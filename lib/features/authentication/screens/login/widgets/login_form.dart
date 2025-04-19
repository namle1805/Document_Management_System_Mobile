import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../controllers/login/login_controller.dart';
import '../../verify_email/verify_email.dart';

class TLoginForm extends StatelessWidget {
  TLoginForm({super.key});

  final controller = Get.put(LoginController());
  final _formKey = GlobalKey<FormState>();

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email là bắt buộc';
    }
    if (!value.contains('@')) {
      return 'Vui lòng nhập đúng email hoặc username của bạn';
    }
    return null;
  }

  String? _passwordValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Mật khẩu là bắt buộc';
    }
    if (value.length < 8) {
      return 'Mật khẩu phải dài ít nhất 8 ký tự';
    }
    if (!RegExp(r'^[A-Z]').hasMatch(value)) {
      return 'Mật khẩu phải bắt đầu bằng một chữ cái viết hoa';
    }
    if (!RegExp(r'[!@\$%&]').hasMatch(value)) {
      return 'Mật khẩu phải chứa ít nhất một ký tự đặc biệt (@! %&)';
    }
    return null;
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      controller.handleLogin();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: TSizes.spaceBtwSections),
        child: Column(
          children: [
            TextFormField(
              controller: controller.emailController,
              validator: _emailValidator,
              decoration: const InputDecoration(
                prefixIcon: Icon(Iconsax.direct_right),
                labelText: TTexts.username,
              ),
            ),
            const SizedBox(height: TSizes.spaceBtwInputFields),
            Obx(() => TextFormField(
              controller: controller.passwordController,
              obscureText: controller.isPasswordHidden.value,
              validator: _passwordValidator,
              decoration: InputDecoration(
                prefixIcon: const Icon(Iconsax.password_check),
                labelText: TTexts.password,
                suffixIcon: IconButton(
                  icon: Icon(
                    controller.isPasswordHidden.value
                        ? Iconsax.eye_slash
                        : Iconsax.eye,
                  ),
                  onPressed: controller.togglePasswordVisibility,
                ),
              ),
            )),
            /// Remember Me & Forgot Password
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                /// Remember Me
                Row(
                  children: [
                    Obx(() => Checkbox(
                      value: controller.isRememberMe.value,
                      onChanged: controller.toggleRememberMe,
                    )),
                    const Text(TTexts.rememberMe),
                  ],
                ),

                /// Forgot Password
                TextButton(
                    onPressed: ()
                    =>
                        Get.to(() => const VerifyEmailScreen())
                    ,
                    child: Text(TTexts.forgotPassword, style: TextStyle(color: Color(0xFF838383)),)),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwSections),
            Obx(() => controller.isLoading.value
                ? const CircularProgressIndicator()
                : SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                child: const Text(TTexts.signIn),
              ),
            )),
          ],
        ),
      ),
    );
  }
}
