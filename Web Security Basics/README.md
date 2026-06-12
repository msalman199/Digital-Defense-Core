# 🔐 Web Security Basics 

![Apache](https://img.shields.io/badge/Apache-D22128?style=for-the-badge&logo=apache&logoColor=white)
![OpenSSL](https://img.shields.io/badge/OpenSSL-721412?style=for-the-badge&logo=openssl&logoColor=white)
![PHP](https://img.shields.io/badge/PHP-777BB4?style=for-the-badge&logo=php&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![HTML5](https://img.shields.io/badge/HTML5-E34F26?style=for-the-badge&logo=html5&logoColor=white)
![Security](https://img.shields.io/badge/Security-Lab-red?style=for-the-badge&logo=shield&logoColor=white)

---

## 🎯 Objectives

By the end of this lab, students will be able to:

- 🔒 Configure **SSL/TLS encryption** on an Apache web server
- 📜 Generate and implement **self-signed SSL certificates**
- 🐛 Identify **Cross-Site Scripting (XSS)** vulnerabilities in web applications
- 🔍 Develop **detection mechanisms** for XSS attacks
- 🛡️ Implement **input sanitization and validation** techniques

---

## ✅ Prerequisites

| Requirement | Description |
|---|---|
| 🖥️ Linux CLI | Basic command line proficiency |
| 🌐 HTTP/HTTPS | Understanding of web protocols |
| 🧾 HTML & Scripting | Familiarity with HTML and basic scripting |
| ✏️ Text Editor | Usage of `nano` or `vim` |

---

## 🧪 Lab Environment

> 💡 **Al Nafi** provides pre-configured Linux cloud machines.  
> Click **Start Lab** to access your environment with **Apache**, **PHP**, and **Python** pre-installed.  
> All tasks are performed on a **single machine**.

---

# 📋 Task 1 — Configure SSL/TLS on Apache Web Server

![Apache](https://img.shields.io/badge/Apache-SSL%2FTLS-D22128?style=flat-square&logo=apache&logoColor=white)
![OpenSSL](https://img.shields.io/badge/OpenSSL-Certificate-721412?style=flat-square&logo=openssl&logoColor=white)

---

## 🔧 Step 1 — Install and Enable Apache with SSL

📦 **Update system packages and install Apache:**

```bash
sudo apt update
sudo apt install apache2 -y
```

⚙️ **Enable SSL module and default SSL site:**

```bash
sudo a2enmod ssl
sudo a2ensite default-ssl
sudo systemctl restart apache2
```

🔍 **Verify Apache is running on ports 80 and 443:**

```bash
sudo netstat -tlnp | grep apache2
```

---

## 📜 Step 2 — Generate Self-Signed SSL Certificate

📁 **Create directory for SSL certificates:**

```bash
sudo mkdir -p /etc/apache2/ssl
```

🔑 **Generate private key and certificate (valid for 365 days):**

```bash
sudo openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
-keyout /etc/apache2/ssl/apache-selfsigned.key \
-out /etc/apache2/ssl/apache-selfsigned.crt
```

📝 **When prompted, enter the following details:**

| Field | Value |
|---|---|
| 🌎 Country | `US` |
| 🏛️ State | `California` |
| 🏙️ City | `San Francisco` |
| 🏢 Organization | `Lab Org` |
| 🖥️ Common Name | `localhost` ⚠️ *important!* |
| 📧 Email | `admin@localhost` |

✅ **Verify certificate creation:**

```bash
sudo ls -la /etc/apache2/ssl/
```

---

## ⚙️ Step 3 — Configure Apache SSL Virtual Host

💾 **Backup existing configuration:**

```bash
sudo cp /etc/apache2/sites-available/default-ssl.conf \
        /etc/apache2/sites-available/default-ssl.conf.backup
```

✏️ **Edit SSL configuration:**

```bash
sudo nano /etc/apache2/sites-available/default-ssl.conf
```

📄 **Replace content with:**

```apache
<IfModule mod_ssl.c>
    <VirtualHost _default_:443>
        ServerAdmin webmaster@localhost
        ServerName localhost
        DocumentRoot /var/www/html
        
        ErrorLog ${APACHE_LOG_DIR}/ssl_error.log
        CustomLog ${APACHE_LOG_DIR}/ssl_access.log combined
        
        SSLEngine on
        SSLCertificateFile /etc/apache2/ssl/apache-selfsigned.crt
        SSLCertificateKeyFile /etc/apache2/ssl/apache-selfsigned.key
        
        SSLProtocol all -SSLv2 -SSLv3 -TLSv1 -TLSv1.1
        SSLCipherSuite HIGH:!aNULL:!MD5
        
    </VirtualHost>
</IfModule>
```

🧪 **Test configuration and restart:**

```bash
sudo apache2ctl configtest
sudo systemctl restart apache2
```

---

## 🌐 Step 4 — Test SSL Configuration

📄 **Create a test page:**

```bash
sudo nano /var/www/html/ssl-test.html
```

✍️ **Add content:**

```html
<!DOCTYPE html>
<html>
<head>
    <title>SSL Test</title>
</head>
<body>
    <h1>SSL Configuration Successful</h1>
    <p>This page is served over HTTPS with TLS encryption.</p>
</body>
</html>
```

🔁 **Test HTTPS connection:**

```bash
curl -k https://localhost/ssl-test.html
```

> ℹ️ The `-k` flag ignores self-signed certificate warnings.

---

# 📋 Task 2 — Detect and Prevent XSS Vulnerabilities

![PHP](https://img.shields.io/badge/PHP-XSS%20Lab-777BB4?style=flat-square&logo=php&logoColor=white)
![Python](https://img.shields.io/badge/Python-Detector-3776AB?style=flat-square&logo=python&logoColor=white)
![Security](https://img.shields.io/badge/OWASP-XSS%20Prevention-red?style=flat-square)

---

## 🐛 Step 1 — Create Vulnerable Web Application

📦 **Install PHP support:**

```bash
sudo apt install php libapache2-mod-php -y
sudo systemctl restart apache2
```

📁 **Create lab directory:**

```bash
sudo mkdir -p /var/www/html/xss-lab
```

✏️ **Create vulnerable application:**

```bash
sudo nano /var/www/html/xss-lab/vulnerable.php
```

⚠️ **Add vulnerable code** *(students will exploit this)*:

```php
<!DOCTYPE html>
<html>
<head>
    <title>Vulnerable Comment System</title>
</head>
<body>
    <h1>User Comments (Vulnerable)</h1>
    <form method="POST">
        <label>Username:</label><br>
        <input type="text" name="username" required><br><br>
        <label>Comment:</label><br>
        <textarea name="comment" rows="4" required></textarea><br><br>
        <button type="submit">Submit</button>
    </form>
    
    <?php
    if ($_POST) {
        echo "<h3>Your Comment:</h3>";
        echo "<strong>User:</strong> " . $_POST['username'] . "<br>";
        echo "<strong>Comment:</strong> " . $_POST['comment'];
    }
    ?>
</body>
</html>
```

🌐 **Test the vulnerable application:**

```
http://localhost/xss-lab/vulnerable.php
```

💉 **Try injecting:**

```html
<script>alert('XSS')</script>
```

---

## 🔍 Step 2 — Build XSS Detection Script

📁 **Create security scripts directory:**

```bash
mkdir -p ~/security-scripts
cd ~/security-scripts
```

✏️ **Create XSS detector template:**

```bash
nano xss_detector.py
```

🐍 **Students must complete this implementation:**

```python
#!/usr/bin/env python3
"""
XSS Detection Script
Students: Complete the detection logic
"""

import re
import sys

class XSSDetector:
    def __init__(self):
        # TODO: Define XSS patterns to detect
        # Include: <script>, javascript:, onerror, onclick, etc.
        self.xss_patterns = [
            # TODO: Add regex patterns for common XSS vectors
        ]
    
    def detect_xss(self, input_string):
        """
        Detect potential XSS in input
        
        Args:
            input_string: User input to analyze
        
        Returns:
            tuple: (is_malicious, detected_patterns, risk_level)
        """
        # TODO: Implement detection logic
        # 1. Check input against each pattern
        # 2. Count matches and calculate risk
        # 3. Return results
        pass
    
    def calculate_risk_level(self, matches):
        """
        Calculate risk level based on matches
        
        Args:
            matches: Number of pattern matches
        
        Returns:
            str: Risk level (LOW, MEDIUM, HIGH)
        """
        # TODO: Implement risk calculation
        pass
    
    def log_detection(self, input_string, result):
        """
        Log detection results to file
        
        Args:
            input_string: Original input
            result: Detection result tuple
        """
        # TODO: Write to /tmp/xss_detection.log
        pass

def main():
    detector = XSSDetector()
    
    if len(sys.argv) > 1:
        test_input = sys.argv[1]
        # TODO: Test the input and display results
    else:
        print("Usage: python3 xss_detector.py '<input_to_test>'")

if __name__ == "__main__":
    main()
```

🔐 **Make executable:**

```bash
chmod +x xss_detector.py
```

---

## 🛡️ Step 3 — Implement XSS Protection

✏️ **Create protection script template:**

```bash
nano xss_protector.py
```

🐍 **Students must complete this implementation:**

```python
#!/usr/bin/env python3
"""
XSS Protection and Sanitization
Students: Implement sanitization methods
"""

import html
import re

class XSSProtector:
    def __init__(self):
        # TODO: Define allowed tags and dangerous attributes
        self.allowed_tags = []  # Whitelist approach
        self.dangerous_attrs = []
    
    def html_encode(self, input_string):
        """
        Encode HTML special characters
        
        Args:
            input_string: Raw user input
        
        Returns:
            str: HTML-encoded string
        """
        # TODO: Use html.escape() to encode input
        pass
    
    def remove_dangerous_tags(self, input_string):
        """
        Remove script, iframe, and other dangerous tags
        
        Args:
            input_string: User input with potential HTML
        
        Returns:
            str: Input with dangerous tags removed
        """
        # TODO: Use regex to remove <script>, <iframe>, etc.
        pass
    
    def sanitize_input(self, input_string, method='encode'):
        """
        Sanitize user input using specified method
        
        Args:
            input_string: Raw user input
            method: 'encode', 'strip', or 'whitelist'
        
        Returns:
            str: Sanitized input
        """
        # TODO: Implement three sanitization methods:
        # 1. encode: HTML encode everything
        # 2. strip: Remove dangerous tags/attributes
        # 3. whitelist: Allow only safe tags
        pass
    
    def validate_and_sanitize(self, input_string):
        """
        Validate input and apply sanitization
        
        Args:
            input_string: User input
        
        Returns:
            tuple: (sanitized_input, is_safe, info_dict)
        """
        # TODO: Detect XSS, then sanitize if needed
        pass

def main():
    protector = XSSProtector()
    
    # TODO: Test with various inputs
    test_cases = [
        "Normal text",
        "<script>alert('XSS')</script>",
        "<img src=x onerror=alert(1)>",
        "<b>Bold</b> text"
    ]
    
    # TODO: Test each case with different methods

if __name__ == "__main__":
    main()
```

🔐 **Make executable:**

```bash
chmod +x xss_protector.py
```

---

## 🔒 Step 4 — Create Secure Web Application

✏️ **Create secure version:**

```bash
sudo nano /var/www/html/xss-lab/secure.php
```

🛡️ **Students must complete the sanitization logic:**

```php
<?php
/**
 * Secure Comment System
 * Students: Complete the sanitization functions
 */

function sanitize_input($input, $method = 'encode') {
    /**
     * Sanitize user input
     * 
     * @param string $input User input
     * @param string $method Sanitization method
     * @return string Sanitized input
     */
    
    // TODO: Implement sanitization
    // Method 'encode': Use htmlspecialchars()
    // Method 'strip': Remove dangerous tags with preg_replace()
    
    return $input;  // Replace with sanitized version
}

function detect_xss($input) {
    /**
     * Detect potential XSS patterns
     * 
     * @param string $input User input
     * @return bool True if XSS detected
     */
    
    // TODO: Check for common XSS patterns
    // Use preg_match() with patterns for:
    // - <script> tags
    // - javascript: protocol
    // - Event handlers (onclick, onerror, etc.)
    
    return false;  // Replace with actual detection
}
?>

<!DOCTYPE html>
<html>
<head>
    <title>Secure Comment System</title>
</head>
<body>
    <h1>User Comments (Secure)</h1>
    <form method="POST">
        <label>Username:</label><br>
        <input type="text" name="username" required><br><br>
        <label>Comment:</label><br>
        <textarea name="comment" rows="4" required></textarea><br><br>
        <label>Sanitization Method:</label>
        <select name="method">
            <option value="encode">HTML Encode</option>
            <option value="strip">Strip Tags</option>
        </select><br><br>
        <button type="submit">Submit</button>
    </form>
    
    <?php
    if ($_POST) {
        $username = $_POST['username'] ?? '';
        $comment = $_POST['comment'] ?? '';
        $method = $_POST['method'] ?? 'encode';
        
        // TODO: Students implement detection and sanitization
        $xss_detected = detect_xss($username) || detect_xss($comment);
        $safe_username = sanitize_input($username, $method);
        $safe_comment = sanitize_input($comment, $method);
        
        if ($xss_detected) {
            echo "<p style='color:orange;'>⚠️ Warning: Malicious content detected and sanitized.</p>";
        }
        
        echo "<h3>Your Comment:</h3>";
        echo "<strong>User:</strong> " . $safe_username . "<br>";
        echo "<strong>Comment:</strong> " . $safe_comment;
    }
    ?>
</body>
</html>
```

---

## 🧪 Step 5 — Test XSS Protection

💉 **Test the following XSS payloads on both versions:**

| # | Payload | Type |
|---|---|---|
| 1️⃣ | `<script>alert('XSS')</script>` | Script Tag |
| 2️⃣ | `<img src=x onerror=alert(1)>` | Event Handler |
| 3️⃣ | `<iframe src="javascript:alert('XSS')"></iframe>` | iFrame Injection |
| 4️⃣ | `<svg onload=alert('XSS')>` | SVG Injection |
| 5️⃣ | `javascript:alert(document.cookie)` | Protocol Injection |

🔗 **Compare results between:**

```
http://localhost/xss-lab/vulnerable.php   ❌ Vulnerable
http://localhost/xss-lab/secure.php       ✅ Secure
```

> 📝 Document which payloads succeed and which are blocked.

---

# ✅ Expected Outcomes

After completing this lab, students should have:

- ✅ Working **HTTPS server** with self-signed certificate
- ✅ Functional **XSS detector** that identifies malicious patterns
- ✅ **XSS protection script** with multiple sanitization methods
- ✅ **Secure web application** that prevents XSS attacks
- ✅ Understanding of **input validation** and **output encoding**

---

# 🔧 Troubleshooting Tips

<details>
<summary>🔴 SSL Certificate Issues</summary>

- If certificate errors occur, verify **Common Name** matches hostname
- Check file permissions: `sudo chmod 600 /etc/apache2/ssl/*.key`
- Ensure SSL module is enabled: `sudo a2enmod ssl`

</details>

<details>
<summary>🔴 Apache Not Starting</summary>

- Check configuration syntax: `sudo apache2ctl configtest`
- Review error logs: `sudo tail -f /var/log/apache2/error.log`
- Verify port 443 is not in use: `sudo netstat -tlnp | grep :443`

</details>

<details>
<summary>🔴 PHP Not Working</summary>

- Restart Apache after installing PHP: `sudo systemctl restart apache2`
- Check PHP module: `php -v`
- Verify file permissions in `/var/www/html/`

</details>

<details>
<summary>🔴 XSS Scripts Not Detecting</summary>

- Ensure regex patterns are properly escaped
- Test patterns individually before combining
- Use `re.IGNORECASE` flag for case-insensitive matching

</details>

<details>
<summary>🔴 Python Import Errors</summary>

- Verify both scripts are in the same directory
- Check file permissions: `chmod +x *.py`
- Use absolute imports if needed

</details>

---

# 🎓 Conclusion

This lab covered essential **web security concepts** including **SSL/TLS encryption** and **XSS prevention**. Students configured HTTPS on Apache, generated SSL certificates, and implemented detection and protection mechanisms against Cross-Site Scripting attacks. These skills are fundamental for developing secure web applications.

---

## 💡 Key Takeaways

| # | Takeaway |
|---|---|
| 🔒 | Always use **HTTPS** for sensitive data transmission |
| 🚫 | **Never trust user input** — validate and sanitize everything |
| 🛡️ | Use **multiple layers of defense** (detection + sanitization) |
| 🧹 | **HTML encoding** is the safest approach for untrusted content |
| 🔁 | **Regular security testing** is essential |

---

## 🚀 Next Steps

![CSP](https://img.shields.io/badge/Next-Content%20Security%20Policy-blue?style=flat-square)
![SQL](https://img.shields.io/badge/Next-SQL%20Injection-orange?style=flat-square)
![CSRF](https://img.shields.io/badge/Next-CSRF%20Protection-green?style=flat-square)
![WAF](https://img.shields.io/badge/Next-Web%20App%20Firewall-red?style=flat-square)

- 🔵 Explore **Content Security Policy (CSP)** headers
- 🟠 Study **SQL injection** prevention techniques
- 🟢 Learn about **CSRF protection** mechanisms
- 🔴 Investigate **Web Application Firewalls (WAF)**

---

<div align="center">

![Made with](https://img.shields.io/badge/Made%20with-❤️%20for%20Security-blueviolet?style=for-the-badge)
![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Lab%20Guide-0077B5?style=for-the-badge)

</div>
