import 'note.dart';

abstract class Score {
  List<Note> get notes;
}

class DrumScore extends Score {
  final List<Note> notes;

  DrumScore(this.notes);

  void toggleNote(int noteIndex) {
    // Convert noteIndex (starts at 1) to List index (starts at 0).
    int index = _toIndex(noteIndex);
    if (notes[index] == sixteenthNote) {
      notes[index] = rest;
    } else {
      notes[index] = sixteenthNote;
    }
  }

  Note noteAt(int noteIndex) => notes[_toIndex(noteIndex)];

  int _toIndex(int noteIndex) => noteIndex - 1;
}
