import 'package:flutter/material.dart';
import 'package:gmoria_grp4/app_localizations.dart';

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
          title: Text(AppLocalizations.of(context).translate("Loading")),
        ),
        body: Center(child: Text("Loading, please wait")),
      ),
    );
  }
}
