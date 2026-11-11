import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import '../models/receta.dart'; 

class RecetasDb {
  RecetasDb._();
  static final RecetasDb instancia = RecetasDb._();
  static const _nombreArchivo = 'misrecetas.db';
  static const _tabla = 'recetas';
  Database? _db;

  Future<Database> get _database async {
    _db ??= await _abrir();
    return _db!;
  }

  Future<Database> _abrir() async {
    final ruta = join(await getDatabasesPath(), _nombreArchivo);
    return openDatabase(
      ruta,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
CREATE TABLE $_tabla (
  id INTEGER PRIMARY KEY,
  nombre TEXT NOT NULL,
  ingredientes TEXT NOT NULL,
  instrucciones TEXT NOT NULL,
  tiempoPreparacion INTEGER NOT NULL,
  tiempoCoccion INTEGER NOT NULL,
  porciones INTEGER NOT NULL,
  calorias INTEGER NOT NULL,
  imagenUrl TEXT NOT NULL,
  calificacion REAL NOT NULL,
  cocina TEXT NOT NULL,
  dificultad TEXT NOT NULL,
  resena TEXT DEFAULT ''
)
''');
      },
    );
  }

  // Ahora si la receta ya existe, la sobreescribe (útil para actualizar reseñas)
  Future<int> insert(Receta receta) async {
    final db = await _database;
    return db.insert(
      _tabla, 
      receta.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Receta>> obtenerTodas() async {
    final db = await _database;
    final filas = await db.query(_tabla, orderBy: 'id DESC');
    return filas.map(Receta.fromMap).toList();
  }

  Future<int> actualizar(Receta receta) async {
    final db = await _database;
    return db.update(
      _tabla,
      receta.toMap(),
      where: 'id = ?',
      whereArgs: [receta.id],
    );
  }

  Future<int> eliminar(int id) async {
    final db = await _database;
    return db.delete(_tabla, where: 'id = ?', whereArgs: [id]);
  }
}