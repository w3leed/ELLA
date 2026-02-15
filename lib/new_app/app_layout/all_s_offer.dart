import 'package:flutter/material.dart';
import 'package:raf/cubit/app/app_cubit.dart';
import 'package:raf/new_app/app_layout/s_offer.dart';
import 'package:raf/core/components.dart';

class AllOffersScreen extends StatelessWidget {
  const AllOffersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var offers = AppCubit.get(context).specialOffers;
    return Scaffold(
      appBar: AppBar(title: const Text("كل العروض الخاصة")),
      body: offers.isEmpty
          ? const Center(
              child: Text(
                "wait special offer",
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : GridView.builder(
              padding: const EdgeInsets.all(15),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 0.7,
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10),
              itemCount: offers.length,
              itemBuilder: (context, index) =>
                  _buildOfferCard(context, offers[index]),
            ),
    );
  }
}
Widget _buildSpecialOffersSection(BuildContext context, List<dynamic> offers) {
  return Column(
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text("العروض الخاصة 🔥", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => const AllOffersScreen())),
              child: const Text("المزيد"),
            ),
          ],
        ),
      ),
      SizedBox(
        height: 220,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          itemCount: offers.length,
          itemBuilder: (context, index) => _buildOfferCard(context, offers[index]),
        ),
      ),
    ],
  );
}

Widget _buildOfferCard(BuildContext context, dynamic offer) {
  double discountedPrice = offer['price'] - (offer['price'] * offer['dis'] / 100);

  return GestureDetector(
    onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SpecialOfferDetailsScreen(offer: offer))),
    child: Container(
      width: 160,
      margin: const EdgeInsets.symmetric(horizontal: 5),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(15), border: Border.all(color: Colors.grey.shade200)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Stack(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                child: buildNetworkImage(offer['images'], height: 120, width: 160, fit: BoxFit.cover),
              ),
              Positioned(
                top: 5, right: 5,
                child: Container(
                  padding: const EdgeInsets.all(5),
                  color: Colors.red,
                  child: Text("-${offer['dis']}%", style: const TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(offer['name'], maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(offer['description'] ?? "", style: const TextStyle(color: Colors.orange, fontSize: 10)),
                Text("$discountedPrice ج.م", style: const TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}