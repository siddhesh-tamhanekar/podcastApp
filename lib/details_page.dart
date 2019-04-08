import 'package:flutter/material.dart';
import 'package:podcastapp/Podcast.dart';

class DetailsPage extends StatefulWidget {
  final Podcast podcast;
  // final BuildContext context;
  DetailsPage(this.podcast);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Hero(
            tag: widget.podcast.url,
            child: Image.network(
              widget.podcast.image,
              // width: 300.0,
            ),
          ),
          //Image.network(widget.podcast.image),
          Container(
            padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 4.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(widget.podcast.title,
                    textAlign: TextAlign.left,
                    style: TextStyle(fontSize: 24.0)),
                SizedBox(height: 10.0),
                Text(
                  widget.podcast.description,
                  textAlign: TextAlign.left,
                  style: TextStyle(fontSize: 14.0, color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
