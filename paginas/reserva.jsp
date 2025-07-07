<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest" %>
<%@ include file="../basedados/basedados.h"%>
<%   
Statement conexao = null;
ResultSet rs = null;


String user = (String) session.getAttribute("user");

String tipoUtilizador = "";
String sql = "SELECT tipoUtilizador FROM user WHERE nomeUtilizador = '" + user + "'";
boolean temReserva = false;
boolean NaoTemVaga = false;

// Execute the query
conexao = conn.createStatement();
rs = conexao.executeQuery(sql);

// Retrieve tipoUtilizador
if (rs.next()) {
    tipoUtilizador = rs.getString("tipoUtilizador");
}

if (user == null) {
    out.println("<script>alert('Autentique-se primeiro!')</script>");
    out.println("<script>setTimeout(function () { window.location.href = './pag_principal.jsp'; }, 0)</script>");
}

String docente = "";
String aluno = request.getParameter("aluno");
String formacao = request.getParameter("formacao");
String horario = request.getParameter("idhorario");
String idHorario = request.getParameter("idhorario");

String checkReservaQuery = "SELECT * FROM reservaformacao WHERE nomeFormacao = '" + formacao + "' AND nomeUtilizador = '" + aluno + "'";
conexao = conn.createStatement();
rs = conexao.executeQuery(checkReservaQuery);
if (rs.next()){
    temReserva = true;
}

   
String checkVagasQuery = "SELECT * FROM horarioformacao WHERE idHorario = '" + idHorario + "' AND inscricoes = limiteinscricoes";
conexao = conn.createStatement();
rs = conexao.executeQuery(checkVagasQuery);
if (rs.next()){
    NaoTemVaga = true;
}


String docenteQuery = "SELECT docente FROM formacao WHERE nomeFormacao = '" + formacao + "'";
conexao = conn.createStatement();
rs = conexao.executeQuery(docenteQuery);
if (rs.next()){
    docente = rs.getString("docente");
} 
    if ( temReserva ) {
        %>
        <script>
            alert('Já fez uma reserva para esta formação');
            window.location.href = 'pag_novaReserva.jsp';
        </script>
        <%
    }else if (NaoTemVaga){
        %>
        <script>alert('De momento não há vagas para esta formação.')
        window.location.href = 'pag_novaReserva.jsp';</script>
        <%
    } else {
        // Inserir nova reserva
        sql = "INSERT INTO reservaformacao (idReserva, nomeUtilizador, nomeFormacao, docente, idHorario) VALUES (NULL, '" + aluno + "', '" + formacao + "','" + docente + "' , '" + idHorario + "')";
        conexao = conn.createStatement();
        int rows = conexao.executeUpdate(sql);
        String updateQuery = "UPDATE horarioformacao SET inscricoes = inscricoes + 1 WHERE idHorario = '" + idHorario + "'";
        conexao = conn.createStatement();
        rows = conexao.executeUpdate(updateQuery);
        out.println("<script>alert('Reserva realizada com sucesso!'); window.location.href = 'pag_utilizador.jsp';</script>");

    }

conexao.close();
%>
