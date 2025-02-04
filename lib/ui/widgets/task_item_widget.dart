import 'package:flutter/material.dart';
import 'package:task_manager/data/models/task_model.dart';
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
  bool _deleteTaskInProgress = false;
  bool _updateTaskInProgress = false;
  String _selectedTaskState = '';
  final List<String> _taskStates = ['New', 'Progress', 'Completed','Cancelled'];

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
                    IconButton(
                      onPressed: () => _deleteTask(widget.taskModel.sId),
                      icon: _deleteTaskInProgress
                          ? const CircularProgressIndicator()
                          : const Icon(Icons.delete),
                    ),
                    IconButton(
                      onPressed: () => _showTaskStateDialog(context),
                      icon: _updateTaskInProgress
                          ? const CircularProgressIndicator()
                          : const Icon(Icons.edit),
                    ),
                  ],
                )
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
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: _taskStates.map((state){
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
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                setState(() => _selectedTaskState = tempSelected);
                Navigator.pop(context);
                //print(_selectedTaskState);
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
    _deleteTaskInProgress = true;
    setState(() {});

    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.deleteTask(taskId));
    if (response.isSuccess) {
      showSnackBarMessage(context, 'Task deleted successfully!');
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _deleteTaskInProgress = false;
    setState(() {});
  }

  Future<void> _updateTaskStatus(String? taskId, String? status) async {
    if (taskId == null || status == null) return;
    _updateTaskInProgress = true;
    setState(() {});

    final NetworkResponse response =
    await NetworkCaller.getRequest(url: Urls.updateTaskStatus(taskId, status));
    if (response.isSuccess) {
      showSnackBarMessage(context, 'Task updated successfully!');
    } else {
      showSnackBarMessage(context, response.errorMessage);
    }
    _updateTaskInProgress = false;
    setState(() {});
  }

  Color _getStatusColor(String status) {
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
}
