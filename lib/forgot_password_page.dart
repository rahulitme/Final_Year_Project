// forgot_password_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  // Controller to capture email input
  final TextEditingController emailController = TextEditingController();

  // Form key for validation
  final _formKey = GlobalKey<FormState>();

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Function to handle password reset
  Future<void> _resetPassword() async {
    if (_formKey.currentState!.validate()) {
      try {
        // Send password reset email
        await _auth.sendPasswordResetEmail(
          email: emailController.text.trim(),
        );

        // Inform the user that the email has been sent
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Password reset email sent.')),
        );

        // Optionally, navigate back to the login page
        Navigator.pop(context);
      } on FirebaseAuthException catch (e) {
        // Display error message
        String message;
        if (e.code == 'user-not-found') {
          message = 'No user found for that email.';
        } else {
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
      // Optional: You can remove AppBar if not needed
      appBar: AppBar(
        title: Text('Forgot Password'),
      ),
      body: Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, // Assign the form key
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                // Instruction Text
                Text(
                  'Enter your email to receive a password reset link.',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 24),
                // Email Field
                TextFormField(
                  controller: emailController,
                  decoration: InputDecoration(labelText: 'Email'),
                  validator: (value) {
                    // Basic email validation
                    if (value == null || value.isEmpty) {
                      return 'Please enter your email';
                    }
                    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                      return 'Please enter a valid email address';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 24),
                // Reset Password Button
                ElevatedButton(
                  onPressed: _resetPassword,
                  child: Text('Reset Password'),
                  style: ElevatedButton.styleFrom(
                    minimumSize: Size(double.infinity, 50), // Full-width button
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
