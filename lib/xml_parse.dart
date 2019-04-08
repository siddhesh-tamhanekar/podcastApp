import 'package:xml/xml.dart' as xml;
import 'package:http/http.dart' show get;

void main() async {
  // var bookshelfXml = '''<?xml version="1.0"?>
  //   <bookshelf>
  //     <book>
  //       <title lang="english">Growing a Language</title>
  //       <price>29.99</price>
  //     </book>
  //     <book>
  //       <title lang="english">Learning XML</title>
  //       <price>39.95</price>
  //     </book>
  //     <price>132.00</price>
  //   </bookshelf>''';
  // var document = xml.parse(bookshelfXml);
  // var elements = document.findAllElements("book");
  // for (var item in elements) {
  //   var title = item.findElements("title");
  //   print(title.single.text);
  // }

  var results = await get("https://bqallyouneedtoknow.libsyn.com/rss");
  xml.XmlDocument rss = xml.parse(results.body);
  var channel = rss.findAllElements("channel");
  if (channel.length == 1) {
    var title = channel.first.findElements("title");
    var date = channel.first.findElements("pubDate");
    var desc = channel.first.findElements("itunes:summary");
    var image = channel.first.findElements("itunes:image");
    var keywords = channel.first.findElements("itunes:keywords");
    var items = channel.first.findElements("item");

    print(title.single.text);
    print(date.single.text);
    print(desc.single.text);
    print(image.single.text);
    print(keywords.single.text.split(","));
    print("Total Episodes : ${items.length}");
  }
  // print(elements);
}
