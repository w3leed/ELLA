import 'package:flutter/material.dart';
import '../models/offer_model.dart';

class OfferCarousel extends StatelessWidget {
  final List<OfferModel> offers;
  const OfferCarousel({super.key, required this.offers});

  @override
  Widget build(BuildContext context) {
    if (offers.isEmpty) {
      return SizedBox(height: 150, child: Center(child: Text('لا توجد عروض حالياً')));
    }
    return SizedBox(
      height: 160,
      child: PageView.builder(
        itemCount: offers.length,
        itemBuilder: (context, i) {
          final o = offers[i];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  o.image.isNotEmpty ? Image.network(o.image, fit: BoxFit.cover) : Container(color: Colors.grey[300]),
                  Positioned(
                    left: 12,
                    bottom: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      color: Colors.black54,
                      child: Text('${o.title} - خصم ${o.discountPercentage}%', style: const TextStyle(color: Colors.white)),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
