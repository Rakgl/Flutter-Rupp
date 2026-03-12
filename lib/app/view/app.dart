import 'dart:async';

import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_methgo_app/config/route/router.dart';
import 'package:flutter_methgo_app/features/settings/cubit/settings_cubit.dart';
import 'package:flutter_methgo_app/features/shared/export_shared.dart';
import 'package:flutter_methgo_app/l10n/l10n.dart';
import 'package:flutter_methgo_app/navigation/cubit/navigation_cubit.dart';
import 'package:flutter_methgo_app/features/profile/cubit/profile_cubit.dart';
import 'package:flutter_methgo_app/features/products/cubit/products_cubit.dart';
import 'package:flutter_methgo_app/features/pets/cubit/pets_cubit.dart';
import 'package:flutter_methgo_app/features/categories/cubit/categories_cubit.dart';
import 'package:flutter_methgo_app/features/services/cubit/services_cubit.dart';
import 'package:flutter_methgo_app/features/card/cubit/card_cubit.dart';
import 'package:flutter_methgo_app/features/appointments/cubit/appointments_cubit.dart';
import 'package:flutter_methgo_app/features/favorite/cubit/favorite_cubit.dart';
import 'package:repository/repository.dart';
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
  ProductRepository? _productRepository;
  FavoriteRepository? _favoriteRepository;
  SettingRepository? _settingRepository;
  AppointmentRepository? _appointmentRepository;
  CartRepository? _cartRepository;
  CategoryRepository? _categoryRepository;
  ServiceRepository? _serviceRepository;
  PetRepository? _petRepository;

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
      _productRepository = ProductRepository(
        apiClient: apiClient,
      );
      _favoriteRepository = FavoriteRepository(
        apiClient: apiClient,
      );
      _settingRepository = SettingRepository(
        apiClient: apiClient,
      );
      _appointmentRepository = AppointmentRepository(
        apiClient: apiClient,
      );
      _cartRepository = CartRepository(
        apiClient: apiClient,
      );
      _categoryRepository = CategoryRepository(
        apiClient: apiClient,
      );
      _serviceRepository = ServiceRepository(
        apiClient: apiClient,
      );
      _petRepository = PetRepository(
        apiClient: apiClient,
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
        RepositoryProvider<ProductRepository>(
          create: (context) => _productRepository!,
        ),
        RepositoryProvider<FavoriteRepository>(
          create: (context) => _favoriteRepository!,
        ),
        RepositoryProvider<SettingRepository>(
          create: (context) => _settingRepository!,
        ),
        RepositoryProvider<AppointmentRepository>(
          create: (context) => _appointmentRepository!,
        ),
        RepositoryProvider<CartRepository>(
          create: (context) => _cartRepository!,
        ),
        RepositoryProvider<CategoryRepository>(
          create: (context) => _categoryRepository!,
        ),
        RepositoryProvider<ServiceRepository>(
          create: (context) => _serviceRepository!,
        ),
        RepositoryProvider<PetRepository>(
          create: (context) => _petRepository!,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<NavigationCubit>(
            create: (context) => NavigationCubit(),
          ),
          BlocProvider<ProfileCubit>(
            create: (context) => ProfileCubit(),
          ),
          BlocProvider<ProductsCubit>(
            create: (context) => ProductsCubit(
              productRepository: context.read<ProductRepository>(),
            ),
          ),
          BlocProvider<PetsCubit>(
            create: (context) => PetsCubit(
              petRepository: context.read<PetRepository>(),
            ),
          ),
          BlocProvider<CategoriesCubit>(
            create: (context) => CategoriesCubit(
              categoryRepository: context.read<CategoryRepository>(),
            ),
          ),
          BlocProvider<ServicesCubit>(
            create: (context) => ServicesCubit(
              serviceRepository: context.read<ServiceRepository>(),
            ),
          ),
          BlocProvider<CardCubit>(
            create: (context) => CardCubit(
              cartRepository: context.read<CartRepository>(),
            ),
          ),
          BlocProvider<AppointmentsCubit>(
            create: (context) => AppointmentsCubit(
              appointmentRepository: context.read<AppointmentRepository>(),
            ),
          ),
          BlocProvider<SettingsCubit>(
            create: (context) => SettingsCubit(
              settingRepository: context.read<SettingRepository>(),
            ),
          ),
          BlocProvider<FavoriteCubit>(
            create: (context) => FavoriteCubit(
              favoriteRepository: context.read<FavoriteRepository>(),
            )..fetchFavorites(),
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
