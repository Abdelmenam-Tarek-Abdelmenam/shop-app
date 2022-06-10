import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:shop/view/ui/main_page/delegates/orders_search.dart';
import 'package:shop/view/ui/main_page/layouts/entry/entry_layout.dart';
import 'package:shop/view/ui/main_page/layouts/home/home_layout.dart';
import 'package:shop/view/ui/main_page/layouts/orders/order_layout.dart';
import 'package:shop/view/ui/main_page/layouts/products/product_layout.dart';
import 'package:shop/view/ui/main_page/layouts/setting/setting_layout.dart';

import '../../../view_model/layout_provider.dart';
import '../../resources/routes_manger.dart';
import 'delegates/entries_search.dart';
import 'delegates/product_search.dart';

const List<String> appBarTitles = [
  "Home",
  "Orders",
  "Entry",
  "Products",
  "Setting"
];

class MainView extends StatelessWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () => popDialog(context),
      child: Selector<LayoutProvider, int>(
        selector: (_, val) => val.activeLayout,
        builder: (context, value, child) => Scaffold(
          appBar: AppBar(
            titleSpacing: 15,
            title: Text(appBarTitles[value]),
            actions: getRightAction(value, context),
          ),
          bottomNavigationBar: bottomNavigationBar(value, context),
          body: [
            HomeLayout(),
            const OrderLayout(),
            const EntryLayout(),
            const ProductLayout(),
            const SettingLayout(),
          ][value],
        ),
      ),
    );
  }

  List<Widget> getRightAction(int activeLayout, BuildContext context) {
    if (activeLayout > 0 && activeLayout < 4) {
      return [
        IconButton(
            onPressed: () {
              switch (activeLayout) {
                case 1:
                  showSearch(context: context, delegate: OrderSearchDelegate());
                  break;
                case 2:
                  showSearch(
                      context: context, delegate: EntriesSearchDelegate());
                  break;
                case 3:
                  showSearch(
                      context: context, delegate: ProductSearchDelegate());
                  break;
              }
            },
            icon: const Icon(Icons.search)),
        IconButton(
            onPressed: () {
              switch (activeLayout) {
                case 1:
                  Navigator.pushNamed(context, Routes.addOrderRoute);
                  break;
                case 2:
                  Navigator.pushNamed(context, Routes.addEntryRoute);
                  break;
                case 3:
                  Navigator.pushNamed(context, Routes.addProductRoute,
                      arguments: null);
                  break;
              }
            },
            icon: const Icon(
              Icons.add,
              size: 35,
            )),
        const SizedBox(
          width: 5,
        ),
      ];
    } else {
      return [];
    }
  }

  Widget bottomNavigationBar(int activeLayout, BuildContext context) => GNav(
      selectedIndex: activeLayout,
      onTabChange: (newIndex) {
        context.read<LayoutProvider>().changeActiveLayout = newIndex;
      },
      backgroundColor: Theme.of(context).colorScheme.onSecondary,
      duration: const Duration(milliseconds: 300),
      gap: 4,
      color: Theme.of(context).colorScheme.onBackground,
      activeColor: Theme.of(context).colorScheme.onSecondary,
      iconSize: 24,
      tabBackgroundColor: Theme.of(context).colorScheme.onSurface,
      padding: const EdgeInsets.all(10),
      tabMargin: const EdgeInsets.symmetric(vertical: 10, horizontal: 7),
      tabs: List.generate(
          appBarTitles.length,
          (index) => GButton(
                icon: [
                  Icons.home_outlined,
                  Icons.local_offer_outlined,
                  Icons.shopping_cart_outlined,
                  Icons.storefront_outlined,
                  Icons.settings,
                ][index],
                text: appBarTitles[index],
              )));

  Future<bool> popDialog(BuildContext context) async {
    return (await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Are you Sure'),
            content: const Text('you want Exit ?'),
            actions: <Widget>[
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text('No'),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text(
                  'Yes',
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
        )) ??
        false;
  }
}
