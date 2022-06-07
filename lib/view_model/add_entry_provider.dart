import 'package:flutter/material.dart';
import 'package:shop/model/repository/database_repo.dart';
import 'package:shop/model/repository/dates_repository.dart';

import '../model/module/deals.dart';
import '../model/module/product.dart';

class AddEntryProvider with ChangeNotifier {
  AddEntryProvider(this.entry) {
    if (!entry.isEmpty) {
      getProducts();
    }
  }
  EntryModel entry;
  List<DealAddProduct> products = [];

  Future<void> getProducts() async {
    List<int> ids = entry.items.map((e) => e.id).toList();
    List<Product> entryProducts =
        await DataBaseRepository.instance.getProducts(ids);
    products = List.generate(entry.items.length, (index) {
      return DealAddProduct(
        product: entryProducts[index],
        amount: entry.items[index].amount,
        price: entry.items[index].price,
      );
    });
    notifyListeners();
  }

  void changeDate(DateTime dateTime) {
    entry.date = dateTime.formatDate;
    notifyListeners();
  }
}
