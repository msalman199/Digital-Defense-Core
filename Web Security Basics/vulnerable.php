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
