import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/view/ui/main_page/layouts/orders/widgets/order_design.dart';

import '../../../../../model/module/deals.dart';
import '../../../../../model/module/ui_models.dart';
import '../../../../../view_model/app_provider.dart';

class OrderLayout extends StatelessWidget {
  const OrderLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Selector<AppProvider, ShowData<OrderModel>>(
        selector: (context, appProvider) => appProvider.ordersShow,
        shouldRebuild: (_, __) {
          try {
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            // ignore: empty_catches
          } catch (e) {}
          return true;
        },
        builder: (context, entries, _) =>
            NotificationListener<ScrollEndNotification>(
          onNotification: (scrollEnd) {
            final metrics = scrollEnd.metrics;
            if (metrics.atEdge) {
              bool isTop = metrics.pixels == 0;
              if (!isTop) {
                context.read<AppProvider>().readMoreOrders();
              }
            }
            return true;
          },
          child: ListView(
            physics: const BouncingScrollPhysics(),
            children: [
              Row(
                children: [
                  Text("Total Orders ${entries.maxNumber}",
                      style: Theme.of(context).textTheme.headline4),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Divider(
                      color: Theme.of(context).colorScheme.onBackground,
                      // thickness: 10,
                      height: 10,
                    ),
                  ),
                ],
              ),
              const Divider(
                height: 10,
                thickness: 0,
              ),
              ListView.separated(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) => index == entries.maxNumber
                    ? entries.lastItem
                    : OrderDesign(entries.data[index]),
                separatorBuilder: (_, __) => const SizedBox(
                  height: 5,
                ),
                itemCount: entries.data.length + 1,
              )
            ],
          ),
        ),
      ),
    );
  }
}
