import 'package:flutter/material.dart';
import 'package:podcastapp/blocs/podcast_bloc.dart';
import 'package:podcastapp/screens/add_podcast_screen.dart';
import 'package:podcastapp/screens/podcast_listing_screen.dart';
import 'package:podcastapp/widgets/title_bar.dart';

void main() => runApp(MaterialApp(
      home: MyApp(),
      debugShowCheckedModeBanner: false,
    ));

class MyApp extends StatelessWidget {
  final PodcastBloc bloc = new PodcastBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        floatingActionButton: FloatingActionButton(
          tooltip: "Add Podcast Feed",
          child: Icon(Icons.add),
          onPressed: () {
            shwoBottomSheet(context);
          },
        ),
        body: SafeArea(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10.0),
            child: CustomScrollView(
              slivers: <Widget>[
                new TitleBar(),
                PodcastListingScreen(bloc, this),
              ],
            ),
          ),
        ));
  }

  void shwoBottomSheet(BuildContext context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return AddPodcastScreen(bloc: bloc);
        });
  }
}
