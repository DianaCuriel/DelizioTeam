import 'package:flutter/material.dart';
import 'package:lucide_icons/lucide_icons.dart';

class OlvidarContra extends StatefulWidget {
  const OlvidarContra({super.key});

  @override
  State<OlvidarContra> createState() => _OlvidarContraState();
}

class _OlvidarContraState extends State<OlvidarContra> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  void _showCustomDialog({
    required String title,
    required String message,
    required IconData icon,
    required Color iconColor,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: Row(
            children: [
              Icon(icon, color: iconColor),
              SizedBox(width: 10),
              Expanded(child: Text(title)),
            ],
          ),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: Text("OK", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  void _cambiarContrasena() {
    String email = _emailController.text.trim();
    String newPassword = _newPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    if (email.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showCustomDialog(
        title: "Campos incompletos",
        message: "Por favor, completa todos los campos",
        icon: Icons.warning,
        iconColor: Colors.orange,
      );
    } else if (newPassword != confirmPassword) {
      _showCustomDialog(
        title: "Error",
        message: "Las contraseñas no coinciden",
        icon: Icons.error,
        iconColor: Colors.red,
      );
    } else {
      _showCustomDialog(
        title: "Éxito",
        message: "Contraseña cambiada exitosamente",
        icon: Icons.check_circle,
        iconColor: Colors.green,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      appBar: AppBar(
        title: Text('Recuperar contraseña'),
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(24),
          child: Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 10,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(LucideIcons.lock, size: 60, color: Colors.red),
                SizedBox(height: 20),
                _buildTextField(
                  controller: _emailController,
                  label: 'Correo electrónico',
                  icon: Icons.email,
                  keyboardType: TextInputType.emailAddress,
                ),
                SizedBox(height: 15),
                _buildTextField(
                  controller: _newPasswordController,
                  label: 'Nueva contraseña',
                  icon: Icons.lock,
                  obscureText: true,
                ),
                SizedBox(height: 15),
                _buildTextField(
                  controller: _confirmPasswordController,
                  label: 'Confirmar contraseña',
                  icon: Icons.lock_outline,
                  obscureText: true,
                ),
                SizedBox(height: 25),
                ElevatedButton(
                  onPressed: _cambiarContrasena,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Cambiar contraseña',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      style: TextStyle(color: Colors.grey), // Texto gris
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey), // Label gris por defecto
        prefixIcon: Icon(icon, color: Colors.grey), // Icono gris
        filled: true,
        fillColor: Colors.grey[200],
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.red), // Borde rojo al enfocar
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        floatingLabelStyle: TextStyle(
          color: Colors.red,
        ), // Label rojo al enfocar
      ),
    );
  }
}
