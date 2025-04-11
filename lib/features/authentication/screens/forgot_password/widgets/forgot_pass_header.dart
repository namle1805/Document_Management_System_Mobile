import 'package:flutter/material.dart';

import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class ForgotPassHeader extends StatelessWidget {
  const ForgotPassHeader({
    super.key
  });

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
            height: 200,
            image: AssetImage(
                dark ? TImages.lightAppLogo : TImages.darkAppLogo)),
        Text(TTexts.loginTitle,
            style: Theme.of(context).textTheme.headlineMedium),
      ],
    );
  }
}