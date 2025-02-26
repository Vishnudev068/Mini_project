import 'package:flutter/material.dart';

class OfflinePage extends StatefulWidget {
  const OfflinePage({super.key});

  @override
  State<OfflinePage> createState() => _OfflinePageState();
}

class _OfflinePageState extends State<OfflinePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: Text("YOU ARE OFFLINE",style: TextStyle(fontSize: 25),),
        ),
        Center(
          child: Container(
            height: 400,
            width: 400,
            decoration: BoxDecoration(
              image: DecorationImage(image: AssetImage('asset/gif/offline_gif (1).gif'))
            ),
          ),
        )
      ],
      ),
    );
  }
}