#!/usr/bin/env bash
# Load environment variables from .env file
set -a
source "$(dirname "$0")/.env"
set +a
echo "✅ Environment loaded:"
echo "   OPENAI_API_KEY: ${OPENAI_API_KEY:0:20}...${OPENAI_API_KEY: -4}"
echo "   OPENAI_API_BASE: ${OPENAI_API_BASE:-https://api.openai.com/v1}"
