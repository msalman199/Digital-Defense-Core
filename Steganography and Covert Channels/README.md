# 🕵️ Steganography and Covert Channels

> A hands-on steganography lab covering LSB encoding, image-based message hiding, password protection, statistical detection, and batch analysis — using Python, Pillow, and NumPy.

![Python](https://img.shields.io/badge/Python-3.8%2B-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Pillow](https://img.shields.io/badge/Pillow-Image%20Processing-FF6B6B?style=for-the-badge&logo=python&logoColor=white)
![NumPy](https://img.shields.io/badge/NumPy-Array%20Operations-013243?style=for-the-badge&logo=numpy&logoColor=white)
![LSB](https://img.shields.io/badge/LSB-Least%20Significant%20Bit-4CAF50?style=for-the-badge&logoColor=white)
![Detection](https://img.shields.io/badge/Detection-Chi--Square%20%7C%20Entropy-FF9800?style=for-the-badge&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-Cloud%20Lab-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![matplotlib](https://img.shields.io/badge/matplotlib-Visualization-9C27B0?style=for-the-badge&logo=python&logoColor=white)

---

## 🎯 Objectives

By the end of this lab, you will be able to:

- ✅ Understand fundamental concepts of **steganography** and **LSB encoding**
- ✅ Implement **image-based steganography** techniques using Python
- ✅ **Hide and extract** text messages within digital images
- ✅ **Analyze images** for potential steganographic content
- ✅ Recognize **security implications** and detection methods for steganography

---

## 📋 Prerequisites

| Requirement | Level |
|---|---|
| 🐍 Python Programming (functions, file I/O, loops) | Basic |
| 🔢 Binary Number Systems and Bitwise Operations | Basic |
| 🖥️ Linux Command Line | Basic |

---

## 🌐 Lab Environment

> **Al Nafi** provides Linux-based cloud machines for this lab.  
> Click **Start Lab** to access your pre-configured environment with Python 3, pip, and necessary libraries pre-installed.

---

## 🗂️ Lab Structure

```
steganography_lab/
├── 🖼️  test_image.png            # Random test image (400×300)
├── 🖼️  blue_image.png            # Solid colour test image
├── 🖼️  hidden.png                # Steganographic output image
├── 🖼️  secure.png                # Password-protected stego image
├── 🖼️  lsb_visualization.png     # LSB layer visual analysis
├── 📄  understanding_lsb.py      # Task 1 — LSB concept demo
├── 📄  steganography_tool.py     # Task 2 — Encoder / decoder
├── 📄  capacity_checker.py       # Task 3 — Capacity calculator
├── 📄  stego_detector.py         # Task 4 — Detection tool
└── 📄  batch_analyzer.py         # Task 4 — Batch analysis
```

---

## 🔬 Task 1 — Understanding LSB Steganography

![Task](https://img.shields.io/badge/Task-1%20of%204-FF5722?style=flat-square)
![File](https://img.shields.io/badge/File-understanding__lsb.py-607D8B?style=flat-square&logo=python)
![Concept](https://img.shields.io/badge/Concept-Bitwise%20Operations-2196F3?style=flat-square)

### 📁 Step 1 — Set Up Working Directory

```bash
mkdir ~/steganography_lab
cd ~/steganography_lab

# Install required Python libraries
pip3 install Pillow numpy matplotlib --user
```

---

### 🖼️ Step 2 — Create Test Images

```bash
python3 << 'EOF'
from PIL import Image
import numpy as np

# Create a random test image
width, height = 400, 300
image_array = np.random.randint(0, 256, (height, width, 3), dtype=np.uint8)
test_image = Image.fromarray(image_array, 'RGB')
test_image.save('test_image.png')

# Create a solid color image
solid_image = Image.new('RGB', (400, 300), color='blue')
solid_image.save('blue_image.png')

print("Test images created successfully!")
EOF
```

---

### 💡 Step 3 — Understand Binary Representation

How LSB steganography works:

```
┌────────────────────────────────────────────────────┐
│              LSB MODIFICATION CONCEPT              │
├────────────────────────────────────────────────────┤
│                                                    │
│  Original pixel:  170  =  1 0 1 0 1 0 1 0         │
│                                   └── LSB          │
│  Message bit to hide:  1                           │
│                                                    │
│  Clear LSB:       170  =  1 0 1 0 1 0 1 0         │
│                       & 0xFE = 1 1 1 1 1 1 1 0    │
│  Set message bit: 171  =  1 0 1 0 1 0 1 1         │
│                                                    │
│  Difference: 1  ← completely imperceptible!        │
│  Extracted bit: 171 & 1 = 1  ✅ Match!            │
└────────────────────────────────────────────────────┘
```

Create and run the demo script:

```bash
cat > understanding_lsb.py << 'EOF'
#!/usr/bin/env python3

def demonstrate_lsb():
    """Demonstrate LSB modification concept"""
    
    # Original pixel value
    original_pixel = 170  # Binary: 10101010
    print(f"Original pixel: {original_pixel} = {format(original_pixel, '08b')}")
    
    # Message bit to hide
    message_bit = 1
    print(f"Message bit to hide: {message_bit}")
    
    # Modify LSB: Clear LSB and set to message bit
    modified_pixel = (original_pixel & 0xFE) | message_bit
    print(f"Modified pixel: {modified_pixel} = {format(modified_pixel, '08b')}")
    print(f"Difference: {abs(original_pixel - modified_pixel)} (imperceptible!)")
    
    # Extract the hidden bit
    extracted_bit = modified_pixel & 1
    print(f"Extracted bit: {extracted_bit}")
    print(f"Match: {extracted_bit == message_bit}")

if __name__ == "__main__":
    demonstrate_lsb()
EOF

python3 understanding_lsb.py
```

---

## 🛠️ Task 2 — Implement Basic Steganography

![Task](https://img.shields.io/badge/Task-2%20of%204-FF9800?style=flat-square)
![File](https://img.shields.io/badge/File-steganography__tool.py-607D8B?style=flat-square&logo=python)
![Method](https://img.shields.io/badge/Method-LSB%20Encoding-4CAF50?style=flat-square)
![Pillow](https://img.shields.io/badge/Library-Pillow%20%7C%20NumPy-FF6B6B?style=flat-square)

### 📝 Step 1 — Create Steganography Encoder/Decoder

```bash
cat > steganography_tool.py << 'EOF'
#!/usr/bin/env python3

from PIL import Image
import numpy as np
import sys

class ImageSteganography:
    def __init__(self):
        self.delimiter = "###END###"
    
    def text_to_binary(self, text):
        """
        Convert text string to binary representation.
        
        Args:
            text: String to convert
        
        Returns:
            Binary string representation
        """
        # TODO: Convert each character to 8-bit binary
        # Hint: Use ord() and format()
        pass
    
    def binary_to_text(self, binary_data):
        """
        Convert binary string back to text.
        
        Args:
            binary_data: Binary string
        
        Returns:
            Decoded text string
        """
        # TODO: Process binary data in 8-bit chunks
        # TODO: Convert each byte to character using chr()
        pass
    
    def hide_message(self, image_path, message, output_path):
        """
        Hide a text message in an image using LSB steganography.
        
        Args:
            image_path: Path to cover image
            message: Text message to hide
            output_path: Path for output image
        
        Returns:
            True if successful, False otherwise
        """
        try:
            # TODO: Open image and convert to RGB
            # TODO: Convert image to numpy array
            # TODO: Prepare message with delimiter
            # TODO: Convert message to binary
            # TODO: Check if image can hold the message
            # TODO: Flatten image array
            # TODO: Modify LSB of each pixel with message bits
            # TODO: Reshape and save modified image
            
            print(f"Message successfully hidden in {output_path}")
            return True
            
        except Exception as e:
            print(f"Error: {str(e)}")
            return False
    
    def extract_message(self, image_path):
        """
        Extract hidden message from steganographic image.
        
        Args:
            image_path: Path to steganographic image
        
        Returns:
            Extracted message or None
        """
        try:
            # TODO: Open image and convert to RGB
            # TODO: Convert to numpy array and flatten
            # TODO: Extract LSB from each pixel value
            # TODO: Convert binary data to text
            # TODO: Find delimiter and extract message
            
            return None
            
        except Exception as e:
            print(f"Error: {str(e)}")
            return None
    
    def compare_images(self, original_path, modified_path):
        """
        Compare original and steganographic images.
        
        Args:
            original_path: Path to original image
            modified_path: Path to modified image
        """
        # TODO: Load both images
        # TODO: Convert to numpy arrays
        # TODO: Calculate pixel differences
        # TODO: Compute statistics (max diff, average diff, count)
        # TODO: Display comparison results
        pass

def main():
    stego = ImageSteganography()
    
    if len(sys.argv) < 2:
        print("Usage:")
        print("  Hide: python3 steganography_tool.py hide <image> <message> <output>")
        print("  Extract: python3 steganography_tool.py extract <image>")
        return
    
    command = sys.argv[1].lower()
    
    if command == "hide" and len(sys.argv) == 5:
        stego.hide_message(sys.argv[2], sys.argv[3], sys.argv[4])
    elif command == "extract" and len(sys.argv) == 3:
        stego.extract_message(sys.argv[2])
    else:
        print("Invalid command or arguments!")

if __name__ == "__main__":
    main()
EOF

chmod +x steganography_tool.py
```

---

### 🧪 Step 2 — Test Your Implementation

```bash
# Hide a message
python3 steganography_tool.py hide test_image.png "Secret message!" hidden.png

# Extract the message
python3 steganography_tool.py extract hidden.png
```

| Test | Expected Result |
|---|---|
| Hide message | ✅ `hidden.png` created successfully |
| Extract message | ✅ `Secret message!` recovered |
| Image comparison | ✅ Difference of max 1 per pixel |

---

### 🖼️ Step 3 — Add Image Comparison

Add this method to your `ImageSteganography` class inside `steganography_tool.py`:

```python
def compare_images(self, original_path, modified_path):
    """
    Compare original and steganographic images.
    
    Args:
        original_path: Path to original image
        modified_path: Path to modified image
    """
    # TODO: Load both images
    # TODO: Convert to numpy arrays
    # TODO: Calculate pixel differences
    # TODO: Compute statistics (max diff, average diff, count)
    # TODO: Display comparison results
    pass
```

---

## 🔐 Task 3 — Advanced Steganography Features

![Task](https://img.shields.io/badge/Task-3%20of%204-4CAF50?style=flat-square)
![File](https://img.shields.io/badge/File-capacity__checker.py-607D8B?style=flat-square&logo=python)
![XOR](https://img.shields.io/badge/Encryption-XOR%20Cipher-FF5722?style=flat-square)
![MD5](https://img.shields.io/badge/Hash-MD5%20Key%20Derivation-2196F3?style=flat-square)

### 📊 Step 1 — Implement Capacity Calculation

```bash
cat > capacity_checker.py << 'EOF'
#!/usr/bin/env python3

from PIL import Image
import sys

def calculate_capacity(image_path):
    """
    Calculate maximum message capacity of an image.
    
    Args:
        image_path: Path to image file
    
    Returns:
        Maximum characters that can be hidden
    """
    # TODO: Open image and get dimensions
    # TODO: Calculate total bits available (width * height * 3)
    # TODO: Account for delimiter overhead
    # TODO: Convert bits to character capacity
    # TODO: Display results
    pass

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 capacity_checker.py <image_path>")
    else:
        calculate_capacity(sys.argv[1])
EOF

chmod +x capacity_checker.py
```

How capacity is calculated:

```
┌──────────────────────────────────────────────────┐
│           IMAGE CAPACITY FORMULA                 │
├──────────────────────────────────────────────────┤
│                                                  │
│  Total pixels  =  width × height                 │
│  Total bits    =  pixels × 3 channels            │
│  Usable bits   =  total bits − delimiter bits    │
│  Max chars     =  usable bits ÷ 8                │
│                                                  │
│  Example (400×300 image):                        │
│  400 × 300 × 3 = 360,000 bits                   │
│  360,000 ÷ 8   = 45,000 characters capacity      │
└──────────────────────────────────────────────────┘
```

---

### 🔒 Step 2 — Add Password Protection

Add these methods to `steganography_tool.py`:

```python
import hashlib
import base64

def encrypt_message(self, message, password):
    """
    Encrypt message using XOR cipher with password.
    
    Args:
        message: Plain text message
        password: Encryption password
    
    Returns:
        Encrypted message (base64 encoded)
    """
    # TODO: Generate key from password using MD5 hash
    # TODO: XOR each character with key
    # TODO: Encode result in base64
    pass

def decrypt_message(self, encrypted_message, password):
    """
    Decrypt XOR encrypted message.
    
    Args:
        encrypted_message: Encrypted message (base64)
        password: Decryption password
    
    Returns:
        Decrypted plain text
    """
    # TODO: Decode base64
    # TODO: Generate same key from password
    # TODO: XOR to decrypt
    pass
```

---

### 🧪 Step 3 — Test Advanced Features

```bash
# Check image capacity
python3 capacity_checker.py test_image.png

# Hide with password (after implementing encryption)
python3 steganography_tool.py hide test_image.png "Secret!" secure.png mypass123

# Extract with password
python3 steganography_tool.py extract secure.png mypass123
```

---

## 🔎 Task 4 — Steganography Detection

![Task](https://img.shields.io/badge/Task-4%20of%204-9C27B0?style=flat-square)
![File](https://img.shields.io/badge/File-stego__detector.py-607D8B?style=flat-square&logo=python)
![ChiSquare](https://img.shields.io/badge/Test-Chi--Square%20(95%25%20CI)-FF6B6B?style=flat-square)
![Entropy](https://img.shields.io/badge/Analysis-Shannon%20Entropy-FF9800?style=flat-square)

### 📝 Step 1 — Implement Chi-Square Test

```bash
cat > stego_detector.py << 'EOF'
#!/usr/bin/env python3

from PIL import Image
import numpy as np
import sys

class SteganographyDetector:
    
    def chi_square_test(self, image_path):
        """
        Perform chi-square test on LSB distribution.
        
        Args:
            image_path: Path to image to analyze
        
        Returns:
            Chi-square value
        """
        # TODO: Load image and extract LSBs
        # TODO: Count 0s and 1s in LSBs
        # TODO: Calculate expected frequency (50/50)
        # TODO: Compute chi-square statistic
        # TODO: Compare to critical value (3.841 for 95% confidence)
        # TODO: Report if suspicious
        pass
    
    def entropy_analysis(self, image_path):
        """
        Calculate entropy of LSB layer.
        
        Args:
            image_path: Path to image
        """
        # TODO: Extract LSBs from image
        # TODO: Calculate Shannon entropy
        # TODO: High entropy (>0.9) suggests hidden data
        pass
    
    def visual_analysis(self, image_path, output_path):
        """
        Create visual representation of LSB layer.
        
        Args:
            image_path: Input image
            output_path: Output visualization
        """
        # TODO: Extract LSB from each color channel
        # TODO: Multiply by 255 to make visible
        # TODO: Save as new image
        # TODO: Patterns indicate hidden data
        pass

def main():
    detector = SteganographyDetector()
    
    if len(sys.argv) != 2:
        print("Usage: python3 stego_detector.py <image_path>")
        return
    
    print("=== Steganography Detection Analysis ===")
    detector.chi_square_test(sys.argv[1])
    detector.entropy_analysis(sys.argv[1])
    detector.visual_analysis(sys.argv[1], "lsb_visualization.png")

if __name__ == "__main__":
    main()
EOF

chmod +x stego_detector.py
```

### 🔬 Detection Thresholds

```
┌─────────────────────────────────────────────────────┐
│            DETECTION METHOD THRESHOLDS              │
├──────────────────┬──────────────────────────────────┤
│  Chi-Square      │  > 3.841  →  🚨 Suspicious       │
│  (95% CI)        │  ≤ 3.841  →  ✅ Clean            │
├──────────────────┼──────────────────────────────────┤
│  Shannon Entropy │  > 0.9    →  🚨 Suspicious       │
│                  │  ≤ 0.9    →  ✅ Clean            │
├──────────────────┼──────────────────────────────────┤
│  Visual LSB      │  Patterns →  🚨 Suspicious       │
│                  │  Noise    →  ✅ Clean            │
└──────────────────┴──────────────────────────────────┘
```

---

### 🧪 Step 2 — Test Detection Tool

```bash
# Analyze clean image
python3 stego_detector.py test_image.png

# Analyze steganographic image
python3 stego_detector.py hidden.png

# Compare results between clean and stego images
```

| Image | Chi-Square | Entropy | Result |
|---|---|---|---|
| `test_image.png` | ≤ 3.841 | ≤ 0.9 | ✅ Clean |
| `hidden.png` | > 3.841 | > 0.9 | 🚨 Suspicious |

---

### 📊 Step 3 — Create Batch Analysis Tool

```bash
cat > batch_analyzer.py << 'EOF'
#!/usr/bin/env python3

import os
import sys

def analyze_directory(directory_path):
    """
    Analyze all images in a directory for steganographic content.
    
    Args:
        directory_path: Path to directory containing images
    """
    # TODO: List all image files in directory
    # TODO: For each image, run quick analysis
    # TODO: Calculate LSB ratio, chi-square, entropy
    # TODO: Assign suspicion score (0-3)
    # TODO: Generate summary report
    pass

if __name__ == "__main__":
    if len(sys.argv) != 2:
        print("Usage: python3 batch_analyzer.py <directory>")
    else:
        analyze_directory(sys.argv[1])
EOF
```

Suspicion scoring system:

| Score | Meaning |
|---|---|
| `0` | ✅ No indicators — clean |
| `1` | 🟡 Low suspicion |
| `2` | 🟠 Moderate suspicion |
| `3` | 🚨 High suspicion — likely stego |

---

## ✅ Expected Outcomes

After completing this lab, you should have:

| Component | Capability | Status |
|---|---|---|
| 🔢 LSB Demo | Binary pixel manipulation visualised | 📦 Task 1 |
| 🖼️ Encoder/Decoder | Hide and extract messages in PNG images | 📦 Task 2 |
| 📊 Capacity Checker | Calculate max characters per image | 📦 Task 3 |
| 🔒 Password Protection | XOR cipher with MD5 key derivation | 📦 Task 3 |
| 🔎 Chi-Square Detector | Statistical LSB distribution test | 📦 Task 4 |
| 🧮 Entropy Analyser | Shannon entropy detection | 📦 Task 4 |
| 👁️ Visual LSB Tool | Render LSB layer as visible image | 📦 Task 4 |
| 📋 Batch Analyser | Scan entire directories for stego content | 📦 Task 4 |

### 🔬 Key Technical Summary

```
🖼️  LSB steganography    →  modifies least significant bit of each pixel
👁️  Imperceptibility     →  max pixel difference of 1 — invisible to humans
📦  Capacity             →  width × height × 3 ÷ 8 characters
🔒  XOR encryption       →  adds password layer before embedding
📊  Chi-square test      →  detects unnatural 50/50 LSB distribution
🧮  Shannon entropy      →  high entropy (>0.9) flags hidden data
```

---

## 🛠️ Troubleshooting

### ❗ `Message too long for image`

```bash
# Check capacity first
python3 capacity_checker.py test_image.png
```

> ✅ Use a **larger image** or a **shorter message**

---

### ❗ Extracted message is garbled

| Cause | Fix |
|---|---|
| Delimiter missing or wrong | Verify `###END###` is appended before encoding |
| Wrong bit count on extract | Ensure read length matches write length |
| Image re-compressed (JPEG) | Always use **PNG** — JPEG loses LSB data |

---

### ❗ Password decryption fails

> ✅ Verify **exact same password** for encryption and decryption (case-sensitive)  
> ✅ Check base64 encoding/decoding is applied symmetrically

---

### ❗ PIL/Pillow import errors

```bash
pip3 install --upgrade Pillow --user
python3 -c "from PIL import Image; print('Pillow OK')"
```

---

### ❗ Detection tool shows false positives

> ⚠️ Natural images may have unusual LSB distributions  
> ✅ Always use **multiple detection methods** together for confirmation  
> ✅ Compare results between a known-clean and suspected image side by side

---

## 📚 Key Takeaways

> 🔢 **LSB steganography** modifies the least significant bit of pixel values  
> 👁️ **Changes are imperceptible** to the human eye but detectable statistically  
> 🔒 **Encryption adds security** — without it, anyone can extract the message  
> 📊 **Chi-square and entropy tests** are standard steganalysis techniques  
> 🚫 **JPEG images destroy LSB data** — always use lossless formats like PNG  
> 🔍 **Multiple detection methods** reduce false positives and negatives  

---

## 🔭 Next Steps

- [ ] 🎵 Explore **audio steganography** using WAV file LSB encoding
- [ ] 📄 Investigate **document steganography** (whitespace, font size tricks)
- [ ] 🧠 Study **deep learning-based** steganalysis detection
- [ ] 🔐 Implement **DCT-domain steganography** (JPEG-resistant)
- [ ] 🌐 Research **network covert channels** and timing-based steganography

---

## 🧰 Technology Stack

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Pillow](https://img.shields.io/badge/Pillow-FF6B6B?style=for-the-badge&logo=python&logoColor=white)
![NumPy](https://img.shields.io/badge/NumPy-013243?style=for-the-badge&logo=numpy&logoColor=white)
![matplotlib](https://img.shields.io/badge/matplotlib-9C27B0?style=for-the-badge&logo=python&logoColor=white)
![LSB](https://img.shields.io/badge/LSB%20Encoding-Steganography-4CAF50?style=for-the-badge&logoColor=white)
![XOR](https://img.shields.io/badge/XOR%20Cipher-Encryption-FF9800?style=for-the-badge&logoColor=white)
![ChiSquare](https://img.shields.io/badge/Chi--Square-Statistical%20Test-2196F3?style=for-the-badge&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)

---

<div align="center">

**Built for the Al Nafi Cybersecurity Lab Program**  
*Understanding both creation and detection of steganographic content is essential for cybersecurity professionals.*

</div>
