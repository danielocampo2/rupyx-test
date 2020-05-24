import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_repos_rupyx/bloc/bloc_provider.dart';
import 'package:github_repos_rupyx/bloc/local_repos_bloc.dart';
import 'package:github_repos_rupyx/dataLayer/models/github_repo.dart';
import 'package:github_repos_rupyx/ui/shared/fullWidthButton.dart';

class CreateRepoScreen extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return _CreateRepoScreenState();
  }

}

class _CreateRepoScreenState extends State<CreateRepoScreen> {

  TextEditingController ownerController;
  TextEditingController nameController;
  TextEditingController descriptionController;

  String repoName = '';
  String repoOwner = '';
  String repoDescription = '';

  @override
  void initState() {
    ownerController = TextEditingController(text: repoOwner);
    nameController = TextEditingController(text: repoName);
    descriptionController = TextEditingController(text: repoDescription);

    super.initState();
  }

  _savePressed(BuildContext context, LocalReposBloc bloc) {
    GithubRepo repo = GithubRepo.newLocalRepo(repoName, repoDescription, repoOwner);

    bloc.createLocalRepo(repo);
    Navigator.of(context).pop('created');
  }

  @override
  Widget build(BuildContext context) {
    var bloc = LocalReposBloc();
    
    return BlocProvider<LocalReposBloc>(
      bloc: bloc,
      child: Scaffold(
        appBar: AppBar(title: Text('Repo details') ),
        body: Column(
          children: <Widget>[
            Expanded(
                child: _details()
            ),
            SafeArea(
                child: Visibility(
                  child: Padding(
                    padding: EdgeInsets.only(left: 28.0, right: 28.0, bottom: 28.0),
                    child: FullWidthButton(
                      onPressed: () => _savePressed(context, bloc),
                      text: 'CREATE',
                    ),
                  ),
                  visible: repoName.isNotEmpty && repoOwner.isNotEmpty,
                ),
            )
          ],
        ),
      ),
    );
  }

  Widget _details() {
    return ListView(
      padding: const EdgeInsets.all(28.0),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Owner'
            ),
            controller: ownerController,
              onChanged: (text) => {
                setState(() {
                  repoOwner = text;
                })
              }
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name'),
            controller: nameController,
            onChanged: (text) => {
              setState(() {
                repoName = text;
              })
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: TextField(
            decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Description'),
            controller: descriptionController,
            onChanged: (text) => {
              setState(() {
                repoDescription = text;
              })
            },
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
        )
      ],
    );
  }

}