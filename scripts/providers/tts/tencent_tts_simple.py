#!/usr/bin/env python3
"""
Tencent TTS - Simplified REST API Implementation
使用腾讯云语音合成 REST API

文档: https://cloud.tencent.com/document/product/1073/37995
只需 requests 库，使用 TC3-HMAC-SHA256 签名
"""

import sys
import os
import json
import time
import hmac
import hashlib
from datetime import datetime

def sign_tc3(secret_key, date, service, string_to_sign):
    """计算 TC3-HMAC-SHA256 签名"""
    def hmac_sha256(key, msg):
        return hmac.new(key, msg.encode('utf-8'), hashlib.sha256).digest()

    k_date = hmac_sha256(('TC3' + secret_key).encode('utf-8'), date)
    k_service = hmac_sha256(k_date, service)
    k_signing = hmac_sha256(k_service, 'tc3_request')
    signature = hmac.new(k_signing, string_to_sign.encode('utf-8'), hashlib.sha256).hexdigest()
    return signature

def synthesize_speech(text, output_file, voice_type=0, speed=1.0):
    """调用腾讯云语音合成 API"""
    import requests

    secret_id = os.environ.get('TENCENT_SECRET_ID')
    secret_key = os.environ.get('TENCENT_SECRET_KEY')
    app_id = os.environ.get('TENCENT_APP_ID')

    if not all([secret_id, secret_key]):
        print("❌ Missing Tencent credentials", file=sys.stderr)
        return False

    try:
        # 腾讯云 API 端点
        service = "tts"
        host = "tts.tencentcloudapi.com"
        endpoint = f"https://{host}"
        region = "ap-guangzhou"
        action = "TextToVoice"
        version = "2019-08-23"

        # 当前时间戳
        timestamp = int(time.time())
        date = datetime.utcfromtimestamp(timestamp).strftime('%Y-%m-%d')

        # 构造请求体
        payload = {
            "Text": text,
            "SessionId": f"session_{timestamp}",
            "VoiceType": voice_type,  # 0: 女声, 1: 男声
            "Speed": speed,
            "Codec": "mp3",
            "EnableSubtitle": False
        }

        payload_str = json.dumps(payload)

        # 构造 CanonicalRequest
        http_method = "POST"
        canonical_uri = "/"
        canonical_querystring = ""
        canonical_headers = f"content-type:application/json; charset=utf-8\nhost:{host}\n"
        signed_headers = "content-type;host"
        hashed_payload = hashlib.sha256(payload_str.encode('utf-8')).hexdigest()

        canonical_request = (
            f"{http_method}\n"
            f"{canonical_uri}\n"
            f"{canonical_querystring}\n"
            f"{canonical_headers}\n"
            f"{signed_headers}\n"
            f"{hashed_payload}"
        )

        # 构造待签名字符串
        algorithm = "TC3-HMAC-SHA256"
        credential_scope = f"{date}/{service}/tc3_request"
        hashed_canonical_request = hashlib.sha256(canonical_request.encode('utf-8')).hexdigest()

        string_to_sign = (
            f"{algorithm}\n"
            f"{timestamp}\n"
            f"{credential_scope}\n"
            f"{hashed_canonical_request}"
        )

        # 计算签名
        signature = sign_tc3(secret_key, date, service, string_to_sign)

        # 构造 Authorization
        authorization = (
            f"{algorithm} "
            f"Credential={secret_id}/{credential_scope}, "
            f"SignedHeaders={signed_headers}, "
            f"Signature={signature}"
        )

        # 发送请求
        headers = {
            "Authorization": authorization,
            "Content-Type": "application/json; charset=utf-8",
            "Host": host,
            "X-TC-Action": action,
            "X-TC-Timestamp": str(timestamp),
            "X-TC-Version": version,
            "X-TC-Region": region
        }

        response = requests.post(endpoint, headers=headers, data=payload_str, timeout=30)

        if response.status_code == 200:
            result = response.json()

            if 'Response' in result:
                if 'Error' in result['Response']:
                    error = result['Response']['Error']
                    print(f"❌ Tencent TTS error: {error.get('Code', 'Unknown')}", file=sys.stderr)
                    print(f"   Message: {error.get('Message', 'No message')}", file=sys.stderr)
                    return False

                if 'Audio' in result['Response']:
                    # Audio 是 base64 编码的音频数据
                    import base64
                    audio_data = base64.b64decode(result['Response']['Audio'])

                    with open(output_file, 'wb') as f:
                        f.write(audio_data)

                    if os.path.getsize(output_file) > 0:
                        print(f"✅ Tencent TTS: Generated {output_file}", file=sys.stderr)
                        return True
                    else:
                        print(f"❌ Tencent TTS: Empty audio file", file=sys.stderr)
                        return False

            print(f"❌ Tencent TTS: Invalid response: {result}", file=sys.stderr)
            return False
        else:
            print(f"❌ Tencent TTS failed: {response.status_code}", file=sys.stderr)
            print(f"   Response: {response.text}", file=sys.stderr)
            return False

    except Exception as e:
        print(f"❌ Tencent TTS error: {str(e)}", file=sys.stderr)
        import traceback
        traceback.print_exc(file=sys.stderr)
        return False

def main():
    if len(sys.argv) < 3:
        print("Usage: tencent_tts_simple.py <text> <output_file> [voice] [speed]", file=sys.stderr)
        sys.exit(1)

    text = sys.argv[1]
    output_file = sys.argv[2]
    voice = sys.argv[3] if len(sys.argv) > 3 else "0"  # 默认女声
    speed = float(sys.argv[4]) if len(sys.argv) > 4 else 1.0

    # 腾讯云支持的语速范围是 -2 到 2
    # 我们的速度是 1.0 = 正常，需要转换
    if speed < 0.5:
        tencent_speed = -2.0
    elif speed > 2.0:
        tencent_speed = 2.0
    else:
        tencent_speed = (speed - 1.0) * 2.0  # 映射到 -2 到 2

    try:
        voice_type = int(voice)
    except:
        voice_type = 0  # 默认女声

    success = synthesize_speech(text, output_file, voice_type, tencent_speed)
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
