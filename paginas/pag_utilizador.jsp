<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest" %>
<%@ include file="../basedados/basedados.h"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Gestão de Cursos</title>
</head>
<style>
	body{
		background-color:#ADD8E6;
		background-image:url(./imagens/salao3.jpeg); 
		background-size: cover;
		background-repeat: no-repeat;
  		
	}

	#cabecalho {
    margin: -8px;
    height: 130px;
    background-color: #E6E6FA;
    z-index: 6;
    border: 2px solid #0B610B;
    font-family: Verdana, sans-serif;
    color: #004d00;
    text-align: center;
    font-size: 18x;
    text-transform: uppercase;
}

	.input-div{    
		margin:25px;
		float:right;
		height:70px;
	}
  
	input[type=submit]{
   
		background-color:#088A29;
		padding:10px 20px;
		height:50px;
		font: bold 15px sans-serif;
		color:white;
		box-shadow:2px 2px 5px #000000;
		cursor:pointer;
		border:0px;
	}
	
	input[type=submit]:hover{
		box-shadow:1px 1px 5px #000000;
	}
	
	#botoes{
		margin:50px;
	}
  
	#botao{
		float:right;
		margin: 0px 10px 7px 0px;
		
	}

	#text { 
		
		font-family: Arial, sans-serif;
		font-size: 16px;
		line-height: 1.5;
		color: #333;
	}
  

	
	a:link{
		color:black;
		font: bold 15px sans-serif;
		text-decoration:none;
	}
	a:visited{
		color:black;
		font: bold 15px sans-serif;
		text-decoration:none;
	}
</style>
<body>  
<div id="cabecalho">
	<h1><br>Gestão de Cursos</h1>
</div>
	
<div class="input-div">
	<div id="botoes"> 
	
		<%
		String user = (String) session.getAttribute("user");
		
		String tipoUtilizador = "";
		String sql = "SELECT tipoUtilizador FROM user WHERE nomeUtilizador = '" + user + "'";
		
		// Execute the query
		Statement stmt = conn.createStatement();
		ResultSet rs = stmt.executeQuery(sql);
		
		// Retrieve tipoUtilizador
		if (rs.next()) {
			tipoUtilizador = rs.getString("tipoUtilizador");
		}
		
		if (user != null) {
			out.println(user);      
		} else {
			out.println("<script>setTimeout(function(){ window.location.href = './logout.jsp'; }, 0)</script>");
		}
		
		if (!tipoUtilizador.equals("cliente_nao_validado")) {
		%>
			<div class='input-div'>
				<div id='botoes'>
					<div id='botao'>
						<form action='./logout.jsp'>
							<input type='submit' value='Logout'>
						</form>
					</div>
					<div id='botao'>
						<form action='./pag_principal.jsp'>
							<input type='submit' value='Página Principal'>
						</form>
					</div>
					<div id='botao'>
						<form action='./DadosPessoais.jsp'>
							<input type='submit' value='Dados Pessoais' id='btCorpo'/>
						</form>
					</div>
					<div id='botao'>
						<form action='./Pag_Reservas.jsp'>
							<input type='submit' value='Gestão de Reservas' id='btCorpo'>
						</form>
					</div>
				</div>
			</div>
			<%
			switch (tipoUtilizador) {
				case "admin":
					printGestãoUtilizadores(out);
					printAlterarDadosPessoais(out);
					out.println("<input type='submit' value='Alterar Dados Pessoais' id='btCorpo' />");
					out.println("<input type='hidden' name='IdUser' value='" + user + "' />");
					out.println("</form>");
					out.println("</div>");
					out.println("</div>");
					out.println("</div>");
					break;
				case "docente":
					printAlterarDadosPessoais(out);
					break;
				case "aluno":
					printAlterarDadosPessoais(out);
					break;
			}
		} else {
			out.println("<script>setTimeout(function(){ window.location.href = './logout.jsp'; }, 0)</script>");
		}
		
		%>
		
		<%!
		void printGestãoUtilizadores(JspWriter out) throws IOException {
			out.println("<div class='input-div'>");
			out.println("<div id='botoes'>");
			out.println("<div id='botao'>");
			out.println("<form action='./pag_gestUtilizadores.jsp'>");
			out.println("<input type='submit' value='Gestão de Utilizadores' id='btCorpo'>");
			out.println("</form>");
			out.println("</div>");
			out.println("</div>");
			out.println("</div>");
		}
		
		void printAlterarDadosPessoais(JspWriter out) throws IOException {
			out.println("<div class='input-div'>");
			out.println("<div id='botoes'>");
			out.println("<div id='botao'>");
			out.println("<form method='POST' action='./pag_editarUser.jsp'>");
			
			
		}
		%>
		</div>
    </div>
</div>
<!-- GRAFISMO CABECALHO -->
<div id="text">
	<h2>Localização</h2>
    <p>Endereço: Rua dos Cursos, Nº10, Castelo Branco</p>
    <h2>Horários de Funcionamento</h2>
    <p>Segunda a Sexta: 9h às 18h</p> 
    <h2>Preço</h2>
	<p>Curso: 250€</p>
	<h2>Contacto</h2>
	<p>Endereço Eletrónico: suporte@cursos.com</p>
	<p>Telemóvel: 962034952</p>
</body>
</html>
