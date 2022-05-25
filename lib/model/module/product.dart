import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class Product extends Equatable {
  String id;
  String date;
  List<int> img; //TODO: CORRECT TYPE
  String name;
  double amount;
  double realPrice;
  double sellPrice;
  String notes;

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
        "notes": notes,
        "date": date,
        "name": name,
        "id": id,
        "sellPrice": sellPrice,
        "realPrice": realPrice,
        "amount": amount,
        "img": img,
      };

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        notes: json['notes'],
        name: json['name'],
        date: json['date'],
        amount: json['amount'],
        id: json['id'],
        img: json['img'],
        realPrice: json['realPrice'],
        sellPrice: json['sellPrice']);
  }

  @override
  List<Object?> get props => [id];
}
