import requests
import json

API_KEY = "AIzaSyAbKCEYBcK2LHfGihk2gd_DcR-EvPcFlP0"
URL = f"https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key={API_KEY}"

excel_columns = ["CIRCLE_NAME", "APPLICATION_STATUS", "BENEFICIARY_NO", "Full Name", "Mobile No"]

prompt_text = f"""
You are an intelligent data mapping assistant. Map these Excel columns to standard fields.
Columns: {json.dumps(excel_columns)}

Map to:
- name
- location
- phone
- status

Return JSON only.
"""

payload = {
    "contents": [{
        "parts": [{"text": prompt_text}]
    }]
}

print(f"Testing Gemini API with key: {API_KEY[:5]}...{API_KEY[-5:]}")

try:
    response = requests.post(URL, json=payload, headers={"Content-Type": "application/json"})
    print(f"Status Code: {response.status_code}")
    
    if response.status_code == 200:
        data = response.json()
        print("Success! Response from AI:")
        print(data['candidates'][0]['content']['parts'][0]['text'])
    else:
        print("Error Response:")
        print(response.text)

except Exception as e:
    print(f"Request failed: {e}")
