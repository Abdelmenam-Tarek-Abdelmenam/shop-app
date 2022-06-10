import 'package:flutter/material.dart';
import 'package:shop/model/module/deals.dart';

import '../../../../../resources/routes_manger.dart';

class OrderDesign extends StatelessWidget {
  final OrderModel item;
  const OrderDesign(this.item, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed(
        Routes.addOrderRoute,
        arguments: item,
      ),
      child: ListTile(
        title: Text(
          item.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        isThreeLine: false,
        subtitle: Text("${item.date} | ${item.itemsCount} items"),
        trailing: FittedBox(
          fit: BoxFit.fill,
          child: Tooltip(
            message: "Profit is ${item.profit}",
            child: Column(
              children: [
                Text("${item.totalPrice} EGP"),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  children: [
                    Icon(
                      item.type.icon,
                      size: 20,
                      color: item.type.color,
                    ),
                    Text(item.type.text,
                        style: Theme.of(context)
                            .textTheme
                            .subtitle1!
                            .copyWith(color: item.type.color))
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
