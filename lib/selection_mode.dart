import 'package:flutter/material.dart';
import 'package:gmoria_grp4/full_list_game_mode.dart';
import 'package:gmoria_grp4/training_mode.dart';

import 'Game_Modes/mistakes_gamemode.dart';

//Page with the game and train buttons
class SelectionModPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select game mode"),
      ),
      body: Center(
        child: SelectionModeRows().build(context),
      ),
    );
  }
}

class SelectionModeRows extends StatelessWidget {
  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        TrainingModeButton().buildTitle(context),
        FullListGameModeButton().buildTitle(context),
        MistakesModeButton().buildTitle(context),
        //NumberModeButton().buildTitle(context)
      ],
    ));
  }
}

//abstract class for the button model
abstract class ModeButton {
  Widget buildTitle(BuildContext context);
}

class NumberModeButton implements ModeButton {
  @override
  Widget buildTitle(BuildContext context) {
    new RaisedButton(
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
                  'Custom number mode',
                  style: TextStyle(fontSize: 17.0, color: Colors.white),
                ),
              )
            ],
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TrainingList()),
          );
        });
  }
}

class MistakesModeButton implements ModeButton {
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
                  'Play with mistakes',
                  style: TextStyle(fontSize: 17.0, color: Colors.white),
                ),
              )
            ],
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => mistakesGameMode()),
          );
        });
  }
}

//Training mode button
class TrainingModeButton implements ModeButton {
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
                  'Training mode',
                  style: TextStyle(fontSize: 17.0, color: Colors.white),
                ),
              )
            ],
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TrainingList()),
          );
        });
  }
}

//Training mode button
class FullListGameModeButton implements ModeButton {
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
                  'Full list mode',
                  style: TextStyle(fontSize: 17.0, color: Colors.white),
                ),
              )
            ],
          ),
        ),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => PlayList()),
          );
        });
  }
}
