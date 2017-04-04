import 'package:model/src/drum_sequencer/sound_signals.dart';

abstract class Sound {
  SoundSignal get signal;
  void play();
}
