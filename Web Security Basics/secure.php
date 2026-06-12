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
            echo "<p style='color:orange;'>Warning: Malicious content detected and sanitized.</p>";
        }
        
        echo "<h3>Your Comment:</h3>";
        echo "<strong>User:</strong> " . $safe_username . "<br>";
        echo "<strong>Comment:</strong> " . $safe_comment;
    }
    ?>
</body>
</html>
