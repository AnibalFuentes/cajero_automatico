import 'package:cajero_automatico/src/models/cuenta.dart';
import 'package:get/get.dart';

class CuentaController extends GetxController {
  var cuentas = <Cuenta>[
    Cuenta(
        numeroCuenta: '03007716244',
        code: '',
        tipo: TipoCuenta.nequi,
        saldo: 600000),
    Cuenta(
        numeroCuenta: '30077162444',
        clave: '1234',
        tipo: TipoCuenta.bancolombia,
        saldo: 100000),
  ].obs;

  void generateCode(int index) {
    // Aquí se genera el código
    String generatedCode = 'CODE-${DateTime.now().millisecondsSinceEpoch}';
    cuentas[index].code = generatedCode;
    update(); // Actualiza los datos en el controlador
    Get.snackbar(
      'Código Generado',
      'Código: $generatedCode',
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  void performOperation(int index) {
    // Aquí puedes implementar la lógica de la operación
    // ...

    // Luego de completar la operación, se anula el código
    cuentas[index].code = null;
    update(); // Actualiza los datos en el controlador
    Get.snackbar(
      'Operación Completa',
      'El código ha sido anulado.',
      snackPosition: SnackPosition.BOTTOM,
    );
  }
}
