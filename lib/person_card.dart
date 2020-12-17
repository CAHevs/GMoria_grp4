import 'package:flutter/material.dart';
import 'package:gmoria_grp4/Objects/Users.dart';
import 'person_details.dart';

//Class that will display the "person's card"
class PersonCard extends StatelessWidget{

  final Users selectedUser; 
  PersonCard(this.selectedUser); 
  
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text("Person Card"),
        
      ),
      body: Center(child: buildInfoCard(context)
      ),
    );
  }
  
  //This widget will display in columns : the "more info" button, the picture of the person and his name
  Widget buildInfoCard(BuildContext context) => Column (
    mainAxisAlignment: MainAxisAlignment.start, 
    children: <Widget>[
      Align(alignment: Alignment.bottomRight,
      child: IconButton(icon: Icon(Icons.info_outline),
        onPressed: (){
          Navigator.push(context, MaterialPageRoute(builder: (context) => PersonDetails(selectedUser)));
        }),),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(selectedUser.image, height: 300, width: 300,)
        ),
      Padding(
        padding: EdgeInsets.all(30),
        child: Text(selectedUser.firstname + " " + selectedUser.lastname),
      ),
    ],
  );
}