import 'package:flutter/painting.dart';
import 'package:flutter/material.dart';
import '../Models/ArcItem.dart';
import 'dart:math' as math;
import 'dart:math';
import '../WeighScale.dart';
import 'dart:ui';

// draw the arc and other stuff
class ChooserPainter extends CustomPainter {
  //debugging Paint
  final debugPaint = new Paint()
    ..color = Colors.red.withAlpha(100) //0xFFF9D976
    ..strokeWidth = 1.0
    ..style = PaintingStyle.stroke;

  final linePaint = new Paint()
    ..color = Colors.black.withAlpha(65) //0xFFF9D976
    ..strokeWidth = 2.0
    ..style = PaintingStyle.stroke
    ..strokeCap = StrokeCap.square;

  final whitePaint = new Paint()
    ..color = Colors.white //0xFFF9D976
    ..strokeWidth = 1.0
    ..style = PaintingStyle.fill;

  // List<ArcItem> arcItems;
  List arcItems;
  double angleInRadians;
  double angleInRadiansByTwo;
  double angleInRadians1;
  double angleInRadians2;
  double angleInRadians3;
  double angleInRadians4;
  double selectedAngle;
  String selectedValue;
  // ChooserPainter(List arcItems, double angleInRadians) {
  ChooserPainter(List<ArcItem> arcItems, double angleInRadians,
      double selectedAngle, String selectedValue) {
    this.arcItems = arcItems;
    this.angleInRadians = angleInRadians;
    this.angleInRadiansByTwo = angleInRadians / 2;
    this.selectedAngle = selectedAngle;
    this.selectedValue = selectedValue ?? '0';

    angleInRadians1 = angleInRadians / 6;
    angleInRadians2 = angleInRadians / 3;
    angleInRadians3 = angleInRadians * 4 / 6;
    angleInRadians4 = angleInRadians * 5 / 6;
    print(selectedAngle);
    print(selectedValue);
    print(angleInRadians);
  }

  @override
  void paint(Canvas canvas, Size size) {
    //common calc
    double centerX = size.width / 2;
    double centerY = size.height * 1.6;
    Offset center = Offset(centerX, centerY);
    double radius = math.sqrt((size.width * size.width) / 2);

//    var mainRect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);
//    canvas.drawRect(mainRect, debugPaint);

    //for white arc at bottom
    double leftX = centerX - radius;
    double topY = centerY - radius;
    double rightX = centerX + radius;
    double bottomY = centerY + radius;

    //for items
    double radiusItems = radius * 1.5;
    double leftX2 = centerX - radiusItems;
    double topY2 = centerY - radiusItems;
    double rightX2 = centerX + radiusItems;
    double bottomY2 = centerY + radiusItems;

    //for shadow
    double radiusShadow = radius * 1.13;
    double leftX3 = centerX - radiusShadow;
    double topY3 = centerY - radiusShadow;
    double rightX3 = centerX + radiusShadow;
    double bottomY3 = centerY + radiusShadow;

    double radiusText = radius * 1.30;
    double radius4 = radius * 1.12;
    double radius5 = radius * 1.06;
    // var arcRect = Rect.fromLTRB(leftX2, topY2, 20.0, bottomY2);
    var arcRect = Rect.fromLTRB(leftX2, topY2, rightX2, bottomY2);

    // var dummyRect = Rect.fromLTRB(0.0, 0.0, size.width, 100.0);
    var dummyRect = Rect.fromLTRB(0.0, 0.0, size.width, size.height);

    canvas.clipRect(dummyRect, clipOp: ClipOp.intersect);

    for (int i = 0; i < arcItems.length; i++) {
      canvas.drawArc(
          arcRect,
          selectedAngle,
          // arcItems[i].startAngle,
          // arcItems[i].toDouble(),
          angleInRadians,
          true,
          new Paint()
            ..style = PaintingStyle.fill
            ..shader = new LinearGradient(
              // colors: arcItems[i].colors
              colors: [Colors.white, Colors.white],
            ).createShader(dummyRect));

      //Draw text
      TextSpan span = new TextSpan(
          style: new TextStyle(
              fontWeight: FontWeight.normal,
              fontSize: 32.0,
              color: Colors.black),
          text: selectedValue
          // text: arcItems[i].text
          );
      // TextSpan textspan = new TextSpan(
      //     style: new TextStyle(
      //         fontWeight: FontWeight.normal,
      //         fontSize: 32.0,
      //         color: Colors.black),
      //     // text: selectedValue
      //     text: arcItems[i].text
      //     );
      TextPainter tp = new TextPainter(
        text: span,
        textAlign: TextAlign.center,
        textDirection: TextDirection.ltr,
      );
      // TextPainter textspans = new TextPainter(
      //   text: textspan,
      //   textAlign: TextAlign.center,
      //   textDirection: TextDirection.ltr,
      // );
      // textspans.layout();
      tp.layout();

      //find additional angle to make text in center
      double f = tp.width / 2;
      double t = sqrt((radiusText * radiusText) + (f * f));

      double additionalAngle = math.acos(
          ((t * t) + (radiusText * radiusText) - (f * f)) /
              (2 * t * radiusText));

      double tX = center.dx +
          radiusText *
              math.cos(arcItems[i].startAngle +
                  angleInRadiansByTwo -
                  additionalAngle); // - (tp.width/2);
      double tY = center.dy +
          radiusText *
              math.sin(arcItems[i].startAngle +
                  angleInRadiansByTwo -
                  additionalAngle); // - (tp.height/2);

      canvas.save();
      canvas.translate(tX, tY);
      // canvas.rotate(arcItems[i].startAngle + angleInRadiansByTwo);
      canvas.rotate(arcItems[i].startAngle +
          angleInRadians +
          angleInRadians +
          angleInRadiansByTwo);
      tp.paint(canvas, new Offset(0.0, 0.0));
      canvas.restore();

      //big lines
      canvas.drawLine(
          new Offset(center.dx + radius4 * math.cos(arcItems[i].startAngle),
              center.dy + radius4 * math.sin(arcItems[i].startAngle)),
          center,
          linePaint);

      canvas.drawLine(
          new Offset(
              center.dx +
                  radius4 *
                      math.cos(arcItems[i].startAngle + angleInRadiansByTwo),
              center.dy +
                  radius4 *
                      math.sin(arcItems[i].startAngle + angleInRadiansByTwo)),
          center,
          linePaint);

      //small lines
      canvas.drawLine(
          new Offset(
              center.dx +
                  radius5 * math.cos(arcItems[i].startAngle + angleInRadians1),
              center.dy +
                  radius5 * math.sin(arcItems[i].startAngle + angleInRadians1)),
          center,
          linePaint);

      canvas.drawLine(
          new Offset(
              center.dx +
                  radius5 * math.cos(arcItems[i].startAngle + angleInRadians2),
              center.dy +
                  radius5 * math.sin(arcItems[i].startAngle + angleInRadians2)),
          center,
          linePaint);

      canvas.drawLine(
          new Offset(
              center.dx +
                  radius5 * math.cos(arcItems[i].startAngle + angleInRadians3),
              center.dy +
                  radius5 * math.sin(arcItems[i].startAngle + angleInRadians3)),
          center,
          linePaint);

      canvas.drawLine(
          new Offset(
              center.dx +
                  radius5 * math.cos(arcItems[i].startAngle + angleInRadians4),
              center.dy +
                  radius5 * math.sin(arcItems[i].startAngle + angleInRadians4)),
          center,
          linePaint);
    }

    //shadow
    Path shadowPath = new Path();
    shadowPath.addArc(
        Rect.fromLTRB(leftX3, topY3, rightX3, bottomY3),
        ChooserState.degreeToRadians(180.0),
        ChooserState.degreeToRadians(180.0));
    // canvas.drawShadow(shadowPath, Colors.black, 18.0, true);

    //bottom white arc
    canvas.drawArc(
        Rect.fromLTRB(leftX, topY, rightX, bottomY),
        ChooserState.degreeToRadians(180.0),
        ChooserState.degreeToRadians(180.0),
        true,
        whitePaint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) {
    return true;
  }
}
