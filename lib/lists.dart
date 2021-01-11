import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmoria_grp4/Setup/loading.dart';
import 'package:gmoria_grp4/add_list.dart';
import 'package:gmoria_grp4/Objects/listsObject.dart';
import 'package:gmoria_grp4/list_person.dart';
import 'package:gmoria_grp4/selection_mode.dart';
import 'package:gmoria_grp4/settings.dart';

class ListsPage extends StatefulWidget {
  @override
  _Lists createState() => _Lists();
}

class _Lists extends State<ListsPage> {
  var firestoreInstance = FirebaseFirestore.instance;
  var firestoreUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: getAllLists(),
        builder:
            (BuildContext context, AsyncSnapshot<List<ListObject>> snapshot) {
          Widget body;
          if (snapshot.connectionState != ConnectionState.done) {
            return Loading();
          }
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Text("GMoria"),
              ),
              //Drawer with the settings and the button to delete account
              drawer: new Drawer(
                child: ListView(
                  children: <Widget>[
                    new UserAccountsDrawerHeader(
                        accountName: new Text(''),
                        accountEmail: new Text(firestoreUser.email,
                            style: TextStyle(fontSize: 18.0))),
                    new ListTile(
                        title: new Text('Settings'),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SettingsPage()),
                          );
                        })
                  ],
                ),
              ),
              body: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ListObject listObject = snapshot.data[index];
                    //return MainPageItem(listObject.id, listObject.name, listObject.score)
                    return MainPageItem(
                            listObject.id, listObject.name, listObject.score)
                        .buildTitle(context);
                    //method to test that the long press work(for the edit function)
                  }),
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

          return Scaffold(body: body);
        });
  }

  //Method for get all the lists for the auth user
  Future<List<ListObject>> getAllLists() async {
    List<ListObject> lists = new List<ListObject>();

    Query query = firestoreInstance.collection(firestoreUser.email);
    await query.get().then((querySnapshot) async {
      querySnapshot.docs.forEach((document) {
        if (document.id.length > 6) {
          lists.add(new ListObject(
              document.id, document.data()['name'], document.data()['score']));
        }
      });
    });
    print(lists.length);
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
  final String id;
  final String heading;
  final int score;
  final String scoreHeading = 'Last score';

  //MainPageItem(this.id, this.heading);
  MainPageItem(this.id, this.heading, this.score);

  Widget buildTitle(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              child: Row(children: [
            InkWell(
              child: Text(
                heading,
                style: Theme.of(context).textTheme.headline5,
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ListPerson(id, heading)),
                );
              },
              onLongPress: () {
                print("edit the list " + heading);
              },
            )
          ])),
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
                    "$score" + "%",
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
                              builder: (context) => SelectionModPage(id)),
                        );
                      })
                ],
              )
            ],
          ))
        ]);
  }
}
