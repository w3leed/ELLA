// import 'package:flutter/material.dart';
// import 'package:raf/new_app/app_layout/subcategory_screen.dart';

// /// Product Detail Screen with full product information and purchase options

// class ProductDetailScreen extends StatefulWidget {
//   final Product product;

//   const ProductDetailScreen({super.key, required this.product});

//   @override
//   State<ProductDetailScreen> createState() => _ProductDetailScreenState();
// }

// class _ProductDetailScreenState extends State<ProductDetailScreen> {
//   int _quantity = 1;
//   List<String> _selectedColors = [];
//   List<String> _selectedSizes = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: CustomScrollView(
//         slivers: [
//           // App Bar with back button
//           SliverAppBar(
//             pinned: true,
//             backgroundColor: Colors.white,
//             elevation: 0,
//             iconTheme: const IconThemeData(color: Colors.black),
//             actions: [
//               IconButton(
//                 icon: const Icon(Icons.favorite_border),
//                 onPressed: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Added to favorites!'),
//                       backgroundColor: Colors.blue,
//                     ),
//                   );
//                 },
//               ),
//               IconButton(
//                 icon: const Icon(Icons.share_outlined),
//                 onPressed: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Share feature not implemented yet'),
//                       backgroundColor: Colors.grey,
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),

//           // Product Image Carousel
//           SliverToBoxAdapter(
//             child: SizedBox(
//               height: MediaQuery.of(context).size.width,
//               child: PageView.builder(
//                 itemCount: 3,
//                 itemBuilder: (context, index) {
//                   return Image.network(
//                     widget.product.imageUrl,
//                     fit: BoxFit.contain,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         color: Colors.grey[200],
//                         child: const Center(
//                           child: Icon(Icons.image_not_supported, size: 48),
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),
//           ),

//           // Product Info
//           SliverToBoxAdapter(
//             child: Container(
//               padding: const EdgeInsets.all(16.0),
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
//                 boxShadow: [
//                   BoxShadow(
//                     color: Colors.black.withOpacity(0.05),
//                     blurRadius: 10,
//                     offset: const Offset(0, -5),
//                   ),
//                 ],
//               ),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Product Name
//                   Text(
//                     widget.product.name,
//                     style: const TextStyle(
//                       fontSize: 22,
//                       fontWeight: FontWeight.bold,
//                     ),
//                     maxLines: 2,
//                     overflow: TextOverflow.ellipsis,
//                   ),
//                   const SizedBox(height: 8),

//                   // Rating
//                   Row(
//                     children: [
//                       const Icon(Icons.star, color: Colors.amber),
//                       const SizedBox(width: 4),
//                       Text(
//                         widget.product.rating.toStringAsFixed(1),
//                         style: const TextStyle(
//                           fontSize: 14,
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),
//                       const SizedBox(width: 8),
//                       const Text(
//                         '(456 reviews)',
//                         style: TextStyle(
//                           fontSize: 12,
//                           color: Colors.grey,
//                         ),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 16),

//                   // Price
//                   Row(
//                     children: [
//                       // Original Price
//                       if (widget.product.discount > 0)
//                         Text(
//                           '₪${widget.product.originalPrice.toStringAsFixed(2)}',
//                           style: const TextStyle(
//                             fontSize: 16,
//                             color: Colors.grey,
//                             decoration: TextDecoration.lineThrough,
//                           ),
//                         ),
                      
//                       if (widget.product.discount > 0)
//                         const SizedBox(width: 8),
                      
//                       // Current Price
//                       Text(
//                         '₪${widget.product.currentPrice.toStringAsFixed(2)}',
//                         style: const TextStyle(
//                           fontSize: 28,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.blue,
//                         ),
//                       ),
                      
//                       const Spacer(),
                      
//                       // Discount Badge
//                       if (widget.product.discount > 0)
//                         Container(
//                           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
//                           decoration: BoxDecoration(
//                             color: Colors.red[600],
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                           child: Text(
//                             '${widget.product.discount}% OFF',
//                             style: const TextStyle(
//                               color: Colors.white,
//                               fontSize: 14,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                         ),
//                     ],
//                   ),
//                   const SizedBox(height: 20),

//                   // Color Selection
//                   _buildColorSelector(),
//                   const SizedBox(height: 20),

//                   // Size Selection
//                   _buildSizeSelector(),
//                   const SizedBox(height: 20),

//                   // Quantity Selector
//                   _buildQuantitySelector(),
//                   const SizedBox(height: 24),

//                   // Add to Cart Button
//                   _buildAddToCartButton(),
//                   const SizedBox(height: 16),

//                   // Buy Now Button
//                   _buildBuyNowButton(),
//                   const SizedBox(height: 24),

//                   // Product Description
//                   _buildProductDescription(),
//                   const SizedBox(height: 24),

//                   // Product Specifications
//                   _buildSpecifications(),
//                   const SizedBox(height: 24),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildColorSelector() {
//     final colors = ['Red', 'Blue', 'Black', 'White', 'Green'];
    
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Color',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Wrap(
//           spacing: 8,
//           runSpacing: 8,
//           children: colors.map((color) {
//             final isSelected = _selectedColors.contains(color);
//             return GestureDetector(
//               onTap: () {
//                 setState(() {
//                   if (isSelected) {
//                     _selectedColors.remove(color);
//                   } else {
//                     _selectedColors = [color];
//                   }
//                 });
//               },
//               child: Container(
//                 padding: const EdgeInsets.all(12),
//                 decoration: BoxDecoration(
//                   color: isSelected ? Colors.blue[100] : Colors.grey[100],
//                   border: Border.all(
//                     color: isSelected ? Colors.blue : Colors.grey[300]!,
//                     width: isSelected ? 2 : 1,
//                   ),
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Text(
//                   color,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                     color: isSelected ? Colors.blue : Colors.black87,
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }

//   Widget _buildSizeSelector() {
//     final sizes = ['S', 'M', 'L', 'XL', 'XXL'];
    
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Size',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 12),
//         Wrap(
//           spacing: 8,
//           runSpacing: 8,
//           children: sizes.map((size) {
//             final isSelected = _selectedSizes.contains(size);
//             return GestureDetector(
//               onTap: () {
//                 setState(() {
//                   if (isSelected) {
//                     _selectedSizes.remove(size);
//                   } else {
//                     _selectedSizes = [size];
//                   }
//                 });
//               },
//               child: Container(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 decoration: BoxDecoration(
//                   color: isSelected ? Colors.blue[100] : Colors.grey[100],
//                   border: Border.all(
//                     color: isSelected ? Colors.blue : Colors.grey[300]!,
//                     width: isSelected ? 2 : 1,
//                   ),
//                   borderRadius: BorderRadius.circular(6),
//                 ),
//                 child: Text(
//                   size,
//                   style: TextStyle(
//                     fontSize: 14,
//                     fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
//                     color: isSelected ? Colors.blue : Colors.black87,
//                   ),
//                 ),
//               ),
//             );
//           }).toList(),
//         ),
//       ],
//     );
//   }

//   Widget _buildQuantitySelector() {
//     return Row(
//       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//       children: [
//         const Text(
//           'Quantity',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Row(
//           children: [
//             GestureDetector(
//               onTap: () {
//                 if (_quantity > 1) {
//                   setState(() {
//                     _quantity--;
//                   });
//                 }
//               },
//               child: Container(
//                 width: 32,
//                 height: 32,
//                 decoration: BoxDecoration(
//                   color: Colors.grey[100],
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: const Icon(Icons.remove, size: 18),
//               ),
//             ),
//             const SizedBox(width: 12),
//             Text(
//               '$_quantity',
//               style: const TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             const SizedBox(width: 12),
//             GestureDetector(
//               onTap: () {
//                 setState(() {
//                   _quantity++;
//                 });
//               },
//               child: Container(
//                 width: 32,
//                 height: 32,
//                 decoration: BoxDecoration(
//                   color: Colors.blue,
//                   borderRadius: BorderRadius.circular(4),
//                 ),
//                 child: const Icon(Icons.add, size: 18, color: Colors.white),
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   Widget _buildAddToCartButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 50,
//       child: ElevatedButton(
//         onPressed: () {
//           ScaffoldMessenger.of(context).showSnackBar(
//             SnackBar(
//               content: Text('Added $_quantity item(s) to cart!'),
//               backgroundColor: Colors.blue,
//             ),
//           );
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.grey[100],
//           foregroundColor: Colors.black87,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.shopping_cart_outlined, size: 20),
//             const SizedBox(width: 8),
//             Text(
//               'Add to Cart',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildBuyNowButton() {
//     return SizedBox(
//       width: double.infinity,
//       height: 50,
//       child: ElevatedButton(
//         onPressed: () {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//               content: Text('Proceeding to checkout...'),
//               backgroundColor: Colors.blue,
//             ),
//           );
//         },
//         style: ElevatedButton.styleFrom(
//           backgroundColor: Colors.blue,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//         child: Row(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             const Icon(Icons.payment, size: 20),
//             const SizedBox(width: 8),
//             const Text(
//               'Buy Now',
//               style: TextStyle(
//                 fontSize: 16,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildProductDescription() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Description',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 8),
//         Text(
//           widget.product.description,
//           style: const TextStyle(
//             fontSize: 14,
           
//             height: 1.5,
//           ),
//         ),
//       ],
//     );
//   }

//   Widget _buildSpecifications() {
//     final specs = {
//       'Brand': 'Premium Audio',
//       'Model': 'Wireless Pro',
//       'Weight': '250g',
//       'Battery Life': '30 hours',
//       'Water Resistance': 'IPX7',
//       'Warranty': '2 years',
//     };

//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Specifications',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         const SizedBox(height: 12),
//         ListView.separated(
//           shrinkWrap: true,
//           physics: const NeverScrollableScrollPhysics(),
//           itemCount: specs.length,
//           separatorBuilder: (context, index) => const Divider(height: 1),
//           itemBuilder: (context, index) {
//             final key = specs.keys.elementAt(index);
//             final value = specs[key];
//             return Row(
//               children: [
//                 SizedBox(
//                   width: 120,
//                   child: Text(
//                     key,
//                     style: const TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.w600,
//                       color: Colors.grey,
//                     ),
//                   ),
//                 ),
//                 const Text(
//                   ': ',
//                   style: TextStyle(
//                     fontSize: 14,
//                     color: Colors.grey,
//                   ),
//                 ),
//                 Text(
//                   value!,
//                   style: const TextStyle(
//                     fontSize: 14,
//                     color: Colors.black87,
//                   ),
//                 ),
//               ],
//             );
//           },
//         ),
//       ],
//     );
//   }
// }

// // Example usage
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
//       ),
//       home: ProductDetailScreen(
//         product: Product(
//           name: 'Premium Wireless Headphones with Noise Cancelling',
//           imageUrl: 'https://images.unsplash.com/photo-1505740420928-5e560c06d30e',
//           originalPrice: 199.99,
//           currentPrice: 149.99,
//           discount: 25.0,
//           rating: 4.8,
//           description: 'Experience premium sound quality with our Wireless Headphones featuring active noise cancelling technology. These headphones deliver crystal-clear audio with deep bass and exceptional clarity. The ergonomic design ensures all-day comfort, while the 30-hour battery life keeps you connected all day long. Perfect for commuting, working, or just relaxing at home.',
//         ),
//       ),
//     );
//   }
//  void showAuthDialog(BuildContext context) {
//   showDialog(
//     context: context,
//     builder: (context) => Directionality(
//       textDirection: TextDirection.rtl,
//       child: AlertDialog(
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
//         content: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             const Icon(Icons.lock_person_outlined, size: 70, color: Colors.blue),
//             const SizedBox(height: 20),
//             const Text(
//               "تسجيل الدخول مطلوب",
//               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             const Text(
//               "يجب عليك تسجيل الدخول لتتمكن من إضافة المنتجات إلى سلة المشتريات الخاصة بك.",
//               textAlign: TextAlign.center,
//               style: TextStyle(color: Colors.grey),
//             ),
//             const SizedBox(height: 30),
            
//             // زر تسجيل الدخول
//             SizedBox(
//               width: double.infinity,
//               height: 45,
//               child: ElevatedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   // Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
//                 },
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.blue[700],
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//                 child: const Text("تسجيل الدخول", style: TextStyle(color: Colors.white)),
//               ),
//             ),
//             const SizedBox(height: 10),
            
//             // زر إنشاء حساب
//             SizedBox(
//               width: double.infinity,
//               height: 45,
//               child: OutlinedButton(
//                 onPressed: () {
//                   Navigator.pop(context);
//                   // Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
//                 },
//                 style: OutlinedButton.styleFrom(
//                   side: BorderSide(color: Colors.blue[700]!),
//                   shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//                 ),
//                 child: Text("إنشاء حساب جديد", style: TextStyle(color: Colors.blue[700])),
//               ),
//             ),
//           ],
//         ),
//       ),
//     ),
//   );
// }
// }
