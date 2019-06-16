import 'package:flutter/material.dart';

class NoPodcastFound extends StatelessWidget {
  const NoPodcastFound({
    Key key,
    @required this.parent,
  }) : super(key: key);

  final parent;

  @override
  Widget build(BuildContext context) {
    return SliverFillRemaining(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(
            Icons.info_outline,
            size: 96.0,
            color: Colors.grey[300],
          ),
          SizedBox(height: 2.0),
          Text(
            "No Podcasts Found",
            style: Theme.of(context).textTheme.caption,
          ),
          SizedBox(height: 10.0),
          RaisedButton(
            color: Theme.of(context).primaryColor,
            textColor: Colors.white,
            child: Text("Add Podcast"),
            onPressed: () => parent.shwoBottomSheet(context),
          ),
          // SizedBox(height: 80.0)
        ],
      ),
    );
  }
}
