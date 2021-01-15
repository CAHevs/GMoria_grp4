import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmoria_grp4/AddAlreadyExistUser.dart';
import 'package:gmoria_grp4/Objects/Users.dart';
import 'package:gmoria_grp4/app_localizations.dart';
import 'package:gmoria_grp4/list_person.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

//Class based on add_list.dart to add a person to the list
class AddPersonToList extends StatefulWidget {
  final String listId;
  final String listName;

  AddPersonToList(this.listId, this.listName);

  @override
  _addPerson createState() => _addPerson(listId, listName);
}

class _addPerson extends State<AddPersonToList> {
  final String listId;
  final String listName;
  final picker = ImagePicker();

  _addPerson(this.listId, this.listName);

  Users selectedUser = new Users.empty();
  var firstname, lastname, image;
  String _image = "";
  var userLoggedIn = FirebaseAuth.instance.currentUser;
  CollectionReference insertPath;
  CollectionReference userCollectionInsideList;
  var firestoreInstance = FirebaseFirestore.instance;
  var firestoreUser = FirebaseAuth.instance.currentUser;
  List<Users> personNotInTheList = new List<Users>();
  List<Users> allPersonInDb = new List<Users>();

  @override
  Widget build(BuildContext context) {
    insertPath = FirebaseFirestore.instance
        .collection(userLoggedIn.email)
        .doc("users")
        .collection("users");
    getAllUsersNotInTheList();
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate('AddPerson')),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListPerson(listId, listName)));
            }),
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
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ListPerson(listId, listName)));
        },
        child: Icon(Icons.save),
      ),
    );
  }

  //Build the widget
  Widget buildAddPersonToList(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 300,
                  margin: new EdgeInsets.symmetric(vertical: 20.0),
                  child: TextButton(
                    child: Text(AppLocalizations.of(context).translate('AddExistingUser')),
                    onPressed: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddAlreadyExistUser(
                                  personNotInTheList, listId, listName)));
                    },
                  )),
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
                        hintText: AppLocalizations.of(context).translate('Firstname'),
                        labelText: AppLocalizations.of(context).translate('Firstname')),
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
                        hintText: AppLocalizations.of(context).translate('Lastname'),
                        labelText: AppLocalizations.of(context).translate('Lastname')),
                  )),
              Container(
                  width: 300,
                  margin: new EdgeInsets.symmetric(vertical: 20.0),
                  child: TextButton(
                    child: Text(AppLocalizations.of(context).translate('AddAnImage')),
                    onPressed: () {
                      getImage();
                    },
                  ))
            ],
          )
        ],
      );

  //Add the user in the database
  Future<void> addNewList() {
    if (_image == "") {
      _image = "images/profil.png"; //image par défaut
    }
    return insertPath
        .add({
          'firstname': firstname,
          'lastname': lastname,
          'image': _image,
          'lists': [listId],
          'mistake': false,
          'note': "",
        })
        .then((value) => print("User added"))
        .catchError((error) => print("Failed to add list: $error"));
  }

  //Get the image from the gallery
  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final String fileName = basename(pickedFile.path);
      var appDir;
      try {
        appDir = await getApplicationDocumentsDirectory();
      } on Exception catch (e) {
        print(e);
      }

      final appDocPath = appDir.path;
      final filePath = '$appDocPath/$fileName';
      final File selectedImage = File(pickedFile.path);
      final File localImage = await selectedImage.copy('$filePath');
      _image = localImage.path;
    } else {
      _image = "images/profil.png"; //l'image par défaut
    }
  }

  //Get all the users that are not inside the list
  void getAllUsersNotInTheList() async {
    Query query = firestoreInstance
        .collection(firestoreUser.email)
        .doc("users")
        .collection("users");
    await query.get().then((querySnapshot) async {
      querySnapshot.docs.forEach((document) {
        String array = document.data()["lists"].toString();

        //Add all the people in the list
        personNotInTheList.add(new Users.withlist(
            document.id,
            document.data()["firstname"],
            document.data()["lastname"],
            document.data()["image"],
            document.data()["note"],
            document.data()["lists"].cast<String>().toList()));

        //Remove the person already in the list
        for (var i = 1; i < array.length; i++) {
          if (array[i] == ',' || array[i] == ']') {
            if (listId == array.substring(i - 20, i)) {
              personNotInTheList
                  .removeWhere((element) => element.id == document.id);
            }
          }
        }
      });
    });
  }
}
