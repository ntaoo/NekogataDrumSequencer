// Copyright (c) 2017, ntaoo. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.
import 'package:angular/di.dart';
import 'package:model/src/drum_sequencer.dart';
import 'package:model/src/repository/sound_resource.dart';
import 'package:model/src/repository/web_sound_resource.dart';

const List<dynamic> modelProviders = const [
  drumSequencerProviders,
  resourceProviders
];

const List resourceProviders = const [soundResourceProvider];

const Provider soundResourceProvider =
    const Provider(SoundResource, useClass: WebSoundResource);
