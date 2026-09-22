import 'package:flutter/material.dart';

void main() {
  runApp(const TaskBoardApp());
}

class TaskBoardApp extends StatelessWidget {
  const TaskBoardApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Equipo 10B',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        scaffoldBackgroundColor: const Color(0xFFF5F5FA),
        useMaterial3: true,
      ),
      home: const TaskBoardScreen(),
    );
  }
}

// Modelo simple de una tarea
class Task {
  String title;
  bool isCompleted;

  Task({required this.title, this.isCompleted = false});
}

class TaskBoardScreen extends StatefulWidget {
  const TaskBoardScreen({super.key});

  @override
  State<TaskBoardScreen> createState() => _TaskBoardScreenState();
}

class _TaskBoardScreenState extends State<TaskBoardScreen> {
  // Estado: lista de tareas
  final List<Task> _tasks = [
    Task(title: 'Subir captura de la lista viva'),
    Task(title: 'Responder autoevaluación'),
    Task(title: 'Tarea 3'),
    Task(title: 'Tarea 4'),
    Task(title: 'Tarea 5'),
    Task(title: 'Tarea 6'),
  ];

  // Cambia el estado de completado de una tarea
  void _toggleCompletada(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipo 10B'),
        centerTitle: true,
        backgroundColor: const Color(0xFFDCD9FB),
        elevation: 0,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _tasks.length,
        itemBuilder: (context, index) {
          final task = _tasks[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
              color: const Color(0xFFEDEBF7),
              borderRadius: BorderRadius.circular(12),
            ),
            child: ListTile(
              leading: Checkbox(
                value: task.isCompleted,
                onChanged: (_) => _toggleCompletada(task),
              ),
              title: Text(
                task.title,
                style: TextStyle(
                  decoration: task.isCompleted
                      ? TextDecoration.lineThrough
                      : TextDecoration.none,
                  color: task.isCompleted ? Colors.grey : Colors.black87,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

}