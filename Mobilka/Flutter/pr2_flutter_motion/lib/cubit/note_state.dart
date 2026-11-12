part of 'note_cubit.dart';

@immutable
class Note {
  Note({required this.text, this.isImportant = false, Object? id})
      : id = id ?? Object();

  final String text;
  final bool isImportant;
  final Object id;
}

@immutable
sealed class NoteState {
  const NoteState({required this.notes, this.editingIndex});

  final List<Note> notes;
  final int? editingIndex;
}

final class NoteInitial extends NoteState {
  const NoteInitial() : super(notes: const []);
}

final class NoteLoaded extends NoteState {
  const NoteLoaded({required super.notes, super.editingIndex});
}
