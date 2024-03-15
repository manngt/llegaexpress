import 'package:flutter/material.dart';
import 'package:llegaexpress/models/transfer/customer_verify_response.dart';
import 'package:llegaexpress/screens/transfer/registration_notice_screen.dart';
import 'package:llegaexpress/screens/transfer/transfer_screen.dart';
import 'package:llegaexpress/services/transfer_services.dart';
import 'package:llegaexpress/widgets/option_button.dart';
import 'package:llegaexpress/widgets/exit_floating_action_button.dart';

class CustomerVerifyForm extends StatefulWidget {
  const CustomerVerifyForm({Key? key}) : super(key: key);

  @override
  _CustomerVerifyFormState createState() => _CustomerVerifyFormState();
}

class _CustomerVerifyFormState extends State<CustomerVerifyForm> {
  final _formKey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> scaffoldStateKey = GlobalKey<ScaffoldState>();
  final _phoneController = TextEditingController();
  bool isProcessing = false;

  //Check response
  _checkResponse(BuildContext context, dynamic json) async {
    if (json['ErrorCode'] == 0) {
      CustomerVerifyResponse customerVerifyResponse =
          CustomerVerifyResponse.fromJson(json);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const TransferScreen(),
        ),
      );
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => const RegistrationNotice(),
        ),
      );
    }
  }

  //Reset form
  _resetForm() {
    setState(() {
      isProcessing = false;
      _phoneController.text = '';
    });
  }

  //Execute registration
  _executeTransaction(BuildContext context) async {
    setState(() {
      isProcessing = true;
    });
    await TransferServices.getCustomerVerify(_phoneController.text)
        .then((response) => {
              if (response['ErrorCode'] != null)
                {
                  _checkResponse(context, response),
                }
            })
        .catchError((error) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            error.toString(),
            style: const TextStyle(
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red,
        ),
      );
      _resetForm();
    });
    _resetForm();
  }

  @override
  Widget build(BuildContext context) {
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return WillPopScope(
      child: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/backgrounds/transfer_background.jpg'),
            fit: BoxFit.cover,
          ),
        ),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          key: scaffoldStateKey,
          body: Builder(
            builder: (context) => Form(
              key: _formKey,
              child: SizedBox(
                width: screenWidth,
                height: screenHeight,
                child: Stack(
                  children: [
                    Positioned(
                      child: Container(
                        height: screenHeight,
                        width: 300,
                        padding: const EdgeInsets.only(left: 20.0),
                        child: ListView(
                          children: [
                            const Center(
                              child: Text(
                                'Validar Numero',
                                style: TextStyle(
                                    color: Color(0xFF0e2338),
                                    fontSize: 14,
                                    fontWeight: FontWeight.w900),
                              ),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            const SizedBox(
                              height: 30.0,
                            ),
                            Container(
                              child: TextFormField(
                                decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    hintText: 'Número teléfono Guatemala *',
                                    errorStyle: TextStyle(
                                      fontSize: 8,
                                    )),
                                keyboardType: TextInputType.phone,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Campo obligatorio';
                                  }
                                  if (value.length < 8) {
                                    return 'Mínimo 8 caracteres';
                                  }
                                  if (value.length > 8) {
                                    return 'Máximo 8 caracteres';
                                  }
                                },
                                controller: _phoneController,
                              ),
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(25.0)),
                              ),
                              height: 50.0,
                              margin: const EdgeInsets.only(bottom: 5.0),
                              padding: const EdgeInsets.only(left: 10.0),
                            ),
                            const SizedBox(
                              height: 20.0,
                            ),
                            OptionButton(
                              label: 'Validar',
                              onPress: () {
                                if (_formKey.currentState!.validate()) {
                                  _executeTransaction(context);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      top: 125.0,
                      left: (screenWidth - 300) / 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
          floatingActionButton: ExitFloatingActionButton(
            context: context,
          ),
        ),
      ),
      onWillPop: () async => true,
    );
  }
}
