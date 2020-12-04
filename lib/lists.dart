import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmoria_grp4/selection_mode.dart';
import 'list_person.dart';
import 'dart:developer';

//Class that will display all the list on the main page
class Lists extends StatelessWidget {
  final UserCredential user;
  const Lists({this.user});

  @override
  Widget build(BuildContext context) {
    List<ListItem> items =
        List<ListItem>.generate(5, (index) => MainPageItem("List $index"));

    log('User: ${user.user.uid}');
    return Scaffold(
        appBar: AppBar(
          title: Text("GMoria"),
        ),
        body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return ListTile(
                title: item.buildTitle(context),
                onLongPress: () => Scaffold.of(context).showSnackBar(SnackBar(
                    content:
                        Text("You clicked on the list " + index.toString()))),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListPerson(index)),
                  );
                },
              );
            }));
  }
}

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);
}

//Class to create the list with a name, a score and a play button that will redirect
//to the selection game mode page
class MainPageItem implements ListItem {
  final String heading;
  final String score = '10/20';
  final String scoreHeading = 'Last score';

  MainPageItem(this.heading);

  Widget buildTitle(BuildContext context) {
    return Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Container(
          child: Row(
            children: [
              Text(
                heading,
                style: Theme.of(context).textTheme.headline5,
                )
                
            ],)
        ),
        Container(
          child: Row(children: [
              Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  scoreHeading,
                  style: TextStyle(
                    fontSize: 25.0,
                    color: Colors.black87
                  ),
                ),
                Text(
                  score,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: Colors.black54
                  ),
                ),
              ],),
              Column(crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                IconButton(icon: Icon(Icons.play_circle_outline), 
                    disabledColor: Colors.red,
                    iconSize: 45,
                    onPressed: (){
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => SelectionModPage()),);
                })
              ],)
          ],)
        )
      ]);    
  }
}

/// A ListItem that contains data to display a heading.
class HeadingItem implements ListItem {
  final String heading;

  HeadingItem(this.heading);

  Widget buildTitle(BuildContext context) {
    return Text(
      heading,
      style: Theme.of(context).textTheme.headline5,
    );
  }
}
