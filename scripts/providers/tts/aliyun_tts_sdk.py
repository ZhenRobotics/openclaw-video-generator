#!/usr/bin/env python3
"""
Aliyun TTS - Official SDK Implementation
使用阿里云官方 Python SDK

依赖: pip install aliyun-python-sdk-nls-cloud-meta
文档: https://help.aliyun.com/document_detail/84435.html
"""

import sys
import os
import json
import base64

def synthesize_speech(text, output_file, voice="xiaoyun", speech_rate=0):
    """调用阿里云语音合成 API (官方 SDK)"""

    # 导入 SDK
    try:
        from aliyunsdkcore.client import AcsClient
        from aliyunsdkcore.request import CommonRequest
    except ImportError:
        print("❌ Aliyun SDK not installed", file=sys.stderr)
        print("   Install: pip install aliyun-python-sdk-core aliyun-python-sdk-nls-cloud-meta", file=sys.stderr)
        return False

    access_key_id = os.environ.get('ALIYUN_ACCESS_KEY_ID')
    access_key_secret = os.environ.get('ALIYUN_ACCESS_KEY_SECRET')
    app_key = os.environ.get('ALIYUN_APP_KEY')

    if not all([access_key_id, access_key_secret, app_key]):
        print("❌ Missing Aliyun credentials", file=sys.stderr)
        return False

    try:
        # 创建客户端
        client = AcsClient(access_key_id, access_key_secret, 'cn-shanghai')

        # 首先获取 token
        token_request = CommonRequest()
        token_request.set_domain('nls-meta.cn-shanghai.aliyuncs.com')
        token_request.set_version('2019-02-28')
        token_request.set_action_name('CreateToken')
        token_request.set_method('POST')

        try:
            token_response = client.do_action_with_exception(token_request)
            token_data = json.loads(token_response)

            if 'Token' not in token_data or 'Id' not in token_data['Token']:
                print(f"❌ Failed to get token: {token_data}", file=sys.stderr)
                return False

            token = token_data['Token']['Id']
        except Exception as e:
            print(f"❌ Token request failed: {str(e)}", file=sys.stderr)
            return False

        # 使用 token 调用语音合成
        import requests

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

        response = requests.post(tts_url, json=payload, headers=headers, timeout=30)

        if response.status_code == 200:
            # 检查响应内容
            content_type = response.headers.get('Content-Type', '')

            if 'audio' in content_type or len(response.content) > 1000:
                # 这是音频数据
                with open(output_file, 'wb') as f:
                    f.write(response.content)

                if os.path.getsize(output_file) > 0:
                    print(f"✅ Aliyun TTS: Generated {output_file}", file=sys.stderr)
                    return True
                else:
                    print(f"❌ Aliyun TTS: Empty audio file", file=sys.stderr)
                    return False
            else:
                # 可能是错误消息
                try:
                    error_data = response.json()
                    print(f"❌ Aliyun TTS error: {error_data}", file=sys.stderr)
                except:
                    print(f"❌ Aliyun TTS: Invalid response", file=sys.stderr)
                    print(f"   Content: {response.content[:200]}", file=sys.stderr)
                return False
        else:
            print(f"❌ Aliyun TTS failed: {response.status_code}", file=sys.stderr)
            print(f"   Response: {response.text[:500]}", file=sys.stderr)
            return False

    except Exception as e:
        print(f"❌ Aliyun TTS error: {str(e)}", file=sys.stderr)
        import traceback
        traceback.print_exc(file=sys.stderr)
        return False

def main():
    if len(sys.argv) < 3:
        print("Usage: aliyun_tts_sdk.py <text> <output_file> [voice] [speed]", file=sys.stderr)
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
