<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest" %>
<%@ include file="../basedados/basedados.h"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Gerir Utilizadores</title>
</head>

<style>
	body {
		background-color: #376141;
	}
	
	#cabecalho {
		margin: -8px;
		height: 200px;
	}
	
	.input-div {
		margin: 25px;
		float: right;
		height: 150px;
	}
  
	input[type=submit] {
		background-color: #088A29;
		padding: 10px 30px;
		height: 50px;
		font: bold 15px sans-serif;
		color: white;
		box-shadow: 2px 2px 5px #000000;
		cursor: pointer;
		border: 0px;
	}
	
	input[type=submit]:hover {
		box-shadow: 1px 1px 5px #000000;
	}
	
	#botoes {
		margin: 70px;
	}
  
	#botao {
		float: right;
		margin: 10px;
	}
  
	#logo {
		float: left;
		background-image: url(./imgs/logo_tipo.png);
		margin-left: 80px;
		margin-top: 90px;
		width: 180px;
		height: 60px;
	}
  
	#corpo {
		margin: 25px;
	}
	
	td {
		font: normal 15px sans-serif;
	}
	
	th {
		font: bold 15px sans-serif;
		text-align: left;
	}
  
	table,
	th,
	td {
		border-collapse: collapse;
	}
  
	th,
	td {
		padding: 15px 20px;
	}
  
	table#t01 tr:nth-child(even) {
		color: white;
		background-color: #4C8E5C;
	}
  
	table#t01 tr:nth-child(odd) {
		background-color: #BCF5A9;
	}
	
	#btnNv {
		font: bold 19px sans-serif;
		margin-bottom: 20px;
		padding: 10px 70px;
	}
</style>  

<body>  
	<!-- CABECALHO -->
	<div id="cabecalho">
		<div class="input-div">
			<div id="botoes"> 
				<%
				Statement conexao = null;
				ResultSet rs = null;

				String user = (String) session.getAttribute("user");

				String tipoUtilizador = "";
				String sql = "SELECT tipoUtilizador FROM user WHERE nomeUtilizador = '" + user + "'";
				
				// Execute the query
				conexao = conn.createStatement();
				rs = conexao.executeQuery(sql);

				// Retrieve tipoUtilizador
				if (rs.next()) {
					tipoUtilizador = rs.getString("tipoUtilizador");
				}

				if (user == null || !tipoUtilizador.equals("admin")) {
					out.println("<script>alert('Acesso Restrito!')</script>");
					out.println("<script>setTimeout(function () { window.location.href = './pag_principal.jsp'; }, 0)</script>");
				}
				%>

				<div id='botao'>
					<form action='./logout.jsp'>
						<input type='submit' value='Logout'>
					</form>
				</div>
				<div id='botao'>
					<form action='./pag_utilizador.jsp'>
						<input type='submit' value='Página Inicial'>
					</form>
				</div>
			</div>
		</div>
	</div>
	<!-- CORPO -->
	<div id="corpo">
		<form action="./pag_registo.jsp">
			<input type='submit' value='Novo Utilizador' id="btnNv">
		</form>
		
		<div id="tabela">
			<%
			sql = "SELECT * FROM user";

			// Execute the query
			conexao = conn.createStatement();
			rs = conexao.executeQuery(sql);
			%>

			<table width='100%' id='t01'>
				<tr>
					<th>Nome Utilizador:</th>
					<th>Tipo:</th>
					<th>Telemóvel:</th>
					<th>Validar:</th>
					<th>Editar:</th>
					<th>(Des)Promover:</th>
				</tr>

				<%
				while (rs.next()) {
					%>
					<tr>
						<td><%= rs.getString("nomeUtilizador") %></td>
						<td><%= getDescricaoUtilizador(rs.getString("tipoUtilizador")) %></td>
						<td><%= rs.getString("telemovel") %></td>

						<%
						if (rs.getString("tipoUtilizador").equals("cliente_nao_validado")) {
							%>
							<td>
								<form method="POST" action="./validar.jsp">
									<input type="text" name="IdUser" value="<%= rs.getString("nomeUtilizador") %>" hidden/>
									<input type="image" src="./validar.png" alt="Validar" width="50" height="50">
								</form>
							</td>
							<%
						} else {
							out.println("<td></td>");
						}

						if (!rs.getString("tipoUtilizador").equals("cliente_nao_validado")) {
							%>
							<td>
								<form method="POST" action="./pag_editarUser.jsp">
									<input type="text" name="IdUser" value="<%= rs.getString("nomeUtilizador") %>" hidden/>
									<input type="image" src="./editar.png" alt="Editar" width="50" height="50">
								</form>
							</td>
							<%
						} else {
							out.println("<td></td>");
						}

						// PROMOVER
						if (!rs.getString("tipoUtilizador").equals("cliente_nao_validado")) {
							%>
							<td>
								<form method="POST" action="./pag_promocao.jsp">
									<input type="text" name="IdUser" value="<%= rs.getString("nomeUtilizador") %>" hidden/>
									<input type="text" name="tipo" value="<%= rs.getString("tipoUtilizador") %>" hidden/>
									<input type="image" src="./promover.png" alt="(Des)promover" width="50" height="50">
								</form>
							</td>
							<%
						} else {
							out.println("<td></td>");
						}
						out.println("</tr>");
					}
					out.println("</table>");
					%>

					<%!
					String getDescricaoUtilizador(String tipo) {
						switch (tipo) {
							case "admin":
								return "Administrador";
							case "funcionario":
								return "Funcionario";
							case "cliente":
								return "Cliente";
							case "cliente_nao_validado":
								return "Cliente não validado";
							default:
								return "Desconhecido";
						}
					}
					%>
		</div>
	</div>
</body>
</html>
