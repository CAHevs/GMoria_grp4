import 'package:flutter/material.dart';
import 'lists.dart';

void main() {
  runApp(MyApp(
  ));
}

class MyApp extends StatelessWidget {

  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = 'GMoria Group 4';

    return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: Lists()
      ),
    );
  }
}