import 'package:delizio_para_restaurantes/pedidos.dart';
import 'package:flutter/material.dart';
import 'login.dart';
import 'home_chat.dart';
import 'package:lucide_icons/lucide_icons.dart';
import 'package:provider/provider.dart';
import 'pedidos_provider.dart';
import 'pedido_modelo.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;
  String categoriaSeleccionada = 'Pendientes';

  void _mostrarDialogoCerrarSesion() {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Cerrar sesión'),
            content: const Text('¿Estás segura de que deseas cerrar sesión?'),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancelar'),
              ),
              TextButton(
                onPressed: () {
                  // Aquí puedes limpiar preferencias si usas shared_preferences, etc.
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
    ).pedidosPorEstado(categoriaSeleccionada);

    return Scaffold(
      appBar: AppBar(
        leading: Builder(
          builder:
              (context) => IconButton(
                icon: Icon(LucideIcons.menu),
                onPressed: () {
                  Scaffold.of(context).openDrawer(); // Ahora sí funciona
                },
              ),
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Cerrar sesión'),
              onTap: () {
                Navigator.pop(context); // Cierra el drawer
                _mostrarDialogoCerrarSesion();
              },
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start, // Opcional, también ayuda
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
                vertical: 8.0,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Pedidos por confirmar',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
            // LISTA DE PEDIDOS
            Expanded(
              child: ListView.builder(
                itemCount: pedidos.length,
                itemBuilder: (context, index) {
                  final pedido = pedidos[index];
                  return platilloCard(context, pedido: pedido);
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
            label: "Inicio",
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.messageCircle),
            label: "Chat",
          ),
          BottomNavigationBarItem(
            icon: Icon(LucideIcons.messageCircle),
            label: "Pedidos",
          ),
        ],
      ),
    );
  }
}

Widget platilloCard(BuildContext context, {required Pedido pedido}) {
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
            // 🧾 Título del pedido
            Center(
              child: Text(
                'Pedido #${pedido.id}',
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.lightBlueAccent,
                ),
              ),
            ),

            const SizedBox(height: 10),

            // 👤 Información del cliente en 2 columnas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Cliente: ${pedido.nombre}'),
                      Text('Cubiertos: ${pedido.cubiertos}'),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total: \$${pedido.precio}'),
                      Text('Pago: ${pedido.tipoPago}'),
                    ],
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 🍽️ Información del platillo
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  // Imagen del platillo
                  pedido.imagen.isNotEmpty
                      ? ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          pedido.imagen,
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                        ),
                      )
                      : const Icon(
                        Icons.image_not_supported,
                        size: 60,
                        color: Colors.grey,
                      ),
                  const SizedBox(width: 12),

                  // Detalles del platillo
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

            // 🔘 Botones centrados
            if (pedido.estado == 'Pendientes') ...[
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
                    label: const Text("Ignorar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                      foregroundColor: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton.icon(
                    onPressed: () {
                      Provider.of<PedidoProvider>(
                        context,
                        listen: false,
                      ).cambiarEstado(pedido.id, 'Confirmar pago');
                    },
                    icon: const Icon(Icons.check),
                    label: const Text("Aceptar"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.lightBlueAccent,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    ),
  );
}
