import 'package:flutter/material.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/onboarding/onboarding_controller.dart';

class OnBoardingNextButton extends StatelessWidget {
  const OnBoardingNextButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = THelperFunctions.screenHeight();
    final screenWidth = THelperFunctions.screenWidth();
    final dark = THelperFunctions.isDarkMode(context);

    return Positioned(
      bottom: TDeviceUtils.getBottomNavigationBarHeight() + 45,
      left: 0,
      right: 0,
      child: Center(
        // mainAxisAlignment: MainAxisAlignment.center,
        child: ElevatedButton(
          onPressed: () => OnBoardingController.instance.nextPage(),
          style: ElevatedButton.styleFrom(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            backgroundColor: dark ? TColors.primary : Color(0xFF3077F4),
            padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.3,
              vertical: screenHeight * 0.018,
            ),
          ),
          child: const Text(
            'Bắt đầu',
            style: TextStyle(color: Colors.white),
          ),
        ),
      ),
    );
  }
}