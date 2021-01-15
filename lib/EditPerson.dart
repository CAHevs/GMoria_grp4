import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmoria_grp4/Objects/Users.dart';
import 'package:gmoria_grp4/app_localizations.dart';
import 'package:gmoria_grp4/list_person.dart';
import 'package:path/path.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

//Class to edit a person's info
class EditPerson extends StatefulWidget {
  final String listId;
  final String listName;
  final Users personToModify;

  EditPerson(this.listId, this.listName, this.personToModify);

  @override
  _editPerson createState() => _editPerson(listId, listName, personToModify);
}

class _editPerson extends State<EditPerson> {
  final String listId;
  final String listName;
  final Users personToModify;
  final picker = ImagePicker();

  _editPerson(this.listId, this.listName, this.personToModify);

  var firstname, lastname;

  String _image = "";
  var userLoggedIn = FirebaseAuth.instance.currentUser;
  CollectionReference editPath;
  CollectionReference userCollectionInsideList;
  var firestoreInstance = FirebaseFirestore.instance;
  var firestoreUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    editPath = FirebaseFirestore.instance
        .collection(userLoggedIn.email)
        .doc("users")
        .collection("users");
    firstname = personToModify.firstname;
    lastname = personToModify.lastname;
    return Scaffold(
      appBar: AppBar(
        title:
            Text(AppLocalizations.of(context).translate("Edit")+" ${personToModify.firstname} ${personToModify.lastname}"),
        leading: new IconButton(
            icon: new Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListPerson(listId, listName)));
            }),
      ),
      body: Center(child: buildEditPersonToList(context)),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (firstname == null || firstname.isEmpty) {
            print(AppLocalizations.of(context).translate("FirstnameNotEmpty"));
          }
          if (lastname == null || lastname.isEmpty) {
            print(AppLocalizations.of(context).translate("LastnameNotEmpty"));
          }
          editList();
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
  Widget buildEditPersonToList(BuildContext context) => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  width: 300,
                  margin: new EdgeInsets.symmetric(vertical: 20.0),
                  child: TextField(
                    controller: new TextEditingController(
                        text: personToModify.firstname),
                    onChanged: (value) {
                      firstname = value;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.grey)),
                        hintText: AppLocalizations.of(context).translate("Firstname"),
                        labelText: AppLocalizations.of(context).translate("Firstname")),
                  )),
              Container(
                  width: 300,
                  margin: new EdgeInsets.symmetric(vertical: 20.0),
                  child: TextField(
                    controller: new TextEditingController(
                        text: personToModify.lastname),
                    onChanged: (value) {
                      lastname = value;
                    },
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: new InputDecoration(
                        border: new OutlineInputBorder(
                            borderSide: new BorderSide(color: Colors.grey)),
                        hintText: AppLocalizations.of(context).translate("Lastname"),
                        labelText: AppLocalizations.of(context).translate("Lastname")),
                  )),
              Container(
                  width: 300,
                  margin: new EdgeInsets.symmetric(vertical: 20.0),
                  child: TextButton(
                    child: Text(AppLocalizations.of(context).translate("ModifyImage")),
                    onPressed: () {
                      getImage();
                    },
                  ))
            ],
          )
        ],
      );

  //Edit the selected person in the DB
  Future<void> editList() {
    if (_image == "") {
      _image = personToModify.image;
    }
    return editPath
        .doc(personToModify.id)
        .update({
          'firstname': firstname,
          'lastname': lastname,
          'image': _image,
        })
        .then((value) => print("User modified"))
        .catchError((error) => print("Failed to modify person: $error"));
  }

  //Get an image from the gallery to change the person's image
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
      _image = personToModify.image; //l'image par défaut
    }
  }
}
