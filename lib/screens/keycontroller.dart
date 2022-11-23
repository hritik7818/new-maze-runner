import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class Keycontroller extends StatefulWidget {
  final String gameID;
  final String nickName;
  final String player;
  final DatabaseReference ref;
  const Keycontroller(
      {super.key,
      required this.gameID,
      required this.nickName,
      required this.player,
      required this.ref});

  @override
  State<Keycontroller> createState() => _KeycontrollerState();
}

class _KeycontrollerState extends State<Keycontroller> {
  Timer? timer;
  int i = 0;
  @override
  void initState() {
    // TODO: implement initState
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
              onPanDown: (_) {
                timer =
                    Timer.periodic(const Duration(milliseconds: 30), (timer) {
                  setValueYOfPlayer(-i.toDouble());
                  i++;
                });
              },
              onPanEnd: (KeycontrollerState) {
                timer?.cancel();
                i = 0;
                setDefaultValuesOfPlayer();
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
                  onPanDown: (_) {
                    timer = Timer.periodic(const Duration(milliseconds: 30),
                        (timer) {
                      setValueXOfPlayer(-i.toDouble());
                      i++;
                    });
                  },
                  onPanEnd: (_) {
                    timer?.cancel();
                    i = 0;
                    setDefaultValuesOfPlayer();
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
                  onPanDown: (_) {
                    timer = Timer.periodic(const Duration(milliseconds: 30),
                        (timer) {
                      setValueXOfPlayer(i.toDouble());
                      i++;
                    });
                  },
                  onPanEnd: (_) {
                    timer?.cancel();
                    i = 0;
                    setDefaultValuesOfPlayer();
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
              onPanDown: (_) {
                timer =
                    Timer.periodic(const Duration(milliseconds: 30), (timer) {
                  setValueYOfPlayer(i.toDouble());
                  i++;
                });
              },
              onPanEnd: (_) {
                timer?.cancel();
                i = 0;
                setDefaultValuesOfPlayer();
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

  void setValueXOfPlayer(double x1) async {
    await widget.ref
        .child("${widget.gameID}/${widget.player}")
        .update({"x": x1.toString()});
  }

  void setValueYOfPlayer(double y1) async {
    await widget.ref
        .child("${widget.gameID}/${widget.player}")
        .update({"y": y1.toString()});
  }

  void setDefaultValuesOfPlayer() async {
    await widget.ref
        .child("${widget.gameID}/${widget.player}")
        .set({"name": widget.nickName, "x": "0", "y": "0"});
    // await widget.ref.child("${widget.gameID}/a").remove();
  }
}
