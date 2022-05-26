import 'package:flutter/material.dart';
import 'package:shop/model/repository/database_repo.dart';

class Deal {
  int id;
  double totalMoney;
  String date;
  String time;
  String name;
  List<DealProduct> items;
  PaymentType type;

  int get itemsCount => items.length;

  Deal(
      {required this.items,
      required this.id,
      required this.type,
      required this.totalMoney,
      required this.name,
      required this.date,
      required this.time});
}

class DealProduct {
  String id;
  double amount;
  double price;

  DealProduct({required this.id, required this.amount, required this.price});

  factory DealProduct.fromJson(Map<String, dynamic> json) {
    return DealProduct(
        id: json['id'], amount: json['amount'], price: json['price']);
  }

  Map<String, dynamic> get toJson =>
      {"id": id, "amount": amount, "price": price};
}

class EntryModel extends Deal {
  EntryModel({
    required double totalMoney,
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
            totalMoney: totalMoney);

  factory EntryModel.fromJson(Map<String, dynamic> json) {
    return EntryModel(
        id: json[EntryTable.id],
        type: json[EntryTable.type] == 0 ? PaymentType.paid : PaymentType.not,
        items: json[EntryTable.items]
            .map<DealProduct>((item) => DealProduct.fromJson(item))
            .toList(),
        date: json[EntryTable.date],
        name: json[EntryTable.name],
        time: json[EntryTable.time],
        totalMoney: json[EntryTable.totalMoney]);
  }

  Map<String, dynamic> get toJson => {
        EntryTable.id: id,
        EntryTable.items: items.map((e) => e.toJson).toList(),
        EntryTable.date: date,
        EntryTable.name: name,
        EntryTable.time: time,
        EntryTable.totalMoney: totalMoney,
        EntryTable.type: type == PaymentType.paid ? 0 : 1
      };
}

class OrderModel extends Deal {
  double profit;

  OrderModel({
    required this.profit,
    required double totalMoney,
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
            totalMoney: totalMoney);

  Map<String, dynamic> get toJson => {
        OrderTable.id: id,
        OrderTable.type: type == PaymentType.paid ? 0 : 1,
        OrderTable.items: items.map((e) => e.toJson).toList(),
        OrderTable.date: date,
        OrderTable.name: name,
        OrderTable.time: time,
        OrderTable.totalMoney: totalMoney,
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
        profit: json[OrderTable.profit],
        totalMoney: json[OrderTable.totalMoney]);
  }
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
