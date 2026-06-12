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
