import 'package:flutter/material.dart';
import 'package:raf/core/constants.dart';
import 'package:raf/cubit/app/app_cubit.dart';
import 'package:raf/new_app/app_layout/app_layout.dart';
import 'package:raf/new_app/app_layout/observe_order.dart';
import 'package:raf/new_app/app_layout/profile_screen.dart';
import 'package:raf/new_app/cart.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    List<Widget> screen = [
      RafLayout(),
      CartScreen(),
      MyOrdersScreen(),
      ProfileScreen(),
    ];

    return Scaffold(
      body: screen[currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (value) {
          setState(() {
            currentIndex = value;
          });
          if (value == 1) {
            AppCubit.get(context).calculateTotalPrice();
          }
          if (value == 2) {
            AppCubit.get(context).getMyOrders();
          }
        },
        backgroundColor: Colors.white,
        indicatorColor: AppColors.secondary.withOpacity(0.5),
        destinations: [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.shopping_cart_outlined),
            selectedIcon: Icon(Icons.shopping_cart),
            label: 'Cart',
          ),
          NavigationDestination(
            icon: Icon(Icons.delivery_dining_outlined),
            selectedIcon: Icon(Icons.delivery_dining),
            label: 'Orders',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
