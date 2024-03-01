import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:hobby_generator/screens/register_screen.dart';
import 'package:hobby_generator/screens/tab_screen.dart';
import 'package:hobby_generator/screens/widgets/button_widget.dart';
import 'package:hobby_generator/screens/widgets/custom_text_field.dart';


class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var _isEmailValid = false;
  var _isPasswordValid = false;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future signIn() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(
            email: emailController.text, password: passwordController.text)
        .then((value) => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const TabScreen(),
            )).then((value) => Navigator.pop(context)));
  }

  void validatePassword(String value) {
    RegExp regex =
        RegExp(r'^(?=.*?[A-Z])(?=.*?[a-z])(?=.*?[0-9])(?=.*?[!@#\$&*~]).{8,}$');
    if (value.isEmpty) {
      _isPasswordValid = false;
    } else {
      if (!regex.hasMatch(value)) {
        _isPasswordValid = false;
      } else {
        _isPasswordValid = true;
      }
    }
  }

  void validateEmail(String email) {
    _isEmailValid = EmailValidator.validate(email);
  }

  void validationMessage(bool email, bool password) {
    if (_isEmailValid == true && _isPasswordValid) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.amber,
        content: Text("Success"),
      ));
    } else if (_isEmailValid == true && _isPasswordValid == false) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Password Fail"),
      ));
    } else if (_isEmailValid == false && _isPasswordValid == true) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text("Email Fail"),
      ));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        backgroundColor: Colors.green,
        content: Text("All Fail"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.amber,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
               
                const SizedBox(height: 20),
                const Text(
                  "Welcome to Hobby Generator",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                ),
                const SizedBox(height: 20),
                CustomTextField(
                    iconData: Icons.person,
                    controller: emailController,
                    hintText: "Email address",
                    iconColor: Colors.green,
                    inputType: TextInputType.emailAddress,
                    title: "Email"),
                const SizedBox(height: 20),
                CustomTextField(
                  controller: passwordController,
                  hintText: "Password",
                  inputType: TextInputType.visiblePassword,
                  title: "Password",
                  iconColor: Colors.red,
                  obscureText: true,
                  iconData: Icons.lock,
                ),
                const SizedBox(height: 20),
                ButtonWidget(
                  onPressed: () {
                    signIn();
                  },
                  buttonText: "Sign In",
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Don't have an account?"),
                    TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RegisterScreen(),
                            ),
                          );
                        },
                        child: const Text("Now Sign Up!")),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
