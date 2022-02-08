import 'dart:convert';
import 'dart:io';

import 'package:github_api_consumer/core/util/enums.dart';
import 'package:github_api_consumer/features/github/data/models/issue_model.dart';
import 'package:http/http.dart' as http;

import '../../../../core/error/exceptions.dart';

abstract class IssuesRemoteDataSource {
  /// Calls the https://api.github.com/ endpoint.
  ///
  /// Throws a [ServerException] for all error codes.
  Future<List<IssueModel>> getIssues(
      int page, FilterState filterState, SortOption sortOption);
}

class IssuesRemoteDataSourceImpl implements IssuesRemoteDataSource {
  final http.Client client;

  IssuesRemoteDataSourceImpl({required this.client});

  @override
  Future<List<IssueModel>> getIssues(
          int page, FilterState filterState, SortOption sortOption) =>
      _getIssuesFromUrl(
          'https://api.github.com/repos/flutter/flutter/issues?page=$page&per_page=30&state=${filterState.toShortString()}&sort=${sortOption.toShortString()}');

  Future<List<IssueModel>> _getIssuesFromUrl(String url) async {
    print('URL = $url');
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
