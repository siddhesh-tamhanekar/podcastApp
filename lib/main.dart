import 'package:flutter/material.dart';
import 'package:podcastapp/Podcast.dart';
import 'package:podcastapp/podcast_bloc.dart';
import 'package:podcastapp/title_bar.dart';
import 'package:podcastapp/details_page.dart';

void main() => runApp(MaterialApp(home: MyApp()));

class MyApp extends StatelessWidget {
  final PodcastBloc bloc = new PodcastBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SafeArea(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10.0),
        child: CustomScrollView(
          slivers: <Widget>[
            new TitleBar(),
            buildGrid(context),
            buildLoading(context),
          ],
        ),
      ),
    ));
  }

  SliverToBoxAdapter buildLoading(BuildContext context) {
    return SliverToBoxAdapter(
      child: GestureDetector(
        onTap: () {
          print("tapped");
          bloc.page.add(1);
        },
        child: Center(
          child: StreamBuilder<Object>(
            stream: bloc.loadingState,
            builder: (context, snapshot) {
              if (snapshot.data == 1) return CircularProgressIndicator();
              return Container();
            },
          ),
        ),
      ),
    );
  }

  StreamBuilder<Object> buildGrid(BuildContext context) {
    return StreamBuilder<Object>(
        stream: bloc.podcasts,
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.data is PodcastListing) {
            // print(snapshot.data.podcastslisting);
            return SliverGrid(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12.0,
                childAspectRatio: 0.8,
                mainAxisSpacing: 12.0,
              ),
              delegate: SliverChildBuilderDelegate((c, i) {
                // // fetch next page if going at end.
                // if (snapshot.data.podcasts.length < (i + 4))
                //   bloc.page.add(snapshot.data.page);

                return buildCard(snapshot.data.podcastslisting[i], context);
              }, childCount: snapshot.data.podcastslisting.length),
            );
          } else {
            return SliverToBoxAdapter(
                child: GestureDetector(
              onTap: () {
                print("tapped");
                bloc.page.add(1);
              },
              child: SizedBox(
                  height: 300.0,
                  child: Center(
                    child: CircularProgressIndicator(),
                  )),
            ));
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
          color: Colors.transparent,
          elevation: 0.0,
          child: Column(
            children: <Widget>[
              Hero(
                tag: podcast.url,
                child: Image.network(
                  podcast.image,
                  width: 300.0,
                ),
              ),
              Container(
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
                  child: Text(
                    podcast.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textScaleFactor: 1,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12.0,
                      fontWeight: FontWeight.w600,
                    ),
                  )),
            ],
          )),
    );
  }
}
