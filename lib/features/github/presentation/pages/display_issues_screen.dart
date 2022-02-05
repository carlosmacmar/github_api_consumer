import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_api_consumer/features/github/domain/entities/issue.dart';
import 'package:github_api_consumer/features/github/presentation/bloc/issues/issues_cubit.dart';

class DisplayIssuesScreen extends StatelessWidget {
  final scrollController = ScrollController();

  void setupScrollController(context) {
    scrollController.addListener(() {
      if (scrollController.position.atEdge) {
        if (scrollController.position.pixels != 0) {
          BlocProvider.of<IssuesCubit>(context).getAllIssues();
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    setupScrollController(context);
    BlocProvider.of<IssuesCubit>(context).getAllIssues();

    return Scaffold(
      appBar: AppBar(
        title: Text("Issues List"),
      ),
      body: _issueList(),
    );
  }

  Widget _issueList() {
    return BlocBuilder<IssuesCubit, IssuesState>(builder: (context, state) {
      if (state is IssuesLoading && state.isFirstFetch) {
        return _loadingIndicator();
      }

      List<Issue> issues = [];
      bool isLoading = false;

      if (state is IssuesLoading) {
        issues = state.oldIssuesList;
        isLoading = true;
      } else if (state is IssuesLoaded) {
        issues = state.issuesList;
      }

      return ListView.separated(
        controller: scrollController,
        itemBuilder: (context, index) {
          if (index < issues.length)
            return _issue(issues[index], context);
          else {
            Timer(Duration(milliseconds: 30), () {
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent);
            });
            return _loadingIndicator();
          }
        },
        separatorBuilder: (context, index) {
          return Divider(
            color: Colors.grey[400],
          );
        },
        itemCount: issues.length + (isLoading ? 1 : 0),
      );
    });
  }

  Widget _loadingIndicator() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Center(child: CircularProgressIndicator()),
    );
  }

  Widget _issue(Issue issue, BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "${issue.title}",
            style: TextStyle(
                fontSize: 18.0,
                color: Colors.white,
                fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
