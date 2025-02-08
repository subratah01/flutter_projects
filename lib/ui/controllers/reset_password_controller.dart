import 'package:get/get.dart';

import '../../data/models/reset_password_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class ResetPasswordController extends GetxController {
  //Declaration of variables
  bool _inProgress = false;
  String? _errorMessage;

  //Getter Methods
  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;

  Future<bool> resetPasswordOTP(ResetPasswordModel model) async {
    _setLoading(true);

    try {
      Map<String, dynamic> requestBody = {
        "email": model.email,
        "OTP": model.otp,
        "password": model.password
      };
      final NetworkResponse response = await NetworkCaller.postRequest(
          url: Urls.resetPassword, body: requestBody);
      if (response.isSuccess) {
        return true;
      } else {
        _handleError(response);
      }
    } catch (e) {
      _setErrorMessage('Something went wrong. Please try again.');
    } finally {
      _setLoading(false);
    }

    return false;
  }

  void _handleError(NetworkResponse response) {
    _setErrorMessage(response.errorMessage);
  }

  void _setErrorMessage(String? message) {
    if (_errorMessage != message) {
      _errorMessage = message;
      update();
    }
  }

  void _setLoading(bool value) {
    if (_inProgress != value) {
      _inProgress = value;
      update();
    }
  }
}
