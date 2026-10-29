import 'dart:async';
import 'package:flutter/material.dart';
import 'package:recetas_app/screens/home_screen.dart';

class SplashScreen extends StatefulWidget{
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() =>_SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>{
  @override
  void initState() {
    super.initState();
    Timer(const Duration(milliseconds: 2200),(){
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context)=> const HomeScreen()),
      );
    }); // Timer
  }

  // AQUÍ ES DONDE VA EL MÉTODO BUILD, DENTRO DE LA CLASE STATE
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 127, 1, 133),
      body: Center( // Agregué un Center para que la Column quede exactamente en medio
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.restaurant, color: Colors.white, size: 90,),
            const SizedBox(height: 16,),
            const Text("Recetas App", style: TextStyle(color: Colors.white, fontSize: 28),),
            const SizedBox(height: 24,),
            const CircularProgressIndicator(color: Colors.white,)
          ],
        ), // Column
      ), // Center
    ); // Scaffold
  }
}