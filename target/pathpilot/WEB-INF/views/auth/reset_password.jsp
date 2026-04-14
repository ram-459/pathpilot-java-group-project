<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Reset Password</title>

<style>
    body {
        font-family: Arial;
        background: #f4f4f4;
        display: flex;
        justify-content: center;
        align-items: center;
        height: 100vh;
    }

    .box {
        background: white;
        padding: 30px;
        border-radius: 10px;
        width: 350px;
        box-shadow: 0 0 10px rgba(0,0,0,0.2);
    }

    input {
        width: 100%;
        padding: 10px;
        margin: 10px 0;
    }

    button {
        width: 100%;
        padding: 10px;
        background: #007bff;
        color: white;
        border: none;
    }

    .msg { color: green; }
    .error { color: red; }
</style>

</head>
<body>

<div class="box">
    <h2>Reset Password</h2>

    <!-- SUCCESS / ERROR -->
    <p class="msg">${msg}</p>
    <p class="error">${error}</p>

    <!-- FORM -->
    <form action="${pageContext.request.contextPath}/reset-password" method="post">
        
        <!-- 🔥 IMPORTANT: TOKEN HIDDEN -->
        <input type="hidden" name="token" value="${token}" />

        <input type="password" name="password" placeholder="Enter new password" required />

        <button type="submit">Update Password</button>
    </form>
</div>

</body>
</html>