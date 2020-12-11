import 'package:flutter/material.dart';

//display something when the page is loading
class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Loading"),
        ),
        body: Text("Loading, please wait"),
      ),
    );
  }
}
