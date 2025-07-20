import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/todo_model.dart';

class DatabaseService {
  DatabaseService._privateConstructor();
  static final DatabaseService instance = DatabaseService._privateConstructor();
  factory DatabaseService() => instance;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDataBase();
      return _database!;
    }
  }

  Future<Database> _initDataBase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'todo_database.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE todos (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        isChecked INTEGER,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        createdDate TEXT NOT NULL,
        updatedDate TEXT,
        todoItemColor INTEGER
      )
    ''');
  }

  // CRUD operations

  Future<int> insertToDo(ToDoModel toDoModel) async {
    final db = await database;
    int id = await db.insert(
      'todos',
      toDoModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return id;
  }

  Future<List<ToDoModel>> getAllToDos() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      'todos',
      orderBy: 'createdDate DESC',
    );
    return maps.map((json) => ToDoModel.fromMap(json)).toList();
  }

  Future<int> updateToDo(ToDoModel toDoModel) async {
    final db = await database;
    return await db.update(
      'todos',
      toDoModel.toMap(),
      where: 'id = ?',
      whereArgs: [toDoModel.id],
    );
  }

  Future<int> deleteToDo(int id) async {
    final db = await database;
    return await db.delete('todos', where: 'id = ?', whereArgs: [id]);
  }

  // Future<void> deleteAllToDos() async {
  //   final db = await database;
  //   await db.delete('todos');
  // }

  Future close() async {
    if (_database != null) {
      await _database!.close();
      _database = null;
    }
  }
}
