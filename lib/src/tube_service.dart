import 'package:angular/di.dart';
import 'package:youtube_player_interop/youtube_player_interop.dart';

@Injectable()
class TubeService {

  static final TubeService _service = new TubeService._internal();

  factory TubeService(){
    return _service;
  }

  TubeService._internal();

  bool isApiReady = false;

  List<Function> _listeners = [];

  void init(Function handler) {
    print('TubeService.init... ');
    if( handler != null)
      _listeners.add(handler);
    if( !isApiReady )
      initYoutubeFrame(_onAPIReadyCallback);
    else
      _onAPIReadyCallback();
  }

  void _onAPIReadyCallback() {
    isApiReady = true;
    if( _listeners.length > 0)
      _listeners.forEach((f)=>f());
  }

  Player createPlayer(String videoId, PlayerOptions options) =>
      isApiReady ? new Player(videoId, options) : null;

}
