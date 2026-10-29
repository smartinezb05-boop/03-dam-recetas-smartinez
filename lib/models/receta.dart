import 'package:flutter/material.dart';

class Receta {
  const Receta({
    required this.nombre,
    required this.ingredientes,
    required this.instrucciones,
    required this.tiempoPreparacion,
    required this.tiempoCoccion,
    required this.porciones,
    required this.calorias,
    required this.imagenUrl,
    required this.calificacion,
  });

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
    ); // Receta
  }

  int get tiempoTotal => tiempoPreparacion + tiempoCoccion;
}