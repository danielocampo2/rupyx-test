import 'package:github_repos_rupyx/dataLayer/models/github_repo.dart';
import 'package:github_repos_rupyx/dataLayer/models/response.dart';
import 'dart:async';
import 'dart:convert' show json;

import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

abstract class Client {
  Future<Response<List<GithubRepo>>> searchRepos(String query);
}

class GitHubClient implements Client {
  final _host = 'api.github.com';

  @override
  Future<Response<List<GithubRepo>>> searchRepos(String query) async {
    try {
      final results = await request(
          path: 'search/repositories', parameters: {'q': query});

      final repos = results['items'];

      var result = repos
          .map<GithubRepo>((json) => GithubRepo.fromRemoteJson(json))
          .toList(growable: false);

      return Response(ResponseStatus.success, results: result);
    } catch(Exception) {
      return Response(ResponseStatus.error);
    }
  }

  Future<Map> request(
      {@required String path, Map<String, String> parameters}) async {
    final uri = Uri.https(_host, '$path', parameters);
    final results = await http.get(uri, headers: _headers);

    if (results.statusCode >= 200 && results.statusCode < 300) {
      return json.decode(results.body);
    }

    throw new Exception('Error getting data - status code: ${results.statusCode}');
  }

  Map<String, String> get _headers =>
      {'Accept': 'application/json'};
}

