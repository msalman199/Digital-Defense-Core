# 🔏 Cryptography with Python

> A hands-on cryptography lab covering AES, RSA, hybrid encryption, and digital signatures — building real-world secure communication systems using Python and industry-standard libraries.

![Python](https://img.shields.io/badge/Python-3.8%2B-3776AB?style=for-the-badge&logo=python&logoColor=white)
![AES](https://img.shields.io/badge/AES-Symmetric%20Encryption-FF6B6B?style=for-the-badge&logo=letsencrypt&logoColor=white)
![RSA](https://img.shields.io/badge/RSA-Asymmetric%20Encryption-4CAF50?style=for-the-badge&logo=shield&logoColor=white)
![Hybrid](https://img.shields.io/badge/Hybrid-RSA%20%2B%20AES-FF9800?style=for-the-badge&logo=security&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Cloud%20Lab-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![cryptography](https://img.shields.io/badge/Library-cryptography-9C27B0?style=for-the-badge&logo=python&logoColor=white)

---

## 🎯 Objectives

By the end of this lab, you will be able to:

- ✅ Implement **symmetric encryption** using AES (Advanced Encryption Standard)
- ✅ Create **asymmetric encryption** using RSA (Rivest-Shamir-Adleman)
- ✅ **Compare performance** and use cases of symmetric vs asymmetric encryption
- ✅ Apply cryptographic principles to **secure data transmission**
- ✅ Understand **hybrid encryption** combining RSA and AES

---

## 📋 Prerequisites

| Requirement | Level |
|---|---|
| 🐍 Python Programming (functions, classes, file I/O) | Basic |
| 🖥️ Linux Command Line | Basic |
| 🔒 Encryption/Decryption Concepts | Basic |
| 💻 Terminal Environment Access | Required |

---

## 🌐 Lab Environment

> **Al Nafi** provides ready-to-use Linux-based cloud machines for this lab.  
> Click **Start Lab** to access your pre-configured environment with Python 3 and necessary tools already installed.

---

## 🗂️ Lab Structure

```
crypto_lab/
├── 📄 aes_crypto.py        # Task 1 — AES symmetric encryption
├── 📄 rsa_crypto.py        # Task 2 — RSA asymmetric encryption
├── 📄 crypto_compare.py    # Task 3 — Performance comparison
├── 📄 hybrid_crypto.py     # Task 4 — Hybrid encryption system
├── 🔑 private.pem          # RSA private key (PEM format)
└── 🔑 public.pem           # RSA public key (PEM format)
```

---

## 🚀 Task 1 — AES Symmetric Encryption

![Task](https://img.shields.io/badge/Task-1%20of%204-FF5722?style=flat-square)
![File](https://img.shields.io/badge/File-aes__crypto.py-607D8B?style=flat-square&logo=python)
![Fernet](https://img.shields.io/badge/Fernet-AES--128--CBC-FF6B6B?style=flat-square)
![PBKDF2](https://img.shields.io/badge/KDF-PBKDF2%20100k%20iters-2196F3?style=flat-square)

### ⚙️ Step 1 — Environment Setup

Install the required cryptography library:

```bash
sudo apt update
sudo apt install python3-pip -y
pip3 install cryptography
```

Verify installation:

```bash
python3 -c "from cryptography.fernet import Fernet; print('Ready')"
```

---

### 📝 Step 2 — Create AES Encryption Module

Create a working directory and script:

```bash
mkdir ~/crypto_lab && cd ~/crypto_lab
nano aes_crypto.py
```

Enter the following starter code:

```python
#!/usr/bin/env python3

from cryptography.fernet import Fernet
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
import base64
import os

class AESCrypto:
    """AES encryption/decryption handler using Fernet"""
    
    def __init__(self):
        self.key = None
        self.cipher = None
    
    def generate_key(self):
        """
        Generate a new random encryption key.
        Store it in self.key and initialize self.cipher.
        """
        # TODO: Generate key using Fernet.generate_key()
        # TODO: Create cipher suite with Fernet(self.key)
        # TODO: Return the key
        pass
    
    def generate_key_from_password(self, password: str, salt: bytes = None):
        """
        Derive encryption key from password using PBKDF2.
        
        Args:
            password: User password string
            salt: Optional salt bytes (generate if None)
        
        Returns:
            Tuple of (key, salt)
        """
        # TODO: Generate salt if None (os.urandom(16))
        # TODO: Create PBKDF2HMAC with SHA256, 100000 iterations
        # TODO: Derive key and encode with base64.urlsafe_b64encode
        # TODO: Initialize self.cipher with derived key
        # TODO: Return (key, salt)
        pass
    
    def encrypt(self, plaintext: str) -> bytes:
        """
        Encrypt plaintext message.
        
        Args:
            plaintext: Message to encrypt
        
        Returns:
            Encrypted bytes
        """
        # TODO: Check if cipher is initialized
        # TODO: Encode plaintext to bytes
        # TODO: Encrypt using self.cipher.encrypt()
        # TODO: Return encrypted bytes
        pass
    
    def decrypt(self, ciphertext: bytes) -> str:
        """
        Decrypt encrypted message.
        
        Args:
            ciphertext: Encrypted bytes
        
        Returns:
            Decrypted plaintext string
        """
        # TODO: Check if cipher is initialized
        # TODO: Decrypt using self.cipher.decrypt()
        # TODO: Decode bytes to string
        # TODO: Return plaintext
        pass
    
    def save_key(self, filename: str):
        """Save encryption key to file"""
        # TODO: Write self.key to file in binary mode
        pass
    
    def load_key(self, filename: str):
        """Load encryption key from file"""
        # TODO: Read key from file in binary mode
        # TODO: Initialize self.cipher with loaded key
        pass

def main():
    """Test AES encryption functionality"""
    print("=== AES Encryption Demo ===\n")
    
    # TODO: Create AESCrypto instance
    # TODO: Generate random key
    # TODO: Encrypt a test message
    # TODO: Decrypt the message
    # TODO: Verify original matches decrypted
    
    # TODO: Test password-based encryption
    # TODO: Save and load key from file
    
    print("\n=== Demo Complete ===")

if __name__ == "__main__":
    main()
```

Save and make executable:

```bash
chmod +x aes_crypto.py
```

---

### 🧪 Step 3 — Implement and Test

Complete the TODO sections in the code, then run:

```bash
python3 aes_crypto.py
```

| Behaviour | Expected Result |
|---|---|
| Key generation | ✅ Succeeds |
| Message encryption | ✅ Produces unreadable ciphertext |
| Decryption | ✅ Recovers original message |
| Password-based key derivation | ✅ Works correctly |
| Key save/load | ✅ Operates correctly |

---

## 🔑 Task 2 — RSA Asymmetric Encryption

![Task](https://img.shields.io/badge/Task-2%20of%204-FF9800?style=flat-square)
![File](https://img.shields.io/badge/File-rsa__crypto.py-607D8B?style=flat-square&logo=python)
![RSA](https://img.shields.io/badge/RSA-2048--bit-4CAF50?style=flat-square)
![OAEP](https://img.shields.io/badge/Padding-OAEP%20%7C%20PSS-2196F3?style=flat-square)
![Signatures](https://img.shields.io/badge/Feature-Digital%20Signatures-9C27B0?style=flat-square)

### 📝 Step 1 — Create RSA Module

Create a new script:

```bash
nano rsa_crypto.py
```

Enter the starter code:

```python
#!/usr/bin/env python3

from cryptography.hazmat.primitives.asymmetric import rsa, padding
from cryptography.hazmat.primitives import serialization, hashes
from cryptography.hazmat.backends import default_backend

class RSACrypto:
    """RSA encryption/decryption and digital signatures"""
    
    def __init__(self):
        self.private_key = None
        self.public_key = None
    
    def generate_keypair(self, key_size: int = 2048):
        """
        Generate RSA public/private key pair.
        
        Args:
            key_size: Key size in bits (2048 or 4096)
        """
        # TODO: Generate private key using rsa.generate_private_key()
        # TODO: Extract public key from private key
        # TODO: Store both in instance variables
        pass
    
    def save_keys(self, private_file: str = "private.pem", 
                   public_file: str = "public.pem"):
        """Save keys to PEM files"""
        # TODO: Serialize private key to PEM format (no encryption)
        # TODO: Write private key to file
        # TODO: Serialize public key to PEM format
        # TODO: Write public key to file
        pass
    
    def load_keys(self, private_file: str = "private.pem",
                   public_file: str = "public.pem"):
        """Load keys from PEM files"""
        # TODO: Read and deserialize private key
        # TODO: Read and deserialize public key
        pass
    
    def encrypt(self, plaintext: str) -> bytes:
        """
        Encrypt message with public key.
        Note: RSA can only encrypt small messages (~190 bytes for 2048-bit key)
        
        Args:
            plaintext: Message to encrypt (must be short)
        
        Returns:
            Encrypted bytes
        """
        # TODO: Check message length (max ~190 bytes)
        # TODO: Encrypt using public_key.encrypt() with OAEP padding
        # TODO: Use SHA256 for MGF1 and algorithm
        # TODO: Return encrypted bytes
        pass
    
    def decrypt(self, ciphertext: bytes) -> str:
        """
        Decrypt message with private key.
        
        Args:
            ciphertext: Encrypted bytes
        
        Returns:
            Decrypted plaintext
        """
        # TODO: Decrypt using private_key.decrypt() with OAEP padding
        # TODO: Decode bytes to string
        # TODO: Return plaintext
        pass
    
    def sign(self, message: str) -> bytes:
        """
        Create digital signature for message.
        
        Args:
            message: Message to sign
        
        Returns:
            Signature bytes
        """
        # TODO: Sign message using private_key.sign()
        # TODO: Use PSS padding with SHA256
        # TODO: Return signature
        pass
    
    def verify(self, message: str, signature: bytes) -> bool:
        """
        Verify digital signature.
        
        Args:
            message: Original message
            signature: Signature to verify
        
        Returns:
            True if valid, False otherwise
        """
        # TODO: Verify using public_key.verify()
        # TODO: Use PSS padding with SHA256
        # TODO: Return True if valid, catch exception and return False
        pass

def main():
    """Test RSA encryption and signatures"""
    print("=== RSA Encryption Demo ===\n")
    
    # TODO: Create RSACrypto instance
    # TODO: Generate key pair
    # TODO: Save keys to files
    
    # TODO: Test encryption/decryption with short message
    # TODO: Verify decrypted matches original
    
    # TODO: Test digital signature creation
    # TODO: Verify signature is valid
    # TODO: Test with tampered message (should fail)
    
    # TODO: Test loading keys from files
    
    print("\n=== Demo Complete ===")

if __name__ == "__main__":
    main()
```

---

### 🧪 Step 2 — Implement and Test

```bash
chmod +x rsa_crypto.py
python3 rsa_crypto.py
```

| Behaviour | Expected Result |
|---|---|
| Key pair generation (2048-bit) | ✅ Succeeds |
| Short message encrypt/decrypt | ✅ Works correctly |
| Digital signature creation | ✅ Verified successfully |
| Tampered message verification | ❌ Fails as expected |
| Keys save/load (PEM) | ✅ Operates correctly |

---

## ⚡ Task 3 — Comparing Encryption Methods

![Task](https://img.shields.io/badge/Task-3%20of%204-2196F3?style=flat-square)
![File](https://img.shields.io/badge/File-crypto__compare.py-607D8B?style=flat-square&logo=python)
![Benchmark](https://img.shields.io/badge/Feature-Performance%20Benchmark-FF5722?style=flat-square)

### 📝 Step 1 — Create Comparison Script

```bash
nano crypto_compare.py
```

Enter the comparison framework:

```python
#!/usr/bin/env python3

import time
from cryptography.fernet import Fernet
from cryptography.hazmat.primitives.asymmetric import rsa, padding
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.backends import default_backend

def benchmark_aes():
    """
    Benchmark AES encryption/decryption speed.
    Test with a large message (1000+ characters).
    
    Returns:
        Tuple of (encrypt_time, decrypt_time, encrypted_size)
    """
    # TODO: Generate AES key
    # TODO: Create test message (large)
    # TODO: Time encryption operation
    # TODO: Time decryption operation
    # TODO: Return timing results and size
    pass

def benchmark_rsa():
    """
    Benchmark RSA encryption/decryption speed.
    Test with a small message (<190 bytes).
    
    Returns:
        Tuple of (encrypt_time, decrypt_time, encrypted_size)
    """
    # TODO: Generate RSA key pair
    # TODO: Create test message (small)
    # TODO: Time encryption operation
    # TODO: Time decryption operation
    # TODO: Return timing results and size
    pass

def compare_methods():
    """Run comparison and display results"""
    print("=== Encryption Method Comparison ===\n")
    
    # TODO: Run AES benchmark
    # TODO: Run RSA benchmark
    # TODO: Display timing comparisons
    # TODO: Display size comparisons
    # TODO: Print use case recommendations
    pass

if __name__ == "__main__":
    compare_methods()
```

---

### 🧪 Step 2 — Run Comparison

```bash
chmod +x crypto_compare.py
python3 crypto_compare.py
```

Reflect on these analysis questions after running the benchmark:

- 🚀 Which method is **faster** for large data?
- 📦 Which produces **smaller ciphertext**?
- 📏 What are the **message size limitations**?
- 🧠 When should you **use each method**?

---

## 🛡️ Task 4 — Hybrid Encryption Implementation

![Task](https://img.shields.io/badge/Task-4%20of%204-4CAF50?style=flat-square)
![File](https://img.shields.io/badge/File-hybrid__crypto.py-607D8B?style=flat-square&logo=python)
![TLS](https://img.shields.io/badge/Real--World-TLS%20%7C%20SSL%20%7C%20PGP-FF6B6B?style=flat-square)
![Pattern](https://img.shields.io/badge/Pattern-RSA%20%2B%20AES%20Combined-9C27B0?style=flat-square)

### 📝 Step 1 — Create Hybrid System

```bash
nano hybrid_crypto.py
```

Implement hybrid encryption combining RSA and AES:

```python
#!/usr/bin/env python3

from cryptography.fernet import Fernet
from cryptography.hazmat.primitives.asymmetric import rsa, padding
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.backends import default_backend

def hybrid_encrypt(message: str, rsa_public_key):
    """
    Encrypt large message using hybrid cryptography.
    
    Process:
    1. Generate random AES key
    2. Encrypt message with AES key
    3. Encrypt AES key with RSA public key
    4. Return both encrypted components
    
    Args:
        message: Large plaintext message
        rsa_public_key: RSA public key object
    
    Returns:
        Tuple of (encrypted_aes_key, encrypted_message)
    """
    # TODO: Generate random AES key
    # TODO: Encrypt message with AES
    # TODO: Encrypt AES key with RSA public key
    # TODO: Return both encrypted components
    pass

def hybrid_decrypt(encrypted_aes_key: bytes, encrypted_message: bytes,
                   rsa_private_key) -> str:
    """
    Decrypt message encrypted with hybrid cryptography.
    
    Process:
    1. Decrypt AES key using RSA private key
    2. Decrypt message using recovered AES key
    3. Return plaintext
    
    Args:
        encrypted_aes_key: RSA-encrypted AES key
        encrypted_message: AES-encrypted message
        rsa_private_key: RSA private key object
    
    Returns:
        Decrypted plaintext message
    """
    # TODO: Decrypt AES key with RSA private key
    # TODO: Create Fernet cipher with recovered key
    # TODO: Decrypt message with AES
    # TODO: Return plaintext
    pass

def main():
    """Test hybrid encryption system"""
    print("=== Hybrid Encryption Demo ===\n")
    
    # TODO: Generate RSA key pair
    # TODO: Create large test message (1000+ chars)
    # TODO: Encrypt using hybrid_encrypt()
    # TODO: Decrypt using hybrid_decrypt()
    # TODO: Verify original matches decrypted
    # TODO: Display advantages of hybrid approach
    
    print("\n=== Demo Complete ===")

if __name__ == "__main__":
    main()
```

---

### 🧪 Step 2 — Test Hybrid System

```bash
chmod +x hybrid_crypto.py
python3 hybrid_crypto.py
```

### 💡 How Hybrid Encryption Works

```
┌─────────────────────────────────────────────────┐
│              HYBRID ENCRYPTION FLOW              │
├─────────────────────────────────────────────────┤
│                                                 │
│  Large Message  ──►  AES Encrypt  ──►  Ciphertext│
│                           ▲                     │
│  Random AES Key ──────────┘                     │
│       │                                         │
│       └──►  RSA Encrypt (Public Key)            │
│                    │                            │
│                    ▼                            │
│           Encrypted AES Key                     │
│                                                 │
│  📦 Send: [ Encrypted AES Key + Ciphertext ]    │
└─────────────────────────────────────────────────┘
```

| Concept | Detail |
|---|---|
| 🔑 RSA encrypts | Only the small AES key |
| ⚡ AES encrypts | The large message |
| 🌐 Real-world use | TLS/SSL, PGP, secure messaging |
| 🏆 Benefit | Speed of AES + security of RSA |

---

## ✅ Expected Outcomes

After completing this lab, you will have built:

| Component | Capability | Status |
|---|---|---|
| ⚡ AES Implementation | Random keys, password-based KDF, encrypt/decrypt any size, save/load keys | 📦 Task 1 |
| 🔐 RSA Implementation | Key pair generation, short message encryption, digital signatures, tamper detection | 📦 Task 2 |
| 📊 Performance Comparison | Benchmarks, size analysis, use-case guidance | 📦 Task 3 |
| 🛡️ Hybrid System | Combines RSA + AES, handles large messages, industry-standard pattern | 📦 Task 4 |

### 🔬 Performance Summary

```
⚡  AES Speed          →  100–1000x faster than RSA
📏  RSA Size Limit     →  ~190 bytes max (2048-bit key)
📦  Ciphertext Size    →  AES produces smaller output
🔐  Key Exchange       →  RSA handles this securely
✍️   Digital Signatures →  RSA only (AES can't sign)
🌐  Industry Standard  →  Hybrid (TLS, PGP, SSH)
```

---

## 🛠️ Troubleshooting

### ❗ Import Errors

If cryptography modules fail to import:

```bash
pip3 install --upgrade cryptography
python3 -m pip install cryptography --user
```

---

### ❗ Message Too Large for RSA

RSA encryption fails with large messages. Solutions:

> ✅ Keep RSA messages **under 190 bytes** (2048-bit key)  
> ✅ Use **hybrid encryption** for large data  
> ❌ Splitting into chunks — not recommended  

---

### ❗ Key File Permissions

If key files have permission issues:

```bash
chmod 600 *.pem *.key
ls -la *.pem *.key
```

---

### ❗ Decryption Failures

Common causes and fixes:

| Cause | Fix |
|---|---|
| Wrong key used for decryption | Verify key pair matches |
| Corrupted ciphertext | Re-encrypt from original |
| Mismatched encryption method | Ensure same padding/algorithm |
| Key not initialized before use | Call generate/load before encrypt |

---

## 📚 Key Takeaways

> ⚡ **Symmetric (AES)** — Fast and efficient; requires secure key distribution  
> 🔐 **Asymmetric (RSA)** — Slower; enables secure key exchange and digital signatures  
> 🛡️ **Hybrid** — Industry standard combining both for real-world use  
> 🌐 **Real-world** — TLS/SSL, PGP, and secure messaging all use these techniques  
> 🚫 **Never** implement your own cryptographic algorithms in production — always use well-tested libraries  

---

## 🔭 Next Steps

- [ ] 🏛️ Explore **certificate authorities** and PKI
- [ ] #️⃣ Study **hash functions** and message authentication codes (MACs)
- [ ] 📐 Investigate **elliptic curve cryptography** (ECC)
- [ ] 🗝️ Learn about **key management** best practices

---

## 🧰 Technology Stack

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![cryptography](https://img.shields.io/badge/cryptography-FF6B6B?style=for-the-badge&logo=letsencrypt&logoColor=white)
![AES](https://img.shields.io/badge/AES%20Fernet-Symmetric-4CAF50?style=for-the-badge&logoColor=white)
![RSA](https://img.shields.io/badge/RSA%202048--bit-Asymmetric-2196F3?style=for-the-badge&logoColor=white)
![PBKDF2](https://img.shields.io/badge/PBKDF2-Key%20Derivation-FF9800?style=for-the-badge&logoColor=white)
![OAEP](https://img.shields.io/badge/OAEP%20%7C%20PSS-Padding-9C27B0?style=for-the-badge&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

---

<div align="center">

**Built for the Al Nafi Cybersecurity Lab Program**  
*Remember: Never implement your own cryptographic algorithms in production. Always use well-tested libraries like the ones in this lab.*

</div>
