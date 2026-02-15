// // lib/models/order_model.dart

// class OrderItem {
//   final String productId;
//   final String name;
//   final double price;
//   final int quantity;
//   final String imageUrl;

//   OrderItem({
//     required this.productId,
//     required this.name,
//     required this.price,
//     required this.quantity,
//     required this.imageUrl,
//   });

//   factory OrderItem.fromMap(Map<String, dynamic> map) {
//     return OrderItem(
//       productId: map['product_id'] ?? '',
//       name: map['name'] ?? '',
//       price: (map['price'] ?? 0).toDouble(),
//       quantity: map['quantity'] ?? 1,
//       imageUrl: map['image_url'] ?? '',
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'product_id': productId,
//       'name': name,
//       'price': price,
//       'quantity': quantity,
//       'image_url': imageUrl,
//     };
//   }
// }

// class OrderModel {
//   final String id;
//   final String userId; // من جدول profiles
//   final List<OrderItem> items;
//   final double totalAmount;
//   final double discountAmount;
//   final double finalAmount;
//   final String status; // تم الإرسال - المراجعة - تم التسليم
//   final DateTime createdAt;

//   OrderModel({
//     required this.id,
//     required this.userId,
//     required this.items,
//     required this.totalAmount,
//     required this.discountAmount,
//     required this.finalAmount,
//     required this.status,
//     required this.createdAt,
//   });

//   factory OrderModel.fromMap(Map<String, dynamic> map) {
//     return OrderModel(
//       id: map['id'] ?? '',
//       userId: map['user_id'] ?? '',
//       items: (map['items'] as List<dynamic>? ?? [])
//           .map((e) => OrderItem.fromMap(Map<String, dynamic>.from(e)))
//           .toList(),
//       totalAmount: (map['total_amount'] ?? 0).toDouble(),
//       discountAmount: (map['discount_amount'] ?? 0).toDouble(),
//       finalAmount: (map['final_amount'] ?? 0).toDouble(),
//       status: map['status'] ?? 'تم الإرسال',
//       createdAt: DateTime.parse(map['created_at']),
//     );
//   }

//   Map<String, dynamic> toMap() {
//     return {
//       'id': id,
//       'user_id': userId,
//       'items': items.map((e) => e.toMap()).toList(),
//       'total_amount': totalAmount,
//       'discount_amount': discountAmount,
//       'final_amount': finalAmount,
//       'status': status,
//       'created_at': createdAt.toIso8601String(),
//     };
//   }

//   // تحديث الحالة (لأدمن)
//   OrderModel copyWithStatus(String newStatus) {
//     return OrderModel(
//       id: id,
//       userId: userId,
//       items: items,
//       totalAmount: totalAmount,
//       discountAmount: discountAmount,
//       finalAmount: finalAmount,
//       status: newStatus,
//       createdAt: createdAt,
//     );
//   }
// }
class OrderItemModel {
  final int productId;
  final String productName;
  final String? productImage;
  final double price;
  final int quantity;
  final double discount;
  final double total; // (price - discount) * quantity

  OrderItemModel({
    required this.productId,
    required this.productName,
    this.productImage,
    required this.price,
    required this.quantity,
    required this.discount,
    required this.total,
  });

  Map<String, dynamic> toMap() {
    return {
      'product_id': productId,
      'product_name': productName,
      'product_image': productImage,
      'price': price,
      'quantity': quantity,
      'discount': discount,
      'total': total,
    };
  }

  factory OrderItemModel.fromMap(Map<String, dynamic> map) {
    return OrderItemModel(
      productId: map['product_id'],
      productName: map['product_name'],
      productImage: map['product_image'],
      price: (map['price'] as num).toDouble(),
      quantity: map['quantity'],
      discount: (map['discount'] as num).toDouble(),
      total: (map['total'] as num).toDouble(),
    );
  }
}
class OrderModel {
  final int id;
  final int userId;
  final List<OrderItemModel> items;
  final double subtotal;
  final double discountTotal;
  final double deliveryFee;
  final double finalTotal;
  final String address;
  final String status; // pending, processing, shipped, delivered, cancelled
  final DateTime createdAt;

  OrderModel({
    required this.id,
    required this.userId,
    required this.items,
    required this.subtotal,
    required this.discountTotal,
    required this.deliveryFee,
    required this.finalTotal,
    required this.address,
    required this.status,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'user_id': userId,
      'items': items.map((e) => e.toMap()).toList(),
      'subtotal': subtotal,
      'discount_total': discountTotal,
      'delivery_fee': deliveryFee,
      'final_total': finalTotal,
      'address': address,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }

  factory OrderModel.fromMap(Map<String, dynamic> map) {
    return OrderModel(
      id: map['id'],
      userId: map['user_id'],
      items: (map['items'] as List)
          .map((e) => OrderItemModel.fromMap(e))
          .toList(),
      subtotal: (map['subtotal'] as num).toDouble(),
      discountTotal: (map['discount_total'] as num).toDouble(),
      deliveryFee: (map['delivery_fee'] as num).toDouble(),
      finalTotal: (map['final_total'] as num).toDouble(),
      address: map['address'],
      status: map['status'],
      createdAt: DateTime.parse(map['created_at']),
    );
  }
}
