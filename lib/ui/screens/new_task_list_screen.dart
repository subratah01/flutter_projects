import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:task_manager/data/models/task_list_by_status_model.dart';
import 'package:task_manager/ui/screens/add_new_task_screen.dart';
import 'package:task_manager/ui/widgets/screen_background.dart';
import 'package:task_manager/ui/widgets/task_item_widget.dart';
import 'package:task_manager/ui/widgets/task_status_summary_counter_widget.dart';
import 'package:task_manager/ui/widgets/tm_app_bar.dart';

import '../../data/models/task_count_by_status_model.dart';
import '../../data/models/task_count_model.dart';
import '../../data/models/task_model.dart';
import '../../data/services/network_caller.dart';
import '../../data/utils/urls.dart';
import '../controllers/task_list_controller.dart';
import '../controllers/task_summary_controller.dart';
import '../widgets/centered_circular_progress_indicator.dart';
import '../widgets/snack_bar_message.dart';

class NewTaskListScreen extends StatefulWidget {
  const NewTaskListScreen({super.key});

  @override
  State<NewTaskListScreen> createState() => _NewTaskListScreenState();
}

class _NewTaskListScreenState extends State<NewTaskListScreen> {
  final TaskListController _taskListController = Get.find<TaskListController>();
  final TaskSummaryController _taskSummaryController =
  Get.find<TaskSummaryController>();
  TaskCountByStatusModel? taskCountByStatusModel;

  @override
  void initState() {
    super.initState();
    _getTaskCountByStatus();
    _getNewTaskList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const TMAppBar(),
      body: ScreenBackground(
        child: SingleChildScrollView(
          child: Column(
            children: [
              GetBuilder<TaskSummaryController>(builder: (controller) {
                return Visibility(
                  visible: controller.inProgress == false,
                  replacement: const CenteredCircularProgressIndicator(),
                  child:
                      _buildTasksSummaryByStatus(controller.taskByStatusList),
                );
              }),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: GetBuilder<TaskListController>(builder: (controller) {
                  return Visibility(
                    visible: controller.inProgress == false,
                    //replacement: const CenteredCircularProgressIndicator(),
                    replacement: const Text('Data loading...'),
                    child: _buildTaskListView(controller.taskList),
                  );
                }),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.toNamed(AddNewTaskScreen.name);
          //Navigator.pushNamed(context, AddNewTaskScreen.name);
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildTasksSummaryByStatus(List<TaskCountModel> taskByStatusList) {
    return SizedBox(
      height: 100,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: taskByStatusList?.length ?? 0,
        itemBuilder: (context, index) {
          final TaskCountModel model = taskByStatusList![index];
          return TaskStatusSummaryCounterWidget(
            title: model.sId ?? '',
            count: model.sum.toString(),
          );
        },
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

  Future<void> _getTaskCountByStatus() async {
    final bool isSuccess = await _taskSummaryController.getTaskCountByStatus();
    if (isSuccess) {
      //_getNewTaskList();
    } else {
      showSnackBarMessage(context, _taskSummaryController.errorMessage!);
    }
  }

  Future<void> _getNewTaskList() async {
    final bool isSuccess = await _taskListController.getTaskList("New");
    if (!isSuccess) {
      showSnackBarMessage(context, _taskListController.errorMessage!);
    }
  }
}
