import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmoria_grp4/lists.dart';

//Class based on add_list.dart to add a person to the list
class AddPersonToList extends StatelessWidget {

  var newListName;
  var userLoggedIn = FirebaseAuth.instance.currentUser;
  CollectionReference userEmail;
  CollectionReference userCollectionInsideList;
  @override
  Widget build(BuildContext context) {
     userEmail = FirebaseFirestore.instance.collection(userLoggedIn.email);
     return Scaffold(
      appBar: AppBar(
        title: Text("Add a person to the list "),
        
      ),
      body: Center(child: buildAddPersonToList(context)
      ),
       floatingActionButton: FloatingActionButton(
            onPressed: () {
              if(newListName == null || newListName.isEmpty){

                print("The name can not be empty !");
              }
              //addNewList();
              //Clear the TextField or Go back 
              Navigator.push(
                context, MaterialPageRoute(
                  builder: (context) => ListsPage()));
            }, 
            child: Icon(Icons.save),
          ),
    );
  }

  Widget buildAddPersonToList(BuildContext context) => Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
       Container(width: 300, child: 
        TextField(
          onChanged: (value){newListName = value;},
          keyboardType: TextInputType.multiline, 
          maxLines: null, 
          decoration: new InputDecoration(
            border: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.grey)
            ),
            hintText: 'Enter the name of the person',
            labelText: 'Add person'
          ),)
      )
    ],
  );

  Future<void> addNewList(){
    return userEmail.add({
      'name': newListName,
    }).then((value) => print("List added"))
    .catchError((error) => print("Failed to add list: $error"));
  }
}