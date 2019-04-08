import 'dart:async';

import 'package:rxdart/rxdart.dart';
// import 'package:http/http.dart' show get;
import 'dart:convert';

//enum loadState = {'uninitialized','loading','nomoreposts'};
class DemoBloc {
  BehaviorSubject<int> page;

  PublishSubject<int> loadingState;

  Stream<PhotoState> photoStream;
  PhotoState photolisting;

  DemoBloc() {
    photolisting = new PhotoState();
    page = new BehaviorSubject<int>();
    photoStream = page.distinct().asyncMap(loadPhotos);
    loadingState = new PublishSubject<int>();
    // print("come here");
    page.add(1);
    // photoStream.add();
  }

  Future<PhotoState> loadPhotos(int page) async {
    print("photo loading");
    if (page == 1) {
      loadingState.add(0);
    } else
      loadingState.add(1); //loading
    // final res =
    //     await get("https://jsonplaceholder.typicode.com/photos?_limit=10");
    try {
      final json1 = await Api.fetchPhotos(page);
      print(json1);

      final jsonobject = json.decode(json1);

      photolisting.addPhotos(jsonobject);
      loadingState.add(2); // loaded

    } catch (_) {
      loadingState.add(3); // no more post.

    }
    return photolisting;
  }
}

class PhotoState {
  List photos = [];
  int page = 1;

  void addPhotos(json) {
    photos.addAll(json as List);
    page = page + 1;
  }
}

class Api {
  static int max = 52;
  static fetchPhotos(int page) {
    final int offset = (page - 1) * 10;
    return Future.delayed(Duration(milliseconds: 2000), () {
      if (offset >= max) throw Error;
      List list = [];
      for (int i = offset + 1; i <= offset + 10; i++) {
        list.add({'number': i, 'url': "https://picsum.photos/200/300/?random"});
      }
      // print(list);
      return json.encode(list);
    });
  }
}
