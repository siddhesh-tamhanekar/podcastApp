import 'package:podcastapp/models/Podcast.dart';
import 'package:podcastapp/perstitence_storage.dart';
import 'package:rxdart/rxdart.dart';

class PodcastBloc {
  Stream<List<Podcast>> podcasts;
  BehaviorSubject<int> refresh;
  PersistentStorage p;
  PodcastBloc() {
    refresh = new BehaviorSubject<int>();

    podcasts = refresh.asyncMap(fetchPodcasts);
    refresh.add(1);
  }

  Future<List<Podcast>> fetchPodcasts(int _) async {
    p = new PersistentStorage();
    print("fetching podcasts");
    return await p.load();
  }
}
