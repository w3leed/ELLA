// import 'package:raf/models/product_model.dart';

// class SubCategory {
//   final String id;
//   final String name;
//   final String? imageUrl;
//   final List<Product> products;

//   SubCategory({
//     required this.id,
//     required this.name,
//     this.imageUrl,
//     required this.products,
//   });

//   factory SubCategory.fromJson(Map<String, dynamic> json) {
//     return SubCategory(
//       id: json['id'],
//       name: json['name'],
//       imageUrl: json['image_url'],
//       products: (json['products'] as List)
//           .map((e) => Product.fromJson(e))
//           .toList(),
//     );
//   }
// }
