import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../model/module/product.dart';
import '../../../../view_model/app_provider.dart';
import '../layouts/products/widgets/product_design.dart';

class ProductSearchDelegate extends SearchDelegate<Product?> {
  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          if (query.isNotEmpty) {
            query = '';
          } else {
            close(context, null);
          }
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return Text("results of $query");
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return FutureBuilder<List<Product>>(
        future: context.read<AppProvider>().findProducts(query),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 0.9,
              ),
              itemBuilder: (context, index) =>
                  ProductDesign(snapshot.data![index]),
              itemCount: snapshot.data?.length ?? 0,
            );
          } else {
            if (snapshot.hasError) {
              return const Center(child: Text("Sorry, something went wrong"));
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
