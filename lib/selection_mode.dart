import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmoria_grp4/Game_Modes/training_mode.dart';
import 'package:gmoria_grp4/Objects/Users.dart';
import 'package:gmoria_grp4/app_localizations.dart';
import 'Game_Modes/custom_number_gamemode.dart';
import 'Game_Modes/mistakes_gamemode.dart';
import 'Game_Modes/normal_gamemode.dart';
import 'package:gmoria_grp4/lists.dart';

bool _mistakesButton = false;

//Page with the game and train buttons
class SelectionModPage extends StatelessWidget {
  final String id;
  final String listName;
  SelectionModPage(this.id, this.listName);



  @override
  Widget build(BuildContext context) {
    genCode(id);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("SelectGameMode")),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => new ListsPage()));
            }),
      ),
      body: Center(
        child: SelectionModeRows(id, listName).build(context),
      ),
    );
  }
}

class SelectionModeRows extends StatelessWidget {
  final String id;
  final String listName;
  SelectionModeRows(this.id, this.listName);

  Widget build(BuildContext context) {
     
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        TrainingModeButton(id, listName).buildTitle(context),
        FullListGameModeButton(id, listName).buildTitle(context),
        Visibility(
          visible: _mistakesButton,
          child: MistakesModeButton(id, listName).buildTitle(context),
        ),
        NumberModeButton(id, listName).buildTitle(context)
      ],
    ));
  }
}

//abstract class for the button model
abstract class ModeButton {
  Widget buildTitle(BuildContext context);
}

class NumberModeButton implements ModeButton {
  final String id;
  var number;
  final String listName;
  final num = TextEditingController();
  NumberModeButton(this.id, this.listName);

  @override
  Widget buildTitle(BuildContext context) {
    return new Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Container(
            width: 100,
            padding: EdgeInsets.all(10.0),
            child: TextField(
              controller: num,
              onChanged: (value) {
                number = value;
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(hintText: 'Enter Your Number Here'),
            )),
        RaisedButton(
            padding: EdgeInsets.all(0),
            child: Container(
              decoration: const BoxDecoration(color: Colors.blue),
              height: 100.0,
              width: 210.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Container(
                    decoration: const BoxDecoration(color: Colors.blue),
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      AppLocalizations.of(context).translate("CustomMode"),
                      style: TextStyle(fontSize: 13.0, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
            onPressed: () {
              if (number == 0 || number == null) {
              } else {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          CustomNumberGameMode(id, number, listName)),
                );
              }
            })
      ],
    );
  }
}

class MistakesModeButton implements ModeButton {
  final String id;
  final String listName;
  MistakesModeButton(this.id, this.listName);

  Widget buildTitle(BuildContext context) {
    return new RaisedButton(
        padding: EdgeInsets.all(0),
        child: Container(
          decoration: const BoxDecoration(color: Colors.blue),
          height: 100.0,
          width: 270.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(color: Colors.blue),
                padding: EdgeInsets.all(20.0),
                child: Text(
                  AppLocalizations.of(context).translate("MistakesMode"),
                  style: TextStyle(fontSize: 17.0, color: Colors.white),
                ),
              )
            ],
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MistakesGameMode(id, listName)),
          );
        });
  }
}

//Training mode button
class TrainingModeButton implements ModeButton {
  final String id;
  final String listName;
  TrainingModeButton(this.id, this.listName);

  Widget buildTitle(BuildContext context) {
    return new RaisedButton(
        padding: EdgeInsets.all(0),
        child: Container(
          decoration: const BoxDecoration(color: Colors.blue),
          height: 100.0,
          width: 270.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(color: Colors.blue),
                padding: EdgeInsets.all(20.0),
                child: Text(
                  AppLocalizations.of(context).translate("TrainingMode"),
                  style: TextStyle(fontSize: 17.0, color: Colors.white),
                ),
              )
            ],
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TrainingList(id, listName)),
          );
        });
  }
}

//Training mode button
class FullListGameModeButton implements ModeButton {
  final String id;
  final String listName;
  FullListGameModeButton(this.id, this.listName);

  Widget buildTitle(BuildContext context) {
    return new RaisedButton(
        padding: EdgeInsets.all(0),
        child: Container(
          decoration: const BoxDecoration(color: Colors.blue),
          height: 100.0,
          width: 270.0,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                decoration: const BoxDecoration(color: Colors.blue),
                padding: EdgeInsets.all(20.0),
                child: Text(
                  AppLocalizations.of(context).translate("FullListMode"),
                  style: TextStyle(fontSize: 17.0, color: Colors.white),
                ),
              )
            ],
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => NormalGameMode(id, listName)),
          );
        });
  }
}

//Method for get all the people of a list
Future<void> genCode(id) async {
  return await getAllUsersWithMistakesFromAList(id);
}

//Method for get all the people of a list
Future<void> getAllUsersWithMistakesFromAList(id) async {
  var firstname, lastname, image;
  List<Users> list = new List<Users>();
  Query query = FirebaseFirestore.instance
      .collection(FirebaseAuth.instance.currentUser.email)
      .doc("users")
      .collection("users");
  await query.get().then((querySnapshot) async {
    querySnapshot.docs.forEach((document) {
      String array = document.data()["lists"].toString();

      for (var i = 1; i < array.length; i++) {
        if (array[i] == ',' || array[i] == ']') {
          if (id == array.substring(i - 20, i)) {
            //If the list is empty, it let the mistake button disable, if not, it shows it
            if (document.data()["mistake"] == true) {
              
              _mistakesButton = true;
              print("Button $_mistakesButton");
            }
          }
        }
      }
    });
  });

}
