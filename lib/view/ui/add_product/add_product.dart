import 'package:flutter/material.dart';

import '../../../model/module/product.dart';

class AddProductView extends StatelessWidget {
  const AddProductView(this.product, {Key? key}) : super(key: key);
  final Product product;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          appBar: AppBar(
            title: const Text("Add Product"),
          ),
          body: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Container(),
          )),
    );
  }
}
