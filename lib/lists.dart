import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:gmoria_grp4/Objects/Users.dart';
import 'package:gmoria_grp4/Setup/loading.dart';
import 'package:gmoria_grp4/add_list.dart';
import 'package:gmoria_grp4/Objects/listsObject.dart';
import 'package:gmoria_grp4/app_localizations.dart';
import 'package:gmoria_grp4/list_person.dart';
import 'package:gmoria_grp4/selection_mode.dart';
import 'package:gmoria_grp4/settings.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

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
          if (snapshot.connectionState != ConnectionState.done) {
            return Loading();
          }
          if (snapshot.hasData && snapshot.data.length > 0) {
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
                        title: new Text(
                            AppLocalizations.of(context).translate('settings')),
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
                    return MainPageItem(listObject.id, listObject.name,
                            listObject.score, context)
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
          } else {
            return new Scaffold(
              appBar: AppBar(
                title: Text("GMoria"),
              ),
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
              body: Center(
                  child: Center(
                child: Text("You have currently no lists"),
              )),
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
  final String name;
  final int score;
  final BuildContext context;

  //MainPageItem(this.id, this.heading);
  MainPageItem(this.id, this.name, this.score, this.context);

  List<Users> personInList = new List<Users>();
  var firestoreInstance = FirebaseFirestore.instance;
  var firestoreUser = FirebaseAuth.instance.currentUser;

  Widget buildTitle(BuildContext context) {
    return Slidable(
      actionPane: SlidableStrechActionPane(),
      actionExtentRatio: 0.25,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: <
          Widget>[
        Container(
            child: Row(children: [
          InkWell(
            child: Text(
              name,
              style: Theme.of(context).textTheme.headline5,
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ListPerson(id, name)),
              );
            },
            onLongPress: () {
              print("edit the list " + name);
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
                  AppLocalizations.of(context).translate('lastScore'),
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
                            builder: (context) => SelectionModPage(id, name)),
                      );
                    })
              ],
            )
          ])),
          Container(
              child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context).translate('lastScore'),
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
                              builder: (context) => SelectionModPage(id, name)),
                        );
                      })
                ],
              )
            ],
          ))
        ]),
        
      secondaryActions: <Widget>[
        IconSlideAction(
          caption: AppLocalizations.of(context).translate('Delete'),
          color: Colors.red,
          icon: Icons.delete,
          onTap: () => deleteList(),
        )
      ]
    );
  }

  void deleteList() async {
    //delete all person in the list

    Query query = firestoreInstance
        .collection(firestoreUser.email)
        .doc("users")
        .collection("users");
    await query.get().then((querySnapshot) async {
      querySnapshot.docs.forEach((document) {
        String array = document.data()["lists"].toString();

        for (var i = 1; i < array.length; i++) {
          if (array[i] == ',' || array[i] == ']') {
            if (id == array.substring(i - 20, i)) {
              personInList.add(new Users.withlist(
                  document.id,
                  document.data()["firstname"],
                  document.data()["lastname"],
                  document.data()["image"],
                  document.data()["note"],
                  document.data()["lists"].cast<String>().toList()));
            }
          }
        }
      });
    });

    personInList.forEach((person) {
      List<String> finalListPerson = person.lists;
      String stringToRemove = "";

      finalListPerson.forEach((element) {
        if (element == id) {
          stringToRemove = element;
        }
      });

      finalListPerson.remove(stringToRemove);

      if (finalListPerson.isNotEmpty) {
        firestoreInstance
            .collection(firestoreUser.email)
            .doc("users")
            .collection("users")
            .doc(person.id)
            .update({
              'lists': finalListPerson,
            })
            .then((value) => print("User deleted"))
            .catchError((error) => print("Failed to modify person: $error"));
      } else {
        FirebaseFirestore.instance
            .collection(FirebaseAuth.instance.currentUser.email)
            .doc("users")
            .collection("users")
            .doc(person.id)
            .delete()
            .then((value) => print("User deleted"))
            .catchError((error) => print("Failed to delete person: $error"));
      }
    });

    //delete the list itself
    firestoreInstance
        .collection(firestoreUser.email)
        .doc(id)
        .delete()
        .then((value) => print("List deleted"))
        .catchError((error) => print("Failed to delete list: $error"));

    Navigator.push(
        context, MaterialPageRoute(builder: (context) => ListsPage()));
  }

  Future<void> getAllUsersFromAList() async {
    Query query = firestoreInstance
        .collection(firestoreUser.email)
        .doc("users")
        .collection("users");
    await query.get().then((querySnapshot) async {
      querySnapshot.docs.forEach((document) {
        String array = document.data()["lists"].toString();

        for (var i = 1; i < array.length; i++) {
          if (array[i] == ',' || array[i] == ']') {
            if (id == array.substring(i - 20, i)) {
              personInList.add(new Users.withlist(
                  document.id,
                  document.data()["firstname"],
                  document.data()["lastname"],
                  document.data()["image"],
                  document.data()["note"],
                  document.data()["lists"].cast<String>().toList()));
            }
          }
        }
      });
    });
  }
}
