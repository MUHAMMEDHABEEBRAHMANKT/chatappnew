import 'package:flutter/material.dart';

class MyBtn extends StatelessWidget {
  final String btntxt;
  final void Function()? onTap;

  const MyBtn({
    super.key,
    required this.btntxt,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(9),
        ),
        padding: const EdgeInsets.all(25),
        margin: const EdgeInsets.symmetric(horizontal: 45),
        child: Center(
            child: Text(
          btntxt,
          style: const TextStyle(fontSize: 18),
        )),
      ),
    );
  }
}
