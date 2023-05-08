import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:griffinman/view/screens/breakBreaker/breaker.dart';

class breakBreakerGame extends StatefulWidget {
  const breakBreakerGame({super.key});

  @override
  State<breakBreakerGame> createState() => _breakBreakerGameState();
}

enum moveDirection { up, down, left, right }

class _breakBreakerGameState extends State<breakBreakerGame> {
  moveDirection _ballDirectionY = moveDirection.down;
  moveDirection _ballDirectionX = moveDirection.right;
  double _ballx = 0;
  double _bally = 0;

  void startGame() {
    Timer.periodic(Duration(milliseconds: 10), (timer) {
      updateMovement();
      moveBall();
      playerDead(() {
        timer.cancel();
      });
      breakBreaker();
    });
  }

  void moveBall() {
    setState(() {
      if (_ballDirectionY == moveDirection.up) {
        _bally -= 0.01;
      } else if (_ballDirectionY == moveDirection.down) {
        _bally += 0.01;
      }

      if (_ballDirectionX == moveDirection.left) {
        _ballx -= 0.01;
      } else if (_ballDirectionX == moveDirection.right) {
        _ballx += 0.01;
      }
    });
  }

  void updateMovement() {
    setState(() {
      if (_bally >= 0.9 &&
          (_ballx > _playerx && _ballx < _playerx + _playerWidth)) {
        _ballDirectionY = moveDirection.up;
      } else if (_bally <= -1.0) {
        _ballDirectionY = moveDirection.down;
      }
      if (_ballx >= 1) {
        _ballDirectionX = moveDirection.left;
      } else if (_ballx <= -1.0) {
        _ballDirectionX = moveDirection.right;
      }
    });
  }

  void playerDead(Function fun) {
    if (!((_ballx > _playerx && _ballx < _playerx + _playerWidth) ||
        _bally <= 1.0)) {
      fun();
      setState(() {
        _playerIsDead = true;
      });
    }
  }

  void breakBreaker() {
  
    if ((_ballx > -0.4 && _ballx < 0.4) &&
        _bally < -0.6 && _breakBroken == false) {
      setState(() {
        _breakBroken = true;
        _ballDirectionY = moveDirection.down;
      });
    }
  }

  bool _breakBroken = false;
  double _playerx = 0;
  bool _isGameStart = false;
  double _playerWidth = 0.5;
  bool _playerIsDead = false;
  @override
  Widget build(BuildContext context) {
    double _leftBoundry = _playerx;
    double _rightBoundry = _playerx + _playerWidth;
    var deviSize = MediaQuery.of(context).size;
    return Scaffold(
      body: RawKeyboardListener(
        autofocus: true,
        focusNode: FocusNode(),
        onKey: (value) {
          if (value.isKeyPressed(LogicalKeyboardKey.arrowLeft)) {
            if (_leftBoundry >= -1) {
              setState(() {
                _playerx -= 0.04;
              });
            }
          } else if (value.isKeyPressed(LogicalKeyboardKey.arrowRight)) {
            if (_rightBoundry <= 1) {
              setState(() {
                _playerx += 0.04;
              });
            }
          }
        },
        child: Stack(
          children: [
            Align(
              alignment: Alignment(_ballx, _bally),
              child: Container(
                height: 10,
                width: 10,
                decoration:
                    BoxDecoration(shape: BoxShape.circle, color: Colors.green),
              ),
            ),
            Align(
              alignment: Alignment(
                  (2 * _playerx + _playerWidth) / (2 - _playerWidth), 0.9),
              child: Container(
                width: deviSize.width * _playerWidth / 2,
                height: 10,
                decoration: BoxDecoration(
                    color: Colors.brown,
                    borderRadius: BorderRadius.circular(10)),
              ),
            ),
            if (!_isGameStart)
              Align(
                alignment: Alignment(0, -0.1),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _isGameStart = true;
                      startGame();
                    });
                  },
                  child: Container(
                    width: deviSize.width * 0.20,
                    height: 10,
                    child: Text('S T A R T G A M E'),
                  ),
                ),
              ),
            Align(
              alignment: Alignment(0, -0.6),
              child: breaker(_breakBroken, 100, 10),
            )
          ],
        ),
      ),
    );
  }
}
