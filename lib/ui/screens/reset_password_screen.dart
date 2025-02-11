import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/screens/sign_in_screen.dart';
import 'package:task_manager/ui/utils/app_colors.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';

import '../../data/models/reset_password_model.dart';
import '../controllers/reset_password_controller.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/snack_bar_message.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  static const String name = '/forgot-password/reset-password';

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordTEController =
      TextEditingController();
  final TextEditingController _confirmPasswordTEController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final ResetPasswordController _resetPasswordController =
      Get.find<ResetPasswordController>();
  String _email = "";
  String _otp = "";

  @override
  Widget build(BuildContext context) {
    TextTheme textTheme = Theme.of(context).textTheme;
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
    _email = args?['email'] ?? "";
    _otp = args?['otp'] ?? "";

    return Scaffold(
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 80),
                  Text('Set Password', style: textTheme.titleLarge),
                  const SizedBox(height: 4),
                  Text(
                    'Minimum length of password should be more than 8 letters.',
                    style: textTheme.titleSmall,
                  ),
                  const SizedBox(height: 24),
                  TextFormField(
                    obscureText: true,
                    controller: _newPasswordTEController,
                    decoration: const InputDecoration(hintText: 'New Password'),
                  ),
                  const SizedBox(height: 8),
                  TextFormField(
                    obscureText: true,
                    controller: _confirmPasswordTEController,
                    decoration:
                        const InputDecoration(hintText: 'Confirm New Password'),
                  ),
                  const SizedBox(height: 24),
                  GetBuilder<ResetPasswordController>(builder: (controller) {
                    return Visibility(
                      visible: controller.inProgress == false,
                      replacement: const CenteredCircularProgressIndicator(),
                      child: ElevatedButton(
                        onPressed: _onTapResetPasswordButton,
                        child: const Text('Confirm'),
                      ),
                    );
                  }),
                  const SizedBox(height: 48),
                  Center(
                    child: _buildSignInSection(),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _onTapResetPasswordButton() {
    if (_formKey.currentState!.validate() &&
        _newPasswordTEController.text.trim() ==
            _confirmPasswordTEController.text.trim()) {
      _resetPasswordOTP();
    } else {
      showSnackBarMessage(context, 'Password mismatched!');
    }
  }

  Future<void> _resetPasswordOTP() async {
    final model = ResetPasswordModel(
      email: _email,
      otp: _otp,
      password: _newPasswordTEController.text,
    );
    final bool isSuccess =
        await _resetPasswordController.resetPasswordOTP(model);
    if (isSuccess) {
      Get.offAllNamed(SignInScreen.name);

      /*Navigator.pushNamedAndRemoveUntil(
          context, SignInScreen.name, (predicate) => false);*/
    } else {
      showSnackBarMessage(context, _resetPasswordController.errorMessage!);
    }
  }

  Widget _buildSignInSection() {
    return RichText(
      text: TextSpan(
        text: "Have an account? ",
        style:
            const TextStyle(color: Colors.black54, fontWeight: FontWeight.w600),
        children: [
          TextSpan(
            text: 'Sign in',
            style: const TextStyle(
              color: AppColors.themeColor,
            ),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                Get.offAllNamed(SignInScreen.name);

                /*Navigator.pushNamedAndRemoveUntil(
                    context, SignInScreen.name, (value) => false);*/
              },
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _newPasswordTEController.dispose();
    _confirmPasswordTEController.dispose();
    super.dispose();
  }
}
