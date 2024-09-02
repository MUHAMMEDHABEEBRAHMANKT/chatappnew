import 'package:flutter/material.dart';
import 'package:mini_chat_app/services/auth/auth_service.dart';
import 'package:mini_chat_app/components/my_btn.dart';
import 'package:mini_chat_app/components/my_text_field.dart';

class LoginPage extends StatelessWidget {
  ///email and pass controller
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  //tap to go register page
  final void Function()? onTap;

  LoginPage({
    super.key,
    required this.onTap,
  });

//login method
  void login(BuildContext context) async {
    // Auth services
    final authServices = AuthServices();

    // Try to login
    try {
      if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "Please Enter the Details!",
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
      } else {
        await authServices.signInWithEmailAndPassword(
            _emailController.text, _passwordController.text);
      }
    }
    // Catch errors
    catch (e) {
      // Show error dialog
      // ignore: use_build_context_synchronously
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
              //logo
              const SizedBox(
                height: 50,
              ),
              Icon(
                Icons.message,
                size: 60,
                color: Colors.grey.shade700,
              ),
              const SizedBox(
                height: 50,
              ),
              //welcome back mesg

              Text(
                "Welcome Back, You've been missed!",
                style: TextStyle(
                    color: Theme.of(context).colorScheme.onTertiary,
                    fontSize: 17),
              ),
              const SizedBox(
                height: 50,
              ),

              //email txt fiels

              MyTextField(
                hinttext: "Email",
                obscuretxt: false,
                controller: _emailController,
              ),
              //password txt field
              const SizedBox(
                height: 20,
              ),

              MyTextField(
                hinttext: "Password",
                obscuretxt: true,
                controller: _passwordController,
              ),

              const SizedBox(
                height: 35,
              ),
              //login btn

              MyBtn(
                btntxt: "Login ",
                onTap: () => login(context),
              ),

              const SizedBox(
                height: 20,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Not a member ? ',
                    style:
                        TextStyle(color: Theme.of(context).colorScheme.primary),
                  ),
                  GestureDetector(
                    onTap: onTap,
                    child: Text(
                      'Register now ',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ),
                ],
              ),
              //register
            ],
          ),
        ),
      ),
    );
  }
}
