import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:github_api_consumer/core/error/exceptions.dart';
import 'package:github_api_consumer/core/error/failures.dart';
import 'package:github_api_consumer/core/network/network_info.dart';
import 'package:github_api_consumer/core/util/enums.dart';
import 'package:github_api_consumer/features/github/data/datasources/issues_remote_data_source.dart';
import 'package:github_api_consumer/features/github/data/models/issue_model.dart';
import 'package:github_api_consumer/features/github/data/repositories/issues_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../../fixtures/fixture_reader.dart';
import 'issues_repository_impl_test.mocks.dart';

@GenerateMocks([NetworkInfo, IssuesRemoteDataSource])
void main() {
  MockNetworkInfo mockNetworkInfo = MockNetworkInfo();
  MockIssuesRemoteDataSource mockRemoteDataSource =
      MockIssuesRemoteDataSource();
  IssuesRepositoryImpl repository = IssuesRepositoryImpl(
      remoteDataSource: mockRemoteDataSource, networkInfo: mockNetworkInfo);

  void runTestsOnline(Function body) {
    group('device is online', () {
      setUp(() {
        when(mockNetworkInfo.isInternetAvailable).thenAnswer((_) async => true);
      });

      body();
    });
  }

  void runTestsOffline(Function body) {
    group('device is offline', () {
      setUp(() {
        when(mockNetworkInfo.isInternetAvailable).thenAnswer((_) async => false);
      });

      body();
    });
  }

  group('getIssues', () {
    Iterable issues = json.decode(fixture('issues.json'));
    final issuesList =
    issues.map((model) => IssueModel.fromJson(model)).toList();

    test(
      'should check if the device is online',
      () async {
        // arrange
        when(mockNetworkInfo.isInternetAvailable).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getIssues(1, FilterState.open, SortOption.created))
            .thenAnswer((_) async => issuesList);
        // act
        repository.getIssues(1, FilterState.open, SortOption.created);
        // assert
        verify(mockNetworkInfo.isInternetAvailable);
      },
    );

    runTestsOnline(() {
      test(
        'should return remote data when the call to remote data source is successful',
        () async {
          // arrange
          when(mockRemoteDataSource.getIssues(1, FilterState.open, SortOption.created))
              .thenAnswer((_) async => issuesList);
          // act
          final result = await repository.getIssues(1, FilterState.open, SortOption.created);
          // assert
          verify(mockRemoteDataSource.getIssues(1, FilterState.open, SortOption.created));
          expect(result, equals(Right(issuesList)));
        },
      );

      test(
        'should return server failure when the call to remote data source is unsuccessful',
        () async {
          // arrange
          when(mockRemoteDataSource.getIssues(1, FilterState.open, SortOption.created))
              .thenThrow(ServerException());
          // act
          final result = await repository.getIssues(1, FilterState.open, SortOption.created);
          // assert
          verify(mockRemoteDataSource.getIssues(1, FilterState.open, SortOption.created));
          expect(result, equals(Left(ServerFailure())));
        },
      );
    });
  });
}
