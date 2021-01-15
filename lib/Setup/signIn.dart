import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmoria_grp4/Setup/signup.dart';
import 'package:gmoria_grp4/app_localizations.dart';
import 'package:gmoria_grp4/lists.dart';
import 'dart:developer';

//The class for the login
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => new _LoginPageState();
}

//the state of the login form
class _LoginPageState extends State<LoginPage> {
  String _email, _password;
  
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  //display a form with an email and a password field and the methods for check the form
  Widget build(BuildContext context) {
    log('User: ${FirebaseAuth.instance.currentUser}');
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: new Text(AppLocalizations.of(context).translate('SignIn')),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              // ignore: missing_return
              validator: (input) {
                if (input.isEmpty) {
                  return AppLocalizations.of(context).translate('NoEmail');
                }
              },
              onSaved: (input) => _email = input,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              // ignore: missing_return
              validator: (input) {
                if (input.isEmpty) {
                  return AppLocalizations.of(context).translate('NoPassword');
                }
                if (input.length < 8) {
                  return AppLocalizations.of(context).translate('PasswordNeeded');
                }
              },
              onSaved: (input) => _password = input,
              decoration: InputDecoration(labelText: AppLocalizations.of(context).translate('Password')),
              obscureText: true,
            ),
            //the signin button
            RaisedButton(
              onPressed: signIn,
              child: Text(AppLocalizations.of(context).translate('SignIn')),
            ),
            //the signup button
            RaisedButton(
              onPressed: navigateToSignUp,
              child: Text(AppLocalizations.of(context).translate('SignUp')),
            )
          ],
        ),
      ),
    );
  }

  //the method raised when the signin button is clicked
  Future<void> signIn() async {
    final formState = _formKey.currentState;
    //if the form is valid, sign the user in and go to the List page.
    if (formState.validate()) {
      formState.save();
      try {
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        //Navigate to the list page
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ListsPage()));
      } catch (e) {
        print(e.message);
      }
    }
  }

  //the method raised when the signup button is clicked
  void navigateToSignUp() {
    //go to the signup page
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => SignupPage(), fullscreenDialog: true));
  }
}
