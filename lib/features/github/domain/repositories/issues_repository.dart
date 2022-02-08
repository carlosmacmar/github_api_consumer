import 'package:dartz/dartz.dart';
import 'package:github_api_consumer/core/util/enums.dart';
import 'package:github_api_consumer/features/github/domain/entities/issue.dart';

import '../../../../core/error/failures.dart';

abstract class IssuesRepository {
  Future<Either<Failure, List<Issue>>> getIssues(int page, FilterState filterState, SortOption sortOption);
}
