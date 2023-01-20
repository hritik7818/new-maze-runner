import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class TestPage extends StatefulWidget {
  const TestPage({
    super.key,
  });

  @override
  State<TestPage> createState() => _TestPageState();
}

class _TestPageState extends State<TestPage> {
  Timer? timer;
  int top = 0;
  int down = 0;
  int left = 0;
  int right = 0;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Joystick Controller"))
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onLongPress: () {
                timer =
                    Timer.periodic(const Duration(milliseconds: 30), (timer) {
                  Fluttertoast.showToast(msg: "move up");
                  top++;
                });
              },
              onLongPressUp: () {
                timer?.cancel();
                top = 0;
                Fluttertoast.showToast(msg: "move up stop");
              },
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(400)),
                child: const Icon(
                  Icons.arrow_upward_sharp,
                  size: 40,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                GestureDetector(
                  onLongPress: () {
                    timer = Timer.periodic(const Duration(milliseconds: 30),
                        (timer) {
                      Fluttertoast.showToast(msg: "move left");
                      left++;
                    });
                  },
                  onLongPressUp: () {
                    timer?.cancel();
                    left = 0;
                    Fluttertoast.showToast(msg: "move left stop");
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(400)),
                    child: const Icon(
                      Icons.arrow_back,
                      size: 40,
                    ),
                  ),
                ),
                const SizedBox(
                  width: 140,
                ),
                GestureDetector(
                  onLongPress: () {
                    timer = Timer.periodic(const Duration(milliseconds: 30),
                        (timer) {
                      Fluttertoast.showToast(msg: "move right");
                      right++;
                    });
                  },
                  onLongPressUp: () {
                    timer?.cancel();
                    right = 0;
                    Fluttertoast.showToast(msg: "move right stop");
                  },
                  child: Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                        color: Colors.orangeAccent,
                        borderRadius: BorderRadius.circular(400)),
                    child: const Icon(
                      Icons.arrow_forward,
                      size: 40,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            GestureDetector(
              onLongPress: () {
                timer =
                    Timer.periodic(const Duration(milliseconds: 30), (timer) {
                  Fluttertoast.showToast(msg: "move down");
                  down++;
                });
              },
              onLongPressUp: () {
                timer?.cancel();
                down = 0;
                Fluttertoast.showToast(msg: "move down stop");
              },
              child: Container(
                height: 100,
                width: 100,
                decoration: BoxDecoration(
                    color: Colors.orangeAccent,
                    borderRadius: BorderRadius.circular(400)),
                child: const Icon(
                  Icons.arrow_downward_sharp,
                  size: 40,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
