import 'dart:async';
import 'dart:math';
import 'package:cajero_automatico/src/controllers/cuenta.dart';
import 'package:cajero_automatico/src/models/cuenta.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CajeroController extends GetxController {
  RxString text = ''.obs;
  final int maxLengthNequi = 10;
  final int maxLengthBancolombia = 11;
  RxInt index = 1.obs;
  TipoCuenta? tipoCuentaSeleccionado;
  Cuenta? cuentaValida;
  final List<Cuenta> cuentas = Get.find<CuentaController>().cuentas;
  RxDouble monto = 0.0.obs;
  RxString codigoTemporal = ''.obs;
  double saldoCajero = 0;
  List<double> billetesDisponibles = [0, 0, 0, 0];
  List<double> cantidadBilletes = [0, 0, 0, 0];
  List<double> billetes = [10000, 20000, 50000, 100000];
  Timer? _timeoutTimer;

  CajeroController() {
    inicializarCajero();
  }

  void inicializarCajero() {
    for (int i = 0; i < 4; i++) {
      billetesDisponibles[i] = 100;
      saldoCajero += billetesDisponibles[i] * billetes[i];
    }
    print('Saldo en el cajero: $saldoCajero');
  }

  String generarMensajeBilletesRetirados() {
    StringBuffer sb = StringBuffer();
    for (int i = 0; i < 4; i++) {
      if (cantidadBilletes[i] > 0) {
        sb.writeln(
            '\$${billetes[i].toStringAsFixed(0)} = ${cantidadBilletes[i]}');
      }
    }
    return sb.toString();
  }

  void realizarRetiro(double monto) {
    for (int i = 0; i < cantidadBilletes.length; i++) {
      cantidadBilletes[i] = 0;
    }

    double suma = 0;
    while (suma < monto) {
      for (var i = 0; i < 4; i++) {
        for (var j = i; j < 4; j++) {
          if (suma + billetes[j] <= monto && billetesDisponibles[j] > 0) {
            suma += billetes[j];
            cantidadBilletes[j]++;
            billetesDisponibles[j]--;
            if (suma == monto) break;
          }
        }
      }
    }
    String mensajeBilletes = generarMensajeBilletesRetirados();

    Get.snackbar(
      'Retirando',
      'Monto: $getMontoFormateado\n\nBilletes:\n$mensajeBilletes',
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 8),
    );
  }

  void updateText(String number) {
    int maxLength = tipoCuentaSeleccionado == TipoCuenta.nequi
        ? maxLengthNequi
        : maxLengthBancolombia;

    if (text.value.length < maxLength) {
      text.value += number;
    } else {
      showAlert('Número máximo de dígitos alcanzado');
    }
  }

  String get formattedNumeroCuenta {
    if (cuentaValida == null) return 'No disponible';
    String numeroCuenta = cuentaValida!.numeroCuenta;

    if (tipoCuentaSeleccionado == TipoCuenta.nequi &&
        numeroCuenta.startsWith('0')) {
      return numeroCuenta.substring(1);
    }

    return numeroCuenta;
  }

  void clearText() {
    text.value = '';
  }

  void cancel() {
    text.value = '';
    monto.value = 0;
    index.value = 1;
    showAlert('Acción Cancelada');
    _resetTimeout();
  }

  void deleteOne() {
    if (text.isNotEmpty) {
      text.value = text.value.substring(0, text.value.length - 1);
    }
  }

  void delete() {
    if (text.isNotEmpty) {
      text.value = '';
    }
  }

  void send() {
    _resetTimeout();
    switch (index.value) {
      case 1:
        if (text.isNotEmpty) {
          index.value = 2;
          text.value = '';
        }
        break;
      case 2:
        if (text.isNotEmpty) {
          String numeroCuenta = text.value;

          if (tipoCuentaSeleccionado == TipoCuenta.nequi) {
            if (!numeroCuenta.startsWith('3') ||
                numeroCuenta.length != maxLengthNequi) {
              Get.snackbar('Número incorrecto',
                  'El número de cuenta para Nequi debe comenzar con 3 y tener 10 dígitos.');
              return;
            }
            numeroCuenta = '0$numeroCuenta';
          } else if (tipoCuentaSeleccionado == TipoCuenta.bancolombia) {
            if (numeroCuenta.isEmpty ||
                !numeroCuenta.startsWith(RegExp(r'[1-9]')) ||
                numeroCuenta.length != maxLengthBancolombia) {
              Get.snackbar('Número incorrecto',
                  'El número de cuenta para Bancolombia debe comenzar con un dígito del 1 al 9 y tener 11 dígitos.');
              return;
            }
          }

          cuentaValida = cuentas.firstWhereOrNull(
            (cuenta) =>
                cuenta.tipo == tipoCuentaSeleccionado &&
                cuenta.numeroCuenta == numeroCuenta,
          );

          if (cuentaValida != null) {
            index.value = 3;
            text.value = '';
          } else {
            Get.snackbar('Cuenta incorrecta',
                'La cuenta ha sido incorrecta\nVerifica el tipo y el número de cuenta.');
          }
        }
        break;
      case 3:
        final montoIngresado = double.tryParse(text.value);
        if (montoIngresado == null ||
            montoIngresado < 10000 ||
            montoIngresado > 600000 ||
            montoIngresado % 10000 != 0) {
          showAlert(
            'Monto inválido. Debe ser múltiplo de 10,000 y estar entre 10,000 y 600,000.',
          );
        } else {
          monto.value = montoIngresado;
          index.value = 5;
          text.value = '';
        }
        break;
      case 4:
        final montoIngresado = double.tryParse(text.value);
        if (montoIngresado == null ||
            montoIngresado < 10000 ||
            montoIngresado > 600000 ||
            montoIngresado % 10000 != 0) {
          showAlert(
            'Monto inválido. Debe ser múltiplo de 10,000 y estar entre 10,000 y 600,000.',
          );
        } else {
          monto.value = montoIngresado;
          index.value = 5;
          text.value = '';
        }
        break;
      case 5:
        index.value = 6;
        text.value = '';
        if (tipoCuentaSeleccionado == TipoCuenta.nequi) {
          final random = Random();
          int codigo = random.nextInt(900000) + 100000;
          String generatedCode = 'CODE-${codigo}';
          cuentaValida?.code = codigo.toString();
          codigoTemporal.value = codigo.toString();
          update();

          Get.snackbar(
            'Código Generado',
            'Código: $generatedCode',
            snackPosition: SnackPosition.TOP,
            duration: const Duration(seconds: 8),
          );
        }
        break;
      case 6:
        if (tipoCuentaSeleccionado == TipoCuenta.nequi) {
          if (text.value == cuentaValida?.code &&
              monto <= cuentaValida!.saldo &&
              monto <= saldoCajero) {
            realizarRetiro(monto.value);
            cuentaValida?.saldo -= monto.value;
            cuentaValida?.code = null;
            update();
            index.value = 7;
          } else if (text.value != cuentaValida?.code) {
            Get.snackbar(
                'Código Incorrecto', 'El código ingresado es incorrecto.');
          } else if (monto >= cuentaValida!.saldo  &&  cuentaValida!.saldo!=0) {
            Get.snackbar('Saldo insuficiente',
                'Su retiro no puede ser mayor a su saldo que es ${cuentaValida!.saldo}',
                duration: const Duration(seconds: 3));
            index.value = 3;
          } else if (monto > saldoCajero) {
            Get.snackbar('Saldo insuficiente cajero',
                'Lo siento, no puede retirar ese monto solo tenemos ${saldoCajero}',
                duration: const Duration(seconds: 8));
            index.value = 3;
          }else if(cuentaValida!.saldo==0){
            Get.snackbar('Saldo insuficiente',
                'su cuenta no tiene saldo',
                duration: const Duration(seconds: 3));

            index.value = 1;

          }
        } else if (tipoCuentaSeleccionado == TipoCuenta.bancolombia) {
          if (text.value == cuentaValida?.clave &&
              monto <= cuentaValida!.saldo &&
              monto <= saldoCajero) {
            realizarRetiro(monto.value);
            cuentaValida?.saldo -= monto.value;
            update();
            index.value = 7;
          } else if (text.value != cuentaValida?.clave) {
            Get.snackbar(
                'Clave incorrecta', 'La clave ingresada es incorrecta.');
          } else if (monto >= cuentaValida!.saldo) {
            Get.snackbar('Saldo insuficiente',
                'Su retiro no puede ser mayor a su saldo que es ${cuentaValida!.saldo}',
                duration: const Duration(seconds: 3));
            index.value = 3;
          } else if (monto > saldoCajero) {
            Get.snackbar('Saldo insuficiente cajero',
                'Lo siento, no puede retirar ese monto solo tenemos ${saldoCajero}',
                duration: const Duration(seconds: 6));
            index.value = 3;
          }
        }
        text.value = '';
        break;
      case 7:
        index.value = 8;
        Get.snackbar(
          'Gracias por usar nuestros servicios',
          'Retiro exitoso',
          duration: const Duration(seconds: 3),
        );
        break;
      case 8:
        index.value = 1;
        text.value = '';
        tipoCuentaSeleccionado = null;
        cuentaValida = null;
        break;
    }
  }

  String get getMontoFormateado {
    final formatter =
        NumberFormat.currency(locale: 'es_CO', decimalDigits: 0, symbol: '\$');
    return formatter.format(monto.value);
  }

  void showAlert(String message) {
    Get.snackbar(
      'Advertencia',
      message,
      snackPosition: SnackPosition.TOP,
      duration: const Duration(seconds: 8),
    );
  }

  void _startTimeout() {
    _timeoutTimer?.cancel();
    _timeoutTimer = Timer(const Duration(seconds: 15), () {
      if (index.value != 1) {
        Get.snackbar('Operación Finalizada',
            'La operación ha sido finalizada por inactividad.');
        index.value = 1;
        text.value = '';
      }
    });
  }

  void _resetTimeout() {
    _startTimeout();
  }
}
