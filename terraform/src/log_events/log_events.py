import json

print("Starting log_events.py")

def lambda_handler(event, context):
    print("Received event: " + json.dumps(event, indent=2))
    return
