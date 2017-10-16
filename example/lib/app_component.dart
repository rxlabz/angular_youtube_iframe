import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_youtube_iframe/angular_youtube_iframe.dart';
import 'package:youtube_player_interop/youtube_player_interop.dart';

@Component(
  selector: 'my-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const [
    materialDirectives,
    YoutubeIFrame,
    NgIf,
    PlayerProgressBar,
    PlayerToolbar
  ],
  providers: const [materialProviders],
)
class AppComponent {
  int width = 320;
  int height = 240;
  int videoStart = 240;
  int newVideoStart;
  int videoEnd = 1000;
  int newVideoEnd;
  bool showControls = true;
  bool showInfos = true;
  bool autoPlay = false;
  bool disableKeyboard = false;
  bool modestBranding = false;
  bool mobilePlaysInline = true;
  bool blockVideoInteraction = true;
  String videoId = '8ixOkJOXdMo';
  String newVideoId = '';
  String errorMsg = '';

  Player player;
  PlayerState playerState = PlayerState.notStarted;

  String archive = '---log---';

  String timeLabel;

  Timer ticker;

  Duration duration;

  bool get isPlaying => playerState == PlayerState.playing;

  num preloadProgress;
  num progress;

  void updateStart(String value) => newVideoStart = int.parse(value);

  void updateEnd(String value) => newVideoEnd = int.parse(value);

  void updateTimeRange() {
    videoStart = newVideoStart;
    videoEnd = newVideoEnd ?? videoEnd;
  }

  void onPlayerReady(Player createdPlayer) {
    log('PlayerReady...');
    player = createdPlayer;
  }

  void onStateChange(PlayerState state) {
    log('$state');
    playerState = state;
  }

  void onDuration(num d) => duration = new Duration(seconds: d.toInt());

  void onError(dynamic error) {
    errorMsg = error.toString();
    log("ERROR : $error ");
  }

  void log(String s) {
    archive = "${archive}\n$s";
  }

  void play() => player.playVideo();
}
