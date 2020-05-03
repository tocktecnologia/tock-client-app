import 'package:flutter/material.dart';

class FavoritsScreen extends StatefulWidget {
  @override
  _FavoritsScreenState createState() => _FavoritsScreenState();
}

class _FavoritsScreenState extends State<FavoritsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("favorits"),
      ),
    );
  }
}
