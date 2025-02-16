import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmoria_grp4/Objects/Users.dart';
import 'package:gmoria_grp4/app_localizations.dart';
import 'package:gmoria_grp4/person_details.dart';
import "package:flutter_swiper/flutter_swiper.dart";

//class for show the training mode with swipe cards
class TrainingList extends StatelessWidget {

  var firestoreInstance = FirebaseFirestore.instance;
  var firestoreUser = FirebaseAuth.instance.currentUser;
  String id;
  String listName;
  TrainingList(this.id, this.listName);

  @override
  //for each person we build a card and we can swipe through them
Widget build(BuildContext context) {
    return FutureBuilder(
      future: genCode(),
      builder: (BuildContext context, AsyncSnapshot<List<Users>> snapshot) {
        if (snapshot.hasData && snapshot.data.length > 0) {
          return Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context).translate("TrainingMode")),
            ),
            body:
                Swiper(
          itemCount: snapshot.data.length,
          itemBuilder: (BuildContext context, int index) {
            final Users user = snapshot.data[index];
            return SwipeableCard(user, id, listName);//the cards
          },
          viewportFraction: 0.8,
          scale: 0.9,
          layout: SwiperLayout.DEFAULT,
          itemHeight: 500.0,
          itemWidth: 300.0,
        )
          );
        } else {
          return new Scaffold(
            appBar: AppBar(
              title: Text(AppLocalizations.of(context).translate("TrainingMode")),
            ),
            body: Text(AppLocalizations.of(context).translate("NoPersonInList")),
          );
        }
      },
    );
  }
  
  //Method for get the persons
  Future<List<Users>> genCode() async {
    return await getAllUsersFromAList();
  }

//Method for get all the people of a list
 Future<List<Users>> getAllUsersFromAList() async {
    List<Users> list = new List<Users>();
    var firstname, lastname, image;

    Query query = firestoreInstance
        .collection(firestoreUser.email)
        .doc("users")
        .collection("users");
    await query.get().then((querySnapshot) async {

      querySnapshot.docs.forEach((document) {
        String array = document.data()["lists"].toString();

        for(var i = 1; i < array.length; i++){
          
          if(array[i]==',' || array[i]==']'){
            if(id==array.substring(i-20, i)){
              list.add(new Users(
                document.id,
                document.data()["firstname"], 
                document.data()["lastname"], 
                document.data()["image"],
                document.data()["note"]
                ));
            }
          }
          
        }
       });
    });
    return list;
  }

}


//the class for the cards, it creates a card model with image, name and info icon
class SwipeableCard extends StatelessWidget {

  Users user;
  String listId;
  String listName;
  SwipeableCard(this.user, this.listId, this.listName);

  Widget build(BuildContext context) {

    //If the person doesn't have a picture in the DB, display the default picture
    var image;
    if(user.image == "images/profil.png"){
      image = Image.asset("images/profil.png", height: 300, width: 300);
    }else{
      image = Image.file(File(user.image), height: 300, width: 300,);
    }

    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
                icon: Icon(Icons.info_outline),
                iconSize: 50.0,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PersonDetails(user, listId, listName)));
                }),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: image
          ),
          Padding(
            padding: EdgeInsets.all(30),
            child: Text(user.firstname+' '+user.lastname,
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
