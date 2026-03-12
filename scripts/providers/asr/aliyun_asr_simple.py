#!/usr/bin/env python3
"""
Aliyun ASR - Simplified REST API Implementation
使用阿里云一句话识别 REST API

文档: https://help.aliyun.com/document_detail/92131.html
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

def transcribe_audio(audio_file, output_json, language="zh"):
    """调用阿里云一句话识别 API"""
    import requests

    access_key_id = os.environ.get('ALIYUN_ACCESS_KEY_ID')
    access_key_secret = os.environ.get('ALIYUN_ACCESS_KEY_SECRET')
    app_key = os.environ.get('ALIYUN_APP_KEY')

    if not all([access_key_id, access_key_secret, app_key]):
        print("❌ Missing Aliyun credentials", file=sys.stderr)
        return False

    if not os.path.exists(audio_file):
        print(f"❌ Audio file not found: {audio_file}", file=sys.stderr)
        return False

    try:
        # 首先获取 token
        url = "https://nls-meta.cn-shanghai.aliyuncs.com/pop/2018-05-18/tokens"

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

        # 读取音频文件
        with open(audio_file, 'rb') as f:
            audio_data = f.read()

        # 使用一句话识别 API
        asr_url = "https://nls-gateway.cn-shanghai.aliyuncs.com/stream/v1/asr"

        headers = {
            'Content-Type': 'application/octet-stream'
        }

        asr_params = {
            'appkey': app_key,
            'token': token,
            'format': 'mp3',
            'enable_punctuation_prediction': 'true',
            'enable_inverse_text_normalization': 'true',
            'enable_intermediate_result': 'false'
        }

        asr_response = requests.post(
            asr_url,
            params=asr_params,
            headers=headers,
            data=audio_data,
            timeout=60
        )

        if asr_response.status_code == 200:
            result = asr_response.json()

            # 阿里云一句话识别不返回时间戳
            # 需要使用文件转写服务才能获取时间戳
            # 这里我们使用简化方案：将整个文本作为一个片段

            if 'result' in result:
                text = result['result']

                # 估算音频时长（通过文件大小粗略估算）
                # MP3 128kbps: 1秒 ≈ 16KB
                file_size = os.path.getsize(audio_file)
                estimated_duration = file_size / 16000  # 粗略估算

                # 生成单个时间戳片段
                segments = [{
                    'start': 0.0,
                    'end': estimated_duration,
                    'text': text
                }]

                # 保存为 JSON
                with open(output_json, 'w', encoding='utf-8') as f:
                    json.dump(segments, f, ensure_ascii=False, indent=2)

                print(f"✅ Aliyun ASR: Transcribed {audio_file}", file=sys.stderr)
                print(f"⚠️  Note: Aliyun one-shot ASR doesn't provide timestamps", file=sys.stderr)
                print(f"   Using estimated duration: {estimated_duration:.2f}s", file=sys.stderr)
                return True
            else:
                print(f"❌ Aliyun ASR: No result in response: {result}", file=sys.stderr)
                return False
        else:
            print(f"❌ Aliyun ASR failed: {asr_response.status_code}", file=sys.stderr)
            print(f"   Response: {asr_response.text}", file=sys.stderr)
            return False

    except Exception as e:
        print(f"❌ Aliyun ASR error: {str(e)}", file=sys.stderr)
        import traceback
        traceback.print_exc(file=sys.stderr)
        return False

def main():
    if len(sys.argv) < 3:
        print("Usage: aliyun_asr_simple.py <audio_file> <output_json> [language]", file=sys.stderr)
        sys.exit(1)

    audio_file = sys.argv[1]
    output_json = sys.argv[2]
    language = sys.argv[3] if len(sys.argv) > 3 else "zh"

    success = transcribe_audio(audio_file, output_json, language)
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
