import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmoria_grp4/lists.dart';

class AddList extends StatelessWidget {

  var newListName;
  var userLoggedIn = FirebaseAuth.instance.currentUser;
  CollectionReference userEmail;
  CollectionReference userCollectionInsideList;
  @override
  Widget build(BuildContext context) {
     userEmail = FirebaseFirestore.instance.collection(userLoggedIn.email);
     return Scaffold(
      appBar: AppBar(
        title: Text("Add a new list"),
        
      ),
      body: Center(child: buildAddNewList(context)
      ),
       floatingActionButton: FloatingActionButton(
            onPressed: () {
              if(newListName == null || newListName.isEmpty){
                //showSnackBarHandler(context);
                print("Name can not be empty");
              }
              else{
                addNewList(); 

              //Clear the TextField or Go back 
              Navigator.push(
                context, MaterialPageRoute(
                  builder: (context) => ListsPage()));
              }
            }, 
            child: Icon(Icons.save),
          ),
    );
  }

  Widget buildAddNewList(BuildContext context) => Row(
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
            hintText: 'Enter the name of the list',
            labelText: 'New List'
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

void showSnackBarHandler(BuildContext context){
  var snackBar = SnackBar(content: Text("The name can not be empty"));

  Scaffold.of(context).showSnackBar(snackBar);
}