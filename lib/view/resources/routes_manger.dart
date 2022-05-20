import 'package:flutter/material.dart';

import '../ui/main_page/main_screen.dart';

class Routes {
  static const String mainRoute = "/";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    print(settings.name);
    switch (settings.name) {
      case Routes.mainRoute:
        // ignore: prefer_const_constructors
        return MaterialPageRoute(builder: (_) => MainView());
      default:
        return unDefinedRoute();
    }
  }

  static Route<dynamic> unDefinedRoute() {
    return MaterialPageRoute(
        builder: (_) => Scaffold(
              appBar: AppBar(
                title: const Text("No Route Found"),
              ),
              body: const Center(child: Text("No Route Found")),
            ));
  }
}
