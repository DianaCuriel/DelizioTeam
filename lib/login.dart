import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'olvidar_contra.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _restauranteController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;

  Future<void> _login() async {
    setState(() => _isLoading = true);
    
    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final restauranteIngresado = _restauranteController.text.trim();

      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final userId = userCredential.user!.uid;

      final userDoc = await FirebaseFirestore.instance
          .collection('USUARIOS')
          .doc(userId)
          .get();

      if (!userDoc.exists) {
        throw Exception('Usuario no encontrado en DelizioApp');
      }

      final data = userDoc.data() as Map<String, dynamic>;
      final tipoUsuario = data['TIPOUSUARIO']?.toString().toLowerCase() ?? '';
      final negocio = data['NEGOCIO']?.toString().toLowerCase().trim() ?? '';

      if ((tipoUsuario == 'locatario' || tipoUsuario == 'administrador') &&
          negocio == restauranteIngresado.toLowerCase().trim()) {
        
        if (_rememberMe) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('remember_me', true);
          await prefs.setString('email', email);
          await prefs.setString('password', password);
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(
              nombreRestaurante: data['NEGOCIO'],
              tipoUsuario: data['TIPOUSUARIO'],
            ),
          ),
        );
      } else {
        _mostrarMensaje('No autorizado. Verifica el tipo de usuario o restaurante.');
      }
    } on FirebaseAuthException catch (e) {
      _mostrarMensaje('Error de autenticación: ${e.message}');
    } catch (e) {
      _mostrarMensaje('Error: ${e.toString()}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // ... (tu código existente de diseño)
          
          _isLoading
              ? const Center(child: CircularProgressIndicator())
              : const SizedBox(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _restauranteController.dispose();
    super.dispose();
  }
}