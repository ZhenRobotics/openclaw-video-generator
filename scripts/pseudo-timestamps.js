#!/usr/bin/env node
// Generate pseudo timestamps by splitting script text and distributing the audio duration proportionally by character count.
const fs = require('fs');
const { execSync } = require('child_process');

function usage() {
  console.error('Usage: node scripts/pseudo-timestamps.js <script.txt> <audio.mp3> <out.json>');
  process.exit(2);
}

const [,, scriptPath, audioPath, outPath] = process.argv;
if (!scriptPath || !audioPath || !outPath) usage();

if (!fs.existsSync(scriptPath)) throw new Error('Script not found: ' + scriptPath);
if (!fs.existsSync(audioPath)) throw new Error('Audio not found: ' + audioPath);

const script = fs.readFileSync(scriptPath, 'utf8').trim();
// Split by Chinese/English sentence delimiters, keep non-empty
const parts = script
  .split(/[。！？!?.\n]+/)
  .map(s => s.trim())
  .filter(Boolean);
if (parts.length === 0) throw new Error('No sentences found in script');

// Get audio duration via ffprobe
let durationSec = parseFloat(execSync(`ffprobe -v error -show_entries format=duration -of default=nk=1:nw=1 "${audioPath}"`).toString().trim());
if (!isFinite(durationSec) || durationSec <= 0) throw new Error('Failed to read audio duration');

// Reserve small gaps between segments
const gap = 0.18; // seconds
const totalGaps = gap * Math.max(0, parts.length - 1);
const allocDur = Math.max(0.1, durationSec - totalGaps);

// Weigh by visible character length
const lens = parts.map(p => p.replace(/\s+/g, '').length || 1);
const totalLen = lens.reduce((a,b)=>a+b,0);

let t = 0;
const segments = parts.map((text, i) => {
  const segDur = allocDur * (lens[i] / totalLen);
  const start = t;
  const end = start + segDur;
  t = end + (i < parts.length - 1 ? gap : 0);
  return { start: +start.toFixed(2), end: +end.toFixed(2), text };
});

fs.writeFileSync(outPath, JSON.stringify(segments, null, 2));
console.log(outPath);
