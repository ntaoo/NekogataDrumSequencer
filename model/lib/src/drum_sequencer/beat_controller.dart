import 'dart:async';

import 'package:angular/di.dart' show Injectable;

typedef void ActionOnBeat(int currentBeatIndex);

const List beatControllerProviders = const [BeatController, BpmTicker];

@Injectable()
class BeatController {
  static final int _defaultBpm = 120;
  final int maximumBpm = 240;
  final int minimumBpm = 10;
  final BpmTicker _ticker;
  final _BeatLoop _beatLoop;
  ActionOnBeat _actionOnBeat;

  factory BeatController(BpmTicker _ticker) {
    _ticker.bpm = _defaultBpm;
    return new BeatController._(_ticker, new _BeatLoop());
  }
  BeatController._(this._ticker, this._beatLoop);

  set actionOnBeat(ActionOnBeat actionOnBeat) {
    _actionOnBeat = actionOnBeat;
    _ticker.action = _tickerAction;
  }

  set bpm(int bpm) {
    if (bpm < minimumBpm || bpm > maximumBpm) {
      throw new ArgumentError.value(bpm, 'bpm',
          'is greater than or equals to $minimumBpm and lesser than or equals to $maximumBpm');
    }

    _ticker.bpm = bpm;
    if (isActive) _ticker.restart();
  }

  int get bpm => _ticker.bpm;

  int get currentBeatIndex => _beatLoop.current;

  bool get isActive => _ticker.isActive;

  void start() {
    _ticker.start();
  }

  void stop() {
    _ticker.stop();
    _beatLoop.reset();
  }

  void _tickerAction() {
    _actionOnBeat(currentBeatIndex);
    _beatLoop.next();
  }
}

typedef void _Action();

@Injectable()
class BpmTicker {
  int bpm = 120;
  _Action _action;
  Timer _timer;

  bool get isActive => _timer?.isActive ?? false;

  set action(_Action f) {
    _action = f;
  }

  void start() {
    assert(!isActive && _action != null);

    _timer = new Timer.periodic(
        new Duration(milliseconds: _millSecPer16thNote), (_) => _action());
  }

  void restart() {
    stop();
    start();
  }

  void stop() {
    _timer.cancel();
  }

  int get _millSecPer16thNote => 60000 ~/ (bpm * 4);
}

class _BeatLoop {
  final int _tail = 16;
  final int _head = 1;
  int current = 1;

  void next() {
    assert(current <= _tail);

    if (current == _tail) {
      current = _head;
    } else {
      current++;
    }
  }

  void reset() {
    current = _head;
  }
}

// TODO: Is introducing [Beat] good idea?
//class Beat {
//  int number;
//}
