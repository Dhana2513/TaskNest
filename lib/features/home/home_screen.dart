import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:recase/recase.dart';

import '../../core/services/firestore.dart';
import '../../core/widgets/main_scaffold.dart';
import '../../shared/type/task_type.dart';
import 'widget/task_list.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedNavIndex = 0;
  late final PageController pageController;

  TaskType get selectedTaskType => TaskTypeX.taskCategories[selectedNavIndex];

  @override
  void initState() {
    super.initState();
    Firestore.instance.allTasks();
    pageController = PageController(initialPage: selectedNavIndex);
  }

  void addTask() {}

  @override
  Widget build(BuildContext context) {
    return MainScaffold(
      body: PageView(
        controller: pageController,
        children: TaskTypeX.taskCategories
            .map((taskType) => TaskList(taskType: taskType))
            .toList(),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: addTask,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: selectedNavIndex,
        selectedFontSize: 12,
        selectedItemColor: Theme.of(context).primaryColor,
        showSelectedLabels: true,
        onTap: (index) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            pageController.animateToPage(
              selectedNavIndex,
              duration: const Duration(seconds: 1),
              curve: Curves.ease,
            );
          });

          setState(() {
            selectedNavIndex = index;
          });
        },
        items: TaskTypeX.taskCategories
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
