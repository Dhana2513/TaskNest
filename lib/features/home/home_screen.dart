import 'dart:async';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';
import 'package:task_nest/core/constants/text_style.dart';
import 'package:task_nest/core/extensions/box_padding.dart';
import 'package:task_nest/core/extensions/ui_navigator.dart';
import 'package:task_nest/features/history/history_screen.dart';
import 'package:task_nest/features/home/add_task_dialog.dart';

import '../../core/constants/asset_images.dart';
import '../../core/constants/constants.dart';
import '../../core/services/firestore.dart';
import '../../core/widgets/main_scaffold.dart';
import '../../shared/type/task_type.dart';
import '../scheduled_tasks/scheduled_tasks.dart';
import 'widget/task_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedNavIndex = 2;
  late final PageController pageController;
  Timer? timer;

  TaskType get selectedTaskType => TaskType.values[selectedNavIndex];

  @override
  void initState() {
    super.initState();
    Firestore.instance.allTasks();
    pageController = PageController(initialPage: selectedNavIndex);
  }

  Widget get navigationDrawer => Drawer(
        child: ListView(
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Colors.grey.shade100),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(BoxPadding.standard),
                    child: Image(
                      image: AssetImages.shared.appLogo,
                      height: BoxPadding.xxLarge + BoxPadding.xLarge,
                    ),
                  ),
                  const Text(Constants.appName, style: UITextStyle.title),
                ],
              ),
            ),
            ListTile(
              onTap: navigateToHistoryScreen,
              title: const Text(
                Constants.history,
                style: UITextStyle.body,
              ),
            ),
            ListTile(
              onTap: navigateToTaskSchedulerScreen,
              title: const Text(
                Constants.scheduledTask,
                style: UITextStyle.body,
              ),
            ),
          ],
        ),
      );

  void navigateToHistoryScreen() {
    UINavigator.push(context: context, screen: const HistoryScreen());
  }

  void navigateToTaskSchedulerScreen() {
    UINavigator.push(context: context, screen: const ScheduledTasks());
  }

  void addTask() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) =>
          Dialog(child: AddTaskDialog(taskType: selectedTaskType)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: PageView(
        controller: pageController,
        onPageChanged: (index) {
          //TODO: implement better solution
          timer?.cancel();
          timer = Timer(const Duration(milliseconds: 100), () {
            setState(() {
              selectedNavIndex = index;
            });
          });
        },
        children: TaskType.values
            .map((taskType) => TaskList(taskType: taskType))
            .toList(),
      ),
      drawer: navigationDrawer,
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: selectedNavIndex,
        selectedLabelStyle: UITextStyle.body.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
        selectedItemColor: Theme.of(context).primaryColor,
        showSelectedLabels: true,
        onTap: (index) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            pageController.animateToPage(
              selectedNavIndex,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeIn,
            );
          });

          setState(() {
            selectedNavIndex = index;
          });
        },
        items: TaskType.values
            .map(
              (taskType) => BottomNavigationBarItem(
                icon: taskType.icon,
                label: taskType.name.titleCase,
              ),
            )
            .toList(),
      ),
    );
  }
}
