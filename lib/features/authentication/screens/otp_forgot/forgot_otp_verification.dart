// import 'dart:async';
// import 'package:dms/features/authentication/screens/verify_email/verify_email.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:iconsax/iconsax.dart';
// import '../../../../data/services/auth_services.dart';
// import '../../../../utils/constants/colors.dart';
// import '../../../../utils/constants/image_strings.dart';
// import '../../../../utils/constants/sizes.dart';
// import '../../../../utils/constants/text_strings.dart';
// import '../../controllers/auth/auth_controller.dart';
// import '../../controllers/verify_otp/verify_otp_controller.dart';
//
// class ForgotOtpVerificationScreen extends StatefulWidget {
//   const ForgotOtpVerificationScreen({super.key});
//
//   @override
//   _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
// }
//
// class _OtpVerificationScreenState extends State<ForgotOtpVerificationScreen> {
//   late Timer _timer;
//   int _start = 180;
//   final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
//   final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
//   final OtpController _otpController = Get.put(OtpController());
//
//   @override
//   void initState() {
//     super.initState();
//     startTimer();
//   }
//
//   void startTimer() {
//     _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
//       if (_start == 0) {
//         setState(() {
//           _timer.cancel();
//         });
//       } else {
//         setState(() {
//           _start--;
//         });
//       }
//     });
//   }
//
//   @override
//   void dispose() {
//     _timer.cancel();
//     _otpControllers.forEach((controller) => controller.dispose());
//     _focusNodes.forEach((focusNode) => focusNode.dispose());
//     super.dispose();
//   }
//
//   void _nextField(int index, String value) {
//     if (value.isNotEmpty) {
//       if (index < _otpControllers.length - 1) {
//         FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
//       } else {
//         FocusScope.of(context).unfocus();
//       }
//     } else if (index > 0) {
//       FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:
//       AppBar(
//         title: Text('Xác thực OTP', style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white), textAlign: TextAlign.center),
//         centerTitle: true,
//         backgroundColor: TColors.primary,
//         iconTheme: IconThemeData(color: Colors.white),
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Iconsax.arrow_left_24),
//           onPressed: () {
//             Navigator.pushReplacement(
//               context,
//               MaterialPageRoute(builder: (context) => VerifyEmailScreen()),
//             );
//           },
//         ),
//       ),
//       backgroundColor: Colors.white,
//       body: Stack(
//         children: [
//           Positioned.fill(
//             top: 50,
//             child: Container(
//               padding:  const EdgeInsets.all(TSizes.md),
//               decoration: const BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
//               ),
//               child: SingleChildScrollView(
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.center,
//                   children: [
//                     const Image(
//                         height: 200,image: AssetImage(TImages.lightAppLogo)),
//                     Text(
//                       'DMS',
//                       style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Color(0xFF5894FE)),
//                       textAlign: TextAlign.center,
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwItems),
//                     Padding(
//                       padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
//                       child: Text(
//                         TTexts.otpVerificationSubTitle,
//                         style: Theme.of(context).textTheme.labelMedium,
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwItems),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//                       children: List.generate(6, (index) {
//                         return SizedBox(
//                           width: 50,
//                           height: 50,
//                           child: TextField(
//                             controller: _otpControllers[index],
//                             focusNode: _focusNodes[index],
//                             decoration: const InputDecoration(
//                               border: OutlineInputBorder(),
//                               counterText: "",
//                             ),
//                             keyboardType: TextInputType.number,
//                             textAlign: TextAlign.center,
//                             maxLength: 1,
//                             textInputAction: TextInputAction.next,
//                             onChanged: (value) {
//                               _nextField(index, value);
//                             },
//                             inputFormatters: [FilteringTextInputFormatter.digitsOnly],
//                           ),
//                         );
//                       }),
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwItems),
//                     Row(
//                       mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                       children: [
//                         Padding(
//                           padding: const EdgeInsets.only(left: TSizes.md),
//                           child: Text(
//                             'Thời gian còn lại 00:${_start.toString().padLeft(2, '0')}',
//                             style: Theme.of(context).textTheme.labelMedium,
//                           ),
//                         ),
//                         TextButton(
//                           onPressed: _start == 0 ? () async {
//                             try {
//                               final email = Get.arguments['email']; // Lấy email từ arguments
//                               await AuthService.sendOtp(email: email);
//                               setState(() {
//                                 _start = 180;
//                                 _timer.cancel();
//                                 startTimer();
//                               });
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text('Đã gửi lại mã OTP đến $email')),
//                               );
//                             } catch (e) {
//                               ScaffoldMessenger.of(context).showSnackBar(
//                                 SnackBar(content: Text('Lỗi: ${e.toString()}')),
//                               );
//                             }
//                           } : null, // Chỉ bật nút khi hết thời gian
//                           child: Text(
//                             TTexts.resendOTP,
//                             style: TextStyle(color: _start == 0 ? Colors.red : Colors.grey),
//                           ),
//                         ),
//
//                       ],
//                     ),
//                     const SizedBox(height: TSizes.spaceBtwItems),
//                     GestureDetector(
//                       onTap: () {
//                         final otp = _otpControllers.map((controller) => controller.text).join();
//                         final email = Get.arguments['email']; // truyền email từ VerifyEmailScreen
//                         if (otp.length == 6 && email != null) {
//                           AuthController().email = email;
//                           AuthController().otpCode = otp;
//                           _otpController.verifyOtp(email, otp);
//                         } else {
//                           Get.snackbar('Lỗi xác thực', 'Vui lòng nhập OTP đầy đủ và hợp lệ');
//                         }
//                       },
//
//                       child: Container(
//                         padding: EdgeInsets.symmetric(vertical: 15),
//                         decoration: BoxDecoration(
//                           borderRadius: BorderRadius.circular(15),
//                           color: Colors.blueAccent,
//                         ),
//                         child: Center(
//                           child: Text(
//                             TTexts.verificationButton,
//                             style: GoogleFonts.getFont(
//                               "Roboto Condensed",
//                               fontWeight: FontWeight.w700,
//                               color: Colors.white,
//                               fontSize: 18,
//                             ),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }


import 'dart:async';
import 'package:dms/features/authentication/screens/verify_email/verify_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import '../../../../data/services/auth_services.dart';
import '../../../../utils/constants/colors.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';
import '../../controllers/auth/auth_controller.dart';
import '../../controllers/verify_otp/verify_otp_controller.dart';

class ForgotOtpVerificationScreen extends StatefulWidget {
  const ForgotOtpVerificationScreen({super.key});

  @override
  _OtpVerificationScreenState createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<ForgotOtpVerificationScreen> {
  late Timer _timer;
  int _start = 180;
  final List<TextEditingController> _otpControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (index) => FocusNode());
  final OtpController _otpController = Get.put(OtpController());

  @override
  void initState() {
    super.initState();
    startTimer();
  }

  void startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_start == 0) {
        setState(() {
          _timer.cancel();
        });
      } else {
        setState(() {
          _start--;
        });
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _otpControllers.forEach((controller) => controller.dispose());
    _focusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  void _nextField(int index, String value) {
    if (value.isNotEmpty) {
      if (index < _otpControllers.length - 1) {
        FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus();
      }
    } else if (index > 0) {
      FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final minutes = (_start ~/ 60).toString().padLeft(2, '0');
    final seconds = (_start % 60).toString().padLeft(2, '0');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Xác thực OTP',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        centerTitle: true,
        backgroundColor: TColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_24),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const VerifyEmailScreen()),
            );
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            top: 50,
            child: Container(
              padding: const EdgeInsets.all(TSizes.md),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(0)),
              ),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const Image(
                      height: 200,
                      image: AssetImage(TImages.lightAppLogo),
                    ),
                    Text(
                      'DMS',
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: const Color(0xFF5894FE)),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: TSizes.md),
                      child: Text(
                        TTexts.otpVerificationSubTitle,
                        style: Theme.of(context).textTheme.labelMedium,
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(6, (index) {
                        return SizedBox(
                          width: 50,
                          height: 50,
                          child: TextField(
                            controller: _otpControllers[index],
                            focusNode: _focusNodes[index],
                            decoration: const InputDecoration(
                              border: OutlineInputBorder(),
                              counterText: "",
                            ),
                            keyboardType: TextInputType.number,
                            textAlign: TextAlign.center,
                            maxLength: 1,
                            textInputAction: TextInputAction.next,
                            onChanged: (value) {
                              _nextField(index, value);
                            },
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: TSizes.md),
                          child: Text(
                            'Thời gian còn lại: $minutes:$seconds',
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                        ),
                        TextButton(
                          onPressed: _start == 0
                              ? () async {
                            try {
                              final email = Get.arguments['email']; // Lấy email từ arguments
                              await AuthService.sendOtp(email: email);
                              setState(() {
                                _start = 180;
                                _timer.cancel();
                                startTimer();
                              });
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Đã gửi lại mã OTP đến $email')),
                              );
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text('Lỗi: ${e.toString()}')),
                              );
                            }
                          }
                              : null, // Chỉ bật nút khi hết thời gian
                          child: Text(
                            TTexts.resendOTP,
                            style: TextStyle(color: _start == 0 ? Colors.red : Colors.grey),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: TSizes.spaceBtwItems),
                    GestureDetector(
                      onTap: () {
                        final otp = _otpControllers.map((controller) => controller.text).join();
                        final email = Get.arguments['email']; // truyền email từ VerifyEmailScreen
                        if (otp.length == 6 && email != null) {
                          AuthController().email = email;
                          AuthController().otpCode = otp;
                          _otpController.verifyOtp(email, otp);
                        } else {
                          Get.snackbar('Lỗi xác thực', 'Vui lòng nhập OTP đầy đủ và hợp lệ');
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          color: Colors.blueAccent,
                        ),
                        child: Center(
                          child: Text(
                            TTexts.verificationButton,
                            style: GoogleFonts.getFont(
                              "Roboto Condensed",
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}