import 'dart:async';
import 'dart:convert';
import 'package:github_repos_rupyx/dataLayer/models/github_repo.dart';
import 'package:github_repos_rupyx/dataLayer/models/response.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'bloc.dart';

class LocalReposBloc implements Bloc {

  static const String Key = 'LOCAL_REPOS';

  final _controller = StreamController<Response<List<GithubRepo>>>();
  Stream<Response<List<GithubRepo>>> get reposStream => _controller.stream;

  void getLocalRepos() async {
    _controller.sink.add(Response(ResponseStatus.loading));

    SharedPreferences.getInstance().then((prefs) {
      try {
        if (!prefs.containsKey(Key)) {
          _controller.sink.add(Response(ResponseStatus.success));
          return;
        }

        var currentRepos = prefs.getStringList(Key);

        var result = currentRepos
            .map<GithubRepo>((json) => GithubRepo.fromLocalJson(jsonDecode(json)))
            .toList(growable: false);

        _controller.sink.add(Response(ResponseStatus.success, results: result));
      } catch(Exception) {
        _controller.sink.add(Response(ResponseStatus.error));
      }

    });
  }

  void createLocalRepo(GithubRepo repo) async {
    SharedPreferences.getInstance().then((prefs) {
      var currentRepos = prefs.getStringList(Key);
      if (currentRepos == null) {
        currentRepos = new List();
      }

      currentRepos.add(jsonEncode(repo));

      prefs.setStringList(Key, currentRepos);
    });
  }

  void editLocalRepo(GithubRepo repo) async {
    SharedPreferences.getInstance().then((prefs) {
      var currentRepos = prefs.getStringList(Key);

      currentRepos.removeWhere((element) => jsonDecode(element)['id'] == repo.id);
      currentRepos.add(jsonEncode(repo));

      prefs.setStringList(Key, currentRepos);
    });
  }

  @override
  void dispose() {
    _controller.close();
  }

}