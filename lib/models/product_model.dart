// class Product {
//   final String id;
//   final String name;
//   final String? imageUrl;
//   final double price;

//   Product({
//     required this.id,
//     required this.name,
//     this.imageUrl,
//     required this.price,
//   });

//   factory Product.fromJson(Map<String, dynamic> json) {
//     return Product(
//       id: json['id'],
//       name: json['name'],
//       imageUrl: json['image_url'],
//       price: (json['price'] as num).toDouble(),
//     );
//   }
// }
class Product {
  final String id, name, description, imageUrl;
  final double price;

  Product({required this.id, required this.name, required this.description, required this.imageUrl, required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      imageUrl: json['images'], // Mapping your 'images' key
      price: (json['price'] as num).toDouble(),
    );
  }
}

class SubCategory {
  final String id, name, imageUrl;
  final List<Product> products;

  SubCategory({required this.id, required this.name, required this.imageUrl, required this.products});

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      id: json['id'],
      name: json['name'],
      imageUrl: json['image_url'],
      products: (json['products'] as List).map((p) => Product.fromJson(p)).toList(),
    );
  }
}