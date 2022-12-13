import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maze_runner/screens/five_player_maze.dart';
import 'package:maze_runner/screens/four_player_maze.dart';
import 'package:maze_runner/screens/maze_generator.dart';

import 'package:maze_runner/screens/six_player_maze.dart';
import 'package:maze_runner/screens/three_player_maze.dart';
import 'package:maze_runner/screens/two_player_maze.dart';

class WebFirstScreen extends StatefulWidget {
  final int? gameID;
  const WebFirstScreen({this.gameID});

  @override
  State<WebFirstScreen> createState() => _WebFirstScreenState();
}

class _WebFirstScreenState extends State<WebFirstScreen> {
  late int id;
  var ref = FirebaseDatabase.instance.ref();
  int noOfPlayers = 0;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    if (widget.gameID == null) {
      id = 100000 + Random().nextInt(899999);
      ref.child(id.toString()).set("");
      ref.child(id.toString()).onValue.listen((event) {
        if (event.snapshot.exists) {
          int noOfNodes = event.snapshot.children.length;

          if ((noOfPlayers < noOfNodes)) {
            if (noOfNodes == 1) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => MazeGenerator(id.toString())));
            } else if (noOfNodes == 2) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => TwoPlayerMaze(id.toString())));
            } else if (noOfNodes == 3) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ThreePlayerMaze(id.toString())));
            } else if (noOfNodes == 4) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FourPlayerMaze(id.toString())));
            } else if (noOfNodes == 5) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => FivePlayerMaze(id.toString())));
            } else if (noOfNodes == 6) {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => SixPlayerMaze(id.toString())));
            }
            noOfPlayers++;
          }
        }
      });
    } else {
      id = widget.gameID!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(
          "Maze runner",
          style: GoogleFonts.josefinSans(fontSize: 30.sp),
        ),
        backgroundColor: Colors.black,
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 50.w, vertical: 8.h),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: const Color.fromARGB(255, 72, 80, 74),
              ),
              child: Padding(
                padding: EdgeInsets.all(4.0.h),
                child: Row(
                  children: [
                    SizedBox(
                      width: 5.w,
                    ),
                    Image.asset(
                      "assets/l.png",
                      width: 20.w,
                    ),
                    SizedBox(
                      width: 5.w,
                    ),
                    Text(
                      id.toString(),
                      style: GoogleFonts.josefinSans(fontSize: 30.sp),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 50.w, top: 10.h, bottom: 10.h),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.r),
                color: const Color.fromARGB(255, 72, 80, 74),
              ),
              child: IconButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => const WebFirstScreen()));
                },
                icon: const Icon(Icons.replay_outlined),
              ),
            ),
          ),
        ],
      ),
      body: Row(
        children: [
          Expanded(
            child: Container(
              color: Colors.blue,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Scan the QR Code",
                    style: GoogleFonts.josefinSans(
                        color: Colors.white,
                        fontSize: 27.sp,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 50.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset("assets/gameUrl.png", height: 300.w),
                      SizedBox(
                        width: 40.w,
                      ),
                      Image.asset("assets/maze.jpg", height: 250.w),
                    ],
                  ),
                  SizedBox(
                    height: 100.h,
                  ),
                  Text(
                    "Phone + Screen = Console",
                    style: GoogleFonts.josefinSans(
                        color: Colors.white,
                        fontSize: 27.sp,
                        fontWeight: FontWeight.bold),
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: Container(
              color: const Color.fromARGB(255, 49, 48, 48),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    "Connect your phone as a gamepads",
                    style: GoogleFonts.quicksand(
                        fontSize: 35.sp,
                        color: Colors.white,
                        letterSpacing: 1.w,
                        fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Open ",
                        style: GoogleFonts.josefinSans(
                            fontSize: 25.sp, color: Colors.white),
                      ),
                      Text(
                        " atechnosmedia.com/maze-runner",
                        style: GoogleFonts.josefinSans(
                            fontSize: 25.sp,
                            color: const Color.fromARGB(255, 0, 255, 34)),
                      ),
                      Text(
                        " in your phone",
                        style: GoogleFonts.josefinSans(
                            fontSize: 25.sp, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "and ",
                        style: GoogleFonts.josefinSans(
                            fontSize: 25.sp, color: Colors.white),
                      ),
                      Text(
                        "enter the code",
                        style: GoogleFonts.josefinSans(
                            fontSize: 25.sp,
                            color: const Color.fromARGB(255, 81, 255, 0)),
                      ),
                      Text(
                        " below",
                        style: GoogleFonts.josefinSans(
                            fontSize: 25.sp, color: Colors.white),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10.r),
                      color: const Color.fromARGB(255, 72, 80, 74),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(8.0.h),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Image.asset(
                            "assets/l.png",
                            width: 20.w,
                          ),
                          SizedBox(
                            width: 10.w,
                          ),
                          Text(
                            id.toString(),
                            style: GoogleFonts.josefinSans(
                              fontSize: 30.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30.h,
                  ),
                  Image.asset(
                    "assets/phone-in-hand.png",
                    height: 300.h,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
