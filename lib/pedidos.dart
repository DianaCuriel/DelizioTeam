import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'pedido_modelo.dart';
import 'pedidos_provider.dart';

class RestaurantePedidos extends StatefulWidget {
  const RestaurantePedidos({super.key});

  @override
  State<RestaurantePedidos> createState() => _RestaurantePedidosState();
}

class _RestaurantePedidosState extends State<RestaurantePedidos> {
  String categoriaSeleccionada = 'Pendiente';

  @override
  Widget build(BuildContext context) {
    final pedidos = Provider.of<PedidoProvider>(context)
        .pedidosPorEstado(categoriaSeleccionada);

    return Scaffold(
      appBar: AppBar(title: const Text("Gestión de Pedidos - CHIAVENATOS")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButton<String>(
              value: categoriaSeleccionada,
              onChanged: (valor) {
                setState(() {
                  categoriaSeleccionada = valor!;
                });
              },
              items: const [
                DropdownMenuItem(
                  value: 'Pendiente',
                  child: Text('Pendientes'),
                ),
                DropdownMenuItem(
                  value: 'En proceso',
                  child: Text('En proceso'),
                ),
                DropdownMenuItem(
                  value: 'Listo',
                  child: Text('Listo para entregar'),
                ),
                DropdownMenuItem(
                  value: 'Entregado',
                  child: Text('Entregado'),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: pedidos.length,
              itemBuilder: (context, index) {
                final pedido = pedidos[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Pedido #${pedido.id.substring(0, 8)}',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text('Producto: ${pedido.nombreplatillo}'),
                        Text('Cantidad: ${pedido.cantidad}'),
                        Text('Precio unitario: \$${pedido.precioUnitario}'),
                        Text('Subtotal: \$${pedido.subtotal}'),
                        Text('Método de pago: ${pedido.metodoPago}'),
                        Text('Mensaje: ${pedido.mensaje}'),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                Provider.of<PedidoProvider>(context, listen: false)
                                    .cambiarEstado(pedido.id, 'En proceso');
                              },
                              child: const Text('En proceso'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Provider.of<PedidoProvider>(context, listen: false)
                                    .eliminarPedido(pedido.id);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                              ),
                              child: const Text('Cancelar'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}