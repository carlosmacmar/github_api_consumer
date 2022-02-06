part of 'issues_cubit.dart';

abstract class IssuesState extends Equatable {
  const IssuesState();
}

class IssuesInitial extends IssuesState {
  @override
  List<Object> get props => [];
}

class IssuesLoading extends IssuesState {
  IssuesLoading(this.oldIssuesList, {this.isFirstFetch=false});

  final List<Issue> oldIssuesList;
  final bool isFirstFetch;

  @override
  List<Object> get props => [oldIssuesList, {isFirstFetch}];
}

class IssuesLoaded extends IssuesState {
  const IssuesLoaded(this.issuesList);

  final List<Issue> issuesList;

  @override
  List<Object> get props => [issuesList];
}

class IssuesError extends IssuesState {
  IssuesError(this.message);

  final String message;

  @override
  List<Object> get props => [message];
}