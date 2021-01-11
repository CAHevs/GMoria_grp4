import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmoria_grp4/Objects/Users.dart';
import 'package:quiver/async.dart';
import '../lists.dart';
import '../selection_mode.dart';

var finalScore = 0;
var questionNumber = 0;
var users;
bool _trueAnswerStatus = false;
bool _wrongAnswerStatus = false;
int _start = 5;
int _current = 5;

//Method for get all the people of a list
Future<List<Users>> genCode(id) async {
  return await getAllUsersFromAList(id);
}

//Method for get all the people of a list
Future<List<Users>> getAllUsersFromAList(id) async {
  List<Users> list = new List<Users>();
  var firstname, lastname, image;

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
            list.add(new Users(document.id, document.data()["firstname"],
                document.data()["lastname"], document.data()["image"], document.data()["note"]));
          }
        }
      }
    });
  });

    //We shuffle the list
  list = shuffle(list);

  return list;
}

Future<void> updateMistakeStatus(personId) async {
  return FirebaseFirestore.instance
      .collection(FirebaseAuth.instance.currentUser.email)
      .doc('users')
      .collection('users')
      .doc(personId)
      .update({'mistake': true});
}

Future<void> updateScore(list,score) async {
  return FirebaseFirestore.instance
      .collection(FirebaseAuth.instance.currentUser.email)
      .doc(list)
      .update({'score': score});
}

//If the user does a mistake, it's set in the DB
List<Users> shuffle(List<Users> items) {
  var random = new Random();

//Method for shuffle list of users
  for (var i = items.length - 1; i > 0; i--) {
    // Pick a user number according to the list length
    var n = random.nextInt(i + 1);

    var temp = items[i];
    items[i] = items[n];
    items[n] = temp;
  }

  return items;
}
//Main class for the CustomNumberGamemode
class NormalGameMode extends StatefulWidget {
  final String id;
  NormalGameMode(this.id);

  @override
  State<StatefulWidget> createState() {
    users = genCode(id);
    return new NormalGamemodeState(id);
  }
}
//State class for all the state of game pages
class NormalGamemodeState extends State<NormalGameMode> {
  String id;
  var personName;
  var _controller = TextEditingController();

  NormalGamemodeState(this.id);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: genCode(id),
      builder: (BuildContext context, AsyncSnapshot<List<Users>> snapshot) {
        if (snapshot.hasData && snapshot.data.length > 0) {
          final Users user = snapshot.data[questionNumber];
          return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Text('Full list gamemode'),
                actions: <Widget>[
                  Padding(
                      padding: EdgeInsets.only(right: 20.0),
                      child: GestureDetector(
                        //Button for leave the game
                          onTap: () {
                            leave();
                          },
                          child: Icon(
                        Icons.close,
                        size: 35.0,
                      )))
                ],
              ),
              resizeToAvoidBottomInset: false,
              body: new WillPopScope(
                onWillPop: () async => false,
                child: Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: new Container(
                      margin: const EdgeInsets.all(10.0),
                      alignment: Alignment.topCenter,
                      child: new Column(
                        children: <Widget>[
                          new Padding(padding: EdgeInsets.all(5.0)),

                          new Container(
                            alignment: Alignment.centerRight,
                            child: new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                new Text(
                                  "Question ${questionNumber + 1} of ${snapshot.data.length}",
                                  style: new TextStyle(fontSize: 22.0),
                                ),
                                new Text(
                                  "Score: $finalScore",
                                  style: new TextStyle(fontSize: 22.0),
                                )
                              ],
                            ),
                          ),

                          new Padding(padding: EdgeInsets.all(10.0)),
                          //Counter before next question
                          new Visibility(
                              visible: _trueAnswerStatus,
                              child: Text('Next question in $_current',
                                  style: TextStyle(fontSize: 20.0))),
                          new Visibility(
                              visible: _wrongAnswerStatus,
                              child: Text('Next question in $_current',
                                  style: TextStyle(fontSize: 20.0))),

                          new Padding(padding: EdgeInsets.all(5.0)),

                          //Image
                          new ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              user.image,
                              height: 300,
                              width: 300,
                            ),
                          ),

                          new Padding(padding: EdgeInsets.all(20.0)),

                          //Input for the name

                          new Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                        width: 300.0,
                                        child: new TextField(
                                          controller: _controller,
                                          onChanged: (value) {
                                            personName = value;
                                          },
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 1,
                                          decoration: new InputDecoration(
                                              border: new OutlineInputBorder(
                                                  borderSide: new BorderSide(
                                                      color: Colors.grey)),
                                              hintText: 'Enter the person name',
                                              labelText: 'Firstname Lastname'),
                                        ))
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    new FloatingActionButton(
                                      onPressed: () {
                                        if (personName == null ||
                                            personName.isEmpty) {
                                          _emptyTextfield();
                                        } else {
                                          //If the personName is null, there is an alert
                                          if (personName ==
                                              user.firstname +
                                                  ' ' +
                                                  user.lastname) {
                                                    //If correct answer, we increase the score and change question
                                          //We also show a green circle for saying that is correct
                                            debugPrint("Correct");
                                            finalScore++;
                                            setState(() {
                                              _trueAnswerStatus = true;
                                            });
                                            updateQuestion(snapshot.data, snapshot.data.length);
                                          } else {
                                            //If correct answer, we set the mistake in DB and change question
                                            //We also show a red circle with the right name for saying that is false
                                            updateMistakeStatus(user.id);
                                            debugPrint("Wrong");
                                            setState(() {
                                              _wrongAnswerStatus = true;
                                            });
                                            updateQuestion(snapshot.data, snapshot.data.length);
                                          }
                                          //We clear the textfield
                                          _controller.clear();
                                        }
                                      },
                                      child: Icon(Icons.play_arrow),
                                    )
                                  ],
                                ),
                              ]),

                          new Padding(padding: EdgeInsets.all(10.0)),

                          //Show the green circle for correct answer
                          new Visibility(
                              visible: _trueAnswerStatus,
                              child: Icon(Icons.circle,
                                  color: Colors.green, size: 50.0)),
                          //Show the red circle with the name for false answer
                          new Visibility(
                              visible: _wrongAnswerStatus,
                              child: new Column(
                                children: [
                                  Text(user.firstname + ' ' + user.lastname,
                                      style: TextStyle(fontSize: 25)),
                                  Padding(padding: EdgeInsets.all(5.0)),
                                  Icon(
                                    Icons.circle,
                                    color: Colors.red,
                                    size: 50.0,
                                  )
                                ],
                              ))
                        ],
                      )),
                ),
              ));
        } else {
          //If nobody in the list
          return new Scaffold(
            appBar: AppBar(
              title: Text('test'),
            ),
            body: Text("No one is in this list"),
          );
        }
      },
    );
  }

 
  //Leave the game
  void leave() {
    setState(() {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new SelectionModPage(id)));
    });
  }

  //Method for the counter
  void startTimer() {
    CountdownTimer countDownTimer = new CountdownTimer(
      new Duration(seconds: _start),
      new Duration(seconds: 1),
    );

    var sub = countDownTimer.listen(null);
    sub.onData((duration) {
      setState(() {
        _current = _start - duration.elapsed.inSeconds;
      });
    });

    sub.onDone(() {
      print("Done");
      sub.cancel();
    });
  }

//Method for go to next question
  void updateQuestion(allUsers, total) {
    //Method for refresh the game IF it's ended
    void refresh() {
      setState(() {
        finalScore = 0;
        questionNumber = 0;
        _trueAnswerStatus = false;
        _wrongAnswerStatus = false;
      });
    }

    //Start the counter before go the next question
    startTimer();
    //Delay for go to the next question
    Future.delayed(Duration(seconds: 5), () {
      setState(() {
        //If last question, we go to the summary
        if (questionNumber == allUsers.length - 1) {
          Navigator.push(
              context,
              new MaterialPageRoute(
                  builder: (context) => new Summary(finalScore, refresh,total)));
        } else {
          //if not the last question, we increase the question number and hide green or red circle
          questionNumber++;
          _trueAnswerStatus = false;
          _wrongAnswerStatus = false;
        }
      });
    });
  }

  //If empty textfield
  Future<void> _emptyTextfield() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
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

//Result screen with score, retry button and leave button
class Summary extends StatelessWidget {
  final int score;
  final Function refresh;
  final int total;
  Summary(this.score, this.refresh, this.total);


  

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            title: Text("Normal game score !"),
          ),
          body: new Center(
            child: new Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                new Text(
                  "Final Score: $score",
                  style: new TextStyle(fontSize: 40.0),
                ),
                new Padding(
                  padding: EdgeInsets.all(30.0),
                ),
                new MaterialButton(
                    color: Colors.red,
                    onPressed: () {
                      refresh();
                      Navigator.pop(context);
                    },
                    child: new Text("Reset Quiz",
                        style: new TextStyle(
                            fontSize: 40.0, color: Colors.white))),
                new Padding(
                  padding: EdgeInsets.all(30.0),
                ),
                new MaterialButton(
                    color: Colors.blue[400],
                    onPressed: () {
                     //Leave the game and update the score
                      updateScore("", (score / total) * 100);
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new ListsPage()));
                    },
                    child: new Text("Home",
                        style:
                            new TextStyle(fontSize: 40.0, color: Colors.white)))
              ],
            ),
          )),
    );
  }
}
