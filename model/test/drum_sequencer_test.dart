import 'dart:async';

import 'package:mockito/mockito.dart';
import 'package:model/src/drum_sequencer.dart';
import 'package:model/src/drum_sequencer/beat_controller.dart';
import 'package:model/src/drum_sequencer/player/sound.dart';
import 'package:model/src/drum_sequencer/sequencer.dart';
import 'package:model/src/drum_sequencer/sound_signals.dart';
import 'package:model/src/repository/sound_resource.dart';
import 'package:quiver/iterables.dart';
import 'package:test/test.dart';

void main() {
  DrumSequencer sequencer;
  SoundResourceMock soundResourceMock;

  group(DrumSequencer, () {
    setUpAll(() {
      soundResourceMock = _prepareSoundResourceMock(_prepareSoundMocks());
    });

    setUp(() async {
      sequencer = new DrumSequencer(new BeatController(new BpmTicker()),
          new Sequencer(), soundResourceMock);
      await sequencer.isSetup;
    });

    test('is setup', () async {
      expect(await sequencer.isSetup, isTrue);
    });

    group('bpm', () {
      test('default bpm', () {
        expect(sequencer.bpm, 120);
      });
      test('can change bpm', () {
        sequencer.bpm = 121;
        expect(sequencer.bpm, 121);
      });
      test('maximum bpm', () {
        sequencer.bpm = 240;
        expect(sequencer.bpm, 240);
        expect(() => sequencer.bpm = 241, throwsArgumentError);
      });
      test('minimum bpm', () {
        sequencer.bpm = 10;
        expect(sequencer.bpm, 10);
        expect(() => sequencer.bpm = 9, throwsArgumentError);
      });
    });

    group('patterns, tracks', () {
      test(
          '4 patters, each has 4 tracks, each default selected is the first one',
          () {
        expect(sequencer.patterns, hasLength(4));
        expect(sequencer.selectedPattern, sequencer.patterns.first);
        for (var pattern in sequencer.patterns) {
          expect(pattern.tracks, hasLength(4));
          expect(pattern.selectedTrack, pattern.tracks.first);
        }
      });
    });

    group('Before start', () {
      test('is inactive', () {
        expect(sequencer.isActive, isFalse);
      });
      test('beat index is 1', () {
        expect(sequencer.currentBeatIndex, 1);
      });
    });

    group('After start', () {
      setUp(() {
        assert(!sequencer.isActive);
        sequencer.toggle();
      });

      test('is active', () {
        expect(sequencer.isActive, isTrue);
      });

      test('stop', () {
        sequencer.toggle();
        expect(sequencer.isActive, isFalse);
      });
    });
  });
  group('sound sequence test', () {
    List<SoundMock> sounds;
    BpmTickerDouble ticker;
    setUp(() async {
      sounds = _prepareSoundMocks();
      soundResourceMock = _prepareSoundResourceMock(sounds);
      ticker = new BpmTickerDouble();
      sequencer = new DrumSequencer(
          new BeatController(ticker), new Sequencer(), soundResourceMock);
      await sequencer.isSetup;
      sequencer.toggle(); // start.
    });

    group('play sounds of beats', () {
      test('beat index', () {
        var twoTimeLoop = () {
          for (int n in range(1, 16)) {
            expect(sequencer.currentBeatIndex, n);
            ticker.tick();
          }
        };
        twoTimeLoop();
      });
      // TODO: more pattern.
      test('play sounds of a pattern', () async {
        var bdSound = sounds.singleWhere((s) => s.signal == bd);
        var sdSound = sounds.singleWhere((s) => s.signal == sd);
        var hhSound = sounds.singleWhere((s) => s.signal == hh);
        var rcSound = sounds.singleWhere((s) => s.signal == rc);
        ticker.tick();
        // waiting for the sound is played.
        await new Future.microtask(() {
          verify(bdSound.play()).called(1);
        });
        await new Future.microtask(() {
          verify(hhSound.play()).called(1);
        });
        await new Future.microtask(() {
          verifyNever(sdSound.play());
        });
        await new Future.microtask(() {
          verifyNever(rcSound.play());
        });
        for (var s in sounds) {
          reset(s);
        }
      });
    });
    group('toggle note', () {
      test('toggle first note', () {
        expect(sequencer.selectedTrack.score.noteAt(1), sixteenthNote);
        sequencer.selectedTrack.score.toggleNote(1);
        expect(sequencer.selectedTrack.score.noteAt(1), rest);
      });
    });
  });
}

List<Sound> _prepareSoundMocks() {
  List<Sound> r = [];
  for (var signal in soundSignals) {
    var sound = new SoundMock();
    when(sound.signal).thenReturn(signal);
    r.add(sound);
  }
  return r;
}

SoundResourceMock _prepareSoundResourceMock(List<Sound> sounds) {
  var soundResource = new SoundResourceMock();
  when(soundResource.getAll(sounds.map((s) => s.signal)))
      .thenReturn(new Future.value(sounds));
  return soundResource;
}

class BpmTickerDouble extends BpmTicker {
  Function action;

  @override
  void start() {
    // do nothing.
  }

  void tick() {
    action();
  }
}

class SoundMock extends Mock implements Sound {}

class SoundResourceMock extends Mock implements SoundResource {}
