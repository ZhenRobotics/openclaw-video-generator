import React from 'react';
import {
  AbsoluteFill,
  useCurrentFrame,
  interpolate,
  spring,
  useVideoConfig,
  Video,
  staticFile,
  Easing,
} from 'remotion';
import { SceneData } from './types';
import { designTokens, getTextShadow, getGlitchShadow } from './styles/design-tokens';
import { CyberGrid } from './components/CyberGrid';
import {
  EleganceScene,
  AuthorityScene,
  LuxuryScene,
  MinimalScene,
  CinematicScene,
} from './premium-scenes';

interface SceneRendererProps {
  scene: SceneData;
}

// Helper: Text reveal animation (逐字显示) - PROFESSIONAL GRADE
const TextReveal: React.FC<{
  text: string;
  frame: number;
  delay?: number;
  stagger?: number;
}> = ({
  text,
  frame,
  delay = 8,       // 整体延迟增加到 8 帧，让粒子先"预热"
  stagger = 3,     // 每个字符间隔 3 帧（0.1 秒），更易感知
}) => {
  const chars = text.split('');

  return (
    <>
      {chars.map((char, index) => {
        // 阶段 1: 预期（anticipation）- 轻微下沉
        const anticipationY = interpolate(
          frame,
          [index * stagger + delay - 3, index * stagger + delay],
          [0, 5],
          {
            extrapolateLeft: 'clamp',
            extrapolateRight: 'clamp',
            easing: Easing.in(Easing.quad),
          }
        );

        // 阶段 2: 动作（action）- 快速上升 + overshoot
        const charTranslateY = interpolate(
          frame,
          [
            index * stagger + delay,
            index * stagger + delay + 12,
            index * stagger + delay + 18,
          ],
          [30, -8, 0], // 从下方弹起，过冲后回到位置
          {
            extrapolateLeft: 'clamp',
            extrapolateRight: 'clamp',
            easing: Easing.bezier(0.34, 1.56, 0.64, 1), // Custom easeOutBack
          }
        );

        // 透明度：快速淡入
        const charOpacity = interpolate(
          frame,
          [index * stagger + delay, index * stagger + delay + 8],
          [0, 1],
          {
            extrapolateLeft: 'clamp',
            extrapolateRight: 'clamp',
            easing: Easing.out(Easing.cubic),
          }
        );

        // 阶段 3: 跟随（follow-through）- 轻微缩放脉冲
        const charScale = interpolate(
          frame,
          [
            index * stagger + delay + 12,
            index * stagger + delay + 18,
          ],
          [1.15, 1], // 轻微放大后收缩
          {
            extrapolateLeft: 'clamp',
            extrapolateRight: 'clamp',
            easing: Easing.out(Easing.quad),
          }
        );

        // 动态光效：字符出现时发光
        const glowIntensity = interpolate(
          frame,
          [
            index * stagger + delay,
            index * stagger + delay + 10,
            index * stagger + delay + 20,
          ],
          [0, 1, 0.3], // 出现时强光，然后减弱到30%
          {
            extrapolateLeft: 'clamp',
            extrapolateRight: 'clamp',
          }
        );

        return (
          <span
            key={index}
            style={{
              opacity: charOpacity,
              transform: `translateY(${charTranslateY + anticipationY}px) scale(${charScale})`,
              display: 'inline-block',
              filter: `drop-shadow(0 0 ${8 + glowIntensity * 12}px rgba(0, 255, 255, ${glowIntensity * 0.8}))`,
            }}
          >
            {char === ' ' ? '\u00A0' : char}
          </span>
        );
      })}
    </>
  );
};

// Helper: Particle explosion effect (粒子爆炸) - PROFESSIONAL GRADE
interface Particle {
  angle: number;
  size: number;
  color: string;
  velocity: number;
  depth: number;
  rotationSpeed: number;
}

const ParticleExplosion: React.FC<{ frame: number; particleCount?: number }> = ({
  frame,
  particleCount = 50, // 增加到 50 个粒子
}) => {
  // 使用 useMemo 确保粒子参数在组件生命周期内保持一致
  const particles = React.useMemo(() => {
    return Array.from({ length: particleCount }, (_, i) => {
      // 添加随机性，但保持可预测（使用 index 作为种子）
      const seed = i * 0.618033988749; // 黄金比例，产生均匀分布
      const randomAngle = (seed % 1) * 0.2 - 0.1; // ±10度随机偏移

      return {
        angle: (i / particleCount) * Math.PI * 2 + randomAngle,
        size: 4 + (seed % 1) * 8, // 4-12px 随机大小
        color: [
          '#00FFFF', // Cyan
          '#FF00FF', // Magenta
          '#FFFF00', // Yellow
          '#00FF88', // Green
          '#FF0080', // Pink
        ][i % 5],
        velocity: 0.8 + (seed % 1) * 0.4, // 0.8-1.2 速度变化
        depth: seed % 1, // 0-1 景深
        rotationSpeed: (seed % 1) * 360 - 180, // -180 到 180 度/秒
      } as Particle;
    });
  }, [particleCount]);

  return (
    <>
      {particles.map((particle, i) => {
        // 阶段 1: 爆炸（0-20 帧）
        const explosionDistance = interpolate(
          frame,
          [0, 20],
          [0, 200 * particle.velocity],
          {
            extrapolateRight: 'clamp',
            easing: Easing.bezier(0.25, 0.46, 0.45, 0.94), // easeOutQuad - 减速
          }
        );

        // 阶段 2: 重力下落（15-40 帧）
        const gravityY = interpolate(
          frame,
          [15, 40],
          [0, 80],
          {
            extrapolateRight: 'clamp',
            easing: Easing.in(Easing.quad), // 加速下落
          }
        );

        // 阶段 3: 淡出（30-45 帧）
        const opacity = interpolate(
          frame,
          [0, 10, 30, 45],
          [0, 1, 1, 0],
          {
            extrapolateRight: 'clamp',
            easing: Easing.inOut(Easing.ease),
          }
        );

        // 旋转动画
        const rotation = interpolate(
          frame,
          [0, 60],
          [0, particle.rotationSpeed * 2], // 2 秒旋转周期
          {
            extrapolateRight: 'extend',
          }
        );

        // 景深缩放（远处的粒子更小）
        const depthScale = 0.5 + particle.depth * 0.5; // 0.5-1.0 倍

        // 计算最终位置
        const x = Math.cos(particle.angle) * explosionDistance * depthScale;
        const y = Math.sin(particle.angle) * explosionDistance * depthScale + gravityY;

        // 动态光晕强度
        const glowSize = interpolate(
          frame,
          [0, 10, 20],
          [0, 20, 10],
          {
            extrapolateRight: 'clamp',
          }
        );

        // 景深模糊（远处的粒子更模糊）
        const blurAmount = particle.depth * 3;

        return (
          <div
            key={i}
            style={{
              position: 'absolute',
              width: `${particle.size}px`,
              height: `${particle.size}px`,
              borderRadius: '50%',
              backgroundColor: particle.color,
              opacity: opacity * (1 - particle.depth * 0.3), // 远处粒子更透明
              transform: `translate(${x}px, ${y}px) rotate(${rotation}deg) scale(${depthScale})`,
              boxShadow: `
                0 0 ${glowSize}px ${particle.color},
                0 0 ${glowSize * 1.5}px ${particle.color},
                inset 0 0 ${particle.size / 2}px rgba(255, 255, 255, 0.5)
              `,
              filter: `blur(${blurAmount}px)`,
              zIndex: Math.round((1 - particle.depth) * 10) + designTokens.layout.zIndex.foreground,
              mixBlendMode: 'screen', // 光效混合模式
            }}
          />
        );
      })}
    </>
  );
};

// Helper: 3D rotating text - P1 ENHANCED
const Text3DEffect: React.FC<{ text: string; frame: number }> = ({ text, frame }) => {
  // 三段式旋转：快速旋转 -> 停顿展示 -> 慢速旋转
  const rotationY = interpolate(
    frame,
    [0, 30, 60, 90],
    [0, Math.PI * 1.5, Math.PI * 1.5, Math.PI * 2], // 停顿在 270 度
    {
      extrapolateRight: 'clamp',
      easing: Easing.bezier(0.65, 0, 0.35, 1), // easeInOutCubic
    }
  );

  const rotateY = (rotationY * 180) / Math.PI;

  // 动态景深调整
  const perspective = interpolate(
    frame,
    [0, 30],
    [1500, 800], // 逐渐拉近
    {
      extrapolateRight: 'clamp',
      easing: Easing.out(Easing.quad),
    }
  );

  // 动态缩放：旋转时放大
  const scale = interpolate(
    frame,
    [0, 30, 60],
    [0.8, 1.2, 1],
    {
      extrapolateRight: 'clamp',
      easing: Easing.inOut(Easing.cubic),
    }
  );

  // 动态光效：正面时最亮
  const glowIntensity = interpolate(
    rotationY,
    [Math.PI * 0.5, Math.PI, Math.PI * 1.5],
    [0.3, 0.8, 1],
    {
      extrapolateLeft: 'clamp',
      extrapolateRight: 'clamp',
    }
  );

  return (
    <div
      style={{
        perspective: `${perspective}px`,
        transformStyle: 'preserve-3d',
      }}
    >
      <div
        style={{
          transform: `rotateY(${rotateY}deg) scale(${scale})`,
          transformStyle: 'preserve-3d',
          textShadow: `
            ${2 * glowIntensity}px ${2 * glowIntensity}px ${8 * glowIntensity}px rgba(0, 255, 255, ${0.8 * glowIntensity}),
            ${-2 * glowIntensity}px ${-2 * glowIntensity}px ${8 * glowIntensity}px rgba(255, 0, 255, ${0.8 * glowIntensity}),
            0 0 ${30 * glowIntensity}px rgba(0, 255, 255, ${0.5 * glowIntensity})
          `,
          filter: `drop-shadow(0 0 ${20 * glowIntensity}px rgba(0, 255, 255, 0.6))`,
        }}
      >
        {text}
      </div>
    </div>
  );
};

// Main animation functions (existing + enhanced)
const getTitleAnimation = (frame: number, fps: number) => {
  const progress = frame / fps;
  const glitchAmount = Math.sin(frame * 0.5) * 3;

  return {
    scale: spring({
      frame,
      fps,
      from: 0,
      to: 1,
      config: designTokens.animation.spring.bouncy,
    }),
    translateY: 0,
    opacity: interpolate(frame, [0, 10], [0, 1], { extrapolateRight: 'clamp' }),
    glitch: getGlitchShadow(glitchAmount),
  };
};

const getEmphasisAnimation = (frame: number, fps: number) => {
  return {
    scale: spring({
      frame,
      fps,
      from: 0.5,
      to: 1.1,
      config: designTokens.animation.spring.snappy,
    }),
    translateY: 0,
    opacity: 1,
    glitch: '',
  };
};

const getPainAnimation = (frame: number, fps: number) => {
  const shake = Math.sin(frame * 0.8) * 2;
  return {
    scale: 1,
    translateY: shake,
    opacity: 1,
    glitch: '',
  };
};

const getCircleAnimation = (frame: number, fps: number) => {
  return {
    scale: 1,
    translateY: 0,
    opacity: interpolate(frame, [0, 15], [0, 1], {
      extrapolateRight: 'clamp',
      easing: Easing.out(Easing.cubic),
    }),
    glitch: '',
  };
};

const getEndAnimation = (frame: number, fps: number) => {
  return {
    scale: 1,
    translateY: interpolate(frame, [0, 30], [0, -50], {
      extrapolateRight: 'clamp',
      easing: Easing.bezier(0.55, 0.055, 0.675, 0.19), // easeInCubic - 专业级加速
    }),
    opacity: interpolate(frame, [20, 30], [1, 0], {
      extrapolateRight: 'clamp',
      easing: Easing.in(Easing.cubic),
    }),
    glitch: '',
  };
};

const getContentAnimation = (frame: number, fps: number) => {
  return {
    scale: interpolate(frame, [0, 20], [0.95, 1], {
      extrapolateRight: 'clamp',
      easing: Easing.bezier(0.215, 0.61, 0.355, 1), // easeOutCubic - 专业级减速
    }),
    translateY: 0,
    opacity: interpolate(frame, [0, 15], [0, 1], {
      extrapolateRight: 'clamp',
      easing: Easing.out(Easing.cubic),
    }),
    glitch: '',
  };
};

// Helper: Light sweep effect (扫光特效) - P1 NEW
const LightSweep: React.FC<{ frame: number; duration?: number }> = ({
  frame,
  duration = 60, // 2 秒扫过
}) => {
  // 光带位置：从左至右扫过
  const sweepX = interpolate(
    frame,
    [0, duration],
    [-100, 200], // 从 -100% 到 200%（超出屏幕）
    {
      extrapolateRight: 'clamp',
      easing: Easing.bezier(0.25, 0.1, 0.25, 1), // easeInOutCubic
    }
  );

  // 光带透明度：中间最亮
  const opacity = interpolate(
    frame,
    [0, duration * 0.3, duration * 0.7, duration],
    [0, 0.8, 0.8, 0],
    {
      extrapolateRight: 'clamp',
    }
  );

  return (
    <div
      style={{
        position: 'absolute',
        top: 0,
        left: `${sweepX}%`,
        width: '40%',
        height: '100%',
        background: `linear-gradient(
          90deg,
          rgba(0, 255, 255, 0) 0%,
          rgba(0, 255, 255, ${opacity * 0.3}) 30%,
          rgba(255, 255, 255, ${opacity * 0.6}) 50%,
          rgba(255, 0, 255, ${opacity * 0.3}) 70%,
          rgba(255, 0, 255, 0) 100%
        )`,
        filter: 'blur(20px)',
        mixBlendMode: 'screen',
        pointerEvents: 'none',
        zIndex: designTokens.layout.zIndex.foreground + 1,
      }}
    />
  );
};

// Highlight text helper
const highlightText = (text: string, highlight?: string) => {
  if (!highlight) return <>{text}</>;

  const parts = text.split(new RegExp(`(${highlight})`, 'gi'));
  return (
    <>
      {parts.map((part, i) =>
        part.toLowerCase() === highlight.toLowerCase() ? (
          <span
            key={i}
            style={{ color: designTokens.colors.accent.gold }}
          >
            {part}
          </span>
        ) : (
          <React.Fragment key={i}>{part}</React.Fragment>
        )
      )}
    </>
  );
};

// Helper: Camera movement effect (镜头运动) - P1 NEW
const getCameraEffect = (frame: number, sceneType: string) => {
  switch (sceneType) {
    case 'title':
      // 推进镜头：从远到近
      return {
        scale: interpolate(
          frame,
          [0, 40],
          [1.2, 1],
          {
            extrapolateRight: 'clamp',
            easing: Easing.out(Easing.cubic),
          }
        ),
        translateY: interpolate(
          frame,
          [0, 40],
          [-30, 0],
          {
            extrapolateRight: 'clamp',
            easing: Easing.out(Easing.cubic),
          }
        ),
        translateX: 0,
      };

    case 'emphasis':
      // 震动效果
      const shake = Math.sin(frame * 0.8) * Math.max(0, 1 - frame / 20);
      return {
        scale: 1,
        translateY: shake * 3,
        translateX: shake * 2,
      };

    case 'end':
      // 拉远镜头
      return {
        scale: interpolate(
          frame,
          [0, 30],
          [1, 0.9],
          {
            extrapolateRight: 'clamp',
            easing: Easing.in(Easing.quad),
          }
        ),
        translateY: 0,
        translateX: 0,
      };

    default:
      return { scale: 1, translateY: 0, translateX: 0 };
  }
};

export const SceneRenderer: React.FC<SceneRendererProps> = ({ scene }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  // Check if using premium style theme
  if (scene.styleTheme === 'premium') {
    switch (scene.type) {
      case 'elegance':
        return <EleganceScene scene={scene} />;
      case 'authority':
        return <AuthorityScene scene={scene} />;
      case 'luxury':
        return <LuxuryScene scene={scene} />;
      case 'minimal':
        return <MinimalScene scene={scene} />;
      case 'cinematic':
        return <CinematicScene scene={scene} />;
      default:
        // Fallback to elegance for unknown premium types
        return <EleganceScene scene={scene} />;
    }
  }

  // Continue with existing cyber style for non-premium scenes
  // Animation logic based on scene type
  const getAnimation = () => {
    switch (scene.type) {
      case 'title':
        return getTitleAnimation(frame, fps);
      case 'emphasis':
        return getEmphasisAnimation(frame, fps);
      case 'pain':
        return getPainAnimation(frame, fps);
      case 'circle':
        return getCircleAnimation(frame, fps);
      case 'end':
        return getEndAnimation(frame, fps);
      default:
        return getContentAnimation(frame, fps);
    }
  };

  const animation = getAnimation();

  // Determine if we should use enhanced effects
  const useTextReveal = scene.type === 'title' || scene.type === 'emphasis';
  const useParticles = scene.type === 'title';
  const use3DText = scene.type === 'emphasis';
  const useLightSweep = scene.type === 'emphasis' || scene.type === 'title';

  // P1: Camera movement effect
  const cameraEffect = getCameraEffect(frame, scene.type);

  return (
    <AbsoluteFill
      style={{
        justifyContent: 'flex-end',
        alignItems: 'center',
        paddingBottom: designTokens.spacing[40],
      }}
    >
      {/* P1: Camera movement wrapper */}
      <div
        style={{
          position: 'absolute',
          width: '100%',
          height: '100%',
          transform: `scale(${cameraEffect.scale}) translate(${cameraEffect.translateX}px, ${cameraEffect.translateY}px)`,
          transformOrigin: 'center center',
        }}
      >
        {/* P2: Cyber grid background */}
        {scene.type === 'title' && <CyberGrid opacity={0.15} />}

        {/* P1: Light sweep effect */}
        {useLightSweep && <LightSweep frame={frame} />}

        {/* Scene-specific background video */}
      {scene.bgVideo && (
        <>
          <Video
            src={staticFile(scene.bgVideo)}
            style={{
              position: 'absolute',
              width: '100%',
              height: '100%',
              objectFit: 'cover',
              opacity: scene.bgOpacity ?? 0.3,
              zIndex: designTokens.layout.zIndex.background,
            }}
            volume={0}
            loop
          />
          <AbsoluteFill
            style={{
              backgroundColor: designTokens.colors.background.translucentLight,
              zIndex: designTokens.layout.zIndex.overlay,
            }}
          />
        </>
      )}

      {/* Main title with background bar */}
      <div
        style={{
          position: 'relative',
          padding: `${designTokens.spacing[4]}px ${designTokens.spacing[15]}px`,
          background: designTokens.colors.gradients.darkenCenter,
          borderRadius: designTokens.effects.borderRadius.md,
          backdropFilter: designTokens.effects.blur.medium,
          boxShadow: designTokens.effects.shadow.soft,
          zIndex: designTokens.layout.zIndex.content,
          maxWidth: designTokens.layout.maxWidth.text,
        }}
      >
        {/* Particle explosion for title */}
        {useParticles && <ParticleExplosion frame={frame} />}

        <div
          style={{
            fontSize: designTokens.typography.fontSize['5xl'],
            fontWeight: designTokens.typography.fontWeight.bold,
            fontFamily: designTokens.typography.fontFamily.primary,
            color: scene.color || designTokens.colors.text.primary,
            textAlign: 'center',
            whiteSpace: 'pre-line',
            transform: `scale(${animation.scale}) translateY(${animation.translateY}px)`,
            opacity: animation.opacity,
            textShadow:
              scene.type === 'title'
                ? animation.glitch
                : designTokens.effects.textEffect.cyberGlow,
            lineHeight: designTokens.typography.lineHeight.normal,
            letterSpacing: designTokens.typography.letterSpacing.tight,
            // P2: 色彩呼吸效果
            filter: `brightness(${interpolate(
              Math.sin(frame * 0.1) * 0.5 + 0.5,
              [0, 1],
              [0.85, 1.15],
              {
                extrapolateLeft: 'clamp',
                extrapolateRight: 'clamp',
              }
            )}) saturate(1.2)`,
          }}
        >
          {use3DText ? (
            <Text3DEffect text={scene.title} frame={frame} />
          ) : useTextReveal ? (
            <TextReveal text={scene.title} frame={frame} />
          ) : (
            highlightText(scene.title, scene.highlight)
          )}
        </div>
      </div>

      {/* Subtitle */}
      {scene.subtitle && (
        <div
          style={{
            fontSize: designTokens.typography.fontSize['2xl'],
            fontFamily: designTokens.typography.fontFamily.primary,
            fontWeight: designTokens.typography.fontWeight.regular,
            color: designTokens.colors.text.tertiary,
            textAlign: 'center',
            whiteSpace: 'pre-line',
            marginTop: designTokens.spacing[10],
            opacity: interpolate(frame, [5, 15], [0, 1], {
              extrapolateRight: 'clamp',
              easing: Easing.out(Easing.cubic),
            }),
            position: 'relative',
            zIndex: designTokens.layout.zIndex.content,
            textShadow: designTokens.effects.textEffect.subtleDepth,
            lineHeight: designTokens.typography.lineHeight.relaxed,
          }}
        >
          {highlightText(scene.subtitle, scene.highlight)}
        </div>
      )}

      {/* Number highlight */}
      {scene.number && (
        <div
          style={{
            fontSize: designTokens.typography.fontSize['6xl'],
            fontFamily: designTokens.typography.fontFamily.primary,
            fontWeight: designTokens.typography.fontWeight.bold,
            color: designTokens.colors.accent.gold,
            position: 'absolute',
            top: '40%',
            transform: `scale(${spring({
              frame,
              fps,
              from: 0,
              to: 1,
              config: designTokens.animation.spring.bouncy,
            })})`,
            zIndex: designTokens.layout.zIndex.content,
            textShadow: designTokens.effects.textEffect.goldShine,
            letterSpacing: designTokens.typography.letterSpacing.normal,
          }}
        >
          {scene.number}
        </div>
      )}
      </div>
      {/* End P1: Camera movement wrapper */}
    </AbsoluteFill>
  );
};
