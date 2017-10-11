import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';
import 'package:angular_youtube_iframe/angular_youtube_iframe.dart';
import 'package:youtube_player_interop/youtube_player_interop.dart';


@Component(
  selector: 'my-app',
  styleUrls: const ['app_component.css'],
  templateUrl: 'app_component.html',
  directives: const [materialDirectives, YoutubeIFrame],
  providers: const [materialProviders],
)
class AppComponent {

  int width = 360;
  int height = 240;
  String videoId = '8ixOkJOXdMo';

  void onPlayerReady(){
    print('AppComponent.onPlayerReady... ');
  }

  void onStateChange(PlayerState state){
    print('AppComponent.onStateChange... $state');
  }
}
