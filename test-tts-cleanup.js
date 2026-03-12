#!/usr/bin/env node
/**
 * Test TTS text cleanup functionality
 */

// Simulate the cleanup logic
function cleanText(text) {
  let cleanText = text.trim();

  // Remove JSON metadata patterns (e.g., ",timeout:123}", ",maxTokens:456}")
  cleanText = cleanText.replace(/,\s*(timeout|maxTokens|temperature|metadata)[:\s]*[^}]*}?\s*$/gi, '');

  // Remove trailing commas and braces
  cleanText = cleanText.replace(/[,}\s]+$/, '').trim();

  return cleanText;
}

// Test cases
const testCases = [
  {
    input: '你好，世界',
    expected: '你好，世界',
  },
  {
    input: '三家巨头同一天说了一件事,timeout:30000}',
    expected: '三家巨头同一天说了一件事',
  },
  {
    input: 'AI改变世界, timeout: 30000 }',
    expected: 'AI改变世界',
  },
  {
    input: '测试文本,maxTokens:1000}',
    expected: '测试文本',
  },
  {
    input: '正常文本，没有元数据',
    expected: '正常文本，没有元数据',
  },
];

console.log('🧪 Testing TTS text cleanup function\n');

let passed = 0;
let failed = 0;

testCases.forEach((testCase, index) => {
  const result = cleanText(testCase.input);
  const success = result === testCase.expected;

  console.log(`Test ${index + 1}: ${success ? '✅ PASS' : '❌ FAIL'}`);
  console.log(`  Input:    "${testCase.input}"`);
  console.log(`  Expected: "${testCase.expected}"`);
  console.log(`  Got:      "${result}"`);

  if (!success) {
    console.log(`  Diff: Expected length ${testCase.expected.length}, got ${result.length}`);
  }

  console.log('');

  if (success) {
    passed++;
  } else {
    failed++;
  }
});

console.log(`\n📊 Results: ${passed}/${testCases.length} tests passed`);

if (failed > 0) {
  process.exit(1);
}
