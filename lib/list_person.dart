import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmoria_grp4/Objects/Users.dart';

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
            ),
            body: ListView.builder(
                itemCount: snapshot.data.length,
                itemBuilder: (BuildContext context, int index) {
                  final Users user = snapshot.data[index];
                  print("${user.firstname} ${user.lastname}");
                  return PersonList(user.firstname, user.image)
                      .buildTitle(context);
                }),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                print("add a person");
              },
              child: Icon(Icons.add),
            ),
          );
        } else {
          return new Scaffold(
            appBar: AppBar(
              title: Text(name),
            ),
            body: Text("No one is in this list"),
            floatingActionButton: FloatingActionButton(
              onPressed: () {
                print("add a list");
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
        .doc(id)
        .collection("users");
    await query.get().then((querySnapshot) async {

      querySnapshot.docs.forEach((document) {
        var userId = document.data()['user'];
        userId = userId.toString();
        userId = userId.substring(45, userId.length - 1);

        var firstname, lastname, image;
        firestoreInstance.collection(firestoreUser.email).doc("users").collection("users").doc(userId).get().then((DocumentSnapshot documentSnapshot){
          if(documentSnapshot.exists){
            firstname = documentSnapshot.data()["firstname"];
            lastname = documentSnapshot.data()["lastname"];
            image = documentSnapshot.data()["image"];
            if(image == null){
              image = "https://cdn.business2community.com/wp-content/uploads/2017/08/blank-profile-picture-973460_640.png";
            }
            Users user = new Users(userId, firstname, lastname, image);
            lists.add(user);
          }else{
            print("doc not exists");
          }
        });
      });
    });
    return lists;
  }

    Users getSpecificUser(var userId){
    var firstname, lastname, image;
    firestoreInstance.collection(firestoreUser.email).doc("users").collection("users").doc(userId).get().then((DocumentSnapshot documentSnapshot){
      if(documentSnapshot.exists){
        firstname = documentSnapshot.data()["firstname"];
        lastname = documentSnapshot.data()["lastname"];
        image = documentSnapshot.data()["image"];
        Users user = new Users(userId, firstname, lastname, image);
        print("Inside getSpecificUser " + userId + " " + firstname + " " + lastname);
       return user;
      }else{
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
  final String heading;
  final String image;

  PersonList(this.heading, this.image);

  Widget buildTitle(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Expanded(
        child: CircleAvatar(
            radius: 55,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage(image),
            )),
      ),
      Text(
        heading,
        style: Theme.of(context).textTheme.headline5,
      ),
    ]);
  }
}
