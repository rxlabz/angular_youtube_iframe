import 'dart:async';

import 'package:angular/angular.dart';
import 'package:youtube_player_interop/youtube_player_interop.dart';

import '../tube_service.dart';

@Component(
  selector: 'youtube-iframe',
  templateUrl: 'youtube_iframe.html',
  providers: const [TubeService],
  styleUrls: const ['youtube_iframe.css'],
)
class YoutubeIFrame implements OnInit {
  TubeService ytService;

  YoutubeIFrame(this.ytService);

  @Input()
  int width = 480;

  @Input()
  int height = 360;

  @Input()
  String videoId;

  @Input()
  String playerId = 'ytframe';

  @Input()
  bool showControls = true;
  int get controls => showControls ? 1 : 0;

  @Input()
  bool showInfos = false;
  int get infos => showInfos ? 1 : 0;

  @Input()
  bool autoPlay = false;
  int get willPlayAuto => autoPlay ? 1 : 0;

  @Input()
  bool disableKeyboard = false;
  int get disablekb => autoPlay ? 1 : 0;

  @Input()
  bool embedOnMobile = false;
  int get playsinline => embedOnMobile ? 1 : 0;

  StreamController<Null> readyStreamer = new StreamController<Null>();
  @Output('onReady')
  Stream<Null> get ready$ => readyStreamer.stream;

  StreamController<PlayerState> playerStateStreamer =
      new StreamController<PlayerState>();
  @Output('onStateChange')
  Stream<PlayerState> get playerState$ => playerStateStreamer.stream;

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
            videoId: videoId,
            playerVars: new PlayerVars(
              controls: controls,
              showinfo: infos,
              disablekb: disablekb,
              autoplay: willPlayAuto,
              enablejsapi: 1,
              playsinline: playsinline,
            ),
            events:
                new Events(onReady: onReady, onStateChange: onStateChange)));
  }

  void onReady(EventArgs eventArgs) {
    readyStreamer.add(null);
  }

  void onStateChange(EventArgs eventArgs) {
    playerStateStreamer.add(stateFromInt(eventArgs.data));
  }
}
