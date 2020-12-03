import 'package:flutter/material.dart';
import 'person_details.dart';

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
          child: Image.asset('images/hell_dice.png'),
        ),
      Padding(
        padding: EdgeInsets.all(30),
        child: Text('Name of the person'),
      ),
    ],
  );
}