# angular_youtube_iframe

Youtube player component for AngularDart (4+)

[Try the demo](https://rxlabz.github.io/angular_youtube_iframe)

```dart
<youtube-iframe [playerId]="'ytvideo'" [videoId]="videoId"
                [width]="width" [height]="height"
                [autoPlay]="true"
                [showControls]="false"
                [showInfos]="false"
                [disableKeyboard]="true"
                [embedOnMobile]="true"
                (onReady)="onPlayerReady()"
                (onStateChange)="onStateChange($event)"
></youtube-iframe>
```