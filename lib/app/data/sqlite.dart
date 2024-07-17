// ignore_for_file: depend_on_referenced_packages
import 'package:app_api/app/model/cart.dart';
import 'package:app_api/app/model/favourite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  // Singleton pattern
  static final DatabaseHelper _databaseService = DatabaseHelper._internal();
  factory DatabaseHelper() => _databaseService;
  DatabaseHelper._internal();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    // Initialize the DB first time it is accessed
    _database = await _initDatabase();
    return _database!;
  }

Future<Database> _initDatabase() async {
  final databasePath = await getDatabasesPath();

  final path = join(databasePath, 'db_cart.db');
  print("Đường dẫn database: $databasePath");
  return await openDatabase(
    path,
    version: 2, // Đảm bảo đây là version mới nhất
    onCreate: _onCreate,
    onUpgrade: _onUpgrade,
  );
}
Future<void> _onUpgrade(Database db, int oldVersion, int newVersion) async {
  if (oldVersion < 2) {
    // Kiểm tra xem bảng Favourite đã tồn tại chưa
    var tables = await db.query('sqlite_master', where: 'name = ?', whereArgs: ['Favourite']);
    if (tables.isEmpty) {
      await db.execute(
        'CREATE TABLE Favourite('
        'productID INTEGER PRIMARY KEY, name TEXT, price FLOAT, img TEXT, des TEXT)',
      );
    }
  }
}
 Future<void> _onCreate(Database db, int version) async {
  await db.execute(
    'CREATE TABLE IF NOT EXISTS Cart('
    'productID INTEGER PRIMARY KEY, name TEXT, price FLOAT, img TEXT, des TEXT, count INTEGER)',
  );
  await db.execute(
    'CREATE TABLE IF NOT EXISTS Favourite('
    'productID INTEGER PRIMARY KEY, name TEXT, price FLOAT, img TEXT, des TEXT)',
  );
}
  Future<void> insertProduct(Cart productModel) async {
    final db = await _databaseService.database;
    await db.insert(
      'Cart',
      productModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Cart>> products() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('Cart');
    return List.generate(
        maps.length, (index) => Cart.fromMap(maps[index]));
  }
  Future<Cart> product(int id) async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps =
    await db.query('product', where: 'id = ?', whereArgs: [id]);
    return Cart.fromMap(maps[0]);
  }


   Future<void> minus(Cart product) async {
    final db = await _databaseService.database;
    if(product.count  > 1) product.count--;
    await db.update(
      'Cart',
      product.toMap(),
      where: 'productID = ?',
      whereArgs: [product.productID],
    );
  }
  Future<void> add(Cart product) async {
    final db = await _databaseService.database;
    product.count++;
    await db.update(
      'Cart',
      product.toMap(),
      where: 'productID = ?',
      whereArgs: [product.productID],
    );
  }

  Future<void> deleteProduct(int id) async {
    final db = await _databaseService.database;
    await db.delete(
      'Cart',
      where: 'productID = ?',
      whereArgs: [id],
    );
  }
  
  Future<void> clear() async {
    final db = await _databaseService.database;
    await db.delete(
      'Cart',
      where: 'count > 0'
    );
  }
  Future<void> insertFavourite(Favourite favourite) async {
    final db = await _databaseService.database;
    await db.insert(
      'Favourite',
      favourite.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }
  Future<List<Favourite>> favourites() async {
    final db = await _databaseService.database;
    final List<Map<String, dynamic>> maps = await db.query('Favourite');
    return List.generate(maps.length, (index) => Favourite.fromMap(maps[index]));
  }

  Future<void> deleteFavourite(int id) async {
    final db = await _databaseService.database;
    await db.delete(
      'Favourite',
      where: 'productID = ?',
      whereArgs: [id],
    );
  }
  Future<void> clearAll() async {
  final db = await database;
  await db.delete('cart');
}
}

