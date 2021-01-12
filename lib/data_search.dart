import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'Objects/Users.dart';
import 'person_card.dart';

class DataSearch extends SearchDelegate<String> {
  final searchList = ["Ludovic", "Alex", "Nicolas", "Christopher"];

  final recentSearch = ["Nicolas", "Ludovic"];

  final String id;

  DataSearch(this.id);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
          icon: Icon(Icons.clear),
          onPressed: () {
            query = "";
          })
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
        icon: AnimatedIcon(
          icon: AnimatedIcons.menu_arrow,
          progress: transitionAnimation,
        ),
        onPressed: () {
          close(context, null);
        });
  }

  @override
  Widget buildResults(BuildContext context) {
    //return PersonCard();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    //Show the recent search or show only the result that match with the query
 
    
  
  }
}
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

  return list;
}
