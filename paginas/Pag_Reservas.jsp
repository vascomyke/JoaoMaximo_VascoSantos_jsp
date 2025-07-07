<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest" %>
<%@ include file="../basedados/basedados.h"%>
<!DOCTYPE html>
<html>
<head>
    <title>Gerir Reservas</title>
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

        .custom-button {
            display: inline-block;
            padding: 10px 20px;
            background-color: #3AA85D;
            border: none;
            color: #fff;
            font-weight: bold;
            border-radius: 3px;
            cursor: pointer;
            margin-top: 15px;
            font-size: 14px;
        }
        
        h1 {
            text-align: center;
            margin-bottom: 20px;
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
    Statement conexao = null;
    String user = (String) session.getAttribute("user");

    if ( user == null ) {
        %>
        echo "<script>alert('Autentique-se primeiro!'); window.location.href = './pag_principal.jsp';</script>";
        <%
    } 
    
    String tipoUtilizador = "";
	String sql = "SELECT tipoUtilizador FROM user WHERE nomeUtilizador = '" + user + "'";
			
	// Execute the query
	Statement stmt = conn.createStatement();
	ResultSet rs = stmt.executeQuery(sql);

	// Retrieve tipoUtilizador
	if (rs.next()) {
		tipoUtilizador = rs.getString("tipoUtilizador");
	}

    if ( tipoUtilizador.equals("cliente_nao_validado") ) {
        %>
        echo "<script>alert('A sua conta ainda não foi validada! Tente novamente mais tarde.'); window.location.href = './pag_principal.jsp';</script>";
        <%
    }



    %>
    
    <div class="container">
        <h1>Gerir Reservas</h1>
        <div id="gerir-reservas">
            <button class="custom-button" onclick="location.href='./pag_novaReserva.jsp'">+ Nova Reserva</button><br>
            <button class="custom-button" onclick="location.href='./pag_gerirReservas.jsp'">Gerir Reservas</button>
        </div>
        <br>
        <div id="volta"><a href="./pag_utilizador.jsp">Página Principal</a></div>
    </div>
</body>
</html>
