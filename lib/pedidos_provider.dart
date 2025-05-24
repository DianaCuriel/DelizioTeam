import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'pedido_modelo.dart';

class PedidoProvider with ChangeNotifier {
  List<Pedido> _pedidos = [];
  String? _nombreRestaurante;

  List<Pedido> get pedidos => _pedidos;

  Future<void> cargarPedidosPorNegocio(String nombreRestaurante) async {
    _nombreRestaurante = nombreRestaurante;
    final snapshot =
        await FirebaseFirestore.instance
            .collection('compras')
            .where('negocio', isEqualTo: nombreRestaurante)
            .get();

    _pedidos = await _procesarPedidos(snapshot.docs);
    notifyListeners();
  }

  Future<List<Pedido>> _procesarPedidos(
    List<QueryDocumentSnapshot> docs,
  ) async {
    List<Pedido> pedidos = [];
    for (var doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final usuarioId = data['usuario_id'] ?? '';
      String nombreCliente = 'Sin nombre';

      // Obtener el nombre del usuario desde la colección usuarios
      if (usuarioId.isNotEmpty) {
        try {
          final userDoc =
              await FirebaseFirestore.instance
                  .collection('USUARIOS')
                  .doc(usuarioId)
                  .get();
          if (userDoc.exists) {
            nombreCliente = userDoc.data()?['NOMBRE'] ?? 'Sin nombre';
          }
        } catch (e) {
          print('Error al obtener nombre de usuario: $e');
        }
      }

      pedidos.add(Pedido.fromMap(doc.id, data, nombreCliente));
    }
    return pedidos;
  }

  Stream<List<Pedido>> escucharPedidosPorNegocio(String nombreRestaurante) {
    return FirebaseFirestore.instance
        .collection('compras')
        .where('negocio', isEqualTo: nombreRestaurante)
        .snapshots()
        .asyncMap((snapshot) => _procesarPedidos(snapshot.docs));
  }

  List<Pedido> pedidosPorEstado(String estado) {
    return _pedidos.where((pedido) => pedido.estado == estado).toList();
  }

  Future<void> cambiarEstado(String pedidoId, String nuevoEstado) async {
    await FirebaseFirestore.instance.collection('compras').doc(pedidoId).update(
      {'estado': nuevoEstado},
    );

    final index = _pedidos.indexWhere((p) => p.id == pedidoId);
    if (index != -1) {
      _pedidos[index] = _pedidos[index].copyWith(estado: nuevoEstado);
      notifyListeners();
    }
  }

  Future<void> eliminarPedido(String pedidoId) async {
    await FirebaseFirestore.instance
        .collection('compras')
        .doc(pedidoId)
        .delete();
    _pedidos.removeWhere((pedido) => pedido.id == pedidoId);
    notifyListeners();
  }
}

extension PedidoCopyWith on Pedido {
  Pedido copyWith({String? estado}) {
    return Pedido(
      id: id,
      nombreCliente: nombreCliente,
      productos: productos,
      mensaje: mensaje,
      direccion: direccion,
      estado: estado ?? this.estado,
      metodoPago: metodoPago,
      total: total,
      cubiertos: cubiertos,
      cantidad: cantidad,
      nombreplatillo: nombreplatillo,
      precioUnitario: precioUnitario,
      subtotal: subtotal,
    );
  }
}
