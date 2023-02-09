// ignore_for_file: depend_on_referenced_packages

import 'package:sqflite/sqflite.dart';
import 'note.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  //create a private constructor;
  DatabaseHelper.privateconstructor();
  //make a singleton instance for this class.
  static final DatabaseHelper instance = DatabaseHelper.privateconstructor();

  final _dbname = "yuke.db";
  final _dbversion = 1;

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initdb();
    return _database!;
  }

  Future<Database> initdb() async {
    // Get the path of the local file / disk where the db will be stored
    String path = join(await getDatabasesPath(), _dbname);
    //The correct method is to actually use the getDocumentsDirectoryApplication() function,
    // from where we get the path and then add with the db name.

    return openDatabase(path, version: _dbversion, onCreate: createdb);
  }

  Future createdb(Database db, int version) async {
    db.execute('''
  CREATE TABLE $tablename
  (
    ${NoteFields.id} INTEGER PRIMARY KEY AUTOINCREMENT NULL,
    ${NoteFields.title} TEXT,
    ${NoteFields.content} TEXT,
    ${NoteFields.bgColor} INTEGER,
    ${NoteFields.dateTime} TEXT,
    ${NoteFields.isImportant} BOOLEAN NOT NULL
  );
''');
  }

  // to insert any record
  Future<Note> insert(Note note) async { 
    Database db = await instance.database;
    int id = await db.insert(tablename, note.toMap());
    return note.copy(id: id);
  }

  // to update any record
  Future<int> update(Note note) async {
    Database db = await instance.database;
    return db.update(tablename, note.toMap(),
        where: "${NoteFields.id} = ?", whereArgs: [note.id]);
  }

  // to delete any record
  Future<int> delete(int id) async {
    Database db = await instance.database;
    return db.delete(tablename, where: "${NoteFields.id} = ?", whereArgs: [id]);
  }

  //to delete the entire table
  droptable() async {
    Database db = await instance.database;
    db.delete(tablename);
  }

  // to select any one record
  Future<Note> queryone(int id) async {
    Database db = await instance.database;
    var result = await db
        .query(tablename, where: "${NoteFields.id} = ?", whereArgs: [id]);
    return Note.toNote(result.first);
  }

  // to select all the records of the table
  Future<List<Note>> queryall() async {
    Database db = await instance.database;
    var result = await db.query(tablename,orderBy:"${NoteFields.isImportant} DESC,${NoteFields.dateTime} ASC");
    return result.map((note) => Note.toNote(note)).toList();
  }
}
