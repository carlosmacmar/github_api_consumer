import 'dart:convert';
import 'dart:io';

import 'package:github_api_consumer/core/error/exceptions.dart';
import 'package:github_api_consumer/core/util/enums.dart';
import 'package:github_api_consumer/features/github/data/datasources/github_remote_data_source.dart';
import 'package:github_api_consumer/features/github/data/models/issue_model.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

import '../../../../fixtures/fixture_reader.dart';
import 'github_remote_data_source_test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  final mockHttpClient = MockClient();
  final dataSource = GithubRemoteDataSourceImpl(client: mockHttpClient);

  void setUpMockHttpClientSuccess200() {
    when(mockHttpClient.get(
      Uri.parse('https://api.github.com/repos/flutter/flutter/issues?page=1&per_page=30&state=open&sort=created'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      },
    )).thenAnswer((_) async => http.Response(
          fixture('issues.json'),
          200,
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          },
        ));
  }

  void setUpMockHttpClientFailure404() {
    when(mockHttpClient.get(
      Uri.parse('https://api.github.com/repos/flutter/flutter/issues?page=1&per_page=30&state=open&sort=created'),
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      },
    )).thenAnswer((_) async => http.Response(
      'Something went wrong',
      404,
      headers: {
        HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
      },
    ));
  }

  group('getIssues', () {
    Iterable issues = json.decode(fixture('issues.json'));
    final issuesList =
        issues.map((model) => IssueModel.fromJson(model)).toList();

    test(
      '''should perform a GET request on a URL with issues
       being the endpoint and with application/json; charset=utf-8 header''',
      () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        dataSource.getIssues(1, FilterState.open, SortOption.created);
        // assert
        verify(mockHttpClient.get(
          Uri.parse('https://api.github.com/repos/flutter/flutter/issues?page=1&per_page=30&state=open&sort=created'),
          headers: {
            HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8',
          },
        ));
      },
    );

    test(
      'should return issues list when the response code is 200 (success)',
          () async {
        // arrange
        setUpMockHttpClientSuccess200();
        // act
        final result = await dataSource.getIssues(1, FilterState.open, SortOption.created);
        // assert
        expect(result, equals(issuesList));
      },
    );

    test(
      'should throw a ServerException when the response code is 404 or other',
          () async {
        // arrange
        setUpMockHttpClientFailure404();
        // act
        final call = dataSource.getIssues(1, FilterState.open, SortOption.created);
        // assert
        expect(() => call, throwsA(TypeMatcher<ServerException>()));
      },
    );
  });
}
