#!/usr/bin/env python3
import http.server
import socketserver
import threading
import time

class SuspiciousHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        print(f"Suspicious access from {self.client_address[0]} at {time.ctime()}")
        super().do_GET()

PORT = 8080
Handler = SuspiciousHandler

with socketserver.TCPServer(("", PORT), Handler) as httpd:
    print(f"Suspicious server running on port {PORT}")
    httpd.serve_forever()
