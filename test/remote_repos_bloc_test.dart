import 'package:flutter_test/flutter_test.dart';
import 'package:github_repos_rupyx/bloc/remote_repos_bloc.dart';
import 'package:github_repos_rupyx/dataLayer/github_client.dart';
import 'package:github_repos_rupyx/dataLayer/models/github_repo.dart';
import 'package:github_repos_rupyx/dataLayer/models/response.dart';

class FakeClientWithResults implements Client {

  @override
  Future<Response<List<GithubRepo>>> searchRepos(String query) async {
      final mapJson = { 'id':123, 'name': 'repo', 'description': 'desc', 'owner' : { 'login': 'fakeuser' } };
      var results = [
        GithubRepo.fromRemoteJson(mapJson)
      ];
      return Response(ResponseStatus.success, results: results);
  }

}

class FakeClientWithError implements Client {

  var response;

  @override
  Future<Response<List<GithubRepo>>> searchRepos(String query) async {
    return response;
  }

}

void main() {
  group('remote repos test', (){
    test('test successful response', () {
      var bloc = RemoteReposSearchBloc();
      bloc.client = new FakeClientWithResults();

      bloc.submitQuery('query');

      final mapJson = { 'id':123, 'name': 'repo', 'description': 'desc', 'owner' : { 'login': 'fakeuser' } };
      var results = [
        GithubRepo.fromRemoteJson(mapJson)
      ];

      bloc.reposStream.toList().then((value) {
        var firstEvent = value[0];
        expect(firstEvent.status, ResponseStatus.loading);

        var secondEvent = value[1];
        expect(secondEvent.status, ResponseStatus.success);
        expect(secondEvent.results, results);
      });

    });

    test('test error response', () {
      var bloc = RemoteReposSearchBloc();
      var fakeClient = FakeClientWithError();
      bloc.client = fakeClient;

      bloc.submitQuery('query');

      bloc.reposStream.toList().then((value) {
        var firstEvent = value[0];
        expect(firstEvent.status, ResponseStatus.loading);

        var secondEvent = value[1];
        expect(secondEvent.status, ResponseStatus.error);
      });

    });
  });
}