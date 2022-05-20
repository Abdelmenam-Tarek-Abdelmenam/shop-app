import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:shop/view/resources/routes_manger.dart';
import 'package:shop/view/resources/theme_manager.dart';

import 'bloc/my_bloc_observer.dart';
import 'model/local/pref_repository.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await PreferenceRepository.initializePreference();
  return BlocOverrides.runZoned(
    () async {
      WidgetsFlutterBinding.ensureInitialized();

      await PreferenceRepository.initializePreference();
      runApp(const MyApp());
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Shop Cashier',
      debugShowCheckedModeBanner: false,
      theme: lightThemeData,
      themeMode: ThemeMode.light,
      onGenerateRoute: RouteGenerator.getRoute,
      initialRoute: Routes.mainRoute,
    );
  }
}
