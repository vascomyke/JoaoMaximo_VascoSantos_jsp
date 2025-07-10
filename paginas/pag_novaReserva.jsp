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
    } else if ( tipoUtilizador.equals("admin") || tipoUtilizador.equals("funcionario") ) {

        %>
        <div class="container">
            <h2>Comprar Bilhete</h2>
            <form method="post" action="reservahorario.jsp">
                <label for="cliente">Cliente:</label>
                <select name="cliente" id="cliente" required>
        <%

        sql = "SELECT nomeUtilizador FROM user WHERE tipoUtilizador = 'cliente'";
        conexao = conn.createStatement();
	    rs = conexao.executeQuery(sql);
        
        while (rs.next()) {
            %>
            <option value="<%= rs.getString("nomeUtilizador") %>"><%= rs.getString("nomeUtilizador") %></option>
            <%
        }
        %>

                </select><br><br>
                <label for="rota">Rota:</label>
                <select name="rota" id="rota" required>
                
                <%
                sql = "SELECT * FROM rota";
                conexao = conn.createStatement();
                rs = conexao.executeQuery(sql);
                while(rs.next()){
                    int idRota = rs.getInt("idRota");
                    String origem = rs.getString("origem");
                    String destino = rs.getString("destino");
                    double preco = rs.getDouble("preco");
                %>
                    <option value="<%= idRota %>"><%= origem %> > <%= destino %> - <%= preco %> €</option>
                <%
                }
                %>

                </select>
                <br>
                <input type="submit" name="submit" value="Continuar">
            </form>
            <div id="acoes">
                <div><a href="./pag_utilizador.jsp">Cancelar</a></div>
            </div>
        </div>
        <%
    }else if ( tipoUtilizador.equals("cliente") ) {
        String cliente = user;
   
    %>
    <div class="container">
        <h2>Comprar Bilhete</h2>
        <form method="post" action="reservahorario.jsp">
            <label for="rota">Rota:</label>
                <select name="rota" id="rota" required>
                
                <%
                sql = "SELECT * FROM rota";
                conexao = conn.createStatement();
                rs = conexao.executeQuery(sql);
                while(rs.next()){
                    int idRota = rs.getInt("idRota");
                    String origem = rs.getString("origem");
                    String destino = rs.getString("destino");
                    double preco = rs.getDouble("preco");
                %>
                    <option value="<%= idRota %>"><%= origem %> > <%= destino %> - <%= preco %> €</option>
                <%
                }
                %>

                </select>
            <br>
            <input type="hidden" name="cliente" value="<%= cliente %>">
            <input type="submit" name="submit" value="Continuar">
        </form>
        <div id="acoes">
        <div><a href="./pag_utilizador.jsp">Cancelar</a></div>
    </div>
    <%
    }
%>
</body>
</html>
