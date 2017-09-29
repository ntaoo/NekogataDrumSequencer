import 'dart:async';
import 'package:angular/di.dart' show Injectable;
import 'drum_sequencer/beat_controller.dart';
import 'drum_sequencer/sound_signals.dart';
import 'drum_sequencer/player.dart';
import 'drum_sequencer/sequencer.dart';
import 'drum_sequencer/pattern.dart';
import 'drum_sequencer/pattern/track.dart';
import 'drum_sequencer/pattern/note.dart';
import 'repository/sound_resource.dart';

export 'drum_sequencer/pattern/note.dart';

const List drumSequencerProviders = const [
  DrumSequencer,
  beatControllerProviders,
  Sequencer,
];

/// The Drum Sequencer.
///
/// It controls the sequence of [SoundSignal] with [Sequencer] and [BeatController],
/// and play the [Sound] of [SoundSignal]s with [Player].
@Injectable()
class DrumSequencer {
  final BeatController _beatController;
  final Sequencer _sequencer;
  final Player _player;
  final SoundResource _soundResource;
  final Completer<bool> _setupCompleter;
  DrumSequencer(this._beatController, this._sequencer, this._soundResource)
      : _player = new Player(),
        _setupCompleter = new Completer() {
    _beatController.actionOnBeat = _sequencer.emitSoundSignals;
    _setUp().then((_) => _setupCompleter.complete(true));
  }

  Future<bool> get isSetup => _setupCompleter.future;

  /// Start or Stop this drum sequencer.
  void toggle() {
    if (_beatController.isActive) {
      _beatController.stop();
    } else {
      _beatController.start();
    }
  }

  bool get isActive => _beatController.isActive;

  set bpm(int v) => _beatController.bpm = v;
  int get bpm => _beatController.bpm;

  int get maximumBpm => _beatController.maximumBpm;
  int get minimumBpm => _beatController.minimumBpm;

  int get currentBeatIndex => _beatController.currentBeatIndex;

  Iterable<DrumPattern> get patterns => _sequencer.patterns;
  DrumPattern get selectedPattern => _sequencer.selectedPattern;
  Iterable<Track> get tracks => selectedPattern.tracks;
  DrumTrack get selectedTrack => selectedPattern.selectedTrack;
  Iterable<Note> get notes => selectedTrack.score.notes;

  void selectPattern(DrumPattern pattern) {
    _sequencer.selectPattern(pattern);
  }

  void selectTrack(DrumTrack drumTrack) {
    _sequencer.selectedPattern.selectTrack(drumTrack);
  }

  void toggleNote(int noteIndex) {
    selectedTrack.score.toggleNote(noteIndex);
  }

  Future<Null> _setUp() async {
    _player.sounds = await _soundResource.getAll(soundSignals);
    _player.listen(_sequencer.soundSignals);
  }
}
