import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raf/core/components.dart';
import 'package:raf/cubit/app/app_cubit.dart';
import 'package:raf/cubit/app/app_state.dart';
import 'package:raf/new_app/app_layout/main_layout.dart';
import 'package:raf/new_app/new_admin/main_admin.dart';
import 'package:raf/screen/auth/forgot_screen.dart';
import 'package:raf/screen/auth/register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _isPasswordVisible = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is LoginSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Login successful"),
                backgroundColor: Colors.green),
          );
          navigateAndFinish(context, MainLayout());
          // Navigator.pushReplacement(...) انتقل للشاشة الرئيسية هنا
        }
        if (state is LoginErrorState) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text("Error: ${state.error}"),
                backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);

        return Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            backgroundColor: Colors.white,
            body: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30.0),
                child: Column(
                  children: [
                    const SizedBox(height: 100),
                    // الشعار أو أيقونة ترحيبية
                    Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(Icons.shopping_bag_outlined,
                          size: 80, color: Colors.blue[700]),
                    ),
                    const SizedBox(height: 40),
                    const Text(
                      "Welcome Back",
                      style:
                          TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      "Login to continue",
                      style: TextStyle(color: Colors.grey[600], fontSize: 16),
                    ),
                    const SizedBox(height: 50),
                    if (state is LoginphoneErrorState)
                      Text(
                        'Invalid phone or password',
                        style: TextStyle(color: Colors.red),
                      ),
                    if (state is LoginpasswoedErrorState)
                      Text(
                        'Invalid phone or password',
                        style: TextStyle(color: Colors.red),
                      ),
                    // حقل رقم الهاتف
                    _buildTextField(
                      controller: _phoneController,
                      label: "Phone Number",
                      hint: "01xxxxxxxxx",
                      icon: Icons.phone_android,
                      keyboardType: TextInputType.phone,
                    ),
                    const SizedBox(height: 20),

                    // حقل كلمة المرور
                    _buildTextField(
                      controller: _passwordController,
                      label: "Password",
                      hint: "********",
                      icon: Icons.lock_outline,
                      isPassword: true,
                      obscureText: !_isPasswordVisible,
                      onSuffixTap: () {
                        setState(
                            () => _isPasswordVisible = !_isPasswordVisible);
                      },
                    ),
                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(" Forgot Password? "),
                        TextButton(
                          onPressed: () {
                            navigateTo(context, ForgotPasswordScreen());
                          },
                          child: const Text("Reset it",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 40),

                    // زر تسجيل الدخول
                    SizedBox(
                      width: double.infinity,
                      height: 55,
                      child: ElevatedButton(
                        onPressed: state is LoginLoadingState
                            ? null
                            : () {
                                if (_phoneController.text == '01010101010' &&
                                    _passwordController.text == '10101010') {
                                  navigateAndFinish(context, AdminHomeScreen());
                                } else {
                                  cubit.login(
                                    phone: _phoneController.text,
                                    password: _passwordController.text,
                                  );
                                }
                              },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[700],
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15)),
                          elevation: 5,
                        ),
                        child: state is LoginLoadingState
                            ? const CircularProgressIndicator(
                                color: Colors.white)
                            : const Text(
                                "Login",
                                style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                      ),
                    ),

                    const SizedBox(height: 30),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text("Don't have an account?"),
                        TextButton(
                          onPressed: () {
                            navigateTo(context, RegisterScreen());
                          },
                          child: const Text("Create new account",
                              style: TextStyle(fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool isPassword = false,
    bool obscureText = false,
    VoidCallback? onSuffixTap,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            hintText: hint,
            prefixIcon: Icon(icon, color: Colors.blue[700]),
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                        obscureText ? Icons.visibility_off : Icons.visibility),
                    onPressed: onSuffixTap,
                  )
                : null,
            filled: true,
            fillColor: Colors.grey[100],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Colors.blue[700]!, width: 1),
            ),
          ),
        ),
      ],
    );
  }
}
