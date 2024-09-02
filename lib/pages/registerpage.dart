import 'package:flutter/material.dart';
import 'package:mini_chat_app/services/auth/auth_service.dart';
import 'package:mini_chat_app/components/my_btn.dart';
import 'package:mini_chat_app/components/my_text_field.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();

  final void Function()? onTap;

  RegisterPage({
    super.key,
    required this.onTap,
  });

  void register(BuildContext context) async {
    final authServices = AuthServices();

    // Check if fields are empty
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _cpasswordController.text.isEmpty) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Please Enter all the details!",
            style: TextStyle(color: Colors.red.shade700),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
      return; // Exit early if fields are empty
    }

    // Check if passwords match
    if (_passwordController.text != _cpasswordController.text) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Passwords don't match!",
            style: TextStyle(color: Colors.red.shade700),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('Close'),
            ),
          ],
        ),
      );
      return; // Exit early if passwords don't match
    }

    // Attempt to register the user
    try {
      await authServices.signUpWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
      // Registration successful, navigate to another page or show a success message
    } catch (e) {
      showDialog(
        // ignore: use_build_context_synchronously
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Error'),
          content: Text(e.toString()),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Dismiss the dialog
              },
              child: const Text('Close'),
            ),
          ],
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 30),
              Icon(
                Icons.lock_open_rounded,
                size: 60,
                color: Colors.grey[700],
              ),
              const SizedBox(height: 40),
              Text(
                "Create an account to get started!",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 50),
              MyTextField(
                hinttext: "Email",
                obscuretxt: false,
                controller: _emailController,
              ),
              const SizedBox(height: 10),
              MyTextField(
                hinttext: "Password",
                obscuretxt: true,
                controller: _passwordController,
              ),
              const SizedBox(height: 10),
              MyTextField(
                hinttext: "Retype Password",
                obscuretxt: true,
                controller: _cpasswordController,
              ),
              const SizedBox(height: 25),
              MyBtn(
                btntxt: "Register",
                onTap: () => register(context),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Already have an account? ',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      'Login now ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
