import 'package:get/get.dart';

import '../../data/models/user_model.dart';
import '../../data/models/user_data_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../screens/main_bottom_nav_screen.dart';
import 'auth_controller.dart';

class SignUpController extends GetxController {
  //Declaration of variables
  bool _inProgress = false;
  String? _errorMessage;

  //Getter Methods
  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;

  Future<bool> registerUser(UserDataModel user) async {
    _setLoading(true);

    try {
      final NetworkResponse response = await NetworkCaller.postRequest(
        url: Urls.registrationUrl,
        body: {
          "email": user.email,
          "firstName": user.firstName,
          "lastName": user.lastName,
          "mobile": user.mobile,
          "password": user.password,
          "photo": ""
        },
      );
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
