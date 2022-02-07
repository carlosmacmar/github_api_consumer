import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:github_api_consumer/core/util/enums.dart';
import 'package:github_api_consumer/core/util/enums.dart';
import 'package:github_api_consumer/features/github/domain/entities/issue.dart';
import 'package:github_api_consumer/features/github/domain/repositories/github_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetIssues implements UseCase<List<Issue>, Params> {
  final GithubRepository repository;

  GetIssues(this.repository);

  @override
  Future<Either<Failure, List<Issue>>> call(Params params) async {
    return await repository.getIssues(
        params.page, params.filterState, params.sortOption);
  }
}

class Params extends Equatable {
  final int page;
  final FilterState filterState;
  final SortOption sortOption;

  Params(
    this.page,
    this.filterState,
    this.sortOption,
  );

  @override
  List<Object> get props => [page, filterState, sortOption];
}
