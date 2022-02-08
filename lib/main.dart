import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:github_api_consumer/features/github/presentation/bloc/issues/issues_cubit.dart';
import 'package:github_api_consumer/features/github/presentation/pages/display_issues_screen.dart';
import 'features/github/domain/usecases/get_issues.dart';
import 'injector.dart' as di;

void main() {
  BlocOverrides.runZoned(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await di.init();
    runApp(GithubApp());
  }, blocObserver: IssuesBlocObserver());
}

class GithubApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Github API Consumer',
      theme: ThemeData.dark(),
      home: BlocProvider<IssuesCubit>(
        create: (context) => IssuesCubit(
          getIssuesUseCase: di.injector<GetIssues>(),
        ),
        child: DisplayIssuesScreen(),
      ),
    );
  }
}

class IssuesBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object? event) {
    print(event);
    super.onEvent(bloc, event);
  }

  @override
  void onChange(BlocBase bloc, Change change) {
    // print(change);
    super.onChange(bloc, change);
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    print(transition);
    super.onTransition(bloc, transition);
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    print('$error, $stackTrace');
    super.onError(bloc, error, stackTrace);
  }
}
