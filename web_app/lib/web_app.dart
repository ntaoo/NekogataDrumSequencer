// Copyright (c) 2017, ntaoo. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:angular2/angular2.dart';
import 'package:angular_components/angular_components.dart';
import 'package:model/model.dart';
import 'src/control_panel.dart';
import 'src/pattern_editor.dart';

@Component(
  selector: 'drum-sequencer',
  template: '''
    <div class="header">
      <div class="brand-logo">Nekogata Drum Sequencer <span class="s">with AngularDart</span></div>
    </div>
    <div class="body">
      <control-panel></control-panel>
      <pattern-editor></pattern-editor>
    </div>
        
    <a href="https://github.com/ntaoo/NekogataDrumSequencer">
      <img style="position: absolute; top: 0; right: 0; border: 0;"
       src="https://camo.githubusercontent.com/652c5b9acfaddf3a9c326fa6bde407b87f7be0f4/68747470733a2f2f73332e616d617a6f6e6177732e636f6d2f6769746875622f726962626f6e732f666f726b6d655f72696768745f6f72616e67655f6666373630302e706e67"
       alt="Fork me on GitHub"
       data-canonical-src="https://s3.amazonaws.com/github/ribbons/forkme_right_orange_ff7600.png">
    </a>
  ''',
  styleUrls: const ['web_app.css'],
  directives: const [ControlPanel, PatternEditor],
  providers: const [materialProviders, modelProviders],
)
class WebApp {}
