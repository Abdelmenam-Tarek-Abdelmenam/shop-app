import 'package:flutter/material.dart';

import '../ui/main_page/main_screen.dart';
import '../ui/money_details/money_screen.dart';

class Routes {
  static const String mainRoute = "/";
  static const String moneyRoute = "/Money";
}

class RouteGenerator {
  static Route<dynamic> getRoute(RouteSettings settings) {
    print(settings.name);
    switch (settings.name) {
      case Routes.mainRoute:
        return MaterialPageRoute(builder: (_) => const MainView());
      case Routes.moneyRoute:
        return MaterialPageRoute(builder: (_) => MoneyDetailsView());
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
