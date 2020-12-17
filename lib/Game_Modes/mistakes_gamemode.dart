import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmoria_grp4/Objects/Users.dart';

class MistakeQuizz {
  var correctAnswers = ["Christopher", "Nicolas", "Ludovic", "Alexandre"];




}

var finalScore = 0;
var questionNumber = 0;
var quiz = new MistakeQuizz();

//Method for get all the lists for the auth user
 Future<List<Users>> getAllUsersFromAList(id) async {
    List<Users> list = new List<Users>();
    var firstname, lastname, image;

    Query query = FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser.email)
        .doc(id)
        .collection("users");
    await query.get().then((querySnapshot) async {
      querySnapshot.docs.forEach((document) {
        var id = document.data()['user'];
        id = id.toString();
        id = id.substring(24, id.length - 1);

        FirebaseFirestore.instance
            .collection("users")
            .doc(id)
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            firstname = documentSnapshot.data()["firstname"];
            lastname = documentSnapshot.data()["lastname"];
            image = documentSnapshot.data()["image"];
            Users user = new Users(id, firstname, lastname, image);
            list.add(user);
          } else {
            print("doc not exist");
          }
        });
      });
    });
    return list;
  }


class mistakesGameMode extends StatefulWidget {

  final String id;
  
  mistakesGameMode(this.id);


  //some brut data for display
  final List<String> names = ["Nicolas Constantin", "Piranavan Thambirajah"];

  @override
  State<StatefulWidget> createState() {
    return new mistakesGamemodeState(id);
  }
}

class mistakesGamemodeState extends State<mistakesGameMode> {

  String id;
  var personName;
  var _controller = TextEditingController();


  mistakesGamemodeState(this.id);

  @override
  Widget build(BuildContext context) {
    //Future<List<Users>> test = getAllUsersFromAList(id);

    return new WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                      new Text(
                        "Score: $finalScore",
                        style: new TextStyle(fontSize: 22.0),
                      )
                    ],
                  ),
                ),

                new Padding(padding: EdgeInsets.all(20.0)),

                //Image

                ClipRRect(
                  borderRadius: BorderRadius.circular(20),
                  child: Image.asset(
                    'images/profil.png',
                    height: 300,
                    width: 300,
                  ),
                ),

                new Padding(padding: EdgeInsets.all(20.0)),

                //Input for the name
                new TextField(
                    controller: _controller,
                    onChanged: (value){personName = value;},
                    keyboardType: TextInputType.multiline, 
                    maxLines: 1, 
                    decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                    borderSide: new BorderSide(color: Colors.grey)
                    ),
                    hintText: 'Enter the person name',
                    labelText: 'Firstname Lastname'
                  ),
                ),
                    
                new Padding(padding: EdgeInsets.all(5.0)),

                new Text(quiz.correctAnswers[questionNumber]),

                new FloatingActionButton(
                onPressed: () {
              if(personName == null || personName.isEmpty){

                print("The name can not be empty !");
              }

              if (personName == quiz.correctAnswers[questionNumber]){
                debugPrint("Correct");
                finalScore++;
              } else {
                //Mistake = false
                debugPrint("Wrong");
              }
              _controller.clear();
              updateQuestion();
            }, 
            child: Icon(Icons.play_arrow),
          ),

          new Padding(padding: EdgeInsets.all(20.0)),
          new Container(
            alignment: Alignment.bottomCenter,
            child: new MaterialButton(
              color: Colors.red,
              minWidth: 240.0,
              height: 30.0,
              onPressed: resetQuiz,
              child: Icon(Icons.stop)),
          )


              ],
            )),
      ),
    );
  }

  
void resetQuiz(){
  setState((){
      Navigator.pop(context);
      finalScore = 0;
      questionNumber = 0;

  });
}


void updateQuestion(){

  setState(() {

    if(questionNumber == quiz.correctAnswers.length - 1){
        Navigator.push(context, new MaterialPageRoute(builder: (context)=>new Summary(score: finalScore)));
      } else {
        questionNumber++;
      }
  });

}

}

class Summary extends StatelessWidget {

final int score;

Summary({Key key, @required this.score}) : super(key : key);

  @override
  Widget build(BuildContext context) {
    return new WillPopScope(
      onWillPop: ()async => false,
      child: Scaffold(
        body: new Container(
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Text("Final Score: $score",
              style: new TextStyle(
                fontSize: 25.0
              ),),

              new MaterialButton(
                color: Colors.red,
                onPressed: (){
                  Navigator.pop(context);
                  questionNumber = 0;
                  finalScore = 0;
                },
                child: new Text("Reset Quiz",
                style: new TextStyle(
                  fontSize: 20.0,
                  color: Colors.white
              ))
              ),

            ],
            
            ),
          )
      
      
      
      ), );
  }
  
}