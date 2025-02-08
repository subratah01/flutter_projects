import 'package:get/get.dart';

import '../../data/models/user_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import 'auth_controller.dart';

class SignInController extends GetxController {
  //Declaration of variables
  bool _inProgress = false;
  String? _errorMessage;

  //Getter Methods
  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;

  Future<bool> signIn(String email, String password) async {
    _setLoading(true);

    try {
      final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.loginUrl,
        body: {"email": email, "password": password},
      );
      if (response.isSuccess) {
        await _handleSuccess(response);
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

  Future<void> _handleSuccess(NetworkResponse response) async {
    String token = response.responseData!['token'];
    UserModel userModel = UserModel.fromJson(response.responseData!['data']);
    await AuthController.saveUserData(token, userModel);
  }

  void _handleError(NetworkResponse response) {
    if (response.statusCode == 401) {
      _setErrorMessage('Email/Password is invalid! Try again.');
    } else {
      _setErrorMessage(response.errorMessage);
    }
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
