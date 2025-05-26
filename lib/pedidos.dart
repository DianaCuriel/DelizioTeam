import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    final pedidos = Provider.of<PedidoProvider>(
      context,
    ).pedidosPorEstado(categoriaSeleccionada);

    return Scaffold(
      appBar: AppBar(title: const Text("Gestión de Pedidos")),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0), // Padding externo
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                // <- Este padding interno evita que el texto esté tan pegado
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: categoriaSeleccionada,
                    isExpanded: true,
                    dropdownColor: Colors.white,
                    onChanged: (valor) {
                      setState(() {
                        categoriaSeleccionada = valor!;
                      });
                    },
                    icon: const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    ),
                    style: const TextStyle(color: Colors.black),
                    items: const [
                      DropdownMenuItem(
                        value: 'Pendiente',
                        child: Text('Pendientes'),
                      ),
                      DropdownMenuItem(
                        value: 'En proceso',
                        child: Text('Confirmación de pago'),
                      ),
                      DropdownMenuItem(
                        value: 'Listo',
                        child: Text('Pedidos por confirmar de listos'),
                      ),
                      DropdownMenuItem(
                        value: 'Entregado',
                        child: Text('Entregado'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),

          Expanded(
            child:
                pedidos.isEmpty
                    ? Center(
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        margin: const EdgeInsets.symmetric(horizontal: 32),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: const [
                            Icon(Icons.inbox, size: 80, color: Colors.grey),
                            SizedBox(height: 16),
                            Text(
                              'No hay pedidos en esta categoría',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.grey,
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
                        return Card(
                          color: Colors.white,
                          margin: const EdgeInsets.all(8.0),
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
                                Text(
                                  'Fecha: ${DateFormat('dd/MM/yyyy HH:mm').format(pedido.fecha)}',
                                  style: const TextStyle(color: Colors.grey),
                                ),
                                const SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Tipo de envío: ${pedido.formaEntrega}',
                                          ),
                                          Text(
                                            'Dirección: ${pedido.direccion}',
                                          ),
                                          Text(
                                            'Cubiertos: ${pedido.cubiertos ? "Sí" : "No"}',
                                          ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Total: \$${pedido.total.toStringAsFixed(2)}',
                                          ),
                                          Text('Pago: ${pedido.metodoPago}'),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                                if (pedido.mensaje.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(bottom: 8.0),
                                    child: Text(
                                      'Mensaje: ${pedido.mensaje}',
                                      style: TextStyle(
                                        fontStyle: FontStyle.italic,
                                        color: Colors.grey[700],
                                      ),
                                    ),
                                  ),
                                ...pedido.productos.map<Widget>((producto) {
                                  final prod = producto as Map<String, dynamic>;
                                  return Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.only(bottom: 8),
                                    decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          prod['nombre'] ??
                                              'Producto sin nombre',
                                          style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Text(
                                          'Cantidad: ${prod['cantidad'] ?? 1}',
                                        ),
                                        Text(
                                          'Precio unitario: \$${(prod['precio_unitario'] ?? 0).toStringAsFixed(2)}',
                                        ),
                                        Text(
                                          'Subtotal: \$${(prod['subtotal'] ?? 0).toStringAsFixed(2)}',
                                        ),
                                        if (prod['salsas'] != null &&
                                            (prod['salsas'] as List).isNotEmpty)
                                          Text(
                                            'Salsas: ${(prod['salsas'] as List).join(", ")}',
                                          ),
                                        if (prod['extras'] != null &&
                                            (prod['extras'] as List).isNotEmpty)
                                          Text(
                                            'Extras: ${(prod['extras'] as List).join(", ")}',
                                          ),
                                      ],
                                    ),
                                  );
                                }).toList(),
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
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              pedido.nombreplatillo,
                                              style: const TextStyle(
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Text(
                                              'Cantidad: ${pedido.cantidad}',
                                            ),
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

                                if (pedido.estado != 'Entregado')
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
                                      const SizedBox(width: 16),
                                      ElevatedButton.icon(
                                        onPressed: () {
                                          final provider =
                                              Provider.of<PedidoProvider>(
                                                context,
                                                listen: false,
                                              );
                                          if (pedido.estado == 'Pendiente') {
                                            provider.cambiarEstado(
                                              pedido.id,
                                              'En proceso',
                                            );
                                          } else if (pedido.estado ==
                                              'En proceso') {
                                            provider.cambiarEstado(
                                              pedido.id,
                                              'Listo',
                                            );
                                          } else if (pedido.estado == 'Listo') {
                                            provider.cambiarEstado(
                                              pedido.id,
                                              'Entregado',
                                            );
                                          }
                                        },
                                        icon: const Icon(Icons.check),
                                        label: Text(
                                          pedido.estado == 'Pendiente'
                                              ? 'Confirmar pedido'
                                              : pedido.estado == 'En proceso'
                                              ? 'Pago realizado'
                                              : 'Entregado',
                                        ),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              Colors.lightBlueAccent,
                                          foregroundColor: Colors.white,
                                        ),
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
