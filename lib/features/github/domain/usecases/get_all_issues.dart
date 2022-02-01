import 'package:dartz/dartz.dart';
import 'package:github_api_consumer/features/github/domain/entities/issue.dart';
import 'package:github_api_consumer/features/github/domain/repositories/github_repository.dart';

import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';

class GetAllIssues implements UseCase<List<Issue>, NoParams> {
  final GithubRepository repository;

  GetAllIssues(this.repository);

  @override
  Future<Either<Failure, List<Issue>>> call(NoParams params) async {
    return await repository.getAllIssues();
  }
}
