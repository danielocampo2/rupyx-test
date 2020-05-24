import 'dart:async';

import 'package:github_repos_rupyx/bloc/bloc.dart';
import 'package:github_repos_rupyx/dataLayer/github_client.dart';
import 'package:github_repos_rupyx/dataLayer/models/github_repo.dart';
import 'package:github_repos_rupyx/dataLayer/models/response.dart';

class RemoteReposSearchBloc implements Bloc {

  final _controller = StreamController<Response<List<GithubRepo>>>();
  Client client = GitHubClient();

  Stream<Response<List<GithubRepo>>> get reposStream => _controller.stream;

  void submitQuery(String query) async {
    if (query == null || query.isEmpty) {
      _controller.sink.add(null);
      return;
    }

    _controller.sink.add(new Response(ResponseStatus.loading));

    final response = await client.searchRepos(query);

    _controller.sink.add(response);
  }

  @override
  void dispose() {
    _controller.close();
  }

}