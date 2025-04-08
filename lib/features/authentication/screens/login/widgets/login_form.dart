import 'package:dms/features/authentication/screens/verify_email/verify_email.dart';
import 'package:dms/navigation_menu.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class TLoginForm extends StatelessWidget {
  const TLoginForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Form(
        child: Padding(
          padding: const EdgeInsets.symmetric(
              vertical: TSizes.spaceBtwSections),
          child: Column(
            children: [
              /// Email
              TextFormField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.direct_right),
                    labelText: TTexts.username),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),

              /// Password
              TextFormField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.password_check),
                    labelText: TTexts.password,
                    suffixIcon: Icon(Iconsax.eye_slash)),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields / 2),

              /// Remember Me & Forgot Password
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /// Remember Me
                  Row(
                    children: [
                      Checkbox(value: true, onChanged: (value) {}),
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

              /// Sign In Button
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => Get.to(() => const NavigationMenu()),
                      child: const Text(TTexts.signIn))),
              const SizedBox(height: TSizes.spaceBtwItems),


            ],
          ),
        )
    );
  }
}