import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
        title: Text('Sign up'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              // ignore: missing_return
              validator: (input) {
                if (input.isEmpty) {
                  return 'Please type an email';
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
                  return 'Please provide a password';
                }
                if (input.length < 8) {
                  return 'Your password needs to be at least 8 characters';
                }
              },
              onSaved: (input) => _tempPassword = input,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            TextFormField(
              // ignore: missing_return
              validator: (input) {
                if (input.isEmpty) {
                  return 'Please repeat a password';
                }
                if (input != _tempPassword) {
                  return 'The passwords must match';
                }
              },
              onSaved: (input) => _password = input,
              decoration: InputDecoration(labelText: 'Confirm password'),
              obscureText: true,
            ),
            RaisedButton(
              onPressed: signUp,
              child: Text('Sign up'),
            )
          ],
        ),
      ),
    );
  }

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
                    Lists(user: FirebaseAuth.instance.currentUser)));
      } catch (e) {
        print(e.message);
      }
    }
  }
}
