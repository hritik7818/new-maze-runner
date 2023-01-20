import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maze_runner/screens/controller.dart';

class Keyboard extends StatefulWidget {
  String nickname;
  Keyboard({super.key, required this.nickname});

  @override
  State<Keyboard> createState() => _KeyboardState();
}

class _KeyboardState extends State<Keyboard> {
  final TextEditingController _text = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    print(_text.text);
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;
    var screenWidth = MediaQuery.of(context).size.width;

    var size = MediaQuery.of(context).size;

    final double itemHeight = (size.height - kToolbarHeight - 24) / 2;
    final double itemWidth = size.width / 2;
    // List<String> = []

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 42, 42, 42),
      body: Padding(
        padding: EdgeInsets.all(8.0.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.transparent,
                  boxShadow: [
                    BoxShadow(
                      offset: const Offset(0, 1),
                      color: const Color.fromARGB(255, 0, 0, 0),
                      blurRadius: 8.0.r,
                    ),
                  ]),
              child: Image(
                image: const AssetImage("assets/man1.png"),
                height: 120.h,
                width: 120.w,
              ),
            ),
            SizedBox(
              height: 20.h,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "Hello ",
                  style: GoogleFonts.josefinSans(
                      color: Colors.green,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600),
                ),
                Text(
                  widget.nickname,
                  style: GoogleFonts.josefinSans(
                      color: Colors.white,
                      fontSize: 30.sp,
                      fontWeight: FontWeight.w600),
                ),
              ],
            ),
            SizedBox(
              height: 50.h,
            ),
            SizedBox(
              height: 10.h,
            ),
            Padding(
              padding: EdgeInsets.only(left: 20.0.w, right: 24.w),
              child: Container(
                height: 70.h,
                width: screenWidth,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 0, 0, 0),
                  borderRadius: BorderRadius.circular(12.sp),
                  border: Border.all(
                    width: 2.w,
                    color: Colors.blue,
                  ),
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 18.0.w),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image(
                        image: const AssetImage("assets/l.png"),
                        height: 30.h,
                        width: 30.w,
                      ),
                      SizedBox(
                        width: 20.w,
                      ),
                      Expanded(
                        child: Center(
                          child: TextField(
                            showCursor: _text.text.isEmpty ? true : false,
                            keyboardType: TextInputType.none,
                            maxLength: 6,
                            controller: _text,
                            cursorHeight: 40.h,
                            style: GoogleFonts.josefinSans(
                                fontSize: 40.sp, color: Colors.white),
                            decoration: InputDecoration(
                                hintText: "Code",
                                alignLabelWithHint: true,
                                hintStyle: GoogleFonts.josefinSans(
                                    color: Colors.white.withOpacity(0.2),
                                    fontSize: 40.sp,
                                    fontWeight: FontWeight.w600),
                                contentPadding: EdgeInsets.only(bottom: -20.h),
                                border: InputBorder.none),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 30.h,
            ),
            SizedBox(
                width: screenWidth,
                child: StaggeredGrid.count(
                    crossAxisCount: 3,
                    mainAxisSpacing: 10,
                    // crossAxisSpacing: 5,
                    children: [
                      "0",
                      "1",
                      "2",
                      "3",
                      "4",
                      "5",
                      "6",
                      "7",
                      "8",
                      "9",
                      "10",
                      "11",
                    ]
                        .map(
                          (e) => GestureDetector(
                            onTap: () {
                              if (_text.text.length <= 5) {
                                print(_text.text.length);
                                FocusScopeNode currentFocus =
                                    FocusScope.of(context);
                                if (e != "9" && e != "10" && e != "11") {
                                  setState(() {
                                    _text.text = _text.text +
                                        (int.parse(e) + 1).toString();
                                    print("text is ${_text.text}");
                                  });
                                } else if (e == "10") {
                                  setState(() {
                                    _text.text = "${_text.text}0";
                                  });
                                }
                              }
                              if (e == "9") {
                                setState(() {
                                  _text.text = _text.text
                                      .substring(0, _text.text.length - 1);
                                });
                              } else if (e == "11") {
                                //main code to navigator to the controller
                                var ref = FirebaseDatabase.instance.ref();

                                ref.child(_text.text).once().then((value) {
                                  if (value.snapshot.exists) {
                                    print(value.snapshot);
                                    Navigator.of(context).push(
                                        MaterialPageRoute(
                                            builder: (context) => MyController(
                                                gameID: _text.text,
                                                nickName: widget.nickname)));
                                  } else {
                                    Fluttertoast.showToast(msg: "invalid code");
                                  }
                                });

                                // ref.child(_text.text).onValue.listen(
                                //   (event) {
                                //     if (event.snapshot.exists) {
                                //       print(event.snapshot);
                                //       Navigator.of(context).push(
                                //           MaterialPageRoute(
                                //               builder: (context) =>
                                //                   MyController(_text.text)));
                                //     } else {
                                //       Fluttertoast.showToast(
                                //           msg: "invalid code");
                                //     }
                                //   },
                                // );
                              }
                            },
                            child: numberContainer(
                              int.parse(e),
                            ),
                          ),
                        )
                        .toList())),
          ],
        ),
      ),
    );
  }

  Widget numberContainer(int index) {
    return Padding(
      padding: EdgeInsets.only(bottom: 8.0.h),
      child: Container(
        height: 80.h,
        width: 80.w,
        decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color.fromARGB(255, 31, 31, 31),
            boxShadow: [
              BoxShadow(
                offset: const Offset(0, 4),
                color: Colors.blueAccent.withOpacity(0.5),
                blurRadius: 8.0.r,
              ),
            ]),
        child: Center(
          child: index < 9
              ? Text(
                  "${index + 1}".toString(),
                  style: GoogleFonts.josefinSans(
                      // fontWeight: FontWeight.w600,
                      fontSize: 30.sp,
                      color: Colors.white),
                )
              : index == 11
                  ? Image(
                      image: const AssetImage(
                        "assets/check.png",
                      ),
                      height: 20.h,
                      width: 20.w,
                      color: Colors.greenAccent,
                    )
                  : index == 10
                      ? Text(
                          "0".toString(),
                          style: TextStyle(
                              // fontWeight: FontWeight.w600,
                              fontSize: 30.sp,
                              color: Colors.white),
                        )
                      : Image(
                          image: const AssetImage("assets/close.png"),
                          color: Colors.redAccent,
                          height: 20.h,
                          width: 20.w,
                        ),
        ),
      ),
    );
  }
}
