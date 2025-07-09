<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="../basedados/basedados.h" %>
<!DOCTYPE html>
<html>
<head>
    <title>Carteira</title>
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

        .button-row {
            display: flex;
            gap: 10px; 
            margin-top: 10px;
        }

        .inline-button {
            width: auto; 
            padding: 10px 20px;
            background-color: #4caf50;
            border: none;
            color: #fff;
            font-weight: bold;
            border-radius: 3px;
            cursor: pointer;
        }

        .inline-button:hover {
            background-color: #45a049;
        }

        .inline-button.red {
            background-color: #f44336; /* light red */
        }


        .inline-button.red:hover {
            background-color: #e53935;
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
    String sessionUser = (String) session.getAttribute("user");
    
    if (sessionUser == null) {
        out.println("<script>alert('Autentique-se primeiro!'); window.location.href = './pag_principal.jsp';</script>");
    } else {
        // Get user data
        String sql = "SELECT * FROM user WHERE nomeUtilizador = '" + sessionUser + "'";
        Statement stmt = conn.createStatement();
        ResultSet rs = stmt.executeQuery(sql);
        
        String tipoUtilizador = "";
        if (rs.next()) {
            tipoUtilizador = rs.getString("tipoUtilizador");
        }
        rs.close();
        stmt.close();
        
        if ("admin".equals(tipoUtilizador) || "funcionario".equals(tipoUtilizador)) {
%>
            <div class="container">
                <h2>Gerir Carteria</h2>
                <form method="post" action="carteira.jsp">
                    <label for="cliente">Cliente:</label>
                    <select name="cliente" id="cliente" required>
<%
            String sqlClientes = "SELECT nomeUtilizador FROM user WHERE tipoUtilizador = 'cliente'";
            Statement stmtClientes = conn.createStatement();
            ResultSet rsClientes = stmtClientes.executeQuery(sqlClientes);
            
            while (rsClientes.next()) {
                String nomeCliente = rsClientes.getString("nomeUtilizador");
%>
                        <option value="<%= nomeCliente %>"><%= nomeCliente %></option>
<%
            }
            rsClientes.close();
            stmtClientes.close();
%>
                    </select><br><br>
                    <label for="valor">Introduza um valor:</label>
                    <input type="number" name="valor" id="valor" min="0" required>
                    <br>
                    <div class="button-row">
                        <input type="submit" name="depositar" value="Depositar" class="inline-button">
                        <input type="submit" name="levantar" value="Levantar" class="inline-button red">
                    </div>
                </form>
                <div id="acoes">
                    <div><a href="./pag_utilizador.jsp">Cancelar</a></div>
                </div>
            </div>
<%
        } else if ("cliente".equals(tipoUtilizador)) {
            String cliente = sessionUser;
%>
            <div class="container">
                <h2>CARTEIRA</h2>
                <form method="post" action="carteira.jsp">
<%
            String sqlCarteira = "SELECT * FROM carteira WHERE nomeUtilizador = '" + cliente + "'";
            Statement stmtCarteira = conn.createStatement();
            ResultSet rsCarteira = stmtCarteira.executeQuery(sqlCarteira);
            
            if (rsCarteira.next()) {
                int idCarteira = rsCarteira.getInt("idCarteira");
                String nomeUtilizador = rsCarteira.getString("nomeUtilizador");
                double saldo = rsCarteira.getDouble("saldo");
%>
                    <p>Carteira: ID <%= idCarteira %> | Utilizador: <%= nomeUtilizador %> | Saldo: <%= saldo %> €</p>
<%
            } else {
%>
                    <p>Carteira não encontrada.</p>
<%
            }
            rsCarteira.close();
            stmtCarteira.close();
%>
                    <label for="valor">Introduza um valor:</label>
                    <input type="number" name="valor" id="valor" min="0" required>
                    <br>
                    <input type="hidden" name="cliente" value="<%= cliente %>">
                    <div class="button-row">
                        <input type="submit" name="depositar" value="Depositar" class="inline-button">
                        <input type="submit" name="levantar" value="Levantar" class="inline-button red">
                    </div>
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