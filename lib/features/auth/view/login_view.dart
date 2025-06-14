import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mns_final/Constants/ui_constants.dart';
import 'package:mns_final/common/loading_page.dart';
import 'package:mns_final/common/rounded_small_button.dart';
import 'package:mns_final/features/auth/view/signup_view.dart';
import 'package:mns_final/theme/theme.dart';

import '../controller/auth_controller.dart';
import '../widgets/auth_field.dart';

class LoginView extends ConsumerStatefulWidget {
  const LoginView({super.key});

  static route () =>  MaterialPageRoute(builder: (context) => const LoginView());
  @override
  ConsumerState<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends ConsumerState<LoginView> {
  final appbar = UIConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onLogin() { 
    ref.read(authControllerProvider.notifier).login(
      email: emailController.text.trim(),
      password: passwordController.text.trim(),
      context: context,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(authControllerProvider);
    return Scaffold(  
      appBar: appbar,
      body:  isLoading
      ?Loader()
      : Center(
        child: SingleChildScrollView(
          child: Padding(padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              //textfield1
              AuthField(controller: emailController, hintText: 'Email'),
              const SizedBox(height: 25),
              //textfield2
              AuthField(controller: passwordController, hintText: 'Password'),
              const SizedBox(height: 40),
              //button  
              Align(
                alignment: Alignment.topRight,
                child: RoundedSmallButton(onTap: onLogin, label: 'Login')),
              const SizedBox(height: 40),
              //textspan
              RichText(text: TextSpan(
                text: 'Don\'t have an account? ',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: 'Sign Up',
                    style: const TextStyle(
                      color: Pallete.blueColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      // Navigate to Sign Up page
                      Navigator.push(context,SignupView.route());
                    },
                  ),
                ],
              )),
              

            ],
          ),),
        ),
      ),
    );
  }
}

