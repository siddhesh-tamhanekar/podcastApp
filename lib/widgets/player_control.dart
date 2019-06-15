import 'package:flutter/material.dart';
import 'package:media_player/data_sources.dart';
import 'package:media_player/media_player.dart';

class PlayerControl extends StatefulWidget {
  const PlayerControl(
      {Key key,
      @required this.t4,
      @required this.player,
      @required this.visible})
      : super(key: key);

  final Animation t4;
  final MediaPlayer player;
  final bool visible;

  @override
  _PlayerControlState createState() => _PlayerControlState();
}

class _PlayerControlState extends State<PlayerControl> {
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
    print("Building Player control $source");
    return (widget.visible == false)
        ? Container()
        : Column(
            children: <Widget>[
              source != null
                  ? Text(
                      source.title,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                          fontSize: 14.0, fontWeight: FontWeight.bold),
                    )
                  : Text(""),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  AnimatedBuilder(
                    animation: widget.t4,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: widget.t4.value,
                        child: child,
                      );
                    },
                    child: FloatingActionButton(
                      heroTag: "prev",
                      child: Icon(Icons.skip_previous),
                      onPressed: prev
                          ? () {
                              widget.player.playPrev();
                            }
                          : null,
                    ),
                  ),
                  SizedBox(width: 10.0),
                  AnimatedBuilder(
                    animation: widget.t4,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: widget.t4.value,
                        child: child,
                      );
                    },
                    child: FloatingActionButton(
                      heroTag: "pause",
                      child: isPlaying
                          ? Icon(Icons.pause)
                          : Icon(Icons.play_arrow),
                      onPressed: () {
                        widget.player.togglePlayPause();
                      },
                    ),
                  ),
                  SizedBox(width: 10.0),
                  AnimatedBuilder(
                    animation: widget.t4,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: widget.t4.value,
                        child: child,
                      );
                    },
                    child: FloatingActionButton(
                      heroTag: "next",
                      child: Icon(Icons.skip_next),
                      onPressed: () {
                        widget.player.playNext();
                      },
                    ),
                  ),
                ],
              ),
            ],
          );
  }
}
