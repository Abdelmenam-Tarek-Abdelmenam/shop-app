import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_typeahead/flutter_typeahead.dart';
import 'package:provider/provider.dart';
import 'package:shop/model/module/product.dart';

import '../../../../view_model/add_deal_provider.dart';
import '../../../resources/asstes_manager.dart';
import '../../../resources/styles_manager.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: StyleManager.border,
        color: Theme.of(context).colorScheme.background,
      ),
      margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      child: TypeAheadField<Product>(
          textFieldConfiguration: TextFieldConfiguration(
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search for product',
                hintStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w300,
                  color: Colors.grey[500],
                ),
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20,
                )),
          ),
          // hideOnError: true,
          suggestionsCallback: context.read<AddDealProvider>().findProducts,
          itemBuilder: (context, suggestion) {
            return ListTile(
                leading: image(suggestion.img),
                title: Text(suggestion.name),
                subtitle: Text(
                  ("${suggestion.sellPrice}"),
                ));
          },
          onSuggestionSelected: (suggestion) {
            context.read<AddDealProvider>().changeActiveProduct(suggestion);
          }),
    );
  }

  Widget image(Uint8List? img) {
    return img != null
        ? Image.memory(img)
        : Image.asset(
            AssetsManager.noProductImage,
            width: double.infinity,
            fit: BoxFit.fitWidth,
          );
  }
}
