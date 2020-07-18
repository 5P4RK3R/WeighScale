import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import './Utils/utils.dart';
import './Painters/ChoosePainter.dart';
import './Models/ArcItem.dart';

class WeighScale extends StatefulWidget {
  ArcSelectedCallback arcSelectedCallback;

  @override
  State<StatefulWidget> createState() {
    return ChooserState(arcSelectedCallback);
  }
}

class ChooserState extends State<WeighScale>
    with SingleTickerProviderStateMixin {
  var slideValue = 0;
  Offset centerPoint;

  double userAngle = 0.0;

  double startAngle;

  static double center = 270.0;
  static double centerInRadians = degreeToRadians(center);
  static double angle = 45.0;

  static double angleInRadians = degreeToRadians(angle);
  static double angleInRadiansByTwo = angleInRadians / 2;
  static double centerItemAngle = degreeToRadians(center - (angle / 2));
  List<ArcItem> arcItems;
  // List arcItems;

  AnimationController animation;
  double animationStart;
  double animationEnd = 0.0;

  int currentPosition = 0;

  Offset startingPoint;
  Offset endingPoint;
  double selectedAngle;
  String selectedValue = '0';

  ArcSelectedCallback arcSelectedCallback;

  ChooserState(ArcSelectedCallback arcSelectedCallback) {
    this.arcSelectedCallback = arcSelectedCallback;
  }

  static double degreeToRadians(double degree) {
    return degree * (math.pi / 180);
  }

  static double radianToDegrees(double radian) {
    return radian * (180 / math.pi);
  }

  @override
  void initState() {
    // arcItems = List<ArcItem>();

    var rangeList = range(30, 110, 1);
    // arcItems = List.generate(
    //     110,
    //     (index) => ArcItem(index.toString(),
    //         angleInRadiansByTwo + userAngle + (index * angleInRadians)));
    arcItems = rangeList
        .map<ArcItem>((x) => ArcItem(x.toStringAsFixed(2),
            angleInRadiansByTwo + userAngle + (x * angleInRadians)))
        .toList();

    // print(arcItems.getRange(30, arcItems.length).map((e) => e.text).toList());

    animation = new AnimationController(
        duration: const Duration(milliseconds: 200), vsync: this);
    animation.addListener(() {
      userAngle = lerpDouble(animationStart, animationEnd, animation.value);
      setState(() {
        for (int i = 0; i < arcItems.length; i++) {
          arcItems[i].startAngle =
              angleInRadiansByTwo + userAngle + (i * angleInRadians);
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    double centerX = MediaQuery.of(context).size.width / 2;
    double centerY = MediaQuery.of(context).size.height * 1.5;
    centerPoint = Offset(centerX, centerY);

    return new GestureDetector(
//        onTap: () {
//          print('ChooserState.build ONTAP');
//          animationStart = touchAngle;
//          animationEnd = touchAngle + angleInRadians;
//          animation.forward(from: 0.0);
//        },
      onPanStart: (DragStartDetails details) {
        startingPoint = details.globalPosition;
        var deltaX = centerPoint.dx - details.globalPosition.dx;
        var deltaY = centerPoint.dy - details.globalPosition.dy;
        startAngle = math.atan2(deltaY, deltaX);
      },
      onPanUpdate: (DragUpdateDetails details) {
        endingPoint = details.globalPosition;
        var deltaX = centerPoint.dx - details.globalPosition.dx;
        var deltaY = centerPoint.dy - details.globalPosition.dy;
        var freshAngle = math.atan2(deltaY, deltaX);
        userAngle += freshAngle - startAngle;

        setState(() {
          for (int i = 0; i < arcItems.length; i++) {
            arcItems[i].startAngle =
                angleInRadiansByTwo + userAngle + (i * angleInRadians);
          }
        });
        startAngle = freshAngle;
      },
      onPanEnd: (DragEndDetails details) {
        //find top arc item with Magic!!
        bool rightToLeft = startingPoint.dx < endingPoint.dx;

//        Animate it from this values
        animationStart = userAngle;
        if (rightToLeft) {
          animationEnd += angleInRadians;
          currentPosition--;
          if (currentPosition < 0) {
            // currentPosition = 0;
            currentPosition = arcItems.length - 1;
          }
        } else {
          animationEnd -= angleInRadians;
          currentPosition++;
          if (currentPosition >= arcItems.length) {
            currentPosition = 0;
          }
        }

        if (arcSelectedCallback != null) {
          arcSelectedCallback(currentPosition, arcItems);
          setState(() {
            selectedAngle = arcItems[currentPosition].startAngle;
            // selectedValue = arcItems[(currentPosition >= (arcItems.length - 1)) ? 0 : currentPosition + 1].text;
            selectedValue = arcItems[currentPosition].text;
          });
          // print("selectedValue ${selectedValue}");
        }

        animation.forward(from: 0.0);
      },
      child: Container(
        child: CustomPaint(
          size: Size(MediaQuery.of(context).size.width,
              MediaQuery.of(context).size.width * 1 / 1.7
              // MediaQuery.of(context).size.width * 1 / 1.5
              ),
          painter: ChooserPainter(
              arcItems, angleInRadians, selectedAngle, selectedValue),
        ),
      ),
    );
  }
}

typedef void ArcSelectedCallback(int position, List<dynamic> arcItems);
