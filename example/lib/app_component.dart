import 'dart:async';

import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_youtube_iframe/angular_youtube_iframe.dart';
import 'package:youtube_player_interop/youtube_player_interop.dart';

@Component(
  selector: 'my-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const [materialDirectives, YoutubeIFrame, NgIf],
  providers: const [materialProviders],
)
class AppComponent {
  int width = 320;
  int height = 240;
  int videoStart = 240;
  int newVideoStart ;
  int videoEnd = 1000;
  int newVideoEnd;
  bool showControls = true;
  bool showInfos = true;
  bool autoPlay = false;
  bool disableKeyboard = false;
  bool modestBranding = false;
  bool mobilePlaysInline = true;
  String videoId = '8ixOkJOXdMo';
  String newVideoId = '';
  String errorMsg = '';

  Player player;
  PlayerState playerState = PlayerState.notStarted;

  String archive = '---log---';

  String timeLabel;

  Timer ticker;
  String get currentTime => player?.getCurrentTime().toStringAsFixed(0);
  String get duration => player?.getDuration().toStringAsFixed(0);

  bool get isPlaying => playerState == PlayerState.playing;
  int get progress => player?.getDuration() > 0
      ? (player?.getCurrentTime() / player?.getDuration() * 100).toInt()
      : 0;
  String progressValue;
  String preloadPercent;

  void updateStart(String value) => newVideoStart = int.parse(value);
  void updateEnd(String value) => newVideoEnd = int.parse(value);
  void updateTimeRange(){
    videoStart = newVideoStart;
    videoEnd = newVideoEnd ?? videoEnd;
  }
  void onPlayerReady(Player createdPlayer) {
    log('onPlayerReady...');
    player = createdPlayer;

    print(
        'AppComponent.onPlayerReady... ${player?.getCurrentTime()} ${player?.getDuration()}');
    progressValue = "${progress.toString()}%";
  }

  void onStateChange(PlayerState state) {
    print('AppComponent.onStateChange... $state');
    log('new state... $state');
    playerState = state;
    if (state == PlayerState.playing)
      ticker = new Timer.periodic(const Duration(seconds: 1), (t) {
        timeLabel = "${currentTime}/$duration";
        progressValue = "${progress.toString()}%";
        preloadPercent = "${player?.getVideoLoadedFraction() * 100}%";
      });
    else
      ticker?.cancel();
  }

  void onError(dynamic error) {
    errorMsg = error.toString();
    log("ERROR : $error ");
  }


  void log(String s) {
    archive = "${archive}\n$s";
  }
}
