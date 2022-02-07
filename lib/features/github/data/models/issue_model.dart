import 'package:github_api_consumer/features/github/domain/entities/issue.dart';
import 'package:github_api_consumer/features/github/domain/entities/user.dart';

import 'user_model.dart';

class IssueModel extends Issue {
  IssueModel({
    required int id,
    required String title,
    required UserModel? user,
    required String state,
    required int comments,
    required String createdAt,
    required String updatedAt,
    required String closedAt,
    required String body,
  }) : super(
          id: id,
          title: title,
          user: User(
              login: user?.login ?? '',
              id: user?.id ?? 0,
              nodeId: user?.nodeId ?? '',
              avatarUrl: user?.avatarUrl ?? ''),
          state: state,
          comments: comments,
          createdAt: createdAt,
          updatedAt: updatedAt,
          closedAt: closedAt,
          body: body,
          visited: false,
        );

  factory IssueModel.fromJson(Map<String, dynamic> json) {
    return IssueModel(
      id: json['id'],
      title: json['title'],
      user: json['user'] != null ? new UserModel.fromJson(json['user']) : null,
      state: json['state'],
      comments: json['comments'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      closedAt: json['closed_at'] ?? '',
      body: json['body'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'user': user,
      'state': state,
      'comments': comments,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'closed_at': closedAt,
      'body': body,
    };
  }
}
