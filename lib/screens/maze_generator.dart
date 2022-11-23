import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:maze_runner/screens/web_first_screen.dart';

import '../constants.dart';
import '../models/cell.dart';

class MazeGenerator extends StatefulWidget {
  final String gameID;
  const MazeGenerator(this.gameID);

  @override
  State<MazeGenerator> createState() => _MazeGeneratorState();
}

class _MazeGeneratorState extends State<MazeGenerator> {
  var ref = FirebaseDatabase.instance.ref();

  // JoystickMode _joystickMode = JoystickMode.horizontalAndVertical;

  // Timer? _timer2;
  String playerName = "hritik";
  late List<Cell> cells;
  late final Timer _timer;
  late int _currentStep;
  final row = height ~/ spacing;
  final cols = width ~/ spacing;
  final List<Cell> stack = [];
  bool _isCompleted = false;
  bool _isWin = false;

  int difficulty = Random().nextInt(3);

  @override
  void initState() {
    print(difficulty);
    super.initState();
    ref.child("${widget.gameID}/P1/x").onValue.listen((event) {
      if (event.snapshot.exists) {
        var value = event.snapshot.value.toString();

        // if joystick moves left
        if (double.parse(value) < 0) {
          _onScreenKeyEvent('left');
        }

        //if joystick moves right
        if (double.parse(value) > 0) {
          _onScreenKeyEvent('right');
        }
      }
    });
    ref.child("${widget.gameID}/P1/y").onValue.listen((event) {
      if (event.snapshot.exists) {
        var value = event.snapshot.value.toString();

        // if joystick moves up
        if (double.parse(value) < 0) {
          _onScreenKeyEvent('up');
        }

        // if joystick moves down
        if (double.parse(value) > 0) {
          _onScreenKeyEvent('down');
        }
      }
    });
    reset();
    getPlayerName();
  }

  List<Cell> getCells() {
    List<Cell> cells = [];
    for (int i = 0; i < row; i++) {
      for (int j = 0; j < cols; j++) {
        cells.add(Cell(j, i));
      }
    }
    return cells;
  }

  int? getIndex(int i, int j) {
    if (i < 0 || j < 0 || i > row - 1 || j > cols - 1) {
      return null;
    }
    return i + (j * (width ~/ spacing));
  }

  List<Cell> checkNeighbours(Cell cell) {
    List<Cell> neighbours = [];
    int? top = getIndex(cell.i, cell.j - 1);
    int? bottom = getIndex(cell.i, cell.j + 1);
    int? left = getIndex(cell.i - 1, cell.j);
    int? right = getIndex(cell.i + 1, cell.j);
    if (top != null && !cells[top].visited) {
      neighbours.add(cells[top]);
    }
    if (right != null && !cells[right].visited) {
      neighbours.add(cells[right]);
    }
    if (bottom != null && !cells[bottom].visited) {
      neighbours.add(cells[bottom]);
    } else if (left != null && !cells[left].visited) {
      neighbours.add(cells[left]);
    }
    return neighbours;
  }

  void reset() {
    stack.clear();
    _isCompleted = false;
    _isWin = false;
    cells = getCells();
    _currentStep = 0;
    cells[_currentStep].visited = true;
    _timer = Timer.periodic(const Duration(milliseconds: 100), updateCell);
  }

  void updateCell(Timer timer) {
    for (int i = 0; i < 15; i++) {
      var neighbours = checkNeighbours(cells[_currentStep]);
      if (neighbours.isEmpty) {
        if (stack.isNotEmpty) {
          var lastCell = stack.removeLast();
          // setState(() {
          _currentStep = getIndex(lastCell.i, lastCell.j)!;
          // });
        } else {
          _timer.cancel();
          // setState(() {
          _isCompleted = true;
          // });
        }
      } else {
        var random = Random().nextInt(neighbours.length);
        var next = neighbours[random];
        stack.add(cells[_currentStep]);
        // setState(() {
        next.visited = true;
        removeWalls(cells[_currentStep], next);
        // });
        _currentStep = getIndex(next.i, next.j)!;
      }
    }
    setState(() {});
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  removeWalls(Cell current, Cell next) {
    if (current.j - next.j == 1) {
      current.left = false;
      next.right = false;
    } else if (current.j - next.j == -1) {
      current.right = false;
      next.left = false;
    } else if (current.i - next.i == 1) {
      current.top = false;
      next.bottom = false;
    } else if (current.i - next.i == -1) {
      current.bottom = false;
      next.top = false;
    }
  }

  void _onScreenKeyEvent(String key) {
    if (!_isCompleted || _isWin) {
      return;
    }
    setState(() {
      if (key == 'up' && !cells[_currentStep].top) {
        _currentStep =
            getIndex(cells[_currentStep].i - 1, cells[_currentStep].j)!;
      } else if (key == 'down' && !cells[_currentStep].bottom) {
        _currentStep =
            getIndex(cells[_currentStep].i + 1, cells[_currentStep].j)!;
      } else if (key == 'left' && !cells[_currentStep].left) {
        _currentStep =
            getIndex(cells[_currentStep].i, cells[_currentStep].j - 1)!;
      } else if (key == 'right' && !cells[_currentStep].right) {
        _currentStep =
            getIndex(cells[_currentStep].i, cells[_currentStep].j + 1)!;
      }
    });
    if (_currentStep == getIndex(0, row - 1)) {
      setState(() {
        _isWin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          title: Text(
            "Single Player Maze runner",
            style: GoogleFonts.josefinSans(fontSize: 30),
          ),
          centerTitle: true,
          backgroundColor: Colors.black,
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        WebFirstScreen(gameID: int.parse(widget.gameID))));
              },
              child: Padding(
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
                        Image.asset(
                          "assets/smartphone.png",
                          width: 50.w,
                          color: Colors.blue,
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                        Text(
                          "Add more phones",
                          style: GoogleFonts.josefinSans(fontSize: 28.sp),
                        ),
                        SizedBox(
                          width: 5.w,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
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
                        width: 20,
                      ),
                      SizedBox(
                        width: 5.w,
                      ),
                      Text(
                        widget.gameID,
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
        backgroundColor: Colors.blue,
        body: Container(
          child: SafeArea(
            child: Padding(
              padding: EdgeInsets.all(15.0.h),
              child: Center(
                  child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    child: Container(
                      margin: EdgeInsets.only(right: 30.w),
                      color: const Color.fromARGB(255, 0, 0, 0),
                      height: height,
                      width: width,
                      child: Stack(
                        children: List.generate(
                          cells.length,
                          (index) => Positioned(
                            top: cells[index].x,
                            left: cells[index].y,
                            child: Container(
                                height: spacing,
                                width: spacing,
                                decoration: BoxDecoration(
                                  border: Border(
                                    right: cells[index].right
                                        ? BorderSide(
                                            color: Colors.white, width: 1.w)
                                        : BorderSide.none,
                                    bottom: cells[index].bottom
                                        ? BorderSide(
                                            color: Colors.white, width: 1.w)
                                        : BorderSide.none,
                                    left: cells[index].left
                                        ? BorderSide(
                                            color: Colors.white, width: 1.w)
                                        : BorderSide.none,
                                    top: cells[index].top
                                        ? BorderSide(
                                            color: Colors.white, width: 1.w)
                                        : BorderSide.none,
                                  ),
                                  // image: DecorationImage(image: AssetImage("assets/runner.png")),
                                  color: index == _currentStep && _isCompleted
                                      ? const Color.fromARGB(255, 47, 0, 122)
                                      // : cells[index].visited
                                      //     ? Colors.purple.withOpacity(0.5)
                                      : (index == 0 ||
                                              index == getIndex(0, row - 1))
                                          ? const Color.fromARGB(
                                              255, 167, 150, 150)
                                          : Colors.transparent,
                                ),
                                padding: EdgeInsets.all(2.h),
                                child: FittedBox(
                                  fit: BoxFit.scaleDown,
                                  child: index == 0
                                      ? Text(
                                          'Start',
                                          style: GoogleFonts.josefinSans(
                                            color: Colors.green,
                                            fontSize: 25.sp,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        )
                                      : index == getIndex(0, row - 1)
                                          ? Text(
                                              'End',
                                              style: GoogleFonts.josefinSans(
                                                color: Colors.red,
                                                fontSize: 25.sp,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            )
                                          : null,
                                )),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  Text(
                    _isWin
                        ? 'You Win !!'
                        : _isCompleted
                            ? 'Maze Generation Completed'
                            : 'Generating Maze...',
                    style: TextStyle(color: Colors.white, fontSize: 22.sp),
                  ),
                  SizedBox(
                    height: 15.h,
                  ),
                  _isWin
                      ? MaterialButton(
                          elevation: 0,
                          color: Colors.white,
                          onPressed: () {
                            setState(() {
                              reset();
                            });
                          },
                          child: Text(
                            'Generate Another Maze',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 20.sp),
                          ),
                        )
                      : _isCompleted
                          ? const Text(
                              'Press arrow keys to play.',
                              style: TextStyle(color: Colors.white),
                            )
                          : const SizedBox(),
                ],
              )),
            ),
          ),
        ));
  }

  void getPlayerName() async {
    ref.child("${widget.gameID}/P1/name").once().then((value) {
      if (value.snapshot.exists) {
        playerName = value.snapshot.value as String;
      }
    });
  }
}
