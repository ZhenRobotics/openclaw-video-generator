# Demo Video Scripts

## 60-Second Product Demo (Primary)

### Script

**DURATION**: 60 seconds
**STYLE**: Fast-paced, screen recording with text overlays
**MUSIC**: Upbeat electronic/cyber (subtle, 20% volume)
**RESOLUTION**: 1920x1080 (can be cropped to 1080x1080 for social)

---

### Scene Breakdown

**[0:00-0:07] Hook + Problem (7 seconds)**

VISUAL:
- Split screen showing:
  - Left: Adobe Premiere timeline (complex, overwhelming)
  - Right: Fiverr freelancer profile ($150/video)
- Red X appears over both

TEXT OVERLAY:
```
Creating videos is expensive and slow
$150/video | 4 hours of editing
```

VOICEOVER:
"Video creation is too expensive and time-consuming."

---

**[0:07-0:15] Solution Introduction (8 seconds)**

VISUAL:
- Fade to clean terminal screen
- OpenClaw Video Generator logo animates in
- Cyber grid background

TEXT OVERLAY:
```
OpenClaw Video Generator
Text → Professional Video
$0.003 | 3 minutes
```

VOICEOVER:
"Meet OpenClaw Video Generator. Generate professional videos from text in 3 minutes for less than 1 cent."

---

**[0:15-0:25] Live Demo - Input (10 seconds)**

VISUAL:
- Terminal screen recording
- Type command (with typing effect):

```bash
openclaw-video-generator generate "Three AI tools that changed my workflow. First, ChatGPT writes my code. Second, Whisper transcribes audio. Third, Remotion generates videos. Try them yourself!"
```

- Press enter

TEXT OVERLAY:
```
Step 1: Enter your script
```

VOICEOVER:
"Just type your script in one command."

---

**[0:25-0:40] Live Demo - Pipeline (15 seconds)**

VISUAL:
- Split screen showing 4 stages simultaneously (2x2 grid):
  - Top-left: TTS audio waveform generating
  - Top-right: Whisper timestamp JSON
  - Bottom-left: Scene detection algorithm
  - Bottom-right: Remotion render progress

Each section completes with checkmark

TEXT OVERLAY (animating in sequence):
```
✓ TTS Audio ($0.001)
✓ Timestamps ($0.0015)
✓ Scene Detection (Free)
✓ Rendering (Free)
```

VOICEOVER:
"The automated pipeline handles everything: speech generation, timestamps, scene detection, and rendering."

---

**[0:40-0:50] Live Demo - Output (10 seconds)**

VISUAL:
- Play the actual generated video (10 seconds)
- Show it playing on a phone mockup
- Overlay stats in corner

TEXT OVERLAY:
```
Total Cost: $0.003
Total Time: 3 minutes
Resolution: 1080x1920
```

VOICEOVER:
"Here's the result: professional quality, ready to publish."

---

**[0:50-0:60] CTA + Social Proof (10 seconds)**

VISUAL:
- Quick montage (1 sec each):
  - GitHub repo page showing stars
  - npm download stats
  - 6 different generated videos in grid
  - Terminal showing install command

TEXT OVERLAY:
```
npm install -g openclaw-video-generator

GitHub: /ZhenRobotics/openclaw-video-generator
1,000+ Stars | MIT License | Open Source
```

VOICEOVER:
"Try it free today. Open source and ready to use."

---

### Production Notes

**Screen Recording Settings:**
- Use Loom or OBS
- 1920x1080, 60fps
- Clean desktop (hide icons, close other apps)
- Terminal: Dark theme, large font (24pt)
- Mouse cursor: visible but not distracting

**Text Overlays:**
- Font: Inter or SF Pro (clean, modern)
- Color: Neon cyan (#00F5FF) on dark background
- Animation: Fade in + slight slide up
- Duration: Long enough to read 2x

**Audio:**
- Voiceover: Professional TTS (OpenAI "nova" at 1.1x speed) or human
- Background music: Royalty-free cyber/electronic
- Mix: VO 80%, Music 20%

**Editing:**
- Cut aggressively (no dead air)
- Speed up waiting parts (2x speed)
- Add subtle transitions (0.2s crossfade)
- Color grade: High contrast, slightly desaturated

---

## 30-Second Social Media Version

### Script

**DURATION**: 30 seconds
**STYLE**: Even faster, hook-heavy
**FORMAT**: 1080x1080 (square for Instagram/Twitter)

---

**[0:00-0:05] Hook**

VISUAL:
- Text appears word by word with emphasis

TEXT ON SCREEN:
```
Generate videos for
$0.003
Not a typo.
```

VOICEOVER:
"Generate professional videos for less than one cent."

---

**[0:05-0:15] Demo**

VISUAL:
- Terminal command appears
- Pipeline visualization (fast animation)
- Output video plays

TEXT ON SCREEN:
```
1. Type your script
2. Hit enter
3. Get video (3 min later)
```

VOICEOVER:
"Type your script, hit enter, get a professional video in 3 minutes."

---

**[0:15-0:25] Comparison**

VISUAL:
- Split screen comparison

LEFT SIDE:
```
Traditional
$150 | 4 hours
```

RIGHT SIDE:
```
OpenClaw
$0.003 | 3 min
```

VOICEOVER:
"One hundred fifty dollars and four hours, or three-tenths of a cent and three minutes?"

---

**[0:25-0:30] CTA**

VISUAL:
- GitHub QR code + npm command

TEXT ON SCREEN:
```
Try it free
npm install -g openclaw-video-generator
```

VOICEOVER:
"Try it free. Link in bio."

---

## 90-Second Technical Deep-Dive

### Script

**DURATION**: 90 seconds
**AUDIENCE**: Developers
**STYLE**: Technical walkthrough with code

---

**[0:00-0:10] Introduction**

"I built a text-to-video generator that costs $0.003 per video. Here's how it works technically."

VISUAL: Title card with project logo

---

**[0:10-0:30] Architecture Overview**

"The pipeline has four stages:"

VISUAL: Animated architecture diagram

```
Text Script
    ↓
OpenAI TTS → Audio File ($0.001)
    ↓
Whisper API → Timestamps ($0.0015)
    ↓
Scene Detector → React Components (Free)
    ↓
Remotion → Final Video (Free)
```

"TTS costs about a tenth of a cent, Whisper another tenth and a half, and rendering is free because it runs locally."

---

**[0:30-0:50] Code Walkthrough**

VISUAL: VS Code with code being highlighted as explained

"The scene renderer is just React:"

```typescript
export const SceneRenderer: React.FC = ({ scene }) => {
  const frame = useCurrentFrame();
  const { fps } = useVideoConfig();

  const animation = spring({
    frame,
    fps,
    config: { damping: 100 }
  });

  return (
    <AbsoluteFill style={{ opacity: animation }}>
      <h1>{scene.text}</h1>
    </AbsoluteFill>
  );
};
```

"Remotion uses React components to generate video frames. Each scene is a component with animations powered by the spring physics engine."

---

**[0:50-1:10] Smart Scene Detection**

VISUAL: Code + examples

"Scene detection automatically categorizes text:"

```typescript
function determineSceneType(text: string): SceneType {
  if (text.includes('%') || /\d+x/.test(text)) {
    return 'emphasis';  // Numbers = emphasize
  }
  if (text.includes('问题') || text.includes('pain')) {
    return 'pain';  // Pain points = shake effect
  }
  return 'content';  // Default
}
```

"If the text has percentages, it's emphasis. Pain point keywords trigger shake effects. It just works."

---

**[1:10-1:25] Performance & Cost**

VISUAL: Terminal showing render output + cost breakdown

"Performance on M1 MacBook Air:"
- 15-second video: 45 seconds render
- Concurrent rendering with --concurrency 4
- 1080x1920 resolution

"Cost breakdown:"
- TTS: $0.015 per 1K characters
- Whisper: $0.006 per minute
- Total: ~$0.003 per 15-second video

---

**[1:25-1:30] CTA**

"Full source on GitHub. MIT license. Star if you found this interesting."

VISUAL: GitHub link + star button

---

## Vertical Short-Form (TikTok/Reels Style)

### Script

**DURATION**: 15 seconds
**FORMAT**: 1080x1920 (vertical)
**STYLE**: Trending audio, fast cuts, text-heavy

---

**[0:00-0:03]**

VISUAL: Face camera or just text

TEXT ON SCREEN:
```
I spent 4 hours making ONE video
```

---

**[0:03-0:06]**

VISUAL: Terminal command

TEXT ON SCREEN:
```
Now I do it in 3 minutes
```

---

**[0:06-0:09]**

VISUAL: Generated video playing

TEXT ON SCREEN:
```
For $0.003
```

---

**[0:09-0:12]**

VISUAL: Split comparison

TEXT ON SCREEN:
```
Traditional: $150 | 4hrs
OpenClaw: $0.003 | 3min
```

---

**[0:12-0:15]**

VISUAL: GitHub repo

TEXT ON SCREEN:
```
Try it free
Link in bio
openclaw-video-generator
```

---

## Behind-the-Scenes Build Story

### Script

**DURATION**: 3-5 minutes
**STYLE**: Casual, storytelling
**AUDIENCE**: Makers, indie hackers

---

**Act 1: The Problem (0:00-1:00)**

"Three months ago, I had 20 GitHub projects. Zero had demo videos.

Why? Because making videos sucks.

Freelancers on Fiverr wanted $150 per video. That's $3,000 for all my projects.

I tried learning Premiere. Spent 8 hours on ONE video. It looked okay but... 8 hours?

So I did what any developer does when existing solutions suck: I built my own."

---

**Act 2: The Solution (1:00-2:30)**

"The idea was simple: automate everything.

Text goes in, video comes out.

I broke it down into four problems:

Problem 1: Turn text into speech
Solution: OpenAI TTS API. Costs a tenth of a cent per video.

Problem 2: Get precise timings
Solution: Whisper API. Gives me exact timestamps for each word.

Problem 3: Generate video scenes
Solution: Remotion. It's like React but for video. Game changer.

Problem 4: Make it look good
Solution: Cyber-wireframe aesthetic. Neon colors, glitch effects, grid backgrounds.

One month later, I had a working prototype."

---

**Act 3: The Results (2:30-3:30)**

"I tested it by generating 50 videos in one night.

Total cost: 15 cents.
Total time: 2.5 hours. (Most of it was just waiting for renders)

If I'd hired freelancers: $7,500 and two weeks.
If I'd done it myself: 200+ hours of editing.

The math is insane. 99.9% cost savings. 95% time savings.

So I open-sourced it. MIT license. Anyone can use it, modify it, whatever."

---

**Act 4: The Impact (3:30-4:30)**

"Two weeks after launching:

1,000 GitHub stars
500 npm downloads per day
Developers using it for demos
Creators using it for tutorials
Marketers using it for ads

The most common feedback: 'This should have existed years ago.'

My favorite use case: A teacher generating 100 course videos in one weekend. Updated her entire curriculum for $3.

Another person A/B tested 50 different marketing videos for a product launch. Found the winner. Would've cost $7,500 to test traditionally."

---

**Act 5: What's Next (4:30-5:00)**

"Current roadmap:

Week 1: More TTS providers
Week 2: Visual style templates
Week 3: Background music
Week 4: Web UI

Long-term: Make this the easiest way to create demo and tutorial videos.

If you're a developer, creator, or marketer who needs videos, try it:

npm install -g openclaw-video-generator

It's free. It's open source. And it might save you hundreds of hours.

Link in description. Let me know what you build with it."

---

## Testimonial/Case Study Video

### Script Format

**DURATION**: 2-3 minutes per case study
**STYLE**: Interview format

---

**Structure:**

1. **Introduction** (0:00-0:15)
   - Name, role, company/project
   - What they do

2. **The Problem** (0:15-0:45)
   - What was their video creation pain point?
   - What had they tried before?
   - Why didn't it work?

3. **The Solution** (0:45-1:30)
   - How they found OpenClaw Video Generator
   - How they use it (show their workflow)
   - Specific examples of videos they created

4. **The Results** (1:30-2:15)
   - Metrics (time saved, cost saved, videos created)
   - Business impact (more GitHub stars, more students, more sales)
   - Unexpected benefits

5. **Advice** (2:15-2:45)
   - Tips for others
   - Favorite features
   - What they'd tell someone considering it

6. **Call to Action** (2:45-3:00)
   - Where to find their work
   - Try OpenClaw Video Generator

---

**Example Questions to Ask:**

- "Walk me through creating a video. What's your process?"
- "How much time/money has this saved you?"
- "What surprised you most about using it?"
- "What would you tell someone who's on the fence?"
- "Show me your favorite video you've created with it."

---

## Batch Production Guide

### Create 10 Videos in One Session

**Video Types Needed:**

1. **Primary Demo** (60s) - For website, Product Hunt, YouTube
2. **Social Cut** (30s) - For Twitter, LinkedIn, Instagram
3. **Vertical Short** (15s) - For TikTok, Reels, Shorts
4. **Technical Deep-Dive** (90s) - For Dev.to, technical audience
5. **Build Story** (3-5min) - For YouTube, Indie Hackers
6. **Use Case: Developers** (60s) - "Generate GitHub Demo Videos"
7. **Use Case: Creators** (60s) - "Scale Your Content 10x"
8. **Use Case: Marketers** (60s) - "A/B Test Video Ads"
9. **Comparison** (45s) - "OpenClaw vs Traditional Editing"
10. **Tutorial** (2min) - "Getting Started in 2 Minutes"

**Production Schedule:**

**Day 1: Planning & Scripting**
- Write all 10 scripts
- Create shot lists
- Prepare assets (code snippets, graphics)

**Day 2: Recording**
- Record all screen recordings (2 hours)
- Record all voiceovers (1 hour)
- Record any face camera segments (1 hour)

**Day 3: Editing**
- Edit videos 1-5 (4 hours)
- Edit videos 6-10 (4 hours)

**Day 4: Polish & Publish**
- Add music and effects
- Color correction
- Export all versions
- Upload to platforms

**Total Time**: ~20 hours for 10 professional videos

**Efficiency Tips:**
- Batch similar tasks
- Use templates for overlays
- Record all VO in one session (voice consistency)
- Use same music track (brand consistency)
- Reuse B-roll across videos

---

## Asset Checklist

**Before Recording:**

- [ ] Clean desktop
- [ ] Terminal configured (dark theme, large font)
- [ ] Code editor ready (syntax highlighting on)
- [ ] Example scripts prepared
- [ ] Generated video examples rendered
- [ ] Music tracks selected
- [ ] Voiceover script printed/on teleprompter
- [ ] Screen recording software tested
- [ ] Microphone tested
- [ ] Lighting checked (if face camera)

**B-Roll Needed:**

- [ ] Terminal commands typing
- [ ] Pipeline visualization
- [ ] Generated videos playing
- [ ] GitHub repo page
- [ ] npm install command
- [ ] Code editor with source
- [ ] Cost breakdown graphics
- [ ] Comparison charts
- [ ] User testimonial quotes
- [ ] Community showcase

**Graphics/Overlays:**

- [ ] Logo/wordmark
- [ ] Social handles
- [ ] GitHub link
- [ ] npm command overlay
- [ ] Cost callouts
- [ ] Time savings callouts
- [ ] Features checklist
- [ ] CTA buttons
- [ ] Subscribe/follow reminders

---

## Distribution Checklist

**For Each Video:**

- [ ] YouTube (main channel)
- [ ] YouTube Shorts (vertical version)
- [ ] Twitter/X (with captions)
- [ ] LinkedIn (professional context)
- [ ] Instagram (square/vertical)
- [ ] TikTok (vertical short)
- [ ] Facebook (if applicable)
- [ ] Bilibili (Chinese version)
- [ ] Embedding in blog posts
- [ ] Product Hunt submission
- [ ] GitHub README
- [ ] Website homepage

**Optimization Per Platform:**

| Platform | Aspect Ratio | Length | Captions | Hashtags |
|----------|-------------|--------|----------|----------|
| YouTube | 16:9 | 1-10min | Optional | In description |
| Twitter | 16:9 or 1:1 | <2:20 | Required | 3-5 |
| LinkedIn | 16:9 or 1:1 | <3min | Required | 3-5 |
| Instagram | 1:1 or 9:16 | <60s | Required | 10-20 |
| TikTok | 9:16 | 15-60s | Optional | 3-5 |
| Reels | 9:16 | 15-60s | Optional | 5-10 |

---

**Production Budget:**

- Microphone (if needed): $50-100 (Blue Yeti or similar)
- Screen recorder: $0 (OBS) or $15/mo (Loom)
- Video editor: $0 (DaVinci Resolve) or existing software
- Music: $0 (royalty-free) or $15/mo (Epidemic Sound)
- Graphics: $0 (Canva free) or $13/mo (Canva Pro)

**Total**: $0-50/month for professional quality

---

Remember: The demo video is often the first impression. Invest time in making it compelling, clear, and action-oriented. Show don't tell. Demonstrate value in the first 10 seconds.
