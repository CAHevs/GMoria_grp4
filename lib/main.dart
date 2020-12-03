import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:gmoria_grp4/Setup/loading.dart';
import 'package:gmoria_grp4/Setup/signIn.dart';
import 'package:gmoria_grp4/Setup/somethingWentWrong.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  //Create the initialization Future outside of build
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    final title = 'GMoria Group 4';

    return FutureBuilder(
      //Initialize FlutterFire
      future: _initialization,
      builder: (context, snapshot) {
        //Check for errors
        if (snapshot.hasError) {
          return SomethingWentWrong();
        }

        //Once complete, show the app
        if (snapshot.connectionState == ConnectionState.done) {
          return MaterialApp(
            title: title,
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
            //Return the login page
            home: LoginPage(),
          );
        }

        //Otherwise, show the loading page
        return Loading();
      },
    );

    /*return MaterialApp(
      title: title,
      home: Scaffold(
        appBar: AppBar(
          title: Text(title),
        ),
        body: ListView.builder(
          // Let the ListView know how many items it needs to build.
          itemCount: items.length,
          // Provide a builder function. This is where the magic happens.
          // Convert each item into a widget based on the type of item it is.
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
                  MaterialPageRoute(
                      builder: (context) => ListPage(index, persons)),
                );
              },
            );
          },
        ),
      ),
    );*/
  }
}

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);
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

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  Widget buildTitle(BuildContext context) => Text(sender);
}

class ListPage extends StatelessWidget {
  final int indexCaller;
  final List<ListItem> persons;
  ListPage(this.indexCaller, this.persons);
  @override
  Widget build(BuildContext context) {
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

class PersonCard extends StatelessWidget {
  final String personName;
  PersonCard(this.personName);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(personName + " Card"),
      ),
      body: Center(child: buildInfoCard(context)),
    );
  }

  Widget buildInfoCard(BuildContext context) => Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
                icon: Icon(Icons.info_outline),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PersonDetails()));
                }),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('images/hell_dice.png'),
          ),
          //Text("Name of the person"),
          Padding(
            padding: EdgeInsets.all(30),
            child: Text('Name of the person'),
          ),
        ],
      );
}

//Class for the page with all the information regarding a person
class PersonDetails extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firstname Lastname"),
      ),
      body: Center(
        child: buildAllInformation(),
      ),
    );
  }

  //Widget that will build all the fields
  Widget buildAllInformation() => Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('images/hell_dice.png'),
          ),
          Text('Email'),
          Text('Phone number'),
          Container(
              width: 300,
              child: TextField(
                keyboardType: TextInputType.multiline,
                maxLines: null,
                decoration: new InputDecoration(
                    border: new OutlineInputBorder(
                        borderSide: new BorderSide(color: Colors.grey)),
                    hintText: 'Add notes regarding the person',
                    labelText: 'Notes'),
              ))
        ],
      );
}
