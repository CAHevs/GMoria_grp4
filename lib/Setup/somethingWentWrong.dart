import 'package:flutter/material.dart';

//display a message if the app encounter an error
class SomethingWentWrong extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: Text("Error"),
        ),
        body: Center(child: Text("An error has occured")),
      ),
    );
  }
}
