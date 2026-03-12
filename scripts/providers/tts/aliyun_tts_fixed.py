#!/usr/bin/env python3
"""
Aliyun TTS - Fixed Signature Implementation
严格按照阿里云签名规范实现

文档: https://help.aliyun.com/document_detail/315526.html
"""

import sys
import os
import json
import time
import hmac
import hashlib
import base64
from datetime import datetime
from urllib.parse import quote

def percent_encode(value):
    """
    阿里云专用 URL 编码
    规则:
    - 字母、数字、-、_、.、~ 不编码
    - 其他字符用 %XY 编码
    - 空格编码为 %20（不是 +）
    - 扩展 UTF-8 字符先转 UTF-8 再编码
    """
    if value is None:
        return ''

    # 使用 quote，安全字符设置为只包含字母数字和 -_.~
    # quote 默认不编码 -_.~ 但会编码 /，我们需要明确指定
    res = quote(str(value), safe='~')

    # Python 的 quote 已经正确处理了大部分，但我们需要确保：
    # - 空格是 %20（quote 默认就是）
    # - * 要编码为 %2A
    res = res.replace('+', '%20')  # 以防万一
    res = res.replace('*', '%2A')
    res = res.replace('%7E', '~')  # ~ 不应该被编码

    return res

def compute_signature(secret, string_to_sign):
    """计算 HMAC-SHA1 签名"""
    # 注意：阿里云签名的 key 是 AccessKeySecret + '&'
    key = (secret + '&').encode('utf-8')
    message = string_to_sign.encode('utf-8')

    h = hmac.new(key, message, hashlib.sha1)
    signature = base64.b64encode(h.digest()).decode('utf-8')

    return signature

def get_aliyun_token(access_key_id, access_key_secret):
    """获取阿里云 NLS Token"""
    import requests

    # 公共参数
    timestamp = datetime.utcnow().strftime('%Y-%m-%dT%H:%M:%SZ')
    nonce = str(int(time.time() * 1000000))  # 使用微秒确保唯一性

    # 所有参数（不包括 Signature）
    parameters = {
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

    # 步骤1: 按键排序
    sorted_params = sorted(parameters.items())

    # 步骤2: 构造规范化请求字符串
    # 格式: key1=value1&key2=value2...（key 和 value 都要编码）
    canonicalized_query_string = '&'.join([
        f"{percent_encode(k)}={percent_encode(v)}"
        for k, v in sorted_params
    ])

    # 步骤3: 构造待签名字符串
    # 格式: HTTPMethod&EncodedURI&EncodedQueryString
    string_to_sign = '&'.join([
        'GET',
        percent_encode('/'),
        percent_encode(canonicalized_query_string)
    ])

    # 步骤4: 计算签名
    signature = compute_signature(access_key_secret, string_to_sign)

    # 步骤5: 添加签名到参数
    parameters['Signature'] = signature

    # 发送请求
    url = 'https://nls-meta.cn-shanghai.aliyuncs.com/'

    try:
        response = requests.get(url, params=parameters, timeout=10)

        if response.status_code == 200:
            result = response.json()
            if 'Token' in result and 'Id' in result['Token']:
                return result['Token']['Id']
            else:
                print(f"❌ Invalid token response: {result}", file=sys.stderr)
                return None
        else:
            print(f"❌ Token request failed: {response.status_code}", file=sys.stderr)
            print(f"   Response: {response.text}", file=sys.stderr)

            # 调试信息：对比服务器期望的签名字符串
            try:
                error_data = response.json()
                if 'Message' in error_data:
                    print(f"   Server message: {error_data['Message']}", file=sys.stderr)

                # 打印我们计算的字符串以便对比
                print(f"   Our string to sign: {string_to_sign}", file=sys.stderr)
            except:
                pass

            return None
    except Exception as e:
        print(f"❌ Token request exception: {str(e)}", file=sys.stderr)
        import traceback
        traceback.print_exc(file=sys.stderr)
        return None

def synthesize_speech(text, output_file, voice="xiaoyun", speech_rate=0):
    """调用阿里云 TTS"""
    import requests

    access_key_id = os.environ.get('ALIYUN_ACCESS_KEY_ID')
    access_key_secret = os.environ.get('ALIYUN_ACCESS_KEY_SECRET')
    app_key = os.environ.get('ALIYUN_APP_KEY')

    if not all([access_key_id, access_key_secret, app_key]):
        print("❌ Missing Aliyun credentials", file=sys.stderr)
        return False

    try:
        # 获取 token
        token = get_aliyun_token(access_key_id, access_key_secret)
        if not token:
            return False

        print(f"✅ Got token: {token[:20]}...", file=sys.stderr)

        # 调用 TTS
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
            # 保存音频
            with open(output_file, 'wb') as f:
                f.write(response.content)

            file_size = os.path.getsize(output_file)
            if file_size > 100:
                print(f"✅ Aliyun TTS: Generated {output_file} ({file_size} bytes)", file=sys.stderr)
                return True
            else:
                print(f"❌ File too small: {file_size} bytes", file=sys.stderr)
                # 尝试解析错误
                try:
                    error_data = json.loads(response.content)
                    print(f"   Error: {error_data}", file=sys.stderr)
                except:
                    print(f"   Content: {response.content[:200]}", file=sys.stderr)
                return False
        else:
            print(f"❌ TTS request failed: {response.status_code}", file=sys.stderr)
            print(f"   Response: {response.text[:500]}", file=sys.stderr)
            return False

    except Exception as e:
        print(f"❌ Aliyun TTS error: {str(e)}", file=sys.stderr)
        import traceback
        traceback.print_exc(file=sys.stderr)
        return False

def main():
    if len(sys.argv) < 3:
        print("Usage: aliyun_tts_fixed.py <text> <output_file> [voice] [speed]", file=sys.stderr)
        sys.exit(1)

    text = sys.argv[1]
    output_file = sys.argv[2]
    voice = sys.argv[3] if len(sys.argv) > 3 else "xiaoyun"
    speed = float(sys.argv[4]) if len(sys.argv) > 4 else 1.0

    # 转换速度
    speech_rate = int((speed - 1.0) * 500)
    speech_rate = max(-500, min(500, speech_rate))

    success = synthesize_speech(text, output_file, voice, speech_rate)
    sys.exit(0 if success else 1)

if __name__ == "__main__":
    main()
