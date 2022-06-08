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
  double moneyInBox = 300;
  int revenue = 50;
  int orders = 7;

  int entries = 2;

  Future<void> startApp() async {
    graphData = await DataBaseRepository.instance.getGraphData();
    graphData.orders = [4, 5, 7, 2, 1, 4, 8, 0, 4];
    graphData.money = [450, 300, 210, 400, 100, 770, 540, 0, 430];
    productsShow =
        await DataBaseRepository.instance.getSomeProducts(productsShow);

    entriesShow = await DataBaseRepository.instance.getSomeEntries(entriesShow);
    ordersShow = await DataBaseRepository.instance.getSomeOrders(ordersShow);

    notifyListeners();
  }

  /// money box
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

  /// entries
  Future<void> addEntry(EntryModel entry) async {
    EasyLoading.show(status: "Adding entry");
    try {
      await DataBaseRepository.instance.insertEntry(entry);
      for (DealProduct item in entry.items) {
        await DataBaseRepository.instance.editProductDeal(item, true);
        productsShow.data
            .firstWhere((element) => element.id == item.id)
            .amount += item.amount;
      }
      entriesShow.addData(entry);
      if (entry.type == PaymentType.paid) moneyInBox -= entry.totalPrice;
      entriesShow.maxNumber++;
      EasyLoading.showSuccess('Entry added successfully');
      notifyListeners();
    } catch (err) {
      EasyLoading.showError("An error happened while add entry");
    }
  }

  Future<void> editEntry(EntryModel entry) async {
    EasyLoading.show(status: "Editing entry");

    try {
      await DataBaseRepository.instance.editEntry(entry);
      int index = entriesShow.data.indexWhere((e) => e.id == entry.id);
      entriesShow.data[index] = entry;
      EasyLoading.showSuccess('Entry edited successfully');
      notifyListeners();
    } catch (err) {
      EasyLoading.showError("An error happened while add entry");
    }
  }

  /// orders
  Future<void> addOrder(OrderModel order) async {
    EasyLoading.show(status: "Adding order");
    try {
      DataBaseRepository.instance.insertOrder(order);
      for (DealProduct item in order.items) {
        await DataBaseRepository.instance.editProductDeal(item, false);
        productsShow.data
            .firstWhere((element) => element.id == item.id)
            .amount -= item.amount;
      }
      ordersShow.addData(order);
      ordersShow.maxNumber++;
      if (order.type == PaymentType.paid) moneyInBox += order.totalPrice;

      EasyLoading.showSuccess('Order added successfully');
      notifyListeners();
    } catch (err) {
      EasyLoading.showError("An error happened while add order");
    }
  }

  Future<void> editOrder(OrderModel order) async {
    EasyLoading.show(status: "Editing order");

    try {
      await DataBaseRepository.instance.editOrder(order);
      int index = entriesShow.data.indexWhere((e) => e.id == order.id);
      ordersShow.data[index] = order;
      EasyLoading.showSuccess('Order edited successfully');
      notifyListeners();
    } catch (err) {
      EasyLoading.showError("An error happened while add order");
    }
  }

  /// Products
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
    } catch (err) {
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
    } catch (err) {
      EasyLoading.showError("An error happened while add product");
    }
  }

  /// ListView Infinite scroll
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

  Future<void> readMoreEntries() async {
    if (entriesShow.isEnd) return;
    await DataBaseRepository.instance.getSomeEntries(entriesShow).then((value) {
      entriesShow = value;
      notifyListeners();
    }).catchError((err) {
      EasyLoading.showError("An error happened while reading more Entries");
    });
  }

  Future<void> readMoreOrders() async {
    if (ordersShow.isEnd) return;
    await DataBaseRepository.instance.getSomeOrders(ordersShow).then((value) {
      ordersShow = value;
      notifyListeners();
    }).catchError((err) {
      EasyLoading.showError("An error happened while reading more Entries");
    });
  }

  /// till here

  void getInitialValues() {
    if (moneyInBox != -1) return;
    moneyInBox = 0;
    notifyListeners();
  }
}
