import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'dart:async';

import 'offline_page.dart';

class NetworkMonitor extends StatefulWidget {
  final Widget child;

  const NetworkMonitor({super.key, required this.child});

  @override
  _NetworkMonitorState createState() => _NetworkMonitorState();
}

class _NetworkMonitorState extends State<NetworkMonitor> {
  late StreamSubscription<ConnectivityResult> _connectivitySubscription;
  bool _isOffline = false;

  @override
  void initState() {
    super.initState();
    _checkConnectivity();

    _connectivitySubscription =
        Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      setState(() {
        _isOffline = result == ConnectivityResult.none;
      });
    } as void Function(List<ConnectivityResult> event)?) as StreamSubscription<ConnectivityResult>;
  }

  Future<void> _checkConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    setState(() {
      _isOffline = result == ConnectivityResult.none;
    });
    
  }
  

  @override
  Widget build(BuildContext context) {
    return _isOffline ? const OfflinePage() : widget.child;
  }

  @override
  void dispose() {
    _connectivitySubscription.cancel();
    super.dispose();
  }
}
