import 'package:equatable/equatable.dart';
import 'package:github_api_consumer/features/github/domain/entities/user.dart';
import 'package:meta/meta.dart';

class Issue extends Equatable {
  final String url;
  final String htmlUrl;
  final int id;
  final int number;
  final String title;
  final User user;
  final String state;
  final int comments;
  final String createdAt;
  final String updatedAt;
  final String closedAt;
  final String body;

  Issue({
      required this.url,
      required this.htmlUrl,
      required this.id,
      required this.number,
      required this.title,
      required this.user,
      required this.state,
      required this.comments,
      required this.createdAt,
      required this.updatedAt,
      required this.closedAt,
      required this.body});

  @override
  List<Object> get props => [
        url,
        htmlUrl,
        id,
        number,
        title,
        user,
        state,
        comments,
        createdAt,
        updatedAt,
        closedAt,
        body
      ];
}
