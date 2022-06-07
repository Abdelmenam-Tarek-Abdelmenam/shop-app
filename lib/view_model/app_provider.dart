import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shop/model/module/old_edit_money.dart';
import 'package:shop/model/module/product.dart';
import 'package:shop/model/repository/database_repo.dart';
import '../model/module/deals.dart';
import "../model/module/ui_models.dart";

class AppProvider with ChangeNotifier {
  GraphsData graphData = GraphsData.empty();
  ShowData<Product> productsShow = ShowData.empty();
  ShowData<EntryModel> entriesShow = ShowData.empty();
  ShowData<OrderModel> ordersShow = ShowData.empty();
  double moneyInBox = -1;
  int revenue = -1;
  int orders = -1;
  int entries = -1;

  Future<void> startApp() async {
    graphData = await DataBaseRepository.instance.getGraphData();
    graphData.orders = [1, 2, 3];
    productsShow =
        await DataBaseRepository.instance.getSomeProducts(productsShow);

    entriesShow = await DataBaseRepository.instance.getSomeEntries(entriesShow);
    ordersShow = await DataBaseRepository.instance.getSomeOrders(ordersShow);

    notifyListeners();
  }

  Future<void> readMoreProducts() async {
    if (productsShow.isEnd) return;

    await DataBaseRepository.instance
        .getSomeProducts(productsShow)
        .then((value) {
      productsShow = value;
      notifyListeners();
    }).catchError((err) {
      EasyLoading.showError("An error happened while reading more products");
    });
  }

  Future<void> addProduct(Product product) async {
    EasyLoading.show(status: "Adding product");
    if (product.check) {
      EasyLoading.showError("Invalid sell price");
      return;
    }
    try {
      await DataBaseRepository.instance.insertProduct(product);
      productsShow.addData(product);
      productsShow.maxNumber++;
      EasyLoading.showSuccess('Product added successfully');
      notifyListeners();
    } catch (err) {
      EasyLoading.showError("An error happened while add product");
    }
  }

  Future<void> editProduct(Product product, int index) async {
    print(product.name);
    EasyLoading.show(status: "Editing product");
    if (product.check) {
      EasyLoading.showError("Invalid sell price");
      return;
    }
    try {
      await DataBaseRepository.instance.editProduct(product);
      productsShow.data[index] = product;
      EasyLoading.showSuccess('Product edited successfully');
      notifyListeners();
    } catch (err, stack) {
      print(err);
      print(stack);
      EasyLoading.showError("An error happened while add product");
    }
  }

  Future<void> deleteProduct(Product product, int index) async {
    EasyLoading.show(status: "Deleting product");
    try {
      await DataBaseRepository.instance.deleteProduct(product.id);
      productsShow.data.removeAt(index);
      productsShow.maxNumber--;
      EasyLoading.showSuccess('Product deleted successfully');
      notifyListeners();
    } catch (err, stack) {
      print(err);
      print(stack);
      EasyLoading.showError("An error happened while add product");
    }
  }

  Future<void> addMoneyEdit(OldMoneyEdit edit) async {
    EasyLoading.show(status: "Adding money edit");
    try {
      await DataBaseRepository.instance.insertMoneyEdit(edit);
      EasyLoading.showSuccess('Money edit added successfully');
      if (edit.type == EditType.add) {
        moneyInBox += edit.amount;
      } else {
        moneyInBox -= edit.amount;
      }
      notifyListeners();
    } catch (err) {
      EasyLoading.showError("An error happened while add money edit");
    }
  }

  Future<List<OldMoneyEdit>> readAllMoneyEdits() async {
    return await DataBaseRepository.instance.getMoneyEdits();
  }

  /// till here
  void getEntries() {
    if (entriesShow.isEnd) return;
    notifyListeners();
    DataBaseRepository.instance.getSomeEntries(entriesShow).then((value) {
      entriesShow = value;
      notifyListeners();
    });
  }

  void getOrders() {
    if (ordersShow.isEnd) return;
    notifyListeners();
    DataBaseRepository.instance.getSomeOrders(ordersShow).then((value) {
      ordersShow = value;
      notifyListeners();
    });
  }

  void getMoneyInBox() {
    if (moneyInBox != -1) return;
    moneyInBox = 0;
    notifyListeners();
  }

  void calculateRevenue() {}

  void calculateOrders() {}
}
