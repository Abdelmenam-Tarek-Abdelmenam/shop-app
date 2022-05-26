import 'dart:io';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shop/model/module/deals.dart';
import 'package:shop/model/module/old_edit_money.dart';
import 'package:shop/model/module/product.dart';
import 'package:sqflite/sqflite.dart';

part '../contstants/database_schema.dart';

part 'saving_files.dart';

const String _dataBasePath = "data.db";
typedef _ReturnedData = List<Map<String, dynamic>>;

class DataBaseRepository {
  late Database _database;

  String get dataBasePath => _database.path;

  DataBaseRepository() {
    _init();
  }

  set database(Database database) {
    _database = database;
  }

  Future<Product> getProduct(String id) async {
    _ReturnedData data = await _database.query(ProductsTable.tableName,
        where: "${ProductsTable.id} = ?", whereArgs: [id]);
    if (data.isEmpty) return Product.empty();
    return Product.fromJson(data.first);
  }

  Future<List<Product>> getProducts(List<String> ids) async {
    _ReturnedData data = await _database.query(ProductsTable.tableName,
        where: "${ProductsTable.id} IN (${ids.join(',')})");
    return data.map((e) => Product.fromJson(e)).toList();
  }

  Future<List<Product>> searchProducts(String search) async {
    _ReturnedData data = await _database.query(ProductsTable.tableName,
        where: "${ProductsTable.name} LIKE '%$search%'");
    return data.map((e) => Product.fromJson(e)).toList();
  }

  Future<List<EntryModel>> searchEntries(String search) async {
    _ReturnedData data = await _database.query(EntryTable.tableName,
        where: "${EntryTable.name} LIKE '%$search%'");
    return data.map((e) => EntryModel.fromJson(e)).toList();
  }

  Future<List<OrderModel>> searchOrders(String search) async {
    _ReturnedData data = await _database.query(OrderTable.tableName,
        where: "${OrderTable.name} LIKE '%$search%'");
    return data.map((e) => OrderModel.fromJson(e)).toList();
  }

  Future<void> insertProduct(Product product) async {
    await _database.insert(
        ProductsTable.tableName, product.toJson.remove(ProductsTable));
  }

  Future<void> insertEntry(EntryModel entry) async {
    await _database.insert(
        EntryTable.tableName, entry.toJson.remove(EntryTable.id));
  }

  Future<void> insertOrder(OrderModel order) async {
    await _database.insert(
        OrderTable.tableName, order.toJson.remove(OrderTable.id));
  }

  Future<void> insertMoneyEdit(OldMoneyEdit oldEditMoney) async {
    await _database.insert(MoneyEditTable.tableName,
        oldEditMoney.toJson.remove(MoneyEditTable.id));
  }

  Future<void> editProduct(Product product) async {
    await _database.update(
        ProductsTable.tableName, product.toJson.remove(ProductsTable),
        where: '${ProductsTable.id} = ?', whereArgs: [product.id]);
  }

  Future<void> editEntry(EntryModel entry) async {
    await _database.update(
        EntryTable.tableName, entry.toJson.remove(EntryTable.id),
        where: '${EntryTable.id} = ?', whereArgs: [entry.id]);
  }

  Future<void> editOrder(OrderModel order) async {
    await _database.update(
        OrderTable.tableName, order.toJson.remove(OrderTable.id),
        where: '${OrderTable.id} = ?', whereArgs: [order.id]);
  }

  Future<Product> getZeroAmountProduct() async {
    _ReturnedData data = await _database.query(ProductsTable.tableName,
        where: "${ProductsTable.amount} = 0");
    if (data.isEmpty) return Product.empty();
    return Product.fromJson(data.first);
  }

  Future<Product> getLessAmountProduct(int min) async {
    _ReturnedData data = await _database.query(ProductsTable.tableName,
        where: "${ProductsTable.amount} < $min");
    if (data.isEmpty) return Product.empty();
    return Product.fromJson(data.first);
  }

  Future<void> editMoneyEdit(OldMoneyEdit oldEditMoney) async {
    await _database.update(
        MoneyEditTable.tableName, oldEditMoney.toJson.remove(MoneyEditTable.id),
        where: '${MoneyEditTable.id} = ?', whereArgs: [oldEditMoney.id]);
  }

  Future<void> deleteProduct(int id) async {
    await _database.delete(ProductsTable.tableName,
        where: "${ProductsTable.id} = ?", whereArgs: [id]);
  }

  Future<void> deleteAllProducts() async {
    await _database.delete(ProductsTable.tableName);
  }

  Future<void> deleteOrder(int id) async {
    await _database.delete(OrderTable.tableName,
        where: "${OrderTable.id} = ?", whereArgs: [id]);
  }

  Future<void> deleteAllOrders() async {
    await _database.delete(OrderTable.tableName);
  }

  Future<void> deleteEntry(int id) async {
    await _database.delete(EntryTable.tableName,
        where: "${EntryTable.id} = ?", whereArgs: [id]);
  }

  Future<void> deleteAllEntries() async {
    await _database.delete(EntryTable.tableName);
  }

  Future<void> deleteAllMoneyEdits() async {
    await _database.delete(MoneyEditTable.tableName);
  }

  Future<void> deleteMoneyEdit(int id) async {
    await _database.delete(MoneyEditTable.tableName,
        where: "${MoneyEditTable.id} = ?", whereArgs: [id]);
  }

  Future<List<Product>> getAllProducts() async {
    _ReturnedData data = await _database.query(ProductsTable.tableName);
    return data.map((e) => Product.fromJson(e)).toList();
  }

  Future<List<EntryModel>> getAllEntries() async {
    _ReturnedData data = await _database.query(EntryTable.tableName);
    return data.map((e) => EntryModel.fromJson(e)).toList();
  }

  Future<List<OldMoneyEdit>> getAllMoneyEdits() async {
    _ReturnedData data = await _database.query(MoneyEditTable.tableName);
    return data.map((e) => OldMoneyEdit.fromJson(e)).toList();
  }

  Future<List<EntryModel>> getAllOrders() async {
    _ReturnedData data = await _database.query(OrderTable.tableName);
    return data.map((e) => EntryModel.fromJson(e)).toList();
  }

  Future<void> _init() async {
    _database = await openDatabase(_dataBasePath, onCreate: _createDataBase);
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
    await deleteDatabase(_dataBasePath);
  }
}
