 
https://code.cleo.live/naveen/video-editor/raw/branch/dev-meenakshi/src/component/Player/PreviewPlayer.js
import Player from './../Player';
import { getM3u8fromSlike, debounce } from './../../utils/playerUtils';
import Controls from '../Controls';
import { PLAYER_EVENTS, PLAYER_NAME } from '../../constants';

export default class PreviewPlayer {
  constructor(editorConfig, playerConfig, previewPlayerEvent) {
    this.editorConfig = editorConfig;
    this.playerConfig = playerConfig;
    this.previewPlayerEvent = previewPlayerEvent;
    this.playerName = PLAYER_NAME.PREVIEW_PLAYER;
    this.loader = playerConfig.loader;
    let timeFrameArray = playerConfig.timeFrameArray;
    this.timeFrameArray = timeFrameArray;
    this.debounceTime = 1000;
    this.currentIndex = 0;
    this.controlsBound = false;
    this.loadSourceProgress = false;
    this.bindFunction();
  }

  render() {
    console.log('PlayerBase render');
    this.playerConfig.autoLoadSource = false;
    this.playerConfig.playerWrapper = this;
    let player = new Player(this.editorConfig, this.playerConfig);
    player.createPlayer();
    this.player = player;
    this.activePlayer = player;
    this.getVideoDuration();
    this.controls = new Controls(this.editorConfig, this.playerConfig);
  }

  bindFunction() {
    this.playerEvents = this.playerEvents.bind(this);
    let debounceTime = this.debounceTime;
    // this.seekPosition = debounce(this.seekPosition, debounceTime);
  }

  onMediaAttached() {
    let actualSeekPosition = this.actualSeekPosition;
    this.playCurrent(actualSeekPosition);
  }

  getVideoDuration() {
    let videoDuration = 0;
    for (let i = 0; i < this.timeFrameArray.length; i++) {
      if (this.timeFrameArray[i].timeClip && this.timeFrameArray[i].timeClip.clipDuration) {
        videoDuration += this.timeFrameArray[i].timeClip.clipDuration;
      }
    }
    this.videoDuration = videoDuration;
    console.log('VideoDuration  :: ', this.videoDuration);
    return videoDuration;
  }

  getCurrentTime(videoPosition) {
    let currentTime = 0;
    let currentIndex = this.currentIndex;
    for (let i = 0; i < currentIndex; i++) {
      if (this.timeFrameArray[i].timeClip && this.timeFrameArray[i].timeClip.clipDuration) {
        currentTime += this.timeFrameArray[i].timeClip.clipDuration;
      }
    }
    let lastClipPlayed = videoPosition - this.timeFrameArray[this.currentIndex].timeClip.left;
    currentTime += lastClipPlayed;
    return currentTime;
  }

  createPlayer() {
    this.player.createPlayer();
  }

  loadSource(m3u8Url, startTime) {
    this.player.loadSource(m3u8Url, startTime);
  }

  loadPlayerInit(m3u8Url) {
    this.editorConfig.m3u8Url = m3u8Url;
    let player = new Player(this.editorConfig, this.playerEvents);
    player.createPlayer();
    player.play();
    this.player = player;
    this.activePlayer = player;
  }

  playNext() {
    this.currentIndex++;
    this.currentIndex = this.cuxxrrentIndex % this.timeFrameArray.length;
    this.destroyAndCreate();
  }

  destroyAndCreate() {
    this.loader.__show();
    this.player.destroyAndCreate();
  }

  playCurrent(seekPosition) {
    let currentIndex = this.currentIndex;
    if (currentIndex < this.timeFrameArray.length) {
      let currentTimeFrame = this.timeFrameArray[currentIndex];
      let currentTimeClip = currentTimeFrame.timeClip;
      if (currentTimeClip) {
        this.loadSourceProgress = true;
        if (!seekPosition) {
          seekPosition = currentTimeClip.left;
        }
        this.loadSource(currentTimeClip.m3u8Url, seekPosition);
      }
    }
  }

  endPreviewPlayer() {
    console.log('Preview Player Ended');
  }

  playerEvents(event) {
    let shouldBroadcast = true;
    let syntheticEvent = {
      type: event.type
    };
    switch (event.type) {
      case PLAYER_EVENTS.DURATION_CHANGE:
        shouldBroadcast = false;
        console.log('DURATION_CHANGE Log :: ', event);
        this.videoHeight = this.player.videoHeight;
        this.videoWidth = this.player.videoWidth;
        if (this.videoDuration > 0 && !this.controlsBound) {
          this.controls.startRender();
          this.controlsBound = true;
        }
        break;
      case PLAYER_EVENTS.VIDEO_ENDED:
        if (!this.loadSourceProgress) {
          this.player.pause();
          this.playNext();
        }
        break;
      case PLAYER_EVENTS.TIME_UPDATE:
        let thisClipVideoPosition = event.position;
        let currentIndex = this.currentIndex;
        let currentTimeFrame = this.timeFrameArray[currentIndex];
        if (currentTimeFrame) {
          let currentTimeClip = currentTimeFrame.timeClip;
          if (thisClipVideoPosition >= currentTimeClip.right) {
            if (!this.loadSourceProgress) {
              this.player.pause();
              this.playNext();
            }
          } else if (thisClipVideoPosition <= currentTimeClip.left) {
            // this.player.seekPosition(currentTimeClip.left);
            return;
          } else {
            if (event.videoPosition && event.videoDuration) {
              shouldBroadcast = true;
              let videoPosition = event.videoPosition;
              let newVideoDuration = this.videoDuration;
              let newVideoPosition = this.getCurrentTime(videoPosition);
              syntheticEvent.videoDuration = newVideoDuration;
              syntheticEvent.videoPosition = newVideoPosition;
            }
          }
        }
        break;
      case PLAYER_EVENTS.HLS_MEDIA_ATTACHED:
        shouldBroadcast = false;
        console.log('HLS_MEDIA_ATTACHED Log :: ', event);
        this.onMediaAttached();
        break;
      case PLAYER_EVENTS.HLS_MANIFEST_PARSED:
        shouldBroadcast = false;
        this.loadSourceProgress = false;
        console.log('HLS_MANIFEST_PARSEDt Log :: ', event);
        break;
      default:
        break;
    }

    if (shouldBroadcast) {
      if (typeof this.previewPlayerEvent === 'function') {
        this.previewPlayerEvent(syntheticEvent);
      }
      if (typeof this.controls.playerEvents === 'function') {
        this.controls.playerEvents(syntheticEvent);
      }
    }
  }

  /* Player Functions*/
  togglePlay() {
    if (this.player) {
      this.player.togglePlay();
    }
  }

  play() {
    if (this.player) {
      this.player.play();
    }
  }

  pause() {
    if (this.player) {
      this.player.pause();
    }
  }

  seekDuration(seekDuration) {
    let videoPosition = this.player.getCurrentTime();
    let currentTime = this.getCurrentTime(videoPosition);
    let seekPosition = currentTime + seekDuration;
    if (seekPosition <= this.videoDuration) {
      this.seekPosition(seekDuration);
    }
  }

  seekPosition(seekPosition, timeoutValue) {
    timeoutValue = timeoutValue || 500;
    clearTimeout(this.seekPositionTimeout);
    this.seekPositionTimeout = setTimeout(() => {
      clearTimeout(this.seekPositionTimeout);
      this.seekPositionActual(seekPosition);
    }, timeoutValue);
  }

  seekPositionActual(seekPosition) {
    let currentIndex = this.currentIndex;
    let selectedTimeFrameIndex = 0;
    let actualSeekPosition = 0;
    let tempSum = 0;

    for (let i = 0; i < this.timeFrameArray.length; i++) {
      let timeClip = this.timeFrameArray[i].timeClip;
      let clipDuration = timeClip.clipDuration;
      if (seekPosition > tempSum + clipDuration) {
        tempSum += clipDuration;
      } else {
        actualSeekPosition = timeClip.left + (seekPosition - tempSum);
        selectedTimeFrameIndex = i;
        break;
      }
    }

    if (selectedTimeFrameIndex === currentIndex) {
      this.player.seekPosition(actualSeekPosition);
    } else {
      this.currentIndex = selectedTimeFrameIndex;
      this.actualSeekPosition = actualSeekPosition;
      this.destroyAndCreate();
    }
  }

 
