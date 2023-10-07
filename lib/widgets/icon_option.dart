import 'package:flutter/material.dart';

class IconOption extends StatelessWidget {
  final String img;
  final VoidCallback onPress;

  const IconOption({
    Key? key,
    required this.img,
    required this.onPress,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 50.0,
      width: 50.0,
      decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.all(Radius.circular(25))),
      margin: const EdgeInsets.only(right: 5.0),
      child: TextButton(
        child: Image.asset(
          img,
          fit: BoxFit.cover,
        ),
        onPressed: onPress,
      ),
    );
  }
}
