import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:mns_final/common/loading_page.dart';
import '../../../Constants/constants.dart';
import '../../../common/common.dart';
import '../../../theme/theme.dart';
import '../controller/auth_controller.dart';
import '../widgets/auth_field.dart';
import 'login_view.dart';

class SignupView extends ConsumerStatefulWidget {
  static route () =>  MaterialPageRoute(builder: (context) => const SignupView());

  const SignupView({super.key});

  @override
  ConsumerState<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView> {
  final appbar = UIConstants.appBar();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void onSignUp() { 
    ref.read(authControllerProvider.notifier).signUp(
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
      body: 
      isLoading
      ? const Loader() 
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
                child: RoundedSmallButton(onTap: onSignUp, label: 'Sign Up',),),
              const SizedBox(height: 40),
              //textspan
              RichText(text: TextSpan(
                text: 'Already have an account? ',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
                children: [
                  TextSpan(
                    text: 'Login',
                    style: const TextStyle(
                      color: Pallete.blueColor,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    recognizer: TapGestureRecognizer()..onTap = () {
                      // Navigate to Login page
                      Navigator.push(context,LoginView.route());

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