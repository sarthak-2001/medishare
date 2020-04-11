import 'package:medishare/components/rounded_button.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'registration_screen.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'WelcomeScreen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: Container(
                    child: Image.asset('images/logo.jpeg'),
                    height: 60.0,
                  ),
                ),
                Text(
                  'Medishare',
                  style: TextStyle(
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            RoundedButton(
              title: 'Log In',
              colour: Colors.lightBlueAccent,
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => LoginScreen()));
              },
            ),
            RoundedButton(
                title: 'Register',
                colour: Colors.blueAccent,
                onPressed: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => RegistrationScreen()));
                }),
          ],
        ),
      ),
    );
  }
}
