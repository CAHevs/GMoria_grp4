import 'package:flutter/material.dart';

//Class for the page with all the information regarding a person
class PersonDetails extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text("Firstname Lastname"),
      ),
      body: Center(child:  buildAllInformation(),),
    );
  }

  //Widget that will build all the fields
  Widget buildAllInformation() => Column(
    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
    children: <Widget>[
      ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset('images/profil.png'),
      ),
      Text('Email'),
      Text('Phone number'),
      Container(width: 300, child: 
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