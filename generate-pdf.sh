#!/bin/bash
#
# Markdown to PDF converter using Chrome headless
#

set -e

INPUT_MD="$1"
OUTPUT_PDF="${2:-${INPUT_MD%.md}.pdf}"

if [ -z "$INPUT_MD" ]; then
    echo "Usage: $0 <input.md> [output.pdf]"
    exit 1
fi

if [ ! -f "$INPUT_MD" ]; then
    echo "Error: File not found: $INPUT_MD"
    exit 1
fi

# Create temporary HTML file
TEMP_HTML=$(mktemp --suffix=.html)

cat > "$TEMP_HTML" <<'EOF'
<!DOCTYPE html>
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
            font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Microsoft YaHei', sans-serif;
            line-height: 1.6;
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
            font-size: 28pt;
            page-break-after: avoid;
        }

        h2 {
            color: #0066cc;
            border-bottom: 2px solid #e0e0e0;
            padding-bottom: 8px;
            margin-top: 25px;
            font-size: 20pt;
            page-break-after: avoid;
        }

        h3 {
            color: #333;
            margin-top: 20px;
            font-size: 16pt;
            page-break-after: avoid;
        }

        h4 {
            color: #555;
            margin-top: 15px;
            font-size: 13pt;
        }

        p {
            margin: 10px 0;
            text-align: justify;
        }

        code {
            background-color: #f5f5f5;
            padding: 2px 6px;
            border-radius: 3px;
            font-family: 'Consolas', 'Monaco', monospace;
            font-size: 9pt;
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
        }

        table {
            border-collapse: collapse;
            width: 100%;
            margin: 15px 0;
            font-size: 10pt;
            page-break-inside: avoid;
        }

        th, td {
            border: 1px solid #ddd;
            padding: 8px;
            text-align: left;
        }

        th {
            background-color: #f0f0f0;
            font-weight: bold;
            color: #333;
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
            background-color: #f9f9f9;
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

        a {
            color: #0066cc;
            text-decoration: none;
        }

        a:hover {
            text-decoration: underline;
        }

        .page-break {
            page-break-before: always;
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
EOF

# Convert markdown to HTML using basic sed/awk (simple conversion)
# Note: This is a simplified converter. For complex markdown, consider using marked/showdown
awk '
BEGIN { in_code = 0; in_table = 0; }

# Code blocks
/^```/ {
    if (in_code == 0) {
        lang = substr($0, 4);
        print "<pre><code class=\"language-" lang "\">";
        in_code = 1;
    } else {
        print "</code></pre>";
        in_code = 0;
    }
    next;
}

in_code == 1 {
    gsub(/&/, "\\&amp;");
    gsub(/</, "\\&lt;");
    gsub(/>/, "\\&gt;");
    print;
    next;
}

# Headers
/^# / { sub(/^# /, ""); print "<h1>" $0 "</h1>"; next; }
/^## / { sub(/^## /, ""); print "<h2>" $0 "</h2>"; next; }
/^### / { sub(/^### /, ""); print "<h3>" $0 "</h3>"; next; }
/^#### / { sub(/^#### /, ""); print "<h4>" $0 "</h4>"; next; }

# Horizontal rule
/^---$/ { print "<hr>"; next; }

# Tables (simplified)
/^\|/ {
    if (in_table == 0) {
        print "<table>";
        in_table = 1;
    }

    # Remove leading/trailing pipes
    line = $0;
    gsub(/^\|/, "", line);
    gsub(/\|$/, "", line);

    # Check if header separator
    if (line ~ /^[-:| ]+$/) {
        next;
    }

    # Split by pipe
    split(line, cells, "|");

    # Detect header row (first row after table start)
    if (NR == table_start + 1) {
        print "<thead><tr>";
        for (i = 1; i <= length(cells); i++) {
            gsub(/^[ \t]+|[ \t]+$/, "", cells[i]);
            print "<th>" cells[i] "</th>";
        }
        print "</tr></thead><tbody>";
    } else {
        print "<tr>";
        for (i = 1; i <= length(cells); i++) {
            gsub(/^[ \t]+|[ \t]+$/, "", cells[i]);
            print "<td>" cells[i] "</td>";
        }
        print "</tr>";
    }
    next;
}

in_table == 1 && !/^\|/ {
    print "</tbody></table>";
    in_table = 0;
}

# Lists
/^- / { sub(/^- /, ""); print "<li>" $0 "</li>"; next; }
/^[0-9]+\. / { sub(/^[0-9]+\. /, ""); print "<li>" $0 "</li>"; next; }

# Inline code
{
    gsub(/`([^`]+)`/, "<code>\\1</code>");
}

# Bold
{
    gsub(/\*\*([^*]+)\*\*/, "<strong>\\1</strong>");
}

# Links
{
    gsub(/\[([^\]]+)\]\(([^)]+)\)/, "<a href=\"\\2\">\\1</a>");
}

# Paragraphs
/^$/ { print "<p></p>"; next; }
{ print "<p>" $0 "</p>"; }

END {
    if (in_table == 1) {
        print "</tbody></table>";
    }
}
' "$INPUT_MD" >> "$TEMP_HTML"

cat >> "$TEMP_HTML" <<'EOF'
</body>
</html>
EOF

echo "生成临时 HTML: $TEMP_HTML"

# Convert HTML to PDF using Chrome headless
google-chrome --headless --disable-gpu --print-to-pdf="$OUTPUT_PDF" "$TEMP_HTML" 2>/dev/null

if [ $? -eq 0 ]; then
    echo "✅ PDF 生成成功: $OUTPUT_PDF"
    rm "$TEMP_HTML"
else
    echo "❌ PDF 生成失败"
    echo "临时文件保留: $TEMP_HTML"
    exit 1
fi
