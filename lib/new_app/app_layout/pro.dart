import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:raf/core/components.dart';
import 'package:raf/core/constants.dart';
import 'package:raf/cubit/app/app_cubit.dart';
import 'package:raf/cubit/app/app_state.dart';
import 'package:raf/new_app/app_layout/subcategory_screen.dart';
import 'package:raf/new_app/cart.dart';
import 'package:raf/screen/auth/login_screen.dart';
import 'package:raf/screen/auth/register_screen.dart';

class ProductDetailsScreen extends StatefulWidget {
  final dynamic product; // نمرر بيانات المنتج هنا

  const ProductDetailsScreen({super.key, required this.product});

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    return  BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        // TODO: implement listener
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return SafeArea(
          child: Scaffold(
            floatingActionButtonLocation: FloatingActionButtonLocation.endTop,
             floatingActionButton: IconButton(onPressed: (){
            navigateTo(context, CartScreen());
          }, icon: Icon(Icons.shopping_cart)),
            backgroundColor: Colors.white,
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      // 1. صورة المنتج مع زر الرجوع
                      SliverAppBar(
                        expandedHeight: 350,
                        backgroundColor: Colors.white,
                        elevation: 0,
                        leading: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.9),
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          background: Hero(
                            tag: widget
                                .product['id'], // لعمل انتقال سلس (Hero Animation)
                            child: Image.network(
                              widget.product['images'],
                              fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) {
                      return Container(
                        color: Colors.grey[200],
                        child: Center(
                          child: Image.asset('assets/images/logo.png'),
                        ),
                      );
                    },
                            ),
                          ),
                        ),
                      ),
          
                      // 2. تفاصيل المنتج
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // الاسم والسعر
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.product['name'],
                                      style: const TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    "${widget.product['price']} ج.م",
                                    style: const TextStyle(
                                      fontSize: 22,
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 10),
          
                              // حالة التوفر أو ملاحظة (مثل "جاري تفعيل حسابك")
                              const Text(
                                "جاري تفعيل حسابك",
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontSize: 14,
                                ),
                              ),
          
                              const Divider(height: 40),
          
                              // الوصف
                              const Text(
                                "عن المنتج",
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                widget.product['description'] ??
                                    "لا يوجد وصف متاح لهذا المنتج حالياً.",
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                  height: 1.5,
                                ),
                              ),
          
                              const SizedBox(
                                height: 120,
                              ), // مساحة إضافية عشان السكرول ميتغطاش بالشريط السفلي
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
         
                  // 3. الشريط السفلي المثبت (Add to Cart Bar)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: _buildBottomActionSide(cubit,widget.product),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // ويدجت شريط التحكم السفلي
  Widget _buildBottomActionSide(var cubit , var pro) {
     print(  widget.product);
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child:pro['qou'] != null && pro ['qou'] <= 0 ? Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(    "لا يوجد المنتج حالياً.",
                                    style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.red[500],
                                      height: 1.5,
                                    ),),
        ],
      ) : Row(
        children: [
          // عداد الكمية
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(15),
            ),
            child: Row(
              children: [
                _quantityButton(Icons.add, () {
                    if (quantity  ==pro['limt']|| quantity ==pro ['qou'] ){
                    showToast(txt: 'قد وصلت الحد الاقصى من المنتج', state: ToastState.worning);
                   }
                   else { setState(() => quantity++);}
                  

                }),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text(
                    "$quantity",
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _quantityButton(Icons.remove, () {
                  if (quantity > 1) setState(() => quantity--);
                }),
              ],
            ),
          ),
          const SizedBox(width: 20),
          // داخل _buildBottomActionSide في ملف ProductDetailsScreen
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                // 1. استدعاء دالة الإضافة
              if(Hive.box(tUId).get(tUId)==null){
showAuthDialog (context);

              }else {
                  await cubit.addToCart(
                  productId: widget.product['id'].toString(),
                  name: widget.product['name'],
                  price: double.parse(widget.product['price'].toString()),
                  imageUrl: widget.product['images'],
                  selectedQuantity:
                      quantity, // نمرر الـ quantity الموجود في الـ State
                );

                // 2. إظهار رسالة تأكيد للمستخدم
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        "تم إضافة $quantity من ${widget.product['name']} إلى السلة",
                      ),
                      backgroundColor: Colors.green,
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                }
              }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: const Text(
                "إضافة إلى السلة",
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
void showAuthDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_person_outlined, size: 70, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              "تسجيل الدخول مطلوب",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "يجب عليك تسجيل الدخول لتتمكن من إضافة المنتجات إلى سلة المشتريات الخاصة بك.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            
            // زر تسجيل الدخول
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {

                navigateAndFinish(context, LoginScreen());                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("تسجيل الدخول", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 10),
            
            // زر إنشاء حساب
            SizedBox(
              width: double.infinity,
              height: 45,
              child: OutlinedButton(
                onPressed: () {
                navigateAndFinish(context, RegisterScreen());
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.blue[700]!),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("إنشاء حساب جديد", style: TextStyle(color: Colors.blue[700])),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
  Widget _quantityButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: Colors.blue[700]),
      ),
    );
  }
}
