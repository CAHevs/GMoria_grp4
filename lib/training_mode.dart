import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:gmoria_grp4/person_details.dart';

//class for show the training mode with swipe cards
class TrainingList extends StatelessWidget {
  //some brut data for display
  final List<String> names = ["Nicolas Constantin", "Piranavan Thambirajah"];

  @override
  //for each person we build a card and we can swipe through them
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Training mode"),
        ),
        body: Swiper(
          itemCount: names.length,
          itemBuilder: (BuildContext context, int index) {
            return SwipeableCard(names[index]); //the cards
          },
          viewportFraction: 0.8,
          scale: 0.9,
          layout: SwiperLayout.DEFAULT,
          itemHeight: 500.0,
          itemWidth: 300.0,
        ));
  }
}

//the class for the cards, it creates a card model with image, name and info icon
class SwipeableCard extends StatelessWidget {
  String name;
  SwipeableCard(this.name);
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Align(
            alignment: Alignment.bottomRight,
            child: IconButton(
                icon: Icon(Icons.info_outline),
                iconSize: 50.0,
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => PersonDetails()));
                }),
          ),
          ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset(
              'images/profil.png',
              height: 400.0,
              width: 500.0,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(30),
            child: Text(name,
                style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
