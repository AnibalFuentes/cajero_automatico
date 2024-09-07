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
        numeroCuenta: '12345678910',
        clave: '1234',
        tipo: TipoCuenta.bancolombia,
        saldo: 100000),
  ].obs;
}
