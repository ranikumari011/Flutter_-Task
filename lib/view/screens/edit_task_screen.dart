import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../services/firebase_service.dart';

class EditTaskScreen extends StatefulWidget {

  final String? taskId;
  final String? title;
  final String? description;

  const EditTaskScreen({
    super.key,
    this.taskId,
    this.title,
    this.description,
  });

  @override
  State<EditTaskScreen> createState() => _EditTaskScreenState();
}

class _EditTaskScreenState extends State<EditTaskScreen> {

  final titleController = TextEditingController();
  final descController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    if (widget.title != null) {
      titleController.text = widget.title!;
    }

    if (widget.description != null) {
      descController.text = widget.description!;
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    double width = MediaQuery.of(context).size.width;
    double cardWidth = width > 800 ? 500 : width * 0.95;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),

      appBar: AppBar(
        title: Text(
          widget.taskId == null ? "Add Task" : "Edit Task",
          style: const TextStyle(color: Colors.white),
        ),
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        backgroundColor: Colors.transparent,
        elevation: 0,

        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFF5A8DEE),
                Color(0xFF3F6FD9),
              ],
            ),
          ),
        ),
      ),

      body: Center(
        child: SingleChildScrollView(
          child: Container(
            width: cardWidth,
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(22),

            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              boxShadow: [
                BoxShadow(
                  blurRadius: 10,
                  color: Colors.black.withOpacity(.05),
                )
              ],
            ),

            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  /// Title
                  const Text(
                    "Task Title",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: titleController,

                    decoration: InputDecoration(
                      hintText: "Enter task title",
                      filled: true,
                      fillColor: Colors.grey.shade100,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter task title";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  /// Description
                  const Text(
                    "Description",
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),

                  const SizedBox(height: 8),

                  TextFormField(
                    controller: descController,
                    maxLines: 3,

                    decoration: InputDecoration(
                      hintText: "Enter task description",
                      filled: true,
                      fillColor: Colors.grey.shade100,

                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: BorderSide.none,
                      ),
                    ),

                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return "Please enter description";
                      }
                      return null;
                    },
                  ),

                  const SizedBox(height: 20),

                  /// Save / Update Button
                  SizedBox(
                    width: double.infinity,
                    height: 50,

                    child: ElevatedButton(

                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF5A8DEE),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),

                      onPressed: () async {

                        if (_formKey.currentState!.validate()) {

                          bool success;

                          if (widget.taskId == null) {

                            /// ADD TASK
                            success = await TaskService.addTask(
                              titleController.text,
                              descController.text,
                            );

                          } else {

                            /// UPDATE TASK
                            success = await TaskService.updateTask(
                              widget.taskId!,
                              titleController.text,
                              descController.text,
                            );

                          }

                          if (success) {

                            Get.snackbar(
                              "Success",
                              widget.taskId == null
                                  ? "Task Added Successfully"
                                  : "Task Updated Successfully",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );

                            Navigator.pop(context);
                            titleController.clear();
                            descController.clear();


                          } else {

                            Get.snackbar(
                              "Error",
                              "Operation Failed",
                              snackPosition: SnackPosition.TOP,
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );

                          }

                        }

                      },

                      child: Text(
                        widget.taskId == null ? "Save Task" : "Update Task",
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}