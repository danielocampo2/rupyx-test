import 'dart:math';

class GithubRepo {
  final int id;
  String name;
  String description;
  String owner;
  final int stars;
  final bool isLocal;

  GithubRepo.newLocalRepo(name, description, owner) :
        id = new Random().nextInt(999999),
        name = name,
        description = description,
        owner = owner,
        stars = 0,
        isLocal = true
  ;

  GithubRepo.fromRemoteJson(Map json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        owner = json['owner']['login'],
        stars = json['stargazers_count'],
        isLocal = false
  ;

  GithubRepo.fromLocalJson(Map json)
      : id = json['id'],
        name = json['name'],
        description = json['description'],
        owner = json['owner'],
        stars = json['stars'],
        isLocal = true
  ;

  Map toJson() => {
    'id': id,
    'name': name,
    'owner': owner,
    'description': description,
    'stars': stars,
    'isLocal': isLocal
  };

}