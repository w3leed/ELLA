// lib/core/constants.dart

import 'package:flutter/material.dart';

/// 🎨 ألوان التطبيق الرسمية
class AppColors {
  static const primary = Color(0xFF060035); // Deep Blue - Premium & Trustworthy
  static const secondary = Color(0xFFFFD700); // Gold - Luxury & Accent
  static const accent = Color(0xFF00BFA5); // Teal - Freshness & Call to Action
  static const background = Color(0xFFFAFAFA); // Off-white - Clean & Modern
  static const cardBackground = Color(0xFFFFFFFF); // White - Card Background
  static const textDark = Color(0xFF212121); // Almost Black - Readable Text
  static const textLight = Color(0xFF757575); // Grey - Secondary Text
  static const error = Color(0xFFB00020); // Standard Error Red
}

/// 🔠 النصوص العامة المستخدمة في أنحاء التطبيق
class AppStrings {
  static const appName = 'ELLA';
  static const slogan = 'The best place to buy your needs easily';
  static const noData = 'No data available at the moment';
  static const comingSoon = 'Products will be added soon 😊';
  static const offersTitle = 'Special Offers';
  static const categoriesTitle = 'Categories';
  static const productsTitle = 'Products';
  static const ordersTitle = 'My Orders';
  static const cartTitle = 'Shopping Cart';
  static const adminTitle = 'Admin Dashboard';
}

/// 🖼️ روابط صور افتراضية (في حالة عدم وجود صورة في قاعدة البيانات)
class AppImages {
  static const defaultProduct =
      'https://via.placeholder.com/300x300.png?text=No+Image';
  static const defaultCategory =
      'https://via.placeholder.com/400x200.png?text=Category';
  static const logo = 'https://via.placeholder.com/150x150.png?text=Sahl+Store';
}

/// 🔑 أسماء الجداول في Supabase
class SupabaseTables {
  static const profiles = 'profiles';
  static const categories = 'categories';
  static const subcategories = 'subcategories';
  static const products = 'products';
  static const offers = 'offers';
  static const orders = 'orders';
}

/// 📏 القيم الثابتة العامة
class AppConstants {
  static const double borderRadius = 12.0;
  static const double padding = 16.0;
  static const double elevation = 3.0;
  static const double spacing = 8.0;
}

const String tUId = 'tUid';
