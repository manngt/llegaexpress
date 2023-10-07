import 'package:flutter/material.dart';

class OptionButton extends StatelessWidget {
  final String label;
  final VoidCallback onPress;

  const OptionButton({
    Key? key,
    required this.label,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 300,
      height: 50,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            Color(0xFF3b6da8),
            Color(0xFF224c96),
          ],
          stops: [
            0.1,
            0.9,
          ],
        ),
        borderRadius: BorderRadius.all(
          Radius.circular(25.0),
        ),
      ),
      child: Center(
          child: TextButton(
        child: Text(label),
        onPressed: onPress,
        style: TextButton.styleFrom(
          foregroundColor: Colors.white,
          backgroundColor: Colors.transparent,
          minimumSize: const Size(300.0, 50.0),
          textStyle: const TextStyle(
            fontSize: 20,
          ),
        ),
      )),
    );
  }
}
