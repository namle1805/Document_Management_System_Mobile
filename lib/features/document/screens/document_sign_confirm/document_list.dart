import 'dart:async';
import 'package:dms/utils/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../utils/constants/image_strings.dart';
import '../../../../utils/constants/sizes.dart';
import '../../../../utils/constants/text_strings.dart';


class DocumentListSignConfirmPage extends StatelessWidget {
  // final double llx;
  // final double lly;
  // final double urx;
  // final double ury;
  // final int currentPage;
  // final String documentName;

  DocumentListSignConfirmPage({
    Key? key,
    // required this.llx,
    // required this.lly,
    // required this.urx,
    // required this.ury,
    // required this.currentPage,
    // required this.documentName,
  }) : super(key: key);

  final List<Map<String, dynamic>> documents = [
    {
      'type': 'PDF',
      'title': 'Nghị định liên quan đến điều...',
      'date': '28 Oct 2024',
      'size': '122 MB',
      'iconColor': Colors.red[100],
    }
  ];

  void _showLoginDialog(BuildContext context) {
    TextEditingController emailController = TextEditingController();
    TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image(
                    height: 200,
                    image:
                    AssetImage( TImages.lightAppLogo)),
                Text(
                  'DMS',
                  style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Color(0xFF5894FE)),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'Vui lòng đăng nhập tài khoản ký số',
                  style: TextStyle(
                    fontSize: 16,
                    color: TColors.primary,
                  ),
                ),
                SizedBox(height: 24),
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    hintText: 'Text your email',
                    labelText: 'Email',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Text your password',
                    labelText: 'Password',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
                SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(dialogContext);
                      _showPinDialog(context);
                    },
                    child: Text('Log In'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    ).whenComplete(() {
      emailController.dispose();
      passwordController.dispose();
    });
  }

  void _showPinDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext dialogContext) {
        return PinDialog(
          onVerify: (pin) {
            Navigator.pop(dialogContext);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Xác nhận thành công!')),
            );
          },
          onError: (message) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(message)),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          'Khởi tạo chức năng ký',
          style: TextStyle(
            color: Colors.black,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 8),
            alignment: Alignment.center,
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(16),
              itemCount: documents.length,
              itemBuilder: (context, index) {
                final doc = documents[index];
                return DocumentItem(
                  type: doc['type'],
                  title: doc['title'],
                  date: doc['date'],
                  size: doc['size'],
                  iconColor: doc['iconColor'],
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _showLoginDialog(context);
        },
        label: Text('Xác nhận'),
        icon: Icon(Icons.check),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class PinDialog extends StatefulWidget {
  final Function(String) onVerify;
  final Function(String) onError;

  const PinDialog({
    Key? key,
    required this.onVerify,
    required this.onError,
  }) : super(key: key);

  @override
  _PinDialogState createState() => _PinDialogState();
}

class _PinDialogState extends State<PinDialog> {
  final List<TextEditingController> pinControllers = List.generate(6, (index) => TextEditingController());
  final List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  int remainingSeconds = 180; // 3 phút = 180 giây
  Timer? timer;
  bool _isMounted = false;

  @override
  void initState() {
    super.initState();
    _isMounted = true;
    startTimer();
  }

  void startTimer() {
    timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (!_isMounted) {
        timer.cancel();
        return;
      }
      if (remainingSeconds > 0) {
        setState(() {
          remainingSeconds--;
        });
      } else {
        timer.cancel();
      }
    });
  }

  void nextField(int index, String value) {
    if (!_isMounted) return;
    if (value.isNotEmpty) {
      if (index < pinControllers.length - 1) {
        FocusScope.of(context).requestFocus(focusNodes[index + 1]);
      } else {
        FocusScope.of(context).unfocus(); // Ẩn bàn phím khi nhập ô cuối
      }
    } else if (index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
  }

  @override
  void dispose() {
    _isMounted = false;
    timer?.cancel();
    pinControllers.forEach((controller) => controller.dispose());
    focusNodes.forEach((focusNode) => focusNode.dispose());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String seconds = remainingSeconds.toString().padLeft(2, '0');

    return Dialog(
      backgroundColor: Colors.white,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(TSizes.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Image(
              height: 200,
              image: AssetImage(TImages.lightAppLogo),
            ),
            Text(
              'DMS',
              style: Theme.of(context).textTheme.headlineLarge?.copyWith(color: Color(0xFF5894FE)),
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
                    controller: pinControllers[index],
                    focusNode: focusNodes[index],
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                      counterText: "",
                    ),
                    keyboardType: TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: 1,
                    textInputAction: TextInputAction.next,
                    onChanged: (value) {
                      nextField(index, value);
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
                    'Thời gian còn lại 00:$seconds',
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
                TextButton(
                  onPressed: remainingSeconds > 0
                      ? null
                      : () {
                    if (!_isMounted) return;
                    setState(() {
                      remainingSeconds = 180;
                      timer?.cancel();
                      startTimer();
                    });
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Đã gửi lại mã PIN')),
                    );
                  },
                  child: const Text(
                    TTexts.resendOTP,
                    style: TextStyle(color: Colors.red),
                  ),
                ),
              ],
            ),
            const SizedBox(height: TSizes.spaceBtwItems),
            GestureDetector(
              onTap: () {
                if (!_isMounted) return;
                final pin = pinControllers.map((controller) => controller.text).join();
                if (pin.length == 6) {
                  widget.onVerify(pin);
                } else {
                  widget.onError('Vui lòng nhập mã PIN 6 số');
                }
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 15),
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
    );
  }
}

class TabItem extends StatelessWidget {
  final String title;

  TabItem({required this.title});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 8),
      child: Text(
        title,
        style: TextStyle(
          color: Colors.grey,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }
}

class DocumentItem extends StatelessWidget {
  final String type;
  final String title;
  final String date;
  final String size;
  final Color iconColor;

  const DocumentItem({
    super.key,
    required this.type,
    required this.title,
    required this.date,
    required this.size,
    required this.iconColor,
  });

  String _getIconAsset() {
    switch (type.toUpperCase()) {
      case 'PDF':
        return TImages.pdf;
      case 'DOCX':
        return TImages.docx;
      case 'XLS':
        return TImages.xls;
      case 'SVG':
        return TImages.svg;
      case 'JPG':
        return TImages.jpg;
      default:
        return TImages.defaultFile;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // 👉 Chuyển đến trang chi tiết
        // Get.to(() => DocumentDetailPage());
      },
      child: Container(
        margin: EdgeInsets.only(bottom: 12),
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Color(0xFFECECEC),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.1),
              spreadRadius: 2,
              blurRadius: 5,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              padding: EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: iconColor,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Image.asset(
                _getIconAsset(),
                width: 32,
                height: 32,
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 4),
                  Text(
                    '$date | $size',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            ),
            Icon(Icons.more_vert, color: Colors.grey),
          ],
        ),
      ),
    );
  }
}