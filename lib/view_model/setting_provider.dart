import 'package:flutter/material.dart';
import 'package:shop/model/repository/database_repo.dart';
import '../model/local/pref_repository.dart';

import '../view/shared/functions/toast_helper.dart';

class SettingProvider with ChangeNotifier {
  late int minimumAmount = PreferenceRepository.getDataFromSharedPreference(
    key: PreferenceKey.minimumAmount,
  );

  final DbFileHandling _fileHandling = DbFileHandling();

  void changeMinimumAmount(int value) {
    minimumAmount = value;
    PreferenceRepository.putDataInSharedPreference(
      value: value,
      key: PreferenceKey.minimumAmount,
    );
    notifyListeners();
  }

  Future<void> exportDataBase() async {
    try {
      await _fileHandling.exportDataBase();
      showToast("File saved successfully,check at you file manager ");
    } catch (err) {
      showToast("An error accrued,Please try again");
    }
  }

  Future<void> importDataBase() async {
    try {
      DataBaseRepository.instance.database =
          await _fileHandling.importDataBase();
      showToast("File read successfully");
    } catch (err) {
      showToast("Ann error accrued,Please try again");
    }
  }

  void printZeroProduct() async {
    ReturnedData products =
        await DataBaseRepository.instance.getZeroAmountProduct();
    try {
      await _fileHandling.saveCsv(products, "Zero Product");
      showToast("File saved successfully");
    } catch (err) {
      showToast("Ann error accrued,Please try again");
    }
  }

  void printLessProduct() async {
    ReturnedData products =
        await DataBaseRepository.instance.getLessAmountProduct(minimumAmount);
    try {
      await _fileHandling.saveCsv(products, "Less Product");
      showToast("File saved successfully");
    } catch (err) {
      showToast("Ann error accrued,Please try again");
    }
  }

  void printAllProduct() async {
    ReturnedData products = await DataBaseRepository.instance.getAllProducts();
    try {
      await _fileHandling.saveCsv(products, "All Product");
      showToast("File saved successfully");
    } catch (err) {
      showToast("Ann error accrued,Please try again");
    }
  }

  void printAllEntries() async {
    ReturnedData products = await DataBaseRepository.instance.getAllEntries();
    try {
      await _fileHandling.saveCsv(products, "All Entries");
      showToast("File saved successfully");
    } catch (err) {
      showToast("Ann error accrued,Please try again");
    }
  }

  void printAllOrders() async {
    ReturnedData products = await DataBaseRepository.instance.getAllOrders();
    try {
      await _fileHandling.saveCsv(products, "All Orders");
      showToast("File saved successfully");
    } catch (err) {
      showToast("Ann error accrued,Please try again");
    }
  }

  void printAllMoneyEdit() async {
    ReturnedData products =
        await DataBaseRepository.instance.getAllMoneyEdits();
    try {
      await _fileHandling.saveCsv(products, "All Money Edit");
      showToast("File saved successfully");
    } catch (err) {
      showToast("Ann error accrued,Please try again");
    }
  }
}
