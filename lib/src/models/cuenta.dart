enum TipoCuenta { nequi, bancolombia }

class Cuenta {
  final String numeroCuenta;
  final String? clave;
  final TipoCuenta tipo; 
   double saldo;
  String? code; // El código temporal, puede ser null cuando no esté activo

  Cuenta({
    required this.numeroCuenta,
     this.clave,
    required this.tipo,
    required this.saldo,
    this.code,
  });
}
