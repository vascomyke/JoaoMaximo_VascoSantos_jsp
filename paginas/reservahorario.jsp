<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="../basedados/basedados.h" %>

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
    String cliente = request.getParameter("cliente");
    String rota = request.getParameter("rota");
    String bilhete = request.getParameter("idBilhete");
    String editar = request.getParameter("editar");
    boolean isEditar = (editar != null && !editar.isEmpty());
    
    String sessionUser = (String) session.getAttribute("user");
    
    if (sessionUser == null) {
    %>
        <script>
            alert('Autentique-se primeiro!');
            window.location.href = './pag_principal.jsp';
        </script>
    <%
    } else {
        String preselectedHorario = null;
        
        // Check if we're editing an existing ticket
        if (bilhete != null && !bilhete.isEmpty()) {
            String sqlBilhete = "SELECT idHorario FROM bilhete WHERE idBilhete = '" + bilhete + "'";
            Statement stmtBilhete = conn.createStatement();
            ResultSet rsBilhete = stmtBilhete.executeQuery(sqlBilhete);
            
            if (rsBilhete.next()) {
                preselectedHorario = rsBilhete.getString("idHorario");
            }
            rsBilhete.close();
            stmtBilhete.close();
        }
    %>
    
    <form method="post" action="reserva.jsp">
        <label for="horario">Horário:</label>
        <%
        String sql = "SELECT idHorario, horario FROM horariorota WHERE idRota = '" + rota + "'";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);
        
        boolean hasResults = false;
        %>
        <select name="idhorario">
        <%
        while (rs.next()) {
            hasResults = true;
            String idHorario = rs.getString("idHorario");
            String horario = rs.getString("horario");
            String selected = (preselectedHorario != null && preselectedHorario.equals(idHorario)) ? "selected" : "";
        %>
            <option value="<%= idHorario %>" <%= selected %>><%= horario %></option>
        <%
        }
        rs.close();
        stmt.close();
        
        if (!hasResults) {
        %>
            </select>
            <script>
                alert('A rota que escolheu não está disponível de momento!');
                window.location.href = './pag_novaReserva.jsp';
            </script>
        <%
        } else {
        %>
            </select>
            
            <input type="hidden" name="idRota" value="<%= rota %>">
            <input type="hidden" name="cliente" value="<%= cliente %>">
            <input type="hidden" name="bilhete" value="<%= bilhete != null ? bilhete : "" %>">
            <% if (isEditar) { %>
                <input type="hidden" name="editar" value="<%= editar %>">
            <% } %>
            <input type="submit" name="submit" value="Comprar Bilhete">
        <%
        }
        %>
    </form>

    <%
    }
    %>
</div>
</body>
</html>