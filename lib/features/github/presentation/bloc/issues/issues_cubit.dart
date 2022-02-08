import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:github_api_consumer/core/error/failures.dart';
import 'package:github_api_consumer/core/util/enums.dart';
import 'package:github_api_consumer/features/github/domain/entities/issue.dart';
import 'package:github_api_consumer/features/github/domain/usecases/get_issues.dart';

part 'issues_state.dart';

const String SERVER_FAILURE_MESSAGE = 'Server Failure';

class IssuesCubit extends Cubit<IssuesState> {
  IssuesCubit({required this.getIssuesUseCase}) : super(IssuesInitial());

  final GetIssues getIssuesUseCase;
  int _page = 1;
  var _visitedIssuesList = <Issue>[];
  var _currentIssuesList = <Issue>[];
  FilterState _currentFilterState = FilterState.open;
  SortOption _currentSortOption = SortOption.created;

  void getIssues() async {
    try {
      if (state is IssuesLoading) return;

      var oldIssuesList = <Issue>[];
      if (_page == 1) _currentIssuesList.clear();

      final currentState = state;
      if (currentState is IssuesLoaded) {
        oldIssuesList = currentState.issuesList;
      }

      emit(IssuesLoading(oldIssuesList, isFirstFetch: _page == 1));
      final failureOrIssues = await getIssuesUseCase
          .call(Params(_page, _currentFilterState, _currentSortOption));
      failureOrIssues.fold(
        (failure) => emit(IssuesError(_mapFailureToMessage(failure))),
        (newIssues) {
          _page++;
          final issues = (state as IssuesLoading).oldIssuesList;
          issues.addAll(newIssues);
          _visitedIssuesList.forEach((visitedIssue) {
            final index = issues.indexWhere(
                    (element) => element.id == visitedIssue.id);
            if(index != -1) issues[index] = visitedIssue;
          });
          _currentIssuesList = issues;
          emit(IssuesLoaded(issues));
        },
      );
    } catch (e) {
      emit(IssuesError('Unknown Error'));
    }
  }

  void updateFilter(FilterState filterState) {
    _currentFilterState = filterState;
    _page = 1;
    emit(IssuesInitial());
    getIssues();
  }

  void updateSortOption(SortOption sortOption) {
    _currentSortOption = sortOption;
    _page = 1;
    emit(IssuesInitial());
    getIssues();
  }

  void setVisited(Issue issue) {
    final visitedIssue = Issue(
        id: issue.id,
        title: issue.title,
        user: issue.user,
        state: issue.state,
        comments: issue.comments,
        createdAt: issue.createdAt,
        updatedAt: issue.updatedAt,
        closedAt: issue.closedAt,
        body: issue.body,
        visited: true);
    _visitedIssuesList.add(visitedIssue);
    final index = _currentIssuesList.indexWhere(
            (element) => element.id == visitedIssue.id);
    if(index != -1) _currentIssuesList[index] = visitedIssue;
    emit(IssuesInitial());
    emit(IssuesLoaded(_currentIssuesList));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return SERVER_FAILURE_MESSAGE;
      default:
        return 'Unexpected error';
    }
  }
}
