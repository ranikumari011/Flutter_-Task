import 'package:flutter/material.dart';
import 'package:flutter_task/view/screens/add_task_screen.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';

import '../../controllers/auth_controller.dart';
import '../../services/firebase_service.dart';
import 'edit_task_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List tasks = [];
  final AuthController authController = Get.put(AuthController());

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    final data = await TaskService.getTasks();

    print("Firebase data: $data");

    setState(() {
      tasks = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double listWidth = width > 900 ? 750 : width * 0.95;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        title: const Text("My Tasks", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,

        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF5A8DEE), Color(0xFF3F6FD9)],
            ),
          ),
        ),

        actions: [
          IconButton(
            icon: const Icon(Icons.logout),

            onPressed: () {
              final AuthController authController = Get.find();
              authController.logout();
            },
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.blue,
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddTaskScreen()),
          );

          loadTasks();
        },
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text("Add Task", style: TextStyle(color: Colors.white)),
      ),

      body: Center(
        child: SizedBox(
          width: listWidth,
          child: Column(
            children: [
              /// Top progress card
              Container(
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF5A8DEE), Color(0xFF3F6FD9)],
                  ),
                  borderRadius: BorderRadius.circular(18),
                ),

                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Today's Tasks",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          "4 tasks remaining",
                          style: TextStyle(color: Colors.white70),
                        ),
                      ],
                    ),

                    Icon(Icons.task_alt, color: Colors.white, size: 40),
                  ],
                ),
              ),

              /// Task list
              Expanded(
                child:
                    tasks.isEmpty
                        ? const Center(child: Text("No tasks found"))
                        : ListView.builder(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: tasks.length,

                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return Container(
                              margin: const EdgeInsets.only(bottom: 14),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    blurRadius: 10,
                                    color: Colors.black.withOpacity(.06),
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),

                              child: Padding(
                                padding: const EdgeInsets.all(16),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    /// Checkbox
                                    Checkbox(
                                      activeColor: Colors.green,
                                      checkColor: Colors.white,
                                      value: task["isCompleted"] ?? false,
                                      onChanged: (value) async {

                                        await TaskService.toggleTask(
                                          task["id"],
                                          value!,
                                        );

                                        loadTasks();
                                      },
                                    ),

                                    const SizedBox(width: 10),

                                    /// Task title + subtitle
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            task["title"],
                                            style: TextStyle(
                                              fontWeight: FontWeight.w600,
                                              fontSize: 16,
                                            ),
                                          ),

                                          SizedBox(height: 6),

                                          Text(
                                            task["description"],
                                            style: TextStyle(
                                              color: Colors.grey,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),

                                    /// Edit + Delete buttons
                                    Column(
                                      children: [
                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.blue.shade50,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.edit_outlined,
                                            ),
                                            iconSize: 20,
                                              onPressed: () async {

                                                await Get.to(
                                                      () => EditTaskScreen(
                                                    taskId: task["id"],
                                                    title: task["title"],
                                                    description: task["description"],
                                                  ),
                                                );

                                                loadTasks();
                                              }
                                          ),
                                        ),

                                        const SizedBox(height: 10),

                                        Container(
                                          decoration: BoxDecoration(
                                            color: Colors.red.shade50,
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.delete_outline,
                                              color: Colors.red,
                                            ),
                                            iconSize: 20,

                                              onPressed: () async {

                                                bool success = await TaskService.deleteTask(task["id"]);

                                                if (success) {
                                                  Get.snackbar(
                                                    "Success",
                                                    "Task Deleted",
                                                    snackPosition: SnackPosition.TOP,
                                                    backgroundColor: Colors.red,
                                                    colorText: Colors.white,
                                                    margin: const EdgeInsets.all(10),
                                                  );
                                                  loadTasks();
                                                }
                                              }
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
