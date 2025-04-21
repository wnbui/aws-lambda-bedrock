import json, os, boto3

client = boto3.client("bedrock-runtime")

def handler(event, context):
    # parse incoming JSON
    body = json.loads(event.get("body", "{}"))
    prompt = body.get("input", "").strip()
    if not prompt:
        return {"statusCode": 400, "body": json.dumps({"error": "No input provided"})}

    model_id = os.getenv("BEDROCK_MODEL_ID", "mistral.mistral-small-2402-v1:0")
    endpoint = os.getenv("BEDROCK_ENDPOINT")
    # build the Mistral prompt payload
    payload = {
        "prompt": f"<s>[INST] {prompt} [/INST]",
        "max_tokens": 500,
        "temperature": 0.7
    }

    try:
        response = client.invoke_model(
            modelId=model_id,
            contentType="application/json",
            body=json.dumps(payload)
        )
        data = json.loads(response["body"].read())
        # Mistral returns text in outputs[0].text
        text = data.get("outputs", [{}])[0].get("text", "")
        return {"statusCode": 200, "body": json.dumps({"response": text})}
    except Exception as e:
        return {"statusCode": 500, "body": json.dumps({"error": str(e)})}
