import os
import base64

# Define the desired length (16 characters, a multiple of 4)
length = 16

# Generate random bytes
random_bytes = os.urandom(length)

# Encode the random bytes in base64
base64_password = base64.b64encode(random_bytes).decode()

print("Generated Base64 Password:", base64_password)
