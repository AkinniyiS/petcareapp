import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper{
  // Database name and version
  static final _databaseName = "PetCareDB.db";
  static final _databaseVersion = 1;

  // Pet Profile Table
  static final petProfileTable = 'pet_profiles';
  static final columnPetId = 'id';
  static final columnPetName = 'name';
  static final columnSpecies = 'species';
  static final columnBreed = 'breed';
  static final columnAge = 'age';

  //Health Records table
  static final healthRecordsTable = 'health_records';
  static final columnHealthId = 'id';
  static final columnVaccinationDate = 'vaccination_date';
  static final columnRecordDetails = 'record_details';
  static final columnPetIdFK = 'pet_id'; //Foreign key that links to Pet Profiles table.

  // Daily Care Tasks Table
  static final dailyCareTable = 'daily_care';
  static final columnTaskId = 'id';
  static final columnTaskName = 'task_name';
  static final columnTaskTime = 'task_time';
  static final columnPetIdTaskFK = 'pet_id';

  static Database? _database;
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  DatabaseHelper._privateConstructor();

  Future<Database> get database async{
    if(_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future <Database> _initDatabase() async{
    String path = join (await getDatabasesPath(), _databaseName);
    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: _onCreate,
    );
  }

  //Create Database tables
  Future _onCreate(Database db, int version) async {
    await db.execute('''
    CREATE TABLE $petProfileTable(
    $columnPetId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnPetName TEXT NOT NULL, 
    $columnSpecies TEXT NOT NULL,
    $columnBreed TEXT, 
    $columnAge INTEGER
    )
    ''');
    
    await db.execute('''
    CREATE TABLE $healthRecordsTable(
    $columnHealthId INTEGER PRIMARY KEY AUTOINCREMENT,
    $columnVaccinationDate TEXT,
    $columnRecordDetails TEXT,
    $columnPetIdFK INTEGER,
    FOREIGN KEY ($columnPetIdFK)REFERENCES $petProfileTable($columnPetId)
    )
    ''');

    await db.execute('''
      CREATE TABLE $dailyCareTable(
      $columnTaskId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnTaskName TEXT NOT NULL,
      $columnTaskTime TEXT NOT NULL,
      $columnPetIdTaskFK INTEGER,
      FOREIGN KEY ($columnPetIdTaskFK) REFERENCES $petProfileTable ($columnPetId)
      )
    ''');
  }
}