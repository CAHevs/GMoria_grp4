import 'package:flutter/material.dart';
import 'person_details.dart';

//Class that will display the "person's card"
class PersonCard extends StatelessWidget{

  final String personName; 
  PersonCard(this.personName); 
  
  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text(personName + " Card"),
        
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
          Navigator.push(context, MaterialPageRoute(builder: (context) => PersonDetails()));
        }),),
        ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.asset('images/profil.png', height: 300, width: 300,),
        ),
      Padding(
        padding: EdgeInsets.all(30),
        child: Text('Name of the person'),
      ),
    ],
  );
}