import 'dart:async';

import 'package:model/src/drum_sequencer/player/sound.dart';
import 'package:model/src/drum_sequencer/sound_signals.dart';

abstract class SoundResource {
  Future<Sound> get(SoundSignal soundSignal);
  Future<Iterable<Sound>> getAll(Iterable<SoundSignal> soundSignals);
}
