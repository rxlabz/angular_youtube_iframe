import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

@Component(
    selector: 'player-progress-bar',
    templateUrl: 'player_progressbar.html',
    styleUrls: const['player_progressbar.css'],
    directives: const [materialDirectives],
    providers: const <dynamic>[materialProviders]
)
class PlayerProgressBar {

  PlayerProgressBar(){}
  
  @Input()
  num progress;
  String get progressPercent => "${progress}%";
  
  @Input()
  num preload;
  String get preloadPercent => "${preload}%";
  
}