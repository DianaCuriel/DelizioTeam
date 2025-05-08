import 'package:flutter/material.dart';
import 'chat.dart'; // Asegúrate de que este archivo contiene ChatApp

class ConversationsList extends StatefulWidget {
  const ConversationsList({super.key});

  @override
  _ConversationsListState createState() => _ConversationsListState();
}

class _ConversationsListState extends State<ConversationsList> {
  final List<String> conversations = [
    'Juan Pérez',
    'Ana López',
    'Carlos Martínez',
    'María González',
    'Pedro Ramírez',
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Conversaciones")),
      body: ListView.builder(
        itemCount: conversations.length,
        itemBuilder: (context, index) {
          final name = conversations[index];
          return ListTile(
            title: Text(name),
            leading: CircleAvatar(child: Text(name[0])),
            trailing: const Icon(Icons.chat),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ChatApp(origen: name)),
              );
            },
          );
        },
      ),
    );
  }
}
