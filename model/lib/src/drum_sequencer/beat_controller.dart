import 'dart:async';

import 'package:angular/di.dart' show Injectable;

const List beatControllerProviders = const [BeatController, BpmTicker];

typedef void ActionOnBeat(int currentBeatIndex);

typedef void _Action();

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

  int get bpm => _ticker.bpm;

  set bpm(int bpm) {
    if (bpm < minimumBpm || bpm > maximumBpm) {
      throw new ArgumentError.value(bpm, 'bpm',
          'is greater than or equals to $minimumBpm and lesser than or equals to $maximumBpm');
    }

    _ticker.bpm = bpm;
    if (isActive) _ticker.restart();
  }

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

@Injectable()
class BpmTicker {
  int bpm = 120;
  _Action _action;
  Timer _timer;

  set action(_Action f) {
    _action = f;
  }

  bool get isActive => _timer?.isActive ?? false;

  int get _millSecPer16thNote => 60000 ~/ (bpm * 4);

  void restart() {
    stop();
    start();
  }

  void start() {
    assert(!isActive && _action != null);

    _timer = new Timer.periodic(
        new Duration(milliseconds: _millSecPer16thNote), (_) => _action());
  }

  void stop() {
    _timer.cancel();
  }
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
