import 'package:WeighScale/WeighScale.dart';
import 'package:flutter/material.dart';
import './WeighScale.dart';
import './Utils/utils.dart';
import './Models/ArcItem.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key}) : super(key: key);
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  int height = 190;
  int slideValue = 0;
  int lastAnimPosition = 2;
  String weight;
  String selectedGender;
  AnimationController animation;

  List<ArcItem> arcItems = List<ArcItem>();

  Color startColor;
  Color endColor;

  @override
  void initState() {
    super.initState();
    var rangeList = range(30, 110, 1);
    List<ArcItem> items = rangeList
        ?.map<ArcItem>((x) => ArcItem(x.toStringAsFixed(2), 0.0))
        ?.toList();
    arcItems = items;

    startColor = Color(0xFF21e1fa);
    endColor = Color(0xff3bb8fd);

    animation = new AnimationController(
      value: 0.0,
      lowerBound: 0.0,
      upperBound: 110.0,
      duration: const Duration(milliseconds: 100),
      vsync: this,
    );

    slideValue = animation.value.toInt();

    animation.animateTo(slideValue.toDouble());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Weigh Scale',
          textAlign: TextAlign.center,
        ),
      ),
      body: Container(
        margin: EdgeInsets.all(200.0),
        child: WeighScale()
          ..arcSelectedCallback = (int pos, List<dynamic> arcItems) {
            int animPosition = pos - 2;
            if (animPosition > 3) {
              animPosition = animPosition - 4;
            }

            if (animPosition < 0) {
              animPosition = 4 + animPosition;
            }
            animation.animateTo(animPosition * 100.0);
            setState(() {
              slideValue = double.parse(arcItems[pos].text).toInt();
              weight = arcItems[pos].text;
            });
          },
      ),
    );
  }
}
