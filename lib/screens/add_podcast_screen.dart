import 'package:flutter/material.dart';
import 'package:podcastapp/blocs/podcast_bloc.dart';
import 'package:podcastapp/models/Podcast.dart';
import 'package:podcastapp/podcast_fetcher.dart';

class AddPodcastScreen extends StatefulWidget {
  final PodcastBloc bloc;

  const AddPodcastScreen({Key key, this.bloc}) : super(key: key);

  @override
  _AddPodcastScreenState createState() => _AddPodcastScreenState();
}

class _AddPodcastScreenState extends State<AddPodcastScreen> {
  String url = "";
  TextEditingController _controller = new TextEditingController();
  bool loading = false;
  String error = "";
  Podcast podcast;
  @override
  void initState() {
    _controller.addListener(() {
      setState(() {
        url = _controller.text;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                  child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  labelText: "Podcast URL",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.zero,
                      borderSide: BorderSide(width: 1.0)),
                  contentPadding: EdgeInsets.all(10.0),
                ),
              )),
              FlatButton(
                color: Theme.of(context).primaryColor,
                child: Text(
                  "ADD",
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: fetchPodcast,
              )
            ],
          ),
          Row(
            children: <Widget>[
              Text("e.g. https://www.npr.org/rss/podcast.php?id=510313"),
              IconButton(
                onPressed: () {
                  // setState(() {
                  _controller.value = TextEditingValue(
                      text: "https://www.npr.org/rss/podcast.php?id=510313");
                  // });
                },
                icon: Icon(Icons.content_copy),
              )
            ],
          ),
          SizedBox(height: 20.0),
          (loading) ? CircularProgressIndicator() : Container(),
          (podcast != null) ? _buildPodcast() : Container(),
          Text(error)
        ],
      ),
    );
  }

  Widget _buildPodcast() {
    return Column(
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6.0),
                child: Container(
                  child: podcast.image != ""
                      ? Image.network(
                          podcast.image,
                          width: double.infinity,
                          fit: BoxFit.cover,
                        )
                      : Image.asset("assets/default.jpg"),
                ),
              ),
            ),
            Expanded(
              child: Container(
                padding: EdgeInsets.all(5.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      podcast.title,
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      podcast.description,
                      maxLines: 6,
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 10.0),
                    Text("${podcast.totalEpisodes} Episodes"),
                  ],
                ),
              ),
            )
          ],
        ),
        Container(
          width: double.infinity,
          child: RaisedButton(
            color: Colors.blueAccent,
            textColor: Colors.white,
            child: Text("Save"),
            onPressed: savePodcast,
          ),
        ),
      ],
    );
  }

  void savePodcast() {
    widget.bloc.p.save(podcast).then((v) {
      widget.bloc.refresh.add(1);
      Navigator.pop(context);
    }).catchError((e) {
      setState(() {
        error = (e as FormatException).message;
      });
    });
  }

  void fetchPodcast() async {
    setState(() {
      loading = true;
    });
    try {
      Podcast p = await PodcastFetcher.fetchPodcast(url);
      print("herer");
      setState(() {
        loading = false;
        podcast = p;
        print(p);
      });
    } catch (e, s) {
      print("in catch");
      print(e);
      print(s);
      setState(() {
        loading = false;
        error = "there is error in parsing podcast";
      });
    }
  }
}
