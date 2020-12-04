import 'package:flutter/material.dart';

import 'person_card.dart';

//Class containing the list with all person inside a selected list and display them
class ListPerson extends StatelessWidget{

  final int indexCaller;
  ListPerson(this.indexCaller);
  @override
  Widget build(BuildContext context) {
    final persons = List<ListItem>.generate(
        2, (index) => (PersonList("Christopher Artero")));
    return Scaffold(
      appBar: AppBar(
        title: Text("Inside the list " + indexCaller.toString()),
      ),
      body: ListView.builder(
        itemCount: persons.length,
        itemBuilder: (context, index) {
          final item = persons[index];

          return ListTile(
            title: item.buildTitle(context),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          PersonCard(persons.elementAt(index).toString())));
            },
          );
        },
      ),
    );
  }
}

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);
}

/// A ListItem that contains a picture and the name of the person
class PersonList implements ListItem {
  final String heading;

  PersonList(this.heading);

  Widget buildTitle(BuildContext context) {

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        Expanded(child: CircleAvatar(
          radius: 55,
          backgroundColor: Colors.white,
          child: CircleAvatar(radius: 50, backgroundImage: AssetImage('images/profil.png'), )
        ),),
        Text(heading, style: Theme.of(context).textTheme.headline5,),
      ]
    );
  }
}
