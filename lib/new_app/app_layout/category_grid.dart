// import 'package:flutter/material.dart';

// /// A complete category grid layout displaying multiple category items

// class CategoryGrid extends StatelessWidget {
//   final List<Category> categories;
//   final int crossAxisCount;
//   final double crossAxisSpacing;
//   final double mainAxisSpacing;
//   final double itemWidth;
//   final double itemHeight;
//   final VoidCallback? onCategoryTap;

//   const CategoryGrid({
//     super.key,
//     required this.categories,
//     this.crossAxisCount = 2,
//     this.crossAxisSpacing = 12.0,
//     this.mainAxisSpacing = 12.0,
//     this.itemWidth = 120.0,
//     this.itemHeight = 120.0,
//     this.onCategoryTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       shrinkWrap: true,
//       physics: const NeverScrollableScrollPhysics(),
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         crossAxisCount: crossAxisCount,
//         crossAxisSpacing: crossAxisSpacing,
//         mainAxisSpacing: mainAxisSpacing,
//         childAspectRatio: itemWidth / itemHeight,
//       ),
//       itemCount: categories.length,
//       itemBuilder: (context, index) {
//         final category = categories[index];
//         return CategoryItem(
//           name: category.name,
//           photoUrl: category.photoUrl,
//           onTap: () {
//             if (onCategoryTap != null) {
//               onCategoryTap!();
//             }
//             print('Category ${category.name} tapped!');
//           },
//         );
//       },
//     );
//   }
// }

// /// Category data model
// class Category {
//   final String name;
//   final String photoUrl;
//   final String? description;

//   const Category({
//     required this.name,
//     required this.photoUrl,
//     this.description,
//   });
// }

// /// Category Item Widget (from previous implementation)
// class CategoryItem extends StatelessWidget {
//   final String name;
//   final String photoUrl;
//   final VoidCallback? onTap;
//   final Color? backgroundColor;
//   final double? width;
//   final double? height;

//   const CategoryItem({
//     super.key,
//     required this.name,
//     required this.photoUrl,
//     this.onTap,
//     this.backgroundColor,
//     this.width = 120,
//     this.height = 120,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         width: width,
//         height: height,
//         decoration: BoxDecoration(
//           color: backgroundColor ?? Colors.white,
//           borderRadius: BorderRadius.circular(16.0),
//           boxShadow: [
//             BoxShadow(
//               color: Colors.black.withOpacity(0.1),
//               blurRadius: 6,
//               offset: const Offset(0, 3),
//             ),
//           ],
//         ),
//         child: SizedBox(
//           width: 100,
//           height: 100,
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               // Photo
//               Expanded(
//                 child: ClipRRect(
//                   borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
//                   child: Image.network(
//                     photoUrl,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         color: Colors.grey[200],
//                         child: const Center(
//                           child: Icon(Icons.category, size: 48, color: Colors.grey),
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
              
//               // Name
//               Container(
//                 padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
//                 decoration: BoxDecoration(
//                   color: backgroundColor ?? Colors.white,
//                   borderRadius: const BorderRadius.vertical(bottom: Radius.circular(16.0)),
//                 ),
//                 child: Text(
//                   name,
//                   style: TextStyle(
//                     color: Colors.black87,
//                     fontSize: 14,
//                     fontWeight: FontWeight.w600,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   textAlign: TextAlign.center,
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Complete example with full screen layout
// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       debugShowCheckedModeBanner: false,
//       theme: ThemeData(
//         primarySwatch: Colors.blue,
//         scaffoldBackgroundColor: const Color(0xFFF5F5F5),
//       ),
//       home: const CategoryGridScreen(),
//     );
//   }
// }

// class CategoryGridScreen extends StatelessWidget {
//   const CategoryGridScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Shop by Category',
//           style: TextStyle(
//             fontSize: 20,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         backgroundColor: Colors.blue[900],
//         elevation: 0,
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Header
//               const Padding(
//                 padding: EdgeInsets.only(bottom: 16.0),
//                 child: Text(
//                   'Popular Categories',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
              
//               // Category Grid - 2 columns
//               CategoryGrid(
//                 categories: categories,
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 12,
//                 mainAxisSpacing: 12,
//                 itemWidth: 150,
//                 itemHeight: 150,
//                 onCategoryTap: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Category selected!'),
//                       backgroundColor: Colors.blue,
//                     ),
//                   );
//                 },
//               ),
              
//               const SizedBox(height: 32),
              
//               // Section 2 Header
//               const Padding(
//                 padding: EdgeInsets.only(bottom: 16.0),
//                 child: Text(
//                   'More Categories',
//                   style: TextStyle(
//                     fontSize: 24,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ),
              
//               // Category Grid - 3 columns
//               CategoryGrid(
//                 categories: moreCategories,
//                 crossAxisCount: 3,
//                 crossAxisSpacing: 10,
//                 mainAxisSpacing: 10,
//                 itemWidth: 120,
//                 itemHeight: 120,
//                 onCategoryTap: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Category selected!'),
//                       backgroundColor: Colors.blue,
//                     ),
//                   );
//                 },
//               ),
              
//               const SizedBox(height: 40),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

// // Sample data - Popular Categories
// // final List<Category> categories = [
// //   Category(
// //     name: 'Electronics',
// //     photoUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
// //     description: 'Latest gadgets and devices',
// //   ),
// //   Category(
// //     name: 'Fashion',
// //     photoUrl: 'https://images.unsplash.com/photo-1483985988355-763728e1935b',
// //     description: 'Trendy clothing and accessories',
// //   ),
// //   Category(
// //     name: 'Home & Kitchen',
// //     photoUrl: 'https://images.unsplash.com/photo-1513506003901-1e0f0137899a',
// //     description: 'Home essentials and kitchenware',
// //   ),
// //   Category(
// //     name: 'Sports',
// //     photoUrl: 'https://images.unsplash.com/photo-1517649763962-0c623066013b',
// //     description: 'Sports equipment and apparel',
// //   ),
// //   Category(
// //     name: 'Beauty',
// //     photoUrl: 'https://images.unsplash.com/photo-1599351431202-1e0f0137899a',
// //     description: 'Beauty products and cosmetics',
// //   ),
// //   Category(
// //     name: 'Books',
// //     photoUrl: 'https://images.unsplash.com/photo-1544947950-fa07a98d237f',
// //     description: 'Books and reading materials',
// //   ),
// // ];

// // // Sample data - More Categories
// // final List<Category> moreCategories = [
// //   Category(
// //     name: 'Toys',
// //     photoUrl: 'https://images.unsplash.com/photo-1511499767150-a48a237f0083',
// //   ),
// //   Category(
// //     name: 'Jewelry',
// //     photoUrl: 'https://images.unsplash.com/photo-1543466835-00a7907e9de1',
// //   ),
// //   Category(
// //     name: 'Furniture',
// //     photoUrl: 'https://images.unsplash.com/photo-1555041469-a586c61ea9bc',
// //   ),
// //   Category(
// //     name: 'Groceries',
// //     photoUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e',
// //   ),
// //   Category(
// //     name: 'Automotive',
// //     photoUrl: 'https://images.unsplash.com/photo-1503376780353-7e6692767b70',
// //   ),
// //   Category(
// //     name: 'Pet Supplies',
// //     photoUrl: 'https://images.unsplash.com/photo-1517849845537-4d257902454a',
// //   ),
// //   Category(
// //     name: 'Garden',
// //     photoUrl: 'https://images.unsplash.com/photo-1588880331179-bc9b93a8cb5e',
// //   ),
// //   Category(
// //     name: 'Office',
// //     photoUrl: 'https://images.unsplash.com/photo-1517245386807-bb43f82c33c4',
// //   ),
// // ];
