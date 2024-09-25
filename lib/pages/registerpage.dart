// ignore_for_file: library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:mini_chat_app/services/auth/auth_service.dart';
import 'package:mini_chat_app/components/my_btn.dart';
import 'package:mini_chat_app/components/my_text_field.dart';

class RegisterPage extends StatefulWidget {
  final void Function()? onTap;

  const RegisterPage({
    super.key,
    required this.onTap,
  });

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cpasswordController = TextEditingController();

  bool _isChecked = false; // State for checkbox
  bool _isTermsRead = false; // State for terms and conditions
  // show erro msg
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

  void _showTermsDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Terms and Conditions'),
        content: const SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(
                  'Please read and agree to the following terms before registering:'),
              SizedBox(height: 20),
              Text(
                '1. Please add your name in the email before entering the @.... ',
                style: TextStyle(fontSize: 19),
              ),
              SizedBox(height: 17),
              Text('2. Password must be at least 6 characters long.'),
              SizedBox(height: 17),
              Text(
                  '3. Reseting of password impossible ,so don\'t forgot your password 😊',
                  style: TextStyle(fontSize: 19)),
              SizedBox(height: 20),
              Text(
                  'By checking the box, you agree to our Terms and Conditions.'),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Agree'),
            onPressed: () {
              Navigator.of(context).pop();
              setState(() {
                _isTermsRead = true; // Mark terms as read
                // Enable the checkbox after agreeing
                _isChecked = true; // Ensure checkbox starts as unchecked
              });
            },
          ),
          TextButton(
            child: const Text('Cancel'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  void register(BuildContext context) async {
    final authServices = AuthServices();

    // Check if terms and conditions are accepted
    if (!_isChecked) {
      if (!_isTermsRead) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'Please read and agree to the Terms and Conditions before registering.'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text(
                'You must agree to the Terms and Conditions to register.'),
            backgroundColor: Colors.red.shade700,
          ),
        );
      }
      return; // Exit early if terms are not agreed
    }

    // Check if fields are empty
    if ( //_nameController.text.isEmpty ||
        _emailController.text.isEmpty ||
            _passwordController.text.isEmpty ||
            _cpasswordController.text.isEmpty) {
      showConditionSnackBar(
        context,
        "Please Enter all the details!",
      );
      return; // Exit early if fields are empty
    }

    // Validate name length
    if (_nameController.text.length > 20) {
      showConditionSnackBar(
        context,
        "Name cannot exceed 20 characters!",
      );
      return; // Exit early if fields are empty/ Exit early if name is too long
    }

    // Validate password length
    if (_passwordController.text.length < 6) {
      showConditionSnackBar(
        context,
        "Password must be at least 6 characters long!",
      );
      return; // Exit early if fields are empty
    }

    // Validate email format
    if (!_emailController.text.contains('@') ||
        !_emailController.text.contains('.')) {
      showConditionSnackBar(
        context,
        "Please provide a valid email address!",
      );
      return; // Exit early if fields are empty
    }

    // Check if passwords match
    if (_passwordController.text != _cpasswordController.text) {
      showConditionSnackBar(
        context,
        "Psswords dose not match!",
      );
      return; // Exit early if fields are empty
    }

    // Attempt to register the user
    try {
      await authServices.signUpWithEmailAndPassword(
        _emailController.text,
        _passwordController.text,
      );
      // Registration successful, navigate to another page or show a success message
    } catch (e) {
      showConditionSnackBar(
        // ignore: use_build_context_synchronously
        context,
        e.toString(),
      );
      return; // Exit early if fields are empty
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
                    color: Theme.of(context).colorScheme.tertiary,
                    fontSize: 17,
                    fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 50),
              MyTextField(
                hinttext: "Email",
                obscuretxt: false,
                controller: _emailController,
                focusNode: null,
              ),
              const SizedBox(height: 10),
              MyTextField(
                hinttext: "Password",
                obscuretxt: true,
                controller: _passwordController,
                focusNode: null,
              ),
              const SizedBox(height: 10),
              MyTextField(
                hinttext: "Retype Password",
                obscuretxt: true,
                controller: _cpasswordController,
                focusNode: null,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Checkbox(
                    value: _isChecked,
                    onChanged: _isTermsRead
                        ? (bool? value) {
                            setState(() {
                              _isChecked = value ?? false;
                            });
                          }
                        : null, // Disable checkbox if terms not read
                  ),
                  GestureDetector(
                    onTap: _showTermsDialog, // Show dialog when text is tapped
                    child: const Text(
                      'I agree to the Terms and Conditions',
                      style: TextStyle(
                          fontSize: 14, decoration: TextDecoration.underline),
                    ),
                  ),
                ],
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
                    onTap: widget.onTap,
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
