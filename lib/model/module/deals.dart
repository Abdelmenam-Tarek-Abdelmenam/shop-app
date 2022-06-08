// ignore_for_file: must_be_immutable

import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:shop/model/module/product.dart';
import 'package:shop/model/repository/database_repo.dart';
import 'package:shop/model/repository/dates_repository.dart';

class Deal {
  int id;
  String date;
  String time;
  String name;
  List<DealProduct> items;
  PaymentType type;

  int get itemsCount => items.length;
  double get totalPrice =>
      items.fold(0, (sum, item) => sum + item.price * item.amount);

  bool get isEmpty => id == -1;

  double get profit => totalPrice - _totalRawMoney;

  double get _totalRawMoney =>
      items.fold(0, (sum, item) => sum + item.realPrice * item.amount);

  Deal(
      {required this.items,
      required this.id,
      required this.type,
      required this.name,
      required this.date,
      required this.time});
}

class EntryModel extends Deal {
  EntryModel({
    required String date,
    required String time,
    required String name,
    required List<DealProduct> items,
    required PaymentType type,
    required int id,
  }) : super(
          id: id,
          date: date,
          items: items,
          name: name,
          type: type,
          time: time,
        );

  factory EntryModel.fromJson(Map<String, dynamic> map) {
    return EntryModel(
      id: map[EntryTable.id],
      type: map[EntryTable.type] == 0 ? PaymentType.paid : PaymentType.not,
      items: json
          .decode(map[EntryTable.items])
          .map<DealProduct>((item) => DealProduct.fromJson(item))
          .toList(),
      date: map[EntryTable.date],
      name: map[EntryTable.name],
      time: map[EntryTable.time],
    );
  }

  factory EntryModel.empty() {
    return EntryModel(
      id: -1,
      type: PaymentType.paid,
      items: [],
      date: DateTime.now().formatDate,
      name: '',
      time: TimeOfDay.now().toString(),
    );
  }

  Map<String, dynamic> get toJson => {
        EntryTable.id: id,
        EntryTable.items: json.encode(items.map((e) => e.toJson).toList()),
        EntryTable.date: date,
        EntryTable.name: name,
        EntryTable.time: time,
        EntryTable.totalMoney: totalPrice,
        EntryTable.type: type == PaymentType.paid ? 0 : 1
      };
}

class OrderModel extends Deal {
  OrderModel({
    required String date,
    required String time,
    required String name,
    required List<DealProduct> items,
    required PaymentType type,
    required int id,
  }) : super(
          id: id,
          date: date,
          items: items,
          name: name,
          type: type,
          time: time,
        );

  factory OrderModel.empty() {
    return OrderModel(
      id: -1,
      type: PaymentType.paid,
      items: [],
      date: DateTime.now().formatDate,
      name: '',
      time: TimeOfDay.now().toString(),
    );
  }

  Map<String, dynamic> get toJson => {
        OrderTable.id: id,
        OrderTable.type: type == PaymentType.paid ? 0 : 1,
        OrderTable.items: items.map((e) => e.toJson).toList(),
        OrderTable.date: date,
        OrderTable.name: name,
        OrderTable.time: time,
        OrderTable.totalMoney: totalPrice,
        OrderTable.profit: profit
      };

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json[OrderTable.id],
      type: json[OrderTable.type] == 0 ? PaymentType.paid : PaymentType.not,
      items:
          json[OrderTable.items].map((p) => DealProduct.fromJson(p)).toList(),
      date: json[OrderTable.date],
      name: json[OrderTable.name],
      time: json[OrderTable.time],
    );
  }
}

class DealProduct extends Equatable {
  int id;
  double amount;
  double price;
  double realPrice;

  DealProduct(
      {required this.realPrice,
      required this.id,
      required this.amount,
      required this.price});

  factory DealProduct.fromJson(Map<String, dynamic> json) {
    return DealProduct(
        id: json['id'],
        amount: json['amount'],
        price: json['price'],
        realPrice: json['realPrice']);
  }

  Map<String, dynamic> get toJson =>
      {"id": id, "amount": amount, "price": price, "realPrice": realPrice};

  @override
  List<Object?> get props => [id];
}

class DealAddProduct extends Equatable {
  Product product;
  double amount;
  double price;

  DealAddProduct(
      {required this.product, required this.amount, required this.price});

  factory DealAddProduct.empty() {
    return DealAddProduct(product: Product.empty(), amount: 0, price: 0);
  }

  Map<String, dynamic> get toJson =>
      {"id": product.id, "amount": amount, "price": price};

  DealProduct get toDealProduct => DealProduct(
      id: product.id,
      realPrice: product.realPrice,
      amount: amount,
      price: price);

  @override
  List<Object?> get props => [product.id];
}

enum PaymentType { paid, not }

extension GetWidget on PaymentType {
  String get text {
    switch (this) {
      case PaymentType.paid:
        return "Paid";
      case PaymentType.not:
        return "Not Paid";
    }
  }

  Color get color {
    switch (this) {
      case PaymentType.not:
        return Colors.red;
      case PaymentType.paid:
        return Colors.green;
    }
  }

  IconData get icon {
    switch (this) {
      case PaymentType.not:
        return Icons.close;
      case PaymentType.paid:
        return Icons.check;
    }
  }
}
