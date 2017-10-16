# angular_youtube_iframe

A Youtube player component for AngularDart (4+) based on [Youtube iFrame interop](https://github.com/rxlabz/youtube_player_interop)

![screenshot](https://rxlabz.github.io/angular_youtube_iframe/screenshot.jpg)

[Try the demo](https://rxlabz.github.io/angular_youtube_iframe)


```html
<youtube-iframe [playerId]="'ytvideo'" [videoId]="videoId"
                [start]="videoStart" [end]="videoEnd"
                [width]="width" [height]="height"
                [autoPlay]="autoPlay"
                [showControls]="showControls"
                [showInfos]="showInfos"
                [blockVideoInteraction]="blockVideoInteraction"
                [disableKeyboard]="disableKeyboard"
                [modestBranding]="modestBranding"
                [mobilePlaysInline]="mobilePlaysInline"
                (onReady)="onPlayerReady($event)"
                (onError)="onError($event)"
                (onStateChange)="onStateChange($event)"
                (onDuration)="duration = $event"
                (onPreloadProgress)="preloadProgress = $event"
                (onProgress)="progress = $event"
></youtube-iframe>
```