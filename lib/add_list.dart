import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:gmoria_grp4/app_localizations.dart';
import 'package:gmoria_grp4/lists.dart';

//Class to add list
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
        title: Text(AppLocalizations.of(context).translate('AddNewList')),
        
      ),
      body: Center(child: buildAddNewList(context)
      ),
       floatingActionButton: FloatingActionButton(
            onPressed: () {
              //Check if the textfield is null or empty to avoid inserting a false
              if(newListName == null || newListName.isEmpty){
                //showSnackBarHandler(context);
                print("Name can not be empty");
              }
              else{
                addNewList(); 

              Navigator.push(
                context, MaterialPageRoute(
                  builder: (context) => ListsPage()));
              }
            }, 
            child: Icon(Icons.save),
          ),
    );
  }

  //Build the textfield for the insert
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
            hintText: AppLocalizations.of(context).translate('HintNewList'),
            labelText: AppLocalizations.of(context).translate('NewList')
          ),)
      )
    ],
  );

  //Method that will add the list to the DB
  Future<void> addNewList(){
    return userEmail.add({
      'name': newListName,
      'score': 0,
    }).then((value) => print("List added"))
    .catchError((error) => print("Failed to add list: $error"));
  }
}

void showSnackBarHandler(BuildContext context){
  var snackBar = SnackBar(content: Text(AppLocalizations.of(context).translate('NameNoEmpty')));

  Scaffold.of(context).showSnackBar(snackBar);
}