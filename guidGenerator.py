import uuid

def generate_guid():
    guid = str(uuid.uuid4())
    return guid.replace('-', '')

print(generate_guid())  # Outputs a new GUID on each call without hyphens

