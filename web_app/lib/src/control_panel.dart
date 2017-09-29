// Copyright (c) 2017, ntaoo. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:model/model.dart';

@Component(
    selector: 'control-panel',
    templateUrl: 'control_panel.html',
    styleUrls: const ['control_panel.css'],
    directives: const [CORE_DIRECTIVES, materialDirectives])
class ControlPanel {
  final DrumSequencer sequencer;
  bool isSetup = false;
  ControlPanel(this.sequencer) {
    sequencer.isSetup.then((bool v) => isSetup = v);
  }

  int parseToInt(String rangeValue) => num.parse(rangeValue).ceil();
}
