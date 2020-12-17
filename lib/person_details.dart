import 'package:flutter/material.dart';
import 'package:gmoria_grp4/Objects/Users.dart';

//Class for the page with all the information regarding a person
class PersonDetails extends StatelessWidget{

  final Users selectedUser; 
  PersonDetails(this.selectedUser); 

  @override
  Widget build(BuildContext context) {
   var title = selectedUser.firstname + " " + selectedUser.lastname; 
   return Scaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: Center(child:  buildAllInformation(),),
    );
  }

  //Widget that will build all the fields
  Widget buildAllInformation() => Column(
    mainAxisAlignment: MainAxisAlignment.start,
    children: <Widget>[
      ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.network(selectedUser.image, height: 300, width: 300,)
      ),
      Container(width: 300, 
      padding: EdgeInsets.all(30),
      child: 
        TextField(
          keyboardType: TextInputType.multiline, 
          maxLines: null, 
          decoration: new InputDecoration(
            border: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.grey)
            ),
            hintText: 'Add notes regarding the person',
            labelText: 'Notes'
          ),)
      )
    ],
  );
}