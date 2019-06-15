import 'package:flutter/foundation.dart';
import 'package:http/http.dart' show get;
import 'package:podcastapp/models/Episode.dart';
import 'package:podcastapp/models/Podcast.dart';
import 'package:xml/xml.dart' as xml;

class PodcastFetcher {
  static Future<Podcast> fetchPodcast(String url) async {
    var response = await get(url);
    print("podcasts fetched");
    final channel = await compute(
        getPodcast, {"response": response.body, "url": url},
        debugLabel: "bg");

    // print("returning podcast $channel");
    return channel;
  }

  static Future<List<Episode>> fetchPodcastEpisodes(String url) async {
    var response = await get(url);
    print("podcasts fetched");
    final channel =
        await compute(getPodcastEpisodes, response.body, debugLabel: "bg");

    // print("returning podcast $channel");
    return channel;
  }
}

List<Episode> getPodcastEpisodes(body) {
  xml.XmlDocument rss = xml.parse(body);
  print("xml parsed");
  List<Episode> episdoeList = [];
  var episodes = rss.findAllElements("item");
  for (var i in episodes) {
    Episode episode = Episode.fromXML(i);
    if (episode.url != null) episdoeList.add(episode);
    print("episode appended $i");
  }
  print("total episode created ${episdoeList.length}");
  return episdoeList;
}

Podcast getPodcast(Map m) {
  xml.XmlDocument rss = xml.parse(m["response"]);
  print("xml parsed");
  var channel = rss.findAllElements("channel");
  return Podcast.fromXML(channel.first, m['url']);
}
