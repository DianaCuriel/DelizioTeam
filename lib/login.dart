import 'package:flutter/material.dart';
import 'home.dart';
import 'Config/clippers/wave_clipper.dart';
import 'olvidar_contra.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;

  void _login() {
    String email = _emailController.text;
    String password = _passwordController.text;

    if (email == "admin" && password == "123") {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Invalid email or password")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // FONDO NEGRO CON OLA
          ClipPath(
            clipper: WaveClipper(),
            child: Container(
              height: MediaQuery.of(context).size.height * 0.80,
              color: Colors.grey[200],
            ),
          ),

          // LOGO Y TÍTULOS
          Positioned(
            top: 80,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Image.asset('lib/Config/Imagenes/Icon.jpg', height: 100),
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
                  style: TextStyle(fontSize: 16, color: Colors.lightBlueAccent),
                ),
              ],
            ),
          ),

          // FORMULARIO BLANCO
          Align(
            alignment: Alignment(0, 0.6),
            child: SingleChildScrollView(
              padding: EdgeInsets.symmetric(horizontal: 50),
              child: Container(
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildTextField(_emailController, "Email", Icons.person),
                    SizedBox(height: 15),
                    _buildTextField(
                      _passwordController,
                      "Password",
                      Icons.lock,
                      obscureText: true,
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const OlvidarContra(),
                              ),
                            );
                          },
                          child: Text(
                            "¿Olvidaste tu contraseña?",
                            style: TextStyle(color: Colors.blue),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _login,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                          horizontal: 100,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Text(
                        "Iniciar sesion",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(height: 20),
                    // Row(
                    //   mainAxisAlignment: MainAxisAlignment.center,
                    //   children: [
                    //     Text(
                    //       "¿No tienes una cuenta?",
                    //       style: TextStyle(color: Colors.grey),
                    //     ),
                    //     TextButton(
                    //       onPressed: () {
                    //         Navigator.push(
                    //           context,
                    //           MaterialPageRoute(
                    //             builder: (context) => const CrearCuenta(),
                    //           ),
                    //         );
                    //       },
                    //       child: Text(
                    //         "Crea tu cuenta aquí",
                    //         style: TextStyle(color: Colors.blue),
                    //       ),
                    //     ),
                    //   ],
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ],
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
}
