import 'package:dartz/dartz.dart';
import 'package:github_api_consumer/features/github/domain/entities/issue.dart';

import '../../../../core/error/failures.dart';

abstract class GithubRepository {
  Future<Either<Failure, List<Issue>>> getAllIssues();
}
