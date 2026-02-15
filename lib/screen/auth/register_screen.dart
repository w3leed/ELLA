// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:raf/cubit/auth/auth_cubit.dart';
// import 'package:raf/cubit/auth/auth_state.dart';

// import '../../../core/app_routes.dart';
// import '../../../widgets/custom_button.dart';
// import '../../../widgets/text_field.dart';

// class RegisterScreen extends StatefulWidget {
//   const RegisterScreen({super.key});

//   @override
//   State<RegisterScreen> createState() => _RegisterScreenState();
// }

// class _RegisterScreenState extends State<RegisterScreen> {
//   final nameCtrl = TextEditingController();
//   final phoneCtrl = TextEditingController();
//   final passCtrl = TextEditingController();
//   final confirmCtrl = TextEditingController();
//   final questionCtrl = TextEditingController();
//   final answerCtrl = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("إنشاء حساب")),
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.all(18.0),
//           child: BlocConsumer<AuthCubit, AuthState>(
//             listener: (context, state) {
//               if (state is AuthSuccess) {
//                 Navigator.pushReplacementNamed(context, AppRoutes.home);
//               } else if (state is AuthError) {
//                 ScaffoldMessenger.of(context).showSnackBar(
//                   SnackBar(content: Text(state.message)),
//                 );
//               }
//             },
//             builder: (context, state) {
//               return SingleChildScrollView(
//                 child: Column(
//                   children: [
//                     CustomTextField(
//                       controller: nameCtrl,
//                       label: "الاسم",
//                     ),
//                     const SizedBox(height: 10),

//                     CustomTextField(
//                       controller: phoneCtrl,
//                       label: "رقم الهاتف",
//                       //keyboardType: TextInputType.phone,
//                     ),
//                     const SizedBox(height: 10),

//                     CustomTextField(
//                       controller: passCtrl,
//                       label: "كلمة المرور",
//                     //  obscureText: true,
//                     ),
//                     const SizedBox(height: 10),

//                     CustomTextField(
//                       controller: confirmCtrl,
//                       label: "تأكيد كلمة المرور",
//                    //   obscureText: true,
//                     ),
//                     const SizedBox(height: 10),

//                     Text("سؤال أمان لإسترجاع الحساب", style: TextStyle(fontWeight: FontWeight.bold)),
//                     const SizedBox(height: 6),

//                     CustomTextField(
//                       controller: questionCtrl,
//                       label: "ما هو السؤال الأمني؟",
//                     ),
//                     const SizedBox(height: 10),

//                     CustomTextField(
//                       controller: answerCtrl,
//                       label: "الإجابة",
//                     ),
//                     const SizedBox(height: 20),

//                     CustomButton(
//                       text: state is AuthLoading
//                           ? "جاري إنشاء الحساب..."
//                           : "إنشاء الحساب",
//                       onPressed: () {
//                         if (passCtrl.text != confirmCtrl.text) {
//                           ScaffoldMessenger.of(context).showSnackBar(
//                             const SnackBar(content: Text("كلمة المرور غير متطابقة")),
//                           );
//                           return;
//                         }

//                         context.read<AuthCubit>().register(
//                           name: nameCtrl.text.trim(),
//                           phone: phoneCtrl.text.trim(),
//                           password: passCtrl.text.trim(),

//                           securityQuestion: questionCtrl.text.trim(),
//                           securityAnswer: answerCtrl.text.trim(),
//                            email: '',
//                         );
//                       },
//                     ),

//                     TextButton(
//                       onPressed: () {
//                         Navigator.pushReplacementNamed(context, AppRoutes.login);
//                       },
//                       child: const Text("لديك حساب؟ تسجيل الدخول"),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:raf/core/components.dart';
import 'package:raf/cubit/app/app_cubit.dart';
import 'package:raf/cubit/app/app_state.dart';
import 'package:raf/screen/auth/login_screen.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is RegisterSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text("Account created! Please verify email"),
                backgroundColor: Colors.green),
          );
          navigateAndFinish(context, LoginScreen());
          // Navigator.pop(context); // العودة لشاشة تسجيل الدخول
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);
        return Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            backgroundColor: Colors.white,
            // appBar: AppBar(backgroundColor: Colors.white, elevation: 0,
            // actions: [

            // ],
            //  leading: const BackButton(color: Colors.black)),
            body: SingleChildScrollView(
              padding: const EdgeInsets.all(25),
              child: Form(
                key: _formKey,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    IconButton(
                        onPressed: () {}, icon: Icon(Icons.arrow_back_rounded)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          'assets/images/logo.png',
                          height: MediaQuery.of(context).size.height * 0.2,
                          width: MediaQuery.of(context).size.width * 0.4,
                        ),
                        const Text("Create New Account",
                            style: TextStyle(
                                fontSize: 28, fontWeight: FontWeight.bold)),
                        const SizedBox(height: 5),
                        Text("Enter your details to join us",
                            style: TextStyle(color: Colors.grey[600])),
                        const SizedBox(height: 30),
                        _buildField(
                            "Full Name", _nameController, Icons.person_outline),
                        _buildField(
                            "Email", _emailController, Icons.email_outlined,
                            keyboard: TextInputType.emailAddress),
                        _buildField("Phone Number", _phoneController,
                            Icons.phone_android,
                            keyboard: TextInputType.phone),
                        _buildField("Detailed Address", _addressController,
                            Icons.location_on_outlined),
                        _buildField("Security Question", _questionController,
                            Icons.question_mark_outlined,
                            keyboard: TextInputType.text),
                        _buildField(
                            "Answer", _answerController, Icons.question_answer),
                        _buildField(
                            "Password", _passwordController, Icons.lock_outline,
                            isPass: true),
                        _buildField("Confirm Password",
                            _confirmPasswordController, Icons.lock_reset,
                            isPass: true),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 55,
                          child: ElevatedButton(
                            onPressed: state is RegisterLoadingState
                                ? null
                                : () => _submit(cubit),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue[700],
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15)),
                            ),
                            child: state is RegisterLoadingState
                                ? const CircularProgressIndicator(
                                    color: Colors.white)
                                : const Text("Create Account",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                          ),
                        ),
                        const SizedBox(height: 30),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text("  Have an account?"),
                            TextButton(
                              onPressed: () {
                                navigateTo(context, LoginScreen());
                              },
                              child: const Text("Login",
                                  style:
                                      TextStyle(fontWeight: FontWeight.bold)),
                            ),
                          ],
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

  void _submit(AppCubit cubit) {
    if (_formKey.currentState!.validate()) {
      if (_passwordController.text != _confirmPasswordController.text) {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("Passwords do not match")));
        return;
      }
      print(_emailController.text);
      cubit.register(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
        name: _nameController.text.trim(),
        phone: _phoneController.text.trim(),
        address: _addressController.text.trim(),
        quesstion: _questionController.text.trim(),
        answer: _answerController.text.trim(),
      );
    }
  }

  Widget _buildField(
      String label, TextEditingController controller, IconData icon,
      {bool isPass = false, TextInputType keyboard = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        obscureText: isPass,
        keyboardType: keyboard,
        validator: (value) => value!.isEmpty ? "This field is required" : null,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue[700]),
          filled: true,
          fillColor: Colors.grey[100],
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide.none),
        ),
      ),
    );
  }
}
