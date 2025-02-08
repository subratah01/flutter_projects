import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/task_item_widget.dart';
import 'package:task_manager/ui/widgets/task_status_summary_counter_widget.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

import '../../data/models/task_list_by_status_model.dart';
import '../../data/models/task_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../controllers/task_list_controller.dart';
import '../widgets/snack_bar_message.dart';

class ProgressTaskListScreen extends StatefulWidget {
  const ProgressTaskListScreen({super.key});

  @override
  State<ProgressTaskListScreen> createState() => _ProgressTaskListScreenState();
}

class _ProgressTaskListScreenState extends State<ProgressTaskListScreen> {
  final TaskListController _taskListController = Get.find<TaskListController>();
  TaskListByStatusModel? progressTaskListModel;

  @override
  void initState() {
    super.initState();
    _getProgressTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: GetBuilder<TaskListController>(builder: (controller) {
            return Visibility(
              visible: controller.inProgress == false,
              replacement: const Center(
                child: Text('Data loading...'),
              ),
              child: _buildTaskListView(controller.taskList),
            );
          }),
        ),
      ),
    );
  }

  Widget _buildTaskListView(List<TaskModel> taskList) {
    return ListView.builder(
      shrinkWrap: true,
      primary: false,
      itemCount: taskList?.length ?? 0,
      itemBuilder: (context, index) {
        return TaskItemWidget(
          taskModel: taskList![index],
        );
      },
    );
  }

  Future<void> _getProgressTaskList() async {
    final bool isSuccess = await _taskListController.getTaskList("Progress");
    if (!isSuccess) {
      showSnackBarMessage(context, _taskListController.errorMessage!);
    }
  }
}
