// lib/models/category_model.dart

class CategoryModel {
  final String id;
  final String name;
  final String image;
  final DateTime createdAt;

  CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    required this.createdAt,
  });

  // تحويل من Map إلى كائن
  factory CategoryModel.fromMap(Map<String, dynamic> map) {
    return CategoryModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      image: map['image_url'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  // تحويل الكائن إلى Map (عند الحفظ في Supabase)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image_url': image,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
