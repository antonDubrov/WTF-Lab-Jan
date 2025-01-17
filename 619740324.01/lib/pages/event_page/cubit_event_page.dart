import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import '../../event.dart';
import '../../note.dart';
import 'states_event_page.dart';

class CubitEventPage extends Cubit<StatesEventPage> {
  CubitEventPage() : super(const StatesEventPage());

  void init(Note note, List<Note> noteList) {
    setNote(note);
    setNoteList(noteList);
    setTextSearch(false);
    setEventEditing(false);
    removeSelectedCircleAvatar();
  }

  void setWriting(bool isWriting) => emit(state.copyWith(isWriting: isWriting));

  void setTextSearch(bool isTextSearch) =>
      emit(state.copyWith(isTextSearch: isTextSearch));

  void setNoteList(List<Note> noteList) =>
      emit(state.copyWith(noteList: noteList));

  void setChoosingCircleAvatar(bool isChoosingCircleAvatar) =>
      emit(state.copyWith(isChoosingCircleAvatar: isChoosingCircleAvatar));

  void setSelectedCircleAvatar(int selectedCircleAvatar) =>
      emit(state.copyWith(selectedCircleAvatar: selectedCircleAvatar));

  void removeSelectedCircleAvatar() =>
      emit(state.copyWith(selectedCircleAvatar: -1));

  void setSelectedNoteIndex(int selectedNoteIndex) =>
      emit(state.copyWith(selectedNoteIndex: selectedNoteIndex));

  void setNote(Note? note) => emit(state.copyWith(note: note));

  void setEventEditing(bool isEventEditing) =>
      emit(state.copyWith(isEventEditing: isEventEditing));

  void setEventPressed(bool isEventPressed) =>
      emit(state.copyWith(isEventPressed: isEventPressed));

  void deleteEvent(int selectedEventIndex) {
    state.note?.eventList.remove(state.note?.eventList[selectedEventIndex]);
    setNote(state.note);
  }

  void editText(int selectedEventIndex, String text) {
    if (text.isNotEmpty) {
      state.note?.eventList[selectedEventIndex].text = text;
      state.note?.eventList[selectedEventIndex].indexOfCircleAvatar =
          state.selectedCircleAvatar;
      setEventEditing(false);
      setWriting(false);
    } else {
      deleteEvent(selectedEventIndex);
      setEventEditing(false);
      setWriting(false);
    }
  }

  void setSelectedEventIndex(int selectedEventIndex) =>
      emit(state.copyWith(selectedEventIndex: selectedEventIndex));

  void sendEvent(String text) {
    final event = Event(
      text: text,
      indexOfCircleAvatar: state.selectedCircleAvatar,
      isBookmark: false,
      time: state.time == ''
          ? DateFormat.jms().format(DateTime.now())
          : state.time,
      date: state.date == ''
          ? DateFormat.yMMMd().format(DateTime.now())
          : state.date,
    );
    if (text.isNotEmpty) {
      final updatedList = [...state.note!.eventList, event]..sort(
          (a, b) {
            final aDate = DateFormat().add_jms().parse(a.time);
            final bDate = DateFormat().add_jms().parse(b.time);
            return bDate.compareTo(aDate);
          },
        );
      state.note!.eventList = updatedList;
      state.note!.subTittleEvent = text;
      emit(state.copyWith(note: state.note));
      setWriting(false);
      setEventPressed(false);
    }
  }
}
