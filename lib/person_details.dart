import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmoria_grp4/Objects/Users.dart';
import 'package:image_picker/image_picker.dart';

//Class for the page with all the information regarding a person
class PersonDetails extends StatelessWidget{

  final Users selectedUser; 
  PersonDetails(this.selectedUser); 

  var notes; 
  String _image;
  final picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
   var title = selectedUser.firstname + " " + selectedUser.lastname; 
   _image = selectedUser.image;
   return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(child:  buildAllInformation(),
      ),
      floatingActionButton: FloatingActionButton(
            onPressed: () {
              savePerson();
            }, 
            child: Icon(Icons.save),
      ),
    );
  }

  //Widget that will build all the fields
  Widget buildAllInformation() => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.file(File(_image), height: 300, width: 300,)
      ),
      IconButton(icon: Icon(Icons.add_a_photo), 
      onPressed: () {
        getImage();
        print(_image);
      }),
      Container(width: 300, 
      padding: EdgeInsets.all(30),
      child: 
        TextFormField(
          keyboardType: TextInputType.multiline, 
          maxLines: null, 
          initialValue: selectedUser.getNote(),
          onChanged: (value){
            notes = value; 
          },
          decoration: new InputDecoration(
            border: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.grey)
            ),
          ),)
      ),
    ],
  );

  //Method that will add/edit notes for a person
  Future<void> savePerson(){
    return FirebaseFirestore.instance
      .collection(FirebaseAuth.instance.currentUser.email)
      .doc('users')
      .collection('users')
      .doc(selectedUser.getId())
      .update({'note': notes, 'image':_image});
  }

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if(pickedFile != null){
      final String fileName = basename(pickedFile.path);
      var appDir;
      try{
         appDir = await getApplicationDocumentsDirectory();
      }on Exception catch(e){
        print(e);
      }
      
      final appDocPath = appDir.path;
      final filePath = '$appDocPath/$fileName';
      final File selectedImage = File(pickedFile.path);
      final File localImage = await selectedImage.copy('$filePath');
      _image = localImage.path;
    }else{
      _image = selectedUser.image;
    }
  }
}