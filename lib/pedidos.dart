// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import 'pedidos_provider.dart';
// import 'pedido_modelo.dart';

// class RestaurantePedidos extends StatefulWidget {
//   const RestaurantePedidos({super.key});

//   @override
//   State<RestaurantePedidos> createState() => _RestaurantePedidosState();
// }

// class _RestaurantePedidosState extends State<RestaurantePedidos> {
//   String categoriaSeleccionada = 'Pendientes';

//   @override
//   Widget build(BuildContext context) {
//     final pedidos = Provider.of<PedidoProvider>(
//       context,
//     ).pedidosPorEstado(categoriaSeleccionada);

//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Gestionador de pedidos',
//           style: TextStyle(
//             color: Colors.black,
//             fontSize: 20, // más pequeño
//             fontWeight: FontWeight.normal,
//           ),
//         ),
//         backgroundColor: Colors.grey[100],
//         iconTheme: const IconThemeData(
//           color: Colors.black,
//         ), // cambia color de los íconos
//       ),

//       body: SafeArea(
//         child: Column(
//           children: [
//             const SizedBox(height: 10),

//             // MENÚ DE CATEGORÍAS (BOTONES)
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: 10),
//               child: SingleChildScrollView(
//                 scrollDirection: Axis.horizontal,
//                 child: Row(
//                   children:
//                       [
//                             'Pendientes',
//                             'Confirmar pago',
//                             'En proceso',
//                             'Entregados',
//                           ]
//                           .map(
//                             (categoria) => Padding(
//                               padding: const EdgeInsets.symmetric(
//                                 horizontal: 3,
//                               ),
//                               child: ElevatedButton(
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor:
//                                       categoriaSeleccionada == categoria
//                                           ? Colors.lightBlueAccent
//                                           : Colors.grey.shade400,
//                                   foregroundColor: Colors.white,
//                                 ),
//                                 onPressed: () {
//                                   setState(() {
//                                     categoriaSeleccionada = categoria;
//                                   });
//                                 },
//                                 child: Text(categoria),
//                               ),
//                             ),
//                           )
//                           .toList(),
//                 ),
//               ),
//             ),

//             // LISTA DE PEDIDOS
//             Expanded(
//               child: ListView.builder(
//                 itemCount: pedidos.length,
//                 itemBuilder: (context, index) {
//                   final pedido = pedidos[index];
//                   return platilloCard(pedido: pedido);
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget platilloCard({required Pedido pedido}) {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Card(
//         color: Colors.white,
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         elevation: 4,
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // 🧾 Título del pedido
//               Center(
//                 child: Text(
//                   'Pedido #${pedido.id}',
//                   style: const TextStyle(
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.lightBlueAccent,
//                   ),
//                 ),
//               ),

//               const SizedBox(height: 10),

//               // 👤 Información del cliente en 2 columnas
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Cliente: ${pedido.nombreplatillo}'),
//                         Text('Cubiertos: ${pedido.cantidad}'),
//                       ],
//                     ),
//                   ),
//                   const SizedBox(width: 16),
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('Total: \$${pedido.subtotal.toStringAsFixed(2)}'),
//                         Text('Pago: ${pedido.metodoPago}'),
//                       ],
//                     ),
//                   ),
//                 ],
//               ),

//               const SizedBox(height: 16),

//               // 🍽️ Información del platillo
//               Container(
//                 padding: const EdgeInsets.all(10),
//                 decoration: BoxDecoration(
//                   color: Colors.grey.shade100,
//                   borderRadius: BorderRadius.circular(8),
//                 ),
//                 child: Row(
//                   children: [
//                     // Imagen del platillo
//                     (pedido.imagen?.isNotEmpty == true)
//                         ? ClipRRect(
//                           borderRadius: BorderRadius.circular(8),
//                           child: Image.asset(
//                             pedido.imagen!,
//                             width: 60,
//                             height: 60,
//                             fit: BoxFit.cover,
//                           ),
//                         )
//                         : const Icon(
//                           Icons.image_not_supported,
//                           size: 60,
//                           color: Colors.grey,
//                         ),
//                     const SizedBox(width: 12),

//                     // Detalles del platillo
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             pedido.nombreplatillo,
//                             style: const TextStyle(
//                               fontSize: 16,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Text('Cantidad: ${pedido.cantidad}'),
//                           Text('Salsas: ${pedido.salsas}'),
//                           Text(
//                             'Descripción: ${pedido.descripcion}',
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),

//               const SizedBox(height: 16),

//               // 🔘 Botones centrados
//               if (pedido.estado == 'Pendientes') ...[
//                 Row(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   children: [
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         Provider.of<PedidoProvider>(
//                           context,
//                           listen: false,
//                         ).eliminarPedido(pedido.id);
//                       },
//                       icon: const Icon(Icons.cancel),
//                       label: const Text("Ignorar"),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.grey,
//                         foregroundColor: Colors.white,
//                       ),
//                     ),

//                     const SizedBox(width: 12),
//                     ElevatedButton.icon(
//                       onPressed: () {
//                         Provider.of<PedidoProvider>(
//                           context,
//                           listen: false,
//                         ).cambiarEstado(pedido.id, 'Confirmar pago');
//                       },
//                       icon: const Icon(Icons.check),
//                       label: const Text("Aceptar"),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Colors.lightBlueAccent,
//                         foregroundColor: Colors.white,
//                       ),
//                     ),
//                   ],
//                 ),
//               ] else if (pedido.estado == 'Confirmar pago') ...[
//                 Center(
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       Provider.of<PedidoProvider>(
//                         context,
//                         listen: false,
//                       ).cambiarEstado(pedido.id, 'En proceso');
//                     },
//                     icon: const Icon(Icons.delivery_dining),
//                     label: const Text("Pago realizado"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.lightBlueAccent,
//                       foregroundColor: Colors.white,
//                     ),
//                   ),
//                 ),
//               ] else if (pedido.estado == 'En proceso') ...[
//                 Center(
//                   child: ElevatedButton.icon(
//                     onPressed: () {
//                       Provider.of<PedidoProvider>(
//                         context,
//                         listen: false,
//                       ).cambiarEstado(pedido.id, 'Entregados');
//                     },
//                     icon: const Icon(Icons.delivery_dining),
//                     label: const Text("Marcar como entregado"),
//                     style: ElevatedButton.styleFrom(
//                       backgroundColor: Colors.lightBlueAccent,
//                       foregroundColor: Colors.white,
//                     ),
//                   ),
//                 ),
//               ] else if (pedido.estado == 'Entregado')
//                 ...[],
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }

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
    final pedidos = Provider.of<PedidoProvider>(
      context,
    ).pedidosPorEstado(categoriaSeleccionada);

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
                DropdownMenuItem(value: 'Pendiente', child: Text('Pendientes')),
                DropdownMenuItem(
                  value: 'En proceso',
                  child: Text('En proceso'),
                ),
                DropdownMenuItem(
                  value: 'Listo',
                  child: Text('Listo para entregar'),
                ),
                DropdownMenuItem(value: 'Entregado', child: Text('Entregado')),
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
                                Provider.of<PedidoProvider>(
                                  context,
                                  listen: false,
                                ).cambiarEstado(pedido.id, 'En proceso');
                              },
                              child: const Text('En proceso'),
                            ),
                            ElevatedButton(
                              onPressed: () {
                                Provider.of<PedidoProvider>(
                                  context,
                                  listen: false,
                                ).eliminarPedido(pedido.id);
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
