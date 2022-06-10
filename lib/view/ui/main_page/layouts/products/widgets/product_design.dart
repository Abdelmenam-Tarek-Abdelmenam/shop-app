import 'package:flutter/material.dart';

import '../../../../../../model/module/product.dart';
import '../../../../../resources/asstes_manager.dart';
import '../../../../../resources/routes_manger.dart';
import '../../../../../resources/styles_manager.dart';

class ProductDesign extends StatelessWidget {
  final Product item;
  const ProductDesign(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.onSecondary,
          borderRadius: StyleManager.border,
          boxShadow: StyleManager.shadow),
      child: InkWell(
        onTap: () => Navigator.of(context)
            .pushNamed(Routes.addProductRoute, arguments: item),
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
}
