/// Bus Drum
const bd = const SoundSignal('BD');

/// Hi-Hat
const hh = const SoundSignal('HH');

/// Ride Cymbal
const rc = const SoundSignal('RC');

/// Snare Drum
const sd = const SoundSignal('SD');

const List<SoundSignal> soundSignals = const [bd, sd, hh, rc];

class SoundSignal {
  final String name;
  const SoundSignal(this.name);
}
