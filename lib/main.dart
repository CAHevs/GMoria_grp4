import 'package:flutter/material.dart';

void main() {
  runApp(MyApp(
    items: List<ListItem>.generate(
      5,
      (i) => HeadingItem("List $i")
    ),
  ));
}

class MyApp extends StatelessWidget {
  final List<ListItem> items;

  MyApp({Key key, @required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = 'GMoria Group 4';

    return MaterialApp(
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
              onLongPress: () => Scaffold
                .of(context)
                .showSnackBar(SnackBar(content: Text("You clicked on the list " + index.toString()))),
              onTap: (){
                 Navigator.push(context, 
                 MaterialPageRoute(builder: (context) => ListPage(index)),);
              },
            );
          },
        ),
      ),
    );
  }
}

/// The base class for the different types of items the list can contain.
abstract class ListItem {
  /// The title line to show in a list item.
  Widget buildTitle(BuildContext context);

}

/// A ListItem that contains data to display.
class HeadingItem implements ListItem {
  final String heading;
  final String score = '10/20';
  final String scoreHeading = 'Last score';

  HeadingItem(this.heading);

  Widget buildTitle(BuildContext context) {
    return 
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                    onPressed: null)
              ],)
          ],)

        )
        
      ]);

    
  }
}

/// A ListItem that contains data to display a message.
class MessageItem implements ListItem {
  final String sender;
  final String body;

  MessageItem(this.sender, this.body);

  Widget buildTitle(BuildContext context) => Text(sender);
}

class ListPageItem implements ListItem {
  final String text;

   ListPageItem(this.text);

  Widget buildTitle(BuildContext context){
    return
      Row(mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
          Text(
            text
          )
      ],
      );
  }
}

class ListPage extends StatelessWidget{
  final List<ListItem> items = List<ListItem>.generate(
      5,
      (i) => ListPageItem("item $i")
    );
  final int indexCaller;
  ListPage(this.indexCaller);
  

  @override
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Inside the list "+indexCaller.toString()),
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
            );
          },
        ),
      ),
    );
    
  }
  
}