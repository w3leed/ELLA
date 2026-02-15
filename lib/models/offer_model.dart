

class OfferModel {
  final String id;
  final String title;
  final String description;
  final double discountPercentage;
  final double minPurchase; 
  final String image; 
  final DateTime createdAt;

  OfferModel({
    required this.id,
    required this.title,
    required this.description,
    required this.discountPercentage,
    required this.minPurchase,
    required this.image,
    required this.createdAt,
  });

  factory OfferModel.fromMap(Map<String, dynamic> map) {
    return OfferModel(
      id: map['id'] ?? '',
      title: map['title'] ?? '',
      description: map['description'] ?? '',
      discountPercentage: (map['discount_percent'] ?? 0).toDouble(),
      minPurchase: (map['min_order_amount'] ?? 0).toDouble(),
      image: map['image_url'] ?? '',
      createdAt: DateTime.parse(map['created_at']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'discount_percent': discountPercentage,
      'min_order_amount': minPurchase,
      'image_url': image,
      'created_at': createdAt.toIso8601String(),
    };
  }

  // التحقق هل الطلب يستحق الخصم أم لا
  bool isEligible(double total) {
    return total >= minPurchase;
  }

  // تطبيق الخصم
  double applyDiscount(double total) {
    if (!isEligible(total)) return total;
    return total - (total * discountPercentage / 100);
  }
}
