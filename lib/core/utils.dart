// lib/core/utils.dart

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// 📢 عرض رسالة سريعة للمستخدم (SnackBar)
void showSnackBar(BuildContext context, String message,
    {Color color = Colors.black87}) {
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text(message, style: const TextStyle(color: Colors.white)),
      backgroundColor: color,
      behavior: SnackBarBehavior.floating,
    ),
  );
}

/// 💰 تنسيق السعر (مثلاً 150 → 150.00 ج.م)
String formatPrice(num price) {
  final formatter = NumberFormat('#,##0.00', 'ar_EG');
  return '${formatter.format(price)} ج.م';
}

/// 📅 تنسيق التاريخ بطريقة بسيطة (2025-10-25 → 25 أكتوبر 2025)
String formatDate(DateTime date) {
  final formatter = DateFormat('dd MMMM yyyy', 'ar_EG');
  return formatter.format(date);
}

/// ✅ التحقق من البريد الإلكتروني
bool isValidEmail(String email) {
  final emailRegex =
      RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegex.hasMatch(email);
}

/// 📱 التحقق من رقم الهاتف المصري (11 رقم يبدأ بـ 010 / 011 / 012 / 015)
bool isValidPhone(String phone) {
  final phoneRegex = RegExp(r'^(010|011|012|015)\d{8}$');
  return phoneRegex.hasMatch(phone);
}

/// 🧠 التعامل مع الأخطاء القادمة من Supabase
String parseSupabaseError(dynamic error) {
  if (error == null) return 'حدث خطأ غير معروف';
  final msg = error.toString().toLowerCase();
  if (msg.contains('invalid login credentials')) {
    return 'بيانات الدخول غير صحيحة';
  } else if (msg.contains('network')) {
    return 'تحقق من الاتصال بالإنترنت';
  } else if (msg.contains('duplicate')) {
    return 'الحساب موجود بالفعل';
  }
  return 'حدث خطأ أثناء العملية';
}

/// 📏 تحديد المسافة بين العناصر
const sizedBoxH10 = SizedBox(height: 10);
const sizedBoxH20 = SizedBox(height: 20);
const sizedBoxW10 = SizedBox(width: 10);
const sizedBoxW20 = SizedBox(width: 20);
