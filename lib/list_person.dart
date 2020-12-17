import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmoria_grp4/Objects/Users.dart';
import 'person_card.dart';

//Class containing the list with all person inside a selected list and display them
class ListPerson extends StatelessWidget {
  final String id;
  final String name;
  ListPerson(this.id, this.name);

  var firestoreInstance = FirebaseFirestore.instance;
  var firestoreUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    getAllUsersFromAList();
    final persons = List<ListItem>.generate(
        2, (index) => (PersonList("Christopher Artero")));
    return Scaffold(
      appBar: AppBar(
        title: Text(name),
      ),
      body: ListView.builder(
        itemCount: persons.length,
        itemBuilder: (context, index) {
          final item = persons[index];

          return ListTile(
            title: item.buildTitle(context),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PersonCard(persons.elementAt(index).toString())));
            },
          );
        },
      ),
    );
  }

//Method for get all the lists for the auth user
 Future<List<Users>> getAllUsersFromAList() async {
    List<Users> list = new List<Users>();
    var firstname, lastname, image;

    Query query = firestoreInstance
        .collection(firestoreUser.email)
        .doc(id)
        .collection("users");
    await query.get().then((querySnapshot) async {
      querySnapshot.docs.forEach((document) {
        var id = document.data()['user'];
        id = id.toString();
        id = id.substring(24, id.length - 1);

        firestoreInstance
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
}

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);
}

/// A ListItem that contains a picture and the name of the person
class PersonList implements ListItem {
  final String heading;

  PersonList(this.heading);

  Widget buildTitle(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
      Expanded(
        child: CircleAvatar(
            radius: 55,
            backgroundColor: Colors.white,
            child: CircleAvatar(
              radius: 50,
              backgroundImage: AssetImage('images/profil.png'),
            )),
      ),
      Text(
        heading,
        style: Theme.of(context).textTheme.headline5,
      ),
    ]);
  }
}
