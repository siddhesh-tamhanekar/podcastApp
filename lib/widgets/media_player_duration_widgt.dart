import 'package:flutter/material.dart';
import 'package:media_player/media_player.dart';
import 'package:podcastapp/widgets/custom_slider.dart';

class MediaPlayerDurationWidget extends StatefulWidget {
  final MediaPlayer player;
  MediaPlayerDurationWidget({this.player});

  @override
  _MediaPlayerDurationWidgetState createState() =>
      _MediaPlayerDurationWidgetState();
}

class _MediaPlayerDurationWidgetState extends State<MediaPlayerDurationWidget> {
  Duration duration, position;
  bool dragging = false;
  @override
  void initState() {
    super.initState();
    widget.player.valueNotifier.addListener(listener);
  }

  @override
  void dispose() {
    widget.player.valueNotifier.removeListener(listener);
    super.dispose();
  }

  void listener() {
    if (dragging == false) {
      setState(() {
        if (widget.player.valueNotifier.value.initialized) {
          position = widget.player.valueNotifier.value.position;
          duration = widget.player.valueNotifier.value.duration;
          // print(DateTime.now());
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print("$duration,$position");
    return Row(
      children: <Widget>[
        SizedBox(width: 10.0),
        Text(_formatDuration(position)),
        SizedBox(width: 5.0),
        Expanded(
          child: CustomSlider(
            min: 0.0,
            max: duration != null ? duration.inSeconds.roundToDouble() : 10.0,
            value: position != null ? position.inSeconds.roundToDouble() : 0.0,
            onChanged: (double v, bool isDragging) {
              setState(() {
                if (v >= 0.0)
                  position =
                      Duration(seconds: (duration.inSeconds * v).round());
                print("duration $position, $isDragging");
                if (!isDragging) {
                  widget.player.seek(position.inSeconds.round() * 1000,
                      widget.player.valueNotifier.value.currentIndex);
                  dragging = false;
                  return;
                }
                if (dragging == false && isDragging == true) dragging = true;
              });
            },
          ),
        ),
        SizedBox(width: 5.0),
        Text(_formatDuration(duration)),
        SizedBox(
          width: 10.0,
          height: 40.0,
        ),
      ],
    );
  }

  String _formatDuration(Duration duration) {
    if (duration == null) return "";
    int seconds = duration.inSeconds;
    String sec = (seconds % 60).toString().padLeft(2, "0");
    int minutes = ((seconds - num.parse(sec)) / 60).floor();
    String min = (minutes % 60).toString().padLeft(2, "0");
    String hours = (minutes / 60).floor().toString().padLeft(2, "0");
    return (hours != "00") ? "$hours:$min:$sec" : "$min:$sec";
  }
}
