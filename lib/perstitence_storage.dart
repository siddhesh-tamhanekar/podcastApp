import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:podcastapp/models/Podcast.dart';

class PersistentStorage {
  List<Podcast> podcasts = [];
  Future<File> getFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File("${dir.path}/podcasts.json");
  }

  Future<List<Podcast>> load() async {
    print("loading file");
    if (podcasts.length != 0) {
      return podcasts;
    }

    if ((await (await getFile()).exists()) == false) {
      print("no content found");
      return Future(() => podcasts);
    }
    print("file eixsts");
    final file = await getFile();
    final content = await file.readAsString();
    print("content= $content");
    final podcastJson = json.decode(content);
    print(podcastJson);
    for (var i in podcastJson) {
      podcasts.add(Podcast.fromJSON(i));
    }
    return podcasts;
  }

  Future<void> save(Podcast podcast) async {
    for (var p in podcasts) {
      if (p.url == podcast.url) {
        throw new FormatException("Podcast already exists");
      }
    }
    podcasts.add(podcast);
    // print(podcasts.length);
    final file = await getFile();
    final content = json.encode(podcasts);
    await file.writeAsString(content);
  }
}
