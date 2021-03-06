import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:github_api_consumer/core/util/enums.dart';
import 'package:github_api_consumer/features/github/data/models/issue_model.dart';
import 'package:github_api_consumer/features/github/domain/repositories/issues_repository.dart';
import 'package:github_api_consumer/features/github/domain/usecases/get_issues.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'get_issues_test.mocks.dart';

@GenerateMocks([IssuesRepository])
void main() {
  MockIssuesRepository mockIssuesRepository = MockIssuesRepository();
  GetIssues getIssuesUsecase = GetIssues(mockIssuesRepository);

  Iterable issues = json.decode(fixture('issues.json'));
  final issuesList =
  issues.map((model) => IssueModel.fromJson(model)).toList();

  test(
    'should get list of issues from the repository',
        () async {
      // arrange
      when(mockIssuesRepository.getIssues(1, FilterState.open, SortOption.created))
          .thenAnswer((_) async => Right(issuesList));
      // act
      final result = await getIssuesUsecase(Params(1, FilterState.open, SortOption.created));
      // assert
      expect(result, Right(issuesList));
      verify(mockIssuesRepository.getIssues(1, FilterState.open, SortOption.created));
      verifyNoMoreInteractions(mockIssuesRepository);
    },
  );
}