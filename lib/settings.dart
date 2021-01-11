import 'package:flutter/material.dart';
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
            Navigator.push(context, MaterialPageRoute(builder: (context)=> new ListsPage()));
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
                      //Method to delete Account
                    },
                    child: new Text("Delete account",
                        style: new TextStyle(
                            fontSize: 25.0, color: Colors.white))),
                new Padding(
                  padding: EdgeInsets.all(30.0),
                ),
              ],
            )),
      ),
    );
  }
}