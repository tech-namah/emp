import 'package:emp_management_ansh_ramani/model/employee_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;
  static Database? _db;

  DatabaseHelper.internal();

  Future<Database?> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  Future<Database> initDb() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, "employee_database.db");

    return await openDatabase(path, version: 2, onCreate: (Database db, int version) async {
      await db.execute(
        // "CREATE TABLE Employee(id INTEGER PRIMARY KEY, name TEXT, role TEXT, date_of_employment TEXT)",
        "CREATE TABLE Employee(id INTEGER PRIMARY KEY, name TEXT, role TEXT, dateOfEmployment TEXT)",
      );
    }, onUpgrade: (db, oldVersion, newVersion) {
      if (oldVersion < 2) {
        // Add any migration logic here to update the schema.
      }
    });
  }

  Future<int> insertEmployee(Employee employee) async {
    print("step ------------------- 1");
    final dbClient = await db;
    print("step ------------------- 2");
    return await dbClient!.insert('Employee', employee.toMap());
  }

  Future<List<Employee>> getEmployees() async {
    final dbClient = await db;
    final list = await dbClient!.query('Employee');
    return list.map((data) => Employee.fromMap(data)).toList();
  }

  Future<int> updateEmployee(Employee employee) async {
    final dbClient = await db;
    return await dbClient!.update(
      'Employee',
      employee.toMap(),
      where: 'id = ?',
      whereArgs: [employee.id],
    );
  }


  Future<int> deleteEmployee(int id) async {
    final dbClient = await db;
    return await dbClient!.delete(
      'Employee',
      where: 'id = ?',
      whereArgs: [id],
    );
  }


}

