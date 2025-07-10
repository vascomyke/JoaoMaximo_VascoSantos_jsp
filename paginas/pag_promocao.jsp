<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="../basedados/basedados.h" %>

<!DOCTYPE html>
<html>
<head>
    <title>Pagina de Promocao</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
        }
        
        .container {
            width: 300px;
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
        
        .data-label {
            font-weight: bold;
        }
        
        .data-value {
            margin-bottom: 15px;
        }
    </style>
</head>
<body>
    <div class="container">
        <h2>(Des)promover</h2>
        <%
        // Check if user is logged in
        String sessionUser = (String) session.getAttribute("user");
        if(sessionUser != null) {
            String idUser = request.getParameter("IdUser");
            
            
            Statement stmt = null;
            ResultSet rs = null;
            
            try {
                stmt = conn.createStatement();
                
                String sql = "SELECT * FROM user WHERE nomeUtilizador='" + idUser + "'";
                rs = stmt.executeQuery(sql);
                
                if(rs.next()) {
                    String nomeUtilizador = rs.getString("nomeUtilizador");
                    String tipoUtilizador = rs.getString("tipoUtilizador");
        %>
                    Nome de Utilizador: <%= nomeUtilizador %><br>
                    Tipo de Utilizador: <%= tipoUtilizador %><br>
                    
                    <form action="promocao.jsp" method="post">
                        <h2>Promover ou Despromover Utilizador</h2><br>
                        <input type="hidden" name="IdUser" value="<%= nomeUtilizador %>">
                        <input type="hidden" name="tipo" value="<%= tipoUtilizador %>">
                        <input type="submit" name="despromover" value="Despromover">
                        <input type="submit" name="promover" value="Promover">
                        
                        <!--=====================Registo=====================-->
                        
                        <div id="acoes">
                            <div><a href="./pag_gestUtilizadores.jsp">Cancelar</a></div>
                        </div>
                    </form>
        <%
                }
            } catch(SQLException e) {
                out.println("Error: " + e.getMessage());
            } 
        } else {
        %>
            <script>
                setTimeout(function(){ 
                    window.location.href = './logout.jsp'; 
                }, 0);
            </script>
        <%
        }
        %>
    </div>
</body>
</html>