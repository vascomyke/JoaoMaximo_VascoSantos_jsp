<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest" %>
<%@ include file="../basedados/basedados.h"%>
<%

Statement conexao = null;

String user = (String) session.getAttribute("user");

if (user == null){
    out.println(" <script> alert ('Erro. Tente Novamente!') </script>");
    out.println("<script>  setTimeout(function () { window.location.href = './logout.jsp'; }, 0)</script>");
}

if (request.getMethod().equals("POST")) {
    String nomeUtilizador = request.getParameter("IdUser");

    String sql = "UPDATE user SET tipoUtilizador = 'aluno' WHERE nomeUtilizador = '" + nomeUtilizador + "'";

    try {
        conexao = conn.createStatement();
        int rowsAffected = conexao.executeUpdate(sql);

        if (rowsAffected > 0) {
            out.println("<script>alert('Validado com sucesso');</script>");
            out.println("<script>  setTimeout(function () { window.location.href = './pag_gestUtilizadores.jsp'; }, 0)</script>");
        } else {
            out.println("<script>alert('Erro1. Tente novamente.');</script>");
            out.println("<script>  setTimeout(function () { window.location.href = './pag_gestUtilizadores.jsp'; }, 0)</script>");
        }

    } catch (SQLException e) {
        e.printStackTrace();
        out.println("<script>alert('Erro. Tente novamente.');</script>");
        out.println("<script>  setTimeout(function () { window.location.href = './pag_gestUtilizadores.jsp'; }, 0)</script>");
    } finally {
        conexao.close();
    }
    
}

    %>


