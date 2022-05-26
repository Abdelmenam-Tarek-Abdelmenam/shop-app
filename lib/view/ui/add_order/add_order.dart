import 'package:flutter/material.dart';

import '../../../model/module/deals.dart';
import '../add_entry/add_entry.dart';

class AddOrderView extends StatelessWidget {
  const AddOrderView(this.order, {Key? key}) : super(key: key);
  final OrderModel? order;

  @override
  Widget build(BuildContext context) {
    return const AddEntryView(null);
    // return GestureDetector(
    //   onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
    //   child: Scaffold(
    //       appBar: AppBar(
    //         title: Text("${order == null ? "Add" : "Edit"} Order"),
    //       ),
    //       body: Padding(
    //         padding: const EdgeInsets.all(15.0),
    //         child: Container(),
    //       )),
    // );
  }
}
