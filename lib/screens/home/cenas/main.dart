import 'package:flutter/material.dart';

class CenasScreen extends StatefulWidget {
  @override
  _CenasScreenState createState() => _CenasScreenState();
}

class _CenasScreenState extends State<CenasScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Cenas")),
      body: Center(
        child: Text("CenasScreen"),
      ),
    );
  }
}
