import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class TaskController extends GetxController {
  // Declaration of variables
  Map<String, bool> _taskLoadingStateForDelete = {}; // Tracks loading states per task
  Map<String, bool> _taskLoadingStateForUpdate = {}; // Tracks loading states per task
  String? _errorMessage;
  final List<String> _taskStates = ['New', 'Progress', 'Completed', 'Cancelled'];

  // Getter Methods
  bool getTaskLoadingStateForDelete(String taskId) => _taskLoadingStateForDelete[taskId] ?? false;
  bool getTaskLoadingStateForUpdate(String taskId) => _taskLoadingStateForUpdate[taskId] ?? false;

  String? get errorMessage => _errorMessage;

  List<String> get taskStates => _taskStates;

  // Update the loading state for a specific task
  void _setTaskLoadingStateForDelete(String taskId, bool value) {
    _taskLoadingStateForDelete[taskId] = value;
    update(); // Notify listeners to rebuild UI
  }
  void _setTaskLoadingStateForUpdate(String taskId, bool value) {
    _taskLoadingStateForUpdate[taskId] = value;
    update(); // Notify listeners to rebuild UI
  }

  Future<bool> deleteTask(String taskId) async {
    _setTaskLoadingStateForDelete(taskId, true); // Set the task as loading

    try {
      final NetworkResponse response =
      await NetworkCaller.getRequest(url: Urls.deleteTask(taskId));
      if (response.isSuccess) {
        return true;
      } else {
        _handleError(response);
      }
    } catch (e) {
      _setErrorMessage('Something went wrong. Please try again.');
    } finally {
      _setTaskLoadingStateForDelete(taskId, false); // Set the task as not loading
    }

    return false;
  }

  Future<bool> updateTaskStatus(String taskId, String status) async {
    _setTaskLoadingStateForUpdate(taskId, true); // Set the task as loading

    try {
      final NetworkResponse response = await NetworkCaller.getRequest(
          url: Urls.updateTaskStatus(taskId, status));
      if (response.isSuccess) {
        return true;
      } else {
        _handleError(response);
      }
    } catch (e) {
      _setErrorMessage('Something went wrong. Please try again.');
    } finally {
      _setTaskLoadingStateForUpdate(taskId, false); // Set the task as not loading
    }

    return false;
  }

  Color getStatusColor(String status) {
    if (status == 'New') {
      return Colors.blue;
    } else if (status == 'Progress') {
      return Colors.yellow;
    } else if (status == 'Cancelled') {
      return Colors.red;
    } else {
      return Colors.green;
    }
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
}
