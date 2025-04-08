import 'package:dms/common/styles/spacing_styles.dart';
import 'package:dms/features/authentication/screens/login/widgets/login_form.dart';
import 'package:dms/features/authentication/screens/login/widgets/login_header.dart';
import 'package:dms/features/authentication/screens/onboarding/onboarding.dart';
import 'package:dms/utils/constants/colors.dart';
import 'package:dms/utils/constants/image_strings.dart';
import 'package:dms/utils/constants/sizes.dart';
import 'package:dms/utils/constants/text_strings.dart';
import 'package:dms/utils/helpers/helper_functions.dart';
import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';

class ChangePasswordScreen extends StatelessWidget {
  const ChangePasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);

    return Scaffold(
      appBar:
      AppBar(
        title: Text('Log In', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white), textAlign: TextAlign.center),
        centerTitle: true,
        backgroundColor: TColors.primary,
        iconTheme: IconThemeData(color: Colors.white),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Iconsax.arrow_left_24),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => OnBoardingScreen()),
            );
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: TSpacingStyle.paddingWithAppBarHeight,
          child: Column(
            children: [
              /// Logo, Title, Sub-Title
              TLoginHeader(),

              /// Form
              TLoginForm(),

              /// Divider
              Row(
                mainAxisAlignment:  MainAxisAlignment.center,
                children: [
                  Divider(color: dark ? TColors.darkerGrey : TColors.grey, thickness: 0.5, indent: 60, endIndent: 5),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}



