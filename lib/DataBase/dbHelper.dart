// import 'dart:io';
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';
// import 'package:sqflite/sqflite.dart';

// class DataBaseHelper {
//   static const String dbname = "myDataBase.db";
//   static const String dbTable = "FoodItemList1";
//   static const String columnName = "name";
//   static const String price = "price";
//   static const String columId = "id";

//   static final DataBaseHelper instance = DataBaseHelper();
//   static Database? _database;

//   Future<Database?> get database async {
//     print("Errorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr000");
//     _database ??= await initDB();
//     return _database;
//   }

//   Future<Database> initDB() async {
//     print("Errorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr1111");
//     // Directory directory = await getApplicationDocumentsDirectory();
//     print("Errorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr11112222");
//     String path = join(await getDatabasesPath(), dbname);
//     print("Errorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr1111333");
//     return await openDatabase(
//       path,
//       version: 1,
//       onCreate: (Database db, int version) async {
//         await db.execute('''
//           CREATE TABLE $dbTable (
//             id INTEGER PRIMARY KEY AUTOINCREMENT,
//             $columnName TEXT NOT NULL,
//             $price REAL NOT NULL
//           )
//         ''');
//       },
//     );
//   }

// // Insert Method
//   insertRecord(Map<String, dynamic> row) async {
//     print("Errorrrrrrrrrrrrrrrrrrrrrrrrrrrrrrr222");
//     Database? db = await instance.database;
//     return await db!.insert(dbTable, row);
//   }

// // Read Method
//   Future<List<Map<String, dynamic>>> queryDatabase() async {
//     Database? db = await instance.database;
//     return await db!.query(dbTable);
//   }

//   // Update Method
//   Future<int> updateRecord(Map<String, dynamic> row) async {
//     Database? db = await instance.database;
//     int id = row[columId];
//     return await db!.update(dbTable, row, where: "$columId=?", whereArgs: [id]);
//   }

//   // Delete Method
//   Future<int> deleteRecord(int id) async {
//     Database? db = await instance.database;
//     return await db!.delete(dbTable, where: "$columId=?", whereArgs: [id]);
//   }
// }
