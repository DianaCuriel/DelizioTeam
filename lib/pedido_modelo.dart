import 'package:cloud_firestore/cloud_firestore.dart';

class Pedido {
  final String id;
  final String? clienteId;
  final String nombreCliente;
  final List<dynamic> productos;
  final String mensaje;
  final String direccion;
  final String estado;
  final String metodoPago;
  final String formaEntrega;
  final double total;
  final bool cubiertos;
  final String? descripcion;
  final String? imagen;
  final int cantidad;
  final List<dynamic>? salsas;
  final List<dynamic>? extras;
  final String nombreplatillo;
  final double precioUnitario;
  final double subtotal;
  final DateTime fecha;

  Pedido({
    required this.id,
    this.clienteId,
    required this.nombreCliente,
    required this.productos,
    required this.mensaje,
    required this.direccion,
    required this.estado,
    required this.metodoPago,
    required this.formaEntrega,
    required this.total,
    required this.cubiertos,
    this.descripcion,
    this.imagen,
    required this.cantidad,
    this.salsas,
    this.extras,
    required this.nombreplatillo,
    required this.precioUnitario,
    required this.subtotal,
    required this.fecha,
  });

  factory Pedido.fromMap(
    String id,
    Map<String, dynamic> data,
    String nombreCliente,
  ) {
    final productos = data['productos'] as List<dynamic>? ?? [];

    // Definir valores por defecto en caso de lista vacía
    final primerProducto =
        productos.isNotEmpty && productos[0] is Map<String, dynamic>
            ? productos[0] as Map<String, dynamic>
            : {};

    return Pedido(
      id: id,
      nombreCliente: nombreCliente,
      productos: productos,
      mensaje: data['mensaje'] ?? '',
      direccion: data['direccion'] ?? '',
      estado: data['estado'] ?? 'Pendiente',
      metodoPago: data['metodo_pago'] ?? 'efectivo',
      formaEntrega: data['forma_entrega'] ?? 'domicilio',
      total: (data['total'] ?? 0).toDouble(),
      cubiertos: data['cubiertos'] ?? false,
      cantidad:
          (primerProducto['cantidad'] ?? 1) is int
              ? primerProducto['cantidad']
              : int.tryParse(primerProducto['cantidad'].toString()) ?? 1,
      nombreplatillo: primerProducto['nombre'] ?? 'Producto',
      precioUnitario: (primerProducto['precio_unitario'] ?? 0).toDouble(),
      subtotal: (primerProducto['subtotal'] ?? 0).toDouble(),
      salsas: primerProducto['salsas'] as List<dynamic>?,
      extras: primerProducto['extras'] as List<dynamic>?,
      imagen: primerProducto['imagen'] as String?,
      fecha: (data['fecha'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}
