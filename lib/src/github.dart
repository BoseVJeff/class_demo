import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'github.g.dart';

@JsonSerializable(createToJson: false)
class GhUser extends Equatable {
  final String name;
  final String email;
  final String date;

  const GhUser({required this.name, required this.email, required this.date});

  @override
  List<Object?> get props => [name, email, date];

  factory GhUser.fromJson(Map<String, dynamic> json) => _$GhUserFromJson(json);
}

@JsonSerializable(createToJson: false)
class GhAuthor extends Equatable {
  final String login;
  // final String avatarUrl;

  const GhAuthor({
    required this.login,
    //  required this.avatarUrl,
  });

  @override
  List<Object?> get props => [
    login,
    // avatarUrl,
  ];

  factory GhAuthor.fromJson(Map<String, dynamic> json) =>
      _$GhAuthorFromJson(json);
}

@JsonSerializable(createToJson: false)
class GhCommit extends Equatable {
  final GhUser author;
  final GhUser committer;
  final String message;
  final String url;

  const GhCommit({
    required this.author,
    required this.committer,
    required this.message,
    required this.url,
  });

  @override
  List<Object?> get props => [author, committer, message, url];

  factory GhCommit.fromJson(Map<String, dynamic> json) =>
      _$GhCommitFromJson(json);
}

@JsonSerializable(createToJson: false)
class GhCommitItem extends Equatable {
  final String sha;
  final GhCommit commit;
  final String url;
  final GhAuthor author;
  final GhAuthor committer;
  // final String? message;

  const GhCommitItem({
    required this.sha,
    required this.commit,
    required this.url,
    required this.author,
    required this.committer,
    // required this.message,
  });

  @override
  List<Object?> get props => [
    sha, commit, url, author, committer,
    // message,
  ];

  factory GhCommitItem.fromJson(Map<String, dynamic> json) =>
      _$GhCommitItemFromJson(json);
}
