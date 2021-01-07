import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmoria_grp4/Objects/Users.dart';
import 'package:gmoria_grp4/list_person.dart';
import 'package:gmoria_grp4/lists.dart';

//Class based on add_list.dart to add a person to the list
class AddPersonToList extends StatefulWidget {
  final String listId;
  final List<Users> personNotInTheList;
  final List<Users> allPersonInDb;
  final String listName;

  AddPersonToList(
      this.listId, this.personNotInTheList, this.allPersonInDb, this.listName);

  @override
  _addPerson createState() =>
      _addPerson(listId, personNotInTheList, allPersonInDb, listName);
}

class _addPerson extends State<AddPersonToList> {
  final String listId;
  final List<Users> personNotInTheList;
  final List<Users> allPersonInDb;
  final String listName;

  _addPerson(
      this.listId, this.personNotInTheList, this.allPersonInDb, this.listName);

  Users selectedUser = new Users.empty();
  var firstname, lastname, image;
  var userLoggedIn = FirebaseAuth.instance.currentUser;
  CollectionReference insertPath;
  CollectionReference userCollectionInsideList;

  @override
  Widget build(BuildContext context) {
    insertPath = FirebaseFirestore.instance
        .collection(userLoggedIn.email)
        .doc("users")
        .collection("users");
    return Scaffold(
      appBar: AppBar(
        title: Text("Add person"),
      ),
      body: Center(child: buildAddPersonToList(context)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (firstname == null || firstname.isEmpty) {
            print("The firstname can not be empty !");
          }
          if (lastname == null || lastname.isEmpty) {
            print("The lastname can not be empty !");
          }
          addNewList();
          //Clear the TextField or Go back
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ListPerson(listId, listName)));
        },
        child: Icon(Icons.save),
      ),
    );
  }

  Widget buildAddPersonToList(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 300,
                  margin: new EdgeInsets.symmetric(vertical: 20.0),
                  child: TextField(
                    onChanged: (value) {
                      firstname = value;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.grey)),
                        hintText: 'firstname',
                        labelText: 'firstname'),
                  )),
              Container(
                  width: 300,
                  margin: new EdgeInsets.symmetric(vertical: 20.0),
                  child: TextField(
                    onChanged: (value) {
                      lastname = value;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.grey)),
                        hintText: 'lastname',
                        labelText: 'lastname'),
                  )),
              Container(
                  width: 300,
                  margin: new EdgeInsets.symmetric(vertical: 20.0),
                  child: TextButton(
                    child: Text("Add an image"),
                    onPressed: () {},
                  ))
            ],
          )
        ],
      );

  Future<void> addNewList() {
    //check si le gars existe déjà
    bool userAlreadyExist = false;
    bool userAlreadyInList = false;
    String existUserId = "";
    List<String> newUserList = new List();

    allPersonInDb.forEach((element) {
      if (element.firstname == firstname && element.lastname == lastname) {
        userAlreadyExist = true;
        existUserId = element.id;
        newUserList = element.lists;

        element.lists.forEach((element) {
          if (element == listId) {
            userAlreadyInList = true;
          }
        });

        newUserList.add(listId);
      }
    });

    if (!userAlreadyExist) {
      return insertPath
          .add({
            'firstname': firstname,
            'lastname': lastname,
            'image':
                "https://www.seekpng.com/png/detail/202-2024994_profile-icon-profile-logo-no-background.png",
            'lists': [listId],
            'mistake': false,
            'note': "",
          })
          .then((value) => print("User added"))
          .catchError((error) => print("Failed to add list: $error"));
    } else {
      if (!userAlreadyInList) {
        return insertPath
            .doc(existUserId)
            .update({
              'lists': newUserList,
            })
            .then((value) => print("Already exist user added"))
            .catchError((error) => print("Failed to add list: $error"));
      } else {
        return insertPath
            .doc(existUserId)
            .update({})
            .then((value) => print("Already exist user added"))
            .catchError((error) => print("Failed to add list: $error"));
      }
    }
  }
}
