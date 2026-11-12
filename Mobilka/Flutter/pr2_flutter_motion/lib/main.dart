import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/note_cubit.dart';

void main() {
  runApp(const NotesApp());
}

class NotesApp extends StatelessWidget {
  const NotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => NoteCubit(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Заметки',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          useMaterial3: true,
        ),
        home: const NotesPage(),
      ),
    );
  }
}

class NotesPage extends StatefulWidget {
  const NotesPage({super.key});

  @override
  State<NotesPage> createState() => _NotesPageState();
}

class _NotesPageState extends State<NotesPage> {
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _saveNote() {
    if (_controller.text.trim().isEmpty) return;
    context.read<NoteCubit>().saveNote(_controller.text);
    _controller.clear();
  }

  void _deleteNote(int index) {
    final cubit = context.read<NoteCubit>();
    final wasEditingDeleted = cubit.state.editingIndex == index;
    cubit.deleteNote(index);
    if (wasEditingDeleted) {
      _controller.clear();
    }
  }

  void _editNote(int index) {
    final cubit = context.read<NoteCubit>();
    cubit.editNote(index);
    _controller.text = cubit.state.notes[index].text;
  }

  void _showNote(Note note) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Row(
          children: [
            const Expanded(child: Text('Заметка')),
            if (note.isImportant)
              const Icon(Icons.star, color: Colors.amber),
          ],
        ),
        content: SingleChildScrollView(child: Text(note.text)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: const Text('Закрыть'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Заметки'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: BlocBuilder<NoteCubit, NoteState>(
          builder: (context, state) {
            final isEditing = state.editingIndex != null;

            return Column(
              children: [
                TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: isEditing ? 'Редактировать заметку' : 'Новая заметка',
                    border: const OutlineInputBorder(),
                  ),
                  maxLines: null,
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _saveNote,
                    child: Text(isEditing ? 'Сохранить изменения' : 'Сохранить'),
                  ),
                ),
                const SizedBox(height: 16),
                const Divider(),
                const SizedBox(height: 8),
                Expanded(
                  child: state.notes.isEmpty
                      ? const Center(child: Text('Заметок пока нет'))
                      : ListView.builder(
                          itemCount: state.notes.length,
                          itemBuilder: (context, index) {
                            final note = state.notes[index];
                            return Dismissible(
                              key: ObjectKey(note.id),
                              direction: DismissDirection.horizontal,
                              confirmDismiss: (direction) async {
                                if (direction == DismissDirection.endToStart) {
                                  return true;
                                }

                                // Свайп вправо снимает отметку важности,
                                // но не удаляет карточку из списка.
                                if (note.isImportant) {
                                  context
                                      .read<NoteCubit>()
                                      .setImportant(index, false);
                                }
                                return false;
                              },
                              onDismissed: (direction) {
                                _deleteNote(index);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('Заметка удалена')),
                                );
                              },
                              background: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                color: Colors.green,
                                child: const Icon(Icons.star_border,
                                    color: Colors.white),
                              ),
                              secondaryBackground: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                color: Colors.red,
                                child: const Icon(Icons.delete,
                                    color: Colors.white),
                              ),
                              child: GestureDetector(
                                onTap: () => _showNote(note),
                                onDoubleTap: () => context
                                    .read<NoteCubit>()
                                    .setImportant(index, true),
                                onLongPress: () => _editNote(index),
                                child: Card(
                                  color: note.isImportant
                                      ? Colors.amber.shade100
                                      : null,
                                  child: ListTile(
                                    title: Text(
                                      note.text,
                                      maxLines: 3,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(fontSize: 16,),
                                    ),
                                    trailing: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        if (note.isImportant)
                                          const Icon(Icons.star,
                                              color: Colors.amber),
                                        IconButton(
                                          icon: const Icon(Icons.edit),
                                          onPressed: () => _editNote(index),
                                        ),
                                        IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () => _deleteNote(index),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
