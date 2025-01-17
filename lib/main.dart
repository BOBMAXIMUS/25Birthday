import 'dart:math';
import 'package:audioplayers/audioplayers.dart';
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
      title: 'Happy Birthday',
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
  late final AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    _audioPlayer = AudioPlayer();
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

    Future<void> _toggleMusic() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      await _audioPlayer.play(
        AssetSource('audio/recordatorio-memoria.mp3'),
        volume: 0.05,
      );
      setState(() {
        _isPlaying = true;
      });
    }
  }
  @override
  void dispose() {
    _ctrl.dispose();
    _audioPlayer.dispose();
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
                MediaQuery.of(context).size.shortestSide <800 ? getGifRow('gif1', 'gif2') : SizedBox.shrink(),
                MediaQuery.of(context).size.shortestSide <800 ? getGifRow('gif3', 'gif4') : SizedBox.shrink(),
                MediaQuery.of(context).size.shortestSide <600 ? getGifRow('gif1', 'gif2') : SizedBox.shrink(),
                MediaQuery.of(context).size.shortestSide <600 ? getGifRow('gif3', 'gif4') : SizedBox.shrink(),
                MediaQuery.of(context).size.shortestSide <400 ? getGifRow('gif1', 'gif2') : SizedBox.shrink(),
                MediaQuery.of(context).size.shortestSide <400 ? getGifRow('gif3', 'gif4') : SizedBox.shrink(),
                
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
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.7),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              '¿Musiquita?',
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(width: 10),
          FloatingActionButton(
            onPressed: _toggleMusic,
            child: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            backgroundColor: Colors.green,
          ),
        ],
      ),
    );
  }
}
