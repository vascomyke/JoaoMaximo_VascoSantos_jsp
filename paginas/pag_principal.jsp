<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
  <meta charset="utf-8">
  <title>Cursos de Formação</title>
</head>
<style>
	body{
		background-color:#ADD8E6;
		background-image:url(./imagens/salao3.jpeg); 
		background-size: cover;
		background-repeat: no-repeat;
  		
	}

	#cabecalho{
		margin: -8px;
		height:130px;
		background-color:#E6E6FA;
		z-index: 6;
		border: 2px solid #0B610B;
		font-family: Verdana, sans-serif;
		color:#004d00;
		text-align: center;
		font-size: 18px; 
		text-transform: uppercase; 

	}
	.input-div{    
		margin:25px;
		float:right;
		height:150px;
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
  
	#logo{
		float:left;
		background-image:url(./imagens/);
		margin-left:80px;
		margin-top:90px;
		width:180px;
		height:60px;
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
	
	<h1>Centro de Gestão de Cursos</h1>
	</div>
		</a>
		<div class= "input-div">
			<div id="botoes"> 
			<%
				String user = (String) session.getAttribute("user");
				
				if (user != null) {
			%>
			<div id='botao'>
				<form action='./logout.jsp'>
					<input type='submit' value='Logout'>
				</form>
			</div>
			<div id='botao'>
				<form action='./pag_utilizador.jsp'>
					<input type='submit' value='Area Pessoal'>
				</form>
			</div>
		<%
		} else {
		%>
			<div id='botao'>
				<form action='./pag_login.jsp'>
					<input type='submit' value='Login'>
				</form>
			</div>
			<div id='botao'> 
				<form action='./pag_registo.jsp'>
					<input type='submit' value='Registe-se'>
				</form>
			</div>
		<%	
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

	</div>
</html>