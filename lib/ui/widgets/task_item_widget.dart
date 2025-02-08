import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/task_model.dart';
import 'package:task_manager/ui/controllers/task_controller.dart';
import 'package:task_manager/ui/widgets/snack_bar_message.dart';

import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';

class TaskItemWidget extends StatefulWidget {
  const TaskItemWidget({
    super.key,
    required this.taskModel,
  });

  final TaskModel taskModel;

  @override
  _TaskItemWidgetState createState() => _TaskItemWidgetState();
}

class _TaskItemWidgetState extends State<TaskItemWidget> {
  final TaskController _taskController = Get.find<TaskController>();
  String _selectedTaskState = '';

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 0,
      child: ListTile(
        title: Text(widget.taskModel.title ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.taskModel.description ?? ''),
            Text('Date: ${widget.taskModel.createdDate ?? ''}'),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: _getStatusColor(widget.taskModel.status ?? 'New'),
                  ),
                  child: Text(
                    widget.taskModel.status ?? 'New',
                    style: const TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                Row(
                  children: [
                    GetBuilder<TaskController>(
                      builder: (controller) {
                        return Visibility(
                          visible: !controller.deleteTaskInProgress,
                          replacement: const CircularProgressIndicator(),
                          child: IconButton(
                            onPressed: () => _deleteTask(widget.taskModel.sId),
                            icon: const Icon(Icons.delete),
                          ),
                        );
                      },
                    ),
                    GetBuilder<TaskController>(
                      builder: (controller) {
                        return Visibility(
                          visible: !controller.updateTaskInProgress,
                          replacement: const CircularProgressIndicator(),
                          child: IconButton(
                            onPressed: () => _showTaskStateDialog(context),
                            icon: const Icon(Icons.edit),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  void _showTaskStateDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        String tempSelected = _selectedTaskState;

        return AlertDialog(
          title: const Text('Select Task State'),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setModalState) {
              return GetBuilder<TaskController>(builder: (controller) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: controller.taskStates.map((state) {
                    return RadioListTile<String>(
                      title: Text(state),
                      value: state,
                      groupValue: tempSelected,
                      onChanged: (String? value) {
                        setModalState(() => tempSelected = value!);
                      },
                    );
                  }).toList(),
                );
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(), //Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() => _selectedTaskState = tempSelected);
                Get.back();
                _updateTaskStatus(widget.taskModel.sId, _selectedTaskState);
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteTask(String? taskId) async {
    if (taskId == null) return;

    final bool isSuccess = await _taskController.deleteTask(taskId);
    if (isSuccess) {
      showSnackBarMessage(context, 'Task deleted successfully!');
    } else {
      showSnackBarMessage(context, _taskController.errorMessage!);
    }
  }

  Future<void> _updateTaskStatus(String? taskId, String? status) async {
    if (taskId == null || status == null) return;

    final bool isSuccess =
        await _taskController.updateTaskStatus(taskId, status);
    if (isSuccess) {
      showSnackBarMessage(context, 'Task updated successfully!');
    } else {
      showSnackBarMessage(context, _taskController.errorMessage!);
    }
  }

  Color _getStatusColor(String status) {
    return _taskController.getStatusColor(status);
  }
}
