import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shop/view/ui/main_page/layouts/entry/entry_layout.dart';
import 'package:shop/view/ui/main_page/layouts/home/home_layout.dart';
import 'package:shop/view/ui/main_page/layouts/orders/order_layout.dart';
import 'package:shop/view/ui/main_page/layouts/products/product_layout.dart';
import 'package:shop/view/ui/main_page/layouts/setting/setting_layout.dart';

const List<String> appBarTitles = [
  "Home",
  "Orders",
  "Entry",
  "Products",
  "Setting"
];

class MainView extends StatefulWidget {
  const MainView({Key? key}) : super(key: key);

  @override
  State<MainView> createState() => _MainViewState();
}

class _MainViewState extends State<MainView> {
  int activeLayout = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        titleSpacing: 15,
        title: Text(appBarTitles[activeLayout]),
        actions: getRightAction(),
      ),
      bottomNavigationBar: bottomNavigationBar(context),
      body: [
        HomeLayout(),
        OrderLayout(),
        EntryLayout(),
        const ProductLayout(),
        const SettingLayout(),
      ][activeLayout],
    );
  }

  List<Widget> getRightAction() {
    if (activeLayout > 0 && activeLayout < 4) {
      return [
        IconButton(
            onPressed: () {}, icon: const Icon(Icons.filter_alt_outlined)),
        IconButton(
            onPressed: () {},
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

  Widget bottomNavigationBar(BuildContext context) => GNav(
      selectedIndex: activeLayout,
      onTabChange: (newIndex) {
        setState(() {
          activeLayout = newIndex;
        });
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
}
