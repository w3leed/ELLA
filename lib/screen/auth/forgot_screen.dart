// import 'package:flutter/material.dart';
// import '../../../widgets/custom_button.dart';
// import '../../../widgets/text_field.dart';

// class ForgotScreen extends StatelessWidget {
//   ForgotScreen({super.key});

//   final email = TextEditingController();
//   final answer = TextEditingController();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("إستعادة كلمة المرور")),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             CustomTextField(controller: email, label: "البريد"),
//             CustomTextField(controller: answer, label: "إجابة سؤال الأمان"),
//             const SizedBox(height: 20),
//             CustomButton(text: "تحقق", onPressed: () {})
//           ],
//         ),
//       ),
//     );
//   }
// }
import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  _ForgotPasswordScreenState createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _phoneController = TextEditingController();
  final _answerController = TextEditingController();
  final _newPasswordController = TextEditingController();
  
  int _currentStep = 0; // 0: Phone, 1: Question, 2: New Password
  String? _retrievedQuestion;
  Map<String, dynamic>? _userData;

  // STEP 1: Find User by Phone
  Future<void> _findUser() async {
    final data = await Supabase.instance.client
        .from('profiles')
        .select()
        .eq('phone', _phoneController.text)
        .maybeSingle();

    if (data != null) {
      setState(() {
        _userData = data;
        _retrievedQuestion = data['security_question'];
        _currentStep = 1;
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Phone number not found")));
    }
  }

  // STEP 2: Verify Security Answer
  void _verifyAnswer() {
    if (_userData!['security_answer_hash'].toString().toLowerCase() == _answerController.text.toLowerCase()) {
      setState(() => _currentStep = 2);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Incorrect Answer")));
    }
  }
  String hashPassword(String password) {
  var bytes = utf8.encode(password);
  return sha256.convert(bytes).toString();
}

  // STEP 3: Update Password and Move to Login
  Future<void> _resetPassword() async {
    String newHash = hashPassword(_newPasswordController.text);
    
    await  Supabase.instance.client
        .from('profiles')
        .update({'password_hash': newHash})
        .eq('phone', _phoneController.text);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Password Updated!")));
    Navigator.pop(context); // Go back to Login screen
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Reset Password")),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          children: [
            if (_currentStep == 0) ...[
              TextField(controller: _phoneController, decoration: InputDecoration(labelText: "Enter Phone")),
              ElevatedButton(onPressed: _findUser, child: Text("Next")),
            ],
            if (_currentStep == 1) ...[
              Text("Security Question: $_retrievedQuestion", style: TextStyle(fontSize: 18)),
              TextField(controller: _answerController, decoration: InputDecoration(labelText: "Your Answer")),
              ElevatedButton(onPressed: _verifyAnswer, child: Text("Verify")),
            ],
            if (_currentStep == 2) ...[
              TextField(controller: _newPasswordController, decoration: InputDecoration(labelText: "New Password"), obscureText: true),
              ElevatedButton(onPressed: _resetPassword, child: Text("Update Password")),
            ],
          ],
        ),
      ),
    );
  }
}