import 'package:podcastapp/models/Episode.dart';
import 'package:podcastapp/podcast_fetcher.dart';
import 'package:rxdart/rxdart.dart';

class PodcastDetailsBloc {
  Stream<List<Episode>> episodeListing;
  BehaviorSubject<String> url;

  PodcastDetailsBloc() {
    url = new BehaviorSubject<String>();
    episodeListing = url.asyncMap(fetchPodcast);
  }

  Future<List<Episode>> fetchPodcast(String podcastUrl) async {
    final p = await PodcastFetcher.fetchPodcastEpisodes(podcastUrl);
    return p;
  }
}
