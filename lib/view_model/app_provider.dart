import 'package:flutter/material.dart';
import 'package:shop/model/module/product.dart';
import 'package:shop/model/repository/database_repo.dart';
import '../model/module/deals.dart';

import '../model/module/graph_data.dart';
import '../view/shared/functions/toast_helper.dart';

class AppProvider with ChangeNotifier {
  int activeLayout = 0;
  GraphData graphData = GraphData.empty();
  int moneyInBox = -1;
  int revenue = -1;
  int orders = -1;

  void changeLayout(int index) {
    if (index == activeLayout) return;
    activeLayout = index;
    notifyListeners();
  }

  Future<void> startApp() async {
    graphData = await DataBaseRepository.instance.getGraphData();

    notifyListeners();
  }

  Future<List<OrderModel>> getOrders({int start = 0, int end = 20}) {
    return DataBaseRepository.instance.getAllOrders();
  }

  Future<List<EntryModel>> getEntries({int start = 0, int end = 20}) {
    return DataBaseRepository.instance.getAllEntries();
  }

  Future<List<Product>> getProducts({int start = 0, int end = 20}) {
    return DataBaseRepository.instance.getAllProducts();
  }

  Future<void> exportDataBase() async {
    try {
      await DbFileHandling().exportDataBase();
      showToast("File saved successfully,check at you file manager ");
    } catch (err) {
      showToast("An error accrued,Please try again");
    }
  }

  Future<void> importDataBase() async {
    try {
      DataBaseRepository.instance.database =
          await DbFileHandling().importDataBase();
      showToast("File read successfully");
    } catch (err) {
      showToast("Ann error accrued,Please try again");
    }
  }
}
