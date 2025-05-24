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
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _cargarPedidosIniciales();
    _iniciarActualizacionAutomatica();
  }

  @override
  void dispose() {
    _timer.cancel();
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
    _timer = Timer.periodic(const Duration(seconds: 10), (timer) {
      if (mounted) {
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
                icon: const Icon(LucideIcons.menu),
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
                  color: Colors.lightBlue,
                ),
              ),
            ),
            Expanded(
              child:
                  pedidos.isEmpty
                      ? _buildEmptyState()
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

  Widget _buildEmptyState() {
    return Center(
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
        child: const Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.inbox, size: 72, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No hay pedidos en esta categoría',
              style: TextStyle(fontSize: 16, color: Colors.black54),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPedidoCard(BuildContext context, {required Pedido pedido}) {
    final tieneDireccion =
        pedido.direccion != null && pedido.direccion!.isNotEmpty;
    final esRecogerEnTienda =
        !tieneDireccion || pedido.direccion!.toLowerCase().contains('recoger');

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
                  'PEDIDO DE ${pedido.nombreCliente.toUpperCase()}',
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
                        Text(
                          'Tipo de envío: ${esRecogerEnTienda ? "RECOGER EN TIENDA" : "DOMICILIO"}',
                        ),
                        if (!esRecogerEnTienda && tieneDireccion)
                          Text('Dirección: ${pedido.direccion}'),
                        Text('Cubiertos: ${pedido.cubiertos ? "SÍ" : "NO"}'),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Total: \$${pedido.total.toStringAsFixed(2)}'),
                        Text('Pago: ${pedido.metodoPago.toUpperCase()}'),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ..._buildListaProductos(pedido),
              if (pedido.descripcion != null && pedido.descripcion!.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    'NOTA: ${pedido.descripcion}',
                    style: TextStyle(
                      fontStyle: FontStyle.italic,
                      color: Colors.grey[700],
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              _buildBotonesEstado(pedido),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildListaProductos(Pedido pedido) {
    if (pedido.productos != null && pedido.productos!.isNotEmpty) {
      return pedido.productos!.map<Widget>((producto) {
        final prod = producto as Map<String, dynamic>;
        return Container(
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.only(bottom: 8),
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
                      prod['nombre'] ?? 'Producto sin nombre',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Cantidad: ${prod['cantidad'] ?? 1}'),
                    if (prod['precio_unitario'] != null)
                      Text(
                        'Precio: \$${prod['precio_unitario'].toStringAsFixed(2)}',
                      ),
                    if (prod['salsas'] != null &&
                        (prod['salsas'] as List).isNotEmpty)
                      Text('Salsas: ${(prod['salsas'] as List).join(", ")}'),
                  ],
                ),
              ),
            ],
          ),
        );
      }).toList();
    } else {
      // Compatibilidad con el segundo formato de pedido (un solo producto)
      return [
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
                      pedido.nombreplatillo ?? 'Producto sin nombre',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Cantidad: ${pedido.cantidad ?? 1}'),
                    if (pedido.salsas != null && pedido.salsas!.isNotEmpty)
                      Text('Salsas: ${pedido.salsas}'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ];
    }
  }

  Widget _buildBotonesEstado(Pedido pedido) {
    if (pedido.estado == 'Pendiente') {
      return Row(
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
            label: const Text('CANCELAR'),
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
            label: const Text('CONFIRMAR PEDIDO'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      );
    } else {
      return Center(
        child: Text(
          'ESTADO: ${pedido.estado.toUpperCase()}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: _getEstadoColor(pedido.estado),
          ),
        ),
      );
    }
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
