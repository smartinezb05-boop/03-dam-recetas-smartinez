import 'dart:convert'; // Súper importante agregarlo hasta arriba para las listas

class Receta {
  // 1. DECLARACIÓN DE VARIABLES
  final int id;
  final String nombre;
  final List<String> ingredientes;
  final List<String> instrucciones;
  final int tiempoPreparacion;
  final int tiempoCoccion;
  final int porciones;
  final int calorias;
  final String imagenUrl;
  final double calificacion;
  final String cocina;
  final String dificultad;

  // 2. EL CONSTRUCTOR
  const Receta({
    required this.id,
    required this.nombre,
    required this.ingredientes,
    required this.instrucciones,
    required this.tiempoPreparacion,
    required this.tiempoCoccion,
    required this.porciones,
    required this.calorias,
    required this.imagenUrl,
    required this.calificacion,
    required this.cocina,
    required this.dificultad,
  });

  // 3. EL FACTORY PARA LA API (Descargar de internet)
  factory Receta.fromJson(Map<String, dynamic> json) {
    return Receta(
      id: json['id'] ?? 0,
      nombre: json['name'] ?? 'Sin nombre',
      ingredientes: List<String>.from(json['ingredients'] ?? []),
      instrucciones: List<String>.from(json['instructions'] ?? []),
      tiempoPreparacion: json['prepTimeMinutes'] ?? 0,
      tiempoCoccion: json['cookTimeMinutes'] ?? 0, 
      porciones: json['servings'] ?? 0,
      calorias: json['caloriesPerServing'] ?? 0,
      imagenUrl: json['image'] ?? '',
      calificacion: json['rating'] != null ? (json['rating'] as num).toDouble() : 0.0,
      cocina: json['cuisine'] ?? 'Sin especificar',
      dificultad: json['difficulty'] ?? 'Media',
    ); 
  }

  // 4. NUEVO: MÉTODO PARA GUARDAR EN SQLITE
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'nombre': nombre,
      // Convertimos las listas a texto para que SQLite las acepte
      'ingredientes': jsonEncode(ingredientes),
      'instrucciones': jsonEncode(instrucciones),
      'tiempoPreparacion': tiempoPreparacion,
      'tiempoCoccion': tiempoCoccion,
      'porciones': porciones,
      'calorias': calorias,
      'imagenUrl': imagenUrl,
      'calificacion': calificacion,
      'cocina': cocina,
      'dificultad': dificultad,
    };
  }

  // 5. NUEVO: MÉTODO PARA LEER DE SQLITE
  factory Receta.fromMap(Map<String, dynamic> map) {
    return Receta(
      id: map['id'],
      nombre: map['nombre'],
      // Decodificamos el texto de vuelta a listas normales de Dart
      ingredientes: List<String>.from(jsonDecode(map['ingredientes'])),
      instrucciones: List<String>.from(jsonDecode(map['instrucciones'])),
      tiempoPreparacion: map['tiempoPreparacion'],
      tiempoCoccion: map['tiempoCoccion'],
      porciones: map['porciones'],
      calorias: map['calorias'],
      imagenUrl: map['imagenUrl'],
      calificacion: map['calificacion'],
      cocina: map['cocina'],
      dificultad: map['dificultad'],
    );
  }

  int get tiempoTotal => tiempoPreparacion + tiempoCoccion;
}