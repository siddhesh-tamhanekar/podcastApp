import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:media_player/data_sources.dart';
import 'package:media_player/media_player.dart';
import 'package:podcastapp/models/Episode.dart';

class EpisodeListing extends StatefulWidget {
  const EpisodeListing({Key key, @required this.player, this.episodeList})
      : super(key: key);

  final MediaPlayer player;
  final List episodeList;
  @override
  _EpisodeListingState createState() => _EpisodeListingState();
}

class _EpisodeListingState extends State<EpisodeListing> {
  int currentIndex;
  MediaFile source;
  bool next, prev, isPlaying;
  @override
  void initState() {
    super.initState();
    next = false;
    prev = false;
    isPlaying = false;
    if (!mounted) return;
    widget.player.valueNotifier.addListener(listener);
  }

  @override
  void dispose() {
    widget.player.valueNotifier.removeListener(listener);
    super.dispose();
  }

  void listener() {
    if (widget.player.valueNotifier.value.getCurrrentMediaFile != source ||
        widget.player.valueNotifier.value.currentIndex != currentIndex ||
        widget.player.valueNotifier.value.next != next ||
        widget.player.valueNotifier.value.prev != prev ||
        widget.player.valueNotifier.value.isPlaying != isPlaying) {
      setState(() {
        source = widget.player.valueNotifier.value.getCurrrentMediaFile;
        currentIndex = widget.player.valueNotifier.value.currentIndex;
        next = widget.player.valueNotifier.value.next;
        prev = widget.player.valueNotifier.value.prev;
        isPlaying = widget.player.valueNotifier.value.isPlaying;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
      Episode e = widget.episodeList.elementAt(index);
      return _buildEpisode(e, index);
    }, childCount: widget.episodeList.length));
  }

  Widget _buildEpisode(Episode e, int index) {
    return Column(
      children: <Widget>[
        GestureDetector(
          onTap: () {
            if (widget.player.valueNotifier.value.initialized) {
              widget.player.playAt(index);
              widget.player.play();
            }
          },
          child: Container(
            color:
                (index == currentIndex) ? Colors.grey[300] : Colors.transparent,
            child: ListTile(
              leading: Container(
                height: 30.0,
                width: 30.0,
                child: e.image != ""
                    ? CachedNetworkImage(
                        fit: BoxFit.cover,
                        imageUrl: e.image,
                        placeholder: (c, url) => CircularProgressIndicator(),
                      )
                    : Image.asset("assets/default.jpg"),
              ),
              title: Text(e.title),
              trailing: Text(
                e.duration,
                style: TextStyle(color: Colors.black54),
              ),
            ),
          ),
        ),
        Divider(
          height: 0.0,
        )
      ],
    );
  }
}
