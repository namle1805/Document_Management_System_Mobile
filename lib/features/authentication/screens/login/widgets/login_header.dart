import 'package:flutter/material.dart';

import '../../../../../utils/constants/image_strings.dart';
import '../../../../../utils/constants/sizes.dart';
import '../../../../../utils/constants/text_strings.dart';
import '../../../../../utils/helpers/helper_functions.dart';

class TLoginHeader extends StatelessWidget {
  const TLoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final dark = THelperFunctions.isDarkMode(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image(
            height: 200,
            image:
                AssetImage(dark ? TImages.lightAppLogo : TImages.darkAppLogo)),
        Text(
          'DMS',
          style: Theme.of(context)
              .textTheme
              .headlineLarge
              ?.copyWith(color: Color(0xFF5894FE)),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: TSizes.sm),
        Text(TTexts.loginSubTitle,
            style: Theme.of(context).textTheme.bodyMedium),
      ],
    );
  }
}
