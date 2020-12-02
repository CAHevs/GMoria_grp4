import 'package:flutter/material.dart';

void main() {
  runApp(MyApp(
    items: List<ListItem>.generate(
      5,
      (i) => MainPageItem("List $i")
    ),
  ));
}

class MyApp extends StatelessWidget {
  final List<ListItem> items;

  MyApp({Key key, @required this.items}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final title = 'GMoria Group 4';
    final persons = List<ListItem>.generate(2, (index) => (HeadingItem("Person $index")));

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
                 MaterialPageRoute(builder: (context) => ListPage(index, persons)),);
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

class MainPageItem implements ListItem {
  final String heading;
  final String score = '10/20';
  final String scoreHeading = 'Last score';

  MainPageItem(this.heading);

  Widget buildTitle(BuildContext context) {
    return 
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
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
                    onPressed: 
                    (){
                  Navigator.push(context, 
                  MaterialPageRoute(builder: (context) => SelectionModPage()),);
                }
              )],)
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

class ListPage extends StatelessWidget{

  final int indexCaller;
  final List<ListItem> persons;
  ListPage(this.indexCaller, this.persons);
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text("Inside the list "+indexCaller.toString()),
        
      ),
      body: ListView.builder(
        itemCount: persons.length,
        itemBuilder: (context, index) {
            final item = persons[index];

            return ListTile(
              title: item.buildTitle(context),
              onTap: (){
                 Navigator.push(context, 
                 MaterialPageRoute(builder: (context) => PersonCard(persons.elementAt(index).toString())));
              },
            );
          },
      ),
    );
  }
  
}

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



class SelectionModPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Select game mode"),
      ),
      body: Center(
        child: SelectionModeRows().build(context),
        ),
    );
  }



}

class SelectionModeRows extends StatelessWidget {


Widget build(BuildContext context) {
  return
    Container(
      child: 
      Column(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          TrainingModeButton().buildTitle(context),
           TrainingModeButton().buildTitle(context),
      ],)
    );
    
}

}

//Training mode button
class TrainingModeButton implements ModeButton {

Widget buildTitle(BuildContext context) {
    return 
      Container(
          height: 100.0,
          width: 270.0,
          decoration: BoxDecoration(boxShadow: [
            BoxShadow(
              offset: Offset(0.0, 20.0),
              blurRadius: 30.0,
              color: Colors.black12)
          ], color: Colors.white, borderRadius:  BorderRadius.circular(50.0)),
          child: Row( mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Container(
                height: 100.0,
                width: 220.0,
                padding: 
                  EdgeInsets.symmetric(vertical: 35.0, horizontal: 20.0),
                child: Text('Training mode', style: TextStyle(
                    fontSize: 17.0,
                    color: Colors.black87
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.greenAccent,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(95.0),
                    topLeft: Radius.circular(95.0),
                    bottomRight: Radius.circular(200.0)
                  )
                ),
              ),
              Icon(Icons.home, 
              size: 40.0,
              )
            ],),
        );

    
  }

}


abstract class ModeButton {

  Widget buildTitle(BuildContext context);
}




//Class for the page with all the information regarding a person
class PersonDetails extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
   return Scaffold(
      appBar: AppBar(
        title: Text("Firstname Lastname"),
      ),
      body: Center(child:  buildAllInformation(),),
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
      Container(width: 300, child: 
        TextField(
          keyboardType: TextInputType.multiline, 
          maxLines: null, 
          decoration: new InputDecoration(
            border: new OutlineInputBorder(
              borderSide: new BorderSide(color: Colors.grey)
            ),
            hintText: 'Add notes regarding the person',
            labelText: 'Notes'
          ),)
      )
    ],
  );
}