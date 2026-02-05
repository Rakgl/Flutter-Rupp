import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_super_aslan_app/config/route/router.dart';
import 'package:flutter_super_aslan_app/features/shared/export_shared.dart';
import 'package:flutter_super_aslan_app/l10n/l10n.dart';
import 'package:flutter_super_aslan_app/navigation/cubit/navigation_cubit.dart';
import 'package:repository/user_repository.dart';
import 'package:api_http_client/api_http_client.dart';
import 'package:http_client/http_client.dart';
import 'package:persistent_storage/persistent_storage.dart';
import 'package:token_storage/token_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class App extends StatefulWidget {
  const App({super.key, required this.environment});

  final EnvironmentModel environment;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  UserRepository? _userRepository;
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    unawaited(_initializeRepositories());
  }

  Future<void> _initializeRepositories() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final storage = PersistentStorage(sharedPreferences: sharedPreferences);
    final tokenStorage = TokenStorage(storage: storage);
    final httpClient = DioHttpClient(
      dio: Dio(),
      baseUrl: widget.environment.baseUrl,
      tokenStorage: tokenStorage,
    );
    final apiClient = ApiHttpClient(httpClient: httpClient);
    setState(() {
      _userRepository = UserRepository(
        apiClient: apiClient,
        tokenStorage: tokenStorage,
      );
      _isInitialized = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_isInitialized || _userRepository == null) {
      return MaterialApp(
        theme: const AppTheme().themeData,
        home: const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    return MultiRepositoryProvider(
      providers: [
        RepositoryProvider<UserRepository>(
          create: (context) => _userRepository!,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<NavigationCubit>(
            create: (context) => NavigationCubit(),
          ),
        ],
        child: MaterialApp.router(
          theme: const AppTheme().themeData,
          routerConfig: GlobalRouter.instance,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
        ),
      ),
    );
  }
}
