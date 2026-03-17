import { SceneData } from './types';

// Premium Styles Test - Showcasing all 5 new high-end styles
// Adjusted to match 14.1 seconds audio duration
export const scenes: SceneData[] = [
  // 1. Elegance - Apple-style opening (2.8s)
  {
    start: 0,
    end: 2.8,
    type: 'elegance',
    styleTheme: 'premium',
    title: 'OpenClaw',
    subtitle: '高端风格系统',
  },

  // 2. Authority - Data-driven narrative (2.3s)
  {
    start: 2.8,
    end: 5.1,
    type: 'authority',
    styleTheme: 'premium',
    title: '权威叙事',
    number: '11',
    subtitle: '种风格',
  },

  // 3. Luxury - High-end texture (2.3s)
  {
    start: 5.1,
    end: 7.4,
    type: 'luxury',
    styleTheme: 'premium',
    title: '奢华质感',
    subtitle: '极致克制',
  },

  // 4. Minimal - Geometric simplicity (2.3s)
  {
    start: 7.4,
    end: 9.7,
    type: 'minimal',
    styleTheme: 'premium',
    title: '极简几何',
    subtitle: '设计力量',
  },

  // 5. Cinematic - Movie trailer style (2.7s)
  {
    start: 9.7,
    end: 12.4,
    type: 'cinematic',
    styleTheme: 'premium',
    title: '电影叙事',
    subtitle: '震撼体验',
  },

  // 6. Compare with Cyber style (1.7s)
  {
    start: 12.4,
    end: 14.1,
    type: 'emphasis',
    styleTheme: 'cyber',
    title: '赛博炫酷',
    xiaomo: 'point',
  },
];

export const videoConfig = {
  fps: 30,
  width: 1080,
  height: 1920,
  durationInFrames: 423, // 14.1 seconds * 30 fps
  audioPath: 'premium-styles-test.mp3',
};
