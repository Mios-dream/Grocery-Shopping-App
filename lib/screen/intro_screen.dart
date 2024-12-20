import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:video_player/video_player.dart';

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  late VideoPlayerController _controller;
  ImageProvider introImage = const AssetImage('assets/images/intro.jpg');
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/videos/intro.mp4')
      ..initialize().then((_) {
        _controller.play();
        _controller.setLooping(true);
        setState(() {});
      });
    _navigateToHome();
  }

  void _navigateToHome() {
    timer = Timer(const Duration(seconds: 2), () {
      context.goNamed('home');
    });
  }

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    // ignore: unused_local_variable
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      body: Stack(
        children: <Widget>[
          SizedBox.expand(
            child: VideoPlayer(_controller),
          ),
          Center(
            child: Text(
              'GROCIFY',
              textAlign: TextAlign.center,
              style: textTheme.displayLarge!.copyWith(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
          // Positioned(
          //   bottom: 48.0,
          //   left: 16.0,
          //   right: 16.0,
          //   child: Column(
          //     children: [
          //       FilledButton(
          //         style: FilledButton.styleFrom(
          //           minimumSize: const Size(double.infinity, 48.0),
          //         ),
          //         onPressed: () {
          //           context.goNamed('register');
          //         },
          //         child: Text(
          //           'Login or Register',
          //           style: textTheme.titleMedium!.copyWith(
          //             color: Colors.white,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ),
          //       const SizedBox(height: 16.0),
          //       OutlinedButton(
          //         style: OutlinedButton.styleFrom(
          //           side: BorderSide(color: colorScheme.surface, width: 2),
          //           minimumSize: const Size(double.infinity, 48.0),
          //         ),
          //         onPressed: () => context.goNamed('home'),
          //         child: Text(
          //           'Shop as a Guest',
          //           style: textTheme.titleMedium!.copyWith(
          //             color: Colors.white,
          //             fontWeight: FontWeight.bold,
          //           ),
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }
}
