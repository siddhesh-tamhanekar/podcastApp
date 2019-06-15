import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:media_player/data_sources.dart';
import 'package:media_player/media_player.dart';
import 'package:podcastapp/blocs/podcast_details_bloc.dart';
import 'package:podcastapp/models/Episode.dart';
import 'package:podcastapp/models/Podcast.dart';
import 'package:podcastapp/widgets/episode_listing_widget.dart';
import 'package:podcastapp/widgets/media_player_duration_widgt.dart';
import 'package:podcastapp/widgets/player_control.dart';

class DetailsPage extends StatefulWidget {
  final Podcast podcast;
  // final BuildContext context;
  DetailsPage(this.podcast);

  @override
  _DetailsPageState createState() => _DetailsPageState();
}

class _DetailsPageState extends State<DetailsPage>
    with SingleTickerProviderStateMixin {
  AnimationController _controller;
  Playlist playlist;
  var bloc;
  Animation t1,
      elevationAnimation,
      t3,
      buttonBounceInAnimation,
      t5,
      playbuttonBounceOutAnimation,
      c;
  MediaPlayer player;

  bool playerStarted = false;
  @override
  void initState() {
    _controller = new AnimationController(
        vsync: this, duration: Duration(milliseconds: 1000));

    elevationAnimation = new Tween(begin: 0.0, end: 4.0).animate(_controller);
    buttonBounceInAnimation = CurvedAnimation(
      parent: _controller,
      curve: new Interval(0.7, 1.0, curve: Curves.decelerate),
    );

    playbuttonBounceOutAnimation = new Tween(begin: 1.0, end: 0.0).animate(
        CurvedAnimation(
            parent: _controller,
            curve: new Interval(0.6, 0.7, curve: Curves.bounceInOut)));

    c = CurvedAnimation(parent: _controller.view, curve: Interval(0.0, 0.6));
    t5 = new Tween(begin: 220.0, end: 350.0).animate(c);

    bloc = new PodcastDetailsBloc();
    bloc.url.add(widget.podcast.url);
    player =
        MediaPlayerPlugin.create(isBackground: true, showNotification: true);
    super.initState();
  }

  @override
  void dispose() {
    player.dispose();
    super.dispose();
  }

  void start() async {
    playerStarted = true;
    setState(() {});
    await player.initialize();
    await player.setPlaylist(playlist);
    await player.play();
  }

  double get maxWidth => MediaQuery.of(context).size.width;
  @override
  Widget build(BuildContext context) {
    t1 = new Tween(begin: maxWidth, end: maxWidth * 0.6).animate(c);

    t3 = new Tween(begin: 10.0, end: (maxWidth / 2) - 30).animate(c);

    return Scaffold(
      body: Stack(
        children: <Widget>[
          CustomScrollView(
            slivers: <Widget>[
              SliverToBoxAdapter(
                child: _buildHeroImage(),
              ),
              SliverToBoxAdapter(
                child: buildPodcastDetails(),
              ),
              StreamBuilder(
                stream: bloc.episodeListing,
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (!snapshot.hasData) {
                    return SliverFillRemaining(
                        child: Center(child: CircularProgressIndicator()));
                  }

                  if (snapshot.hasError) {
                    return SliverFillRemaining(
                        child: Center(
                            child: Text("there is error parsing podcast")));
                  }
                  var p = snapshot.data as List;
                  List<MediaFile> list = [];
                  for (Episode i in p) {
                    list.add(MediaFile(
                        type: "audio", source: i.url, title: i.title));
                  }
                  playlist = new Playlist(list);
                  return EpisodeListing(player: player, episodeList: p);
                },
              ),
            ],
          ),
          StreamBuilder<Object>(
              stream: bloc.episodeListing,
              builder: (context, snapshot) {
                if (!snapshot.hasData) return Container();
                return AnimatedBuilder(
                  animation: t3,
                  builder: (context, child) {
                    return Positioned(
                      right: t3.value,
                      top: t5.value,
                      child: Transform.scale(
                          scale: playbuttonBounceOutAnimation.value,
                          child: child),
                    );
                  },
                  child: FloatingActionButton(
                    heroTag: "play",
                    child: Icon(Icons.play_arrow),
                    onPressed: () {
                      _controller.forward();
                      start();
                    },
                  ),
                );
              }),
        ],
      ),
    );
  }

  Widget buildPodcastDetails() {
    List<Widget> chips = [];
    if (widget.podcast.keywords != null && widget.podcast.keywords != "") {
      var keywords = widget.podcast.keywords.split(",");
      print(widget.podcast.keywords);
      // chips.
      for (var i = 0; i < keywords.length; i++) {
        chips.add(Chip(
          label: Text(keywords[i], style: Theme.of(context).textTheme.caption),
        ));
      }
    }
    // print(chips);
    return Container(
      padding: EdgeInsets.only(top: 15.0, left: 4.0, right: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            widget.podcast.title,
            textAlign: TextAlign.left,
            style: Theme.of(context).textTheme.title,
          ),
          SizedBox(height: 10.0),
          Text(
            (widget.podcast.description.length > 200)
                ? widget.podcast.description.toString().substring(0, 200)
                : widget.podcast.description,
            style: Theme.of(context)
                .textTheme
                .subtitle
                .copyWith(color: Colors.grey),
            textAlign: TextAlign.justify,
          ),
          SizedBox(height: 10.0),
          Wrap(
            runSpacing: 2.0,
            spacing: 2.0,
            runAlignment: WrapAlignment.start,
            children: chips,
          ),
          SizedBox(height: 20.0),
          Text(
            "Episodes (${widget.podcast.totalEpisodes})",
            style: Theme.of(context).textTheme.subhead,
          ),
          // Divider()
        ],
      ),
    );
  }

  Widget _buildHeroImage() {
    return Column(
      children: <Widget>[
        Center(
          child: AnimatedBuilder(
            animation: t1,
            builder: (BuildContext context, Widget child) {
              return Container(
                margin: EdgeInsets.only(top: _controller.value * 50),
                width: t1.value,
                height: 250.0,
                child: Material(
                  elevation: elevationAnimation.value,
                  child: child,
                ),
              );
            },
            child: Hero(
              tag: widget.podcast.url,
              child: CachedNetworkImage(
                  imageUrl: widget.podcast.image, fit: BoxFit.cover),
            ),
          ),
        ),
        playerStarted
            ? ScaleTransition(
                scale: _controller,
                child: new MediaPlayerDurationWidget(player: player),
              )
            : Container(),
        new PlayerControl(
            t4: buttonBounceInAnimation,
            player: player,
            visible: playerStarted),
      ],
    );
  }
}
