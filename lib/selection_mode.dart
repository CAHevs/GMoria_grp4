import 'package:flutter/material.dart';
import 'package:gmoria_grp4/Game_Modes/training_mode.dart';
import 'Game_Modes/custom_number_gamemode.dart';
import 'Game_Modes/mistakes_gamemode.dart';
import 'Game_Modes/normal_gamemode.dart';
import 'package:gmoria_grp4/lists.dart';

//Page with the game and train buttons
class SelectionModPage extends StatelessWidget {

  final String id;

  SelectionModPage(this.id);

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
        child: SelectionModeRows(id).build(context),
      ),
    );
  }
}

class SelectionModeRows extends StatelessWidget {

  final String id;
  SelectionModeRows(this.id);

  Widget build(BuildContext context) {
    return Container(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        TrainingModeButton(id).buildTitle(context),
        FullListGameModeButton(id).buildTitle(context),
        MistakesModeButton(id).buildTitle(context),
        NumberModeButton(id, context).buildTitle(context)
      ],
    ));
  }
}

//abstract class for the button model
abstract class ModeButton {
  Widget buildTitle(BuildContext context);
}

class NumberModeButton implements ModeButton {

  BuildContext context;
  final String id;
  var number;
  final num = TextEditingController();
  NumberModeButton(this.id, this.context);


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
                  'Custom number mode',
                  style: TextStyle(fontSize: 17.0, color: Colors.white),
                ),
              )
            ],
          ),
        ),
        onPressed: () {
          if(number == 0 || number == null){
            _emptyTextfield();
          } else {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => CustomNumberGameMode(id, number)),
          );
          }

          
        })
      ],
    );
    
  }

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
  

}



class MistakesModeButton implements ModeButton {

  final String id;


  MistakesModeButton(this.id);

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
            MaterialPageRoute(builder: (context) => MistakesGameMode(id)),
          );
        });
  }
}

//Training mode button
class TrainingModeButton implements ModeButton {


  final String id;

  TrainingModeButton(this.id);

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
            MaterialPageRoute(builder: (context) => TrainingList(id)),
          );
        });
  }
}

//Training mode button
class FullListGameModeButton implements ModeButton {


  final String id;


  FullListGameModeButton(this.id);

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
            MaterialPageRoute(builder: (context) => NormalGameMode(id)),
          );
        });
  }
}
