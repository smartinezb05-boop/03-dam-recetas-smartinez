import 'package:flutter/material.dart';
import 'package:recetas_app/models/receta.dart';
import 'package:recetas_app/services/recipe_service.dart';
import 'package:recetas_app/widgets/receta_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RecipeService _recipeService = RecipeService();
  final TextEditingController _buscadorController = TextEditingController();
  late Future<List<Receta>> _futureRecetas;
  List<Receta> _todasLasRecetas = [];
  List<Receta> _recetasFiltradas = [];

  @override
  void initState() {
    super.initState();
    _futureRecetas = _recipeService.obtenerRecetas();
  }

  void _filtrarRecetas(String texto){
    setState((){
      _recetasFiltradas = _todasLasRecetas.where((receta) {
        return receta.nombre.toLowerCase().contains(texto.toLowerCase());
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RecetasApp'),
        backgroundColor: const Color.fromARGB(255, 216, 119, 84),
      ), // AppBar
      body: FutureBuilder<List<Receta>>(
        future: _futureRecetas,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          final recetas = snapshot.data!;
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: recetas.length,
            itemBuilder: (context, index) {
              return RecetaCard(receta: recetas[index]);
            },
          ); // ListView.builder
        },
      ), // FutureBuilder
    ); // Scaffold
  }
}