import 'dart:io';
import 'package:flutter/material.dart';
import 'package:gmoria_grp4/Objects/Users.dart';
import 'package:gmoria_grp4/app_localizations.dart';
import 'person_details.dart';

//Class that will display the "person's card"
class PersonCard extends StatelessWidget{

  final Users selectedUser; 
  final String listId;
  final String listName;
  PersonCard(this.selectedUser, this.listId, this.listName); 
  
  @override
  Widget build(BuildContext context) {

     return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).translate("PersonCard")),
        
      ),
      body: Center(child: buildInfoCard(context)
      ),
    );
  }


  //This widget will display in columns : the "more info" button, the picture of the person and his name
  Widget buildInfoCard(BuildContext context){

    //If the person doesn't have a picture in the DB, display the default picture
    var image;
    if(selectedUser.image == "images/profil.png"){
      image = Image.asset("images/profil.png", height: 300, width: 300);

    }else{
      image = Image.file(File(selectedUser.image), height: 300, width: 300,);
    }

    return Column (
    mainAxisAlignment: MainAxisAlignment.start, 
    children: <Widget>[
      Align(alignment: Alignment.bottomRight,
      child: IconButton(icon: Icon(Icons.info_outline),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => PersonDetails(selectedUser, listId, listName)));
        }),),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: image
        ),
      Padding(
        padding: EdgeInsets.all(30),
        child: Text(selectedUser.firstname + " " + selectedUser.lastname),
      ),
    ],
    );
  }
}