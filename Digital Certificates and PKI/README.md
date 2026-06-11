# 🏛️ Digital Certificates and PKI

> A hands-on PKI lab covering certificate generation, chain verification, digital signatures, expiration monitoring, and multi-level certificate hierarchies — using OpenSSL and Python's cryptography library.

![Python](https://img.shields.io/badge/Python-3.8%2B-3776AB?style=for-the-badge&logo=python&logoColor=white)
![OpenSSL](https://img.shields.io/badge/OpenSSL-Latest-FF6B6B?style=for-the-badge&logo=openssl&logoColor=white)
![PKI](https://img.shields.io/badge/PKI-Certificate%20Authority-4CAF50?style=for-the-badge&logo=letsencrypt&logoColor=white)
![RSA](https://img.shields.io/badge/RSA-2048%20%7C%204096--bit-FF9800?style=for-the-badge&logo=shield&logoColor=white)
![X.509](https://img.shields.io/badge/X.509-Digital%20Certificates-2196F3?style=for-the-badge&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Cloud%20Lab-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![cryptography](https://img.shields.io/badge/Library-cryptography-9C27B0?style=for-the-badge&logo=python&logoColor=white)

---

## 🎯 Objectives

By the end of this lab, you will be able to:

- ✅ Understand **PKI components** and certificate chains
- ✅ Generate and manage **digital certificates** using OpenSSL
- ✅ **Verify certificate authenticity** and validity programmatically
- ✅ Implement **digital signature** creation and verification
- ✅ Analyze **certificate properties** and expiration dates

---

## 📋 Prerequisites

| Requirement | Level |
|---|---|
| 🔐 Asymmetric Cryptography Concepts | Basic |
| 🖥️ Linux Command Line | Basic |
| 🐍 Python Programming | Basic |
| 📁 File System Navigation | Basic |

---

## 🌐 Lab Environment

Your cloud machine includes:

- ✅ **OpenSSL** (latest version)
- ✅ **Python 3.x** with cryptography library pre-installed
- ✅ **Text editors** (nano, vim)
- ✅ All necessary development tools

> Click **Start Lab** — no additional setup required.

---

## 🗂️ Lab Structure

```
pki_lab/
├── 🔑 server_private.key       # Server RSA private key
├── 📄 server.csr               # Server certificate signing request
├── 📜 server_cert.crt          # Self-signed server certificate
├── 🔑 ca_private.key           # Root CA private key (4096-bit)
├── 📜 ca_cert.crt              # Root CA certificate
├── 🔑 ca_signed_server.key     # CA-signed server private key
├── 📜 ca_signed_server.crt     # CA-signed server certificate
├── 🔑 intermediate_ca.key      # Intermediate CA private key
├── 📜 intermediate_ca.crt      # Intermediate CA certificate
├── 🔑 end_entity.key           # End-entity private key
├── 📜 end_entity.crt           # End-entity certificate
├── 📄 chain.pem                # Certificate chain bundle
├── 📄 certificate_verifier.py      # Task 2
├── 📄 digital_signature_demo.py    # Task 3
├── 📄 cert_expiration_monitor.py   # Task 4
└── 📄 multi_level_verifier.py      # Task 5
```

---

## 🔏 Task 1 — Generate Self-Signed Certificates

![Task](https://img.shields.io/badge/Task-1%20of%205-FF5722?style=flat-square)
![Tool](https://img.shields.io/badge/Tool-OpenSSL-FF6B6B?style=flat-square)
![Type](https://img.shields.io/badge/Cert-Self--Signed%20%7C%20CA--Signed-607D8B?style=flat-square)

### 📁 Step 1 — Create Working Directory

```bash
mkdir ~/pki_lab
cd ~/pki_lab
```

---

### 🔑 Step 2 — Generate Private Key and Self-Signed Certificate

```bash
# Generate 2048-bit RSA private key
openssl genrsa -out server_private.key 2048

# Create Certificate Signing Request (CSR)
openssl req -new -key server_private.key -out server.csr
```

When prompted, enter:

| Field | Value |
|---|---|
| Country | `US` |
| State | Your State |
| City | Your City |
| Organization | `Test Organization` |
| Organizational Unit | `IT Department` |
| Common Name | `localhost` |
| Email | `admin@test.com` |
| Challenge Password | *(leave blank)* |

```bash
# Generate self-signed certificate (365 days validity)
openssl x509 -req -days 365 -in server.csr -signkey server_private.key -out server_cert.crt

# Examine the certificate
openssl x509 -in server_cert.crt -text -noout
```

---

### 🏛️ Step 3 — Create Certificate Authority (CA)

```bash
# Generate CA private key (4096-bit for higher security)
openssl genrsa -out ca_private.key 4096

# Create CA certificate (10 years validity)
openssl req -new -x509 -days 3650 -key ca_private.key -out ca_cert.crt
```

CA certificate details:

| Field | Value |
|---|---|
| Country | `US` |
| Organization | `Test CA Organization` |
| Organizational Unit | `Certificate Authority` |
| Common Name | `Test Root CA` |
| Email | `ca@test.com` |

---

### 📜 Step 4 — Create CA-Signed Server Certificate

```bash
# Generate server private key
openssl genrsa -out ca_signed_server.key 2048

# Create CSR for CA-signed certificate
openssl req -new -key ca_signed_server.key -out ca_signed_server.csr
```

Server certificate details:

| Field | Value |
|---|---|
| Organization | `Test Server Organization` |
| Organizational Unit | `Web Services` |
| Common Name | `testserver.local` |
| Email | `server@test.com` |

```bash
# Sign server certificate with CA
openssl x509 -req -days 365 -in ca_signed_server.csr \
  -CA ca_cert.crt -CAkey ca_private.key \
  -CAcreateserial -out ca_signed_server.crt

# Verify the certificate chain
openssl verify -CAfile ca_cert.crt ca_signed_server.crt
```

---

## 🔍 Task 2 — Certificate Verification with Python

![Task](https://img.shields.io/badge/Task-2%20of%205-FF9800?style=flat-square)
![File](https://img.shields.io/badge/File-certificate__verifier.py-607D8B?style=flat-square&logo=python)
![x509](https://img.shields.io/badge/Module-cryptography.x509-2196F3?style=flat-square)

### 📝 Step 1 — Create Certificate Verification Script

Create **`certificate_verifier.py`**:

```python
#!/usr/bin/env python3

from cryptography import x509
from cryptography.hazmat.backends import default_backend
from cryptography.x509.oid import NameOID
import datetime

def load_certificate(cert_path):
    """
    Load a PEM certificate from file.
    
    Args:
        cert_path: Path to certificate file
    
    Returns:
        Certificate object or None on error
    """
    # TODO: Open and read certificate file
    # TODO: Use x509.load_pem_x509_certificate() with default_backend()
    # TODO: Handle exceptions and return None on error
    pass

def display_certificate_info(certificate, cert_name):
    """
    Display certificate information including subject, issuer, and validity.
    
    Args:
        certificate: Certificate object
        cert_name: Descriptive name for output
    """
    print(f"\n=== {cert_name} Certificate Information ===")
    
    # TODO: Extract and display subject information
    # TODO: Extract and display issuer information
    # TODO: Display validity period (not_valid_before, not_valid_after)
    # TODO: Check if certificate is currently valid
    # TODO: Display serial number and public key information
    pass

def verify_certificate_chain(ca_cert, server_cert):
    """
    Verify that server certificate is signed by CA certificate.
    
    Args:
        ca_cert: CA certificate object
        server_cert: Server certificate object
    
    Returns:
        True if verification succeeds, False otherwise
    """
    print(f"\n=== Certificate Chain Verification ===")
    
    # TODO: Compare server certificate issuer with CA subject
    # TODO: Verify signature using CA's public key
    # TODO: Return verification result
    pass

def main():
    print("PKI Certificate Verification Tool")
    print("=" * 50)
    
    # TODO: Load ca_cert.crt, ca_signed_server.crt, and server_cert.crt
    # TODO: Display information for each certificate
    # TODO: Verify CA-signed certificate chain
    # TODO: Test self-signed certificate against CA (should fail)
    pass

if __name__ == "__main__":
    main()
```

---

### 🧪 Step 2 — Run Certificate Verification

```bash
chmod +x certificate_verifier.py
python3 certificate_verifier.py
```

| Test | Expected Result |
|---|---|
| CA-signed certificate chain | ✅ Verification succeeds |
| Self-signed vs CA | ❌ Verification fails as expected |
| Certificate details display | ✅ Subject, issuer, validity shown |

---

## ✍️ Task 3 — Digital Signature Implementation

![Task](https://img.shields.io/badge/Task-3%20of%205-4CAF50?style=flat-square)
![File](https://img.shields.io/badge/File-digital__signature__demo.py-607D8B?style=flat-square&logo=python)
![PSS](https://img.shields.io/badge/Padding-RSA--PSS-FF6B6B?style=flat-square)
![SHA256](https://img.shields.io/badge/Hash-SHA256-FF9800?style=flat-square)

### 📝 Step 1 — Create Digital Signature Script

Create **`digital_signature_demo.py`**:

```python
#!/usr/bin/env python3

from cryptography.hazmat.primitives import hashes, serialization
from cryptography.hazmat.primitives.asymmetric import padding
from cryptography.hazmat.backends import default_backend
import base64

def load_private_key(key_path):
    """
    Load RSA private key from PEM file.
    
    Args:
        key_path: Path to private key file
    
    Returns:
        Private key object or None on error
    """
    # TODO: Open and read private key file
    # TODO: Use serialization.load_pem_private_key() with password=None
    # TODO: Handle exceptions
    pass

def create_digital_signature(private_key, message):
    """
    Create digital signature for a message using RSA-PSS.
    
    Args:
        private_key: RSA private key object
        message: String message to sign
    
    Returns:
        Signature bytes or None on error
    """
    # TODO: Convert message to bytes
    # TODO: Create signature using private_key.sign() with PSS padding
    # TODO: Use SHA256 hash algorithm
    # TODO: Return signature bytes
    pass

def verify_digital_signature(public_key, message, signature):
    """
    Verify digital signature for a message.
    
    Args:
        public_key: RSA public key object
        message: Original message string
        signature: Signature bytes to verify
    
    Returns:
        True if signature is valid, False otherwise
    """
    # TODO: Convert message to bytes
    # TODO: Use public_key.verify() with PSS padding and SHA256
    # TODO: Return True on success, False on exception
    pass

def main():
    print("Digital Signature Demonstration")
    print("=" * 40)
    
    # TODO: Load private key from server_private.key
    # TODO: Extract public key from private key
    # TODO: Create message and generate signature
    # TODO: Verify signature with original message
    # TODO: Test with tampered message (should fail)
    # TODO: Display results
    pass

if __name__ == "__main__":
    main()
```

---

### 🧪 Step 2 — Run Digital Signature Demo

```bash
chmod +x digital_signature_demo.py
python3 digital_signature_demo.py
```

| Test | Expected Result |
|---|---|
| Signature creation | ✅ Succeeds |
| Verification with original message | ✅ Valid |
| Verification with tampered message | ❌ Fails as expected |

---

## 📅 Task 4 — Certificate Expiration Monitoring

![Task](https://img.shields.io/badge/Task-4%20of%205-2196F3?style=flat-square)
![File](https://img.shields.io/badge/File-cert__expiration__monitor.py-607D8B?style=flat-square&logo=python)
![Monitor](https://img.shields.io/badge/Feature-Expiry%20Monitoring-FF5722?style=flat-square)

### 📝 Step 1 — Create Expiration Monitor Script

Create **`cert_expiration_monitor.py`**:

```python
#!/usr/bin/env python3

from cryptography import x509
from cryptography.hazmat.backends import default_backend
import datetime
import os

def check_certificate_expiration(cert_path, warning_days=30):
    """
    Check certificate expiration and provide status.
    
    Args:
        cert_path: Path to certificate file
        warning_days: Days before expiration to trigger warning
    
    Returns:
        Dictionary with expiration information or None on error
    """
    # TODO: Load certificate from file
    # TODO: Extract expiry date (not_valid_after)
    # TODO: Calculate days until expiration
    # TODO: Extract subject Common Name
    # TODO: Determine status (EXPIRED, WARNING, OK)
    # TODO: Return dictionary with results
    pass

def main():
    print("Certificate Expiration Monitor")
    print("=" * 40)
    
    # TODO: Find all .crt files in current directory
    # TODO: Check expiration for each certificate
    # TODO: Display summary (total, expired, warning, ok)
    # TODO: List expired and expiring-soon certificates
    pass

if __name__ == "__main__":
    main()
```

---

### 🧪 Step 2 — Run Expiration Monitor

```bash
chmod +x cert_expiration_monitor.py
python3 cert_expiration_monitor.py
```

Expected output includes:

- 📋 All `.crt` files listed with expiration dates
- ⏳ Days remaining until expiry for each
- 🚦 Status indicators: `EXPIRED` / `⚠️ WARNING` / `✅ OK`

---

## 🔗 Task 5 — Multi-Level Certificate Chain

![Task](https://img.shields.io/badge/Task-5%20of%205-9C27B0?style=flat-square)
![File](https://img.shields.io/badge/File-multi__level__verifier.py-607D8B?style=flat-square&logo=python)
![Chain](https://img.shields.io/badge/Chain-Root%20→%20Intermediate%20→%20Entity-4CAF50?style=flat-square)

### 🏛️ Step 1 — Create Intermediate CA

```bash
# Generate intermediate CA key
openssl genrsa -out intermediate_ca.key 2048

# Create intermediate CA CSR
openssl req -new -key intermediate_ca.key -out intermediate_ca.csr
```

Intermediate CA details:

| Field | Value |
|---|---|
| Common Name | `Test Intermediate CA` |
| Organization | `Intermediate CA Organization` |
| Other fields | Use appropriate values |

```bash
# Sign intermediate CA with root CA
openssl x509 -req -days 1825 -in intermediate_ca.csr \
  -CA ca_cert.crt -CAkey ca_private.key \
  -CAcreateserial -out intermediate_ca.crt
```

---

### 📜 Step 2 — Create End-Entity Certificate

```bash
# Generate end-entity key
openssl genrsa -out end_entity.key 2048

# Create end-entity CSR
openssl req -new -key end_entity.key -out end_entity.csr
```

End-entity details:

| Field | Value |
|---|---|
| Common Name | `www.example.com` |
| Organization | `End Entity Organization` |
| Other fields | Use appropriate values |

```bash
# Sign with intermediate CA
openssl x509 -req -days 365 -in end_entity.csr \
  -CA intermediate_ca.crt -CAkey intermediate_ca.key \
  -CAcreateserial -out end_entity.crt

# Verify the complete chain
cat intermediate_ca.crt ca_cert.crt > chain.pem
openssl verify -CAfile chain.pem end_entity.crt
```

### 🔗 Certificate Chain Structure

```
┌─────────────────────────────────────────────────────┐
│              CERTIFICATE CHAIN HIERARCHY             │
├─────────────────────────────────────────────────────┤
│                                                     │
│   🏛️  Root CA (ca_cert.crt)                         │
│        │  4096-bit RSA  |  10 years validity        │
│        │                                            │
│        ▼  signs                                     │
│   🔗  Intermediate CA (intermediate_ca.crt)         │
│        │  2048-bit RSA  |  5 years validity         │
│        │                                            │
│        ▼  signs                                     │
│   🌐  End Entity (end_entity.crt)                   │
│           2048-bit RSA  |  1 year validity          │
│           CN: www.example.com                       │
└─────────────────────────────────────────────────────┘
```

---

### 📝 Step 3 — Create Chain Verification Script

Create **`multi_level_verifier.py`**:

```python
#!/usr/bin/env python3

from cryptography import x509
from cryptography.hazmat.backends import default_backend

def load_certificate(cert_path):
    """Load certificate from file."""
    # TODO: Implement certificate loading
    pass

def verify_chain_link(issuer_cert, subject_cert, level_name):
    """
    Verify one link in certificate chain.
    
    Args:
        issuer_cert: Issuing certificate
        subject_cert: Subject certificate
        level_name: Description for output
    
    Returns:
        True if link is valid, False otherwise
    """
    # TODO: Compare issuer_cert.subject with subject_cert.issuer
    # TODO: Display verification result
    # TODO: Return boolean result
    pass

def main():
    print("Multi-Level Certificate Chain Verification")
    print("=" * 50)
    
    # TODO: Load root CA, intermediate CA, and end-entity certificates
    # TODO: Verify root CA -> intermediate CA link
    # TODO: Verify intermediate CA -> end entity link
    # TODO: Display overall chain validation result
    pass

if __name__ == "__main__":
    main()
```

---

### 🧪 Step 4 — Run Multi-Level Verification

```bash
chmod +x multi_level_verifier.py
python3 multi_level_verifier.py
```

| Chain Link | Expected Result |
|---|---|
| Root CA → Intermediate CA | ✅ Valid |
| Intermediate CA → End Entity | ✅ Valid |
| Overall chain status | ✅ Verified |

---

## ✅ Expected Outcomes

After completing this lab, you should have:

| Achievement | Details | Status |
|---|---|---|
| 📜 Self-signed certificates | Generated using OpenSSL | 📦 Task 1 |
| 🏛️ Certificate Authority | Root CA with 4096-bit key, 10-year validity | 📦 Task 1 |
| 🔗 CA-signed certificates | Server cert signed by your own CA | 📦 Task 1 |
| 🔍 Python cert verification | Chain verification programmatically | 📦 Task 2 |
| ✍️ Digital signatures | RSA-PSS create, verify, tamper detection | 📦 Task 3 |
| 📅 Expiration monitor | Scans all certs with status indicators | 📦 Task 4 |
| 🔗 Multi-level chain | Root → Intermediate → End-entity verified | 📦 Task 5 |

### 📁 Your Directory Should Contain

```
🔑 Private keys      →  *.key files
📜 Certificates      →  *.crt files
📄 CSRs              →  *.csr files
🐍 Python scripts    →  *.py files
📄 Chain bundle      →  chain.pem
```

---

## 🛠️ Troubleshooting

### ❗ `unable to load certificate` error

```bash
# Verify file path and format
file server_cert.crt
openssl x509 -in server_cert.crt -text -noout
```

> ✅ Ensure the certificate is in **PEM format**

---

### ❗ Certificate verification fails

```bash
# Check issuer matches and expiry
openssl x509 -in ca_signed_server.crt -noout -dates
openssl x509 -in ca_signed_server.crt -noout -issuer
openssl x509 -in ca_cert.crt -noout -subject
```

> ✅ Issuer subject must match certificate's issuer field  
> ✅ Certificate must not be expired

---

### ❗ Python cryptography module not found

```bash
pip3 install cryptography
python3 -c "import cryptography; print(cryptography.__version__)"
```

---

### ❗ Permission denied when running scripts

```bash
chmod +x certificate_verifier.py digital_signature_demo.py
chmod +x cert_expiration_monitor.py multi_level_verifier.py
# Or run directly:
python3 script_name.py
```

---

### ❗ Signature verification fails unexpectedly

| Cause | Fix |
|---|---|
| Wrong public key used | Verify key corresponds to the signing private key |
| Message was modified | Compare original and current message byte-for-byte |
| Padding mismatch | Ensure PSS padding used consistently |

---

## 📚 Key Takeaways

> 🔓 **Self-signed certificates** — useful for testing but not trusted by default  
> 🔗 **Certificate chains** — establish trust through a hierarchy  
> ✍️ **Digital signatures** — provide authentication and integrity  
> 📅 **Expiration monitoring** — critical for production systems  
> 🐍 **Python cryptography library** — provides robust PKI functionality  

---

## 🔭 Next Steps

- [ ] 🌐 Explore **Subject Alternative Names** (SAN) extensions
- [ ] 🔒 Study **Key Usage** constraints in certificates
- [ ] 🏗️ Build more complex **certificate hierarchies**
- [ ] 🔐 Investigate **OCSP** and **CRL** for revocation
- [ ] 📱 Learn about **code signing** and identity verification systems

---

## 🧰 Technology Stack

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![OpenSSL](https://img.shields.io/badge/OpenSSL-FF6B6B?style=for-the-badge&logo=openssl&logoColor=white)
![cryptography](https://img.shields.io/badge/cryptography-9C27B0?style=for-the-badge&logo=python&logoColor=white)
![X.509](https://img.shields.io/badge/X.509-Certificates-2196F3?style=for-the-badge&logoColor=white)
![RSA](https://img.shields.io/badge/RSA-PSS%20%7C%20OAEP-4CAF50?style=for-the-badge&logoColor=white)
![SHA256](https://img.shields.io/badge/SHA256-Hashing-FF9800?style=for-the-badge&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![PEM](https://img.shields.io/badge/PEM-Key%20Format-607D8B?style=for-the-badge&logoColor=white)

---

<div align="center">

**Built for the Al Nafi Cybersecurity Lab Program**  
*Continue practising by creating more complex certificate hierarchies and exploring certificate extensions like SAN and Key Usage constraints.*

</div>
