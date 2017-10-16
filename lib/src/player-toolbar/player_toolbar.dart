import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:youtube_player_interop/youtube_player_interop.dart';

@Component(
    selector: 'player-toolbar',
    templateUrl: 'player_toolbar.html',
    styleUrls: const['player_toolbar.css'],
    directives: const [materialDirectives],
    providers: const <dynamic>[materialProviders]
)
class PlayerToolbar {

  PlayerToolbar(){}

  @Input()
  bool isPlaying;

  @Input()
  Player player;
}