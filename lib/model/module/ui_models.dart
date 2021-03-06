// ignore_for_file: must_be_immutable, prefer_const_literals_to_create_immutables

import 'package:equatable/equatable.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:shop/model/module/deals.dart';

class GraphsData extends Equatable {
  List<int> money;
  List<int> orders;

  List<int> get moneyGraph => money.isEmpty ? [0] : money;
  List<int> get ordersGraph => orders.isEmpty ? [0] : orders;

  GraphsData({required this.money, required this.orders});

  factory GraphsData.empty() => GraphsData(money: [0], orders: [0]);

  bool get isEmpty => money.isEmpty && orders.isEmpty;

  void addMoney(double value) {
    money[money.length - 1] += value.round();
  }

  void removeMoney(double value) {
    money[money.length - 1] -= value.round();
  }

  void addOrder(int order) {
    orders[orders.length - 1] += order;
  }

  @override
  List<Object?> get props => [money.firstOrNull, orders.firstOrNull];
}

class DealsData extends Equatable {
  List<Deal> deals;
  int start;
  int end;
  int maxNumber;

  DealsData({
    required this.deals,
    required this.start,
    required this.end,
    required this.maxNumber,
  });

  factory DealsData.empty() =>
      DealsData(deals: const [], start: 0, end: 0, maxNumber: 0);

  bool get isEmpty => deals.isEmpty;
  bool get isEnd => end == maxNumber;

  void getNext() {
    start = end;
    end = end + 20;
    if (end > maxNumber) end = maxNumber;
  }

  @override
  List<Object?> get props => [start, end];
}

class ShowData<T> extends Equatable {
  List<T> data;
  int end = 20;
  int maxNumber;

  ShowData({
    required this.data,
    required this.maxNumber,
  });

  void addData(T newData) {
    data.insert(0, newData);
  }

  factory ShowData.empty() => ShowData(data: [], maxNumber: 0);

  bool get isEmpty => data.isEmpty;
  bool get isEnd => (data.length) == maxNumber;

  void getNext() {
    end = data.length;
    end = end + 10;
    if (end > maxNumber) end = maxNumber;
  }

  Widget get lastItem =>
      isEnd ? Container() : const Center(child: CircularProgressIndicator());

  @override
  List<Object?> get props => [data.length];
}

class CalculateData {
  double totalMoneyToday;
  int totalOrdersToday;
  int totalEntriesToday;
  double totalRevenueToday;
  double totalMoney;
  int totalOrders;
  double totalRevenues;

  CalculateData({
    required this.totalMoneyToday,
    required this.totalOrdersToday,
    required this.totalEntriesToday,
    required this.totalRevenueToday,
    required this.totalMoney,
    required this.totalOrders,
    required this.totalRevenues,
  });

  factory CalculateData.empty() => CalculateData(
        totalMoneyToday: -1,
        totalOrdersToday: -1,
        totalEntriesToday: -1,
        totalRevenueToday: -1,
        totalMoney: -1,
        totalOrders: -1,
        totalRevenues: -1,
      );

  @override
  String toString() {
    return 'CalculateData{totalMoneyToday: $totalMoneyToday, totalOrdersToday: $totalOrdersToday, totalEntriesToday: $totalEntriesToday, totalRevenueToday: $totalRevenueToday, totalMoney: $totalMoney, totalOrders: $totalOrders, totalRevenues: $totalRevenues}';
  }
}
