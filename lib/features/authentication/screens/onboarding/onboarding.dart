import 'package:dms/features/authentication/screens/login/login.dart';
import 'package:dms/utils/constants/image_strings.dart';
import 'package:dms/utils/constants/text_strings.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/onboarding_page.dart';




class OnBoardingScreen extends StatelessWidget {
  const OnBoardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Lấy kích thước màn hình để tính toán responsive
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: screenHeight * 0.4,
              width: screenWidth * 0.8,
              child: Image.asset(
                TImages.onBoardingImage,
                fit: BoxFit.contain,
              ),
            ),
            SizedBox(height: screenHeight * 0.05),

            OnBoardingPage(title: TTexts.onBoardingTitle1, subTitle: TTexts.onBoardingSubTitle1),
            SizedBox(height: screenHeight * 0.05),

            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.1),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Get.to(() => LoginScreen()),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: EdgeInsets.symmetric(vertical: screenHeight * 0.02),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  child: const Text(
                    'Bắt đầu',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
