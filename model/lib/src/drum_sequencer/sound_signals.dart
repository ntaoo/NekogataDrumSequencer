class SoundSignal {
  final String name;
  const SoundSignal(this.name);
}

/// Bus Drum
const bd = const SoundSignal('BD');

/// Snare Drum
const sd = const SoundSignal('SD');

/// Hi-Hat
const hh = const SoundSignal('HH');

/// Ride Cymbal
const rc = const SoundSignal('RC');

const List<SoundSignal> soundSignals = const [bd, sd, hh, rc];
