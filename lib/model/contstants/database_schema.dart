const String moneyEditTable = '''CREATE TABLE  IF NOT EXISTS "moneyEdits" (
"id"	INTEGER ,
"notes"	TEXT,
"amount"	NUMERIC,
"type"	INTEGER,
"date"	TEXT,
"time"	TEXT,
PRIMARY KEY("id" AUTOINCREMENT)
);''';

const String productsTable = '''CREATE TABLE "products" (
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

const String entriesTable = '''CREATE TABLE "entries" (
	"id"	INTEGER,
	"totalMoney"	NUMERIC,
	"date"	TEXT,
	"time"	TEXT,
	"name"	TEXT,
	"type"	INTEGER,
	"items"	TEXT,
	PRIMARY KEY("id" AUTOINCREMENT)
);''';

const String ordersTable = '''CREATE TABLE "orders" (
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
