import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/model/module/product.dart';
import 'package:shop/view/resources/asstes_manager.dart';

import '../../../../../model/module/ui_models.dart';
import '../../../../../view_model/app_provider.dart';
import '../../../../resources/routes_manger.dart';
import '../../../../resources/styles_manager.dart';
import '../../../add_product/add_product.dart';

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
          } catch (e) {
            print(e);
          }
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
                      listItem(context, entries.data[index], index),
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

  Widget listItem(BuildContext context, Product item, int index) => Container(
        margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.onSecondary,
            borderRadius: StyleManager.border,
            boxShadow: StyleManager.shadow),
        child: InkWell(
          onTap: () => Navigator.of(context).pushNamed(Routes.addProductRoute,
              arguments: AddProductArgument(item, index)),
          child: LayoutBuilder(
            builder: (context, constraints) => Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Hero(
                      tag: item.id,
                      child: ClipRRect(
                        borderRadius: StyleManager.border, // Image border
                        child: item.img == null
                            ? Image.asset(
                                AssetsManager.noProductImage,
                                height: constraints.maxHeight * .58,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              )
                            : Image.memory(
                                item.img!,
                                height: constraints.maxHeight * .58,
                                width: double.infinity,
                                fit: BoxFit.fill,
                              ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.name,
                            maxLines: 1,
                            strutStyle: const StrutStyle(
                              forceStrutHeight: true,
                              height: 1.5,
                            ),
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.subtitle1,
                          ),
                          Tooltip(
                            message: "Real price ${item.realPrice} EGP",
                            child: Text(
                              "${item.sellPrice} EGP",
                              style: Theme.of(context).textTheme.caption,
                            ),
                          ),
                          Text(
                            item.date,
                            style: Theme.of(context).textTheme.headline4,
                          )
                        ],
                      ),
                    )
                  ],
                ),
                Positioned(
                  right: 10,
                  top: constraints.maxHeight * .58 - 10,
                  child: CircleAvatar(
                    radius: 20,
                    foregroundColor: Theme.of(context).colorScheme.onSecondary,
                    backgroundColor: Theme.of(context).colorScheme.onSurface,
                    child: Text(item.amount.toString()),
                  ),
                )
              ],
            ),
          ),
        ),
      );
}
