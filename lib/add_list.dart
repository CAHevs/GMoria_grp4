import 'package:flutter/material.dart';

class AddList extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
     return Scaffold(
      appBar: AppBar(
        title: Text("Add a new list"),
        
      ),
      body: Center(child: buildAddNewList(context)
      ),
       floatingActionButton: FloatingActionButton(
            onPressed: () {
              
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
}