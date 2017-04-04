import 'dart:async';
import 'package:model/src/drum_sequencer/sound_signals.dart' show SoundSignal;
import 'player/sound.dart' show Sound;

/// Sound Player
///
/// It [listen]s to [SoundSignal]s to [play] the sound of the signal.
/// The [sounds] must be set before this player starts to listen to the signals.
class Player {
  Map<SoundSignal, Sound> _sounds;
  StreamSubscription<SoundSignal> _soundSignalsSubscription;

  set sounds(Iterable<Sound> sounds) {
    Map<SoundSignal, Sound> soundsMap = {};
    for (var sound in sounds) {
      soundsMap[sound.signal] = sound;
    }
    _sounds = soundsMap;
  }

  void listen(Stream<SoundSignal> soundSignals) {
    _soundSignalsSubscription?.cancel();
    _soundSignalsSubscription = soundSignals.listen(_play);
  }

  void _play(SoundSignal soundSignal) {
    assert(_sounds.containsKey(soundSignal),
        "Can't play ${soundSignal.name}. Unknown soundSignal.");
    
    _sounds[soundSignal].play();
  }
}
