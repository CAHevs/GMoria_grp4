import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmoria_grp4/test.dart';

class SignupPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

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

      try {
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        //Navigate to home
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => TestPage(
                    user:
                        userCredential))); //regarder avec Chris comment avec le split des pages
      } catch (e) {
        print(e.message);
      }
    }
  }
}
