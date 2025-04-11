import 'package:dms/features/authentication/screens/otp/otp_verification.dart';
import 'package:dms/features/authentication/screens/verify_email/verify_email.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';

class ForgotPassForm extends StatelessWidget {
  const ForgotPassForm({
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

              /// Password
              TextFormField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.password_check),
                    labelText: TTexts.new_password,
                    suffixIcon: Icon(Iconsax.eye_slash)),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),
              /// Confirm Password
              TextFormField(
                decoration: const InputDecoration(
                    prefixIcon: Icon(Iconsax.password_check),
                    labelText: TTexts.res_password,
                    suffixIcon: Icon(Iconsax.eye_slash)),
              ),
              const SizedBox(height: TSizes.spaceBtwInputFields),


              /// Sign In Button
              SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                      onPressed: () => Get.to(() => OtpVerificationScreen()),
                      child: const Text(TTexts.confirm))),
              const SizedBox(height: TSizes.spaceBtwItems),


            ],
          ),
        )
    );
  }
}