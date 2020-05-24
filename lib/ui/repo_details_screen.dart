import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:github_repos_rupyx/bloc/bloc_provider.dart';
import 'package:github_repos_rupyx/bloc/local_repos_bloc.dart';
import 'package:github_repos_rupyx/dataLayer/models/github_repo.dart';
import 'package:github_repos_rupyx/ui/shared/fullWidthButton.dart';

class RepoDetailsScreen extends StatefulWidget {

  final GithubRepo repo;

  const RepoDetailsScreen({Key key, @required this.repo}) : super(key: key);

  @override
  State createState() => _RepoDetailsScreenState();

}

class _RepoDetailsScreenState extends State<RepoDetailsScreen> {

  bool isEditing = false;
  bool editAvailable = false;
  GithubRepo repo;

  TextEditingController ownerController;
  TextEditingController nameController;
  TextEditingController descriptionController;

  var bloc = LocalReposBloc();

  @override
  void initState() {
    repo = widget.repo;
    editAvailable = repo.isLocal;
    ownerController = TextEditingController(text: repo.owner);
    nameController = TextEditingController(text: repo.name);
    descriptionController = TextEditingController(text: repo.description);

    super.initState();
  }

  _cancelEditingPressed() {
    setState(() {
      isEditing = false;
    });
  }

  _editPressed() {
    setState(() {
      isEditing = true;
    });
  }

  _savePressed() {
    repo.name = nameController.text;
    repo.owner = ownerController.text;
    repo.description = descriptionController.text;

    bloc.editLocalRepo(repo);

    Navigator.of(context).pop('edited');
  }

  @override
  Widget build(BuildContext context) {
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
                    child: isEditing ? Column(
                      children: <Widget>[
                        FullWidthButton(
                          onPressed: _savePressed,
                          text: 'SAVE',
                        ),
                        FullWidthButton(
                          onPressed: _cancelEditingPressed ,
                          text: 'CANCEL',
                        )
                      ],
                    ) : FullWidthButton(
                      onPressed: _editPressed,
                      text: 'EDIT',
                    ),
                  ),
                  visible: editAvailable,
              )
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
              enabled: editAvailable && isEditing,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Name'),
              controller: nameController,
              enabled: editAvailable && isEditing,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Description'),
              controller: descriptionController,
              enabled: editAvailable && isEditing,
              keyboardType: TextInputType.multiline,
              maxLines: null,
            ),
          )
        ],
    );
  }

}