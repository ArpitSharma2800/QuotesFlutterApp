import 'package:flutter/material.dart';
import 'package:qoute2/screens/fingerPrint.dart';
import 'package:qoute2/screens/homeScreen.dart';

void main() {
  runApp(Myapp());
}

class Myapp extends StatelessWidget {
  const Myapp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'SMM', debugShowCheckedModeBanner: false, home: FingerPrint());
  }
}
