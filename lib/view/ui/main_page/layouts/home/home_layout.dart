import 'dart:math';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/view/ui/main_page/layouts/home/widgets/money_card.dart';
import 'package:shop/view/ui/main_page/widgets/line_graph.dart';
import 'package:shop/view_model/app_provider.dart';

class HomeLayout extends StatelessWidget {
  HomeLayout({Key? key}) : super(key: key);

  final rng = Random();
  late final List<int> dummyData = List.generate(10, (i) => rng.nextInt(100));

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(15, 10, 15, 2),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Text("Sales today", style: Theme.of(context).textTheme.headline4),
          const MoneyCard(),
          const SizedBox(
            height: 10,
          ),
          Text("Sales Last month",
              style: Theme.of(context).textTheme.headline4),
          LineGraph(context.select<AppProvider, List<int>>(
              (val) => val.graphData.moneyGraph)),
          const SizedBox(
            height: 5,
          ),
          Text("Orders Last month",
              style: Theme.of(context).textTheme.headline4),
          LineGraph(context.select<AppProvider, List<int>>(
              (val) => val.graphData.ordersGraph)),
        ],
      ),
    );
  }
}
