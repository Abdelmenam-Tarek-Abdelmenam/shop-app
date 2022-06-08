import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/module/deals.dart';
import '../../../../view_model/add_deal_provider.dart';

class ProductsList extends StatelessWidget {
  const ProductsList(this.products, {Key? key}) : super(key: key);

  final List<DealAddProduct> products;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemBuilder: (context, index) =>
          listItem(context, products[index], index),
      separatorBuilder: (_, __) => const SizedBox(
        height: 5,
      ),
      itemCount: products.length,
    );
  }

  Widget listItem(BuildContext context, DealAddProduct item, int index) =>
      Dismissible(
        key: Key(item.product.id.toString()),
        onDismissed: (_) =>
            context.read<AddDealProvider>().removeProduct(index),
        direction: DismissDirection.endToStart,
        background: Container(
          color: Colors.red,
          child: dismissibleBackGround(),
        ),
        child: ListTile(
          title: Text(
            item.product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          isThreeLine: false,
          subtitle: Text("${item.amount} Items | ${item.price} EGP"),
          trailing: FittedBox(
            fit: BoxFit.fill,
            child: Text("${item.amount * item.price} EGP"),
          ),
        ),
      );

  Widget dismissibleBackGround() => Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: const [
          Icon(
            Icons.delete,
            color: Colors.white,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            'Delete',
            style: TextStyle(color: Colors.white),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      );
}
