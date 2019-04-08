import 'package:meta/meta.dart';
// import 'package:xml/xml.dart' as xml;

class Episode {
  String url;
  String title;
  String image;
  String description;
  String keywords;
  String date;

  Episode({
    @required this.title,
    @required this.image,
    this.description,
    this.keywords,
    this.date,
  })  : assert(title != null),
        assert(image != null);

  Episode.fromXML(var node) {
    this.title = node.first.findElements("title");
    this.date = node.first.findElements("pubDate");
    this.description = node.first.findElements("itunes:summary");
    this.image = node.first.findElements("itunes:image");
    this.keywords = node.first.findElements("itunes:keywords");
    this.url = node.first.findElements("itunes:url");
  }
}
