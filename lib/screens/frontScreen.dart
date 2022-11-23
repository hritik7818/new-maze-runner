import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maze_runner/screens/keyboard.dart';

class FrontScreen extends StatefulWidget {
  const FrontScreen({super.key});

  @override
  State<FrontScreen> createState() => _FrontScreenState();
}

class _FrontScreenState extends State<FrontScreen> {
  final TextEditingController _nickname = TextEditingController();
  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 42, 42, 42),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 18.0.w, right: 18.w),
            child: Container(
              height: 87.h,
              width: screenWidth,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 0, 0, 0),
                borderRadius: BorderRadius.circular(12.r),
                border: Border.all(
                  width: 2.w,
                  color: Colors.blue,
                ),
              ),
              child: Center(
                child: TextField(
                  // maxLength: 6,
                  controller: _nickname,
                  cursorHeight: 40.h,
                  style: GoogleFonts.josefinSans(
                    fontSize: 40.sp,
                    color: Colors.white,
                    decoration: TextDecoration.none,
                  ),
                  maxLength: 8,
                  decoration: InputDecoration(
                      hintText: "Nickname",
                      hintStyle: GoogleFonts.josefinSans(
                          color: Colors.white.withOpacity(0.2),
                          fontSize: 40.sp,
                          fontWeight: FontWeight.w600),
                      contentPadding: EdgeInsets.only(
                        top: 20.h,
                        left: 18.w,
                        // bottom: 20.h,
                      ),
                      border: InputBorder.none),
                ),
              ),
            ),
          ),
          SizedBox(
            height: 40.h,
          ),
          Padding(
            padding: EdgeInsets.only(left: 18.0.w, right: 18.w),
            child: Container(
                height: 70.h,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: ElevatedButton(
                  onPressed: () {
                    FocusScope.of(context).unfocus();
                    _nickname.text.length > 3
                        ? Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Keyboard(
                                      nickname: _nickname.text.trim(),
                                    )))
                        : Fluttertoast.showToast(msg: "Please write your name");
                  },
                  style: ButtonStyle(
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0.r),
                    // side: BorderSide(color: Colors.red)
                  ))),
                  child: Text(
                    "Submit",
                    style: GoogleFonts.josefinSans(fontSize: 25.sp),
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
