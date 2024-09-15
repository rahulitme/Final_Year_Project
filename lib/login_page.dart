// // import 'package:flutter/material.dart';

// // class LoginPage extends StatefulWidget {
// //   @override
// //   _LoginPageState createState() => _LoginPageState();
// // }

// // class _LoginPageState extends State<LoginPage> {
// //   final TextEditingController _emailController = TextEditingController();
// //   final TextEditingController _passwordController = TextEditingController();

// //   void _login() {
// //     String email = _emailController.text;
// //     String password = _passwordController.text;

// //     if (email.isNotEmpty && password.isNotEmpty) {
// //       Navigator.pushReplacementNamed(context, '/home');
// //     } else {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Please enter both email and password')),
// //       );
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Container(
// //         decoration: BoxDecoration(
// //           gradient: LinearGradient(
// //             begin: Alignment.topLeft,
// //             end: Alignment.bottomRight,
// //             colors: [
// //               Color(0xFF6A11CB), // Deep purple
// //               Color(0xFF2575FC), // Vibrant blue
// //             ],
// //           ),
// //         ),
// //         height: double.infinity,
// //         child: SingleChildScrollView(
// //           child: Column(
// //             children: <Widget>[
// //               Padding(
// //                 padding: const EdgeInsets.fromLTRB(0, 80, 0, 30),
// //                 child: Center(
// //                   child: Container(
// //                     width: 200,
// //                     height: 200,
// //                     decoration: BoxDecoration(
// //                       shape: BoxShape.circle,
// //                       color: Colors.white.withOpacity(0.2),
// //                       boxShadow: [
// //                         BoxShadow(
// //                           color: Colors.white.withOpacity(0.1),
// //                           blurRadius: 20,
// //                           spreadRadius: 5,
// //                         ),
// //                       ],
// //                     ),
// //                     child: ClipOval(
// //                       child: Image.asset('images/logo.png'),
// //                     ),
// //                   ),
// //                 ),
// //               ),
// //               Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 30),
// //                 child: TextField(
// //                   controller: _emailController,
// //                   style: TextStyle(color: Colors.white),
// //                   decoration: InputDecoration(
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(30),
// //                       borderSide: BorderSide.none,
// //                     ),
// //                     labelText: 'Phone number, email or username',
// //                     hintText: 'Enter valid email id as abc@gmail.com',
// //                     labelStyle: TextStyle(color: Colors.white70),
// //                     hintStyle: TextStyle(color: Colors.white54),
// //                     filled: true,
// //                     fillColor: Colors.white.withOpacity(0.1),
// //                     prefixIcon: Icon(Icons.person, color: Colors.white70),
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(height: 20),
// //               Padding(
// //                 padding: EdgeInsets.symmetric(horizontal: 30),
// //                 child: TextField(
// //                   controller: _passwordController,
// //                   obscureText: true,
// //                   style: TextStyle(color: Colors.white),
// //                   decoration: InputDecoration(
// //                     border: OutlineInputBorder(
// //                       borderRadius: BorderRadius.circular(30),
// //                       borderSide: BorderSide.none,
// //                     ),
// //                     labelText: 'Password',
// //                     hintText: 'Enter secure password',
// //                     labelStyle: TextStyle(color: Colors.white70),
// //                     hintStyle: TextStyle(color: Colors.white54),
// //                     filled: true,
// //                     fillColor: Colors.white.withOpacity(0.1),
// //                     prefixIcon: Icon(Icons.lock, color: Colors.white70),
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(height: 40),
// //               Container(
// //                 width: 300,
// //                 height: 50,
// //                 child: ElevatedButton(
// //                   child: Text(
// //                     'Log in',
// //                     style: TextStyle(color: Colors.white, fontSize: 18),
// //                   ),
// //                   onPressed: _login,
// //                   style: ElevatedButton.styleFrom(
// //                     backgroundColor: Color(0xFF4776E6),
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(25),
// //                     ),
// //                     elevation: 5,
// //                   ),
// //                 ),
// //               ),
// //               SizedBox(height: 30),
// //               Text(
// //                 'Forgot your login details?',
// //                 style: TextStyle(color: Colors.white70),
// //               ),
// //               TextButton(
// //                 onPressed: () {
// //                   // Handle forgot password
// //                 },
// //                 child: Text(
// //                   'Get help logging in.',
// //                   style: TextStyle(
// //                     fontSize: 16,
// //                     color: Colors.white,
// //                     fontWeight: FontWeight.bold,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// // // login_page.dart
// // import 'package:flutter/material.dart';
// // import 'package:firebase_auth/firebase_auth.dart';

// // class LoginPage extends StatefulWidget {
// //   @override
// //   _LoginPageState createState() => _LoginPageState();
// // }

// // class _LoginPageState extends State<LoginPage> {
// //   // Controllers to capture user input
// //   final TextEditingController emailController = TextEditingController();
// //   final TextEditingController passwordController = TextEditingController();

// //   // Form key for validation
// //   final _formKey = GlobalKey<FormState>();

// //   // Firebase Auth instance

// //   // Function to handle login
// //   Future<void> _login() async {
// //     if (_formKey.currentState!.validate()) {
// //       try {
// //         // Sign in with email and password

// //         // Navigate to Home Page on successful login
// //         Navigator.pushReplacementNamed(context, '/home');
// //       } on FirebaseAuthException catch (e) {
// //         // Display error message
// //         String message;
// //         if (e.code == 'user-not-found') {
// //           message = 'No user found for that email.';
// //         } else if (e.code == 'wrong-password') {
// //           message = 'Wrong password provided.';
// //         } else {
// //           message = 'An error occurred. Please try again.';
// //         }
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text(message)),
// //         );
// //       }
// //     }
// //   }

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       // Optional: You can remove AppBar if not needed
// //       appBar: AppBar(
// //         title: Text('Login'),
// //       ),
// //       body: Center(
// //         child: SingleChildScrollView(
// //           padding: EdgeInsets.all(16.0),
// //           child: Form(
// //             key: _formKey, // Assign the form key
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               children: <Widget>[
// //                 // Email Field
// //                 TextFormField(
// //                   controller: emailController,
// //                   decoration: InputDecoration(labelText: 'Email'),
// //                   validator: (value) {
// //                     // Basic email validation
// //                     if (value == null || value.isEmpty) {
// //                       return 'Please enter your email';
// //                     }
// //                     if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
// //                       return 'Please enter a valid email address';
// //                     }
// //                     return null;
// //                   },
// //                 ),
// //                 SizedBox(height: 16),
// //                 // Password Field
// //                 TextFormField(
// //                   controller: passwordController,
// //                   decoration: InputDecoration(labelText: 'Password'),
// //                   obscureText: true, // Hide the password
// //                   validator: (value) {
// //                     if (value == null || value.isEmpty) {
// //                       return 'Please enter your password';
// //                     }
// //                     return null;
// //                   },
// //                 ),
// //                 SizedBox(height: 24),
// //                 // Login Button
// //                 ElevatedButton(
// //                   onPressed: _login,
// //                   child: Text('Login'),
// //                   style: ElevatedButton.styleFrom(
// //                     minimumSize: Size(double.infinity, 50), // Full-width button
// //                   ),
// //                 ),
// //                 SizedBox(height: 16),
// //                 // Forgot Password Link
// //                 TextButton(
// //                   onPressed: () {
// //                     Navigator.pushNamed(context, '/forgot-password');
// //                   },
// //                   child: Text('Forgot Password?'),
// //                 ),
// //                 // Signup Link
// //                 TextButton(
// //                   onPressed: () {
// //                     Navigator.pushNamed(context, '/signup');
// //                   },
// //                   child: Text('Don\'t have an account? Sign Up'),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }

// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   // Controllers to capture user input
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController passwordController = TextEditingController();

//   // Form key for validation
//   final _formKey = GlobalKey<FormState>();

//   // Firebase Auth instance
//   final FirebaseAuth auth = FirebaseAuth.instance;

//   // Function to handle login
//   Future<void> _login() async {
//     if (_formKey.currentState!.validate()) {
//       try {
//         // Sign in with email and password
//         await FirebaseAuth.instance.signInWithEmailAndPassword(
//           email: emailController.text,
//           password: passwordController.text,
//         );
//         // Navigate to Home Page on successful login
//         Navigator.pushReplacementNamed(context, '/home');
//       } on FirebaseAuthException catch (e) {
//         String message;
//         if (e.code == 'user-not-found') {
//           message = 'No user found for that email.';
//         } else if (e.code == 'wrong-password') {
//           message = 'Wrong password provided.';
//         } else if (e.code == 'invalid-email') {
//           message = 'Invalid email format.';
//         } else {
//           message = 'An error occurred. Please try again.';
//         }
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(message)),
//         );
//       }
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       // Optional: You can remove AppBar if not needed
//       appBar: AppBar(
//         title: Text('Login'),
//       ),
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             begin: Alignment.topLeft,
//             end: Alignment.bottomRight,
//             colors: [
//               Color(0xFF6A11CB), // Deep purple
//               Color(0xFF2575FC), // Vibrant blue
//             ],
//           ),
//         ),
//         height: double.infinity,
//         child: Center(
//           child: SingleChildScrollView(
//             padding: EdgeInsets.all(16.0),
//             child: Form(
//               key: _formKey, // Assign the form key
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: <Widget>[
//                   // App logo
//                   Padding(
//                     padding: const EdgeInsets.fromLTRB(0, 20, 0, 40),
//                     child: Center(
//                       child: Container(
//                         width: 150,
//                         height: 150,
//                         decoration: BoxDecoration(
//                           shape: BoxShape.circle,
//                           color: Colors.white.withOpacity(0.2),
//                           boxShadow: [
//                             BoxShadow(
//                               color: Colors.white.withOpacity(0.1),
//                               blurRadius: 20,
//                               spreadRadius: 5,
//                             ),
//                           ],
//                         ),
//                         child: ClipOval(
//                           child: Image.asset('images/logo.png'),
//                         ),
//                       ),
//                     ),
//                   ),
//                   // Email Field
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 30),
//                     child: TextFormField(
//                       controller: emailController,
//                       style: TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30),
//                           borderSide: BorderSide.none,
//                         ),
//                         labelText: 'Phone number, email or username',
//                         hintText: 'Enter valid email id as abc@gmail.com',
//                         labelStyle: TextStyle(color: Colors.white70),
//                         hintStyle: TextStyle(color: Colors.white54),
//                         filled: true,
//                         fillColor: Colors.white.withOpacity(0.1),
//                         prefixIcon: Icon(Icons.person, color: Colors.white70),
//                       ),
//                       validator: (value) {
//                         // Basic email validation
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your email';
//                         }
//                         if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
//                           return 'Please enter a valid email address';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   // Password Field
//                   Padding(
//                     padding: EdgeInsets.symmetric(horizontal: 30),
//                     child: TextFormField(
//                       controller: passwordController,
//                       obscureText: true,
//                       style: TextStyle(color: Colors.white),
//                       decoration: InputDecoration(
//                         border: OutlineInputBorder(
//                           borderRadius: BorderRadius.circular(30),
//                           borderSide: BorderSide.none,
//                         ),
//                         labelText: 'Password',
//                         hintText: 'Enter secure password',
//                         labelStyle: TextStyle(color: Colors.white70),
//                         hintStyle: TextStyle(color: Colors.white54),
//                         filled: true,
//                         fillColor: Colors.white.withOpacity(0.1),
//                         prefixIcon: Icon(Icons.lock, color: Colors.white70),
//                       ),
//                       validator: (value) {
//                         if (value == null || value.isEmpty) {
//                           return 'Please enter your password';
//                         }
//                         return null;
//                       },
//                     ),
//                   ),
//                   SizedBox(height: 40),
//                   // Login Button
//                   Container(
//                     width: 300,
//                     height: 50,
//                     child: ElevatedButton(
//                       onPressed: _login,
//                       child: Text(
//                         'Log in',
//                         style: TextStyle(color: Colors.white, fontSize: 18),
//                       ),
//                       style: ElevatedButton.styleFrom(
//                         backgroundColor: Color(0xFF4776E6),
//                         shape: RoundedRectangleBorder(
//                           borderRadius: BorderRadius.circular(25),
//                         ),
//                         elevation: 5,
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   // Forgot Password Link
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pushNamed(context, '/forgot-password');
//                     },
//                     child: Text(
//                       'Forgot Password?',
//                       style: TextStyle(
//                           color: Colors.white70, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                   // Signup Link
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pushNamed(context, '/signup');
//                     },
//                     child: Text(
//                       'Don\'t have an account? Sign Up',
//                       style: TextStyle(
//                           color: Colors.white, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:carousel_slider/carousel_slider.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  // List of image paths for the slider
  final List<String> imgList = [
    'images/b1.png',
    'images/b2.png',
    'images/b3.png',
    'images/b4.png',
  ];

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim(),
        );
        Navigator.pushReplacementNamed(context, '/home');
      } on FirebaseAuthException catch (e) {
        String message;
        switch (e.code) {
          case 'user-not-found':
            message = 'No user found for that email.';
            break;
          case 'wrong-password':
            message = 'Wrong password provided.';
            break;
          case 'invalid-email':
            message = 'Invalid email format.';
            break;
          default:
            message = 'An error occurred. Please try again.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF6A11CB), // Deep purple
              Color(0xFF2575FC), // Vibrant blue
            ],
          ),
        ),
        height: double.infinity,
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              // Image Slider
              CarouselSlider(
                options: CarouselOptions(
                  height: 200.0,
                  enlargeCenterPage: true,
                  autoPlay: true,
                  aspectRatio: 16 / 9,
                  autoPlayCurve: Curves.fastOutSlowIn,
                  enableInfiniteScroll: true,
                  autoPlayAnimationDuration: Duration(milliseconds: 800),
                  viewportFraction: 0.8,
                ),
                items: imgList
                    .map((item) => Container(
                          child: Center(
                            child: Image.asset(item,
                                fit: BoxFit.cover, width: 1000),
                          ),
                        ))
                    .toList(),
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: TextFormField(
                          controller: emailController,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            labelText: 'Email',
                            hintText: 'Enter valid email id as abc@gmail.com',
                            labelStyle: TextStyle(color: Colors.white70),
                            hintStyle: TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            prefixIcon:
                                Icon(Icons.person, color: Colors.white70),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your email';
                            }
                            if (!RegExp(
                                    r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$')
                                .hasMatch(value)) {
                              return 'Please enter a valid email address';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 20),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30),
                        child: TextFormField(
                          controller: passwordController,
                          obscureText: true,
                          style: TextStyle(color: Colors.white),
                          decoration: InputDecoration(
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            labelText: 'Password',
                            hintText: 'Enter secure password',
                            labelStyle: TextStyle(color: Colors.white70),
                            hintStyle: TextStyle(color: Colors.white54),
                            filled: true,
                            fillColor: Colors.white.withOpacity(0.1),
                            prefixIcon: Icon(Icons.lock, color: Colors.white70),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your password';
                            }
                            return null;
                          },
                        ),
                      ),
                      SizedBox(height: 40),
                      Container(
                        width: 300,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: _login,
                          child: Text(
                            'Log in',
                            style: TextStyle(color: Colors.white, fontSize: 18),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Color(0xFF4776E6),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            elevation: 5,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/forgot-password');
                        },
                        child: Text(
                          'Forgot Password?',
                          style: TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/signup');
                        },
                        child: Text(
                          'Don\'t have an account? Sign Up',
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
