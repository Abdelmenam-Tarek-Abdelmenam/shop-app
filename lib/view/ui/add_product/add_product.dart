import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/model/repository/database_repo.dart';
import 'package:shop/model/repository/dates_repository.dart';
import 'package:shop/view/resources/asstes_manager.dart';
import 'package:shop/view/shared/widgets/form_field.dart';
import 'package:shop/view/shared/widgets/numeric_field.dart';
import 'package:shop/view_model/app_provider.dart';

import '../../../model/module/product.dart';
import '../../resources/styles_manager.dart';
import '../../shared/functions/dialog.dart';

// ignore: must_be_immutable
class AddProductView extends StatelessWidget {
  AddProductView(this.product, {Key? key}) : super(key: key);
  final Product? product;

  late Uint8List? img = product?.img;
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController =
      TextEditingController(text: product?.name);
  late final TextEditingController _notesController =
      TextEditingController(text: product?.notes);
  late final TextEditingController _amountController =
      TextEditingController(text: product?.amount.toString() ?? "10");
  late final TextEditingController _realPriceController =
      TextEditingController(text: product?.realPrice.toString() ?? "0");
  late final TextEditingController _sellPriceController =
      TextEditingController(text: product?.sellPrice.toString() ?? "0");

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).requestFocus(FocusNode()),
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.save_outlined),
            onPressed: () async {
              if (_formKey.currentState!.validate()) {
                Product product = Product(
                    id: this.product?.id ?? 0,
                    name: _nameController.text,
                    notes: _notesController.text,
                    amount: double.parse(_amountController.text),
                    realPrice: double.parse(_realPriceController.text),
                    sellPrice: double.parse(_sellPriceController.text),
                    date: DateTime.now().formatDate,
                    img: img);
                if (this.product == null) {
                  await context.read<AppProvider>().addProduct(product);
                } else {
                  await context.read<AppProvider>().editProduct(product);
                }
                if (Navigator.canPop(context)) {
                  // Navigator.pop(context);
                }
              }
            },
          ),
          appBar: AppBar(
            title: Text("${product == null ? "Add" : "Edit"} Product"),
            actions: product == null
                ? null
                : [
                    IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () async {
                        if (await chooseDialog(context,
                            title: "Delete Product",
                            content:
                                "Are you sure you want to delete this product?")) {
                          await context
                              .read<AppProvider>()
                              .deleteProduct(product!);
                        }
                      },
                    )
                  ],
          ),
          body: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Text(
                      "Last Updated: ${product?.date ?? DateTime.now().formatDate}",
                      style: Theme.of(context).textTheme.headline4),
                  const Divider(),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .onBackground
                            .withOpacity(0.5),
                      ),
                      borderRadius: StyleManager.border,
                    ),
                    margin: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: _imageField(),
                  ),
                  const Divider(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: StyleManager.border,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    child: DefaultFormField(
                      border: true,
                      controller: _nameController,
                      title: "Name",
                      prefix: Icons.text_fields_outlined,
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Name is required";
                        }
                        return null;
                      },
                    ),
                  ),
                  const Divider(),
                  Container(
                      decoration: BoxDecoration(
                        borderRadius: StyleManager.border,
                        color: Theme.of(context).colorScheme.onSecondary,
                      ),
                      child: NumericField(_amountController, title: 'Amount')),
                  const Divider(),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: StyleManager.border,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                              child: NumericField(_realPriceController,
                                  title: 'Real Price'))),
                      const SizedBox(width: 10),
                      Expanded(
                          child: Container(
                              decoration: BoxDecoration(
                                borderRadius: StyleManager.border,
                                color:
                                    Theme.of(context).colorScheme.onSecondary,
                              ),
                              child: NumericField(_sellPriceController,
                                  title: 'Sell Price'))),
                    ],
                  ),
                  const Divider(),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: StyleManager.border,
                      color: Theme.of(context).colorScheme.onSecondary,
                    ),
                    child: DefaultFormField(
                      border: true,
                      controller: _notesController,
                      title: "Notes",
                      prefix: Icons.notes_outlined,
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          )),
    );
  }

  Widget _imageField() => StatefulBuilder(
      builder: (context, setState) => Stack(
            alignment: Alignment.bottomRight,
            children: [
              Hero(
                tag: product?.id ?? 0,
                child: ClipRRect(
                  borderRadius: StyleManager.border, // Image border
                  child: img != null
                      ? Image.memory(img!)
                      : Image.asset(
                          AssetsManager.noProductImage,
                          width: double.infinity,
                          fit: BoxFit.fitWidth,
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 20,
                  foregroundColor: Theme.of(context).colorScheme.onSecondary,
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  child: Center(
                    child: IconButton(
                      iconSize: 25,
                      icon: const Icon(Icons.camera_alt_outlined),
                      onPressed: () async {
                        img = await ImageFileHandling().pickImage(context);
                        setState(() {});
                      },
                    ),
                  ),
                ),
              ),
            ],
          ));
}
