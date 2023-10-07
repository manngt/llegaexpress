import 'package:flutter/material.dart';
import 'package:llegaexpress/screens/procedure_screen.dart';
import 'package:llegaexpress/screens/recharge_screen.dart';
import 'package:llegaexpress/screens/shop_screen.dart';

class GlobalOptionsWidget extends StatelessWidget {
  GlobalOptionsWidget(
      {Key? key,
      required this.screenMiddleHeight,
      required this.screenWidth,
      required this.activeGlobalOption})
      : super(key: key);

  final screenMiddleHeight;
  final screenWidth;
  final String activeGlobalOption;
  @override
  Widget build(BuildContext context) {
    return Positioned(
      child: SizedBox(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              child: Ink(
                child: Column(
                  children: [
                    Container(
                      child: IconButton(
                        icon: Image.asset('images/icons/recharge_icon.png'),
                        onPressed: () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const RechargeScreen(),
                            ),
                          );
                        },
                        iconSize: 30,
                      ),
                      decoration: BoxDecoration(
                        color: activeGlobalOption == 'recharge'
                            ? const Color(0XFF86C0E7)
                            : const Color(0xFF0E325F),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            10,
                          ),
                        ),
                      ),
                    ),
                    const Text(
                      'Recargas',
                      style: TextStyle(color: Colors.white, fontSize: 10.0),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                ),
              ),
              height: 75,
              width: 75,
            ),
            SizedBox(
              child: Ink(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: activeGlobalOption == 'shop'
                            ? const Color(0XFF86C0E7)
                            : const Color(0xFF0E325F),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            10,
                          ),
                        ),
                      ),
                      child: IconButton(
                        icon: Image.asset('images/icons/shop_icon.png'),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const ShopScreen()));
                        },
                        iconSize: 30,
                      ),
                    ),
                    const Text(
                      'Compras',
                      style: TextStyle(color: Colors.white, fontSize: 10.0),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                ),
              ),
              height: 75,
              width: 75,
            ),
            SizedBox(
              child: Ink(
                child: Column(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: activeGlobalOption == 'procedure'
                            ? const Color(0XFF86C0E7)
                            : const Color(0xFF0E325F),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(
                            10,
                          ),
                        ),
                      ),
                      child: IconButton(
                        icon: Image.asset('images/icons/procedure_icon.png'),
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const ProcedureScreen()));
                        },
                        iconSize: 30,
                      ),
                    ),
                    const Text(
                      'Gestiones',
                      style: TextStyle(color: Colors.white, fontSize: 10.0),
                    ),
                  ],
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                ),
              ),
              height: 75,
              width: 75,
            ),
          ],
        ),
        height: 150,
        width: 325,
      ),
      top: screenMiddleHeight - 200,
      left: (screenWidth - 325) / 2,
    );
  }
}
