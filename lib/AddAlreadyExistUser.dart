import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmoria_grp4/Objects/Users.dart';

//Class containing the list with all person inside a selected list and display them
class AddAlreadyExistUser extends StatelessWidget {
  final List<Users> availableUser;
  final String listName;
  final String listId;
  AddAlreadyExistUser(this.availableUser, this.listId, this.listName);

  var firestoreInstance = FirebaseFirestore.instance;
  var firestoreUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    if (availableUser.isNotEmpty) {
      return new Scaffold(
        appBar: AppBar(
          title: Text("add to $listName"),
        ),
        body: ListView.builder(
            itemCount: availableUser.length,
            itemBuilder: (BuildContext context, int index) {
              final Users user = availableUser.elementAt(index);
              print("${user.firstname} ${user.lastname}");
              return Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Expanded(
                      child: CircleAvatar(
                          radius: 55,
                          backgroundColor: Colors.white,
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: FileImage(File(user.image)),
                          )),
                    ),
                    Container(
                        child: InkWell(
                            child: Text(
                              "${user.firstname} ${user.lastname}",
                              style: Theme.of(context).textTheme.headline5,
                            ),
                            onTap: () {
                              //manage the list of lists for the user
                              List<String> finalList = new List<String>();

                              user.lists.forEach((element) {
                                finalList.add(element);
                              });

                              finalList.add(listId);

                              //modify in the db
                              FirebaseFirestore.instance
                                  .collection(
                                      FirebaseAuth.instance.currentUser.email)
                                  .doc('users')
                                  .collection('users')
                                  .doc(user.id)
                                  .update({'lists': finalList})
                                  .then((value) => print("User added"))
                                  .catchError((error) =>
                                      print("Failed to add user: $error"));

                              //delete the user in the list
                              availableUser.remove(user);

                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddAlreadyExistUser(
                                          availableUser, listId, listName)));
                            }))
                  ]);
              ;
            }),
      );
    } else {
      return new Scaffold(
        appBar: AppBar(
          title: Text("add to $listName"),
        ),
        body: Text("All of your contact are already in this list !"),
      );
    }
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

  PersonList(this.person, this.listId);

  Widget buildTitle(BuildContext context) {
    var heading = person.firstname + " " + person.lastname;

    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
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
                //manage the list of lists for the user
                List<String> finalList = new List<String>();

                person.lists.forEach((element) {
                  element = element.substring(1);
                  finalList.add(element);
                });

                finalList.add(listId);

                //modify in the db
                return FirebaseFirestore.instance
                    .collection(FirebaseAuth.instance.currentUser.email)
                    .doc('users')
                    .collection('users')
                    .doc(person.id)
                    .update({'lists': finalList})
                    .then((value) => print("User added"))
                    .catchError((error) => print("Failed to add user: $error"));
              }))
    ]);
  }
}
