import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'core/network/network_info.dart';
import 'features/github/data/datasources/github_remote_data_source.dart';

final injector = GetIt.instance;

Future<void> init() async {
  // Data sources
  injector.registerLazySingleton<GithubRemoteDataSource>(
        () => GithubRemoteDataSourceImpl(client: injector()),
  );

  //! Core
  injector.registerLazySingleton<NetworkInfo>(() => NetworkInfoImpl(injector()));

  //! External
  final sharedPreferences = await SharedPreferences.getInstance();
  injector.registerLazySingleton(() => sharedPreferences);
  injector.registerLazySingleton(() => http.Client());
  injector.registerLazySingleton(() => DataConnectionChecker());
}