# IMPORT MODULE PYCRYPTODOME - PIP INSTALL PYCRYPTODOME
from Crypto.Cipher import AES
from Crypto.Random import get_random_bytes
from Crypto.Protocol.KDF import scrypt
import base64

def encrypt_script(script, password):
    # Generate a random salt
    salt = get_random_bytes(16)

    # Derive a key using scrypt
    key = scrypt(password.encode(), salt, 32, N=2**14, r=8, p=1)

    # Create an AES cipher object
    cipher = AES.new(key, AES.MODE_GCM)

    # Encrypt the script
    ciphertext, tag = cipher.encrypt_and_digest(script.encode())

    # Combine salt, nonce, and ciphertext for storage
    encrypted_script = salt + cipher.nonce + tag + ciphertext

    return base64.b64encode(encrypted_script).decode()

def decrypt_script(encrypted_script, password):
    # Decode the base64 encoded string
    encrypted_script = base64.b64decode(encrypted_script)

    # Extract salt, nonce, tag, and ciphertext
    salt = encrypted_script[:16]
    nonce = encrypted_script[16:32]
    tag = encrypted_script[32:48]
    ciphertext = encrypted_script[48:]

    # Derive key using scrypt
    key = scrypt(password.encode(), salt, 32, N=2**14, r=8, p=1)

    # Create an AES cipher object
    cipher = AES.new(key, AES.MODE_GCM, nonce=nonce)

    # Decrypt the script
    decrypted_script = cipher.decrypt_and_verify(ciphertext, tag)

    return decrypted_script.decode()

# Example usage:
script = "This is a top-secret script!"
password = "SuperSecurePassword"

encrypted_script = encrypt_script(script, password)
print("Encrypted Script:", encrypted_script)

decrypted_script = decrypt_script(encrypted_script, password)
print("Decrypted Script:", decrypted_script)
