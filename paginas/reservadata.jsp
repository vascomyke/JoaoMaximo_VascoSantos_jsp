<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest" %>
<%@ include file="../basedados/basedados.h"%>
<!DOCTYPE html>
<html>
<head>
    <title>Escolher Horário</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
        }
        
        .container {
            width: 400px;
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
        
        select, input[type="datetime-local"] {
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
            margin: 15px 0 0 0;
        }
        
        input[type="submit"]:hover {
            background-color: #45a049;
        }
        
        .success {
            color: #4caf50;
            margin-top: 10px;
        }
        
        .error {
            color: #f44336;
            margin-top: 10px;
        }
    </style>
</head>
<body>
<div class="container">
    <h2>Escolher Horário</h2>
    <%
    Statement conexao = null;
    ResultSet rs = null;
    String user = (String) session.getAttribute("user");


    String aluno = request.getParameter("aluno");
    String formacao = request.getParameter("formacao");
    

    if ( user == null ) {
        %>
        out.println("<script>alert('Autentique-se primeiro!'); window.location.href = './pag_principal.jsp';</script>");
    } 
    
    String tipoUtilizador = "";
	String sql = "SELECT tipoUtilizador FROM user WHERE nomeUtilizador = '" + user + "'";
			
	// Execute the query
	conexao = conn.createStatement();
	rs = conexao.executeQuery(sql);

	// Retrieve tipoUtilizador
	if (rs.next()) {
		tipoUtilizador = rs.getString("tipoUtilizador");
	}

    if ( tipoUtilizador.equals("cliente_nao_validado") ) {
        %>
        <script>alert('A sua conta ainda não foi validada! Tente novamente mais tarde.'); window.location.href = './pag_principal.jsp';</script>
        <%
    }
    %>

    <form method="post" action="reserva.jsp">
        <label for="horario">Horário:</label>
        <%
        String sql = "SELECT idHorario, horario FROM horarioformacao WHERE nomeFormacao = '" + formacao + "'";
        conexao = conn.createStatement();
        rs = conexao.executeQuery(sql);

        if (rs.next()) {
        %>
            <select name="idhorario">
        <%
            do {
        %>
                <option value="<%= rs.getString("idHorario") %>"><%= rs.getString("horario") %></option>
        <%
            } while (rs.next());
        %>
            </select>
        <%
        } else {
        %>
            <script>
                alert('O curso que escolheu não está disponível de momento!');
                window.location.href = './pag_principal.jsp';
            </script>
        <%
        }
        %>
        
        <input type="hidden" name="formacao" value="<%= formacao %>">
        <input type="hidden" name="aluno" value="<%= aluno %>">
        <input type="submit" name="submit" value="Inscrever">
    </form>


</div>
</body>
</html>
