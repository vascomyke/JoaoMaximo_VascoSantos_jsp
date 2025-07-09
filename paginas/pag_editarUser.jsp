<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest " %>
<%@ include file="../basedados/basedados.h"%>
<!DOCTYPE html>
<html>
<head>
    <title>Editar</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
        }
        
        .container {
            width: 300px;
            margin: 0 auto;
            margin-top: 50px;
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
        
        .data-label {
            font-weight: bold;
        }
        
        .data-value {
            margin-bottom: 15px;
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
        margin: 15px 0 0 0;
    }

    input[type="submit"]:hover {
        background-color: #45a049;
    }
    </style>
</head>
<body>
    <div class="container">
        <h2>Dados Pessoais</h2>
        
        <%
        
        Statement conexao = null;
        ResultSet session_rs = null;
        ResultSet user_rs = null;


        String idUser = "";
        String session_user = (String) session.getAttribute("user");

        if (session_user == null){
            out.println(" <script> alert ('Autentique-se Primeiro!') </script>");
            out.println("<script>  setTimeout(function () { window.location.href = './logout.jsp'; }, 0)</script>");
        }

        String tipoUtilizador = "";
        String sql = "SELECT * FROM user WHERE nomeUtilizador = '" + session_user + "'";
        
        // Execute the query
        conexao = conn.createStatement();
        session_rs = conexao.executeQuery(sql);

        // Retrieve tipoUtilizador
        if (session_rs.next()) {
            tipoUtilizador = session_rs.getString("tipoUtilizador");
        }

        if (tipoUtilizador.equals("admin") && request.getMethod().equals("POST")){
             idUser = request.getParameter("IdUser");
             
             String sql2 = "SELECT * FROM user WHERE nomeUtilizador = '" + idUser + "'";
             
             conexao = conn.createStatement();
             user_rs = conexao.executeQuery(sql2);
             if (user_rs.next()) {
                 %>
                 Nome de Utilizador: <%= user_rs.getString("nomeUtilizador") %><br><br>
                 E-mail: <%= user_rs.getString("email") %><br><br>
                 Telemóvel: <%= user_rs.getString("telemovel") %><br>
                 <%
                }
                %>
                
                <form action="editar.jsp" method="post">
                    <h2>Editar Utilizador</h2>
                    <p>Deixar em branco para não alterar!</p>
                    <input type="hidden" name="IdUser" value="<%= user_rs.getString("nomeUtilizador") %>">
                    <label>Nome do utilizador:</label>
                    <input type="text" name="nomeNovo" value="<%= user_rs.getString("nomeUtilizador") %>"><br><br>
                    <label>Password:</label>
                    <input type="password" name="passNova" ><br><br>
                    <label>Telemóvel:</label>
                    <input type="contact" name="contactonovo" value="<%= user_rs.getString("telemovel") %>"><br><br>
                    <label>E-mail:</label>
                    <input type="email" name="emailnovo" value="<%= user_rs.getString("email") %>"><br><br>
                    <input type="submit" name="eliminar" value="Eliminar Utilizador" style="background-color: #e74c3c;"><br>
                    <input type="submit" name="editar" value="Editar">
                    <!--=====================Registo=====================-->
                    <div id="acoes">
                        <div><a href="./pag_gestUtilizadores.jsp">Cancelar</a></div>
                    </div>
                </form>
                
                <%
                
            } else {
             idUser = session_user;
            }
            
        if ( tipoUtilizador.equals("funcionario") || tipoUtilizador.equals("cliente") ) {
            //if (session_rs.next()) {
                %>
                Nome de Utilizador: <%= session_rs.getString("nomeUtilizador") %><br><br>
                E-mail: <%= session_rs.getString("email") %><br><br>
                Telemóvel: <%= session_rs.getString("telemovel") %><br>
                <%
            //}
        
        %>

            <form action="editar.jsp" method="post">
                <h2>Editar Utilizador</h2>
                <p>Deixar em branco para não alterar!</p>
                <input type="hidden" name="IdUser" value="<%= session_user %>">
                <label>Nome do utilizador:</label>
                <input type="text" name="nomeNovo" value="<%= session_user %>"><br><br>
                <label>Password:</label>
                <input type="password" name="passNova" ><br><br>
                <label>Telemóvel:</label>
                <input type="contact" name="contactonovo" value="<%= session_rs.getString("telemovel") %>"><br><br>
                <label>E-mail:</label>
                <input type="email" name="emailnovo" value="<%= session_rs.getString("email") %>"><br><br>
                <input type="submit" name="eliminar" value="Eliminar Utilizador" style="background-color: #e74c3c;"><br>
                <input type="submit" name="editar" value="Editar">
                <!--=====================Registo=====================-->
                <div id="acoes">
                    <div><a href="./pag_utilizador.jsp">Cancelar</a></div>
                </div>
            </form>
        
    <%
    
        }
    %>

</body>
</html>