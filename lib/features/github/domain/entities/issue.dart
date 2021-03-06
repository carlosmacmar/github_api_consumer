import 'package:equatable/equatable.dart';
import 'package:github_api_consumer/features/github/domain/entities/user.dart';
import 'package:meta/meta.dart';

class Issue extends Equatable {
  final int id;
  final String title;
  final User user;
  final String state;
  final int comments;
  final String createdAt;
  final String updatedAt;
  final String closedAt;
  final String body;
  final bool visited;

  Issue({
    required this.id,
    required this.title,
    required this.user,
    required this.state,
    required this.comments,
    required this.createdAt,
    required this.updatedAt,
    required this.closedAt,
    required this.body,
    required this.visited,
  });

  @override
  List<Object> get props => [
        id,
        title,
        user,
        state,
        comments,
        createdAt,
        updatedAt,
        closedAt,
        body,
        visited,
      ];
}
