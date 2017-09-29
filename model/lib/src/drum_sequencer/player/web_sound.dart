import 'dart:web_audio';

import 'package:model/src/drum_sequencer/player/sound.dart';
import 'package:model/src/drum_sequencer/sound_signals.dart';

class WebSound implements Sound {
  final SoundSignal signal;
  final AudioContext _audioContext;
  final AudioBuffer _buffer;

  WebSound(this.signal, this._audioContext, this._buffer);

  void play() {
    print("playing sound: ${signal.name}");
    _audioContext.createBufferSource()
      ..buffer = _buffer
      ..connectNode(_audioContext.destination)
      ..start(0);
  }
}
