import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:raf/core/components.dart';
import 'package:raf/core/constants.dart';
import 'package:raf/cubit/app/app_cubit.dart';
import 'package:raf/cubit/app/app_state.dart';
import 'package:raf/screen/auth/login_screen.dart';
import 'package:raf/screen/auth/register_screen.dart';

class SpecialOfferDetailsScreen extends StatefulWidget {
  final dynamic offer; // نمرر بيانات العرض هنا من جدول special_offer

  const SpecialOfferDetailsScreen({super.key, required this.offer});

  @override
  State<SpecialOfferDetailsScreen> createState() => _SpecialOfferDetailsScreenState();
}

class _SpecialOfferDetailsScreenState extends State<SpecialOfferDetailsScreen> {
  int quantity = 1;

  @override
  Widget build(BuildContext context) {
    // حساب السعر بعد الخصم
    double originalPrice = double.parse(widget.offer['price'].toString());
    double discountPercent = double.parse(widget.offer['dis'].toString());
    double discountedPrice = originalPrice - (originalPrice * discountPercent / 100);

    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {},
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return SafeArea(
          child: Scaffold(
            backgroundColor: Colors.white,
            body: Directionality(
              textDirection: TextDirection.rtl,
              child: Stack(
                children: [
                  CustomScrollView(
                    slivers: [
                      // 1. صورة العرض مع زر الرجوع وشارة الخصم
                      SliverAppBar(
                        expandedHeight: 350,
                        backgroundColor: Colors.white,
                        elevation: 0,
                        leading: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: CircleAvatar(
                            backgroundColor: Colors.white.withOpacity(0.9),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.black),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          background: Stack(
                            children: [
                              Hero(
                                tag: widget.offer['id'],
                                child: buildNetworkImage(
                                  widget.offer['images'],
                                  width: double.infinity,
                                  fit: BoxFit.contain,
                                ),
                              ),
                              // شارة الخصم فوق الصورة
                              Positioned(
                                top: 20,
                                left: 20,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    "خصم $discountPercent%",
                                    style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 2. تفاصيل العرض
                      SliverToBoxAdapter(
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // العنوان والملصق الإضافي
                              Row(
                                children: [
                                  Expanded(
                                    child: Text(
                                      widget.offer['name'],
                                      style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  if (widget.offer['name_extra'] != null)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.orange.withOpacity(0.1),
                                        borderRadius: BorderRadius.circular(5),
                                      ),
                                      child: Text(
                                        widget.offer['name_extra'],
                                        style: const TextStyle(color: Colors.orange, fontSize: 12, fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 10),

                              // عرض السعر (قبل وبعد الخصم)
                              Row(
                                children: [
                                  Text(
                                    "$discountedPrice ج.م",
                                    style: const TextStyle(fontSize: 26, color: Colors.blue, fontWeight: FontWeight.bold),
                                  ),
                                  const SizedBox(width: 15),
                                  Text(
                                    "$originalPrice ج.م",
                                    style: const TextStyle(
                                      fontSize: 18,
                                      color: Colors.grey,
                                      decoration: TextDecoration.lineThrough,
                                    ),
                                  ),
                                ],
                              ),

                              const Divider(height: 40),

                              const Text(
                                "تفاصيل العرض الخاص",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Text(
                                widget.offer['description'] ?? "لا يوجد وصف متاح.",
                                style: TextStyle(fontSize: 16, color: Colors.grey[700], height: 1.5),
                              ),

                              const SizedBox(height: 120),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  // 3. شريط التحكم السفلي (نفس التصميم السابق)
                  Positioned(
                    bottom: 0, left: 0, right: 0,
                    child: _buildBottomActionSide(cubit, discountedPrice),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBottomActionSide(var cubit, double finalPrice) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10, offset: const Offset(0, -5))],
        borderRadius: const BorderRadius.vertical(top: Radius.circular(30)),
      ),
      child: Row(
        children: [
          // عداد الكمية
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(color: Colors.grey[100], borderRadius: BorderRadius.circular(15)),
            child: Row(
              children: [
                _quantityButton(Icons.add, () => setState(() => quantity++)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: Text("$quantity", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                ),
                _quantityButton(Icons.remove, () {
                  if (quantity > 1) setState(() => quantity--);
                }),
              ],
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: ElevatedButton(
              onPressed: () async {
                if (Hive.box(tUId).get(tUId) == null) {
                  showAuthDialog(context);
                } else {
                  // نرسل السعر بعد الخصم (finalPrice) إلى السلة
                  await cubit.addToCart(
                    productId: widget.offer['id'].toString(),
                    name: widget.offer['name'],
                    price: finalPrice, 
                    imageUrl: widget.offer['images'],
                    selectedQuantity: quantity,
                  );

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("تم إضافة العرض إلى السلة بسعر $finalPrice ج.م"),
                        backgroundColor: Colors.green,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[700],
                padding: const EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              ),
              child: const Text("إضافة العرض للسلة", style: TextStyle(fontSize: 18, color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
void showAuthDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (context) => Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.lock_person_outlined, size: 70, color: Colors.blue),
            const SizedBox(height: 20),
            const Text(
              "تسجيل الدخول مطلوب",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              "يجب عليك تسجيل الدخول لتتمكن من إضافة المنتجات إلى سلة المشتريات الخاصة بك.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey),
            ),
            const SizedBox(height: 30),
            
            // زر تسجيل الدخول
            SizedBox(
              width: double.infinity,
              height: 45,
              child: ElevatedButton(
                onPressed: () {

                navigateAndFinish(context, LoginScreen());                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const LoginScreen()));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: const Text("تسجيل الدخول", style: TextStyle(color: Colors.white)),
              ),
            ),
            const SizedBox(height: 10),
            
            // زر إنشاء حساب
            SizedBox(
              width: double.infinity,
              height: 45,
              child: OutlinedButton(
                onPressed: () {
                navigateAndFinish(context, RegisterScreen());
                  // Navigator.push(context, MaterialPageRoute(builder: (context) => const RegisterScreen()));
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.blue[700]!),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                child: Text("إنشاء حساب جديد", style: TextStyle(color: Colors.blue[700])),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
  Widget _quantityButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(5),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, size: 20, color: Colors.blue[700]),
      ),
    );
  }
}