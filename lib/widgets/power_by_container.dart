import 'package:flutter/material.dart';

class PowerByContainer extends StatelessWidget {
  const PowerByContainer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: const Align(
        alignment: Alignment.center,
        child: Text(
          'Powered by GPS PAY WALLET',
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
      ),
      decoration: BoxDecoration(
          border: Border.all(
            width: 1,
            color: const Color(0xFFAFBECC),
          ),
          borderRadius: const BorderRadius.all(Radius.circular(10))),
      padding: const EdgeInsets.all(10.0),
      width: 300,
      height: 50,
    );
  }
}
