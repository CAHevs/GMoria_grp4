import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gmoria_grp4/Setup/loading.dart';
import 'package:gmoria_grp4/Setup/signIn.dart';
import 'package:gmoria_grp4/Setup/somethingWentWrong.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //Create the initialization Future outside of build
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  MyApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = 'GMoria Group 4';

    return FutureBuilder(
      //Initialize FlutterFire
      future: _initialization,
      builder: (context, snapshot) {
        //Check for errors
        if (snapshot.hasError) {
          return SomethingWentWrong();
        }

        //Once complete, show the app
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
              title: title,
              theme: ThemeData(
                primarySwatch: Colors.blue,
              ),
              //Return the login page
              home: Scaffold(
                body: LoginPage(),
              ));
        }

        //Otherwise, show the loading page
        return Loading();
      },
    );
  }
}
