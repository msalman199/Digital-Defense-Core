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
