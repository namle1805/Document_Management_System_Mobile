import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../data/services/auth_services.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/auth/auth_controller.dart';
import '../../login/login.dart';

class ChangePassForm extends StatefulWidget {
  const ChangePassForm({super.key});

  @override
  State<ChangePassForm> createState() => _ChangePassFormState();
}

class _ChangePassFormState extends State<ChangePassForm> {
  final _formKey = GlobalKey<FormState>();
  final _oldPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscureOld = true;
  bool _obscureNew = true;
  bool _obscureConfirm = true;


  void _submit() async {
    final email = AuthController().email;
    final otpCode = AuthController().otpCode;
    final oldPass = _oldPasswordController.text.trim();
    final newPass = _newPasswordController.text.trim();
    final confirmPass = _confirmPasswordController.text.trim();

    if (newPass != confirmPass) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Mật khẩu không khớp')),
      );
      return;
    }

    try {
      final result = await AuthService.changePassword(
        email: email,
        otpCode: otpCode,
        oldPassword: oldPass,
        newPassword: newPass,
        confirmPassword: confirmPass,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Thay đổi mật khẩu thành công')),
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [

        TextFormField(
        controller: _oldPasswordController,
        obscureText: _obscureOld,
        decoration: InputDecoration(
          labelText: TTexts.old_password,
          prefixIcon: const Icon(Iconsax.password_check),
          suffixIcon: IconButton(
            icon: Icon(_obscureOld ? Iconsax.eye_slash : Iconsax.eye),
            onPressed: () {
              setState(() {
                _obscureOld = !_obscureOld;
              });
            },
          ),
        ),),
          const SizedBox(height: 16),
          TextFormField(
            controller: _newPasswordController,
            obscureText: _obscureNew,
            decoration: InputDecoration(
              labelText: TTexts.new_password,
              prefixIcon: const Icon(Iconsax.password_check),
              suffixIcon: IconButton(
                icon: Icon(_obscureNew ? Iconsax.eye_slash : Iconsax.eye),
                onPressed: () {
                  setState(() {
                    _obscureNew = !_obscureNew;
                  });
                },
              ),
            ),),
          const SizedBox(height: 16),
          TextFormField(
            controller: _confirmPasswordController,
            obscureText: _obscureConfirm,
            decoration: InputDecoration(
              labelText: TTexts.conPassword,
              prefixIcon: const Icon(Iconsax.password_check),
              suffixIcon: IconButton(
                icon: Icon(_obscureConfirm ? Iconsax.eye_slash : Iconsax.eye),
                onPressed: () {
                  setState(() {
                    _obscureConfirm = !_obscureConfirm;
                  });
                },
              ),
            ),),
          const SizedBox(height: 24),
          SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Đổi mật khẩu'))),
          const SizedBox(height: TSizes.spaceBtwItems),
        ],
      ),
    );
  }
}
