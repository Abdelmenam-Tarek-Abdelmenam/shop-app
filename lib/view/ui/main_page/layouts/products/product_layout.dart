import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/model/module/product.dart';
import 'package:shop/view/ui/main_page/layouts/products/widgets/product_design.dart';

import '../../../../../model/module/ui_models.dart';
import '../../../../../view_model/app_provider.dart';

class ProductLayout extends StatelessWidget {
  const ProductLayout({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Selector<AppProvider, ShowData<Product>>(
        shouldRebuild: (_, __) {
          try {
            if (Navigator.of(context).canPop()) Navigator.of(context).pop();
            // ignore: empty_catches
          } catch (e) {}
          return true;
        },
        selector: (context, appProvider) => appProvider.productsShow,
        builder: (context, entries, _) {
          return NotificationListener<ScrollEndNotification>(
            onNotification: (scrollEnd) {
              final metrics = scrollEnd.metrics;
              if (metrics.atEdge) {
                bool isTop = metrics.pixels == 0;
                if (!isTop) {
                  context.read<AppProvider>().readMoreProducts();
                }
              }
              return true;
            },
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: [
                Row(
                  children: [
                    Text("Total Products ${entries.maxNumber}",
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
                GridView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.9,
                  ),
                  itemBuilder: (context, index) =>
                      ProductDesign(entries.data[index]),
                  itemCount: entries.data.length,
                ),
                entries.lastItem,
              ],
            ),
          );
        },
      ),
    );
  }
}
