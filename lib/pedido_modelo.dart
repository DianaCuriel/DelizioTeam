class Pedido {
  final String id;
  final String? clienteId;
  final String nombreCliente;
  final List<dynamic> productos;
  final String mensaje;
  final String direccion;
  final String estado;
  final String metodoPago;
  final double total;
  final bool cubiertos;
  final String? descripcion;
  final String? imagen;
  final int cantidad;
  final List<dynamic>? salsas;
  final String nombreplatillo;
  final double precioUnitario;
  final double subtotal;

  Pedido({
    required this.id,
    this.clienteId,
    required this.nombreCliente,
    required this.productos,
    required this.mensaje,
    required this.direccion,
    required this.estado,
    required this.metodoPago,
    required this.total,
    required this.cubiertos,
    this.descripcion,
    this.imagen,
    required this.cantidad,
    this.salsas,
    required this.nombreplatillo,
    required this.precioUnitario,
    required this.subtotal,
  });

  factory Pedido.fromMap(
    String id,
    Map<String, dynamic> data,
    String nombreCliente,
  ) {
    return Pedido(
      id: id,
      nombreCliente: nombreCliente,
      productos: data['productos'] ?? [],
      mensaje: data['mensaje'] ?? '',
      direccion: data['direccion'] ?? '',
      estado: data['estado'] ?? 'Pendiente',
      metodoPago: data['metodo_pago'] ?? 'efectivo',
      total: (data['subtotal'] ?? 0).toDouble(),
      cubiertos: data['cubiertos'] ?? false,
      cantidad: data['cantidad'] ?? 1,
      nombreplatillo: data['nombre'] ?? 'Producto',
      precioUnitario: (data['precio_unitario'] ?? 0).toDouble(),
      subtotal: (data['subtotal'] ?? 0).toDouble(),
    );
  }
}
