import 'package:cajero_automatico/src/components/splass_screen.dart';
import 'package:cajero_automatico/src/controllers/cuenta.dart';
import 'package:cajero_automatico/src/screens/cajero.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/get_instance.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

void main() {
  Get.put(CuentaController());
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BANK',
      theme: ThemeData(primarySwatch: Colors.blue),
      routes: {
        '/': (context) => SplashScreen(
              child: Cajero(),
            ),
      },
    );
  }
}
