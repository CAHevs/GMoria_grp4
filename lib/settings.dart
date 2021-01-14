import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmoria_grp4/Setup/signIn.dart';
import 'package:gmoria_grp4/lists.dart';

class SettingsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new ListsPage()));
            }),
      ),
      body: Center(
        child: Container(
            child: new Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            new Padding(
              padding: EdgeInsets.all(0.0),
            ),
            new MaterialButton(
                color: Colors.red,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) =>
                        _buildPopupDialog(context),
                  );
                },
                child: new Text("Delete account",
                    style: new TextStyle(fontSize: 25.0, color: Colors.white))),
            new Padding(
              padding: EdgeInsets.all(30.0),
            ),
            new Padding(
              padding: EdgeInsets.all(0.0),
            ),
            new MaterialButton(
                color: Colors.blue,
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => LoginPage()));
                },
                child: new Text("Logout",
                    style: new TextStyle(fontSize: 25.0, color: Colors.white))),
            new Padding(
              padding: EdgeInsets.all(30.0),
            ),
          ],
        )),
      ),
    );
  }

  Widget _buildPopupDialog(BuildContext context) {
    return new AlertDialog(
      title: const Text('Are you sure you want to delete your account ?'),
      content: new Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text("This action is irreversible"),
        ],
      ),
      actions: <Widget>[
        new FlatButton(
          onPressed: () {
            deleteAccount(context);
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('Yes, delete'),
        ),
        new FlatButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          textColor: Theme.of(context).primaryColor,
          child: const Text('No'),
        ),
      ],
    );
  }

  void deleteAccount(BuildContext context) async {
    FirebaseAuth.instance.currentUser
        .delete()
        .then((value) => print("Account deleted"))
        .catchError((error) => print("Failed to delete account: $error"));

    //delete all the collection
    Query query = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser.email);
    await query.get().then((querySnapshot) {
      querySnapshot.docs.forEach((document) {
        document.reference.delete();
      });
    });

    //back to the login page
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => LoginPage()));
  }
}
