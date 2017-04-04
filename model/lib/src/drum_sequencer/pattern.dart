import 'dart:collection';
import 'package:model/src/drum_sequencer/sound_signals.dart';
import 'pattern/track.dart';

export 'pattern/track.dart';
export 'pattern/note.dart';

class DrumPatterns extends IterableMixin<DrumPattern> {
  static final List<String> patternIds = const ["1", "2", "3", "4"];
  final Set<DrumPattern> _patterns;
  DrumPattern _selected;

  factory DrumPatterns(Set<DrumTracks> tracksSet) {
    assert(tracksSet.length == patternIds.length);

    var patterns = <DrumPattern>[];

    var i = tracksSet.iterator;
    i.moveNext();
    for (var id in patternIds) {
      patterns.add(new DrumPattern(id, i.current));
      i.moveNext();
    }

    return new DrumPatterns._(patterns.toSet());
  }
  DrumPatterns._(this._patterns) : _selected = _patterns.first;

  Iterator<DrumPattern> get iterator => _patterns.iterator;
  DrumPattern get selected => _selected;

  void select(DrumPattern pattern) {
    _selected = _patterns.firstWhere((t) => t.id == pattern.id);
    print("pattern selected: ${selected.id}");
  }
}

class DrumPattern {
  final String id;
  final DrumTracks tracks;

  DrumPattern(this.id, this.tracks);

  DrumTrack get selectedTrack => tracks.selected;

  void selectTrack(DrumTrack track) {
    tracks.select(track);
  }

  Iterable<SoundSignal> soundSignalsOf(int beatIndex) {
    return tracks
        .map<SoundSignal>((t) => t.soundSignalOf(beatIndex))
        .where((s) => s != null);
  }
}
