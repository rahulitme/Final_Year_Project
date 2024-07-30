// import 'package:flutter/material.dart';
// import 'package:firebase_auth/firebase_auth.dart';

// class LoginPage extends StatefulWidget {
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final _formKey = GlobalKey<FormState>();
//   String _email = '';
//   String _password = '';
//   String _error = '';



// // loginCheck() async {
// //     // _normalProgress(context);
// //     try {
// //       final User? firebaseUser = (await fAuth.signInWithEmailAndPassword(
// //               email: EmailEditingController.text,
// //               password: passwordEditingController.text))
// //           .user;
// //       if (firebaseUser != null) {
// //         DatabaseEvent event = await FirebaseDatabase.instance
// //             .ref()
// //             .child('users')
// //             .orderByChild('email')
// //             .equalTo(EmailEditingController.text)
// //             .once();
// //         DataSnapshot snapshot = event.snapshot;

// //         if (snapshot.value != null) {
// //           Map<dynamic, dynamic> userData =
// //               snapshot.value as Map<dynamic, dynamic>;

// //           if (userData.isNotEmpty) {
// //             var userKey = userData.keys.first;
// //             var user = userData[userKey];

// //             bool isBlocked = user['blocked'] ?? false;

// //             if (isBlocked) {
// //               Navigator.pushReplacement(
// //                   context, MaterialPageRoute(builder: (c) => MySplashScreen()));

// //               Fluttertoast.showToast(msg: "You are blocked. Cannot log in.");
// //             } else {
// //               currentFirebaseUser = firebaseUser;
// //               Fluttertoast.showToast(msg: "Login Successfull");

// //               Navigator.push(
// //                   context, MaterialPageRoute(builder: (c) => main_homepage()));
// //             }
// //             return;
// //           }
// //         }
// //       } else {
// //         Navigator.of(context).pop();
// //         Fluttertoast.showToast(
// //           msg: "Error Login!",
// //         );
// //       }
// //     } catch (e) {
// //       Navigator.push(context, MaterialPageRoute(builder: (c) => Login()));
// //       Fluttertoast.showToast(msg: "Error Login!");
// //     }
// //   }






//   void _submitForm() async {
//     if (_formKey.currentState!.validate()) {
//       _formKey.currentState!.save();
//       // try {
//       //   await FirebaseAuth.instance.signInWithEmailAndPassword(
//       //     email: _email,
//       //     password: _password,
//       //   );
//       //   Navigator.pushReplacementNamed(context, '/main');
//       // } 
//       // on FirebaseAuthException catch (e) {
//       //   setState(() {
//       //     _error = e.message ?? 'An error occurred';
//       //   });
//       // }



//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text('Login')),
//       body: Form(
//         key: _formKey,
//         child: Padding(
//           padding: EdgeInsets.all(16.0),
//           child: Column(
//             children: [
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Email'),
//                 validator: (value) => value!.isEmpty ? 'Enter an email' : null,
//                 onSaved: (value) => _email = value!,
//               ),
//               TextFormField(
//                 decoration: InputDecoration(labelText: 'Password'),
//                 obscureText: true,
//                 validator: (value) => value!.isEmpty ? 'Enter a password' : null,
//                 onSaved: (value) => _password = value!,
//               ),
//               SizedBox(height: 20),
//               ElevatedButton(
//                 onPressed: _submitForm,
//                 child: Text('Login'),
//               ),
//               if (_error.isNotEmpty)
//                 Text(_error, style: TextStyle(color: Colors.red)),
//               TextButton(
//                 onPressed: () => Navigator.pushNamed(context, '/forgot_password'),
//                 child: Text('Forgot Password?'),
//               ),
//               TextButton(
//                 onPressed: () => Navigator.pushNamed(context, '/signup'),
//                 child: Text('Create an Account'),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }