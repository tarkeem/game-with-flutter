import 'dart:async';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:griffinman/constants.dart';

enum moveDirection { left, top, right, bottom }

class griffinGmae extends StatefulWidget {
  const griffinGmae({super.key});

  @override
  State<griffinGmae> createState() => _griffinGmaeState();
}

class _griffinGmaeState extends State<griffinGmae>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  int ColumnNum = 11;
  int RowNum = 16;
  int score = 0;
  List<int> barriers = [
    1,
    2,
    3,
    4,
    5,
    6,
    7,
    8,
    9,
    10,
    0,
    11,
    22,
    33,
    44,
    55,
    66,
    77,
    88,
    99,
    110,
    121,
    132,
    143,
    154,
    165,
    166,
    167,
    168,
    169,
    170,
    171,
    172,
    173,
    174,
    175,
    164,
    153,
    142,
    131,
    120,
    109,
    98,
    87,
    76,
    65,
    54,
    43,
    32,
    21,
    86,
    84,
    81,
    80,
    83,
    78,
    97,
    95,
    94,
    92,
    91,
    89,
    72,
    61,
    39,
    28,
    70,
    59,
    37,
    26,
    103,
    114,
    136,
    147,
    105,
    116,
    138,
    149,
    112,
    123,
    134,
    145,
    118,
    129,
    140,
    151,
    57,
    46,
    35,
    24,
    30,
    41,
    52,
    63
  ];

  List<int> MyPath = [];

  int myplayer = 155;
  int myEnemy = 12;

  moveDirection myDirection = moveDirection.right;
  bool GameOver = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _animationController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _animationController.repeat();
  }

  late Timer gostTimer;
  void StartGame() {
    Timer.periodic(
      Duration(milliseconds: 150),
      (timer) {
        if (myEnemy == myplayer) {
          setState(() {
            GameOver = true;
            myplayer = -1;
            myEnemy = -1;
          });
          timer.cancel();
          gostTimer.cancel();
        }
        feedMe();
        switch (myDirection) {
          case moveDirection.right:
            moveRight();
            break;
          case moveDirection.left:
            moveLeft();
            break;
          case moveDirection.top:
            moveTop();
            break;
          case moveDirection.bottom:
            moveBottom();
            break;
          default:
            print('error');
            break;
        }
      },
    );
  }

  void StartGameAsGost() {
    gostTimer = Timer.periodic(
      Duration(milliseconds: 600),
      (timer) {
        List<int> moveCordinate = [];

        if (!barriers.contains(myEnemy + 1)) {
          moveCordinate.add(1);
        }

        if (!barriers.contains(myEnemy - 1)) {
          moveCordinate.add(-1);
        }

        if (!barriers.contains(myEnemy - ColumnNum)) {
          moveCordinate.add(-ColumnNum);
        }
        if (!barriers.contains(myEnemy + ColumnNum)) {
          moveCordinate.add(ColumnNum);
        }

        int randomMove = Random().nextInt(moveCordinate.length);
        setState(() {
          myEnemy += moveCordinate[randomMove];
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    var deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Colors.pink,
      body: Stack(
        children: [
          Column(
            children: [
              Expanded(
                  flex: 8,
                  child: GestureDetector(
                    onHorizontalDragUpdate: (details) {
                      if (details.primaryDelta! > 0) {
                        setState(() {
                          myDirection = moveDirection.right;
                        });
                      } else {
                        setState(() {
                          myDirection = moveDirection.left;
                        });
                      }
                    },
                    onVerticalDragUpdate: (details) {
                      if (details.primaryDelta! < 0) {
                        setState(() {
                          myDirection = moveDirection.top;
                        });
                      } else {
                        setState(() {
                          myDirection = moveDirection.bottom;
                        });
                      }
                    },
                    child: Container(
                      child: GridView.builder(
                        shrinkWrap: false,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: ColumnNum * RowNum,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                            mainAxisExtent: (deviceSize.height *
                                0.875 /
                                RowNum), //to make the grid take all screen
                            mainAxisSpacing: 1,
                            crossAxisSpacing: 1,
                            crossAxisCount: ColumnNum),
                        itemBuilder: (context, index) {
                          if (barriers.contains(index)) {
                            return house(index);
                          } else if (index == myEnemy) {
                            return Container(
                                child: Transform.scale(
                                    scale: 2,
                                    child: Image.asset(
                                      'assets/characters/bull.png',
                                    )));
                          } else if (index == myplayer) {
                            return Container(
                                child: Container(
                                    child: Transform.scale(
                              scale: 1.5,
                              child: Image.asset('assets/characters/peter.png'),
                            )));
                          } else if (!MyPath.contains(index)) {
                            return Container(
                              padding: EdgeInsets.all(8),
                              child: Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: AnimatedBuilder(
                                  animation: _animationController,
                                  builder: (context, child) => Transform(
                                    alignment: Alignment.center,
                                    transform: Matrix4.identity()
                                      ..setEntry(3, 2, 0.01)
                                      ..rotateY(
                                          pi * _animationController.value),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color:
                                              Color.fromARGB(255, 251, 255, 0),
                                          shape: BoxShape.circle),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          } else {
                            return Container(
                              color: Colors.pink,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  )),
              Expanded(child: LayoutBuilder(builder: (p0, p1) {
                return Container(
                  decoration: BoxDecoration(
                      color: Color.fromARGB(255, 0, 0, 0),
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(15),
                          topRight: Radius.circular(15))),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Score:$score',
                        style: Constantss().normalStayle,
                      ),
                      GestureDetector(
                          onTap: () {
                            StartGame();
                            StartGameAsGost();
                          },
                          child: Text(
                            'Play',
                            style: Constantss().normalStayle,
                          ))
                    ],
                  ),
                );
              }))
            ],
          ),
          if (GameOver)
            Align(
              alignment: Alignment.center,
              child: TweenAnimationBuilder<double>(
                  duration: Duration(milliseconds: 1000),
                  tween: Tween(begin: 0, end: 1),
                  curve: Curves.bounceOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        color: Colors.black.withOpacity(0.7),
                        height: deviceSize.height * 0.5,
                        width: deviceSize.width * 0.70,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              Text(
                                'G A M E O V E R',
                                style: Constantss().normalStayle,
                              ),
                              GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      GameOver = false;
                                      myEnemy = 12;
                                      myplayer = 155;
                                      score = 0;
                                      MyPath = [];
                                      myDirection = moveDirection.right;
                                    });
                                  },
                                  child: Text(
                                    'T R Y A G A I N',
                                    style: Constantss().normalStayle,
                                  )),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
            ),
        ],
      ),
    );
  }

  void moveRight() {
    if (!barriers.contains(myplayer + 1)) {
      setState(() {
        myplayer++;
      });
    }
  }

  void moveLeft() {
    if (!barriers.contains(myplayer - 1)) {
      setState(() {
        myplayer--;
      });
    }
  }

  void moveTop() {
    if (!barriers.contains(myplayer - ColumnNum)) {
      setState(() {
        myplayer -= ColumnNum;
      });
    }
  }

  void moveBottom() {
    if (!barriers.contains(myplayer + ColumnNum)) {
      setState(() {
        myplayer += ColumnNum;
      });
    }
  }

  void feedMe() {
    if (!MyPath.contains(myplayer)) {
      MyPath.add(myplayer);
      setState(() {
        score++;
      });
    }
  }

  Widget house(int index) {
    int rand = index % 3;
    if (rand == 0) {
      return Container(child: Image.asset('assets/barriers/house1.png'));
    } else if (rand == 1) {
      return Container(child: Image.asset('assets/barriers/house2.png'));
    } else {
      return Container(child: Image.asset('assets/barriers/house3.png'));
    }
  }
}
