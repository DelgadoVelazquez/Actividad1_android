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
  // Estado 1: lista de tareas
  final List<Task> _tasks = [
    Task(title: 'Tarea 1'),
    Task(title: 'Tarea 2'),
    Task(title: 'Tarea 3'),
    Task(title: 'Tarea 4'),
  ];

  // Estado 2: filtro de "solo pendientes"
  bool _soloPendientes = false;

  // Lista filtrada según el estado _soloPendientes
  List<Task> get _tareasVisibles {
    if (_soloPendientes) {
      return _tasks.where((t) => !t.isCompleted).toList();
    }
    return _tasks;
  }

  // Cambia el estado de completado de una tarea
  void _toggleCompletada(Task task) {
    setState(() {
      task.isCompleted = !task.isCompleted;
    });
  }

  // Cambia el estado del filtro
  void _toggleFiltro(bool value) {
    setState(() {
      _soloPendientes = value;
    });
  }

  // Elimina una tarea de la lista
  void _eliminarTarea(Task task) {
    setState(() {
      _tasks.remove(task);
    });
  }

  // Agrega una nueva tarea mediante un diálogo
  Future<void> _agregarTarea() async {
    final controller = TextEditingController();

    final nuevoTitulo = await showDialog<String>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Nueva tarea'),
          content: TextField(
            controller: controller,
            autofocus: true,
            decoration: const InputDecoration(
              hintText: 'Escribe el nombre de la tarea',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, controller.text.trim()),
              child: const Text('Agregar'),
            ),
          ],
        );
      },
    );

    if (nuevoTitulo != null && nuevoTitulo.isNotEmpty) {
      setState(() {
        _tasks.add(Task(title: nuevoTitulo));
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Equipo 10A — Tareas'),
        centerTitle: true,
        backgroundColor: const Color(0xFFDCD9FB),
        elevation: 0,
      ),
      body: Column(
        children: [
          // Fila con el switch del filtro
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Solo pendientes'),
                Switch(
                  value: _soloPendientes,
                  onChanged: _toggleFiltro,
                ),
              ],
            ),
          ),

          // Lista de tareas (filtrada o completa)
          Expanded(
            child: _tareasVisibles.isEmpty
                ? const Center(
              child: Text(
                'No hay tareas para mostrar',
                style: TextStyle(color: Colors.grey),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _tareasVisibles.length,
              itemBuilder: (context, index) {
                final task = _tareasVisibles[index];
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
                        color: task.isCompleted
                            ? Colors.grey
                            : Colors.black87,
                      ),
                    ),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete_outline),
                      onPressed: () => _eliminarTarea(task),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _agregarTarea,
        icon: const Icon(Icons.add_task),
        label: const Text('Agregar'),
        backgroundColor: const Color(0xFFDCD9FB),
        foregroundColor: Colors.indigo.shade900,
      ),
    );
  }
}