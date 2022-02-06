import 'package:github_api_consumer/features/github/domain/entities/issue.dart';
import 'package:github_api_consumer/features/github/domain/entities/user.dart';

import 'user_model.dart';

class IssueModel extends Issue {
  IssueModel({
    required String url,
    required String htmlUrl,
    required int id,
    required int number,
    required String title,
    required UserModel? user,
    required String state,
    required int comments,
    required String createdAt,
    required String updatedAt,
    required String closedAt,
    required String body,
  }) : super(
          url: url,
          htmlUrl: htmlUrl,
          id: id,
          number: number,
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
      url: json['url'],
      htmlUrl: json['html_url'],
      id: json['id'],
      number: json['number'],
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
      'url': url,
      'html_url': htmlUrl,
      'id': id,
      'number': number,
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
