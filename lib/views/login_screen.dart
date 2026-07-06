// import 'package:flutter/material.dart';
// import 'home_screen.dart';
//
// class LoginScreen extends StatefulWidget {
//   @override
//   _LoginScreenState createState() => _LoginScreenState();
// }
//
// class _LoginScreenState extends State<LoginScreen> {
//   String username = "";
//   String password = "";
//   String error = "";
//
//   void login() {
//     if (username == "shruti" && password == "shruti") {
//       Navigator.pushReplacement(
//           context, MaterialPageRoute(builder: (_) => HomeScreen()));
//     } else {
//       setState(() => error = "Invalid credentials");
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: EdgeInsets.all(30),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Icon(Icons.eco, size: 100, color: Colors.orange),
//             Text("FreshKeeper", style: TextStyle(fontSize: 28)),
//             TextField(onChanged: (v) => username = v),
//             TextField(obscureText: true, onChanged: (v) => password = v),
//             if (error.isNotEmpty)
//               Text(error, style: TextStyle(color: Colors.red)),
//             ElevatedButton(onPressed: login, child: Text("Login"))
//           ],
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String error = "";
  String _storedUsername = "";
  String _storedPassword = "";

  @override
  void initState() {
    super.initState();
    _loadStoredCredentials();
  }

  Future<void> _loadStoredCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedUsername = prefs.getString('username') ?? '';
      _storedPassword = prefs.getString('password') ?? '';
    });
  }

  void _clearInputs() {
    _usernameController.clear();
    _passwordController.clear();
  }

  void login() {
    final username = _usernameController.text.trim();
    final password = _passwordController.text.trim();

    if (_storedUsername.isEmpty || _storedPassword.isEmpty) {
      setState(() => error =
          "No registered credentials found. Please register first.");
      return;
    }

    if (username.isEmpty || password.isEmpty) {
      setState(() => error = "Enter your username and password.");
      return;
    }

    if (username != _storedUsername) {
      _clearInputs();
      setState(() => error = "Username not matched.");
      return;
    }

    if (password != _storedPassword) {
      _clearInputs();
      setState(() => error = "Password not matched.");
      return;
    }

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        // 🌈 LIGHT GREEN GRADIENT BACKGROUND (FIXED)
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFF4F7F4),
              Color(0xFFDFF5E3),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),

        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(height: 80),

              // 🥕 CARROT ICON (BIGGER + CLEAN)
              Icon(
                Icons.eco,
                size: 110,
                color: Colors.orange,
                shadows: [
                  Shadow(
                    color: Colors.orange.withOpacity(0.3),
                    blurRadius: 15,
                  )
                ],
              ),

              SizedBox(height: 15),

              // 🌿 TITLE
              Text(
                "FreshKeeper",
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Colors.green.shade600,
                  letterSpacing: 1,
                ),
              ),

              SizedBox(height: 30),

              // 🧾 LOGIN CARD (FIXED COLOR + SHADOW)
              Container(
                margin: EdgeInsets.symmetric(horizontal: 25),
                padding: EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Color(0xFFEAEAEA), // lighter grey like image 2
                  borderRadius: BorderRadius.circular(25),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black12,
                      blurRadius: 15,
                      offset: Offset(0, 6),
                    )
                  ],
                ),
                child: Column(
                  children: [
                    // USERNAME
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Username",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              )
                            ],
                          ),
                          child: TextField(
                            controller: _usernameController,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 12),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),

                    SizedBox(height: 20),

                    // PASSWORD
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Password",
                          style: TextStyle(
                            color: Colors.grey.shade600,
                            fontSize: 13,
                          ),
                        ),
                        SizedBox(height: 6),
                        Container(
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 6,
                                offset: Offset(0, 3),
                              )
                            ],
                          ),
                          child: TextField(
                            controller: _passwordController,
                            obscureText: true,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 12),
                              border: InputBorder.none,
                            ),
                          ),
                        ),
                      ],
                    ),

                    // ERROR MESSAGE
                    if (error.isNotEmpty)
                      Padding(
                        padding: EdgeInsets.only(top: 12),
                        child: Text(
                          error,
                          style: TextStyle(
                            color: Colors.red,
                            fontSize: 13,
                          ),
                        ),
                      ),

                    SizedBox(height: 20),

                    // LOGIN BUTTON (FIXED COLOR + TEXT)
                    GestureDetector(
                      onTap: login,
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(vertical: 14),
                        decoration: BoxDecoration(
                          color: Colors.green.shade600,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.green.withOpacity(0.4),
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Login",
                            style: TextStyle(
                              color: Colors.white, // FIXED (was blue)
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}