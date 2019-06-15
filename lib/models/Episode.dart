import 'package:meta/meta.dart';

class Episode {
  String url;
  String title;
  String image;
  String description;
  String keywords;
  String duration;
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
    // print(node);
    var title = node.findElements("title");

    if (title != null) this.title = title.single.text;

    try {
      var image = node.findElements("itunes:image");
      if (image != null) this.image = image.single.getAttribute("href");
    } catch (e) {
      this.image = "";
    }

    var url = node.findElements("enclosure");
    if (url.length != 0) this.url = url.single.getAttribute("url");

    try {
      if (node.findElements("itunes:duration").length != 0)
        this.duration = node.findElements("itunes:duration").single.text;
    } catch (e) {
      this.duration = "N/A";
    }
  }
}
