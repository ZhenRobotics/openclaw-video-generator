#!/usr/bin/env python3
"""
Tencent ASR - Simplified REST API Implementation
使用腾讯云一句话识别 REST API

文档: https://cloud.tencent.com/document/product/1093/37823
只需 requests 库，使用 TC3-HMAC-SHA256 签名
"""

import sys
import os
import json
import time
import hmac
import hashlib
import base64
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

def transcribe_audio(audio_file, output_json, language="zh"):
    """调用腾讯云一句话识别 API"""
    import requests

    secret_id = os.environ.get('TENCENT_SECRET_ID')
    secret_key = os.environ.get('TENCENT_SECRET_KEY')

    if not all([secret_id, secret_key]):
        print("❌ Missing Tencent credentials", file=sys.stderr)
        return False

    if not os.path.exists(audio_file):
        print(f"❌ Audio file not found: {audio_file}", file=sys.stderr)
        return False

    try:
        # 腾讯云 API 端点
        service = "asr"
        host = "asr.tencentcloudapi.com"
        endpoint = f"https://{host}"
        region = "ap-guangzhou"
        action = "SentenceRecognition"
        version = "2019-06-14"

        # 当前时间戳
        timestamp = int(time.time())
        date = datetime.utcfromtimestamp(timestamp).strftime('%Y-%m-%d')

        # 读取音频文件并 Base64 编码
        with open(audio_file, 'rb') as f:
            audio_data = f.read()

        audio_base64 = base64.b64encode(audio_data).decode('utf-8')

        # 构造请求体
        payload = {
            "EngSerViceType": "16k_zh",  # 16k 中文
            "SourceType": 1,  # 音频数据
            "VoiceFormat": "mp3",
            "Data": audio_base64,
            "DataLen": len(audio_data)
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

        response = requests.post(endpoint, headers=headers, data=payload_str, timeout=60)

        if response.status_code == 200:
            result = response.json()

            if 'Response' in result:
                if 'Error' in result['Response']:
                    error = result['Response']['Error']
                    print(f"❌ Tencent ASR error: {error.get('Code', 'Unknown')}", file=sys.stderr)
                    print(f"   Message: {error.get('Message', 'No message')}", file=sys.stderr)
                    return False

                if 'Result' in result['Response']:
                    text = result['Response']['Result']

                    # 腾讯云一句话识别不返回时间戳
                    # 估算音频时长
                    file_size = os.path.getsize(audio_file)
                    estimated_duration = file_size / 16000  # MP3 128kbps 估算

                    # 生成单个时间戳片段
                    segments = [{
                        'start': 0.0,
                        'end': estimated_duration,
                        'text': text
                    }]

                    # 保存为 JSON
                    with open(output_json, 'w', encoding='utf-8') as f:
                        json.dump(segments, f, ensure_ascii=False, indent=2)

                    print(f"✅ Tencent ASR: Transcribed {audio_file}", file=sys.stderr)
                    print(f"⚠️  Note: Tencent one-shot ASR doesn't provide timestamps", file=sys.stderr)
                    print(f"   Using estimated duration: {estimated_duration:.2f}s", file=sys.stderr)
                    return True

            print(f"❌ Tencent ASR: Invalid response: {result}", file=sys.stderr)
            return False
        else:
            print(f"❌ Tencent ASR failed: {response.status_code}", file=sys.stderr)
            print(f"   Response: {response.text}", file=sys.stderr)
            return False

    except Exception as e:
        print(f"❌ Tencent ASR error: {str(e)}", file=sys.stderr)
        import traceback
        traceback.print_exc(file=sys.stderr)
        return False

def main():
    if len(sys.argv) < 3:
        print("Usage: tencent_asr_simple.py <audio_file> <output_json> [language]", file=sys.stderr)
        sys.exit(1)

    audio_file = sys.argv[1]
    output_json = sys.argv[2]
    language = sys.argv[3] if len(sys.argv) > 3 else "zh"

    success = transcribe_audio(audio_file, output_json, language)
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
