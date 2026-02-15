// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class ManageOrdersScreen extends StatefulWidget {
//   const ManageOrdersScreen({super.key});

//   @override
//   State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
// }

// class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
//   final supabase = Supabase.instance.client;

//   @override
//   Widget build(BuildContext context) {
//     return DefaultTabController(
//       length: 3,
//       child: Scaffold(
//         appBar: AppBar(
//           title: const Text("إدارة الطلبات"),
//           bottom: const TabBar(
//             tabs: [
//               // نستخدم الأرقام (0, 1, 2) كما في السكيما الجديدة
//               Tab(text: "الجديدة", icon: Icon(Icons.new_releases)),
//               Tab(text: "قيد التنفيذ", icon: Icon(Icons.delivery_dining)),
//               Tab(text: "المنتهية", icon: Icon(Icons.check_circle)),
//             ],
//           ),
//         ),
//         body: TabBarView(
//           children: [
//             _buildOrderList(0), // الجديد
//             _buildOrderList(1), // قيد التنفيذ
//             _buildOrderList(2), // تم التوصيل (أو منتهي)
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildOrderList(int status) {
//     return StreamBuilder(
//       stream: supabase
//           .from('orders')
//           .stream(primaryKey: ['id'])
//           .eq('status', status)
//           .order('created_at', ascending: false),
//       builder: (context, snapshot) {
//         if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
//         final orders = snapshot.data!;

//         if (orders.isEmpty) {
//           return const Center(child: Text("لا توجد طلبات هنا"));
//         }

//         return ListView.builder(
//           itemCount: orders.length,
//           itemBuilder: (context, index) {
//             final order = orders[index];
//             return Card(
//               margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//               child: ListTile(
//                 title: Text("طلب #${order['id']}"),
//                 subtitle: Text(
//                     "المبلغ النهائي: ${order['final_price']} ج.م\nالهاتف: ${order['phone']}"),
//                 trailing: const Icon(Icons.arrow_forward_ios, size: 14),
//                 onTap: () => _showOrderDetails(order),
//               ),
//             );
//           },
//         );
//       },
//     );
//   }

//   // void _showOrderDetails(dynamic order) async {
//   //   // جلب المنتجات مع محاولة الربط بجدول المنتجات وجدول العروض الخاصة معاً
//   //   // ملاحظة: يجب أن تكون قد ألغيت Foreign Key Constraint يدوياً في DB إذا كان الـ ID لا ينتمي لـ Products
//   //   final response = await supabase
//   //       .from('order_items')
//   //       .select('''
//   //         *,
//   //         products(name),
//   //         special_offers(name)
//   //       ''')
//   //       .eq('order_id', order['id']);

//   //   final items = response as List<dynamic>;

//   //   if (!mounted) return;

//   //   showModalBottomSheet(
//   //     context: context,
//   //     isScrollControlled: true,
//   //     shape: const RoundedRectangleBorder(
//   //         borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//   //     builder: (context) {
//   //       return Container(
//   //         padding: const EdgeInsets.all(20),
//   //         height: MediaQuery.of(context).size.height * 0.85,
//   //         child: Column(
//   //           crossAxisAlignment: CrossAxisAlignment.start,
//   //           children: [
//   //             Center(
//   //               child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
//   //             ),
//   //             const SizedBox(height: 20),
//   //             Text("طلب رقم #${order['id']}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//   //             const Divider(),
//   //             _infoRow(Icons.location_on, "العنوان: ${order['address']}"),
//   //             _infoRow(Icons.phone, "الهاتف: ${order['phone']}"),
//   //             _infoRow(Icons.money, "الخصم: ${order['discount_amount']} ج.م"),
//   //             _infoRow(Icons.payments, "الإجمالي النهائي: ${order['final_price']} ج.م", isBold: true),
//   //             const SizedBox(height: 15),
//   //             const Text("الأصناف المطلوبة:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
//   //             const SizedBox(height: 10),
//   //             Expanded(
//   //               child: ListView.builder(
//   //                 itemCount: items.length,
//   //                 itemBuilder: (context, i) {
//   //                   final item = items[i];
//   //                   // تحديد الاسم: إذا لم يوجد في Products نبحث عنه في Special Offers
//   //                   String productName = item['products']?['name'] ??
//   //                                      item['special_offers']?['name'] ??
//   //                                      "منتج (غير متوفر حالياً)";

//   //                   return Container(
//   //                     margin: const EdgeInsets.only(bottom: 10),
//   //                     padding: const EdgeInsets.all(10),
//   //                     decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
//   //                     child: Row(
//   //                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                       children: [
//   //                         Expanded(child: Text(productName, style: const TextStyle(fontWeight: FontWeight.w600))),
//   //                         Text("×${item['quantity']}", style: const TextStyle(color: Colors.blue)),
//   //                         const SizedBox(width: 15),
//   //                         Text("${item['price_at_purchase']} ج.م"),
//   //                       ],
//   //                     ),
//   //                   );
//   //                 },
//   //               ),
//   //             ),
//   //             const Divider(),
//   //             const Text("تحديث الحالة:"),
//   //             const SizedBox(height: 10),
//   //             Row(
//   //               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//   //               children: [
//   //                 _statusButton(order['id'], 1, Colors.orange, "تحضير"),
//   //                 _statusButton(order['id'], 2, Colors.green, "تم التوصيل"),
//   //                 _statusButton(order['id'], 3, Colors.red, "إلغاء"),
//   //               ],
//   //             ),
//   //           ],
//   //         ),
//   //       );
//   //     },
//   //   );
//   // }
//   void _showOrderDetails(dynamic order) async {
//    try {
//     // 1. جلب الأصناف من جدول order_items فقط
//     final List<dynamic> items = await supabase
//         .from('order_items')
//         .select('*')
//         .eq('order_id', order['id']);

//     // 2. جلب قائمة بجميع الـ IDs الموجودة في الطلب
//     List<int> productIds = items.map((item) => item['product_id'] as int).toList();

//     // 3. جلب الأسماء من جدول المنتجات
//     final productsData = await supabase
//         .from('products')
//         .select('id, name')
//         .inFilter('id', productIds);

//     // 4. جلب الأسماء من جدول العروض الخاصة
//     final offersData = await supabase
//         .from('special_offer')
//         .select('id, name')
//         .inFilter
//         ('id', productIds);

//     // 5. دمج البيانات يدوياً في قائمة واحدة للعرض
//     List<Map<String, dynamic>> displayItems = items.map((item) {
//       // البحث عن الاسم في قائمة المنتجات
//       var product = productsData.firstWhere(
//         (p) => p['id'] == item['product_id'],
//         orElse: () => {},
//       );

//       // إذا لم يجد في المنتجات، يبحث في العروض
//       var offer = offersData.firstWhere(
//         (o) => o['id'] == item['product_id'],
//         orElse: () => {},
//       );

//       return {
//         'name': product['name'] ?? offer['name'] ?? "منتج غير معروف",
//         'quantity': item['quantity'],
//         'price': item['price_at_purchase'],
//       };
//     }).toList();

//     if (!mounted) return;

//       // ... باقي كود الـ showModalBottomSheet كما هو دون تغيير ...
//        showModalBottomSheet(
//       context: context,
//       isScrollControlled: true,
//       shape: const RoundedRectangleBorder(
//           borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
//       builder: (context) {
//         return Container(
//           padding: const EdgeInsets.all(20),
//           height: MediaQuery.of(context).size.height * 0.85,
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Center(
//                 child: Container(width: 50, height: 5, decoration: BoxDecoration(color: Colors.grey[300], borderRadius: BorderRadius.circular(10))),
//               ),
//               const SizedBox(height: 20),
//               Text("طلب رقم #${order['id']}", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
//               const Divider(),
//               _infoRow(Icons.location_on, "العنوان: ${order['address']}"),
//               _infoRow(Icons.phone, "الهاتف: ${order['phone']}"),
//               _infoRow(Icons.money, "الخصم: ${order['discount_amount']} ج.م"),
//               _infoRow(Icons.payments, "الإجمالي النهائي: ${order['final_price']} ج.م", isBold: true),
//               const SizedBox(height: 15),
//               const Text("الأصناف المطلوبة:", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue)),
//               const SizedBox(height: 10),
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: items.length,
//                   itemBuilder: (context, i) {
//                     final item = items[i];
//                     // تحديد الاسم: إذا لم يوجد في Products نبحث عنه في Special Offers
//                     String productName = item['products']?['name'] ??
//                                        item['special_offers']?['name'] ??
//                                        "منتج (غير متوفر حالياً)";

//                     return Container(
//                       margin: const EdgeInsets.only(bottom: 10),
//                       padding: const EdgeInsets.all(10),
//                       decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(10)),
//                       child: Row(
//                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         children: [
//                           Expanded(child: Text(productName, style: const TextStyle(fontWeight: FontWeight.w600))),
//                           Text("×${item['quantity']}", style: const TextStyle(color: Colors.blue)),
//                           const SizedBox(width: 15),
//                           Text("${item['price_at_purchase']} ج.م"),
//                         ],
//                       ),
//                     );
//                   },
//                 ),
//               ),
//               const Divider(),
//               const Text("تحديث الحالة:"),
//               const SizedBox(height: 10),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                 children: [
//                   _statusButton(order['id'], 1, Colors.orange, "تحضير"),
//                   _statusButton(order['id'], 2, Colors.green, "تم التوصيل"),
//                   _statusButton(order['id'], 3, Colors.red, "إلغاء"),
//                 ],
//               ),
//             ],
//           ),
//         );
//       },
//     );
//     } catch (e) {
//       print("Error fetching details: $e");
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text("خطأ في جلب التفاصيل: $e"))
//       );
//     }
//   }

//   Widget _infoRow(IconData icon, String text, {bool isBold = false}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 4),
//       child: Row(
//         children: [
//           Icon(icon, size: 18, color: Colors.grey[600]),
//           const SizedBox(width: 8),
//           Expanded(child: Text(text, style: TextStyle(fontWeight: isBold ? FontWeight.bold : FontWeight.normal, fontSize: 15))),
//         ],
//       ),
//     );
//   }

//   Widget _statusButton(int orderId, int newStatus, Color color, String label) {
//     return ElevatedButton(
//       style: ElevatedButton.styleFrom(backgroundColor: color, foregroundColor: Colors.white),
//       onPressed: () async {
//         await supabase.from('orders').update({'status': newStatus}).eq('id', orderId);
//         if (!mounted) return;
//         Navigator.pop(context);
//         ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("تم تحويل الطلب إلى: $label")));
//       },
//       child: Text(label),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ManageOrdersScreen extends StatefulWidget {
  const ManageOrdersScreen({super.key});

  @override
  State<ManageOrdersScreen> createState() => _ManageOrdersScreenState();
}

class _ManageOrdersScreenState extends State<ManageOrdersScreen> {
  final supabase = Supabase.instance.client;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 4, // Increased to 4 to include cancelled or more states
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Order Management"),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "New", icon: Icon(Icons.new_releases)),
              Tab(text: "In Progress", icon: Icon(Icons.delivery_dining)),
              Tab(text: "Delivered", icon: Icon(Icons.check_circle)),
              Tab(text: "Cancelled", icon: Icon(Icons.cancel)),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildOrderList(0), // New
            _buildOrderList(1), // In Progress
            _buildOrderList(2), // Delivered
            _buildOrderList(3), // Cancelled
          ],
        ),
      ),
    );
  }

  Widget _buildOrderList(int status) {
    return StreamBuilder(
      stream: supabase
          .from('orders')
          .stream(primaryKey: ['id'])
          .eq('status', status)
          .order('created_at', ascending: false),
      builder: (context, snapshot) {
        if (!snapshot.hasData)
          return const Center(child: CircularProgressIndicator());
        final orders = snapshot.data!;

        if (orders.isEmpty) {
          return const Center(child: Text("No orders in this section"));
        }

        return ListView.builder(
          itemCount: orders.length,
          itemBuilder: (context, index) {
            final order = orders[index];
            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              child: ListTile(
                title: Text("Order #${order['id']}"),
                subtitle: Text(
                    "Amount: ${order['final_price']} EGP\nPhone: ${order['phone']}"),
                trailing: const Icon(Icons.arrow_forward_ios, size: 14),
                onTap: () => _showOrderDetails(order),
              ),
            );
          },
        );
      },
    );
  }

  void _showOrderDetails(dynamic order) async {
    try {
      // 1. Fetch items
      final List<dynamic> rawItems = await supabase
          .from('order_items')
          .select('*')
          .eq('order_id', order['id']);

      List<int> productIds =
          rawItems.map((item) => item['product_id'] as int).toList();

      // 2. Fetch names from both tables
      final productsData = await supabase
          .from('products')
          .select('id, name')
          .inFilter('id', productIds);
      final offersData = await supabase
          .from('special_offer')
          .select('id, name')
          .inFilter('id', productIds);

      // 3. Merge data
      List<Map<String, dynamic>> displayItems = rawItems.map((item) {
        final product = productsData
            .firstWhere((p) => p['id'] == item['product_id'], orElse: () => {});
        final offer = offersData
            .firstWhere((o) => o['id'] == item['product_id'], orElse: () => {});
        return {
          'name': product['name'] ?? offer['name'] ?? "Unknown Product",
          'quantity': item['quantity'],
          'price': item['price_at_purchase'],
        };
      }).toList();

      if (!mounted) return;

      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
        builder: (context) {
          return Container(
            padding: const EdgeInsets.all(20),
            height: MediaQuery.of(context).size.height * 0.85,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                    child: Container(
                        width: 50, height: 5, color: Colors.grey[300])),
                const SizedBox(height: 20),
                Text("Order Details #${order['id']}",
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.bold)),
                const Divider(),
                _infoRow(Icons.location_on, "Address: ${order['address']}"),
                _infoRow(Icons.phone, "Phone: ${order['phone']}"),
                _infoRow(Icons.payments, "Total: ${order['final_price']} EGP",
                    isBold: true),
                const SizedBox(height: 15),
                const Text("Items:",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.blue)),
                Expanded(
                  child: ListView.builder(
                    itemCount: displayItems.length,
                    itemBuilder: (context, i) {
                      final item = displayItems[i];
                      return ListTile(
                        title: Text(item['name']),
                        trailing: Text("×${item['quantity']}"),
                        subtitle: Text("${item['price']} EGP"),
                      );
                    },
                  ),
                ),
                const Divider(),
                const Text("Update Status:"),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _statusButton(order['id'], 1, Colors.orange, "Preparing"),
                      const SizedBox(width: 8),
                      _statusButton(order['id'], 2, Colors.green, "Delivered"),
                      const SizedBox(width: 8),
                      _statusButton(order['id'], 3, Colors.red, "Cancel"),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    } catch (e) {
      debugPrint("Error: $e");
    }
  }

  Widget _infoRow(IconData icon, String text, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.grey),
          const SizedBox(width: 8),
          Text(text,
              style: TextStyle(
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }

  Widget _statusButton(int orderId, int newStatus, Color color, String label) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
          backgroundColor: color, foregroundColor: Colors.white),
      onPressed: () async {
        await supabase
            .from('orders')
            .update({'status': newStatus}).eq('id', orderId);
        if (!mounted) return;
        Navigator.pop(context);
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text("Order updated to: $label")));
      },
      child: Text(label),
    );
  }
}
