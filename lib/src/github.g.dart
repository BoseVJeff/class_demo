// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'github.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

GhUser _$GhUserFromJson(Map<String, dynamic> json) => GhUser(
  name: json['name'] as String,
  email: json['email'] as String,
  date: json['date'] as String,
);

GhAuthor _$GhAuthorFromJson(Map<String, dynamic> json) =>
    GhAuthor(login: json['login'] as String);

GhCommit _$GhCommitFromJson(Map<String, dynamic> json) => GhCommit(
  author: GhUser.fromJson(json['author'] as Map<String, dynamic>),
  committer: GhUser.fromJson(json['committer'] as Map<String, dynamic>),
  message: json['message'] as String,
  url: json['url'] as String,
);

GhCommitItem _$GhCommitItemFromJson(Map<String, dynamic> json) => GhCommitItem(
  sha: json['sha'] as String,
  commit: GhCommit.fromJson(json['commit'] as Map<String, dynamic>),
  url: json['url'] as String,
  author: GhAuthor.fromJson(json['author'] as Map<String, dynamic>),
  committer: GhAuthor.fromJson(json['committer'] as Map<String, dynamic>),
);
