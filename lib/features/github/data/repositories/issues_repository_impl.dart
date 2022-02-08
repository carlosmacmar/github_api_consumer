import 'package:dartz/dartz.dart';
import 'package:github_api_consumer/core/util/enums.dart';
import 'package:github_api_consumer/features/github/data/datasources/issues_remote_data_source.dart';
import 'package:github_api_consumer/features/github/domain/entities/issue.dart';
import 'package:github_api_consumer/features/github/domain/repositories/issues_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';

class IssuesRepositoryImpl implements IssuesRepository {
  final IssuesRemoteDataSource remoteDataSource;
  // final IssuesLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  IssuesRepositoryImpl({
    required this.remoteDataSource,
    // @required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Issue>>> getIssues(int page, FilterState filterState, SortOption sortOption) async {
    return await _getIssues(page, filterState, sortOption);
  }

  Future<Either<Failure, List<Issue>>> _getIssues(int page, FilterState filterState, SortOption sortOption) async {
    if (await networkInfo.isInternetAvailable) {
      try {
        final remoteIssues = await remoteDataSource.getIssues(page, filterState, sortOption);
        // localDataSource.cacheIssues(remoteIssues);
        return Right(remoteIssues);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        // final localIssues = await localDataSource.getIssues();
        // return Right(localIssues);
        return Left(CacheFailure());
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }
}
