// import 'package:flutter/material.dart';
// import '../../core/constants.dart';

// class AppBottomNav extends StatelessWidget {
//   final int currentIndex;
//   final ValueChanged<int> onTap;

//   const AppBottomNav({Key? key, required this.currentIndex, required this.onTap}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       currentIndex: currentIndex,
//       onTap: onTap,
//       type: BottomNavigationBarType.fixed,
//       selectedItemColor: AppColors.primary,
//       items: const [
//         BottomNavigationBarItem(icon: Icon(Icons.home), label: 'الرئيسية'),
//         BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'العربة'),
//         BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: 'طلباتي'),
//         BottomNavigationBarItem(icon: Icon(Icons.person), label: 'الملف'),
//       ],
//     );
//   }
// }
import 'package:flutter/material.dart';
import '../../core/constants.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  const BottomNavBar({
    required this.currentIndex,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      selectedItemColor: AppColors.primary,
      unselectedItemColor: Colors.grey,
      type: BottomNavigationBarType.fixed,
      items: const [
        BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
        BottomNavigationBarItem(
            icon: Icon(Icons.category), label: "Categories"),
        BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: "Cart"),
        BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long), label: "Orders"),
        BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
      ],
    );
  }
}
