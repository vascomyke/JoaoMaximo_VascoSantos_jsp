<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest" %>
<%@ include file="../basedados/basedados.h"%>
<!DOCTYPE html>
<html>
<head>
    <title>Reserva</title>
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
        }
        
        input[type="submit"]:hover {
            background-color: #45a049;
        }
        
        #servico {
        display: block;
        margin-bottom: 5px;
        }

        
        .success {
            color: #4caf50;
            margin-top: 10px;
        }
        
        .error {
            color: #f44336;
            margin-top: 10px;
        }

        input[type = "submit"]{
            margin: 12px 0 15px 0;
        }
        #servico{
            margin-top:15px;
        }
        
        </style>
</head>
<body>
<%

    Statement conexao = null;
    String user = (String) session.getAttribute("user");
    ResultSet rs = null;

    if ( user == null ) {
        %>
        out.println("<script>alert('Autentique-se primeiro!'); window.location.href = './pag_principal.jsp';</script>");
        <%
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
    } else if ( tipoUtilizador.equals("admin") || tipoUtilizador.equals("docente") ) {

        %>
        <div class="container">
            <h2>Nova Reserva</h2>
            <form method="post" action="reservadata.jsp">
                <label for="aluno">aluno:</label>
                <select name="aluno" id="aluno" required>
        <%

        sql = "SELECT nomeUtilizador FROM user WHERE tipoUtilizador = 'aluno'";
        conexao = conn.createStatement();
	    rs = conexao.executeQuery(sql);
        
        while (rs.next()) {
            %>
            <option value="<%= rs.getString("nomeUtilizador") %>"><%= rs.getString("nomeUtilizador") %></option>
            <%
        }
        %>

                </select><br><br>
                <label for="formacao">Formação:</label>
                <select name="formacao" id="formacao" required>
                    <option value="operadorInformatica">Operador de Informática</option>
                    <option value="gestaoRedesSociais">Gestão de Redes Sociais</option>
                    <option value="pintorConstrucaoCivil">Pintor de Construção Civil</option>
                    <option value="operadorLogistica">Operador de Logística</option>
                </select>
                <br>
                <input type="submit" name="submit" value="Continuar">
            </form>
            <div id="acoes">
                <div><a href="./pag_utilizador.jsp">Cancelar</a></div>
            </div>
        </div>
        <%
    }else if ( tipoUtilizador.equals("aluno") ) {
        String aluno = user;
   
    %>
    <div class="container">
        <h2>Nova Reserva</h2>
        <form method="post" action="reservadata.jsp">
            <label for="formacao">Formação:</label>
            <select name="formacao" id="formacao" required>
                <option value="operadorInformatica">Operador de Informática</option>
                <option value="gestaoRedesSociais">Gestão de Redes Sociais</option>
                <option value="pintorConstrucaoCivil">Pintor de Construção Civil</option>
                <option value="operadorLogistica">Operador de Logística</option>
            </select>
            <br>
            <input type="hidden" name="aluno" value="<%= aluno %>">
            <input type="submit" name="submit" value="Continuar">
        </form>
        <div id="acoes">
            <div><a href="./pag_utilizador.jsp">Cancelar</a></div>
        </div>
    </div>
    <%
    }
%>
</body>
</html>
