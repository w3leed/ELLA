// // // Admin Screens Skeleton
// // // Folder: lib/screens/admin/

// // import 'package:flutter/material.dart';

// // // ✅ Admin Dashboard
// // class AdminDashboard extends StatelessWidget {
// //   const AdminDashboard({super.key});
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("لوحة التحكم")),
// //       body: GridView.count(
// //         crossAxisCount: 2,
// //         padding: const EdgeInsets.all(16),
// //         crossAxisSpacing: 12,
// //         mainAxisSpacing: 12,
// //         children: const [
// //           _AdminTile(title: "الأقسام", route: "/addCategory"),
// //           _AdminTile(title: "الأقسام الفرعية", route: "/addSubCategory"),
// //           _AdminTile(title: "إضافة منتج", route: "/addProduct"),
// //           _AdminTile(title: "العروض", route: "/addOffer"),
// //           _AdminTile(title: "الطلبات", route: "/manageOrders"),
// //           _AdminTile(title: "التقارير", route: "/reports"),
// //           _AdminTile(title: "ارسال واتساب", route: "/whatsappSend"),
// //         ],
// //       ),
// //     );
// //   }
// // }

// // class _AdminTile extends StatelessWidget {
// //   final String title;
// //   final String route;
// //   const _AdminTile({required this.title, required this.route});

// //   @override
// //   Widget build(BuildContext context) {
// //     return InkWell(
// //       onTap: () => Navigator.pushNamed(context, route),
// //       child: Container(
// //         decoration: BoxDecoration(
// //             borderRadius: BorderRadius.circular(12), color: Colors.blueGrey),
// //         child: Center(
// //           child: Text(title,
// //               textAlign: TextAlign.center,
// //               style: const TextStyle(color: Colors.white, fontSize: 18)),
// //         ),
// //       ),
// //     );
// //   }
// // }
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:raf/cubit/admin_cubit/admin_cubit.dart';
// import 'package:raf/screen/admin/add_subcategory.dart';
// import 'package:raf/screen/admin/manage_categories.dart';
// import 'package:raf/screen/admin/manage_offers.dart';
// import 'package:raf/screen/admin/manage_products.dart'; 

// class AdminDashboard extends StatelessWidget {
//   const AdminDashboard({super.key});

//   @override
//   Widget build(BuildContext context) {
//     final adminCubit = context.read<AdminCubit>();

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Admin Dashboard"),
//         centerTitle: true,
//         backgroundColor: Colors.black87,
//       ),

//       body: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: GridView(
//           gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//             crossAxisCount: 2,
//             childAspectRatio: 1,
//             crossAxisSpacing: 12,
//             mainAxisSpacing: 12,
//           ),

//           children: [

//             _dashboardButton(
//               icon: Icons.category,
//               title: "Manage Categories",
//             //  onTap: () => Navigator.pushNamed(context, "admin/manage-category"),
//             onTap: () => Navigator.push(context, 
//             MaterialPageRoute(builder: (context) => ManageCategoriesScreen())),

//             ),

//             _dashboardButton(
//               icon: Icons.category_outlined,
//               title: "Manage Subcategories",
//              onTap: () => Navigator.push(context, 
//             MaterialPageRoute(builder: (context) =>
//              ManageSubCategoriesScreen())),

//            ),

//             _dashboardButton(
//               icon: Icons.shopping_bag,
//               title: "Manage Products",
//               onTap: ()=> Navigator.push(context, 
//             MaterialPageRoute(builder: (context) =>
//              ManageProductsScreen())),
//             ),

//             _dashboardButton(
//               icon: Icons.local_offer,
//               title: "Manage Offers",
//               onTap: ()=> Navigator.push(context, 
//             MaterialPageRoute(builder: (context) =>
//              ManageOffersScreen())),
//             ),

//             // _dashboardButton(
//             //   icon: Icons.receipt_long,
//             //   title: "الطلبات",
//             //   onTap: () {
//             //     adminCubit.loadAllOrders();
//             //     Navigator.pushNamed(context, "/admin/orders");
//             //   },
//             // ),

//             // _dashboardButton(
//             //   icon: Icons.bar_chart,
//             //   title: "التقارير",
//             //   onTap: () => Navigator.pushNamed(context, "/admin/reports"),
//             // ),

         

//           ],
//         ),
//       ),
//     );
//   }

//   Widget _dashboardButton({
//     required IconData icon,
//     required String title,
//     required VoidCallback onTap,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Card(
//         elevation: 2,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         child: Container(
//           padding: const EdgeInsets.all(10),
//           decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(12),
//           ),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Icon(icon, size: 40, color: Colors.black87),
//               const SizedBox(height: 10),
//               Text(
//                 title,
//                 style: const TextStyle(
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold
//                 ),
//                 textAlign: TextAlign.center,
//               )
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
