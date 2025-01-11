import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cubixd/cubixd.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Birthday Cube',
      theme: ThemeData.dark(),
      home: Home(),
    );
  }
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> with TickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    _ctrl = AnimationController(
      duration: Duration(milliseconds: 10000),
      vsync: this,
    )
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          _ctrl.forward(from: 0);
        }
      })
      ..forward();
    super.initState();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  getImage(String image, [BoxFit? fit]) => Container(
    height: double.infinity,
    width: double.infinity,
    child: Image.asset(
          'assets/images/$image.png',
          fit: fit ?? BoxFit.cover,
        ),
  );
  getGifRow(String image1, String image2) => Expanded(
        child: Row(
          children: [
            Expanded(
              child: Image.asset(
                'assets/images/$image1.gif',
                fit: BoxFit.cover,
              ),
            ),
            Expanded(
              child: Image.asset(
                'assets/images/$image2.gif',
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Column(
              children: [
                getGifRow('gif1', 'gif2'),
                getGifRow('gif3', 'gif4'),
                !kIsWeb ? getGifRow('gif1', 'gif2') : SizedBox.shrink(),
                !kIsWeb ? getGifRow('gif3', 'gif4') : SizedBox.shrink(),
              ],
            ),
          ),
          Center(
            child: AnimatedCubixD(
              size: MediaQuery.of(context).size.shortestSide *
                  (kIsWeb ? 0.5 : 0.8),
              advancedXYposAnim: AnimRequirements(
                controller: _ctrl,
                xAnimation:
                    Tween<double>(begin: -pi / 2, end: pi * 2).animate(_ctrl),
                yAnimation:
                    Tween<double>(begin: pi / 2, end: -pi / 2).animate(_ctrl),
              ),
              shadow: false,
              onSelected: (SelectedSide opt) {
                switch (opt) {
                  case SelectedSide.back:
                  case SelectedSide.top:
                  case SelectedSide.front:
                  case SelectedSide.bottom:
                  case SelectedSide.right:
                  case SelectedSide.left:
                  case SelectedSide.none:
                    return false;
                }
              },
              top: getImage('img55'),
              bottom: getImage('img2'),
              left: getImage('img3', BoxFit.fill),
              right: getImage('img4'),
              front: getImage('img1', BoxFit.fill),
              back: getImage('img6'),
            ),
          ),
        ],
      ),
    );
  }
}
