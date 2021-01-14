import 'package:flutter/material.dart';
import 'package:gmoria_grp4/Game_Modes/training_mode.dart';
import 'package:gmoria_grp4/app_localizations.dart';
import 'Game_Modes/custom_number_gamemode.dart';
import 'Game_Modes/mistakes_gamemode.dart';
import 'Game_Modes/normal_gamemode.dart';
import 'package:gmoria_grp4/lists.dart';

//Page with the game and train buttons
class SelectionModPage extends StatelessWidget {

  final String id;
  final String listName;
  SelectionModPage(this.id, this.listName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select game mode"),
        leading: new IconButton(
          icon: new Icon(Icons.arrow_back), 
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context)=> new ListsPage()));
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
        MistakesModeButton(id, listName).buildTitle(context),
        NumberModeButton(id,listName).buildTitle(context)
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
                )
              ),
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
          if(number == 0 || number == null){
            //_emptyTextfield();
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CustomNumberGameMode(id, number, listName)),
          );
          }

          
        })
      ],
    );
    
  }
    /*
    Future<void> _emptyTextfield() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Empty field !'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[Text('The name cannot be empty !')],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Ok !'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  */

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
            MaterialPageRoute(builder: (context) => MistakesGameMode(id, listName)),
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
            MaterialPageRoute(builder: (context) => NormalGameMode(id, listName)),
          );
        });
  }
}
