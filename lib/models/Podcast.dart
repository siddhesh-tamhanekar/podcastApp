import 'package:meta/meta.dart';

class Podcast {
  String url;
  var title;
  var image;
  var description;
  var keywords;
  var date;
  int totalEpisodes;

  Podcast({
    @required this.title,
    @required this.image,
    this.description,
    this.keywords,
    this.date,
  })  : assert(title != null),
        assert(image != null);

  Podcast.fromJSON(var json) {
    this.url = json['url'];
    this.title = json['title'];
    this.description = json['description'];
    this.image = json['image'];
    this.keywords = json['keywords'];
    this.totalEpisodes = json['totalEpisodes'];
  }

  Map toJson() {
    return {
      'url': this.url,
      'title': this.title,
      'description': this.description,
      'image': this.image,
      'keywords': this.keywords,
      'totalEpisodes': this.totalEpisodes
    };
  }

  Podcast.fromXML(var node, var url) {
    this.url = url;

    var title = node.findElements("title");
    if (title != null) this.title = title.single.text;
    print("fetching description");

    try {
      var description = node.findElements("itunes:summary");
      if (description != null) this.description = description.single.text;
    } catch (e) {
      this.description = "N/A";
    }
    try {
      var image = node.findElements("itunes:image");
      if (image != null) this.image = image.single.getAttribute("href");
    } catch (e) {
      this.image = "";
    }
    try {
      var keywords = node.findElements("itunes:keywords");
      if (keywords.length > 0) this.keywords = keywords.single.text;
    } catch (e) {
      this.keywords = null;
    }
    this.totalEpisodes = node.findElements("item").length;
  }
}
