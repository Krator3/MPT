import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';

part 'note_state.dart';

class NoteCubit extends Cubit<NoteState> {
  NoteCubit() : super(const NoteInitial());

  void saveNote(String rawText) {
    final text = rawText.trim();
    if (text.isEmpty) return;

    final notes = List<Note>.of(state.notes);
    final editingIndex = state.editingIndex;

    if (editingIndex == null) {
      notes.add(Note(text: text));
    } else {
      notes[editingIndex] = Note(
        text: text,
        isImportant: notes[editingIndex].isImportant,
        id: notes[editingIndex].id,
      );
    }

    emit(NoteLoaded(notes: notes));
  }

  void editNote(int index) {
    if (index < 0 || index >= state.notes.length) return;
    emit(NoteLoaded(notes: state.notes, editingIndex: index));
  }

  void setImportant(int index, bool isImportant) {
    if (index < 0 || index >= state.notes.length) return;

    final notes = List<Note>.of(state.notes);
    notes[index] = Note(
      text: notes[index].text,
      isImportant: isImportant,
      id: notes[index].id,
    );
    emit(NoteLoaded(notes: notes, editingIndex: state.editingIndex));
  }

  void deleteNote(int index) {
    if (index < 0 || index >= state.notes.length) return;

    final notes = List<Note>.of(state.notes)..removeAt(index);
    final editingIndex = state.editingIndex;

    int? nextEditingIndex = editingIndex;
    if (editingIndex == index) {
      nextEditingIndex = null;
    } else if (editingIndex != null && editingIndex > index) {
      nextEditingIndex = editingIndex - 1;
    }

    emit(NoteLoaded(notes: notes, editingIndex: nextEditingIndex));
  }
}
