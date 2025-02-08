import 'package:get/get.dart';

import '../../data/models/task_count_by_status_model.dart';
import '../../data/models/task_count_model.dart';
import '../../data/models/task_list_by_status_model.dart';
import '../../data/models/task_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class TaskListController extends GetxController {
  //Declaration of variables
  bool _inProgress = false;
  String? _errorMessage;
  TaskListByStatusModel? _taskListByStatusModel;

  //Getter Methods
  bool get inProgress => _inProgress;

  String? get errorMessage => _errorMessage;

  List<TaskModel> get taskList => _taskListByStatusModel?.taskList ?? [];

  Future<bool> getTaskList(String status) async {
    _setLoading(true);

    try {
      final NetworkResponse response =
          await NetworkCaller.getRequest(url: Urls.taskListByStatusUrl(status));
      if (response.isSuccess) {
        _taskListByStatusModel = null;
        _taskListByStatusModel =
            TaskListByStatusModel.fromJson(response.responseData!);
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
