// // lib/core/app_routes.dart

// import 'package:flutter/material.dart';
// import 'package:raf/screen/auth/forgot_screen.dart';
// import 'package:raf/screen/auth/login_screen.dart';
// import 'package:raf/screen/auth/register_screen.dart';
// import 'package:raf/screen/cart_screen.dart';
// import 'package:raf/screen/home_screen.dart';
// import 'package:raf/screen/orders_screen.dart';
// import 'package:raf/new_app/splash/splash_screen.dart';


// /// 🗺️ أسماء جميع المسارات في التطبيق
// class AppRoutes {
//   static const splash = '/';
//   static const login = '/login';
//   static const register = '/register';
//   static const forgot = '/forgot';

//   static const home = '/home';
//   static const cart = '/cart';
//   static const orders = '/orders';
//   static const profile = '/profile';
//   static const productList = '/product_list';
//   static const productDetail = '/product_detail';

//   // 📦 قسم الأدمن
//   static const adminDashboard = '/admin_dashboard';
//   static const addCategory = '/add_category';
//   static const addSubcategory = '/add_subcategory';
//   static const addProduct = '/add_product';
//   static const addOffer = '/add_offer';
//   static const manageOrders = '/manage_orders';
//   static const reports = '/reports';
//   static const whatsappSend = '/whatsapp_send';
// }

// /// 🧭 دالة لتوليد الصفحات بناءً على اسم المسار
// Route<dynamic>? onGenerateRoute(RouteSettings settings) {
//   switch (settings.name) {
//     case AppRoutes.splash:
//       return MaterialPageRoute(builder: (_) => const SplashScreen());
//     case AppRoutes.login:
//       return MaterialPageRoute(builder: (_) =>   LoginScreen());
//     case AppRoutes.register:
//       return MaterialPageRoute(builder: (_) => const RegisterScreen());
//     case AppRoutes.forgot:
//       return MaterialPageRoute(builder: (_) =>   ForgotScreen());

//     case AppRoutes.home:
//       return MaterialPageRoute(builder: (_) => const HomeScreen());
//     case AppRoutes.cart:
//       return MaterialPageRoute(builder: (_) => const CartScreen());
//     case AppRoutes.orders:
//       return MaterialPageRoute(builder: (_) => const OrdersScreen());
//     // case AppRoutes.profile:
//     //   return MaterialPageRoute(builder: (_) => const ProfileScreen());
//     // case AppRoutes.productList:
//     //   return MaterialPageRoute(builder: (_) => const ProductListScreen());
//     // case AppRoutes.productDetail:
//     //   return MaterialPageRoute(builder: (_) => const ProductDetailScreen(product: null,));

//     // ⚙️ الأدمن
//     // case AppRoutes.adminDashboard:
//     //   return MaterialPageRoute(builder: (_) => const AdminDashboardScreen());
//     // case AppRoutes.addCategory:
//     //   return MaterialPageRoute(builder: (_) => const AddCategoryScreen());
//     // case AppRoutes.addSubcategory:
//     //   return MaterialPageRoute(builder: (_) => const AddSubcategoryScreen());
//     // case AppRoutes.addProduct:
//     //   return MaterialPageRoute(builder: (_) => const AddProductScreen());
//     // case AppRoutes.addOffer:
//     //   return MaterialPageRoute(builder: (_) => const AddOfferScreen());
//     // case AppRoutes.manageOrders:
//     //   return MaterialPageRoute(builder: (_) => const ManageOrdersScreen());
//     // case AppRoutes.reports:
//     //   return MaterialPageRoute(builder: (_) => const ReportsScreen());
//     // case AppRoutes.whatsappSend:
//     //   return MaterialPageRoute(builder: (_) => const WhatsAppSendScreen());

//     default:
//       return MaterialPageRoute(
//         builder: (_) => Scaffold(
//           body: Center(
//             child: Text('الصفحة غير موجودة: ${settings.name}'),
//           ),
//         ),
//       );
//   }
// }


// // onGenerateRoute: onGenerateRoute,
// // initialRoute: AppRoutes.splash,
