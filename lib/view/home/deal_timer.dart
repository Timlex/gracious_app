import 'dart:async';

import 'package:flutter/material.dart';
import '../../view/utils/constant_colors.dart';

class DealTimer extends StatefulWidget {
  final DateTime? deadLine;
  String perioid;
  DealTimer(this.deadLine, this.perioid, {Key? key}) : super(key: key);
  bool fristInit = true;
  @override
  State<DealTimer> createState() => _DealTimerState();
}

class _DealTimerState extends State<DealTimer> {
  ConstantColors cc = ConstantColors();

  late Timer timer;
  int s = 0;
  int m = 0;
  int h = 0;

  void hourDecre() {
    if (h == 0 && m == 0) {
      m = 0;
      return;
    }
    if (m == 0) {
      m = 59;
      if (h == 0) {
        timer.cancel();
      }
      h--;
      return;
    }
    m--;
  }

  String get textString {
    if (widget.perioid == 'h') {
      return '${h}h';
    }
    if (widget.perioid == 'm') {
      return '${m}m';
    }
    return '${s}s';
  }

  @override
  void initState() {
    super.initState();
    if (widget.deadLine!.isBefore(DateTime.now()) || widget.deadLine == null) {
      timer.cancel();
      return;
    }

    if (widget.fristInit) {
      s = widget.deadLine!.second;
      m = widget.deadLine!.minute;
      h = widget.deadLine!.hour;
      widget.fristInit = false;
    }

    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (h == 0 && m == 0 && s == 0) {
          s = 0;
          return;
        }
        if (s == 0) {
          s = 59;
          hourDecre();
          return;
        }
        s--;
      });
    });
  }

  @override
  void dispose() {
    super.dispose();

    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        margin: const EdgeInsets.only(left: 3),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 7),
        decoration:
            BoxDecoration(border: Border.all(color: cc.greyBorder, width: 2)),
        child: Text(textString));
  }
}
