import 'dart:collection';

import 'package:model/src/drum_sequencer/sound_signals.dart';

import 'note.dart';
import 'score.dart';

const List<Note> _initialNotesOfBD = const [
  sixteenthNote,
  rest,
  rest,
  rest,
  rest,
  rest,
  rest,
  rest,
  sixteenthNote,
  rest,
  rest,
  rest,
  rest,
  rest,
  rest,
  rest
];

const List<Note> _initialNotesOfHH = const [
  sixteenthNote,
  rest,
  sixteenthNote,
  rest,
  sixteenthNote,
  rest,
  sixteenthNote,
  rest,
  sixteenthNote,
  rest,
  sixteenthNote,
  rest,
  sixteenthNote,
  rest,
  sixteenthNote,
  rest
];

const List<Note> _initialNotesOfRC = const [
  rest,
  rest,
  rest,
  rest,
  rest,
  rest,
  rest,
  rest,
  rest,
  rest,
  rest,
  rest,
  rest,
  rest,
  rest,
  rest
];

const List<Note> _initialNotesOfSD = const [
  rest,
  rest,
  rest,
  rest,
  sixteenthNote,
  rest,
  rest,
  rest,
  rest,
  rest,
  rest,
  rest,
  sixteenthNote,
  rest,
  rest,
  rest
];

final Map<SoundSignal, List<Note>> initialNoteOfTrack = const {
  bd: _initialNotesOfBD,
  sd: _initialNotesOfSD,
  hh: _initialNotesOfHH,
  rc: _initialNotesOfRC
};

class DrumTrack extends Track {
  final int beat = 16;
  final SoundSignal soundSignal;
  final DrumScore score;

  DrumTrack(this.soundSignal, this.score) {
    assert(_isValidScore);
  }

  String get name => soundSignal.name;

  SoundSignal soundSignalOf(int beatIndex) {
    var note = score.notes[beatIndex - 1];
    if (note == rest) {
      return null;
    } else {
      return soundSignal;
    }
  }
}

class DrumTracks extends IterableMixin<DrumTrack> {
  final Set<DrumTrack> _drumTracks;
  DrumTrack _selected;

  factory DrumTracks(List<SoundSignal> soundNames) {
    var drumTracks = soundNames
        .map((s) => new DrumTrack(
            s, new DrumScore(new List.from(initialNoteOfTrack[s]))))
        .toSet();

    return new DrumTracks._(drumTracks);
  }
  DrumTracks._(this._drumTracks) : _selected = _drumTracks.first;

  Iterator<DrumTrack> get iterator => _drumTracks.iterator;
  DrumTrack get selected => _selected;

  void select(DrumTrack track) {
    _selected = _drumTracks.firstWhere((t) => t.name == track.name);
    print("track selected: ${selected.name}");
  }
}

abstract class Track {
  int get beat;
  String get name;
  Score get score;
  bool get _isValidScore => score.notes.length == beat;
}
