import 'package:flutter/material.dart';
import 'package:recetas_app/models/receta.dart';
import 'package:recetas_app/data/recetas_db.dart'; // Importamos la BD

class DetalleRecetaScreen extends StatefulWidget {
  final Receta receta;

  const DetalleRecetaScreen({super.key, required this.receta});

  @override
  State<DetalleRecetaScreen> createState() => _DetalleRecetaScreenState();
}

class _DetalleRecetaScreenState extends State<DetalleRecetaScreen> {
  final TextEditingController _resenaController = TextEditingController();
  late Receta _recetaActual;

  @override
  void initState() {
    super.initState();
    // Cargamos la receta en el estado y pre-llenamos la reseña si ya tenía una
    _recetaActual = widget.receta;
    _resenaController.text = _recetaActual.resena;
  }

  @override
  void dispose() {
    _resenaController.dispose();
    super.dispose();
  }

  // MÉTODO CONECTADO A LA BD
  void _enviarResena() async {
    final textoResena = _resenaController.text;
    if (textoResena.isNotEmpty) {
      // 1. Creamos una copia de la receta con la nueva reseña
      final recetaActualizada = _recetaActual.copyWith(resena: textoResena);

      // 2. La guardamos fisicamente en la base de datos local
      await RecetasDb.instancia.insert(recetaActualizada);

      // 3. Actualizamos la pantalla visualmente
      setState(() {
        _recetaActual = recetaActualizada;
      });
      
      // 4. Confirmación
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('¡Reseña guardada en la base de datos! 💾')),
      );
      FocusScope.of(context).unfocus();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Usamos _recetaActual en lugar de widget.receta para que la pantalla reaccione
    final receta = _recetaActual;
    
    return Scaffold(
      appBar: AppBar(title: const Text("Detalle de la receta")),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(14),
            child: Image.network(
              receta.imagenUrl,
              height: 200,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) => Image.asset(
                "assets/images/plato-placeholder.jpg",
                height: 200,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            children: [
              Chip(label: Text('${receta.tiempoTotal} min')),
              Chip(label: Text(receta.dificultad)),
              Chip(label: Text(receta.cocina)),
              Chip(label: Text('${receta.calorias} kcal')),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            "Ingredientes: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...receta.ingredientes.map(
            (ingrediente) => Padding(
              padding: const EdgeInsets.symmetric(vertical: 3),
              child: Row(
                children: [
                  const Icon(Icons.circle, size: 6, color: Colors.orange),
                  const SizedBox(width: 8),
                  Expanded(child: Text(ingrediente)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            "Preparación: ",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          ...receta.instrucciones.asMap().entries.map(
                (entrada) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.deepOrange,
                        child: Text(
                          '${entrada.key + 1}',
                          style: const TextStyle(color: Colors.white, fontSize: 11),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(child: Text(entrada.value)),
                    ],
                  ),
                ),
              ),
          
          const SizedBox(height: 30),
          const Divider(),
          const SizedBox(height: 10),
          
          // Muestra la reseña actual si ya existe
          if (receta.resena.isNotEmpty) ...[
            const Text(
              "Tu reseña actual:",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Colors.deepOrange),
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.orange.shade200),
              ),
              child: Text(
                receta.resena,
                style: const TextStyle(fontSize: 15, fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 20),
          ],

          Text(
            receta.resena.isEmpty ? "Deja tu reseña:" : "Actualizar reseña:",
            style: const TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: _resenaController,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: '¿Qué te pareció este platillo?',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              filled: true,
              fillColor: Colors.grey.shade100,
            ),
          ),
          const SizedBox(height: 12),
          Align(
            alignment: Alignment.centerRight,
            child: ElevatedButton.icon(
              onPressed: _enviarResena,
              icon: const Icon(Icons.save),
              label: Text(receta.resena.isEmpty ? 'Guardar Reseña' : 'Actualizar Reseña'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepOrange,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}