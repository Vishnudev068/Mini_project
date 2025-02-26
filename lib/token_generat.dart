import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class TokenGenerate extends StatefulWidget {
  const TokenGenerate({super.key});

  @override
  State<TokenGenerate> createState() => _TokenGenerateState();
}

class _TokenGenerateState extends State<TokenGenerate> {
  late ConfettiController _confettiController;
  late int _randomnumber;
  void initState() {
    super.initState();

    _confettiController=ConfettiController(duration: Duration(seconds: 3));
    _confettiController.play();
    _randomnumber = Random().nextInt(50) + 1;
  }

  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirection: pi / 2, // Confetti direction: upwards
              emissionFrequency: 0.05,
              numberOfParticles: 20,
              maxBlastForce: 10,
              minBlastForce: 5,
              gravity: 0.1,
            ),
          ),
          Positioned(
            top: 300,
            left: 100,
            child: Text('Token generated',style: TextStyle(fontSize: 30),)),
          Center(
            child: Container(
              height: 200,
              width: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.deepPurple,
              border: Border.all(
             color: Colors.white
              )
            ),
              child: Center(
                  child: Text(
                '$_randomnumber',
                style: TextStyle(fontSize: 50,color: Colors.white),
              )),
            ),
          ),
        ],
      ),
    );
  }
}
