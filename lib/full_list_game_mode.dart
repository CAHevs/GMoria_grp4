import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class PlayList extends StatelessWidget {

  final List<String> names = ["Nicolas Constantin", "Piranavan Thambirajah"];
  PlayList();

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(title: new Text("Full list game mode"),
      ),
      body: Swiper(
        itemCount: names.length,
        itemBuilder: (BuildContext context, int index) {
          return SwipeableCard(names[index]);
        },
        viewportFraction: 0.8,
        scale: 0.9,
        layout: SwiperLayout.DEFAULT,
        itemHeight: 500.0,
        itemWidth: 300.0,
        )
    );

  }

}

class SwipeableCard extends StatelessWidget{

  String name;
  SwipeableCard(this.name);
  Widget build(BuildContext context) {
    return 
    Container(
      child: Column (
        mainAxisAlignment: MainAxisAlignment.start, 
        children: [
          Padding(padding: EdgeInsets.fromLTRB(0,6,0,0),
          child: 
            ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Image.asset('images/profil.png', 
            height: 300.0,
            width: 375.0,),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Expanded(
                child: TextField(
                    decoration: InputDecoration(
                     border: OutlineInputBorder(),
                     labelText: 'Name of the person',
                  ),
                ),
              ),
              Expanded(
                child: IconButton(icon: Icon(Icons.check_box_outlined), onPressed: null),
              )
            ],
          ),
        ],
      ),
    );
  }
}