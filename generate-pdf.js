#!/usr/bin/env node
/**
 * Markdown to PDF converter using Puppeteer
 */

const fs = require('fs');
const path = require('path');
const { execSync } = require('child_process');

const INPUT = process.argv[2] || 'PROJECT_ROADMAP_2026.md';
const OUTPUT = process.argv[3] || INPUT.replace(/\.md$/, '.pdf');

if (!fs.existsSync(INPUT)) {
  console.error(`Error: File not found: ${INPUT}`);
  process.exit(1);
}

console.log(`📖 读取 Markdown: ${INPUT}`);
const markdown = fs.readFileSync(INPUT, 'utf-8');

// Generate HTML
const html = `<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>OpenClaw Video Generator - Project Roadmap 2026</title>
    <style>
        @page {
            size: A4;
            margin: 2cm;
        }

        * {
            box-sizing: border-box;
        }

        body {
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Microsoft YaHei', 'PingFang SC', sans-serif;
            line-height: 1.7;
            color: #333;
            max-width: 900px;
            margin: 0 auto;
            padding: 20px;
            font-size: 11pt;
        }

        h1 {
            color: #1a1a1a;
            border-bottom: 3px solid #0066cc;
            padding-bottom: 10px;
            margin-top: 30px;
            font-size: 26pt;
            page-break-after: avoid;
        }

        h2 {
            color: #0066cc;
            border-bottom: 2px solid #e0e0e0;
            padding-bottom: 8px;
            margin-top: 25px;
            font-size: 18pt;
            page-break-after: avoid;
        }

        h3 {
            color: #333;
            margin-top: 20px;
            font-size: 14pt;
            page-break-after: avoid;
        }

        h4 {
            color: #555;
            margin-top: 15px;
            font-size: 12pt;
        }

        p {
            margin: 10px 0;
            text-align: justify;
        }

        code {
            background-color: #f5f5f5;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'Consolas', 'Monaco', 'Courier New', monospace;
            font-size: 9pt;
            color: #d63384;
        }

        pre {
            background-color: #f8f8f8;
            border: 1px solid #ddd;
            border-radius: 5px;
            padding: 12px;
            overflow-x: auto;
            font-size: 9pt;
            line-height: 1.4;
            page-break-inside: avoid;
        }

        pre code {
            background-color: transparent;
            padding: 0;
            color: #333;
        }

        table {
            border-collapse: collapse;
            width: 100%;
            margin: 15px 0;
            font-size: 9pt;
            page-break-inside: avoid;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 8px 10px;
            text-align: left;
        }

        th {
            background-color: #0066cc;
            color: white;
            font-weight: bold;
        }

        tr:nth-child(even) {
            background-color: #f9f9f9;
        }

        ul, ol {
            margin: 10px 0;
            padding-left: 30px;
        }

        li {
            margin: 5px 0;
        }

        blockquote {
            border-left: 4px solid #0066cc;
            margin: 15px 0;
            padding: 10px 20px;
            background-color: #f0f7ff;
            font-style: italic;
        }

        hr {
            border: none;
            border-top: 2px solid #e0e0e0;
            margin: 30px 0;
        }

        strong {
            color: #000;
            font-weight: 600;
        }

        em {
            font-style: italic;
            color: #555;
        }

        a {
            color: #0066cc;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        .emoji {
            font-family: 'Apple Color Emoji', 'Segoe UI Emoji', 'Segoe UI Symbol';
        }

        @media print {
            body {
                max-width: 100%;
            }

            h1, h2, h3 {
                page-break-after: avoid;
            }

            pre, table {
                page-break-inside: avoid;
            }
        }
    </style>
</head>
<body>
${convertMarkdownToHTML(markdown)}
</body>
</html>`;

// Simple markdown to HTML converter
function convertMarkdownToHTML(md) {
  let html = md;

  // Escape HTML special chars in code blocks first
  html = html.replace(/```([\s\S]*?)```/g, (match, code) => {
    code = code
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;');
    return '<pre><code>' + code.trim() + '</code></pre>';
  });

  // Inline code
  html = html.replace(/`([^`]+)`/g, '<code>$1</code>');

  // Headers
  html = html.replace(/^#### (.+)$/gm, '<h4>$1</h4>');
  html = html.replace(/^### (.+)$/gm, '<h3>$1</h3>');
  html = html.replace(/^## (.+)$/gm, '<h2>$1</h2>');
  html = html.replace(/^# (.+)$/gm, '<h1>$1</h1>');

  // Bold
  html = html.replace(/\*\*(.+?)\*\*/g, '<strong>$1</strong>');

  // Italic
  html = html.replace(/\*(.+?)\*/g, '<em>$1</em>');

  // Links
  html = html.replace(/\[([^\]]+)\]\(([^)]+)\)/g, '<a href="$2">$1</a>');

  // Horizontal rules
  html = html.replace(/^---$/gm, '<hr>');

  // Lists (simplified)
  html = html.replace(/^- (.+)$/gm, '<li>$1</li>');
  html = html.replace(/^\d+\. (.+)$/gm, '<li>$1</li>');

  // Wrap consecutive list items in ul
  html = html.replace(/(<li>.*?<\/li>\n?)+/gs, (match) => {
    return '<ul>' + match + '</ul>';
  });

  // Tables (basic support)
  const tableRegex = /^\|(.+)\|\n\|[-:| ]+\|\n((?:\|.+\|\n?)+)/gm;
  html = html.replace(tableRegex, (match, header, rows) => {
    const headerCells = header.split('|').filter(c => c.trim());
    const headerHTML = '<thead><tr>' +
      headerCells.map(c => '<th>' + c.trim() + '</th>').join('') +
      '</tr></thead>';

    const rowsHTML = rows.trim().split('\n').map(row => {
      const cells = row.split('|').filter(c => c.trim());
      return '<tr>' + cells.map(c => '<td>' + c.trim() + '</td>').join('') + '</tr>';
    }).join('');

    return '<table>' + headerHTML + '<tbody>' + rowsHTML + '</tbody></table>';
  });

  // Paragraphs (wrap non-HTML lines)
  html = html.split('\n\n').map(block => {
    if (block.match(/^<[h1-6|ul|ol|pre|table|hr]/)) {
      return block;
    }
    return '<p>' + block.replace(/\n/g, ' ') + '</p>';
  }).join('\n');

  return html;
}

// Save temporary HTML
const tempHTML = path.join(__dirname, 'temp-roadmap.html');
fs.writeFileSync(tempHTML, html);
console.log(`📝 生成临时 HTML: ${tempHTML}`);

// Convert to PDF using Chrome
try {
  console.log(`🖨️  转换为 PDF...`);
  execSync(
    `google-chrome --headless --disable-gpu --no-sandbox --print-to-pdf="${OUTPUT}" "${tempHTML}"`,
    { stdio: 'inherit' }
  );
  console.log(`✅ PDF 生成成功: ${OUTPUT}`);

  // Clean up
  fs.unlinkSync(tempHTML);

  // Show file size
  const stats = fs.statSync(OUTPUT);
  const size = (stats.size / 1024).toFixed(1);
  console.log(`📦 文件大小: ${size} KB`);
} catch (error) {
  console.error(`❌ PDF 生成失败:`, error.message);
  console.log(`保留临时文件: ${tempHTML}`);
  process.exit(1);
}
