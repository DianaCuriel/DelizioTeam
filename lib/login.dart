import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home.dart';
import 'olvidar_contra.dart';
import 'Config/clippers/wave_clipper.dart';

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

  @override
  void initState() {
    super.initState();
    _cargarCredencialesGuardadas();
  }

  Future<void> _cargarCredencialesGuardadas() async {
    final prefs = await SharedPreferences.getInstance();
    final rememberMe = prefs.getBool('remember_me') ?? false;

    if (rememberMe) {
      setState(() {
        _rememberMe = true;
        _emailController.text = prefs.getString('email') ?? '';
        _passwordController.text = prefs.getString('password') ?? '';
        _restauranteController.text = prefs.getString('restaurante') ?? '';
      });
    }
  }

  Future<void> _login() async {
    setState(() => _isLoading = true);

    try {
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      final restauranteIngresado = _restauranteController.text.trim();

      // 1. Autenticar usuario
      final userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      final userId = userCredential.user!.uid;

      // 2. Verificar datos en colección USUARIOS
      final userDoc =
          await FirebaseFirestore.instance
              .collection('USUARIOS')
              .doc(userId)
              .get();

      if (!userDoc.exists) {
        throw Exception('Usuario no registrado en el sistema');
      }

      final userData = userDoc.data() as Map<String, dynamic>;
      final tipoUsuario =
          userData['TIPOUSUARIO']?.toString().toLowerCase() ?? '';
      final negocioUsuario = userData['NEGOCIO']?.toString().trim() ?? '';

      // 3. Verificar que el restaurante exista
      final restaurantesQuery =
          await FirebaseFirestore.instance
              .collection('restaurantes')
              .where('NEGOCIO', isEqualTo: restauranteIngresado)
              .limit(1)
              .get();

      if (restaurantesQuery.docs.isEmpty) {
        throw Exception('Restaurante no encontrado en nuestros registros');
      }

      final nombreRestaurante =
          restaurantesQuery.docs.first.data()['NEGOCIO']?.toString().trim() ??
          '';

      // 4. Validar acceso según tipo de usuario
      if (tipoUsuario == 'administrador') {
        // Administradores pueden acceder a cualquier restaurante
        if (_rememberMe) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('remember_me', true);
          await prefs.setString('email', email);
          await prefs.setString('password', password);
          await prefs.setString('restaurante', nombreRestaurante);
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => HomeScreen(
                  nombreRestaurante: nombreRestaurante,
                  tipoUsuario: tipoUsuario,
                ),
          ),
        );
      } else if (tipoUsuario == 'locatario' &&
          negocioUsuario.toLowerCase() == nombreRestaurante.toLowerCase()) {
        // Locatarios solo pueden acceder a su restaurante asignado
        if (_rememberMe) {
          final prefs = await SharedPreferences.getInstance();
          await prefs.setBool('remember_me', true);
          await prefs.setString('email', email);
          await prefs.setString('password', password);
          await prefs.setString('restaurante', nombreRestaurante);
        }

        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder:
                (context) => HomeScreen(
                  nombreRestaurante: nombreRestaurante,
                  tipoUsuario: tipoUsuario,
                ),
          ),
        );
      } else {
        throw Exception('No tienes permisos para acceder a este restaurante');
      }
    } on FirebaseAuthException catch (e) {
      _mostrarMensaje('Error de autenticación: ${e.message}');
    } catch (e) {
      _mostrarMensaje(e.toString());
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _mostrarMensaje(String mensaje) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(mensaje), duration: Duration(seconds: 3)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Stack(
            children: [
              // FONDO CON OLA
              ClipPath(
                clipper: WaveClipper(),
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.80,
                  color: Colors.grey[200],
                ),
              ),

              // LOGO Y TÍTULOS
              Padding(
                padding: const EdgeInsets.only(top: 80),
                child: Column(
                  children: [
                    Image.asset('lib/Config/Imagenes/Logo.png', height: 100),
                    SizedBox(height: 10),
                    Text(
                      "DELIZIO",
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                    Text(
                      "APP PARA RESTAURANTES",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.lightBlueAccent,
                      ),
                    ),
                    SizedBox(height: 40), // espacio antes del formulario
                    // FORMULARIO
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      child: Center(
                        child: ConstrainedBox(
                          constraints: BoxConstraints(
                            maxWidth: 500,
                          ), // más ancho
                          child: Container(
                            padding: EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 3,
                                ),
                              ],
                            ),
                            child: Column(
                              children: [
                                _buildTextField(
                                  _emailController,
                                  "Correo electrónico",
                                  Icons.email,
                                ),
                                SizedBox(height: 15),
                                _buildTextField(
                                  _passwordController,
                                  "Contraseña",
                                  Icons.lock,
                                  obscureText: true,
                                ),
                                SizedBox(height: 15),
                                _buildTextField(
                                  _restauranteController,
                                  "Restaurante",
                                  Icons.restaurant,
                                ),
                                SizedBox(height: 10),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        Checkbox(
                                          value: _rememberMe,
                                          onChanged: (value) {
                                            setState(() {
                                              _rememberMe = value!;
                                            });
                                          },
                                        ),
                                        Text("Recuérdame"),
                                      ],
                                    ),
                                    Flexible(
                                      child: TextButton(
                                        onPressed: () {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder:
                                                  (context) =>
                                                      const OlvidarContra(),
                                            ),
                                          );
                                        },
                                        child: Text(
                                          "¿Olvidaste tu contraseña?",
                                          style: TextStyle(color: Colors.blue),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(height: 20),
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _login,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.black,
                                      padding: EdgeInsets.symmetric(
                                        vertical: 15,
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    child:
                                        _isLoading
                                            ? CircularProgressIndicator(
                                              color: Colors.white,
                                            )
                                            : Text(
                                              "INICIAR SESIÓN",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),

                    SizedBox(height: 50), // espacio final por si hay teclado
                  ],
                ),
              ),

              // OVERLAY DE CARGA
              if (_isLoading)
                Container(
                  color: Colors.black.withOpacity(0.5),
                  child: Center(child: CircularProgressIndicator()),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController controller,
    String label,
    IconData icon, {
    bool obscureText = false,
  }) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      style: TextStyle(color: Colors.grey[700]),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(color: Colors.grey),
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: Colors.grey[200],
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(color: Colors.lightBlueAccent),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide.none,
        ),
        floatingLabelStyle: TextStyle(color: Colors.lightBlueAccent),
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
