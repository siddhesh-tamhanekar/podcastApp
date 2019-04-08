import 'package:flutter/foundation.dart';
import 'package:podcastapp/Podcast.dart';
import 'package:rxdart/rxdart.dart';
import 'package:http/http.dart' show get;
import 'package:xml/xml.dart' as xml;

class PodcastBloc {
  Stream<PodcastListing> podcasts;
  BehaviorSubject<int> page;
  PublishSubject<int> loadingState;

  PodcastListing podcastslist;
  PodcastBloc() {
    loadingState = new PublishSubject<int>();
    podcastslist = PodcastListing();
    page = new BehaviorSubject<int>();

    podcasts = page.asyncMap(fetchPodcasts);
    page.add(1);
  }

  Future<PodcastListing> fetchPodcasts(int page) async {
    if (page == 1) {
      loadingState.add(0);
    } else
      loadingState.add(1); //loading

    var urls = [
      "https://bqallyouneedtoknow.libsyn.com/rss",
      "https://rss.art19.com/call-your-girlfriend",
      "https://rss.art19.com/tim-ferriss-show"
    ];
    for (var item in urls) {
      print("url $item");
      var results = await get(item);
      print("podcasts fetched");
      final p = await compute(
          getPodcast, {"response": results.body, "url": item},
          debugLabel: "Bg");

      podcastslist.append(p);
    }
    podcastslist.setPage(page);
    loadingState.add(2); // loaded
    return podcastslist;
  }
}

Podcast getPodcast(Map m) {
  xml.XmlDocument rss = xml.parse(m["response"]);
  print("xml parsed");
  var channel = rss.findAllElements("channel");
  print("tag fetched parsed");
  return Podcast.fromXML(channel, m['url']);
}

class PodcastListing {
  int page;
  List<Podcast> podcastslisting = [];
  void setPage(page) {
    this.page = page;
  }

  void append(Podcast podcast) {
    print("appending $podcast");
    // print("PodcastLength ${podcastslisting.length}");

    podcastslisting.add(podcast);
    // print("PodcastLength $podcastslisting.length");
  }
}
