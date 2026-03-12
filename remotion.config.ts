import { Config } from '@remotion/cli/config';

Config.setVideoImageFormat('jpeg');
Config.setOverwriteOutput(true);
Config.setCodec('h264');

// Increase timeout for background video loading
// Default is 30 seconds, increase to 60 seconds for large videos
Config.setDelayRenderTimeoutInMilliseconds(60000);

// Increase concurrent tasks for faster rendering
Config.setConcurrency(6);
