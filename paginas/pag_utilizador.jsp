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
		margin:20px;
	}
  
	#botao{
		float:right;
		margin: 0px 8px 5px 0px;
		
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


/* Routes container styles */
	#routes-container {
		background-color: rgba(255, 255, 255, 0.9);
		border: 2px solid #0B610B;
		border-radius: 10px;
		padding: 20px;
		margin: 20px auto;
		box-shadow: 0 4px 8px rgba(0, 0, 0, 0.3);
		max-width: 500px;
		min-width:400px;
		position: absolute;
		left: 50%;
		top: 60%;
		transform: translate(-50%, -50%);
		z-index: 10;
	}

	#routes-container h3 {
		color: #004d00;
		text-align: center;
		margin-bottom: 15px;
		font-family: Verdana, sans-serif;
		text-transform: uppercase;
	}

	.route-item {
		background-color: #f9f9f9;
		border: 1px solid #ddd;
		border-radius: 5px;
		padding: 10px;
		margin: 8px 0;
		font-family: Arial, sans-serif;
		font-size: 14px;
		transition: background-color 0.3s ease;
	}

	.route-item:hover {
		background-color: #e8f5e8;
		cursor: pointer;
	}

	.route-price {
		font-weight: bold;
		color: #088A29;
		float: right;
	}

	.route-path {
		color: #333;
	}
	</style>
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
					<div id='botao'>
							<form action='./pag_carteira.jsp'>
								<input type='submit' value='Carteira'>
							</form>
						</div>
						<%
						switch (tipoUtilizador) {
							case "admin":
								printGestaoUtilizadores(out);
								printAlterarDadosPessoais(out);
								break;
							case "funcionario":
								printAlterarDadosPessoais(out);
								break;
							case "cliente":
								printAlterarDadosPessoais(out);
								break;
						}
					} else {
						out.println("<script>setTimeout(function(){ window.location.href = './logout.jsp'; }, 0)</script>");
					}
					
					%>
				</div>
			</div>
		
		<%!
		void printGestaoUtilizadores(JspWriter out) throws IOException {
			out.println("<div id='botao'>");
			out.println("<form action='./pag_gestUtilizadores.jsp'>");
			out.println("<input type='submit' value='Gestão de Utilizadores' id='btCorpo'>");
			out.println("</form>");
			out.println("</div>");

		}
		
		void printAlterarDadosPessoais(JspWriter out) throws IOException {
			out.println("<div id='botao'>");
			out.println("<form method='POST' action='./pag_editarUser.jsp'>");
			out.println("<input type='submit' value='Alterar Dados Pessoais' id='btCorpo'>");
			out.println("</form>");
			out.println("</div>");
		}
		%>
		</div>
    </div>
</div>


<!-- Routes Display Container -->
<div id="routes-container">
    <h3>Rotas Disponíveis</h3>
    <%
    stmt = null;
    ResultSet resultrota = null;
    
    try {
        // Debug: Check if connection exists
        if (conn == null) {
            out.println("<div class='route-item'>Erro: Conexão com base de dados não estabelecida.</div>");
        } else {
            String sqlRota = "SELECT * FROM rota";
            stmt = conn.createStatement();
            resultrota = stmt.executeQuery(sqlRota);
            
            boolean hasResults = false;
            while (resultrota.next()) {
                hasResults = true;
    %>
                <div class="route-item">
                    <span class="route-path"><%= resultrota.getString("origem") %> → <%= resultrota.getString("destino") %></span>
                    <span class="route-price"><%= resultrota.getString("preco") %> €</span>
                    <div style="clear: both;"></div>
                </div>
    <%
            }
            
            if (!hasResults) {
    %>
                <div class="route-item">Nenhuma rota disponível no momento.</div>
    <%
            }
        }
        
    } catch (Exception e) {
        out.println("<div class='route-item'>Erro ao carregar rotas: " + e.getMessage() + "</div>");
        e.printStackTrace(); // This will help debug in server logs
    } finally {
        if (resultrota != null) try { resultrota.close(); } catch (SQLException e) {}
        if (stmt != null) try { stmt.close(); } catch (SQLException e) {}
    }
    %>

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
