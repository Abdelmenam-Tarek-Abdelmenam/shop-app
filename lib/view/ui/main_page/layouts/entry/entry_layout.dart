import 'package:flutter/material.dart';

import '../../../../../model/module/deals.dart';

class EntryLayout extends StatelessWidget {
  EntryLayout({Key? key}) : super(key: key);
  final EntryModel orderModel = EntryModel(
      totalMoney: 120,
      date: '11-5-200',
      time: '11:20 AM',
      name: 'Abdelmenam Tarek',
      items: [DealProduct(id: "id", amount: 5, price: 5)],
      type: PaymentType.not);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: ListView(
        physics: const BouncingScrollPhysics(),
        children: [
          Row(
            children: [
              Text("Total Orders 10",
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
            itemBuilder: (context, index) => listItem(context, orderModel),
            separatorBuilder: (_, __) => const SizedBox(
              height: 5,
            ),
            itemCount: 10,
          )
        ],
      ),
    );
  }

  Widget listItem(BuildContext context, EntryModel item) => ListTile(
        title: Text(
          item.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        isThreeLine: false,
        subtitle: Text("${item.date} | ${item.itemsCount} items"),
        trailing: FittedBox(
          fit: BoxFit.fill,
          child: Column(
            children: [
              Text("${item.totalMoney} EGP"),
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
      );
}
