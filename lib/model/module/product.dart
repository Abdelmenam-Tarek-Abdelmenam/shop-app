import 'dart:typed_data';

import 'package:equatable/equatable.dart';

import '../repository/data_encodeing.dart';
import '../repository/database_repo.dart';

// ignore: must_be_immutable
class Product extends Equatable {
  int id;
  String date;
  Uint8List? img;
  String name;
  String? notes;
  double amount;
  double realPrice;
  double sellPrice;

  Product(
      {required this.notes,
      required this.name,
      required this.date,
      required this.amount,
      required this.id,
      required this.img,
      required this.realPrice,
      required this.sellPrice});

  Map<String, dynamic> get toJson => {
        ProductsTable.notes: notes,
        ProductsTable.date: date,
        ProductsTable.name: name,
        ProductsTable.id: id,
        ProductsTable.sellPrice: sellPrice,
        ProductsTable.realPrice: realPrice,
        ProductsTable.amount: amount,
        ProductsTable.img: DataEncoding.encode(img),
      };

  factory Product.fromJson(Map<String, dynamic> json) {
    List? imgData = DataEncoding.decode(json[ProductsTable.img]);
    Uint8List? _imgBytes =
        imgData == null ? null : Uint8List.fromList(List<int>.from((imgData)));

    return Product(
        notes: json[ProductsTable.notes],
        name: json[ProductsTable.name],
        date: json[ProductsTable.date],
        amount: json[ProductsTable.amount].toDouble(),
        id: json[ProductsTable.id],
        img: _imgBytes,
        realPrice: json[ProductsTable.realPrice].toDouble(),
        sellPrice: json[ProductsTable.sellPrice].toDouble());
  }

  factory Product.empty() {
    return Product(
        notes: 'This product has no notes',
        name: 'No Product',
        date: '',
        amount: 0,
        id: -1,
        img: null,
        realPrice: 0,
        sellPrice: 0);
  }

  bool get check => sellPrice < realPrice;
  bool get isEmpty => id == -1;

  @override
  List<Object?> get props => [id];
}
