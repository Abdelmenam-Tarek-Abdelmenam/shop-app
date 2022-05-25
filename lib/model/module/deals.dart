import 'package:flutter/material.dart';

class Deal {
  double totalMoney;
  String date;
  String time;
  String name;
  List<DealProduct> items;
  PaymentType type;

  int get itemsCount => items.length;

  Deal(
      {required this.items,
      required this.type,
      required this.totalMoney,
      required this.name,
      required this.date,
      required this.time});

  factory Deal.fromJson(Map<String, dynamic> json) {
    return Deal(
        type: json['type'] == 0 ? PaymentType.paid : PaymentType.not,
        items: json['items'],
        date: json['date'],
        name: json['name'],
        time: json['time'],
        totalMoney: json['money']);
  }

  Map<String, dynamic> get toJson => {
        "type": type == PaymentType.paid ? 0 : 1,
        "items": items.map((e) => e.toJson).toList(),
        "date": date,
        "name": name,
        "time": time,
        "money": totalMoney
      };
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
  }) : super(
            date: date,
            items: items,
            name: name,
            type: type,
            time: time,
            totalMoney: totalMoney);
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
  }) : super(
            date: date,
            items: items,
            name: name,
            type: type,
            time: time,
            totalMoney: totalMoney);

  @override
  Map<String, dynamic> get toJson => {
        "type": type == PaymentType.paid ? 0 : 1,
        "items": items.map((e) => e.toJson).toList(),
        "profit": profit,
        "date": date,
        "name": name,
        "time": time,
        "money": totalMoney
      };

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
        type: json['type'] == 0 ? PaymentType.paid : PaymentType.not,
        items: json['items'].map((p) => DealProduct.fromJson(p)).toList(),
        date: json['date'],
        name: json['name'],
        time: json['time'],
        profit: json['profit'],
        totalMoney: json['money']);
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
