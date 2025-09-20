// import 'package:date_picker_timeline/date_picker_timeline.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:management/services/notification_service.dart';
// import 'package:management/services/theme_service.dart';
// import 'package:management/ui/widgets/add_task_bar.dart';
// import 'package:management/ui/theme.dart';
// import 'package:management/ui/widgets/button.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   DateTime _selectedDate = DateTime.now();
//   var notifyHelper;

//   @override
//   void initState() {
//     super.initState();
//     notifyHelper = NotifyHelper();
//     notifyHelper.initializeNotification();
//     notifyHelper.requestAndroidPermissions();
//     // notifyHelper.requestExactAlarmsPermission();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _appBar(),

//       body: Column(
//         children: [
//           // add task
//           _addTaskBar(),
//           // date time line picker
//           _datePicker(),
          

//         ],
//       ),
//     );
//   }

//   _datePicker() {
//     return Container(
//       child: DatePicker(
//         DateTime.now(),
//         height: 130,
//         width: 80,
//         initialSelectedDate: DateTime.now(),
//         selectionColor: Colors.blue,
//         selectedTextColor: Colors.white,
//         dateTextStyle: GoogleFonts.lato(
//           textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//         ),

//         dayTextStyle: GoogleFonts.lato(
//           textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//         ),

//         monthTextStyle: GoogleFonts.lato(
//           textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
//         ),
//         onDateChange: (date) {
//           _selectedDate = date;
//         },
//       ),
//     );
//   }

//   _addTaskBar() {
//     return Container(
//       margin: EdgeInsets.only(left: 10, right: 10, top: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 DateFormat.yMMMEd().format(DateTime.now()),
//                 style: subHeadingStyle,
//               ),
//               SizedBox(height: 10),
//               Text("Today", style: headingStyle),
//             ],
//           ),
//           MyButton(label: "+ Add Task", onTap: () => Get.to(AddTaskPage_M())),
//         ],
//       ),
//     );
//   }

//   _appBar() {
//     return AppBar(
//       elevation: 0,
//       leading: Padding(
//         padding: const EdgeInsets.all(8.0),
//         child: InkWell(
//           borderRadius: BorderRadius.circular(30),
//           onTap: () {
//             ThemeService().swithchTheme();
//             notifyHelper.displayNotification(
//               title: "Theme Changed",
//               body: "MOOD Already Activated",
//             );
//           },

//           child: Icon(Icons.nightlight_round, size: 28),
//         ),
//       ),
//       actions: [Icon(Icons.person, size: 20), SizedBox(height: 20)],
//     );
//   }


// }


// import 'package:date_picker_timeline/date_picker_timeline.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_fonts/google_fonts.dart';
// import 'package:intl/intl.dart';
// import 'package:management/controller/task_controller.dart';
// import 'package:management/models/task.dart';
// import 'package:management/models/task_tile.dart';
// import 'package:management/services/notification_service.dart';
// import 'package:management/services/theme_service.dart';
// import 'package:management/ui/theme.dart';
// import 'package:management/ui/widgets/add_task_bar.dart';
// import 'package:management/ui/widgets/button.dart';

// class HomePage extends StatefulWidget {
//   const HomePage({super.key});

//   @override
//   State<HomePage> createState() => _HomePageState();
// }

// class _HomePageState extends State<HomePage> {
//   DateTime _selectedDate = DateTime.now();
//   var notifyHelper;
//   final TaskController _taskController = Get.put(TaskController());

//   @override
//   void initState() {
//     super.initState();
//     notifyHelper = NotifyHelper();
//     notifyHelper.initializeNotification();
//     notifyHelper.requestAndroidPermissions();
//     _taskController.getTasks();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: _appBar(),
//       body: Column(
//         children: [
//           _addTaskBar(),
//           _datePicker(),
//           SizedBox(height: 10),
//           _showTasks(), // هذا السطر يعرض المهام
//         ],
//       ),
//     );
//   }

//   _showTasks() {
//     return Expanded(
//       child: Obx(() {
//         if (_taskController.taskList.isEmpty) {
//           return Center(
//             child: Text(
//               "لا توجد مهام لهذا اليوم",
//               style: titleStyle,
//             ),
//           );
//         }

//         return ListView.builder(
//           itemCount: _taskController.taskList.length,
//           itemBuilder: (_, index) {
//             Task task = _taskController.taskList[index];
            
//             // تحقق إذا كانت المهمة للتاريخ المحدد أو متكررة
//             if (task.date == DateFormat.yMd().format(_selectedDate) ||
//                 task.repeat == "Daily" ||
//                 (task.repeat == "Weekly" &&
//                     _selectedDate
//                         .difference(DateFormat.yMd().parse(task.date!))
//                         .inDays %
//                         7 ==
//                     0) ||
//                 (task.repeat == "Monthly" &&
//                     _selectedDate.day ==
//                         DateFormat.yMd().parse(task.date!).day)) {
              
//               return GestureDetector(
//                 onTap: () {
//                   _showBottomSheet(context, task);
//                 },
//                 child: TaskTile(task),
//               );
//             } else {
//               return Container();
//             }
//           },
//         );
//       }),
//     );
//   }

//   _showBottomSheet(BuildContext context, Task task) {
//     Get.bottomSheet(
//       Container(
//         padding: EdgeInsets.only(top: 4),
//         height: task.isCompleted == 1
//             ? MediaQuery.of(context).size.height * 0.24
//             : MediaQuery.of(context).size.height * 0.32,
//         color: Get.isDarkMode ? darkGreyClr : Colors.white,
//         child: Column(
//           children: [
//             Container(
//               height: 6,
//               width: 120,
//               decoration: BoxDecoration(
//                 borderRadius: BorderRadius.circular(10),
//                 color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
//               ),
//             ),
//             Spacer(),
//             task.isCompleted == 1
//                 ? Container()
//                 : _bottomSheetButton(
//                     label: "تم إكمال المهمة",
//                     onTap: () {
//                       _taskController.markTaskCompleted(task.id!);
//                       Get.back();
//                     },
//                     clr: primaryClr,
//                     context: context,
//                   ),
//             _bottomSheetButton(
//               label: "حذف المهمة",
//               onTap: () {
//                 _taskController.deleteTask(task);
//                 Get.back();
//               },
//               clr: Colors.red[300]!,
//               context: context,
//             ),
//             SizedBox(height: 20),
//             _bottomSheetButton(
//               label: "إغلاق",
//               onTap: () {
//                 Get.back();
//               },
//               clr: Colors.red[300]!,
//               isClose: true,
//               context: context,
//             ),
//             SizedBox(height: 10),
//           ],
//         ),
//       ),
//     );
//   }

//   _bottomSheetButton({
//     required String label,
//     required Function() onTap,
//     required Color clr,
//     bool isClose = false,
//     required BuildContext context,
//   }) {
//     return GestureDetector(
//       onTap: onTap,
//       child: Container(
//         margin: EdgeInsets.symmetric(vertical: 4),
//         height: 55,
//         width: MediaQuery.of(context).size.width * 0.9,
//         decoration: BoxDecoration(
//           border: Border.all(
//             width: 2,
//             color: isClose == true
//                 ? Get.isDarkMode ? Colors.grey[600]! : Colors.grey[300]!
//                 : clr,
//           ),
//           borderRadius: BorderRadius.circular(20),
//           color: isClose == true ? Colors.transparent : clr,
//         ),
//         child: Center(
//           child: Text(
//             label,
//             style:
//                 isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
//           ),
//         ),
//       ),
//     );
//   }

//   _datePicker() {
//     return Container(
//       margin: EdgeInsets.only(top: 20, left: 20),
//       child: DatePicker(
//         DateTime.now(),
//         height: 100,
//         width: 80,
//         initialSelectedDate: DateTime.now(),
//         selectionColor: primaryClr,
//         selectedTextColor: Colors.white,
//         dateTextStyle: GoogleFonts.lato(
//           textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
//         ),
//         dayTextStyle: GoogleFonts.lato(
//           textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
//         ),
//         monthTextStyle: GoogleFonts.lato(
//           textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
//         ),
//         onDateChange: (date) {
//           setState(() {
//             _selectedDate = date;
//           });
//         },
//       ),
//     );
//   }

//   _addTaskBar() {
//     return Container(
//       margin: EdgeInsets.only(left: 20, right: 20, top: 10),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               Text(
//                 DateFormat.yMMMEd().format(DateTime.now()),
//                 style: subHeadingStyle,
//               ),
//               Text("اليوم", style: headingStyle),
//             ],
//           ),
//           MyButton(
//               label: "+ إضافة مهمة", 
//               onTap: () async {
//                 await Get.to(AddTaskPage_M());
//                 _taskController.getTasks();
//               }
//           ),
//         ],
//       ),
//     );
//   }

//   _appBar() {
//     return AppBar(
//       elevation: 0,
//       backgroundColor: context.theme.colorScheme.background,
//       leading: GestureDetector(
//         onTap: () {
//           ThemeService().swithchTheme();
//         },
//         child: Icon(Icons.nightlight_round, 
//                     size: 20, 
//                     color: Get.isDarkMode ? Colors.white : Colors.black),
//       ),
//       actions: [
//         Icon(Icons.person, 
//              size: 20,
//              color: Get.isDarkMode ? Colors.white : Colors.black),
//         SizedBox(width: 20),
//       ],
//     );
//   }
// }





import 'package:date_picker_timeline/date_picker_timeline.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:management/controller/task_controller.dart';
import 'package:management/models/task.dart';
import 'package:management/models/task_tile.dart';
import 'package:management/services/notification_service.dart';
import 'package:management/services/theme_service.dart';
import 'package:management/ui/theme.dart';
import 'package:management/ui/widgets/add_task_bar.dart';
import 'package:management/ui/widgets/button.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DateTime _selectedDate = DateTime.now();
  var notifyHelper;
  final TaskController _taskController = Get.put(TaskController());

  @override
  void initState() {
    super.initState();
    notifyHelper = NotifyHelper();
    notifyHelper.initializeNotification();
    notifyHelper.requestAndroidPermissions();
    notifyHelper.requestExactAlarmsPermission();
    _taskController.getTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(),
      body: Column(
        children: [
          _addTaskBar(),
          _datePicker(),
          SizedBox(height: 10),
          _showTasks(), // This line displays the tasks
        ],
      ),
    );
  }

  _showTasks() {
    return Expanded(
      child: Obx(() {
        if (_taskController.taskList.isEmpty) {
          return Center(
            child: Text(
              "No tasks for today",
              style: titleStyle,
            ),
          );
        }

        return ListView.builder(
          itemCount: _taskController.taskList.length,
          itemBuilder: (_, index) {
            Task task = _taskController.taskList[index];
            
            // Check if the task is for the selected date or is recurring
            if (task.date == DateFormat.yMd().format(_selectedDate) ||
                task.repeat == "Daily" ||
                (task.repeat == "Weekly" &&
                    _selectedDate
                        .difference(DateFormat.yMd().parse(task.date!))
                        .inDays %
                        7 ==
                    0) ||
                (task.repeat == "Monthly" &&
                    _selectedDate.day ==
                        DateFormat.yMd().parse(task.date!).day)) {
              
              return GestureDetector(
                
                onTap: () {
                  _showBottomSheet(context, task);
                },
                child: TaskTile(task),
              );
            } else {
              return Container();
            }
          },
        );
      }),
    );
  }

  _showBottomSheet(BuildContext context, Task task) {
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
        height: task.isCompleted == 1
            ? MediaQuery.of(context).size.height * 0.24
            : MediaQuery.of(context).size.height * 0.32,
        color: Get.isDarkMode ? darkGreyClr : Colors.white,
        child: Column(
          children: [
            Container(
              height: 6,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                color: Get.isDarkMode ? Colors.grey[600] : Colors.grey[300],
              ),
            ),
            Spacer(),
            task.isCompleted == 1
                ? Container()
                : _bottomSheetButton(
                    label: "Task Completed",
                    onTap: () {
                      _taskController.markTaskCompleted(task.id!);
                      Get.back();
                    },
                    clr: primaryClr,
                    context: context,
                  ),
            _bottomSheetButton(
              
              label: "Delete Task",
              onTap: () {
                _taskController.deleteTask(task);
                Get.back();
              },
              clr: Colors.red[300]!,
              context: context,
            ),
            SizedBox(height: 20),
            _bottomSheetButton(
              label: "Close",
              onTap: () {
                Get.back();
              },
              clr: Colors.red[300]!,
              isClose: true,
              context: context,
            ),
            SizedBox(height: 10),
          ],
        ),
      ),
    );
  }

  _bottomSheetButton({
    required String label,
    required Function() onTap,
    required Color clr,
    bool isClose = false,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(5),
        height: 55,
        width: MediaQuery.of(context).size.width * 0.9,
        decoration: BoxDecoration(
          border: Border.all(
            width: 2,
            color: isClose == true
                ? Get.isDarkMode ? Colors.grey[600]! : Colors.grey[300]!
                : clr,
          ),
          borderRadius: BorderRadius.circular(20),
          color: isClose == true ? Colors.transparent : clr,
        ),
        child: Center(
          child: Text(
            label,
            style:
                isClose ? titleStyle : titleStyle.copyWith(color: Colors.white),
          ),
        ),
      ),
    );
  }

  _datePicker() {
    return Container(
      margin: EdgeInsets.only(top: 20, left: 20),
      child: DatePicker(
        DateTime.now(),
        height: 100,
        width: 80,
        initialSelectedDate: DateTime.now(),
        selectionColor: primaryClr,
        selectedTextColor: Colors.white,
        dateTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        dayTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        monthTextStyle: GoogleFonts.lato(
          textStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.grey),
        ),
        onDateChange: (date) {
          setState(() {
            _selectedDate = date;
          });
        },
      ),
    );
  }

  _addTaskBar() {
    return Container(
      margin: EdgeInsets.only(left: 20, right: 20, top: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                DateFormat.yMMMEd().format(DateTime.now()),
                style: subHeadingStyle,
              ),
              Text("Today", style: headingStyle),
            ],
          ),
          MyButton(
              label: "+ Add Task", 
              onTap: () async {
                await Get.to(AddTaskPage_M());
                _taskController.getTasks();
              }
          ),
        ],
      ),
    );
  }

  _appBar() {
    return AppBar(
      elevation: 0,
      backgroundColor: context.theme.colorScheme.background,
      leading: GestureDetector(
        onTap: () {
          ThemeService().swithchTheme();
        },
        child: Icon(Icons.nightlight_round, 
                    size: 20, 
                    color: Get.isDarkMode ? Colors.white : Colors.black),
      ),
      actions: [
        Icon(Icons.person, 
             size: 20,
             color: Get.isDarkMode ? Colors.white : Colors.black),
        SizedBox(width: 20),
      ],
    );
  }
}