import 'dart:io';

import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmoria_grp4/EditPerson.dart';
import 'package:gmoria_grp4/Objects/Users.dart';
import 'package:gmoria_grp4/lists.dart';
import 'package:gmoria_grp4/person_card.dart';

import 'AddPersonToList.dart';
import 'data_search.dart';

//Class containing the list with all person inside a selected list and display them
class ListPerson extends StatelessWidget {
  final String id;
  final String name;
  ListPerson(this.id, this.name);

  var firestoreInstance = FirebaseFirestore.instance;
  var firestoreUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: genCode(),
      builder: (BuildContext context, AsyncSnapshot<List<Users>> snapshot) {
        if (snapshot.hasData && snapshot.data.length > 0) {
          return Scaffold(
            appBar: AppBar(
                title: Text(name),
                leading: new IconButton(
                    icon: new Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.push(context,
                          MaterialPageRoute(builder: (context) => ListsPage()));
                    }),
                actions: <Widget>[
                  IconButton(
                    icon: Icon(Icons.search),
                    onPressed: () {
                      showSearch(context: context, delegate: DataSearch(id));
                    },
                  )
                ]),
            body: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  final Users user = snapshot.data[index];
                  print("${user.firstname} ${user.lastname}");
                  return PersonList(user, id, name, context)
                      .buildTitle(context);
                }),
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
          );
        } else {
          return new Scaffold(
            appBar: AppBar(
              title: Text(name),
              leading: new IconButton(
                  icon: new Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => ListsPage()));
                  }),
            ),
            body: Text("No one is in this list"),
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
          );
        }
      },
    );
  }

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
    return lists;
  }

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
        print("Inside getSpecificUser " +
            userId +
            " " +
            firstname +
            " " +
            lastname);
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

    return Slidable(
      actionPane: SlidableStrechActionPane(),
      actionExtentRatio: 0.25,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        Expanded(
          child: CircleAvatar(
              radius: 55,
              backgroundColor: Colors.white,
              child: CircleAvatar(
                radius: 50,
                backgroundImage: FileImage(File(person.image)),
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
              MaterialPageRoute(builder: (context) => PersonCard(person, listId, listName)),
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
          caption: 'Delete',
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => deletePerson(),
        )
      ],
    );
  }

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

    print(finalListPerson);

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
          .catchError((error) => print("Failed to modify person: $error"));
    } else {
      FirebaseFirestore.instance
          .collection(FirebaseAuth.instance.currentUser.email)
          .doc("users")
          .collection("users")
          .doc(person.id)
          .delete()
          .then((value) => print("User deleted"))
          .catchError((error) => print("Failed to modify person: $error"));
    }

    Navigator.push(context,
        MaterialPageRoute(builder: (context) => ListPerson(listId, listName)));


  }
}
