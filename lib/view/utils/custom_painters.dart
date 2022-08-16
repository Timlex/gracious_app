import 'package:flutter/material.dart';

import 'constant_styles.dart';

//Add this CustomPaint widget to the Widget Tree
// CustomPaint(
//     size: Size(WIDTH, (WIDTH*0.31155778894472363).toDouble()), //You can Replace [WIDTH] with your desired width for Custom Paint and height will be calculated automatically
//     painter: RPSCustomPainter(),
// )

//Copy this CustomPainter code to the Bottom of the File
class UserChatBubble extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width, 0);
    // path_0.cubicTo(
    //     size.width * 1.000678,
    //     size.height * 0.03201855,
    //     size.width * 0.9982965,
    //     size.height * 0.01876919,
    //     size.width * 0.9944724,
    //     size.height * 0.01865210);
    // path_0.lineTo(size.width, 0);
    path_0.lineTo(size.width * 0.8842663, 0);
    path_0.cubicTo(size.width * 0.8836683, 0, size.width * 0.8831005, 0,
        size.width * 0.8825829, 0);
    path_0.lineTo(size.width * 0.04020101, 0);
    path_0.cubicTo(
        size.width * 0.01799859, 0, 0, 0, 0, size.height * 0.1451616);
    path_0.lineTo(0, size.height * 0.8709677);
    path_0.cubicTo(0, size.height * 0.9422306, size.width * 0.01799864,
        size.height, size.width * 0.04020101, size.height);
    path_0.lineTo(size.width - 17, size.height);
    path_0.cubicTo(
      size.width - 10,
      size.height,
      size.width - 10,
      size.height * 0.9422306,
      size.width - 10,
      size.height * 0.8709677,
    );
    path_0.lineTo(size.width - 10, /*size.height * 0.3215032*/ 15);
    path_0.lineTo(size.width, 0);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = cc.primaryColor;
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

//Copy this CustomPainter code to the Bottom of the File
class AdminChatBubble extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Path path_0 = Path();
    path_0.moveTo(size.width * 0.04545455, 15);
    path_0.lineTo(size.width * 0.003944217, 0);
    path_0.cubicTo(
        size.width * 0.001927253,
        size.height * 0.01913276,
        size.width * 0.004336323,
        size.height * 0.002197680,
        size.width * 0.008253990,
        size.height * 0.002136340);
    path_0.lineTo(size.width * 0.08133384, size.height * 0.0009921280);
    path_0.cubicTo(size.width * 0.08281919, size.height * 0.0003366040,
        size.width * 0.08432879, 0, size.width * 0.08585859, 0);
    path_0.lineTo(size.width * 0.9595960, 0);
    path_0.cubicTo(size.width * 0.9819091, 0, size.width,
        size.height * 0.07163440, size.width, size.height * 0.1600000);
    path_0.lineTo(size.width, size.height * 0.8400000);
    path_0.cubicTo(size.width, size.height * 0.9283660, size.width * 0.9819091,
        size.height, size.width * 0.9595960, size.height);
    path_0.lineTo(size.width * 0.08585859, size.height);
    path_0.cubicTo(
        size.width * 0.06354394,
        size.height,
        size.width * 0.04545455,
        size.height * 0.9283660,
        size.width * 0.04545455,
        size.height * 0.8400000);
    path_0.lineTo(size.width * 0.04545455, size.height * 0.3061560);
    path_0.close();

    Paint paint0Fill = Paint()..style = PaintingStyle.fill;
    paint0Fill.color = const Color(0xffEFEFEF);
    canvas.drawPath(path_0, paint0Fill);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}

class RPSCustomPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint0 = Paint()
      ..color = const Color.fromARGB(255, 33, 150, 243)
      ..style = PaintingStyle.fill
      ..strokeWidth = 1.0;

    Path path0 = Path();
    path0.moveTo(99.0, 100.0);
    path0.quadraticBezierTo(50.38, 100.29, 50.0, 151.0);
    path0.quadraticBezierTo(50.25, 301.75, 50.0, 352.0);
    path0.cubicTo(49.85, 370.26, 50.81, 399.53, 100.9, 399.8);
    path0.cubicTo(238.4, 400.3, 510.84, 398.68, 650.0, 400.0);
    path0.cubicTo(689.77, 399.66, 699.83, 379.61, 700.0, 350.0);
    path0.quadraticBezierTo(699.25, 312.0, 700.0, 198.0);
    path0.lineTo(798.0, 99.0);
    path0.quadraticBezierTo(623.25, 99.25, 99.0, 100.0);
    path0.close();

    canvas.drawPath(path0, paint0);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
