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
      is_completed INTEGER DEFAULT 0,
      FOREIGN KEY ($columnPetIdTaskFK) REFERENCES $petProfileTable ($columnPetId)
      )
    ''');
    // User Table
    await db.execute('''
      CREATE TABLE $userTable (
      $columnUserId INTEGER PRIMARY KEY AUTOINCREMENT,
      $columnUsername TEXT NOT NULL UNIQUE,
      $columnPassword TEXT NOT NULL
      )
      '''); 
  }
    // CRUD Methods for Pet Profiles

  // Insert a new pet profile
  Future<int> insertPetProfile(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(petProfileTable, row);
  }

  // Query all pet profiles
Future<List<Map<String, dynamic>>> queryAllPetProfiles() async {
  final db = await database; // Your method to get the database
  return await db.query('pet_profiles'); // Adjust based on your actual table name
}
   // Get a pet profile by ID
  Future<List<Map<String, dynamic>>> getPetProfiles() async {
    return await queryAllPetProfiles();
  }
  // Update a pet profile
  Future<int> updatePetProfile(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row[columnPetId];
    return await db.update(
      petProfileTable,
      row,
      where: '$columnPetId = ?',
      whereArgs: [id],
    );
  }

  // Delete a pet profile
  Future<int> deletePetProfile(int id) async {
    Database db = await instance.database;
    return await db.delete(
      petProfileTable,
      where: '$columnPetId = ?',
      whereArgs: [id],
    );
  }
  

  // CRUD Methods for Health Records

  // Insert a new health record
  Future<int> insertHealthRecord(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(healthRecordsTable, row);
  }

  // Query all health records for a specific pet
  Future<List<Map<String, dynamic>>> queryHealthRecords(int petId) async {
    Database db = await instance.database;
    return await db.query(
      healthRecordsTable,
      where: '$columnPetIdFK = ?',
      whereArgs: [petId],
    );
  }
  

  // CRUD Methods for Daily Care Tasks

  // Insert a new care task
  Future<int> insertDailyCareTask(Map<String, dynamic> row) async {
    Database db = await instance.database;
    return await db.insert(dailyCareTable, row);
  }

  // Query all daily care tasks for a specific pet
  Future<List<Map<String, dynamic>>> queryDailyCareTasks(int petId) async {
    Database db = await instance.database;
    return await db.query(
      dailyCareTable,
      where: '$columnPetIdTaskFK = ?',
      whereArgs: [petId],
    );
  }
  Future<int> deleteDailyCareTask(int id) async {
  Database db = await instance.database;
  return await db.delete(
    dailyCareTable,
    where: '$columnTaskId = ?',
    whereArgs: [id],
  );
}
  Future<void> updateTaskCompletion(int taskId, bool isCompleted) async {
    // Assuming you're using a database like SQLite
    final db = await database; // Your method to get the database instance

    await db.update(
      'tasks', // Table name
      {'is_completed': isCompleted}, // Column and value to update
      where: 'id = ?', // Where clause
      whereArgs: [taskId], // Arguments for the where clause
    );
  }
// User Table information
static final userTable = 'users';
static final columnUserId = 'user_id';
static final columnUsername = 'username';
static final columnPassword = 'password';
    
// method for verifying user credentials
Future<bool> verifyUser(String username, String password) async {
  Database db = await instance.database;
  var res = await db.query(userTable,
      where: '$columnUsername = ? AND $columnPassword = ?',
      whereArgs: [username, password]);
  return res.isNotEmpty;
}

  // method to register a new user
Future<int> registerUser(String username, String password) async {
  Database db = await instance.database;

  // Insert the new user record
  try {
    return await db.insert(userTable, {
      columnUsername: username,
      columnPassword: password,
    });
  } catch (e) {
    // Return -1 if there's an error (e.g., username already exists)
    return -1;
  }
}

}
