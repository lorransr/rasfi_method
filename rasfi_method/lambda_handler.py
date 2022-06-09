from rasfi_method.model import RasfiInputs
from rasfi_method.main import apply_method

def handler(event,context):
    inputs = RasfiInputs(event)
    results = apply_method(inputs)
    return {"results": results.__dict__}