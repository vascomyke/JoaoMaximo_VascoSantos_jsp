<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest" %>
<%@ include file="../basedados/basedados.h"%>

<!DOCTYPE html>
<html>
<head>
    <title>Gerir Reservas</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #376141;
        }
        
        .container {
            width: 95%;
            margin: 0 auto;
            margin-top: 20px;
            background-color: #fff;
            border: 1px solid #ccc;
            padding: 20px;
            border-radius: 5px;
            box-shadow: 2px 2px 5px #000000;
        }
        
        h1 {
            text-align: center;
            margin-bottom: 20px;
            color: white;
        }
        
        .success {
            color: #4caf50;
            margin-top: 10px;
            text-align: center;
        }
        
        .error {
            color: #f44336;
            margin-top: 10px;
            text-align: center;
        }

        table {
            width: 100%;
            border-collapse: collapse;
        }

        th {
            font: bold 15px sans-serif;
            text-align: left;
            padding: 15px 20px;
        }

        td {
            font: normal 15px sans-serif;
            padding: 15px 20px;
        }

        table tr:nth-child(even) {
            color: white;
            background-color: #4C8E5C;
        }

        table tr:nth-child(odd) {
            background-color: #BCF5A9;
        }

        #btnNv {
    font: bold 19px sans-serif;
    margin-bottom: 5px;
    padding: 10px 60px;
}

.right-buttons {
    position: absolute;
    top: 10px;
    right: 20px;
    display: flex;
    align-items: center;
}

.right-buttons form {
    margin-left: 10px;
}

    </style>
    </head>
<body>

<%

    Statement conexao = null;

    int rowsAffected = 0;

    String sessionUser = (String) session.getAttribute("user");

    ResultSet rs = null;

    String tipoUtilizador = "";
    String sql = "SELECT * FROM user WHERE nomeUtilizador = '" + sessionUser + "'";

    // Execute the query
    conexao = conn.createStatement();
    ResultSet session_rs = conexao.executeQuery(sql);

    // Retrieve tipoUtilizador
    if (session_rs.next()) {
        tipoUtilizador = session_rs.getString("tipoUtilizador");
    }

    if (sessionUser == null){
%>
                <script> alert ('Autentique-se Primeiro!') </script>
                <script>  setTimeout(function () { window.location.href = './logout.jsp'; }, 0)</script>
<%
    } else if (tipoUtilizador.equals("admin") || tipoUtilizador.equals("funcionario")){
        %>
        <div>
            <form action='./pag_novaReserva.jsp'>
                    <input type='submit' value='Nova Reserva' id='btnNv'>
            </form>
            </div>
            <div class='right-buttons'>
                <form action='./logout.jsp'>
                    <input type='submit' value='Logout' id='btnNv'>
                </form>
                <form action='./pag_utilizador.jsp'>
                    <input type='submit' value='Página Inicial' id='btnNv'>
                </form>
            </div>
            
        <%
        sql = "SELECT * FROM bilhete";
        conexao = conn.createStatement();
        ResultSet rsBilhete = conexao.executeQuery(sql);

       

        if (rsBilhete.next()){
            int idHorario = rsBilhete.getInt("idHorario");

            String sql2 = "SELECT horario,idRota FROM horariorota WHERE idHorario = " + idHorario;
            conexao = conn.createStatement();
            ResultSet rsHorario = conexao.executeQuery(sql2);       
            rsHorario.next();

            int idRota = rsHorario.getInt("idRota");

            String sql3 = "SELECT origem, destino FROM rota WHERE idRota = " + idRota;
            conexao = conn.createStatement();
            ResultSet rsRota = conexao.executeQuery(sql3); 
            
            rsRota.next();

            int idBilhete = rsBilhete.getInt("idBilhete");
            String nomeUtilizador = rsBilhete.getString("nomeUtilizador");
            String origem = rsRota.getString("origem");
            String destino = rsRota.getString("destino");
            String horario = rsHorario.getString("horario");

            %>
            <div class='container'>
                <table>
                    <tr><th>ID</th>
                        <th>Nome do Cliente</th>
                        <th>Origem</th>
                        <th>Destino</th>
                        <th>Horario</th>
                        <th>Editar</th>
                        <th>Remover</th></tr>
                        <tr>
                        <td><%= idBilhete %></td>
                        <td><%= nomeUtilizador %></td>
                        <td><%= origem %></td>
                        <td><%= destino %></td>
                        <td><%= horario %></td>
                        <td>
                            <form method="POST" action="./pag_editarReserva.jsp">
                                <input type="text" name="idBilhete" value="<%= idBilhete %>" hidden/>
                                <input type="image" src="./editar.png" alt="Editar" width="50" height="50">
                            </form>
                        </td>
                        <td>
                            <form method="POST" action="./removerReserva.jsp">
                                <input type="text" name="idBilhete" value="<%= idBilhete %>" hidden/>
                                <input type="text" name="idHorario" value="<%= idHorario %>" hidden/>
                                <input type="image" src="./remover.png" alt="Remover" width="50" height="50">
                            </form>
                        </td>
                    </tr>
                    <% 
                    
                    while (rsBilhete.next()) { 
                        idHorario = rsBilhete.getInt("idHorario");

                        sql2 = "SELECT horario,idRota FROM horariorota WHERE idHorario = " + idHorario;
                        conexao = conn.createStatement();
                        rsHorario = conexao.executeQuery(sql2);       
                        rsHorario.next();

                        idRota = rsHorario.getInt("idRota");

                        sql3 = "SELECT origem, destino FROM rota WHERE idRota = " + idRota;
                        conexao = conn.createStatement();
                        rsRota = conexao.executeQuery(sql3); 
                        
                        rsRota.next();

                        idBilhete = rsBilhete.getInt("idBilhete");
                        nomeUtilizador = rsBilhete.getString("nomeUtilizador");
                        origem = rsRota.getString("origem");
                        destino = rsRota.getString("destino");
                        horario = rsHorario.getString("horario");
                        %>
                        <tr>
                            <td><%= idBilhete %></td>
                            <td><%= nomeUtilizador %></td>
                            <td><%= origem %></td>
                            <td><%= destino %></td>
                            <td><%= horario %></td>
                            <td>
                                <form method="POST" action="./pag_editarReserva.jsp">
                                    <input type="hidden" name="idBilhete" value="<%= idBilhete %>" hidden/>
                                    <input type="image" src="./editar.png" alt="Editar" width="50" height="50">
                                </form>
                            </td>
                            <td>
                                <form method="POST" action="./removerReserva.jsp">
                                    <input type="text" name="idBilhete" value="<%= idBilhete %>" hidden/>
                                    <input type="text" name="idHorario" value="<%= idHorario %>" hidden/>
                                    <input type="image" src="./remover.png" alt="Remover" width="50" height="50">
                                </form>
                            </td>
                        </tr> 
                    <% 
                    }
                    %>
                </table>  
            </div>
        <%          
        }else { %>
            <div class='container'>
            <p>Não há registros de reserva.</p>
            </div>
            <% 
        }

    } else if (tipoUtilizador.equals("cliente")) {
        %>
        <div>
            <form action='./pag_novaReserva.jsp'>
                    <input type='submit' value='Nova Reserva' id='btnNv'>
            </form>
            </div>
            <div class='right-buttons'>
                <form action='./logout.jsp'>
                    <input type='submit' value='Logout' id='btnNv'>
                </form>
                <form action='./pag_utilizador.jsp'>
                    <input type='submit' value='Página Inicial' id='btnNv'>
                </form>
            </div>
            
        <%
        String cliente = sessionUser;

        sql = "SELECT * FROM bilhete WHERE nomeUtilizador = '"+ cliente + "'";
        conexao = conn.createStatement();
        ResultSet rsBilhete = conexao.executeQuery(sql);

       

        if (rsBilhete.next()){
            int idHorario = rsBilhete.getInt("idHorario");

            String sql2 = "SELECT horario,idRota FROM horariorota WHERE idHorario = " + idHorario;
            conexao = conn.createStatement();
            ResultSet rsHorario = conexao.executeQuery(sql2);       
            rsHorario.next();

            int idRota = rsHorario.getInt("idRota");

            String sql3 = "SELECT origem, destino FROM rota WHERE idRota = " + idRota;
            conexao = conn.createStatement();
            ResultSet rsRota = conexao.executeQuery(sql3); 
            
            rsRota.next();

            int idBilhete = rsBilhete.getInt("idBilhete");
            String nomeUtilizador = rsBilhete.getString("nomeUtilizador");
            String origem = rsRota.getString("origem");
            String destino = rsRota.getString("destino");
            String horario = rsHorario.getString("horario");

            %>
            <div class='container'>
                <table>
                    <tr><th>ID</th>
                        <th>Nome do Cliente</th>
                        <th>Origem</th>
                        <th>Destino</th>
                        <th>Horario</th>
                        <th>Editar</th>
                        <th>Remover</th></tr>
                        <tr>
                        <td><%= idBilhete %></td>
                        <td><%= nomeUtilizador %></td>
                        <td><%= origem %></td>
                        <td><%= destino %></td>
                        <td><%= horario %></td>
                        <td>
                            <form method="POST" action="./pag_editarReserva.jsp">
                                <input type="text" name="idBilhete" value="<%= idBilhete %>" hidden/>
                                <input type="image" src="./editar.png" alt="Editar" width="50" height="50">
                            </form>
                        </td>
                        <td>
                            <form method="POST" action="./removerReserva.jsp">
                                <input type="text" name="idBilhete" value="<%= idBilhete %>" hidden/>
                                <input type="text" name="idHorario" value="<%= idHorario %>" hidden/>
                                <input type="image" src="./remover.png" alt="Remover" width="50" height="50">
                            </form>
                        </td>
                    </tr>
                    <% 
                    
                    while (rsBilhete.next()) { 
                        idHorario = rsBilhete.getInt("idHorario");

                        sql2 = "SELECT horario,idRota FROM horariorota WHERE idHorario = " + idHorario;
                        conexao = conn.createStatement();
                        rsHorario = conexao.executeQuery(sql2);       
                        rsHorario.next();

                        idRota = rsHorario.getInt("idRota");

                        sql3 = "SELECT origem, destino FROM rota WHERE idRota = " + idRota;
                        conexao = conn.createStatement();
                        rsRota = conexao.executeQuery(sql3); 
                        
                        rsRota.next();

                        idBilhete = rsBilhete.getInt("idBilhete");
                        nomeUtilizador = rsBilhete.getString("nomeUtilizador");
                        origem = rsRota.getString("origem");
                        destino = rsRota.getString("destino");
                        horario = rsHorario.getString("horario");
                        %>
                        <tr>
                            <td><%= idBilhete %></td>
                            <td><%= nomeUtilizador %></td>
                            <td><%= origem %></td>
                            <td><%= destino %></td>
                            <td><%= horario %></td>
                            <td>
                                <form method="POST" action="./pag_editarReserva.jsp">
                                    <input type="hidden" name="idBilhete" value="<%= idBilhete %>" hidden/>
                                    <input type="image" src="./editar.png" alt="Editar" width="50" height="50">
                                </form>
                            </td>
                            <td>
                                <form method="POST" action="./removerReserva.jsp">
                                    <input type="text" name="idBilhete" value="<%= idBilhete %>" hidden/>
                                    <input type="text" name="idHorario" value="<%= idHorario %>" hidden/>
                                    <input type="image" src="./remover.png" alt="Remover" width="50" height="50">
                                </form>
                            </td>
                        </tr> 
                    <% 
                    }
                    %>
                </table>  
            </div>
        <%          
        }else { %>
            <div class='container'>
            <p>Não há registros de reserva.</p>
            </div>
            <% 
        }

    }

%>



