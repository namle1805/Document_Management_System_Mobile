import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import '../../../../../utils/constants/colors.dart';
import '../../../../../utils/device/device_utility.dart';
import '../../../../../utils/helpers/helper_functions.dart';
import '../../../controllers/onboarding/onboarding_controller.dart';

class OnBoardingDotNavigation extends StatelessWidget {
  const OnBoardingDotNavigation({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = OnBoardingController.instance;
    final dark = THelperFunctions.isDarkMode(context);

    return Positioned(
      bottom: TDeviceUtils.getBottomNavigationBarHeight() + 20,
      left: 0,
      right: 0,
      child: Center(
        child: SmoothPageIndicator(
          count: 1,
          controller: controller.pageController,
          onDotClicked: controller.dotNavigationClick,
          effect: ExpandingDotsEffect(activeDotColor: dark ? TColors.light : TColors.primary, dotHeight: 6, dotWidth: 6),
        ),
      ),
    );
  }
}