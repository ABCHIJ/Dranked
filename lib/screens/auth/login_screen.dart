import 'package:sperro_neu/components/large_heading_widget.dart';
import 'package:sperro_neu/constants/colors.dart';
import 'package:sperro_neu/forms/login_form.dart';

import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  static const String id = 'login_screen';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: whiteColor,
      body: _body(),
    );
  }

  _body() {
    return SingleChildScrollView(
      child:
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: const [
        LargeHeadingWidget(
            heading: 'Welcome', subHeading: 'Sign In to Continue'),
        LogInForm(),
      ]),
    );
  }
}
