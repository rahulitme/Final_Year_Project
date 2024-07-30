import 'package:color_detector_app/global.dart';
import 'package:color_detector_app/home_page.dart';
import 'package:flutter/material.dart';


class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}
TextEditingController emailEditingController = TextEditingController();
  TextEditingController passwordEditingController = TextEditingController();
class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';
  String _error = '';

  void _submitForm() async {
  try{
    final User? firebaseUser = (await fAuth.createUserWithEmailAndPassword(
            email: emailEditingController.text.trim(),
            password: passwordEditingController.text.trim()))
        .user;

    if (firebaseUser != null) {
      Map usersMap = {
        "id": firebaseUser.uid,
        // "name": nameEditingController.text.trim(),
        "email": emailEditingController.text.trim(),
      };
      DatabaseReference userssref =
          FirebaseDatabase.instance.ref().child("users");
      userssref.child(firebaseUser.uid).set(usersMap);

      currentFirebaseUser = firebaseUser;
      // Fluttertoast.showToast(msg: "Account created Successfully");

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (c) => main_homepage()));
    }
    ///////

    else {
      Navigator.of(context).pop();
      // Fluttertoast.showToast(msg: "Account not created!");
    }
    }on FirebaseAuthException catch (e) {
    if (e.code == 'email-already-in-use') { 
      // Fluttertoast.showToast(msg: "This email address is already registered! ");
      Navigator.of(context).pop();
      Navigator.push(
          context, MaterialPageRoute(builder: (c) => Login()));
      
    } 
  }}
    
  
  



    
    // if (_formKey.currentState!.validate()) {
    //   _formKey.currentState!.save();
    //   try {
    //     await FirebaseAuth.instance.createUserWithEmailAndPassword(
    //       email: _email,
    //       password: _password,
    //     );
    //     Navigator.pushReplacementNamed(context, '/main');
    //   } on FirebaseAuthException catch (e) {
    //     setState(() {
    //       _error = e.message ?? 'An error occurred';
    //     });
    //   }
    // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            children: [
              TextFormField(controller: emailEditingController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Enter an email' : null,
                onSaved: (value) => _email = value!,
              ),
              TextFormField(controller: passwordEditingController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Enter a password' : null,
                onSaved: (value) => _password = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _submitForm,
                child: Text('Sign Up'),
              ),
              if (_error.isNotEmpty)
                Text(_error, style: TextStyle(color: Colors.red)),
            ],
          ),
        ),
      ),
    );
  }
}