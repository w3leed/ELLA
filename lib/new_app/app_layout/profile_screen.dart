import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:raf/core/components.dart';
import 'package:raf/core/constants.dart';
import 'package:raf/cubit/app/app_cubit.dart';
import 'package:raf/cubit/app/app_state.dart';
import 'package:raf/new_app/savedata.dart';
import 'package:raf/screen/auth/login_screen.dart';
import 'package:raf/screen/auth/register_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _nameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    AppCubit.get(context).getUserProfile();

    return BlocConsumer<AppCubit, AppState>(
      listener: (context, state) {
        if (state is ProfileUpdateSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Profile updated successfully")));
        }
      },
      builder: (context, state) {
        var cubit = AppCubit.get(context);

        return Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            backgroundColor: Colors.grey[50],
            appBar: AppBar(
              title:
                  const Text("Profile", style: TextStyle(color: Colors.black)),
              backgroundColor: Colors.white,
              elevation: 0,
              centerTitle: true,
            ),
            body: cubit.userProfile == null
                ? _buildGuestView(context)
                : _buildProfileView(cubit, state),
          ),
        );
      },
    );
  }

  // واجهة الزائر (Guest)
  Widget _buildGuestView(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.account_circle_outlined,
                size: 100, color: Colors.blue[200]),
            const SizedBox(height: 20),
            const Text("You are browsing as a guest",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            const Text("Login to order and track your account",
                textAlign: TextAlign.center),
            const SizedBox(height: 30),
            Row(
              children: [
                Expanded(
                    child: ElevatedButton(
                        onPressed: () {
                          navigateTo(context, LoginScreen());
                        },
                        child: const Text("Login"))),
                const SizedBox(width: 10),
                Expanded(
                    child: OutlinedButton(
                        onPressed: () {
                          navigateTo(context, RegisterScreen());
                        },
                        child: const Text("Create Account"))),
              ],
            )
          ],
        ),
      ),
    );
  }

  // واجهة المستخدم المسجل
  Widget _buildProfileView(AppCubit cubit, AppState state) {
    // ملء البيانات في الـ Controllers لأول مرة
    _nameController.text = cubit.userProfile!['full_name'] ?? "";
    _phoneController.text = cubit.userProfile!['phone'] ?? "";
    _addressController.text = cubit.userProfile!['address'] ?? "";

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          const CircleAvatar(
              radius: 50,
              backgroundColor: Colors.blue,
              child: Icon(Icons.person, size: 50, color: Colors.white)),
          const SizedBox(height: 30),
          _buildEditableField(
              "Full Name", _nameController, Icons.person_outline),
          _buildEditableField(
              "Phone Number", _phoneController, Icons.phone_android),
          _buildEditableField(
              "Address", _addressController, Icons.location_on_outlined),
          const SizedBox(height: 10),
          // عرض سؤال الأمان (للقراءة فقط)
          _buildEditableField(
              "Security Question",
              TextEditingController(
                  text: cubit.userProfile!['security_question']),
              Icons.security,
              enabled: false),
          const SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            height: 55,
            child: ElevatedButton(
              onPressed: state is ProfileUpdateLoadingState
                  ? null
                  : () {
                      cubit.updateProfile(
                        name: _nameController.text,
                        phone: _phoneController.text,
                        address: _addressController.text,
                      );
                    },
              style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15))),
              child: state is ProfileUpdateLoadingState
                  ? const CircularProgressIndicator(color: Colors.white)
                  : const Text("Save Changes",
                      style: TextStyle(color: Colors.white, fontSize: 18)),
            ),
          ),
          TextButton(
            onPressed: () {
              cubit.logout();
            },
            child: const Text("Logout", style: TextStyle(color: Colors.red)),
          )
        ],
      ),
    );
  }

  Widget _buildEditableField(
      String label, TextEditingController controller, IconData icon,
      {bool enabled = true}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(15)),
          filled: true,
          fillColor: enabled ? Colors.white : Colors.grey[200],
        ),
      ),
    );
  }
}
