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
bool _nameStatus = false;
bool _displayButtonStatus = true;
bool _validationButtons = false;

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
            list.add(new Users(
                document.id,
                document.data()["firstname"],
                document.data()["lastname"],
                document.data()["image"],
                document.data()["note"]));
          }
        }
      }
    });
  });

  //We shuffle the list
  //list = shuffle(list, list.length);
  
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

Future<void> updateRightAnswerStatus(personId) async {
  return FirebaseFirestore.instance
      .collection(FirebaseAuth.instance.currentUser.email)
      .doc('users')
      .collection('users')
      .doc(personId)
      .update({'mistake': false});
}

Future<void> updateScore(list, score) async {
  return FirebaseFirestore.instance
      .collection(FirebaseAuth.instance.currentUser.email)
      .doc(list)
      .update({'score': score});
}

//If the user does a mistake, it's set in the DB
List<Users> shuffle(List<Users> items, int end) {
  var random = new Random();
  int start = 0;

  end ??= items.length;
  var length = end - start;
  while (length > 1) {
    var pos = random.nextInt(length);
    length--;
    var tmp1 = items[start + pos];
    items[start + pos] = items[start + length];
    items[start + length] = tmp1;
  }
}

//Main class for the CustomNumberGamemode
class NormalGameMode extends StatefulWidget {
  final String id;
  final String listName;
  NormalGameMode(this.id, this.listName);

  @override
  State<StatefulWidget> createState() {
    users = genCode(id);
    return new NormalGamemodeState(id, this.listName);
  }
}

//State class for all the state of game pages
class NormalGamemodeState extends State<NormalGameMode> {
  String id;
  String listName;
  var personName;

  NormalGamemodeState(this.id, this.listName);

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: genCode(id),
      builder: (BuildContext context, AsyncSnapshot<List<Users>> snapshot) {
        if (snapshot.hasData && snapshot.data.length > 0) {
          final Users user = snapshot.data[questionNumber];
          print(user.firstname+" "+user.lastname);
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

                          //Question number with score
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

                          //Name display button

                          new Visibility(
                              visible: _nameStatus,
                              child: new Text(
                                user.firstname + " " + user.lastname,
                                style: new TextStyle(fontSize: 25.0),
                              )),

                          //Name shown
                          new Visibility(
                              visible: _displayButtonStatus,
                              child: new Container(
                                  height: 100.0,
                                  width: 100.0,
                                  child: new FloatingActionButton(
                                    heroTag: null,
                                    onPressed: () {
                                      setState(() {
                                        _nameStatus = true;
                                        _displayButtonStatus = false;
                                        _validationButtons = true;
                                      });
                                    },
                                    child: Icon(
                                      Icons.person,
                                      size: 70.0,
                                    ),
                                    backgroundColor: Colors.blue,
                                  ))),

                          new Padding(padding: EdgeInsets.all(10.0)),


                          //Validation buttons, one green and one red
                          new Visibility(
                              visible: _validationButtons,
                              child: new Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: <Widget>[
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        new Container(
                                            height: 100.0,
                                            width: 100.0,
                                            child: new FloatingActionButton(
                                              heroTag: null,
                                              onPressed: () {
                                                updateRightAnswerStatus(user.id);
                                                finalScore++;
                                                update(snapshot.data,
                                                    snapshot.data.length, id);
                                              },
                                              child: Icon(Icons.check, size: 70.0),
                                              backgroundColor: Colors.green,
                                            ))
                                      ],
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        new Container(
                                            height: 100.0,
                                            width: 100.0,
                                            child: new FloatingActionButton(
                                              heroTag: null,
                                              onPressed: () {
                                                updateMistakeStatus(user.id);
                                                update(snapshot.data,
                                                    snapshot.data.length, id);
                                              },
                                              child: Icon(Icons.close, size: 70.0),
                                              backgroundColor: Colors.red,
                                            ))
                                      ],
                                    ),
                                  ])),
                        ],
                      )),
                ),
              ));
        } else {
          //If nobody in the list
          return new Scaffold(
            appBar: AppBar(
              title: Text('Full list gamemode'),
            ),
            body: Text("No one is in this list"),
          );
        }
      },
    );
  }

  //Leave the game
  void leave() {
    finalScore = 0;
    questionNumber = 0;
    _validationButtons = false;
    _displayButtonStatus = true;
    _nameStatus = false;

    setState(() {
      Navigator.push(
          context,
          new MaterialPageRoute(
              builder: (context) => new SelectionModPage(id, listName)));
    });
  }

  //Update the next question or go to the summary screen at the end of the game
  Future<void> update(allUsers, total, listId) async {
    void refresh() {
      setState(() {
        finalScore = 0;
        questionNumber = 0;
        _validationButtons = false;
        _displayButtonStatus = true;
        _nameStatus = false;
      });
    }

    setState(() {
      //If last question, we go to the summary
      if (questionNumber == allUsers.length - 1) {
        Navigator.push(
            context,
            new MaterialPageRoute(
                builder: (context) => new Summary(finalScore, refresh, total, listId)));
      } else {
        //if not the last question, we increase the question number and hide green or red circle
        questionNumber++;
        _validationButtons = false;
        _displayButtonStatus = true;
        _nameStatus = false;
      }
    });
  }

}

//Result screen with score, retry button and leave button
class Summary extends StatelessWidget {
  final int score;
  final Function refresh;
  final int total;
  final String listId;
  double percentage;
  Summary(this.score, this.refresh, this.total, this.listId);

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
                      percentage = (score / total) * 100;
                      updateScore(listId, percentage.truncate());
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
                      percentage = (score / total) * 100;
                      updateScore(listId, percentage.truncate());
                      refresh();
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
