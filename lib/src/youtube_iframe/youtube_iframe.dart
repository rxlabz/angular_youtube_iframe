import 'dart:async';

import 'package:angular/angular.dart';
import 'package:js/js.dart';
import 'package:youtube_player_interop/youtube_player_interop.dart';

import '../tube_service.dart';

@Component(
  selector: 'youtube-iframe',
  templateUrl: 'youtube_iframe.html',
  directives: const [NgIf],
  providers: const [TubeService],
  styleUrls: const ['youtube_iframe.css'],
)
class YoutubeIFrame implements OnInit {

  YoutubeIFrame(this.ytService);

  TubeService ytService;

  PlayerState currentState = PlayerState.notStarted;

  Player player;

  Timer ticker;

  String progressValue;
  String preloadPercent;
  String timeLabel;

  @Input()
  bool blockVideoInteraction = true;

  num _width = 640;

  num get width => _width;

  @Input()
  void set width(num width) {
    _width = width.toInt();
  }

  num _height = 360;

  num get height => _height;

  @Input()
  void set height(num height) {
    _height = height.toInt();
  }

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
    _allowFS = value ? 1 : 0;
    updatePlayer();
  }

  int _allowFS = 1;

  @Input()
  void set showRelated(bool value) {
    _showRelated = value;
    updatePlayer();
  }

  bool _showRelated = false;
  int get rel => _showRelated ? 1 : 0;

  @Input()
  void set loop(bool value) {
    _loop = value;
    updatePlayer();
  }

  bool _loop = false;
  int get _loopVideo => _loop ? 1 : 0;

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

  @Input()
  void set playlist(List<String> urls) => _playlist = urls;
  List<String> _playlist = [];

  @Input()

  /// if listType == 'search' => search query
  /// if listType == 'user_uploads' => search query
  /// if listType == 'playlist' => playlist id
  /// https://developers.google.com/youtube/player_parameters#list
  void set list(dynamic listValue) => _list = listValue;
  dynamic _list;

  @Input()

  /// search || user_uploads || playlist
  /// https://developers.google.com/youtube/player_parameters#listtype
  void set listType(String value) => _listType = value;
  String _listType;

  @Input()
  void set forceCaptions(bool value) => _cc_load_policy = value ? 1 : 0;
  int _cc_load_policy;

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

  StreamController<num> durationStreamer = new StreamController<num>();

  @Output('onDuration')
  Stream<num> get duration$ => durationStreamer.stream;

  StreamController<num> progressStreamer = new StreamController<num>();

  @Output('onProgress')
  Stream<num> get progress$ => progressStreamer.stream;

  StreamController<num> preloadProgressStreamer = new StreamController<num>();

  @Output('onPreloadProgress')
  Stream<num> get preloadProgress$ => preloadProgressStreamer.stream;

  StreamController<num> currentTimeStreamer = new StreamController<num>();

  @Output('onCurrentTime')
  Stream<num> get currentTime$ => currentTimeStreamer.stream.distinct();

  String get currentTime => player.getCurrentTime().toStringAsFixed(0) ?? '';

  String get duration => player.getDuration().toStringAsFixed(0) ?? '';

  bool get isPlaying => currentState == PlayerState.playing;

  num get progress => player?.getDuration() > 0
      ? (player?.getCurrentTime() / player?.getDuration() * 100)/*.toInt()*/
      : 0;

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
                rel: rel,
                modestbranding: modestbranding,
                loop: _loopVideo,
                fs: _allowFS,
                start: _start,
                end: _end,
                playlist: _playlist,
                list: _list,
                listType: _listType,
                cc_load_policy: _cc_load_policy),
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
    if (stateFromInt(eventArgs.data) == PlayerState.playing) {
      durationStreamer.add(player.getDuration());
      ticker = new Timer.periodic(const Duration(milliseconds: 500), (t) {
        timeLabel = "${currentTime}/$duration";
        progressValue = "${progress.toString()}%";
        progressStreamer.add(progress);
        final preloadFraction = player.getVideoLoadedFraction()*100;
        preloadPercent = "${preloadFraction}%";
        preloadProgressStreamer.add(preloadFraction);
        currentTimeStreamer.add(player.getCurrentTime());
      });
    } else
      ticker?.cancel();
  }

  void updatePlayer() {
    if (player != null) {
      if (currentState == PlayerState.playing) player.stopVideo();
      player.destroy();
      createPlayer();
    }
  }

  void toggle(){
    if(isPlaying)
      player.pauseVideo();
    else
      player.playVideo();
  }
}
