import 'dart:async';
import 'package:angular/di.dart' show Injectable;
import 'package:model/src/drum_sequencer/sound_signals.dart' as s;
import 'package:model/src/drum_sequencer/pattern.dart';

/// The Sequencer.
///
/// It emits the sequence of [SoundSignal] in [DrumPatterns] with specified beat index.
@Injectable()
class Sequencer {
  final DrumPatterns patterns;
  final _SignalEmitter _emitter;

  factory Sequencer() {
    return new Sequencer.withPatterns(new DrumPatterns(new List.generate(
        DrumPatterns.patternIds.length,
        (_) => new DrumTracks(s.soundSignals)).toSet()));
  }

  Sequencer.withPatterns(this.patterns) : _emitter = new _SignalEmitter();

  DrumPattern get selectedPattern => patterns.selected;

  void selectPattern(DrumPattern pattern) {
    patterns.select(pattern);
  }

  Stream<s.SoundSignal> get soundSignals => _emitter.signals;

  void emitSoundSignals(int beatIndex) {
    selectedPattern.soundSignalsOf(beatIndex).forEach(_emitter.emit);
  }
}

class _SignalEmitter {
  final StreamController<s.SoundSignal> _controller =
      new StreamController<s.SoundSignal>();

  Stream<s.SoundSignal> get signals => _controller.stream;

  void emit(s.SoundSignal signal) {
    _controller.add(signal);
  }
}
