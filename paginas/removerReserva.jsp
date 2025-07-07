<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest" %>
<%@ include file="../basedados/basedados.h"%>
<%

Statement conexao = null;

int rowsAffected = 0;

String sessionUser = (String) session.getAttribute("user");

//ResultSet rs = null;

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
} else {

    String idReserva = request.getParameter("idReserva");
    String idHorario = request.getParameter("idHorario");

    String removerSql = "DELETE FROM reservaformacao WHERE idReserva = '" + idReserva + "'";
    String updateQuery = "UPDATE horarioformacao SET inscricoes = inscricoes - 1 WHERE idHorario = '" + idHorario + "'";


    conexao = conn.createStatement();
    int remover = conexao.executeUpdate(removerSql);
    int update = conexao.executeUpdate(updateQuery);

    if (remover > 0 && update > 0){
        out.println ("<script>alert('Reserva removida!');</script>");
        conexao.close();
        out.println ("<script>setTimeout(function() { window.location.href = 'pag_gerirReservas.jsp'; }, 0);</script>");

    } else {
        out.println ("<script>alert('Erro ao remover reserva!');</script>");
        conexao.close();
        out.println ("<script>setTimeout(function() { window.location.href = 'pag_gerirReservas.jsp'; }, 0);</script>");

    }
}

%>