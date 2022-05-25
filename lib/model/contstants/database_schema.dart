part of "../repository/database_repo.dart";

class _TablesSchema {
  static const String _moneyEdit = '''CREATE TABLE  IF NOT EXISTS "moneyEdits" (
"id"	INTEGER ,
"notes"	TEXT,
"amount"	NUMERIC,
"type"	INTEGER,
"date"	TEXT,
"time"	TEXT,
PRIMARY KEY("id" AUTOINCREMENT)
);''';

  static const String _products = '''CREATE TABLE  IF NOT EXISTS  "products" (
	"id"	INTEGER,
	"notes"	TEXT,
	"name"	TEXT,
	"date"	TEXT,
	"amount"	NUMERIC,
	"img"	TEXT,
	"realPrice"	NUMERIC,
	"sellPrice"	NUMERIC,
	PRIMARY KEY("id" AUTOINCREMENT)
);''';

  static const String _entries = '''CREATE TABLE  IF NOT EXISTS  "entries" (
	"id"	INTEGER,
	"totalMoney"	NUMERIC,
	"date"	TEXT,
	"time"	TEXT,
	"name"	TEXT,
	"type"	INTEGER,
	"items"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT)
);''';

  static const String _orders = '''CREATE TABLE  IF NOT EXISTS  "orders" (
	"id"	INTEGER,
	"profit"	NUMERIC,
	"totalMoney"	NUMERIC,
	"date"	TEXT,
	"time"	TEXT,
	"name"	TEXT,
	"type"	INTEGER,
	"items"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT)
);''';

  static List<String> get all => [_moneyEdit, _products, _entries, _orders];
}

class _TablesName {
  static const String moneyEdit = "moneyEdits";
  static const String products = "products";
  static const String entries = "entries";
  static const String orders = "orders";

  static List<String> get all => [moneyEdit, products, entries, orders];
}
