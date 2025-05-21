import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'login.dart';
import 'home_chat.dart';
import 'pedidos.dart';
import 'pedidos_provider.dart';
import 'pedido_modelo.dart';

class HomeScreen extends StatefulWidget {
  final String nombreRestaurante;
  final String tipoUsuario;

  const HomeScreen({
    super.key,
    required this.nombreRestaurante,
    required this.tipoUsuario,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  late Timer _timer; // Timer para actualizaciones periódicas

  @override
  void initState() {
    super.initState();
    _cargarPedidosIniciales();
    _iniciarActualizacionAutomatica();
  }

  @override
  void dispose() {
    _timer.cancel(); // Cancelar el timer cuando el widget se destruya
    super.dispose();
  }

  void _cargarPedidosIniciales() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final pedidoProvider = Provider.of<PedidoProvider>(
        context,
        listen: false,
      );
      pedidoProvider.cargarPedidosPorNegocio(widget.nombreRestaurante);
    });
  }

  void _iniciarActualizacionAutomatica() {
    // Configurar un timer que se ejecute cada 10 segundos (ajusta este valor según necesites)
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
        // Verificar que el widget todavía esté montado
        final pedidoProvider = Provider.of<PedidoProvider>(
          context,
          listen: false,
        );
        pedidoProvider.cargarPedidosPorNegocio(widget.nombreRestaurante);
      }
    });
  }

  void _mostrarDialogoCerrarSesion() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cerrar sesión'),
            content: const Text('¿Estás seguro de que deseas cerrar sesión?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                    (route) => false,
                  );
                },
                child: const Text('Cerrar sesión'),
              ),
            ],
          ),
    );
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ConversationsList()),
      );
    } else if (index == 2) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const RestaurantePedidos()),
      );
    } else {
      setState(() {
        _selectedIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final pedidos = Provider.of<PedidoProvider>(
      context,
    ).pedidosPorEstado('Pendiente');

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.nombreRestaurante),
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(LucideIcons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: const BoxDecoration(color: Colors.lightBlueAccent),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Bienvenido',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  Text(
                    widget.nombreRestaurante,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    widget.tipoUsuario,
                    style: const TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: () {
                Navigator.pop(context);
                _mostrarDialogoCerrarSesion();
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Text(
                'Solicitudes pendientes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlue, // Azul claro
                ),
              ),
            ),
            Expanded(
              child:
                  pedidos.isEmpty
                      ? Center(
                        child: Container(
                          margin: const EdgeInsets.all(32),
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: const [
                              Icon(Icons.inbox, size: 72, color: Colors.grey),
                              SizedBox(height: 16),
                              Text(
                                'No hay pedidos en esta categoría',
                                style: TextStyle(
                                  fontSize: 16,
                                  color: Colors.black54,
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                      : ListView.builder(
                        itemCount: pedidos.length,
                        itemBuilder: (context, index) {
                          final pedido = pedidos[index];
                          return _buildPedidoCard(context, pedido: pedido);
                        },
                      ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.home),
            label: 'Inicio',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.messageCircle),
            label: 'Chat',
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.shoppingBag),
            label: 'Pedidos',
          ),
        ],
      ),
    );
  }

  Widget _buildPedidoCard(BuildContext context, {required Pedido pedido}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  'Pedido de ${pedido.nombreCliente}',
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.lightBlueAccent,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Tipo de envío: ${pedido.nombreCliente}'),
                        Text(
                          'Domicilio: ${pedido.nombreCliente == "Recoger en tienda" ? "No aplica" : pedido.nombreCliente}',
                        ),
                        Text(
                          'Cubiertos: ${pedido.cubiertos == 1 ? "Sí" : "No"}',
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total: \$${pedido.subtotal.toStringAsFixed(2)}'),
                        Text('Pago: ${pedido.metodoPago}'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            pedido.nombreplatillo,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          Text('Cantidad: ${pedido.cantidad}'),
                          Text('Salsas: ${pedido.salsas}'),
                          Text(
                            'Descripción: ${pedido.descripcion}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              if (pedido.estado == 'Pendiente') ...[
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton.icon(
                      onPressed: () {
                        Provider.of<PedidoProvider>(
                          context,
                          listen: false,
                        ).eliminarPedido(pedido.id);
                      },
                      icon: const Icon(Icons.cancel),
                      label: const Text('Cancelar'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red.shade200,
                        foregroundColor: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 12),
                    ElevatedButton.icon(
                      onPressed: () {
                        Provider.of<PedidoProvider>(
                          context,
                          listen: false,
                        ).cambiarEstado(pedido.id, 'En proceso');
                      },
                      icon: const Icon(Icons.check),
                      label: const Text('Confirmar pedido'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.lightBlueAccent,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
              ] else ...[
                Center(
                  child: Text(
                    'Estado: ${pedido.estado}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: _getEstadoColor(pedido.estado),
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  Color _getEstadoColor(String estado) {
    switch (estado) {
      case 'En proceso':
        return Colors.orange;
      case 'Listo':
        return Colors.green;
      case 'Entregado':
        return Colors.blue;
      default:
        return Colors.grey;
    }
  }
}
