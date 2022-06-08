import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shop/model/repository/database_repo.dart';
import 'package:shop/model/repository/dates_repository.dart';

import '../model/module/deals.dart';
import '../model/module/product.dart';

class AddDealProvider with ChangeNotifier {
  AddDealProvider(this.deal) {
    print(entry.toJson);
    if (!entry.isEmpty) {
      getProducts();
    }
  }
  Deal deal;

  EntryModel get entry => deal as EntryModel;
  OrderModel get order => deal as OrderModel;
  bool get isEntry => deal is EntryModel;

  List<DealAddProduct> products = [];
  DealAddProduct activeProduct = DealAddProduct.empty();

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

  Future<List<Product>> findProducts(String pattern) async {
    if (pattern.isEmpty) {
      return [];
    }
    return DataBaseRepository.instance.searchProducts(pattern);
  }

  void removeProduct(int index) {
    products.removeAt(index);
    entry.items.removeAt(index);
    notifyListeners();
  }

  void addProduct() {
    if (activeProduct.price != activeProduct.product.realPrice) {
      EasyLoading.showError(
          "Supplier price change , please modify product price");
    }
    if (activeProduct.product.amount == 0) {
      EasyLoading.showError("No type the amount");
      return;
    }
    if (activeProduct.product.isEmpty) {
      EasyLoading.showError("No product to add");
      return;
    }
    for (DealAddProduct product in products) {
      if (product.product.id == activeProduct.product.id) {
        EasyLoading.showError("Product already added");
        return;
      }
    }
    products.add(activeProduct);
    entry.items.add(activeProduct.toDealProduct);
    activeProduct = DealAddProduct.empty();
    notifyListeners();
  }

  void changeActivePrice(double? value) {
    activeProduct.price = value ?? activeProduct.price;
    notifyListeners();
  }

  void changeActiveProduct(Product product) {
    activeProduct.product = product;
    activeProduct.amount = 0;
    activeProduct.price = product.realPrice;
    notifyListeners();
  }

  void changeActiveAmount(double? value) {
    activeProduct.amount = value ?? activeProduct.amount;
    notifyListeners();
  }

  void changeDate(DateTime dateTime) {
    entry.date = dateTime.formatDate;
    notifyListeners();
  }
}
