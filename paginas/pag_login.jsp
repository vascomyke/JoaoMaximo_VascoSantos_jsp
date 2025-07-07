<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Login</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
        }
        
        .container {
            width: 330px;
            margin: 0 auto;
            margin-top: 100px;
            background-color: #fff;
            border: 1px solid #ccc;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        
        h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
        }

        form{
            margin:0 20px 0 20px;
            
        }
        
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 3px;
        }
        
        input[type="submit"] {
            width: 106%;
            padding: 10px;
            background-color: #4caf50;
            border: none;
            color: #fff;
            font-weight: bold;
            border-radius: 4px;
            cursor: pointer;
            margin-top: 15px;
        }
        
        input[type="submit"]:hover {
            background-color: #45a049;
        }
        
        .error {
            color: #f44336;
            margin-top: 10px;
        }
    </style>
</head>
<body>
<%
    String user = (String) session.getAttribute("user");

    if (user != null) {
%>
        echo "<script> setTimeout(function () { window.location.href = './pag_utilizador.jsp'; }, 0)</script>";
<%
    }
%>

    <div class="container">
        <h2>Login</h2>
        <form method="POST" action="login.jsp">
            <label for="username">Nome de Utilizador:</label>
            <input type="text" name="user" id="username" required>
            <br>
            <label for="password">Password:</label>
            <input type="password" name="pass" id="password" required>
            <br>
            <input type="submit" name="submit" value="Login">
            <br>
            <p>Não está registado? <a href="pag_registo.jsp">Registe-se aqui!</a></p>
            <div id="voltar">
                <button type="button" onclick="location.href='./pag_principal.jsp'">Voltar</button>
            </div>
            <br>
        </form>
    </div>
</body>
</html>
