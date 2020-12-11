import 'package:flutter/material.dart';

class MistakeQuizz {
  var correctAnswers = ["Christopher", "Nicolas"];
}

var finalScore = 0;
var questionNumber = 0;
var quiz = new MistakeQuizz();

class mistakesGameMode extends StatefulWidget {
  //some brut data for display
  final List<String> names = ["Nicolas Constantin", "Piranavan Thambirajah"];

  @override
  State<StatefulWidget> createState() {
    return new mistakesGamemodeState();
  }
}

class mistakesGamemodeState extends State<mistakesGameMode> {
  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        body: new Container(
            margin: const EdgeInsets.all(10.0),
            alignment: Alignment.topCenter,
            child: new Column(
              children: <Widget>[

                new Padding(padding: EdgeInsets.all(20.0)),

                new Container(
                    alignment: Alignment.centerRight,
                    child: new Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[


                        new Text(
                          "Question ${questionNumber + 1} of ${quiz.correctAnswers.length}",
                          style: new TextStyle(fontSize: 22.0),
                        ),


                        new Text("Score: $finalScore",
                            style: new TextStyle(fontSize: 22.0),)


                      ],
                    ),
                  ),

                  
                  new Padding(padding: EdgeInsets.all(10.0)),

                  //Image
                  new Image.asset("images/profil.png"),

                  new Padding(padding: EdgeInsets.all(40.0)),

                  //Input for the name
                  new TextField(decoration: 
                    InputDecoration(labelText: "Firstname Lastname")
                      ),

                  new Padding(padding: EdgeInsets.all(20.0)),


                  

              ],
            )),
      ),
    );
  }
}
