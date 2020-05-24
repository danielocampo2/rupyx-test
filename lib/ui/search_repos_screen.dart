import 'package:flutter/material.dart';
import 'package:github_repos_rupyx/bloc/bloc_provider.dart';
import 'package:github_repos_rupyx/bloc/remote_repos_bloc.dart';
import 'package:github_repos_rupyx/dataLayer/models/github_repo.dart';
import 'package:github_repos_rupyx/dataLayer/models/response.dart';
import 'package:github_repos_rupyx/ui/repo_details_screen.dart';

class SearchReposScreen extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    final bloc = RemoteReposSearchBloc();

    return BlocProvider<RemoteReposSearchBloc>(
      bloc: bloc,
      child: Scaffold(
        appBar: AppBar(title: Text('Search GitHub Repos')),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: TextField(
                textInputAction: TextInputAction.search,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), hintText: 'Search Github repos ...'),
                onSubmitted: (query) => bloc.submitQuery(query),
              ),
            ),
            Expanded(
              child: _buildResults(bloc),
            )
          ],
        ),
      ),
    );
  }


  Widget _buildResults(RemoteReposSearchBloc bloc) {
    return StreamBuilder<Response<List<GithubRepo>>>(
      stream: bloc.reposStream,
      builder: (context, snapshot) {

        final response = snapshot.data;

        if (response == null) {
          return Center(child: Text('Search for repos'));
        }

        if (response.status == ResponseStatus.loading) {
          return Center(child: CircularProgressIndicator());
        }

        if (response.status == ResponseStatus.error) {
          return Center(child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('There was an error!\n Please check your connection and try again.'),
          ));
        }

        if (response.results.isEmpty) {
          return Center(child: Text('No repos found'));
        }

        return _buildSearchResults(response.results);
      },
    );
  }

  Widget _buildSearchResults(List<GithubRepo> results) {
    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (context, index) {
        final repo = results[index];
        return ListTile(
          title: Text('${repo.owner}/${repo.name}'),
          onTap: () {
            Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) =>
                    RepoDetailsScreen(repo: repo,),
              ),
            );
          },
        );
      },
    );
  }
}