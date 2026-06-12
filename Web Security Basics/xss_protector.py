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
