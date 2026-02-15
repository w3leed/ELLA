import 'package:flutter/material.dart';
import 'package:raf/new_app/app_layout/main_layout.dart';
import 'package:raf/new_app/new_admin/man_category.dart';
import 'package:raf/new_app/new_admin/man_offer.dart';
import 'package:raf/new_app/new_admin/man_order.dart';
import 'package:raf/new_app/new_admin/man_special_offer.dart';

class AdminHomeScreen extends StatelessWidget {
  const AdminHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Admin Dashboard"), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
          children: [
            _buildAdminCard(context, "Categories", Icons.category,
                Colors.orange, const ManageStoreScreen()),
            _buildAdminCard(
              context,
              "Special Offers",
              Icons.local_offer,
              Colors.red,
              ManageOfferScreen(),
            ),
            _buildAdminCard(context, "Orders", Icons.delivery_dining,
                Colors.green, ManageOrdersScreen()),
            _buildAdminCard(context, "Special Deals", Icons.discount_outlined,
                Colors.green, ManageSpecialOfferScreen()),
            _buildAdCard(context, "Back", Icons.door_back_door, Colors.green,
                MainLayout()),
          ],
        ),
      ),
    );
  }

  Widget _buildAdminCard(BuildContext context, String title, IconData icon,
      Color color, Widget? screen) {
    return InkWell(
      onTap: () {
        if (screen != null)
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => screen));
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: color),
            const SizedBox(height: 10),
            Text(title,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

Widget _buildAdCard(BuildContext context, String title, IconData icon,
    Color color, Widget? screen) {
  return InkWell(
    onTap: () {
      if (screen != null)
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => screen));
    },
    child: Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 50, color: color),
          const SizedBox(height: 10),
          Text(title,
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        ],
      ),
    ),
  );
}
