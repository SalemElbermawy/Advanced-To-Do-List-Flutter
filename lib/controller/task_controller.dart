import 'package:get/get.dart';
import 'package:management/db/db_helper.dart';
import 'package:management/models/task.dart';

// class TaskController extends GetxController {
//   @override
//   void onReady() {
//     super.onReady();
//   }

//   Future<int> addTask({Task? task}) async{
//     return await DBHelper.insert(task);
//   } 
// }



class TaskController extends GetxController {
  var taskList = <Task>[].obs;

  @override
  void onReady() {
    super.onReady();
    getTasks();
  }

  Future<int> addTask({Task? task}) async {
    return await DBHelper.insert(task);
  }

  Future<void> getTasks() async {
    List<Map<String, dynamic>> tasks = await DBHelper.query();
    taskList.assignAll(tasks.map((data) => Task.fromJson(data)).toList());
  }

  void deleteTask(Task task) {
    DBHelper.delete(task);
    getTasks();
  }

  void markTaskCompleted(int id) async {
    await DBHelper.update(id);
    getTasks();
  }
}