import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:podcastapp/models/Podcast.dart';
import 'package:podcastapp/screens/details_page.dart';
import 'package:podcastapp/widgets/no_podcast_found.dart';

class PodcastListingScreen extends StatelessWidget {
  final bloc;
  final parent;
  PodcastListingScreen(this.bloc, this.parent);
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<Object>(
        stream: bloc.podcasts,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data is List<Podcast>) {
            if (snapshot.data.length == 0) {
              return new NoPodcastFound(parent: parent);
            }
            return SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                childAspectRatio: 0.8,
                mainAxisSpacing: 12.0,
              ),
              delegate: SliverChildBuilderDelegate((c, i) {
                return buildCard(snapshot.data[i], context);
              }, childCount: snapshot.data.length),
            );
          } else {
            return SliverToBoxAdapter(
                child: SizedBox(
                    height: 300.0,
                    child: Center(
                      child: CircularProgressIndicator(),
                    )));
          }
        });
  }

  Widget buildCard(Podcast podcast, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(context,
            new MaterialPageRoute(builder: (BuildContext context) {
          return DetailsPage(podcast);
        }));
      },
      child: Card(
          // color: Colors.transparent,
          elevation: 2.0,
          child: Column(
            children: <Widget>[
              Hero(
                  tag: podcast.url,
                  child: CachedNetworkImage(
                    imageUrl: podcast.image,
                  )),
              Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  child: Text(
                    podcast.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 12.0),
                  )),
            ],
          )),
    );
  }
}
