<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest" %>
<%@ include file="../basedados/basedados.h"%>
<!DOCTYPE html>
<html>
<head>
    <title>Editar Reserva</title>
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

    <%

    Statement conexao = null;
    ResultSet rs = null;

    String idHorario = "";
    String horario = "";
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
    
    String aluno = request.getParameter("aluno");
    String formacao = request.getParameter("formacao");
    String idReserva = request.getParameter("idReserva");

    sql = "SELECT idHorario, horario FROM horarioformacao WHERE nomeFormacao = '" + formacao + "'";
    conexao = conn.createStatement();
    ResultSet rsHorario = conexao.executeQuery(sql);
    

    if (user == null ) {
        out.println("<script>alert('Autentique-se Primeiro!')</script>");
        out.println("<script>setTimeout(function () { window.location.href = './pag_principal.jsp'; }, 0)</script>");
    } else  {
%>

<div class="container">
    <h2>Reservar data</h2>
    <form method="post" action="editarReserva.jsp">
        <label for="horario">Horário:</label>

<%   

            out.println("<select name='idHorario'>");
            while(rsHorario.next()) {
    
                String horarioSelecionado = rsHorario.getString("horario");
                
                idHorario = rsHorario.getString("idHorario");
                horario = rsHorario.getString("horario");
                boolean horarioselected = horario.equals(horarioSelecionado);
                out.println("<option value=\"" + idHorario + "\"" + (horarioselected ? " selected" : "") + ">" + horario + "</option>");
            }
            out.println("</select>");
        
%>
        <br><br>
        <input type="hidden" name="aluno" value="<%= aluno %>">
        <input type="hidden" name="formacao" value="<%= formacao %>">
        <input type="hidden" name="idReserva" value="<%= idReserva %>">        
        <input type="submit" name="submit" value="Editar Reserva">
        <br><br>
        <div id="acoes">
            <div><a href="./pag_utilizador.jsp">Cancelar</a></div>
        </div>
    </form>
</div>

<%
    }
%>
</body>
</html>