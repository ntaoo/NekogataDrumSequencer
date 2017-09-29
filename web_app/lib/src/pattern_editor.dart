// Copyright (c) 2017, ntaoo. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:model/model.dart';

@Component(
    selector: 'pattern-editor',
    templateUrl: 'pattern_editor.html',
    styleUrls: const ['pattern_editor.css'],
    directives: const [CORE_DIRECTIVES, materialDirectives])
class PatternEditor {
  final DrumSequencer sequencer;
  final int _rawSize = 4;

  PatternEditor(this.sequencer);

  Map<String, bool> classOfNote(Note note) {
    bool isSixteenthNote = note == sixteenthNote;
    // Only two kinds of note available in current spec.
    return {
      'sixteen-note': isSixteenthNote,
      'rest': !isSixteenthNote,
    };
  }

  Map<String, bool> classOfRow(int rowIndex, int beatIndex, bool isActive) {
    return {
      'playing-row': isActive && rowIndex == (beatIndex / _rawSize).ceil()
    };
  }
  List<Iterable<Note>> divideByRawSize(List<Note> notes) {
    List<Iterable<Note>> r = [];
    for (int i = 0; i < _rawSize; i++) {
      r.add(notes.skip(i * _rawSize).take(_rawSize));
    }
    return r;
  }

  int noteIndex(int i, int j) => (_rawSize * i) + j + 1;
  int rowIndex(int i) => i + 1;
}
