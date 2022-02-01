import 'package:dartz/dartz.dart';
import 'package:github_api_consumer/features/github/data/datasources/github_remote_data_source.dart';
import 'package:github_api_consumer/features/github/domain/entities/issue.dart';
import 'package:github_api_consumer/features/github/domain/repositories/github_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/error/exceptions.dart';
import '../../../../core/network/network_info.dart';

class GithubRepositoryImpl implements GithubRepository {
  final GithubRemoteDataSource remoteDataSource;
  // final GithubLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  GithubRepositoryImpl({
    required this.remoteDataSource,
    // @required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Issue>>> getAllIssues() async {
    return await _getAllIssues();
  }

  Future<Either<Failure, List<Issue>>> _getAllIssues() async {
    if (await networkInfo.isInternetAvailable) {
      try {
        final remoteIssues = await remoteDataSource.getAllIssues();
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
