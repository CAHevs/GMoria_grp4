import 'dart:io';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmoria_grp4/EditPerson.dart';
import 'package:gmoria_grp4/Objects/Users.dart';
import 'package:gmoria_grp4/app_localizations.dart';
import 'package:gmoria_grp4/lists.dart';
import 'package:gmoria_grp4/person_card.dart';
import 'AddPersonToList.dart';

//Stateful list of persons because of the search bar
class ListPerson extends StatefulWidget {
  final String id;
  final String name;
  ListPerson(this.id, this.name);

  @override
  State<StatefulWidget> createState() => _ListPersonState(id, name);

}

//State class containing the list with all person inside a selected list and display them with the search bar
class _ListPersonState extends State<ListPerson> {

  TextEditingController _searchController = TextEditingController();
  final String id;
  final String name;
  List _allResults = [];
  List _resultsList = [];
  Future resultsLoaded;
  _ListPersonState(this.id, this.name);

  //Init the search listener
  @override
  void initState(){
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  //Remove the search controller
  @override
  void dispose(){
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  //Recupe the list of users in the list
  @override
  void didChangeDependencies(){
    super.didChangeDependencies();
    resultsLoaded = genCode();
  }

  _onSearchChanged(){
    searchResultsList();
  }

  //Update the list compared to the search
  searchResultsList(){
    var showResults = [];

    if(_searchController.text != ""){

      for(Users user in _allResults){
        var firstname = user.firstname.toLowerCase();
        var lastname = user.lastname.toLowerCase();

        if(firstname.contains(_searchController.text.toLowerCase()) || lastname.contains(_searchController.text.toLowerCase())){
          showResults.add(user);
        }
      }

    } else {
      showResults = List.from(_allResults);
    }

    setState(() {
      _resultsList = showResults;
    });
  }

  var firestoreInstance = FirebaseFirestore.instance;
  var firestoreUser = FirebaseAuth.instance.currentUser;
  
  //Show the list with the search bar
  Widget build(BuildContext context){
    return Container(
      child: Scaffold(
            appBar: AppBar(
                title: Text(name),
                leading: new IconButton(
                    icon: new Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ListsPage()));
                    }),
                  ),
            body: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 30.0, right: 30.0, bottom: 30.0),
                  child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                    prefixIcon: Icon(Icons.search),
                    hintText: AppLocalizations.of(context).translate('SearchHint')
                    ),

                  )
                ),
                Expanded(child: ListView.builder(
                    itemCount: _resultsList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final Users user = _resultsList[index];
                      return PersonList(user, id, name, context)
                          .buildTitle(context);
                    }))
              ],
            ),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddPersonToList(id, name)),
                );
              },
              child: Icon(Icons.add),
            ),
          )
    );
  }

//Method to generate the people in the list
  Future<List<Users>> genCode() async {
    return await getAllUsersFromAList();
  }

//Method for get all the lists for the auth user
  Future<List<Users>> getAllUsersFromAList() async {
    List<Users> lists = new List<Users>();

    Query query = firestoreInstance
        .collection(firestoreUser.email)
        .doc("users")
        .collection("users");
    await query.get().then((querySnapshot) async {
      querySnapshot.docs.forEach((document) {
        String array = document.data()["lists"].toString();

        for (var i = 1; i < array.length; i++) {
          if (array[i] == ',' || array[i] == ']') {
            if (id == array.substring(i - 20, i)) {
              lists.add(new Users.withlist(
                  document.id,
                  document.data()["firstname"],
                  document.data()["lastname"],
                  document.data()["image"],
                  document.data()["note"],
                  document.data()["lists"].cast<String>().toList()));
            }
          }
        }
      });
    });

  setState(() {
    _allResults = lists;
  });
  searchResultsList();

    return lists;
  }

  //Method to get a specific person
  Users getSpecificUser(var userId) {
    var firstname, lastname, image, note;
    firestoreInstance
        .collection(firestoreUser.email)
        .doc("users")
        .collection("users")
        .doc(userId)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        firstname = documentSnapshot.data()["firstname"];
        lastname = documentSnapshot.data()["lastname"];
        image = documentSnapshot.data()["image"];
        note = documentSnapshot.data()["note"];
        Users user = new Users(userId, firstname, lastname, image, note);
        return user;
      } else {
        print("doc not exists");
      }
    });
    return null;
  }
}

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);
}

/// A ListItem that contains a picture and the name of the person
class PersonList implements ListItem {
  final Users person;
  final String listId;
  final String listName;
  var context;

  PersonList(this.person, this.listId, this.listName, this.context);

  Widget buildTitle(BuildContext context) {
    var heading = person.firstname + " " + person.lastname;

    //If the person doesn't have a picture in the DB, display the default picture
    var image;
    if(person.image == "images/profil.png"){
      image = AssetImage("images/profil.png");
    }else{
      image = FileImage(File(person.image));
    }

    return Slidable(
      actionPane: SlidableStrechActionPane(),
      actionExtentRatio: 0.25,
      child: Row(mainAxisAlignment: MainAxisAlignment.start, textDirection: TextDirection.rtl, children: [
        Expanded(
          child: CircleAvatar(
              radius: 55,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: image,
              )),
        ),
        Container(
            child: InkWell(
          child: Text(
            heading,
            style: Theme.of(context).textTheme.headline5,
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => PersonCard(person, listId, listName)),
            );
          },
          onLongPress: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => EditPerson(listId, listName, person)),
            );
          },
        )),
      ]),
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: AppLocalizations.of(context).translate("Delete"),
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => deletePerson(),
        )
      ],
    );
  }

  //Method to delete a person
  void deletePerson() {
    List<String> finalListPerson = person.lists;
    String stringToRemove = "";

    print(finalListPerson);

    finalListPerson.forEach((element) {
      if (element == listId) {
        stringToRemove = element;
      }
    });

    finalListPerson.remove(stringToRemove);

    //If the deleted person was inside only one list, delete the person in the DB,
    //if not delete it only from the list
    if (finalListPerson.isNotEmpty) {
      FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser.email)
          .doc("users")
          .collection("users")
          .doc(person.id)
          .update({
            'lists': finalListPerson,
          })
          .then((value) => print("User deleted"))
          .catchError((error) => print("Failed to delete person: $error"));
    } else {
      FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser.email)
          .doc("users")
          .collection("users")
          .doc(person.id)
          .delete()
          .then((value) => print("User deleted"))
          .catchError((error) => print("Failed to delete person: $error"));
    }

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ListPerson(listId, listName)));
  }
}
