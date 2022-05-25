import 'package:flutter/material.dart';

enum EditType { add, remove }

extension GetWidget on EditType {
  String get text {
    switch (this) {
      case EditType.remove:
        return "Remove";
      case EditType.add:
        return "Add";
    }
  }

  Color get color {
    switch (this) {
      case EditType.remove:
        return Colors.red;
      case EditType.add:
        return Colors.blue;
    }
  }

  IconData get icon {
    switch (this) {
      case EditType.remove:
        return Icons.remove;
      case EditType.add:
        return Icons.add;
    }
  }
}

class OldMoneyEdit {
  EditType type;
  String date;
  String time;
  String notes;
  int amount;

  OldMoneyEdit(
      {required this.type,
      required this.notes,
      required this.date,
      required this.amount,
      required this.time});

  factory OldMoneyEdit.fromJson(Map<String, dynamic> json) {
    return OldMoneyEdit(
        type: json['type'] == 0 ? EditType.add : EditType.remove,
        notes: json['notes'],
        date: json['date'],
        amount: json['amount'],
        time: json['time']);
  }
}
