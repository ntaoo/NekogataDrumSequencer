# Nekogata Drum Sequencer with AngularDart

## What's this.

https://github.com/Shinpeim/NekogataDrumSequencer を、AngularDartで実装してみたもの。
[https://drum-sequencer-f54fe.firebaseapp.com/](https://drum-sequencer-f54fe.firebaseapp.com/)にて公開中。

### ドメイン知識

**TBD**

#### *DrumSequencer*

*DrumSequencer*は、*BeatController*, *Sequencer*, *Player*より構成される。詳細は各modelのdoc commentを参照。


### 用語マッピング

* Presentation層 -> Angular Component。このアプリではpackage:web_app.
* Use Case層 -> package:model/model.dartにおいてexportしている、このmodelのpublic interface.
* Domain層 -> package:model/src/ 以下のmodel。主にクラスとメソッドの名前とその組み合わせでドメイン知識を表現する。いにしえよりドメイン駆動設計と言われているもの。オブジェクト指向設計そのもの。
* Infrastructure層 -> 現在はpackage:model/src/repository/のみ。単純化のため、package:modelに含めている。必要に応じてpackageとして切り出す。 

### 設計に関するメモ

modelのpublic interfaceとsrc/以下の1,2段の浅い階層でドメイン知識を表現する。
packageのpublic interfaceは公開後はできるだけ維持し、ドメイン知識の進化に応じて内部構造を変更していく。

レイヤーごとにその名を冠したディレクトリを作成することはせず、代わりに別のpackageに切り出すことを検討する。
Model層を独立したpackageにすることでWebAppのViewControllerであるComponentと疎結合にしている。また、component/ディレクトリを作ったり_component接尾辞を付けずともcomponentであることが明確になる。

Modelの公開APIとしてexportしているものがxxxUseCase, xxxContextに相当する。接尾辞は追加してはいない。packageとdirectoryの構造はDart package conventionに従い、名前とディレクトリ構造を簡潔に保つ。

Modelの状態変化の検知とViewの更新は、現状ではAngularのChange Detectionが行っているため、modelは自身の状態変化を通知する必要はない。
 
実行環境になるべく依存しない、ウェブアプリでもネイティブアプリでも動作するModelを目指す。

#### 現在の制限

Domain層がWeb API(WebAudio in dart:html)に依存している。また、DIのためにpackage:angular2にも依存している。
Flutterなどの他の環境でも再利用可能にする、またテストサーバー(pub serve test)を立ち上げずにテストを実行するためには、それらのcodeを別のpackageに切り出す必要がある。