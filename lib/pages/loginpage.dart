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
// snack bar error msg custom
  void showConditionSnackBar(BuildContext context, String message,
      {Color backgroundColor = Colors.red}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
        ),
        backgroundColor: backgroundColor,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

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
        showConditionSnackBar(
          context,
          "Please Enter all the details!",
        );
        return; // Exit early if fields are empty
      }
      if (!_emailController.text.contains('@') ||
          !_emailController.text.contains('.')) {
        showConditionSnackBar(
          context,
          "Please provide a valid email address!",
        );
        return; // Exit early if fields are empty
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
                    color: Theme.of(context).colorScheme.tertiary,
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
                focusNode: null,
              ),
              //password txt field
              const SizedBox(
                height: 20,
              ),

              MyTextField(
                hinttext: "Password",
                obscuretxt: true,
                controller: _passwordController,
                focusNode: null,
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
