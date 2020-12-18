import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gmoria_grp4/Setup/loading.dart';
import 'package:gmoria_grp4/add_list.dart';
import 'package:gmoria_grp4/Objects/listsObject.dart';
import 'package:gmoria_grp4/list_person.dart';
import 'package:gmoria_grp4/selection_mode.dart';

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
                automaticallyImplyLeading: false,
                title: Text("GMoria"),
              ),
              body: ListView.builder(
                  itemCount: snapshot.data.length,
                  itemBuilder: (BuildContext context, int index) {
                    final ListObject listObject = snapshot.data[index];
                    return MainPageItem(listObject.id, listObject.name)
                        .buildTitle(context);
                    //method to test that the long press work(for the edit function)
                  }),
              floatingActionButton: FloatingActionButton(
                onPressed: () {
                  Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => AddList()),
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
        if(document.id.length > 6){
          lists.add(new ListObject(document.id, document.data().values.first));
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
  final String score = '10/20';
  final String scoreHeading = 'Last score';

  MainPageItem(this.id, this.heading);

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
