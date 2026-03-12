#!/usr/bin/env python3
"""
Aliyun TTS - Simplified REST API Implementation
使用阿里云实时语音合成 REST API

文档: https://help.aliyun.com/document_detail/84435.html
只需 requests 库，无需复杂 SDK
"""

import sys
import os
import json
import time
import hmac
import hashlib
import base64
from urllib.parse import quote
from datetime import datetime, timezone

def sign_request(access_key_secret, string_to_sign):
    """计算 HMAC-SHA1 签名"""
    h = hmac.new(
        access_key_secret.encode('utf-8'),
        string_to_sign.encode('utf-8'),
        hashlib.sha1
    )
    return base64.b64encode(h.digest()).decode('utf-8')

def synthesize_speech(text, output_file, voice="xiaoyun", speech_rate=0):
    """调用阿里云语音合成 API"""
    import requests

    access_key_id = os.environ.get('ALIYUN_ACCESS_KEY_ID')
    access_key_secret = os.environ.get('ALIYUN_ACCESS_KEY_SECRET')
    app_key = os.environ.get('ALIYUN_APP_KEY')

    if not all([access_key_id, access_key_secret, app_key]):
        print("❌ Missing Aliyun credentials", file=sys.stderr)
        return False

    try:
        # 使用 NLS 一句话识别 API 的 token 方式（更简单）
        # 首先获取 token
        url = "https://nls-meta.cn-shanghai.aliyuncs.com/pop/2018-05-18/tokens"

        # 构造公共参数
        timestamp = datetime.now(timezone.utc).strftime('%Y-%m-%dT%H:%M:%SZ')
        nonce = str(int(time.time() * 1000))

        params = {
            'AccessKeyId': access_key_id,
            'Action': 'CreateToken',
            'Format': 'JSON',
            'RegionId': 'cn-shanghai',
            'SignatureMethod': 'HMAC-SHA1',
            'SignatureNonce': nonce,
            'SignatureVersion': '1.0',
            'Timestamp': timestamp,
            'Version': '2018-05-18'
        }

        # 构造待签名字符串
        sorted_params = sorted(params.items())
        canonicalized = '&'.join([f"{quote(k, safe='')}={quote(str(v), safe='')}" for k, v in sorted_params])
        string_to_sign = f"GET&%2F&{quote(canonicalized, safe='')}"

        # 计算签名
        signature = sign_request(access_key_secret + '&', string_to_sign)
        params['Signature'] = signature

        # 获取 token
        response = requests.get(url, params=params, timeout=10)

        if response.status_code != 200:
            print(f"❌ Failed to get Aliyun token: {response.text}", file=sys.stderr)
            return False

        result = response.json()
        if 'Token' not in result or 'Id' not in result['Token']:
            print(f"❌ Invalid token response: {result}", file=sys.stderr)
            return False

        token = result['Token']['Id']

        # 使用 token 调用语音合成
        tts_url = "https://nls-gateway.cn-shanghai.aliyuncs.com/stream/v1/tts"

        headers = {
            'Content-Type': 'application/json'
        }

        payload = {
            'appkey': app_key,
            'token': token,
            'text': text,
            'format': 'mp3',
            'voice': voice,
            'speech_rate': speech_rate,
            'pitch_rate': 0,
            'enable_subtitle': False
        }

        tts_response = requests.post(tts_url, json=payload, headers=headers, timeout=30)

        if tts_response.status_code == 200:
            # 保存音频
            with open(output_file, 'wb') as f:
                f.write(tts_response.content)

            # 验证文件大小
            if os.path.getsize(output_file) > 0:
                print(f"✅ Aliyun TTS: Generated {output_file}", file=sys.stderr)
                return True
            else:
                print(f"❌ Aliyun TTS: Empty audio file", file=sys.stderr)
                return False
        else:
            print(f"❌ Aliyun TTS failed: {tts_response.status_code}", file=sys.stderr)
            print(f"   Response: {tts_response.text}", file=sys.stderr)
            return False

    except Exception as e:
        print(f"❌ Aliyun TTS error: {str(e)}", file=sys.stderr)
        import traceback
        traceback.print_exc(file=sys.stderr)
        return False

def main():
    if len(sys.argv) < 3:
        print("Usage: aliyun_tts_simple.py <text> <output_file> [voice] [speed]", file=sys.stderr)
        sys.exit(1)

    text = sys.argv[1]
    output_file = sys.argv[2]
    voice = sys.argv[3] if len(sys.argv) > 3 else "xiaoyun"
    speed = float(sys.argv[4]) if len(sys.argv) > 4 else 1.0

    # 转换速度为阿里云格式 (-500 到 500)
    speech_rate = int((speed - 1.0) * 500)
    speech_rate = max(-500, min(500, speech_rate))

    success = synthesize_speech(text, output_file, voice, speech_rate)
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
