import 'package:get/get.dart';
import 'package:task_manager/ui/controllers/add_new_task_controller.dart';
import 'package:task_manager/ui/controllers/forgot_password_controller.dart';
import 'package:task_manager/ui/controllers/reset_password_controller.dart';
import 'package:task_manager/ui/controllers/sign_in_controller.dart';
import 'package:task_manager/ui/controllers/sign_up_controller.dart';
import 'package:task_manager/ui/controllers/task_controller.dart';
import 'package:task_manager/ui/controllers/task_list_controller.dart';
import 'package:task_manager/ui/controllers/task_summary_controller.dart';
import 'package:task_manager/ui/controllers/update_profile_controller.dart';

class ControllerBinder extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(()=> SignInController());
    Get.lazyPut(()=> SignUpController());
    Get.lazyPut(()=> ForgotPasswordController());
    Get.lazyPut(()=> ResetPasswordController());
    Get.lazyPut(()=> UpdateProfileController());
    Get.lazyPut(()=> AddNewTaskController());
    Get.lazyPut(()=> TaskSummaryController());
    Get.lazyPut(()=> TaskController());
    Get.lazyPut(()=> TaskListController());
  }
}