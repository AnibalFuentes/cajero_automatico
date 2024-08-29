import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // Importar el paquete intl
import 'package:get/get.dart';
import 'package:cajero_automatico/src/controllers/cajero.dart';
import 'package:cajero_automatico/src/models/cuenta.dart';

class Cajero extends StatelessWidget {
  final CajeroController controller = Get.put(CajeroController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cajero Automático'),
        backgroundColor: Colors.blueAccent,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          double wScreen = constraints.maxWidth;
          double hScreen = constraints.maxHeight;

          return Center(
            child: Column(
              children: [
                Expanded(
                  flex: 2,
                  child: Container(
                    margin: const EdgeInsets.only(top: 16.0),
                    width: wScreen > 600 ? wScreen * 0.5 : wScreen * 0.8,
                    height: hScreen * 0.1,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade900,
                    ),
                    child: Obx(() => _buildScreen()),
                  ),
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildNumberPad(wScreen),
                      const SizedBox(width: 20),
                      botonesControl(),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildScreen() {
    switch (controller.index.value) {
      case 1:
        return seleccionarCuenta();
      case 2:
        return numeroCuenta();
      case 3:
        return seleccionarMonto();
      case 4:
        return ingresarOtroMonto();
      case 5:
        return verificarInfo();
      case 6:
        return codigoClave();
      case 7:
        return recibo();
      case 8:
        return ultimo();
      default:
        return Container();
    }
  }

  Widget codigoClave() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Ingrese ${controller.tipoCuentaSeleccionado == TipoCuenta.nequi ? 'el Codigo generado' : 'La clave de su cuenta Bancolombia'}',
          textAlign: TextAlign.center,
          style: const TextStyle(
            color: Color.fromARGB(255, 235, 205, 205),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () => TextFormField(
              controller: TextEditingController(text: controller.text.value),
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget ultimo() {
    return const Center(
      child: Text(
        'OPERACION FINALIZADA',
        style: TextStyle(fontSize: 24, color: Colors.white),
      ),
    );
  }

  Widget recibo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('RECIBO:\n'),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'N° de cuenta:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.formattedNumeroCuenta,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tipo de cuenta:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.cuentaValida?.tipo.name ?? 'No disponible',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Total Retirado:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '\$${NumberFormat('#,###').format(controller.monto.value)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Saldo:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '\$${NumberFormat('#,###').format(controller.cuentaValida?.saldo ?? 0)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
          Image.asset(
            'money.png',
            width: 50,
          )
        ],
      ),
    );
  }

  Widget verificarInfo() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'N° de cuenta:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.formattedNumeroCuenta,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 30),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Tipo de cuenta:',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.cuentaValida?.tipo.name ?? 'No disponible',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          const Text(
            'Monto a Retirar:',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '\$${NumberFormat('#,###').format(controller.monto.value)}',
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
            ),
          ),
        ],
      ),
    );
  }

  Widget seleccionarCuenta() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Image.asset(
          'logo.png',
          width: 100,
        ),
        const Text(
          'Bienvenido\nSeleccione una cuenta',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromARGB(255, 235, 205, 205),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            GestureDetector(
              onTap: () {
                controller.tipoCuentaSeleccionado = TipoCuenta.nequi;
                controller.index.value = 2;
                controller.text.value = '';
              },
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Nequi'),
              ),
            ),
            GestureDetector(
              onTap: () {
                controller.tipoCuentaSeleccionado = TipoCuenta.bancolombia;
                controller.index.value = 2;
                controller.text.value = '';
              },
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text('Bancolombia'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget numeroCuenta() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Ingrese número de cuenta',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromARGB(255, 235, 205, 205),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () => TextFormField(
              controller: TextEditingController(text: controller.text.value),
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingrese número de cuenta',
              ),
              style: const TextStyle(fontSize: 18, color: Colors.white),
            ),
          ),
        ),
      ],
    );
  }

  Widget seleccionarMonto() {
    final List<double> montos1 = [20000, 100000, 300000, 600000];
    final List<double> montos2 = [50000, 200000, 500000];

    return Column(
      children: [
        const Text(
          'Seleccione el monto a retirar:',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromARGB(255, 235, 205, 205),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Column(
                children:
                    montos1.map((monto) => _buildAmountButton(monto)).toList(),
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                children: [
                  ...montos2.map((monto) => _buildAmountButton(monto)).toList(),
                  GestureDetector(
                    onTap: () {
                      controller.index.value =
                          4; // Ir a la pantalla de ingresar otro monto
                      controller.text.value = '';
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8.0),
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade400,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Center(
                        child: Text(
                          'Otro valor',
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAmountButton(double monto) {
    return GestureDetector(
      onTap: () {
        controller.monto.value = monto; // Guardar el monto seleccionado
        controller.index.value = 5;
      },
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 8.0),
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.grey.shade400,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Center(
          child: Text(
            '\$${NumberFormat('#,###').format(monto)}',
            style: const TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }

  Widget ingresarOtroMonto() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'el valor debe ser multiplo de \$10.000,00\n\n(minimo\$10,000,00 y maximo \$600,000,00) ',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Color.fromARGB(255, 235, 205, 205),
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Obx(
            () => TextFormField(
              controller: TextEditingController(text: controller.text.value),
              keyboardType: TextInputType.number,
              readOnly: true,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Ingrese monto (múltiplos de 10,000)',
              ),
              style: const TextStyle(fontSize: 24, color: Colors.white),
              onChanged: (value) {
                controller.text.value = value;
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNumberPad(double wScreen) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      width: wScreen > 600 ? 200 : wScreen * 0.4,
      height: 300,
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8.0,
          mainAxisSpacing: 8.0,
        ),
        itemCount: 12,
        itemBuilder: (context, index) {
          String buttonText;
          if (index < 9) {
            buttonText = '${index + 1}';
          } else if (index == 9) {
            buttonText = '0';
          } else if (index == 10) {
            buttonText = 'C';
          } else {
            buttonText = '';
          }

          return GestureDetector(
            onTap: () {
              if (controller.index.value != 1 && controller.index.value != 3) {
                if (index < 9) {
                  controller.updateText('$buttonText');
                } else if (index == 9) {
                  controller.updateText('0');
                } else if (index == 10) {
                  controller.clearText();
                }
              }
            },
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Center(
                child: Text(
                  buttonText,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                ),
              ),
            ),
          );
        },
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
      ),
    );
  }

  Widget botonesControl() {
    // Lista de colores para la línea debajo del texto de los botones
    final List<Color> underlineColors = [
      Colors.red, // Rojo para Cancelar
      Colors.yellow, // Amarillo para Corregir
      Colors.yellow, // Amarillo para Borrar
      Colors.green, // Verde para Enviar
    ];

    return Container(
      margin: const EdgeInsets.all(16.0),
      width: 100,
      height: 300,
      child: Column(
        children: List.generate(4, (index) {
          return GestureDetector(
            onTap: () {
              switch (index) {
                case 0:
                  controller.cancel();
                  break;
                case 1:
                  controller.deleteOne();
                  break;
                case 2:
                  controller.delete();
                  break;
                case 3:
                  controller.send();
                  break;
              }
            },
            child: Container(
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.only(bottom: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100, // Relleno gris claro
                border: Border.all(color: Colors.grey), // Bordes grises
                borderRadius: BorderRadius.circular(5),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    ['CANCEL', 'CORRECT', 'DELETE', 'ENTER'][index],
                    style: TextStyle(color: Colors.black), // Color del texto
                  ),
                  const SizedBox(
                      height: 4), // Espacio entre el texto y la línea
                  Container(
                    height: 2, // Altura de la línea
                    color: underlineColors[index], // Color de la línea
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
