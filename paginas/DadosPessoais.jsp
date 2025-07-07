<%@ include file="../basedados/basedados.h"%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest" %>
<!DOCTYPE html>
<html>
<head>
    <title>Dados Pessoais</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
        }
        
        .container {
            width: 300px;
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
        
        .data-label {
            font-weight: bold;
        }
        
        .data-value {
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>Dados Pessoais</h2>
        <%

        Statement conexao = null;

        String user = (String) session.getAttribute("user");

        if(user != null){
            String sql = "SELECT * FROM user WHERE nomeUtilizador='" + user + "'"; 
            conexao = conn.createStatement();
            ResultSet rs = conexao.executeQuery(sql);

            if (rs.next()) {
                String nomeUtilizador = rs.getString("nomeUtilizador");
                String email = rs.getString("email");
                String telemovel = rs.getString("telemovel");
                out.println("Nome de Utilizador: '" + nomeUtilizador + "'<br><br>");
                out.println("E-mail: '" + email + "'<br><br>");
                out.println("Telemóvel: '" + telemovel + "'<br>");
            }
        } else{
            out.println("<script>setTimeout(function(){ window.location.href = './logout.jsp'; }, 0)</script>");
        }
        %>
         <br>
        <div id="voltar">
            <button type="button" onclick="location.href='./pag_utilizador.jsp'">Voltar</button>
        </div>
    </div>
</body>
</html>
