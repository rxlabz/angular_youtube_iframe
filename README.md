# angular_youtube_iframe

A Youtube player component for AngularDart (4+) based on [Youtube iFrame interop](https://github.com/rxlabz/youtube_player_interop)

[Try the demo](https://rxlabz.github.io/angular_youtube_iframe)

```html
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