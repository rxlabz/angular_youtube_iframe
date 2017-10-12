import 'dart:async';

import 'package:angular/angular.dart';
import 'package:js/js.dart';
import 'package:youtube_player_interop/youtube_player_interop.dart';

import '../tube_service.dart';

@Component(
  selector: 'youtube-iframe',
  templateUrl: 'youtube_iframe.html',
  providers: const [TubeService],
  styleUrls: const ['youtube_iframe.css'],
)
class YoutubeIFrame implements OnInit {
  YoutubeIFrame(this.ytService);

  TubeService ytService;

  PlayerState currentState = PlayerState.notStarted;

  @Input()
  int width = 480;

  @Input()
  int height = 360;

  @Input()
  void set videoId(String value) {
    _videoId = value;
    updatePlayer();
  }

  String _videoId;

  @Input()
  String playerId = 'ytframe';

  @Input()
  void set showControls(bool value) {
    print('YoutubeIFrame.showControls... $value');
    _showControls = value;
    updatePlayer();
  }

  bool _showControls = true;
  int get controls => _showControls ? 1 : 0;

  @Input()
  void set showInfos(bool value) {
    _showInfos = value;
    updatePlayer();
  }

  bool _showInfos = false;
  int get infos => _showInfos ? 1 : 0;

  bool _autoPlay = false;

  @Input()
  void set autoPlay(bool value) {
    _autoPlay = value;
    updatePlayer();
  }

  int get willPlayAuto => _autoPlay ? 1 : 0;

  @Input()
  void set disableKeyboard(bool value) {
    _disableKeyboard = value;
    updatePlayer();
  }

  bool _disableKeyboard = false;
  int get disablekb => _disableKeyboard ? 1 : 0;

  @Input()
  void set modestBranding(bool value) {
    _modestBranding = value;
    updatePlayer();
  }

  bool _modestBranding = false;
  int get modestbranding => _modestBranding ? 1 : 0;

  @Input()
  void set mobilePlaysInline(bool value) {
    _mobilePlaysInline = value;
    updatePlayer();
  }

  bool _mobilePlaysInline = false;
  int get playsinline => _mobilePlaysInline ? 1 : 0;

  @Input()
  void set allowFS(bool value) {
    _allowFS = value;
    updatePlayer();
  }

  bool _allowFS = false;
  int get fs => _allowFS ? 1 : 0;

  @Input()
  void set start(int value) {
    _start = value;
    updatePlayer();
  }

  int _start = 0;

  @Input()
  void set end(int value) {
    _end = value;
    updatePlayer();
  }

  int _end = 0;

  StreamController<Player> readyStreamer =
      new StreamController<Player>.broadcast();
  @Output('onReady')
  Stream<Player> get ready$ => readyStreamer.stream;

  StreamController<PlayerState> playerStateStreamer =
      new StreamController<PlayerState>.broadcast();
  @Output('onStateChange')
  Stream<PlayerState> get playerState$ => playerStateStreamer.stream;

  StreamController<YTPlayerError> errorStreamer =
      new StreamController<YTPlayerError>.broadcast();

  @Output('onError')
  Stream<YTPlayerError> get error$ => errorStreamer.stream;

  Player player;

  @override
  void ngOnInit() => ytService.init(onYTReady);

  void onYTReady() => createPlayer();

  void createPlayer() {
    player = ytService.createPlayer(
        playerId,
        new PlayerOptions(
            width: width.toString(),
            height: height.toString(),
            videoId: _videoId,
            playerVars: new PlayerVars(
              controls: controls,
              showinfo: infos,
              disablekb: disablekb,
              autoplay: willPlayAuto,
              enablejsapi: 1,
              playsinline: playsinline,
              fs: fs,
              start: _start,
              end: _end,
            ),
            events: new Events(
                onReady: allowInterop(onReady),
                onStateChange: allowInterop(onStateChange),
                onError: allowInterop(
                    (EventArgs ev) => errorStreamer.add(getError(ev.data))))));
    playerState$.listen((s) => currentState = s);
  }

  void onReady(EventArgs eventArgs) {
    readyStreamer.add(player);
  }

  void onStateChange(EventArgs eventArgs) {
    playerStateStreamer.add(stateFromInt(eventArgs.data));
  }

  void updatePlayer() {
    if (player != null) {
      if (currentState == PlayerState.playing) player.stopVideo();
      player.destroy();
      createPlayer();
    }
  }
}
