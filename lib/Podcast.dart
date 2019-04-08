import 'package:meta/meta.dart';
// import 'package:xml/xml.dart' as xml;

class Podcast {
  String url;
  var title;
  var image;
  var description;
  var keywords;
  var date;

  Podcast({
    @required this.title,
    @required this.image,
    this.description,
    this.keywords,
    this.date,
  })  : assert(title != null),
        assert(image != null);

  Podcast.fromXML(var node, var url) {
    this.url = url;
    this.title = node.first.findElements("title").single.text;
    print("title done");

    // this.date = node.first.findElements("pubDate").single.text;
    // print("date done");

    this.description = node.first.findElements("itunes:summary").single.text;
    print("desc done");

    this.image =
        node.first.findElements("itunes:image").single.getAttribute("href");
    print("image done");
    this.keywords = node.first.findElements("itunes:keywords").single.text;
    print("keywords done");

    print(" $image");
  }

  List getEpisodes() {
    var episodes = [];
    //fetch rss url
    // parse xml and send episodes
    return episodes;
  }
}
