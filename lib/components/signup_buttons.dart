import 'package:sperro_neu/components/custom_icon_button.dart';
import 'package:sperro_neu/constants/colors.dart';
import 'package:sperro_neu/screens/auth/phone_auth_screen.dart';
import 'package:sperro_neu/services/auth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:sperro_neu/screens/home_screen.dart';

class SignUpButtons extends StatefulWidget {
  const SignUpButtons({Key? key}) : super(key: key);

  @override
  State<SignUpButtons> createState() => _SignUpButtonsState();
}

class _SignUpButtonsState extends State<SignUpButtons> {
  final Auth authService = Auth(); // Keep Auth instance final for immutability

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const PhoneAuthScreen(isFromLogin: false),
              ),
            );
          },
          child: CustomIconButton(
            text: 'Signup with Phone',
            imageIcon: 'assets/phone.png',
            bgColor: greyColor,
            imageOrIconColor: whiteColor,
            imageOrIconRadius: 20,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
        InkWell(
          onTap: () async {
            try {
              print("Google SignUp button clicked");
              User? user = await Auth.signInWithGoogle(
                  context: context); // Accessing the static method correctly
              if (user != null) {
                print("Google Sign-In successful");
                await authService.getAdminCredentialPhoneNumber(context, user);
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        HomeScreen(), // Replace with your home screen
                  ),
                );
              } else {
                print("Google Sign-In returned null user");
              }
            } catch (e) {
              print("Error during Google Sign-In: $e");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Error during Google Sign-In: $e')),
              );
            }
          },
          child: CustomIconButton(
            text: 'Signup with Google',
            imageIcon: 'assets/google.png',
            bgColor: whiteColor,
          ),
        ),
        const SizedBox(
          height: 10,
        ),
      ],
    );
  }
}
