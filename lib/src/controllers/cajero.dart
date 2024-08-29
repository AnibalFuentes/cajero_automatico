import 'dart:math';

import 'package:cajero_automatico/src/controllers/cuenta.dart';
import 'package:cajero_automatico/src/models/cuenta.dart';
import 'package:cajero_automatico/src/screens/cajero.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CajeroController extends GetxController {
  RxString text = ''.obs;
  final int maxLengthNequi = 10; // Longitud máxima para Nequi
  final int maxLengthBancolombia = 11; // Longitud máxima para Bancolombia
  RxInt index = 1.obs;
  TipoCuenta? tipoCuentaSeleccionado; // Cambiado a TipoCuenta
  Cuenta? cuentaValida; // Para almacenar la cuenta válida
  final List<Cuenta> cuentas = Get.find<CuentaController>().cuentas;
  RxDouble monto = 0.0.obs; // Para almacenar el monto seleccionado o ingresado
  RxString codigoTemporal = ''.obs; // Para almacenar el código temporal
  double saldoCajero = 0;

  List<double> billetesDisponibles = [0, 0, 0, 0];
  List<double> cantidadBilletes = [0, 0, 0, 0];
  List<double> billetes = [10000, 20000, 50000, 100000];
  CajeroController() {
    inicializarCajero();
  }

  void inicializarCajero() {
    for (int i = 0; i < 4; i++) {
      billetesDisponibles[i] = 100; // Cantidad inicial de cada billete
      saldoCajero +=
          billetesDisponibles[i] * billetes[i]; // Calcular el saldo total
    }
    print('Saldo en el cajero: $saldoCajero'); // Muestra el saldo en consola
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
            if (suma == monto) {
              break;
            } // Salir del ciclo
          }
        }
      }
    }
    imprimirBilletesRetirados();
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

    // Verificar si es una cuenta de Nequi y tiene un 0 al principio
    if (tipoCuentaSeleccionado == TipoCuenta.nequi &&
        numeroCuenta.startsWith('0')) {
      return numeroCuenta.substring(1); // Eliminar el 0 al mostrar
    }

    return numeroCuenta;
  }

  void clearText() {
    text.value = '';
  }

  void cancel() {
    text.value = '';
    monto.value = 0;
    index.value = 1; // Regresar a la pantalla inicial
    showAlert('Acción Cancelada');
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
    switch (index.value) {
      case 1:
        if (text.isNotEmpty) {
          index.value = 2; // Cambiar a la pantalla de número de cuenta
          text.value = '';
        }
        break;
      case 2:
        if (text.isNotEmpty) {
          String numeroCuenta = text.value;

          // Validar el formato del número de cuenta según el tipo de cuenta
          if (tipoCuentaSeleccionado == TipoCuenta.nequi) {
            if (!numeroCuenta.startsWith('3') ||
                numeroCuenta.length != maxLengthNequi) {
              Get.snackbar('Número incorrecto',
                  'El número de cuenta para Nequi debe comenzar con 3 y tener 10 dígitos.');
              return;
            }
            numeroCuenta =
                '0$numeroCuenta'; // Agregar un 0 al inicio si es Nequi
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
            index.value = 3; // Cambiar a la pantalla de selección de monto
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
          monto.value = montoIngresado; // Guardar el monto ingresado
          index.value = 5; // Cambiar a la pantalla de ingreso de código o clave
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
          monto.value = montoIngresado; // Guardar el monto ingresado
          index.value = 5; // Cambiar a la pantalla de ingreso de código o clave
          text.value = '';
        }
        // Generar un código para cuentas Nequi

        break;
      case 5:
        index.value =
            6; // Cambiar a la pantalla de validación de código o clave
        text.value = '';
        if (tipoCuentaSeleccionado == TipoCuenta.nequi) {
          final random = Random();
          int codigo = random.nextInt(900000) + 100000;
          String generatedCode = 'CODE-${codigo}';
          cuentaValida?.code = codigo.toString();
          codigoTemporal.value = codigo.toString();
          update(); // Actualiza los datos en el controlador

          Get.snackbar(
            'Código Generado',
            'Código: $generatedCode',
            snackPosition: SnackPosition.TOP,
            duration: Duration(seconds: 8),
          );
        }
        break;
      case 6:
        if (tipoCuentaSeleccionado == TipoCuenta.nequi) {
          if (text.value == cuentaValida?.code &&
              monto <= cuentaValida!.saldo &&
              monto <= saldoCajero) {
            Get.snackbar('Código Validado', 'Retirando');
            realizarRetiro(monto.value);
            cuentaValida?.saldo -= monto.value;

            // Realizar la acción deseada
            cuentaValida?.code = null;
            // Invalidate the code after use
            update(); // Update the controller
            index.value = 7;
          } else if (text.value != cuentaValida?.code) {
            Get.snackbar(
                'Código Incorrecto', 'El código ingresado es incorrecto.');
            cuentaValida?.code = null;
            index.value = 1;
          } else if (monto >= cuentaValida!.saldo) {
            Get.snackbar('Saldo insuficiente',
                'Su retiro no puede ser mayor a su saldo que es ${cuentaValida!.saldo}',
                duration: Duration(seconds: 8));
            index.value = 3;
          } else if (monto > saldoCajero) {
            Get.snackbar('Saldo insuficiente cajero',
                'Lo siento, no puede retirar ese monto solo tenemos ${saldoCajero}',
                duration: Duration(seconds: 8));
            index.value = 3;
          }
        } else if (tipoCuentaSeleccionado == TipoCuenta.bancolombia) {
          // Validar clave para Bancolombia
          if (text.value == cuentaValida?.clave &&
              monto <= cuentaValida!.saldo &&
              monto <= saldoCajero) {
            Get.snackbar('Info Cajero', 'Retirando....');
            realizarRetiro(monto.value);

            cuentaValida?.saldo -= monto.value;
            update();
            index.value = 7;
          } else if (text.value != cuentaValida?.clave) {
            Get.snackbar(
                'clave incorecta', 'la clave ingresada es incorrecto.');
          } else if (monto > cuentaValida!.saldo) {
            Get.snackbar('Saldo insuficiente',
                'Su retiro no puede ser mayor a su saldo que es ${cuentaValida!.saldo}',
                duration: Duration(seconds: 8));
            index.value = 3;
          } else if (monto > saldoCajero) {
            Get.snackbar('Saldo insuficiente cajero',
                'Lo siento, no puede retirar ese monto solo tenemos ${saldoCajero}',
                duration: Duration(seconds: 6));
            index.value = 3;
          }
        }
        text.value = '';
        break;
      case 7:
        index.value = 8;

        break;
      case 8:
        index.value = 1;
        break;

      default:
        break;
    }
  }

  void imprimirBilletesRetirados() {
    for (int i = 0; i < 4; i++) {
      if (cantidadBilletes[i] > 0) {
        // ignore: avoid_print
        print(
          'Billetes de \$${billetes[i].toInt()}: ${cantidadBilletes[i].toInt()} = ${(billetes[i] * cantidadBilletes[i]).toInt()}',
        );
      }
    }
  }

  String formatMonto(String monto) {
    try {
      // Elimina caracteres no numéricos
      final cleanText = monto.replaceAll(RegExp(r'[^\d]'), '');
      final number = int.parse(cleanText);
      return NumberFormat('#,###').format(number);
    } catch (e) {
      return monto; // Si ocurre un error, devuelve el texto original
    }
  }

  void showAlert(String message) {
    Get.dialog(
      AlertDialog(
        title: const Text('Advertencia'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
