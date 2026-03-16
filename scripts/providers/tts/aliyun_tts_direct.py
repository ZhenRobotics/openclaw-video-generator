#!/usr/bin/env python3
"""
Aliyun TTS - Direct REST API (无需 token)
使用阿里云 NLS RESTful API 直接方式

文档: https://help.aliyun.com/document_detail/84435.html
"""

import sys
import os
import json
import time
import hmac
import hashlib
import base64
from urllib.parse import quote_plus
from datetime import datetime

def percent_encode(s):
    """URL 编码（符合阿里云规范）"""
    return quote_plus(str(s)).replace('+', '%20').replace('*', '%2A').replace('%7E', '~')

def sign_string(access_key_secret, string_to_sign):
    """计算签名"""
    h = hmac.new(
        (access_key_secret + '&').encode('utf-8'),
        string_to_sign.encode('utf-8'),
        hashlib.sha1
    )
    return base64.b64encode(h.digest()).decode('utf-8')

def synthesize_speech_direct(text, output_file, voice="xiaoyun", speech_rate=0):
    """直接调用阿里云 TTS，不使用 SDK"""
    import requests

    access_key_id = os.environ.get('ALIYUN_ACCESS_KEY_ID')
    access_key_secret = os.environ.get('ALIYUN_ACCESS_KEY_SECRET')
    app_key = os.environ.get('ALIYUN_APP_KEY')

    if not all([access_key_id, access_key_secret, app_key]):
        print("❌ Missing Aliyun credentials", file=sys.stderr)
        return False

    try:
        # 构造公共参数
        timestamp = datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')
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
            'Version': '2019-02-28'
        }

        # 按字典序排序
        sorted_params = sorted(params.items())

        # 构造待签名的字符串
        canonical_query_string = '&'.join([f"{percent_encode(k)}={percent_encode(v)}" for k, v in sorted_params])
        string_to_sign = f"GET&{percent_encode('/')}&{percent_encode(canonical_query_string)}"

        # 计算签名
        signature = sign_string(access_key_secret, string_to_sign)
        params['Signature'] = signature

        # 发送请求获取 token
        url = 'https://nls-meta.cn-shanghai.aliyuncs.com/'

        response = requests.get(url, params=params, timeout=10)

        if response.status_code != 200:
            print(f"❌ Failed to get token: {response.status_code}", file=sys.stderr)
            print(f"   Response: {response.text}", file=sys.stderr)
            return False

        result = response.json()

        if 'Token' not in result or 'Id' not in result['Token']:
            print(f"❌ Invalid token response: {result}", file=sys.stderr)
            return False

        token = result['Token']['Id']
        print(f"✅ Got Aliyun token: {token[:20]}...", file=sys.stderr)

        # 使用 token 调用 TTS
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

            if os.path.getsize(output_file) > 100:
                print(f"✅ Aliyun TTS: Generated {output_file}", file=sys.stderr)
                return True
            else:
                print(f"❌ Aliyun TTS: File too small ({os.path.getsize(output_file)} bytes)", file=sys.stderr)
                print(f"   Content: {tts_response.content[:200]}", file=sys.stderr)
                return False
        else:
            print(f"❌ Aliyun TTS failed: {tts_response.status_code}", file=sys.stderr)
            print(f"   Response: {tts_response.text[:500]}", file=sys.stderr)
            return False

    except Exception as e:
        print(f"❌ Aliyun TTS error: {str(e)}", file=sys.stderr)
        import traceback
        traceback.print_exc(file=sys.stderr)
        return False

def main():
    if len(sys.argv) < 3:
        print("Usage: aliyun_tts_direct.py <text> <output_file> [voice] [speed]", file=sys.stderr)
        sys.exit(1)

    text = sys.argv[1]
    output_file = sys.argv[2]
    voice = sys.argv[3] if len(sys.argv) > 3 else "xiaoyun"
    speed = float(sys.argv[4]) if len(sys.argv) > 4 else 1.0

    # 转换速度
    speech_rate = int((speed - 1.0) * 500)
    speech_rate = max(-500, min(500, speech_rate))

    success = synthesize_speech_direct(text, output_file, voice, speech_rate)
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
