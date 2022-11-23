import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:maze_runner/screens/frontScreen.dart';
import 'package:maze_runner/screens/web_first_screen.dart';

class CheckScreen extends StatelessWidget {
  const CheckScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MediaQuery.of(context).size.width > 900
          ? ScreenUtilInit(
              builder: (_, child) => const WebFirstScreen(),
              designSize: const Size(1440, 1024),
            )
          : ScreenUtilInit(
              builder: (_, child) => const FrontScreen(),
              designSize: const Size(414, 896),
            ),
    );
  }
}
