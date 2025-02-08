import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class TaskController extends GetxController {
  //Declaration of variables
  bool _deleteTaskInProgress = false;
  bool _updateTaskInProgress = false;
  String? _errorMessage;
  final List<String> _taskStates = ['New', 'Progress', 'Completed', 'Cancelled'];

  //Getter Methods
  bool get deleteTaskInProgress => _deleteTaskInProgress;

  bool get updateTaskInProgress => _updateTaskInProgress;

  String? get errorMessage => _errorMessage;

  List<String> get taskStates => _taskStates;


  Future<bool> deleteTask(String taskId) async {
    _setDeleteLoading(true, taskId);

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
      _setDeleteLoading(false, taskId);
    }

    return false;
  }

  Future<bool> updateTaskStatus(String taskId, String status) async {
    _setUpdateLoading(true);

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
      _setUpdateLoading(false);
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

  void _setDeleteLoading(bool value, String taskId) {
    if (_deleteTaskInProgress != value) {
      _deleteTaskInProgress = value;
      update();
    }
  }

  void _setUpdateLoading(bool value) {
    if (_updateTaskInProgress != value) {
      _updateTaskInProgress = value;
      update();
    }
  }


}
