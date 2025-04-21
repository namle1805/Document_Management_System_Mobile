import 'package:dms/features/authentication/screens/login/login.dart';
import 'package:dms/features/authentication/screens/onboarding/onboarding.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/device/device_utility.dart';

class OnBoardingSkip extends StatelessWidget {
  const OnBoardingSkip({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: TDeviceUtils.getAppBarHeight(),
      right: TSizes.defaultSpace,
      child: TextButton(onPressed: () =>
          Get.to(() => const LoginScreen())
          // OnBoardingController.instance.skipPage()
          , child:  Text('Bỏ qua',
              style: GoogleFonts.getFont("Roboto Condensed", fontWeight: FontWeight.w700, color: Colors.black, fontSize: 18)
          )),
    );
  }
}