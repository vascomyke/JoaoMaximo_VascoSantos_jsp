<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest" %>
<%@ include file="../basedados/basedados.h"%>

<!DOCTYPE html>
<html>
<head>
    <title>Editar Bilhete</title>
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

        input[type="submit"] {
            margin: 12px 0 15px 0;
        }
        
        #servico {
            margin-top: 15px;
        }
        
    </style>
</head>
<body>

<%
String sessionUser = (String) session.getAttribute("user");
String idBilhete = request.getParameter("idBilhete");
String cliente = request.getParameter("cliente");

if (sessionUser == null) {
%>
    <script>
        alert('Autentique-se primeiro!');
        window.location.href = './pag_principal.jsp';
    </script>
<%
} else {
    // Get user data
    String sql = "SELECT * FROM user WHERE nomeUtilizador = '" + sessionUser + "'";
    Statement stmt = conn.createStatement();
    ResultSet rsUser = stmt.executeQuery(sql);
    
    String tipoUtilizador = "";
    if (rsUser.next()) {
        tipoUtilizador = rsUser.getString("tipoUtilizador");
    }
    rsUser.close();
    stmt.close();
    
    // Get all routes
    String sqlRota = "SELECT * FROM rota";
    Statement stmtRota = conn.createStatement();
    ResultSet rsRota = stmtRota.executeQuery(sqlRota);
    
    if (tipoUtilizador.equals("admin") || tipoUtilizador.equals("funcionario")) {
%>
        <div class="container">
            <h2>Editar Reserva</h2>
            <form method="post" action="reservahorario.jsp">
                <label for="cliente">Cliente:</label>
                <select name="cliente" id="cliente" required>
                <%
                // Get all clients
                String sqlClientes = "SELECT nomeUtilizador FROM user WHERE tipoUtilizador = 'cliente'";
                Statement stmtClientes = conn.createStatement();
                ResultSet rsClientes = stmtClientes.executeQuery(sqlClientes);
                
                while (rsClientes.next()) {
                    String nomeCliente = rsClientes.getString("nomeUtilizador");
                    String selected = (nomeCliente.equals(cliente)) ? "selected" : "";
                %>
                    <option value="<%= nomeCliente %>" <%= selected %>><%= nomeCliente %></option>
                <%
                }
                rsClientes.close();
                stmtClientes.close();
                %>
                </select><br><br>
                <label for="rota">Rota:</label>
                <select name="rota" id="rota" required>
                <%
                // Get idRota associated with idBilhete
                String sqlBilhete = "SELECT idHorario FROM bilhete WHERE idBilhete = '" + idBilhete + "'";
                Statement stmtBilhete = conn.createStatement();
                ResultSet rsBilhete = stmtBilhete.executeQuery(sqlBilhete);
                
                String idRotaSelecionada = "";
                if (rsBilhete.next()) {
                    String idHorario = rsBilhete.getString("idHorario");
                    rsBilhete.close();
                    stmtBilhete.close();
                    
                    String sqlHorario = "SELECT idRota FROM horariorota WHERE idHorario = '" + idHorario + "'";
                    Statement stmtHorario = conn.createStatement();
                    ResultSet rsHorario = stmtHorario.executeQuery(sqlHorario);
                    
                    if (rsHorario.next()) {
                        idRotaSelecionada = rsHorario.getString("idRota");
                    }
                    rsHorario.close();
                    stmtHorario.close();
                }
                
                while (rsRota.next()) {
                    String idRota = rsRota.getString("idRota");
                    String origem = rsRota.getString("origem");
                    String destino = rsRota.getString("destino");
                    String preco = rsRota.getString("preco");
                    String selected = (idRota.equals(idRotaSelecionada)) ? "selected" : "";
                %>
                    <option value="<%= idRota %>" <%= selected %>><%= origem %> > <%= destino %> - <%= preco %> €</option>
                <%
                }
                rsRota.close();
                stmtRota.close();
                %>
                </select>
                <input type="hidden" name="idBilhete" value="<%= idBilhete %>">
                <input type="hidden" name="editar" value="true">
                <input type="submit" name="submit" value="Continuar">
            </form>
            <div id="acoes">
                <div><a href="./pag_utilizador.jsp">Cancelar</a></div>
            </div>
        </div>
<%
    } else if (tipoUtilizador.equals("cliente")) {
        cliente = sessionUser;
%>
        <div class="container">
            <h2>Editar Reserva</h2>
            <form method="post" action="reservahorario.jsp">
                <label for="rota">Rota:</label>
                <select name="rota" id="rota" required>
                <%
                // Get idRota associated with idBilhete for client
                String sqlBilheteCliente = "SELECT idHorario FROM bilhete WHERE idBilhete = '" + idBilhete + "'";
                Statement stmtBilheteCliente = conn.createStatement();
                ResultSet rsBilheteCliente = stmtBilheteCliente.executeQuery(sqlBilheteCliente);
                
                String idRotaSelecionadaCliente = "";
                if (rsBilheteCliente.next()) {
                    String idHorario = rsBilheteCliente.getString("idHorario");
                    rsBilheteCliente.close();
                    stmtBilheteCliente.close();
                    
                    String sqlHorarioCliente = "SELECT idRota FROM horariorota WHERE idHorario = '" + idHorario + "'";
                    Statement stmtHorarioCliente = conn.createStatement();
                    ResultSet rsHorarioCliente = stmtHorarioCliente.executeQuery(sqlHorarioCliente);
                    
                    if (rsHorarioCliente.next()) {
                        idRotaSelecionadaCliente = rsHorarioCliente.getString("idRota");
                    }
                    rsHorarioCliente.close();
                    stmtHorarioCliente.close();
                }
                
                while (rsRota.next()) {
                    String idRota = rsRota.getString("idRota");
                    String origem = rsRota.getString("origem");
                    String destino = rsRota.getString("destino");
                    String preco = rsRota.getString("preco");
                    String selected = (idRota.equals(idRotaSelecionadaCliente)) ? "selected" : "";
                %>
                    <option value="<%= idRota %>" <%= selected %>><%= origem %> > <%= destino %> - <%= preco %> €</option>
                <%
                }
                rsRota.close();
                stmtRota.close();
                %>
                </select>
                <br>
                <input type="hidden" name="cliente" value="<%= cliente %>">
                <input type="hidden" name="idBilhete" value="<%= idBilhete %>">
                <input type="hidden" name="editar" value="true">
                <input type="submit" name="submit" value="Continuar">
            </form>
            <div id="acoes">
                <div><a href="./pag_utilizador.jsp">Cancelar</a></div>
            </div>
        </div>
<%
    }
}
%>

</body>
</html>
