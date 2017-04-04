import 'dart:html';
import 'dart:async';
import 'dart:web_audio';
import 'package:angular2/angular2.dart';
import 'package:model/src/drum_sequencer/player/web_sound.dart';
import 'package:model/src/drum_sequencer/sound_signals.dart';
import 'package:model/src/repository/sound_resource.dart';

@Injectable()
class WebSoundResource implements SoundResource {
  final String _location = 'packages/model/src/repository/sound_data/';

  Future<Iterable<WebSound>> getAll(Iterable<SoundSignal> soundSignals) {
    return Future.wait(soundSignals.map((s) => get(s)));
  }

  Future<WebSound> get(SoundSignal soundSignal) async {
    var request = await HttpRequest.request(_uriOf(soundSignal),
        method: 'GET', responseType: 'arraybuffer');
    var context = new AudioContext();
    var buffer = await context.decodeAudioData(request.response);
    return new WebSound(soundSignal, context, buffer);
  }

  String _uriOf(SoundSignal soundSignal) =>
      '$_location${_dataName(soundSignal)}';

  String _dataName(SoundSignal soundSignal) =>
      '${soundSignal.name.toLowerCase()}.wav';
}
