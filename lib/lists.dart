import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmoria_grp4/add_list.dart';
import 'package:gmoria_grp4/selection_mode.dart';
import 'list_person.dart';
import 'dart:developer';
import 'Objects/listsObject.dart';

class ListsPage extends StatefulWidget {
  @override
  _Lists createState() => _Lists();
}

class _Lists extends State<ListsPage> {
  var firestoreInstance = FirebaseFirestore.instance;
  var firestoreUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    List<ListItem> items =
        List<ListItem>.generate(5, (index) => MainPageItem("List $index"));



    return Scaffold(
        appBar: AppBar(
          title: Text("GMoria"),
        ),/*
        body: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection(firestoreUser.email)
              .snapshots(),
          builder: (context, snapshot) {
            var doc = snapshot.data.docs;
            if (!snapshot.hasData) return Text('Loading data.. Please Wait..');

            return new ListView.builder(
                itemCount: doc.length,
                itemBuilder: (context, index) {
                  final item = doc[index];

                  /*
                  return Container(
                    child: MainPageItem(item.name),
                  );*/
/*
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
              );*/
                });
          },
        )
        */
        
          body: ListView.builder(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];

              return ListTile(

                title: item.buildTitle(context),
                //method to test that the long press work(for the edit function)
                onLongPress: () => Scaffold.of(context).showSnackBar(SnackBar(
                    content:
                        Text("You clicked on the list " + index.toString()))),
                //go in the list to see it content
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ListPerson(index)),
                  );
                },
              );
            }
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context) => AddList()),
              );
            }, 
            child: Icon(Icons.add),
          ),
        );
  }

  //Method for get all the lists for the auth user
  Future<List<ListObject>> getAllLists() async {
    List<ListObject> lists;

    Query query = firestoreInstance.collection(firestoreUser.email);
    lists.clear();
    await query.get().then((querySnapshot) async {
      querySnapshot.docs.forEach((document) {
          lists.add(new ListObject(
              document.id, document.data()['name'], document.data().values));
      });
    });
    return lists;

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
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              child: Row(
            children: [
              Text(
                heading,
                style: Theme.of(context).textTheme.headline5,
              )
            ],
          )),
          Container(
              child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    scoreHeading,
                    style: TextStyle(fontSize: 25.0, color: Colors.black87),
                  ),
                  Text(
                    score,
                    style: TextStyle(fontSize: 20.0, color: Colors.black54),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                      icon: Icon(Icons.play_circle_outline),
                      disabledColor: Colors.red,
                      iconSize: 45,
                      //go to the selection mode page
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectionModPage()),
                        );
                      })
                ],
              )
            ],
          ))
        ]);
  }
}

/// A ListItem that contains data to display a heading
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
