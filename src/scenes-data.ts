import { SceneData, VideoConfig } from './types';

// Premium Authority Style - Professional Healthcare Video
// Generated at: 2026-03-24 (with Chinese TTS audio - 63.4 seconds)
export const scenes: SceneData[] = [
  {
    start: 0,
    end: 6.55,
    type: 'authority',
    styleTheme: 'premium',
    title: '亲爱的长辈们',
    subtitle: '如果您或身边的亲友正经历脑卒中的考验，请不要灰心。',
  },
  {
    start: 6.55,
    end: 12.24,
    type: 'authority',
    styleTheme: 'premium',
    title: '脑卒中康复',
    subtitle: '是一场与时间的赛跑，但请记住，您并不孤单。',
  },
  {
    start: 12.24,
    end: 16.38,
    type: 'authority',
    styleTheme: 'premium',
    title: '科学的康复训练',
    subtitle: '是重获新生的关键钥匙',
  },
  {
    start: 16.38,
    end: 27.36,
    type: 'authority',
    styleTheme: 'premium',
    title: '专业的方法',
    subtitle: '从发病初期的良肢位摆放、被动活动，到恢复期的站立、步行与精细动作训练，每一步都有专业的方法与温暖的陪伴。',
  },
  {
    start: 27.36,
    end: 36.65,
    type: 'authority',
    styleTheme: 'premium',
    title: '黄金修复期',
    number: '6个月',
    subtitle: '抓住发病后6个月的黄金修复期，大脑拥有惊人的可塑性，通过坚持训练，受损的功能可以被重塑。',
  },
  {
    start: 36.65,
    end: 43.99,
    type: 'authority',
    styleTheme: 'premium',
    title: '希望的曙光',
    subtitle: '我们理解您可能面临的沮丧与焦虑，但请相信，每一个微小的进步都是希望的曙光。',
  },
  {
    start: 43.99,
    end: 53.53,
    type: 'authority',
    styleTheme: 'premium',
    title: '坚持中变为现实',
    subtitle: '无论是重新学会自己吃饭，还是再次迈出稳健的步伐，这些看似平常的事，都将在坚持中变为现实。',
  },
  {
    start: 53.53,
    end: 63.40,
    type: 'authority',
    styleTheme: 'premium',
    title: '生命绽放新光彩',
    subtitle: '让我们携手，用耐心与科学的方法，一步步找回生活的自理能力与自信，让生命在康复中绽放新的光彩。',
  },
];

export const videoConfig: VideoConfig = {
  fps: 30,
  width: 1080,
  height: 1920,
  durationInFrames: Math.ceil(63.40 * 30), // 1902 frames
  audioPath: 'stroke-recovery-complete.mp3',
  bgVideo: 'background-video-fixed.mp4',
  bgOpacity: 0.6,  // 提高到0.6让视频更明显
  bgOverlayColor: 'rgba(15, 15, 15, 0.3)',  // 降低到0.3减少遮挡
};
