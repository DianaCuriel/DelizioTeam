import 'package:flutter/material.dart';
import 'pedido_modelo.dart';

class PedidoProvider with ChangeNotifier {
  final List<Pedido> _listaPedidos = [
    Pedido(
      id: 1,
      nombre: 'Ana Gómez',
      cubiertos: 2,
      precio: 120.50,
      tipoPago: 'Tarjeta',
      nombreplatillo: 'Enchiladas suizas',
      cantidad: 1,
      salsas: 'Verde',
      descripcion: 'Enchiladas con pollo, crema y queso',
      imagen: 'assets/enchiladas.jpg',
      estado: 'Pendientes',
    ),
    Pedido(
      id: 2,
      nombre: 'Carlos Pérez',
      cubiertos: 1,
      precio: 85.00,
      tipoPago: 'Efectivo',
      nombreplatillo: 'Tacos al pastor',
      cantidad: 3,
      salsas: 'Roja y Verde',
      descripcion: 'Tacos con piña y cebolla',
      imagen: 'assets/tacos.jpg',
      estado: 'En proceso',
    ),
    Pedido(
      id: 3,
      nombre: 'Lucía Ramírez',
      cubiertos: 3,
      precio: 200.00,
      tipoPago: 'Tarjeta',
      nombreplatillo: 'Mole poblano',
      cantidad: 2,
      salsas: 'Ninguna',
      descripcion: 'Pechuga de pollo con mole y arroz',
      imagen: 'assets/mole.jpg',
      estado: 'Entregados',
    ),
  ];

  List<Pedido> get pedidos => _listaPedidos;

  List<Pedido> pedidosPorEstado(String estado) {
    return _listaPedidos.where((p) => p.estado == estado).toList();
  }

  void cambiarEstado(int id, String nuevoEstado) {
    final index = _listaPedidos.indexWhere((p) => p.id == id);
    if (index != -1) {
      _listaPedidos[index].estado = nuevoEstado;
      notifyListeners();
    }
  }

  void eliminarPedido(int id) {
    _listaPedidos.removeWhere((p) => p.id == id);
    notifyListeners();
  }
}
