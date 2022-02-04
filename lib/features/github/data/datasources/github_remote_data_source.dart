import 'dart:convert';
import 'dart:io';

import 'package:github_api_consumer/features/github/data/models/issue_model.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';

final String ISSUES_URL = 'https://api.github.com/repos/flutter/flutter/issues';

abstract class GithubRemoteDataSource {
  /// Calls the https://api.github.com/ endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<IssueModel>> getAllIssues();
}

class GithubRemoteDataSourceImpl implements GithubRemoteDataSource {
  final http.Client client;

  GithubRemoteDataSourceImpl({required this.client});

  @override
  Future<List<IssueModel>> getAllIssues() =>
      _getAllIssuesFromUrl(ISSUES_URL);

  Future<List<IssueModel>> _getAllIssuesFromUrl(String url) async {
    final response = await client.get(
      Uri.parse(url),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      },
    );

    if (response.statusCode == 200) {
      Iterable list = json.decode(response.body);
      final issues = list.map((model) => IssueModel.fromJson(model)).toList();
      return issues;
    } else {
      throw ServerException();
    }
  }
}
