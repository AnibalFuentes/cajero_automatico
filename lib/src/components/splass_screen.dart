import 'package:flutter/material.dart';

class SplashScreen extends StatefulWidget {
  final Widget? child;

  const SplashScreen({super.key, this.child});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 3), () {
      if (widget.child != null) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (context) => widget.child!),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 4, 24, 41),
      body: Center(
        child: Container(
          width: 170,
          height: 200,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), // Borde redondeado
            color: Colors.white.withOpacity(0.8), // Color de fondo más claro
          ),
          child: Center(
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20), // Bordes redondeados
                color: Colors.blueGrey[100], // Color de fondo del contenedor
              ),
              child: Image.asset(
                'logo.png', // Asegúrate de que la ruta sea correcta
                width: 130,
                height: 130,
                fit: BoxFit.contain,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
