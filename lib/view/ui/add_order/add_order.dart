import 'package:flutter/material.dart';
import 'package:shop/model/module/deals.dart';

class AddOrderView extends StatelessWidget {
  const AddOrderView(this.order, {Key? key}) : super(key: key);
  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Add Order"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(),
          )),
    );
  }
}
