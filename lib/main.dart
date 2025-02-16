import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gmoria_grp4/Setup/loading.dart';
import 'package:gmoria_grp4/Setup/signIn.dart';
import 'package:gmoria_grp4/Setup/somethingWentWrong.dart';
import 'package:gmoria_grp4/lists.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'app_localizations.dart';

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
          //if no user in the cache, return the login page
          if (FirebaseAuth.instance.currentUser == null) {
            return MaterialApp(
                title: title,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                //Return the login page
                home: Scaffold(
                  body: LoginPage(),
                  //go to the login page
                ),
                //Support multi-language
                supportedLocales: [
                  Locale('en', 'US'),
                  Locale('fr', 'FR')
                ],
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                localeResolutionCallback: (locale, supportedLocales){

                  for(var supportedLocale in supportedLocales){
                    if(supportedLocale.languageCode == locale.languageCode &&
                    supportedLocale.countryCode == locale.countryCode){
                      return supportedLocale;
                    }
                  }
                  return supportedLocales.first;
                }
                );
          } else {
            //if this is a user in the cache, go to the list page(a user is logged)
            return MaterialApp(
                title: title,
                theme: ThemeData(
                  primarySwatch: Colors.blue,
                ),
                //Return the login page
                home: Scaffold(
                  body:
                      ListsPage(), //go to the list page and give the user loged in
                ),
                //Support multi-language
                supportedLocales: [
                  Locale('en', 'US'),
                  Locale('fr', 'FR')
                ],
                localizationsDelegates: [
                  AppLocalizations.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                localeResolutionCallback: (locale, supportedLocales){

                  for(var supportedLocale in supportedLocales){
                    if(supportedLocale.languageCode == locale.languageCode &&
                    supportedLocale.countryCode == locale.countryCode){
                      return supportedLocale;
                    }
                  }
                  return supportedLocales.first;
                },
              );
          }
        }

        //Otherwise, show the loading page
        return Loading();
      },
    );
  }
}
