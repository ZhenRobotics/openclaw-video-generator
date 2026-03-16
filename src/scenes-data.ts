import { SceneData } from './types';

// Auto-generated from Whisper timestamps
// Generated at: 2026-03-12T03:24:52.276Z
export const scenes: SceneData[] = [
  {
    "start": 0,
    "end": 7.665,
    "type": "title",
    "title": "字幕优化测试第一段验证字幕位置在底部第二段验证背景条清晰可见",
    "xiaomo": "peek"
  },
  {
    "start": 7.665,
    "end": 10.476,
    "type": "content",
    "title": "第三段验证霓虹发光效果",
    "xiaomo": "point"
  },
  {
    "start": 10.476,
    "end": 13.286,
    "type": "content",
    "title": "第四段验证滑入动画流畅",
    "xiaomo": "point"
  },
  {
    "start": 13.286,
    "end": 18.396,
    "type": "end",
    "title": "第五段验证文字描边效果，测试完成查看效果",
    "xiaomo": "wave"
  }
];

// Video metadata
export const videoConfig = {
  fps: 30,
  width: 1080,
  height: 1920,  // Vertical video for 视频号
  durationInFrames: 552,  // 18.40 seconds * 30 fps
  audioPath: 'subtitle-style-test.mp3',  // Audio file path (relative to public/)
  bgVideo: '623cba348a101f1de29ce5b91d9a9679.mp4',  // Background video file (relative to public/)
  bgOpacity: 0.7,  // Background video opacity (0-1)
  bgOverlayColor: 'rgba(10, 10, 15, 0.25)',  // Overlay color for better text visibility
};
