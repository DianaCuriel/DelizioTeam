class Pedido {
  final int id;
  final String nombre;
  final int cubiertos;
  final double precio;
  final String tipoPago;
  final String nombreplatillo;
  final int cantidad;
  final String salsas;
  final String descripcion;
  final String imagen;
  String estado;

  Pedido({
    required this.id,
    required this.nombre,
    required this.cubiertos,
    required this.precio,
    required this.tipoPago,
    required this.nombreplatillo,
    required this.cantidad,
    required this.salsas,
    required this.descripcion,
    required this.imagen,
    required this.estado,
  });
}
