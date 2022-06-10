import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shop/model/module/deals.dart';
import 'package:shop/model/module/old_edit_money.dart';
import 'package:shop/model/module/product.dart';
import 'package:shop/model/repository/dates_repository.dart';
import 'package:sqflite/sqflite.dart';

import '../module/ui_models.dart';
import 'data_encodeing.dart';

part '../contstants/database_schema.dart';

part 'files_handling.dart';

const String _dataBasePath = "data.db";
typedef ReturnedData = List<Map<String, dynamic>>;

class DataBaseRepository {
  static DataBaseRepository? _instance;
  static DataBaseRepository get instance => _instance ??= DataBaseRepository();

  late Database _database;

  /// get products by id for deals
  Future<Product> getProduct(int id) async {
    ReturnedData data = await _database.query(ProductsTable.tableName,
        where: "${ProductsTable.id} = $id");
    if (data.isEmpty) return Product.empty();
    return Product.fromJson(data.first);
  }

  Future<List<Product>> getProducts(List<int> ids) async {
    ReturnedData data = await _database.query(ProductsTable.tableName,
        where: "${ProductsTable.id} IN (${ids.join(',')})");
    return data.map((e) => Product.fromJson(e)).toList();
  }

  /// get Data for showing in home screen
  Future<GraphsData> getGraphData() async {
    GraphsData data = GraphsData.empty();
    int maxOrders = await _countData(OrderTable.tableName);
    ReturnedData ordersData = await _database.query(OrderTable.tableName,
        columns: [
          'count(${OrderTable.date}) as results',
        ],
        limit: 30,
        offset: maxOrders - 30,
        groupBy: OrderTable.date);
    data.orders = ordersData.map((e) => e['results'] as int).toList();
    ReturnedData moneyData = await _database.query(OrderTable.tableName,
        columns: [
          'sum(${OrderTable.totalMoney}*${OrderTable.type}) as results',
        ],
        limit: 30,
        offset: maxOrders - 30,
        groupBy: OrderTable.date);
    data.money = moneyData.map((e) => e['results'] as int).toList();
    return GraphsData.empty();
  }

  Future<CalculateData> getInitialValues() async {
    CalculateData data = CalculateData.empty();
    final date = DateTime.now().formatDate;
    data.totalOrders = await _countData(OrderTable.tableName);
    data.totalOrdersToday =
        await _countWhere(OrderTable.tableName, "${OrderTable.date} = '$date'");
    data.totalEntriesToday =
        await _countWhere(EntryTable.tableName, "${OrderTable.date} = '$date'");
    ReturnedData temp = await _database.query(OrderTable.tableName,
        columns: [
          'sum(${OrderTable.profit}*${OrderTable.type}) as results',
        ],
        where: "${OrderTable.date} = '$date'");
    data.totalRevenueToday = temp.first['results'];
    temp = await _database.query(
      OrderTable.tableName,
      columns: [
        'sum(${OrderTable.profit}*${OrderTable.type}) as results',
      ],
    );
    data.totalRevenues = temp.first['results'] ?? 0;
    data.totalMoney = await _totalMoney();
    data.totalMoneyToday = await _totalMoneyToday(date);

    return data;
  }

  Future<ShowData<Product>> getSomeProducts(ShowData<Product> old) async {
    old.maxNumber = await _countData(ProductsTable.tableName);
    old.getNext();

    ReturnedData maps = await _database.query(
      ProductsTable.tableName,
      limit: old.end,
      offset: old.maxNumber - old.end,
    );
    old.data =
        (maps.map((e) => Product.fromJson(e)).toList().reversed.toList());
    return old;
  }

  Future<ShowData<EntryModel>> getSomeEntries(ShowData<EntryModel> old) async {
    old.maxNumber = await _countData(EntryTable.tableName);
    old.getNext();

    ReturnedData maps = await _database.query(
      EntryTable.tableName,
      limit: old.end,
      offset: old.maxNumber - old.end,
    );
    old.data.addAll(maps.map((e) => EntryModel.fromJson(e)).toList());
    return old;
  }

  Future<ShowData<OrderModel>> getSomeOrders(ShowData<OrderModel> old) async {
    old.maxNumber = await _countData(OrderTable.tableName);
    old.getNext();
    ReturnedData maps = await _database.query(
      OrderTable.tableName,
      limit: old.end,
      offset: old.maxNumber - old.end,
    );
    old.data.addAll(maps.map((e) => OrderModel.fromJson(e)).toList());
    return old;
  }

  Future<List<OldMoneyEdit>> getMoneyEdits() async {
    ReturnedData maps = await _database.query(
      MoneyEditTable.tableName,
    );

    return maps.map((e) => OldMoneyEdit.fromJson(e)).toList().reversed.toList();
  }

  /// filter data
  Future<List<Product>> searchProducts(String search) async {
    ReturnedData data = await _database.query(ProductsTable.tableName,
        where: "${ProductsTable.name} LIKE '%$search%'");
    return data.map((e) => Product.fromJson(e)).toList();
  }

  Future<List<EntryModel>> searchEntries(String search) async {
    ReturnedData data = await _database.query(EntryTable.tableName,
        where: "${EntryTable.name} LIKE '%$search%'");
    return data.map((e) => EntryModel.fromJson(e)).toList();
  }

  Future<List<OrderModel>> searchOrders(String search) async {
    ReturnedData data = await _database.query(OrderTable.tableName,
        where: "${OrderTable.name} LIKE '%$search%'");
    return data.map((e) => OrderModel.fromJson(e)).toList();
  }

  /// money Box calculation

  /// insert data to database
  Future<void> insertProduct(Product product) async {
    Map<String, dynamic> map = product.toJson;
    map.remove(ProductsTable.id);
    await _database.insert(ProductsTable.tableName, map);
  }

  Future<void> insertEntry(EntryModel entry) async {
    Map<String, dynamic> map = entry.toJson;
    map.remove(ProductsTable.id);
    await _database.insert(EntryTable.tableName, map);
  }

  Future<void> insertOrder(OrderModel order) async {
    Map<String, dynamic> map = order.toJson;
    map.remove(ProductsTable.id);
    await _database.insert(OrderTable.tableName, map);
  }

  Future<void> insertMoneyEdit(OldMoneyEdit oldEditMoney) async {
    Map<String, dynamic> map = oldEditMoney.toJson;
    map.remove(ProductsTable.id);
    await _database.insert(MoneyEditTable.tableName, map);
  }

  /// edit data in database
  Future<void> editProduct(Product product) async {
    Map<String, dynamic> map = product.toJson;
    map.remove(ProductsTable.id);
    await _database.update(ProductsTable.tableName, map,
        where: '${ProductsTable.id} = ${product.id}');
  }

  Future<void> editProductDeal(DealProduct product, bool isEntry) async {
    Product raw = await getProduct(product.id);
    if (isEntry) {
      raw.amount += product.amount;
      raw.realPrice = product.price;
    } else {
      raw.amount -= product.amount;
    }
    await editProduct(raw);
  }

  Future<void> editEntry(EntryModel entry) async {
    Map<String, dynamic> map = entry.toJson;
    map.remove(ProductsTable.id);
    await _database.update(EntryTable.tableName, map,
        where: '${EntryTable.id} = ${entry.id}');
  }

  Future<void> editOrder(OrderModel order) async {
    Map<String, dynamic> map = order.toJson;
    map.remove(ProductsTable.id);
    await _database.update(OrderTable.tableName, map,
        where: '${OrderTable.id} = ?', whereArgs: [order.id]);
  }

  Future<void> editMoneyEdit(OldMoneyEdit oldEditMoney) async {
    await _database.update(
        MoneyEditTable.tableName, oldEditMoney.toJson.remove(MoneyEditTable.id),
        where: '${MoneyEditTable.id} = ?', whereArgs: [oldEditMoney.id]);
  }

  /// get reports data
  Future<void> fromJson(Map<String, dynamic> json) async {
    await delete();
    await initializeDatabase();
    for (String table in _TablesSchema.allNames) {
      for (Map<String, dynamic> map in json[table]!) {
        await _database.insert(table, map);
      }
    }
  }

  Future<Map<String, ReturnedData>> getAllData() async {
    Map<String, ReturnedData> data = {};
    for (String table in _TablesSchema.allNames) {
      data[table] = await _database.query(table);
    }

    return data;
  }

  Future<ReturnedData> getZeroAmountProduct() async {
    ReturnedData data = await _database.query(ProductsTable.tableName,
        where: "${ProductsTable.amount} = 0");
    return data;
  }

  Future<ReturnedData> getLessAmountProduct(int min) async {
    ReturnedData data = await _database.query(ProductsTable.tableName,
        where: "${ProductsTable.amount} < $min");
    return data;
  }

  Future<ReturnedData> getAllProducts() async {
    ReturnedData data = await _database.query(ProductsTable.tableName);
    return data;
  }

  Future<ReturnedData> getAllEntries() async {
    ReturnedData data = await _database.query(EntryTable.tableName);
    return data;
  }

  Future<ReturnedData> getAllMoneyEdits() async {
    ReturnedData data = await _database.query(MoneyEditTable.tableName);
    return data;
  }

  Future<ReturnedData> getAllOrders() async {
    ReturnedData data = await _database.query(OrderTable.tableName);
    return data;
  }

  /// delete data from database
  Future<void> deleteProduct(int id) async {
    await _database.delete(ProductsTable.tableName,
        where: "${ProductsTable.id} = ?", whereArgs: [id]);
  }

  // Future<void> deleteAllProducts() async {
  //   await _database.delete(ProductsTable.tableName);
  // }

  // Future<void> deleteOrder(int id) async {
  //   await _database.delete(OrderTable.tableName,
  //       where: "${OrderTable.id} = ?", whereArgs: [id]);
  // }

  // Future<void> deleteAllOrders() async {
  //   await _database.delete(OrderTable.tableName);
  // }

  // Future<void> deleteEntry(int id) async {
  //   await _database.delete(EntryTable.tableName,
  //       where: "${EntryTable.id} = ?", whereArgs: [id]);
  // }

  // Future<void> deleteAllEntries() async {
  //   await _database.delete(EntryTable.tableName);
  // }

  // Future<void> deleteAllMoneyEdits() async {
  //   await _database.delete(MoneyEditTable.tableName);
  // }

  // Future<void> deleteMoneyEdit(int id) async {
  //   await _database.delete(MoneyEditTable.tableName,
  //       where: "${MoneyEditTable.id} = ?", whereArgs: [id]);
  // }

  /// helper functions
  Future<int> _countData(String tableName) async {
    ReturnedData value =
        await _database.rawQuery("SELECT COUNT(*) FROM $tableName");
    return value[0]['COUNT(*)'];
  }

  Future<int> _countWhere(String tableName, String where) async {
    ReturnedData value =
        await _database.query(tableName, columns: ["COUNT(*)"], where: where);
    return value[0]['COUNT(*)'];
  }

  Future<double> _totalMoney({String? where}) async {
    double money = 0;
    ReturnedData temp = await _database.query(
      OrderTable.tableName,
      where: where,
      columns: [
        'sum(${OrderTable.totalMoney}*${OrderTable.type}) as results',
      ],
    );
    money += temp[0]['results'] ?? 0;
    temp = await _database.query(
      MoneyEditTable.tableName,
      where: where,
      columns: [
        'sum(${MoneyEditTable.amount}*${MoneyEditTable.type}) as results',
      ],
    );
    money += temp[0]['results'] ?? 0;
    temp = await _database.query(
      EntryTable.tableName,
      where: where,
      columns: [
        'sum(${EntryTable.totalMoney}*${EntryTable.type}) as results',
      ],
    );
    money -= temp[0]['results'] ?? 0;

    return money;
  }

  Future<double> _totalMoneyToday(String date) async {
    print(date);
    return _totalMoney(where: "${EntryTable.date} = '$date'");
  }

  Future<void> initializeDatabase() async {
    _database = await openDatabase(_dataBasePath,
        version: 1, onCreate: _createDataBase);
  }

  Future<void> _createDataBase(Database db, int _) async {
    for (String schema in _TablesSchema.allSchemas) {
      await db.execute(schema);
    }
  }

  Future<void> dispose() async => await _database.close();

  Future<void> delete() async {
    for (String name in _TablesSchema.allNames) {
      await _database.delete(name);
    }
  }
}
