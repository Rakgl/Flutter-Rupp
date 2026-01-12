import 'package:app_ui/app_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_super_aslan_app/config/route/router.dart';
import 'package:flutter_super_aslan_app/l10n/l10n.dart';
import 'package:flutter_super_aslan_app/navigation/cubit/navigation_cubit.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigationCubit>(
          create: (context) => NavigationCubit(),
        ),
      ],
      child: MaterialApp.router(
        theme: ThemeData(
          appBarTheme:const  AppBarTheme(),
        ),
        routerConfig: GlobalRouter.instance,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
      ),
    );
  }
}
