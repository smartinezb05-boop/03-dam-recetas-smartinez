class Receta {
  // 1. AQUI FALTABA DECLARAR LAS VARIABLES (ESTO CAUSABA CASI TODOS LOS ERRORES)
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

  // 2. EL CONSTRUCTOR (Añadí id, cocina y dificultad)
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

  // 3. EL FACTORY
  factory Receta.fromJson(Map<String, dynamic> json) {
    return Receta(
      id: json['id'],
      nombre: json['name'],
      ingredientes: List<String>.from(json['ingredients']),
      instrucciones: List<String>.from(json['instructions']),
      tiempoPreparacion: json['prepTimeMinutes'],
      tiempoCoccion: json['cookMinutes'],
      porciones: json['servings'],
      calorias: json['caloriesPerServing'],
      imagenUrl: json['image'],
      calificacion: (json['rating'] as num).toDouble(),
      cocina: json['cuisine'] ?? 'Sin especificar', // Agregado para que no falle tu Card
      dificultad: json['difficulty'] ?? 'Media',    // Agregado para que no falle tu Card
    ); 
  }

  int get tiempoTotal => tiempoPreparacion + tiempoCoccion;
}