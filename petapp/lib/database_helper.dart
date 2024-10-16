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
}