import 'package:flutter/material.dart';

class IssueOptionsScreen extends StatefulWidget {
  const IssueOptionsScreen({Key? key}) : super(key: key);

  @override
  _IssueOptionsScreenState createState() => _IssueOptionsScreenState();
}

class _IssueOptionsScreenState extends State<IssueOptionsScreen>
    with WidgetsBindingObserver {
  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Container(
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage('images/backgrounds/white_with_log_background.png'),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Stack(
          children: [
            Positioned(
              child: SizedBox(
                child: Container(
                  decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(20.0),
                          topRight: Radius.circular(20.0)),
                      color: Colors.white),
                ),
                height: screenHeight * 0.80,
                width: screenWidth,
              ),
              top: 125.0,
            ),
          ],
        ),
      ),
    );
  }
}
