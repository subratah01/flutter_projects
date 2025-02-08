import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/services/network_caller.dart';
import 'package:task_manager/data/utils/urls.dart';
import 'package:task_manager/ui/screens/forgot_password_verify_email_screen.dart';
import 'package:task_manager/ui/screens/main_bottom_nav_screen.dart';
import 'package:task_manager/ui/screens/sign_up_screen.dart';
import 'package:task_manager/ui/widgets/centered_circular_progress_indicator.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../../data/models/user_model.dart';
import '../controllers/auth_controller.dart';
import '../controllers/sign_in_controller.dart';
import '../utils/app_colors.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const String name = '/sign-in';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final TextEditingController _emailTEController = TextEditingController();
  final TextEditingController _passwordTEController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final SignInController _signInController = Get.find<SignInController>();

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      body: ScreenBackground(
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(30),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const SizedBox(height: 40),
                    Text(
                      'Get Started With',
                      style: textTheme.titleLarge,
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: _emailTEController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(hintText: 'Email'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter a valid email address';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 8),
                    TextFormField(
                      obscureText: true,
                      controller: _passwordTEController,
                      decoration: const InputDecoration(hintText: 'Password'),
                      validator: (String? value) {
                        if (value?.trim().isEmpty ?? true) {
                          return 'Enter your valid password';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    GetBuilder<SignInController>(builder: (controller) {
                      return Visibility(
                        visible: controller.inProgress == false,
                        replacement: const CenteredCircularProgressIndicator(),
                        child: ElevatedButton(
                          onPressed: _onTapSignInButton,
                          child: const Icon(Icons.arrow_circle_right_outlined),
                        ),
                      );
                    }),
                    const SizedBox(height: 48),
                    Center(
                      child: Column(
                        children: [
                          TextButton(
                            onPressed: () {
                              //Navigator.pushNamed(context, ForgotPasswordVerifyEmailScreen.name);
                              Get.toNamed(ForgotPasswordVerifyEmailScreen.name);
                            },
                            child: const Text('Forgot Password?'),
                          ),
                          _buildSignUpSection()
                        ],
                      ),
                    )
                    //ElevatedButton(onPressed: (){}, child: const Text('Sign in'))
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapSignInButton() {
    if (_formKey.currentState!.validate()) {
      _signIn();
    }
  }

  Future<void> _signIn() async {
    final bool isSuccess = await _signInController.signIn(
      _emailTEController.text.trim(),
      _passwordTEController.text,
    );
    if (isSuccess) {
      Get.offNamed(MainBottomNavScreen.name);
    } else {
      showSnackBarMessage(context, _signInController.errorMessage!);
    }
  }

  Widget _buildSignUpSection() {
    return RichText(
      text: TextSpan(
        text: "Don't have an account? ",
        style:
            const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
        children: [
          TextSpan(
              text: 'Sign up',
              style: const TextStyle(
                color: AppColors.themeColor,
              ),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  //Navigator.pushNamed(context, SignUpScreen.name);
                  Get.toNamed(SignUpScreen.name);
                })
        ],
      ),
    );
  }

  @override
  void dispose() {
    _emailTEController.dispose();
    _passwordTEController.dispose();
    super.dispose();
  }
}
