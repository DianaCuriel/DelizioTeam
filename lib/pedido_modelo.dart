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
    final productos = data['productos'] as List<dynamic>? ?? [];
    final primerProducto =
        productos.isNotEmpty ? productos[0] as Map<String, dynamic> : {};

    return Pedido(
      id: id,
      nombreCliente: nombreCliente,
      productos: productos,
      mensaje: data['mensaje'] ?? '',
      direccion: data['direccion'] ?? '',
      estado: data['estado'] ?? 'Pendiente',
      metodoPago: data['metodo_pago'] ?? 'efectivo',
      total: (data['subtotal'] ?? 0).toDouble(),
      cubiertos: data['cubiertos'] ?? false,
      cantidad: primerProducto['cantidad'] ?? 1,
      nombreplatillo: primerProducto['nombre'] ?? 'Producto',
      precioUnitario: (primerProducto['precio_unitario'] ?? 0).toDouble(),
      subtotal: (primerProducto['subtotal'] ?? 0).toDouble(),
    );
  }
}
