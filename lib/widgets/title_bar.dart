import 'package:flutter/material.dart';

class TitleBar extends StatelessWidget {
  const TitleBar({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SliverToBoxAdapter(
      child: Container(
        // height: 70.0,
        padding: EdgeInsets.symmetric(vertical: 25.0),
        child: Text(
          "PodcastApp",
          style: Theme.of(context)
              .textTheme
              .headline
              .copyWith(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
