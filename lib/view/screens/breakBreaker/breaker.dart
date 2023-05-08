import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class breaker extends StatefulWidget {
  bool breaked;
  double breakWidth;
 double breakHeigh;
  breaker(this.breaked,this.breakWidth,this.breakHeigh);

  @override
  State<breaker> createState() => _breakerState();
}

class _breakerState extends State<breaker> {
  @override
  Widget build(BuildContext context) {
    return widget.breaked?SizedBox():Container(
      color: Colors.brown,
      width: widget.breakWidth,
      height: widget.breakHeigh,
    );
  }
}