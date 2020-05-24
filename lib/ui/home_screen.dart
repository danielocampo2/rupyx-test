import 'package:flutter/material.dart';
import 'package:github_repos_rupyx/bloc/bloc_provider.dart';
import 'package:github_repos_rupyx/bloc/local_repos_bloc.dart';
import 'package:github_repos_rupyx/dataLayer/models/github_repo.dart';
import 'package:github_repos_rupyx/dataLayer/models/response.dart';
import 'package:github_repos_rupyx/ui/create_repo_screen.dart';
import 'package:github_repos_rupyx/ui/repo_details_screen.dart';
import 'package:github_repos_rupyx/ui/search_repos_screen.dart';

class HomeScreen extends StatelessWidget {

  final bloc = LocalReposBloc();

  _refreshList() {
    bloc.getLocalRepos();
  }

  _createRepoButtonPressed(BuildContext context) {
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (context) =>
              CreateRepoScreen(),
        ),
      ).then((param) {
        if (param == 'created') {
          _refreshList();
        }
      });
  }

  _repoItemTapped(BuildContext context, GithubRepo repo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) =>
            RepoDetailsScreen(repo: repo,),
      ),
    ).then((param) {
      if (param == 'edited') {
        _refreshList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    _refreshList();

    return BlocProvider<LocalReposBloc>(
      bloc: bloc,
      child: Scaffold(
        appBar: AppBar(
          title: Text('GitHub Repos'),
          actions: <Widget>[
            IconButton(
              icon: Icon(
                Icons.search,
                color: Colors.white,
              ),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) =>
                        SearchReposScreen(),
                  ),
                );
              },
            )
          ],),
        floatingActionButton: new FloatingActionButton(
            child: new Icon(Icons.add),
            onPressed: () => _createRepoButtonPressed(context)
        ),
        body: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text('Your local repos', style: TextStyle(fontSize: 24.0),),
            ),
            Expanded(
              child: _buildResults(bloc),
            )
          ],
        ),
      ),
    );
  }


  Widget _buildResults(LocalReposBloc bloc) {
    return StreamBuilder<Response<List<GithubRepo>>>(
      stream: bloc.reposStream,
      builder: (context, snapshot) {

        final response = snapshot.data;

        if (response == null || response.results == null) {
          return Center(child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('You have no repos yet. Create one now!'),
          ));
        }

        if (response.status == ResponseStatus.loading) {
          return Center(child: CircularProgressIndicator());
        }

        if (response.status == ResponseStatus.error) {
          return Center(child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('There was an error getting the local repos.'),
          ));
        }

        if (response.results.isEmpty) {
          return Center(child: Padding(
            padding: EdgeInsets.all(20.0),
            child: Text('You have no repos yet. Create one now!'),
          ));
        }

        return _buildList(response.results);
      },
    );
  }

  Widget _buildList(List<GithubRepo> results) {
    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (BuildContext context, int index) => Divider(),
      itemBuilder: (context, index) {
        final repo = results[index];
        return ListTile(
          title: Text('${repo.owner}/${repo.name}'),
            onTap: () => _repoItemTapped(context, repo),
        );
      },
    );
  }
}