<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <title>Registo</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
        }
        
        .container {
            width: 330px;
            margin: 0 auto;
            margin-top: 50px;
            background-color: #fff;
            border: 1px solid #ccc;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
        }
        
        h1 {
            text-align: center;
            margin-bottom: 20px;
        }

        form {
            margin: 0 20px 0 20px;
        }
        
        label {
            display: block;
            margin-bottom: 8px;
        }
        
        input[type="text"],
        input[type="password"] {
            width: 100%;
            padding: 8px;
            border: 1px solid #ccc;
            border-radius: 3px;
        }
        
        input[type="submit"] {
            width: 100%;
            padding: 10px;
            background-color: #4caf50;
            border: none;
            color: #fff;
            font-weight: bold;
            border-radius: 3px;
            cursor: pointer;
            margin-top: 15px;
        }
        
        input[type="submit"]:hover {
            background-color: #45a049;
        }
        
        .success {
            color: #4caf50;
            margin-top: 10px;
            text-align: center;
        }
        
        .error {
            color: #f44336;
            margin-top: 10px;
            text-align: center;
        }
    </style>
</head>
<body>
    <%
        String user = (String) session.getAttribute("user");

        if (user != null) {
            if (user.equals("admin")) {
                
    %>
        <script>alert("Criar novo utilizador");</script>

        <div class="container">
            <h1>Registo de Utilizador</h1>
            <form action="novo_registo.jsp" method="post" >
                <label>Nome do utilizador:</label>
                <input type="text" name="user" required><br><br>
                <label>Password:</label>
                <input type="password" name="pass" required><br><br>
                <label>Telemóvel:</label>
                <input type="contact" name="contacto" required><br><br>
                <label>E-mail:</label>
                <input type="email" name="email" required><br><br>
                <input type="submit" name="register" value="Registar novo utilizador" required>
            </form>
            <br>
            <br><div id="volta"><a href="./pag_principal.jsp">Página Principal</a></div>
        </div>
        <%
            } else {
        %>
                <script> setTimeout(function () { window.location.href = './pag_utilizador.jsp'; }, 0)</script>
        <%
            }
        } else {
        %>

        <div class="container">
            <h1>Registo de Utilizador</h1>
            <form action="novo_registo.jsp" method="post" >
                <label>Nome do utilizador:</label>
                <input type="text" name="user" required><br><br>
                <label>Password:</label>
                <input type="password" name="pass" required><br><br>
                <label>Telemóvel:</label>
                <input type="contact" name="contacto" required><br><br>
                <label>E-mail:</label>
                <input type="email" name="email" required><br><br>
                <input type="submit" name="register" value="Registar" required>
            </form>
            <br>
        
        
        <!--=====================Registo=====================-->
            <div id="acoes">
                <div><a href="./pag_login.jsp">Já tem conta? Login</a></div>
                <br><div id="volta"><a href="./pag_principal.jsp">Página Principal</a></div>
            </div>
        </div>
        
        <%
        }
    %>
</body>
</html>
