from rasfi_method.model import RasfiInputs
from rasfi_method.main import apply_method
import json
import logging

logger = logging.getLogger()
logger.setLevel(logging.INFO)

def handler(event,context):
    body = json.loads(event["body"])
    logger.info(f"received body: {body}")
    inputs = RasfiInputs(**body)
    results = apply_method(inputs)
    return {
        "statusCode": 200,
        'headers': {
            'Access-Control-Allow-Headers': 'Content-Type',
            'Access-Control-Allow-Origin': '*',
            'Access-Control-Allow-Methods': 'POST'
        },
        "body": json.dumps(results.__dict__)
        }