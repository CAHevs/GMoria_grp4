import 'dart:io';
import 'package:gmoria_grp4/list_person.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmoria_grp4/Objects/Users.dart';
import 'package:image_picker/image_picker.dart';

//Class for the page with all the information regarding a person
class PersonDetails extends StatelessWidget {
  final Users selectedUser;
  final String listId;
  final String listName;

  final String image;

  PersonDetails(this.selectedUser, this.listId, this.listName, [this.image = ""]);

  var notes;
  String _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    var title = selectedUser.firstname + " " + selectedUser.lastname;
    notes = selectedUser.note;
    if(image != ""){
      _image = image;
    }else{
      _image = selectedUser.image;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(
        child: buildAllInformation(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          savePerson();

          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => ListPerson(listId, listName)));
        },
        child: Icon(Icons.save),
      ),
    );
  }

  //Widget that will build all the fields
  Widget buildAllInformation(BuildContext context) {

    //If the person doesn't have a picture in the DB, display the default picture
    var image;
    if(selectedUser.image == "images/profil.png"){
      image = Image.asset("images/profil.png", height: 300, width: 300);

    }else{
      image = Image.file(File(selectedUser.image), height: 300, width: 300,);
    }

    return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          ClipRRect( 
              borderRadius: BorderRadius.circular(20),
              child: image
          ),
          IconButton(
              icon: Icon(Icons.add_a_photo),
              onPressed: () {
                getImage(context);
              }),
          Container(
              width: 300,
              padding: EdgeInsets.all(30),
              child: TextFormField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                initialValue: selectedUser.getNote(),
                onChanged: (value) {
                  notes = value;
                },
                decoration: new InputDecoration(
                  border: new OutlineInputBorder(
                      borderSide: new BorderSide(color: Colors.grey)),
                ),
              )),
        ],
      );
  } 

  //Method that will add/edit notes for a person
  Future<void> savePerson() {
    return FirebaseFirestore.instance
        .collection(FirebaseAuth.instance.currentUser.email)
        .doc('users')
        .collection('users')
        .doc(selectedUser.getId())
        .update({'note': notes, 'image': _image});
  }

  //Method to get an image from the gallery
  Future getImage(BuildContext context) async {
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
      _image = selectedUser.image;
    }
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => PersonDetails(selectedUser, listId, listName, _image)));
  }
}
