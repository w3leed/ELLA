

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:raf/core/components.dart';
import 'package:raf/core/constants.dart';
import 'package:raf/core/sql_helper.dart';
import 'package:raf/cubit/app/app_state.dart';
import 'package:raf/new_app/app_layout/sub.dart';
import 'package:raf/new_app/savedata.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:bcrypt/bcrypt.dart';
import 'dart:convert'; // for utf8
import 'package:crypto/crypto.dart';
class AppCubit extends Cubit<AppState> {
  AppCubit() : super(AppInitial());
  
static   AppCubit get(context)=> BlocProvider.of(context);

List offer =[];
  Future<void> getoffer()async{
 
   Supabase.instance.client.from('offers').select('*').then((values){
    offer =values;   
    emit(GetOfferSuccess());
   }).catchError     
   
   ((error){ 
    emit(GetOfferError(error: error.toString()));
   });
  }
  List category =[];
  Future<void> getCategory()async{
     emit(GetCategoryLoading());
   Supabase.instance.client.from('categories').select('*').then((values){
    category =values;   
    emit(GetCategorySuccess());
   }).catchError     
   
   ((error){ 
    emit(GetCategoryError(error: error.toString()));
   });
  }
    List subGategory =[];
  Future<void> getSubGategory(String id)async{
     emit(GetSubCategoryLoading());
   Supabase.instance.client.from('subcategories').select('*').eq('category_id',id).then((values){
    offer =values;   
    emit(GetSubCategorySuccess());
   }).catchError     
   
   ((error){ 
    emit(GetSubCategoryError(error: error.toString()));
   });
  }
    List productWithCategory =[];
  Future<void> getProductWithCategory(String id)async{
     emit(GetProductLoading());
   Supabase.instance.client.from('products').select('*').eq('category_id',id).then((values){
    productWithCategory =values;   
    print(values);
    emit(GetProductSuccess());
   }).catchError     
   
   ((error){ 
    emit(GetProductError(error: error.toString()));
   });
  }
  var data ;
   Future  fetchCategory(int id ,context) async {
     await Supabase.instance.client.rpc(
      'get_category_details',
      params: {
        'p_category_id': id,
      },
    ).then((value){
      print('ddddddddd');
      //print(value);
      data=value; 
      print(data);
       navigateTo(
                                context, 
                               StoreCategoryScreen(data:data,)
                              );
      emit(GetProductSuccess());
    }).catchError((e){
      print(e);
       emit(GetProductError(error: e.toString()));
    });
    
  
}
Future<void> login({required String phone, required String password}) async {
  emit(LoginLoadingState());
  try {
   var enPassword = encryptPassword(password);
    Supabase.instance.client.from('profiles').select(
       
    ).eq( 'phone'
        , phone).then((v){
          print(v);
          print(enPassword);
  if (v.isNotEmpty){
     if (v[0]['password_hash']==enPassword){
      saveData(tUId, v[0]['id']);
      print(v[0]['id']);
  emit(LoginSuccessState());
     }
     else {
       emit(LoginpasswoedErrorState());
     }
  }else{
     emit(LoginphoneErrorState());
  }
       // 'password_hash': enPassword, 
  
        });
    
  } catch (e) {
    emit(LoginErrorState(e.toString()));
  }
}


Future<void> confirmOrder(String userId) async {
  final db = await CartDatabase.instance.database;
  final cartItems = await db.query('cart');

  if (cartItems.isEmpty) return;

  final total = cartItems.fold<double>(
    0,
   (sum, item) {
    final price = double.tryParse(item['price'].toString()) ?? 0.0;
    final quantity = int.tryParse(item['quantity'].toString()) ?? 0;
    return sum + (price * quantity);
  },
  );

  // 1️⃣ insert order
  final order = await Supabase.instance.client
      .from('orders')
      .insert({
        'user_id': userId,
        'total': total,
      })
      .select()
      .single();

  final orderId = order['id'];

  // 2️⃣ insert order items
  final orderItems = cartItems.map((item) {
    return {
      'order_id': orderId,
      'product_id': item['product_id'],
      'price': item['price'],
      'quantity': item['quantity'],
    };
  }).toList();

  await Supabase.instance.client
      .from('order_items')
      .insert(orderItems);

  // 3️⃣ clear cart
  await db.delete('cart');
}

Future<void> addToCart({
  required String productId,
  required String name,
  required double price,
  required String imageUrl,
  required int selectedQuantity, // 👈 أضفنا هذا المتغير
}) async {
  final db = await CartDatabase.instance.database;

  final result = await db.query(
    'cart',
    where: 'product_id = ?',
    whereArgs: [productId],
  );

  if (result.isNotEmpty) {
    // تحديث الكمية: الكمية القديمة + الكمية المختارة من الشاشة
    final currentQty = result.first['quantity'] as int;

    await db.update(
      'cart',
      {'quantity': currentQty + selectedQuantity}, // 👈 نجمع الكمية الجديدة
      where: 'product_id = ?',
      whereArgs: [productId],
    );
  } else {
    // إدخال منتج جديد بالكمية المختارة
    await db.insert('cart', {
      'product_id': productId,
      'name': name,
      'price': price,
      'image_url': imageUrl,
      'quantity': selectedQuantity, // 👈 نستخدم الكمية المختارة
    });
  }
}
List<Map> cartItems = [];
double totalPrice = 0;

Future<void> getCartItems() async {
  emit(GetCartLoadingState());
  final db = await CartDatabase.instance.database;
  final result = await db.query('cart');
  
  cartItems = result;
  calculateTotalPrice();
  
  if (cartItems.isEmpty) {
    emit(CartEmptyState());
  } else {
    emit(GetCartSuccessState());
  }
}


Future<void> removeFromCart(String productId) async {
  final db = await CartDatabase.instance.database;
  await db.delete('cart', where: 'product_id = ?', whereArgs: [productId]);
  getCartItems(); // إعادة جلب البيانات لتحديث الشاشة
}
 
//   String encryptPassword(String password) {
//   return BCrypt.hashpw(password, BCrypt.gensalt());
// } 
String encryptPassword(String password) {
  var bytes = utf8.encode(password); // Convert password to bytes
  var digest = sha256.convert(bytes); // Create SHA-256 hash
  return digest.toString(); // Return as a String to store in DB
}
Future<void> register({
  required String email,
  required String password,
  required String name,
  required String phone,
  required String address,
  required String quesstion,
  required String answer,
}) async {
  emit(RegisterLoadingState());
  var enPassword = encryptPassword(password);
  try {
    //profiles
    print(name);
    Supabase.instance.client.from('profiles').insert(
      {
        'full_name':name,
        'email' : email,
        'phone': phone,
        'address':address,
        'password_hash': enPassword,
        'security_question': quesstion,
        'security_answer_hash': answer,

      }
    ).then((v){
      print('s');
      print(v);
    }).catchError((e){
      print(e);
    });
    emit(RegisterSuccessState());
  } catch (e) {
    print(e);
    emit(RegisterErrorState(e.toString()));
  }

}
double discountAmount = 0;
double finalPrice = 0;
String offerMessage = "";

// دالة لحساب الإجمالي مع فحص العروض
Future<void> calculateTotalPrice() async {
  double total = 0;
   
  for (var item in cartItems) {
    total += (item['price'] * item['quantity']);
     print(item['price']);
  }
  totalPrice = total;
  print(totalPrice);

  // فحص العروض من Supabase
  try {
    final response = await Supabase.instance.client
        .from('offers')
        .select() 
        .limit(1);
        print('sssssssssss');
     print( response);
    if (response[0]['min_amount']< totalPrice) {

      int percent = response[0]['discount_percent'];
      discountAmount = (totalPrice * percent) / 100;
      offerMessage = response[0]['description'];
    } else {
      discountAmount = 0;
      offerMessage = "";
    }
    finalPrice = totalPrice - discountAmount;
    emit(GetCartSuccessState());
  } catch (e) {
    finalPrice = totalPrice;
    emit(GetCartSuccessState());
  }
}

// تحديث دالة إرسال الطلب لتشمل الخصم
// Future<void> placeOrder({required String address, required String phone} ) async {
//   emit(GetCartLoadingState());
//   try {
//    // final userId = supabase.auth.currentUser!.id;
// final userId = Hive.box(tUId).get(tUId);
//   await Supabase.instance.client.from('orders').insert({
//       'user_id':userId,
//       'total_price': totalPrice,
//       'discount_amount': discountAmount,
//       'final_price': finalPrice, 
//        'address': address, 
//        'phone': phone, 
      
//       'status': 0,
//     }).select().single().then((v){
//     print(v);
//     }).catchError((e){
//       print(e.toString());
//     });

//     // ... (بقية كود إضافة order_items ومسح السلة كما في السابق)
//     emit(UpdateStatusSuccessState());
//   } catch (e) {
//     emit(GetOrdersErrorState(e.toString()));
//   }
// }

Future<void> placeOrder({
  required String address,
  required String phone,
}) async {
  emit(PlaceOrderLoadingState());

  try {
    final user = Hive.box(tUId).get(tUId);
    // 1. إدراج الطلب الرئيسي في جدول orders
    await Supabase.instance.client  .from('orders').insert({
      'user_id': user ,
      'total_price': totalPrice,
      'discount_amount': discountAmount,
      'final_price': finalPrice,
      'address': address,
      'phone': phone,
      'status': 0, // الحالة الافتراضية (جديد)
    }).select().single().then((v)async{
      print(v);
      print('oooo');
  final int orderId = v ['id'];
getCartItems();
print(cartItems);
    // 2. تجهيز بيانات المنتجات لجدول order_items
    // نقوم بتحويل قائمة السلة من SQLite إلى قائمة مناسبة لـ Supabase
    List<Map<String, dynamic>> orderItemsToInsert = cartItems.map((item) {
      return {
        'order_id': orderId,
        'product_id': item['product_id'],
        'quantity': item['quantity'],
        'price_at_purchase': item['price'], // السعر وقت الشراء
      };
    }).toList();

    // 3. إدراج جميع المنتجات في جدول order_items بطلب واحد
   await   Supabase.instance.client  .from('order_items').insert(orderItemsToInsert);

    // 4. تفريغ السلة من SQLite بعد نجاح العملية
  await    emptyCart();

    emit(PlaceOrderSuccessState());
    });

  
  } catch (error) {
    print("Error placing order: $error");
    emit(PlaceOrderErrorState());
  }
}

// دالة تفريغ السلة
Future<void> emptyCart() async {
  final db = await CartDatabase.instance.database;
  await db.delete('cart'); // مسح جدول السلة محلياً
  cartItems = [];
  totalPrice = 0;
  finalPrice = 0;
  discountAmount = 0;
  emit(CartEmptyState());
}
List<dynamic> myOrders = [];

// جلب طلبات المستخدم الحالي فقط
Future<void> getMyOrders() async {
  emit(GetOrdersLoadingState());
  try {
    final userId = Hive.box(tUId).get(tUId);
    final data = await  Supabase.instance.client
        .from('orders')
        .select('*, order_items(*, products(*))') // جلب الطلب مع تفاصيله ومنتجاته
        .eq('user_id', userId)
        .order('created_at', ascending: false);

    myOrders = data;
    emit(GetOrdersSuccessState());
  } catch (e) {
    emit(GetOrdersErrorState(e.toString()));
  }
}
 logout(){
  saveData(tUId, null);
  emit(Logout());
 }
// تحديث حالة الطلب إلى 5 (تم الاستلام)
Future<void> updateOrderStatusToReceived(int orderId) async {
  emit(UpdateStatusLoadingState());
  try {
    await  Supabase.instance.client
        .from('orders')
        .update({'status': 2})
        .eq('id', orderId);
    
    // إعادة جلب البيانات لتحديث الشاشة
    getMyOrders();
    emit(UpdateStatusSuccessState());
  } catch (e) {
    emit(GetOrdersErrorState(e.toString()));
  }
}
Map<String, dynamic>? userProfile;

// 1. جلب بيانات البروفايل
Future<void> getUserProfile() async {
  print('cccccc');
  final user = Hive.box(tUId).get(tUId);
  print(user);
  if (user == null) {
    userProfile = null;
    emit(UnauthenticatedState()); // حالة مستخدم غير مسجل
    return;
  }

  emit(ProfileLoadingState());
 
      await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('id', user)
        .single().then((v){
          userProfile=v;
          print(v);
          
    emit(ProfileSuccessState());
        }).catchError(
          (e){
            print(e);
            
    emit(ProfileErrorState(e.toString()));
          }
        );
   
  
}

// 2. تحديث بيانات البروفايل
Future<void> updateProfile({
  required String name,
  required String phone,
  required String address,
}) async {
  emit(ProfileUpdateLoadingState());
  try {
    final userId = Hive.box(tUId).get(tUId);
    await Supabase.instance.client  .from('profiles').update({
      'full_name': name,
      'phone': phone,
      'address': address,
    }).eq('id', userId);

    await getUserProfile(); // تحديث البيانات محلياً بعد التعديل
    emit(ProfileUpdateSuccessState());
  } catch (e) {
    emit(ProfileErrorState(e.toString()));
  }
}
List<dynamic> specialOffers = [];

Future<void> getSpecialOffers() async {
  emit(GetProductsLoadingStateo());
 
   await Supabase.instance.client.from('special_offer').select('*').then((v){
      print(v);
      specialOffers=v;
          emit(GetProductsSuccessStateo());
    }).catchError((e){
      print(e);
      
    emit(GetProductsErrorStateo(e.toString()));
    }); 

   
}
}

