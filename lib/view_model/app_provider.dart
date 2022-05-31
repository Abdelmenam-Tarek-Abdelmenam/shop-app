import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:shop/model/module/product.dart';
import 'package:shop/model/repository/database_repo.dart';
import '../model/module/deals.dart';
import "../model/module/ui_models.dart";

class AppProvider with ChangeNotifier {
  GraphsData graphData = GraphsData.empty();
  ShowData<Product> productsShow = ShowData.empty();
  ShowData<EntryModel> entriesShow = ShowData.empty();
  ShowData<OrderModel> ordersShow = ShowData.empty();
  int moneyInBox = -1;
  int revenue = -1;
  int orders = -1;

  Future<void> startApp() async {
    graphData = await DataBaseRepository.instance.getGraphData();
    graphData.orders = [1, 2, 3];
    productsShow =
        await DataBaseRepository.instance.getSomeProducts(productsShow);

    entriesShow = await DataBaseRepository.instance.getSomeEntries(entriesShow);
    ordersShow = await DataBaseRepository.instance.getSomeOrders(ordersShow);

    notifyListeners();
  }

  void readMoreProducts() {
    if (productsShow.isEnd) return;

    notifyListeners();
    DataBaseRepository.instance.getSomeProducts(productsShow).then((value) {
      productsShow = value;
      print(productsShow);
      notifyListeners();
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
