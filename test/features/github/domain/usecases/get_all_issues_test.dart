import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:github_api_consumer/core/usecases/usecase.dart';
import 'package:github_api_consumer/features/github/data/models/issue_model.dart';
import 'package:github_api_consumer/features/github/domain/repositories/github_repository.dart';
import 'package:github_api_consumer/features/github/domain/usecases/get_all_issues.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'get_all_issues_test.mocks.dart';

@GenerateMocks([GithubRepository])
void main() {
  MockGithubRepository mockGithubRepository = MockGithubRepository();
  GetAllIssues getAllIssuesUsecase = GetAllIssues(mockGithubRepository);

  Iterable issues = json.decode(fixture('issues.json'));
  final issuesList =
  issues.map((model) => IssueModel.fromJson(model)).toList();

  test(
    'should get list of issues from the repository',
        () async {
      // arrange
      when(mockGithubRepository.getAllIssues())
          .thenAnswer((_) async => Right(issuesList));
      // act
      final result = await getAllIssuesUsecase(NoParams());
      // assert
      expect(result, Right(issuesList));
      verify(mockGithubRepository.getAllIssues());
      verifyNoMoreInteractions(mockGithubRepository);
    },
  );
}