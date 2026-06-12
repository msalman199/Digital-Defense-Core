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
