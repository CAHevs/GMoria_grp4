import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmoria_grp4/app_localizations.dart';
import 'package:gmoria_grp4/lists.dart';

//the class for sign up in our app
class SignupPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

//the state of the signup form
class _SignUpPageState extends State<SignupPage> {
  String _email, _password, _tempPassword;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("SignUp")),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              // ignore: missing_return
              validator: (input) {
                if (input.isEmpty) {
                  return AppLocalizations.of(context).translate("NoEmail");
                }
              },
              onSaved: (input) => _email = input,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              // ignore: missing_return
              validator: (input) {
                _tempPassword = input;
                if (input.isEmpty) {
                  return AppLocalizations.of(context).translate("NoPassword");
                }
                if (input.length < 8) {
                  return AppLocalizations.of(context).translate("PasswordNeeded");
                }
              },
              onSaved: (input) => _tempPassword = input,
              decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("Password")),
              obscureText: true,
            ),
            TextFormField(
              // ignore: missing_return
              validator: (input) {
                if (input.isEmpty) {
                  return AppLocalizations.of(context).translate("RepeatPwd");
                }
                if (input != _tempPassword) {
                  return AppLocalizations.of(context).translate("MatchPwd");
                }
              },
              onSaved: (input) => _password = input,
              decoration: InputDecoration(labelText: AppLocalizations.of(context).translate("ConfirmPassword")),
              obscureText: true,
            ),
            RaisedButton(
              onPressed: signUp,
              child: Text(AppLocalizations.of(context).translate("SignUp")),
            )
          ],
        ),
      ),
    );
  }

  //Method to create a user in Firebase
  Future<void> signUp() async {
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();

      //create the user in our db and log him in
      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        //TO DO in the sprint 2 : Create a collection for the user
        await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        //Navigate to home
        Navigator.push(
            context,
            //go to the List page
            MaterialPageRoute(
                builder: (context) =>
                    ListsPage()));
      } catch (e) {
        print(e.message);
      }
    }
  }
}
