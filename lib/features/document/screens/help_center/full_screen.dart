import 'package:flutter/material.dart';
import 'package:iconsax/iconsax.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../../utils/constants/colors.dart';

class VideoFullScreenPage extends StatefulWidget {
  final YoutubePlayerController controller;
  final String title;

  const VideoFullScreenPage({
    Key? key,
    required this.controller,
    required this.title,
  }) : super(key: key);

  @override
  _VideoFullScreenPageState createState() => _VideoFullScreenPageState();
}

class _VideoFullScreenPageState extends State<VideoFullScreenPage> {
  @override
  void initState() {
    super.initState();
    // Ensure video continues playing
    widget.controller.play();
  }

  @override
  void dispose() {
    // Pause video when exiting
    widget.controller.pause();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          widget.title,
          style: TextStyle(
            color: Colors.white,
            fontSize: screenSize.width * 0.05,
          ),
        ),
        backgroundColor: TColors.primary,
        iconTheme: const IconThemeData(color: Colors.white),
        leading: IconButton(
          icon: const Icon(Iconsax.arrow_left_24),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: YoutubePlayer(
          controller: widget.controller,
          showVideoProgressIndicator: true,
          progressIndicatorColor: TColors.primary,
          progressColors: ProgressBarColors(
            playedColor: TColors.primary,
            handleColor: TColors.primary,
          ),
          aspectRatio: 16 / 9,
        ),
      ),
    );
  }
}