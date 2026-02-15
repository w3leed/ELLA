import 'package:flutter/material.dart';
import 'package:raf/core/components.dart';
import 'package:raf/new_app/app_layout/app_layout.dart';
import 'package:raf/new_app/app_layout/main_layout.dart';
import 'package:raf/screen/auth/login_screen.dart';
import 'package:raf/screen/auth/register_screen.dart';
import 'package:raf/screen/home_screen.dart';
import '../../../core/constants.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
  navigateAndFinish(context, RegisterScreen());
    
     // لاحقًا نبدلها حسب تسجيل الدخول
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // backgroundColor: AppColors.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
           // OrderCard(),
            Image.asset('assets/images/logo.png'),
            Text(
              "خلي رفك دايما جاهز",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Colors.green,
              ),
            ),
          ],
        ),
      ),
    );
  }
} 
