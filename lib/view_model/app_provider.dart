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
  double totalMoneyToday = -1;
  int totalOrdersToday = -1;
  int totalEntriesToday = -1;
  double totalRevenueToday = -1;
  double totalMoney = -1;
  int totalOrders = -1;
  double totalRevenues = -1;

  /// money box
  Future<void> addMoneyEdit(OldMoneyEdit edit) async {
    EasyLoading.show(status: "Adding money edit");
    try {
      await DataBaseRepository.instance.insertMoneyEdit(edit);
      EasyLoading.showSuccess('Money edit added successfully');
      if (edit.type == EditType.add) {
        totalMoney += edit.amount.round();
        totalMoneyToday += edit.amount.round();
      } else {
        totalMoney -= edit.amount.round();
        totalMoneyToday -= edit.amount.round();
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
        try {
          productsShow.data
              .firstWhere((element) => element.id == item.id)
              .amount += item.amount;
        } catch (_) {}
      }

      if (entry.type == PaymentType.paid) {
        graphData.removeMoney(entry.totalPrice);
        totalMoneyToday -= entry.totalPrice.round();
        totalMoney -= entry.totalPrice.round();
      }
      entriesShow.maxNumber++;
      entriesShow.addData(entry);
      totalEntriesToday++;
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
        try {
          productsShow.data
              .firstWhere((element) => element.id == item.id)
              .amount -= item.amount;
        } catch (_) {}
      }
      ordersShow.addData(order);
      ordersShow.maxNumber++;
      totalOrdersToday++;
      totalOrders++;
      if (order.type == PaymentType.paid) {
        graphData.addMoney(order.totalPrice);
        totalMoneyToday += order.totalPrice.round();
        totalMoney += order.totalPrice.round();
        totalRevenueToday += order.profit.round();
        totalRevenues += order.profit.round();
      }

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

  Future<void> editProduct(Product product) async {
    EasyLoading.show(status: "Editing product");
    if (product.check) {
      EasyLoading.showError("Invalid sell price");
      return;
    }
    try {
      await DataBaseRepository.instance.editProduct(product);
      int index = productsShow.data.indexWhere((e) => e.id == product.id);
      if (index != -1) {
        productsShow.data[index] = product;
      }
      EasyLoading.showSuccess('Product edited successfully');
      notifyListeners();
    } catch (err) {
      EasyLoading.showError("An error happened while add product");
    }
  }

  Future<void> deleteProduct(Product product) async {
    EasyLoading.show(status: "Deleting product");
    try {
      await DataBaseRepository.instance.deleteProduct(product.id);
      int index = productsShow.data.indexWhere((e) => e.id == product.id);
      if (index != -1) {
        productsShow.data.removeAt(index);
      }
      productsShow.maxNumber--;
      EasyLoading.showSuccess('Product deleted successfully');
      notifyListeners();
    } catch (err) {
      EasyLoading.showError("An error happened while add product");
    }
  }

  /// search
  Future<List<Product>> findProducts(String pattern) async {
    if (pattern.isEmpty) {
      return [];
    }
    return DataBaseRepository.instance.searchProducts(pattern);
  }

  Future<List<EntryModel>> findEntries(String pattern) async {
    if (pattern.isEmpty) {
      return [];
    }
    return DataBaseRepository.instance.searchEntries(pattern);
  }

  Future<List<OrderModel>> findOrders(String pattern) async {
    if (pattern.isEmpty) {
      return [];
    }
    return DataBaseRepository.instance.searchOrders(pattern);
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

  Future<void> startApp() async {
    graphData = await DataBaseRepository.instance.getGraphData();
    getInitialValues();

    productsShow =
        await DataBaseRepository.instance.getSomeProducts(productsShow);

    entriesShow = await DataBaseRepository.instance.getSomeEntries(entriesShow);
    ordersShow = await DataBaseRepository.instance.getSomeOrders(ordersShow);

    notifyListeners();
  }

  Future<void> getInitialValues() async {
    CalculateData data = await DataBaseRepository.instance.getInitialValues();
    totalMoney = data.totalMoney;
    totalMoneyToday = data.totalMoneyToday;
    totalEntriesToday = data.totalEntriesToday;
    totalOrdersToday = data.totalOrdersToday;
    totalRevenues = data.totalRevenues;
    totalRevenueToday = data.totalRevenueToday;
    totalOrders = data.totalOrders;
    notifyListeners();
  }
}
