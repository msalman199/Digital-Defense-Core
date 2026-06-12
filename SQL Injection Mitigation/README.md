# 💉 SQL Injection Mitigation 

![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)
![Flask](https://img.shields.io/badge/Flask-000000?style=for-the-badge&logo=flask&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-003B57?style=for-the-badge&logo=sqlite&logoColor=white)
![Linux](https://img.shields.io/badge/Linux-FCC624?style=for-the-badge&logo=linux&logoColor=black)
![Security](https://img.shields.io/badge/OWASP-SQL%20Injection-red?style=for-the-badge&logo=owasp&logoColor=white)
![HTTP](https://img.shields.io/badge/HTTP-Requests-blue?style=for-the-badge&logo=curl&logoColor=white)

---

## 🎯 Objectives

By the end of this lab, students will be able to:

- 🔍 **Identify** SQL injection vulnerabilities in web applications
- 💡 **Understand** how SQL injection attacks exploit insecure database queries
- 🛡️ **Implement** parameterized queries to prevent SQL injection
- ✅ **Apply** input validation and secure coding practices
- 🧪 **Test** applications for SQL injection vulnerabilities

---

## ✅ Prerequisites

| Requirement | Description |
|---|---|
| 🐍 Python | Basic Python programming knowledge |
| 🗄️ SQL | Understanding of SQL operations (`SELECT`, `INSERT`, `UPDATE`) |
| 🌐 HTTP | Familiarity with HTTP requests and web forms |
| 🖥️ Linux CLI | Basic Linux command line skills |

---

## 🧪 Lab Environment

> 💡 **Al Nafi** provides Linux-based cloud machines for this lab.  
> Click **Start Lab** to access your pre-configured environment with **Python 3**, **Flask**, and **SQLite** pre-installed.

---

# 📋 Task 1 — Understanding SQL Injection Vulnerabilities

![Flask](https://img.shields.io/badge/Flask-Vulnerable%20App-000000?style=flat-square&logo=flask&logoColor=white)
![SQLite](https://img.shields.io/badge/SQLite-Database-003B57?style=flat-square&logo=sqlite&logoColor=white)

---

## 📁 Step 1 — Create Project Directory

```bash
mkdir ~/sqli_lab
cd ~/sqli_lab
```

---

## 📦 Step 2 — Install Required Dependencies

```bash
pip3 install flask requests
```

---

## ⚠️ Step 3 — Create a Vulnerable Application

✏️ **Create `vulnerable_app.py`** with the following starter code:

```python
#!/usr/bin/env python3
from flask import Flask, request, render_template_string
import sqlite3

app = Flask(__name__)

def init_db():
    '''Initialize database with sample users'''
    conn = sqlite3.connect('users.db')
    cursor = conn.cursor()
    
    # TODO: Create users table with id, username, password, email columns
    # TODO: Insert sample users (admin/admin123, john/pass123, jane/secret456)
    # TODO: Commit and close connection
    pass

@app.route('/')
def home():
    '''Display login and search forms'''
    return render_template_string('''
    <html>
    <body>
        <h2>Vulnerable Login System</h2>
        <form method="POST" action="/login">
            Username: <input type="text" name="username"><br>
            Password: <input type="password" name="password"><br>
            <input type="submit" value="Login">
        </form>
        <hr>
        <h3>Search Users</h3>
        <form method="GET" action="/search">
            Search: <input type="text" name="query">
            <input type="submit" value="Search">
        </form>
    </body>
    </html>
    ''')

@app.route('/login', methods=['POST'])
def vulnerable_login():
    '''VULNERABLE: Uses string concatenation for SQL query'''
    username = request.form['username']
    password = request.form['password']
    
    # TODO: Create SQL query using f-string (VULNERABLE METHOD)
    # Example: f"SELECT * FROM users WHERE username = '{username}' AND password = '{password}'"
    # TODO: Execute query and fetch result
    # TODO: Return success or failure message with query displayed
    pass

@app.route('/search')
def vulnerable_search():
    '''VULNERABLE: Uses string concatenation for search'''
    query_param = request.args.get('query', '')
    
    # TODO: Create SQL query with LIKE operator using string concatenation
    # TODO: Execute query and display results
    # TODO: Show the executed query in the response
    pass

if __name__ == '__main__':
    init_db()
    app.run(host='0.0.0.0', port=5000, debug=True)
```

---

## ▶️ Step 4 — Complete and Run the Vulnerable Application

✅ Complete the `TODO` sections in `vulnerable_app.py`, then run:

```bash
python3 vulnerable_app.py &
```

🌐 **Access the application at:** `http://localhost:5000`

---

## 💉 Step 5 — Test SQL Injection Manually

**🔐 Try these payloads in the login form:**

| # | Username | Password |
|---|---|---|
| 1️⃣ | `admin'--` | `anything` |
| 2️⃣ | `' OR '1'='1` | `' OR '1'='1` |
| 3️⃣ | `admin'; DROP TABLE users;--` | `test` |

**🔎 Try these in the search form:**

```
' OR 1=1--
' UNION SELECT username,password,email FROM users--
```

> ❓ **Question:** What happens when you use these payloads? Why do they work?

---

# 📋 Task 2 — Automated SQL Injection Detection

![Python](https://img.shields.io/badge/Python-Scanner-3776AB?style=flat-square&logo=python&logoColor=white)
![Security](https://img.shields.io/badge/Automated-Detection-orange?style=flat-square)

---

## 🤖 Step 1 — Create Detection Script

✏️ **Create `sqli_detector.py`:**

```python
#!/usr/bin/env python3
import requests
import time

class SQLiDetector:
    def __init__(self, base_url):
        self.base_url = base_url
        self.vulnerabilities = []
    
    def test_error_based_sqli(self, url, params, method='GET'):
        '''Test for error-based SQL injection'''
        print(f"Testing error-based SQLi on: {url}")
        
        error_payloads = [
            "'",
            "' OR '1'='1",
            "' OR 1=1--",
            "admin'--",
            "'; DROP TABLE users;--"
        ]
        
        # TODO: Loop through each payload
        # TODO: Test each parameter with the payload
        # TODO: Check response for SQL error indicators:
        #       - 'sqlite3.OperationalError'
        #       - 'SQL syntax error'
        #       - 'database error'
        # TODO: Store vulnerabilities found
        # TODO: Add 0.5 second delay between requests
        pass
    
    def test_union_based_sqli(self, url, params, method='GET'):
        '''Test for UNION-based SQL injection'''
        print(f"Testing UNION-based SQLi on: {url}")
        
        union_payloads = [
            "' UNION SELECT 1,2,3--",
            "' UNION SELECT username,password,email FROM users--",
            "' UNION SELECT sqlite_version(),2,3--"
        ]
        
        # TODO: Test each UNION payload
        # TODO: Check if data from other tables appears in response
        # TODO: Look for indicators like email addresses or version strings
        pass
    
    def test_boolean_based_sqli(self, url, params, method='GET'):
        '''Test for boolean-based blind SQL injection'''
        print(f"Testing boolean-based SQLi on: {url}")
        
        # TODO: Get baseline response length
        # TODO: Test true condition:  ' AND '1'='1
        # TODO: Test false condition: ' AND '1'='2
        # TODO: Compare response lengths to detect vulnerability
        pass
    
    def run_full_scan(self):
        '''Run comprehensive SQL injection scan'''
        print("="*60)
        print("SQL INJECTION VULNERABILITY SCANNER")
        print("="*60)
        
        # TODO: Define endpoints to test (login and search)
        # TODO: Run all three test methods on each endpoint
        # TODO: Generate and display report
        pass
    
    def generate_report(self):
        '''Generate vulnerability report'''
        # TODO: Display all vulnerabilities found
        # TODO: Save report to sqli_report.txt
        # TODO: Include URL, parameter, payload, and evidence for each
        pass

def main():
    base_url = "http://localhost:5000"
    
    # TODO: Check if application is running
    # TODO: Create detector instance and run scan
    pass

if __name__ == "__main__":
    main()
```

---

## ▶️ Step 2 — Complete and Run the Scanner

✅ Complete the `TODO` sections, then run:

```bash
python3 sqli_detector.py
```

---

## 📊 Step 3 — Analyze Results

```bash
cat sqli_report.txt
```

> ❓ **Question:** How many vulnerabilities were detected? What types?

---

# 📋 Task 3 — Implementing Secure Parameterized Queries

![Security](https://img.shields.io/badge/Parameterized-Queries-brightgreen?style=flat-square)
![Flask](https://img.shields.io/badge/Flask-Secure%20App-000000?style=flat-square&logo=flask&logoColor=white)
![Hash](https://img.shields.io/badge/SHA256-Password%20Hashing-blueviolet?style=flat-square)

---

## 🔒 Step 1 — Create Secure Application

✏️ **Create `secure_app.py`:**

```python
#!/usr/bin/env python3
from flask import Flask, request, render_template_string
import sqlite3
import hashlib

app = Flask(__name__)

def init_secure_db():
    '''Initialize database with hashed passwords'''
    conn = sqlite3.connect('secure_users.db')
    cursor = conn.cursor()
    
    # TODO: Create users table with password_hash instead of password
    # TODO: Hash passwords using hashlib.sha256
    # TODO: Insert sample users with hashed passwords
    pass

def validate_input(input_string, max_length=50):
    '''Validate and sanitize user input'''
    # TODO: Check if input is empty or too long
    # TODO: Check for dangerous characters: ', ", ;, --, /*, */
    # TODO: Return True if valid, False otherwise
    pass

@app.route('/')
def home():
    '''Display secure login and search forms'''
    return render_template_string('''
    <html>
    <body>
        <h2>Secure Login System</h2>
        <form method="POST" action="/login">
            Username: <input type="text" name="username" maxlength="50"><br>
            Password: <input type="password" name="password" maxlength="50"><br>
            <input type="submit" value="Login">
        </form>
        <hr>
        <h3>Search Users</h3>
        <form method="GET" action="/search">
            Search: <input type="text" name="query" maxlength="50">
            <input type="submit" value="Search">
        </form>
        <hr>
        <p><strong>Security Features:</strong></p>
        <ul>
            <li>Parameterized queries</li>
            <li>Password hashing</li>
            <li>Input validation</li>
        </ul>
    </body>
    </html>
    ''')

@app.route('/login', methods=['POST'])
def secure_login():
    '''SECURE: Uses parameterized queries'''
    username = request.form.get('username', '').strip()
    password = request.form.get('password', '').strip()
    
    # TODO: Validate input using validate_input()
    # TODO: Hash the password
    # TODO: Create parameterized query:
    #       query = "SELECT id, username, email FROM users WHERE username = ? AND password_hash = ?"
    # TODO: Execute with parameters: cursor.execute(query, (username, password_hash))
    # TODO: Return success/failure WITHOUT revealing database errors
    pass

@app.route('/search')
def secure_search():
    '''SECURE: Uses parameterized queries for search'''
    query_param = request.args.get('query', '').strip()
    
    # TODO: Validate input
    # TODO: Create parameterized query with LIKE:
    #       query = "SELECT username, email FROM users WHERE username LIKE ?"
    # TODO: Execute with parameter: cursor.execute(query, (f"%{query_param}%",))
    # TODO: Display results without revealing errors
    pass

@app.route('/register', methods=['GET', 'POST'])
def register():
    '''Secure user registration'''
    if request.method == 'GET':
        # TODO: Display registration form
        pass
    
    # TODO: Get and validate username, password, email
    # TODO: Hash password
    # TODO: Use parameterized INSERT query
    # TODO: Handle duplicate username error gracefully
    pass

if __name__ == '__main__':
    init_secure_db()
    app.run(host='0.0.0.0', port=5001, debug=False)
```

---

## ▶️ Step 2 — Complete and Run Secure Application

🛑 **Stop the vulnerable application:**

```bash
pkill -f vulnerable_app.py
```

✅ Complete the `TODO` sections in `secure_app.py`, then run:

```bash
python3 secure_app.py &
```

🌐 **Access at:** `http://localhost:5001`

---

## 🧪 Step 3 — Test Secure Application

✏️ **Create `test_secure_app.py`:**

```python
#!/usr/bin/env python3
import requests

def test_secure_application():
    base_url = "http://localhost:5001"
    
    print("Testing Secure Application")
    print("="*50)
    
    # Test 1: Normal functionality
    print("\n1. Testing Normal Login")
    # TODO: Test login with valid credentials
    # TODO: Verify success message appears
    
    print("\n2. Testing Normal Search")
    # TODO: Test search with valid query
    # TODO: Verify results appear
    
    # Test 3: SQL Injection attempts
    print("\n3. Testing SQL Injection Protection")
    sqli_payloads = [
        "admin'--",
        "' OR '1'='1",
        "'; DROP TABLE users;--",
        "' UNION SELECT 1,2,3--"
    ]
    
    # TODO: Test each payload against login
    # TODO: Test each payload against search
    # TODO: Verify all attempts are blocked
    # TODO: Count successful blocks
    
    print("\n4. Testing Registration")
    # TODO: Register new user with normal data
    # TODO: Try to register with SQL injection payload
    # TODO: Verify injection is blocked

if __name__ == "__main__":
    test_secure_application()
```

✅ **Complete and run:**

```bash
python3 test_secure_app.py
```

---

## 🔁 Step 4 — Compare Vulnerable vs Secure

🔍 **Run the detector against the secure application:**

```python
# Modify sqli_detector.py to test port 5001
detector = SQLiDetector("http://localhost:5001")
detector.run_full_scan()
```

> ❓ **Question:** How many vulnerabilities are detected in the secure version?

---

# 📋 Task 4 — Understanding Parameterized Queries

![Concept](https://img.shields.io/badge/Key-Concepts-informational?style=flat-square)
![SQLite](https://img.shields.io/badge/SQLite-Parameterized-003B57?style=flat-square&logo=sqlite&logoColor=white)

---

## ❌ Vulnerable Code — String Concatenation

> ⚠️ **NEVER DO THIS**

```python
# NEVER DO THIS
query = f"SELECT * FROM users WHERE username = '{username}'"
cursor.execute(query)
```

---

## ✅ Secure Code — Parameterized Query

> 🛡️ **ALWAYS DO THIS**

```python
# ALWAYS DO THIS
query = "SELECT * FROM users WHERE username = ?"
cursor.execute(query, (username,))
```

---

## 💡 Why Parameterized Queries Work

| # | Reason |
|---|---|
| 🔒 | Database treats parameters as **data**, not executable code |
| 🧹 | Special characters are **automatically escaped** |
| 🧱 | SQL structure is **separated** from user input |
| 🚫 | Prevents **all types** of SQL injection |

---

## 🛡️ Additional Security Measures

| Measure | Description |
|---|---|
| ✅ Input Validation | Check length, format, and dangerous characters |
| 🔑 Password Hashing | Never store plaintext passwords |
| 🔇 Error Handling | Don't reveal database structure in error messages |
| 🔐 Least Privilege | Database user should have minimal permissions |
| 📝 Prepared Statements | Pre-compile queries when possible |

---

# ✅ Expected Outcomes

After completing this lab, you should have:

- ✅ A **vulnerable application** that demonstrates SQL injection
- ✅ A **detection script** that identifies multiple SQL injection types
- ✅ A **secure application** using parameterized queries
- ✅ **Test scripts** proving the secure application blocks injection attempts
- ✅ Understanding of **why parameterized queries** prevent SQL injection

---

## 📝 Verification Checklist

- [ ] 🐛 Vulnerable app allows SQL injection login bypass
- [ ] 🔍 Scanner detects error-based, boolean-based, and UNION-based SQLi
- [ ] 🛡️ Secure app blocks all SQL injection attempts
- [ ] ⚙️ Secure app maintains normal functionality
- [ ] 🧪 Test script confirms security improvements

---

# 🔧 Troubleshooting Tips

<details>
<summary>🔴 Application won't start — "Address already in use"</summary>

Kill the existing process:

```bash
pkill -f vulnerable_app.py
# or
pkill -f secure_app.py
```

</details>

<details>
<summary>🔴 Scanner reports no vulnerabilities on vulnerable app</summary>

- Verify app is running: `curl http://localhost:5000`
- Check if database was initialized properly
- Ensure error messages are displayed in app responses

</details>

<details>
<summary>🔴 Parameterized query syntax error</summary>

- Use `?` placeholders, **not** `%s`
- Pass parameters as tuple: `(param,)` not just `param`
- For **SQLite** use `?`; for **MySQL/PostgreSQL** use `%s`

</details>

<details>
<summary>🔴 Input validation too strict</summary>

- Balance security with usability
- Allow alphanumeric and common special characters
- Block only SQL-specific dangerous patterns

</details>

---

# 🎓 Conclusion

SQL injection remains one of the most critical web application vulnerabilities. This lab demonstrated:

- 💥 How SQL injection exploits **string concatenation** in queries
- 🔍 Multiple **detection techniques** for identifying vulnerabilities
- 🛡️ **Parameterized queries** as the primary defense mechanism
- 🔐 Additional security layers including **input validation** and **password hashing**

---

## 💡 Key Takeaways

| # | Takeaway |
|---|---|
| 🛡️ | Always use **parameterized queries** for database operations |
| 🚫 | **Never trust user input** — validate and sanitize everything |
| 🧱 | Implement **defense in depth** with multiple security layers |
| 🧪 | **Test applications** for vulnerabilities before deployment |

---

## 🏆 Best Practices

| Practice | Description |
|---|---|
| 🔧 ORM Frameworks | Use ORMs that handle parameterization automatically |
| 📝 Prepared Statements | Implement for repeated queries |
| 🔐 Least Privilege | Apply principle of least privilege to DB accounts |
| 📋 Security Logging | Log security events for monitoring and incident response |
| 🔄 Keep Updated | Maintain frameworks and libraries with security patches |

---

## 🚀 Next Steps

![CSP](https://img.shields.io/badge/Next-CSRF%20Protection-blue?style=flat-square)
![XSS](https://img.shields.io/badge/Next-XSS%20Prevention-orange?style=flat-square)
![WAF](https://img.shields.io/badge/Next-Web%20App%20Firewall-red?style=flat-square)
![ORM](https://img.shields.io/badge/Next-ORM%20Frameworks-green?style=flat-square)

- 🔵 Learn about **CSRF protection** mechanisms
- 🟠 Explore **XSS prevention** techniques
- 🔴 Investigate **Web Application Firewalls (WAF)**
- 🟢 Practice with **ORM frameworks** (SQLAlchemy, Django ORM)

---

<div align="center">

![Made with](https://img.shields.io/badge/Made%20with-❤️%20for%20Security-blueviolet?style=for-the-badge)
![Al Nafi](https://img.shields.io/badge/Al%20Nafi-Lab%20Guide-0077B5?style=for-the-badge)

</div>
