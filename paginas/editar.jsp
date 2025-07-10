<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest" %>
<%@ include file="../basedados/basedados.h"%>
<%

Statement conexao = null;

int rowsAffected = 0;

boolean isAdmin = false;
boolean isAdminCountEqualsOne = false;
String sessionUser = (String) session.getAttribute("user");

ResultSet horarioRs = null;

String tipoUtilizador = "";
String sql = "SELECT * FROM user WHERE nomeUtilizador = '" + sessionUser + "'";

// Execute the query
conexao = conn.createStatement();
ResultSet session_rs = conexao.executeQuery(sql);

// Retrieve tipoUtilizador
if (session_rs.next()) {
    tipoUtilizador = session_rs.getString("tipoUtilizador");
}


if (request.getMethod().equals("POST")) {
    String idUser = request.getParameter("IdUser");
    String eliminar = request.getParameter("eliminar");
    String editar = request.getParameter("editar");
    String nomeNovo = request.getParameter("nomeNovo");
    String passNova = request.getParameter("passNova");
    String contactonovo = request.getParameter("contactonovo");
    String mailnovo = request.getParameter("emailnovo");
    


    if (sessionUser == null){
%>
        <script> alert ('Autentique-se Primeiro!') </script>
        <script>  setTimeout(function () { window.location.href = './logout.jsp'; }, 0)</script>
        <%
    }


    if ( eliminar != null ) {
        ResultSet checkAdminRs = null;
        ResultSet checkAdminCountRs = null;

        String checkAdminQuery = "SELECT * FROM user WHERE nomeUtilizador = '" + idUser + "' AND tipoUtilizador = 'admin'";
        String checkAdminCountQuery = "SELECT COUNT(*) AS adminCount FROM user WHERE tipoUtilizador = 'admin'";
        

        conexao = conn.createStatement();
        checkAdminRs = conexao.executeQuery(checkAdminQuery);
        
        //ver se o utilizador é admin
        if (checkAdminRs.next()) {
            isAdmin = true;
        }
        

        checkAdminCountRs = conexao.executeQuery(checkAdminCountQuery);
        //ver se só há 1 admin
        if (checkAdminCountRs.next() && checkAdminCountRs.getInt(1) == 1) {
            isAdminCountEqualsOne = true;
        }

        if ( isAdmin && isAdminCountEqualsOne ) {
            %>
            <script>alert('Não pode eliminar o admin sendo o único admin!');</script>
            <script>window.location.href = 'pag_utilizador.jsp';</script>
            <%
        } else {
            String selectHorarioQuery = "SELECT idHorario FROM bilhete WHERE nomeUtilizador = '" + idUser + "'";
            conexao = conn.createStatement();
            horarioRs = conexao.executeQuery(selectHorarioQuery);
            while (horarioRs.next()) {
                String idHorario = horarioRs.getString("idHorario");

                String updateHorarioQuery = "UPDATE horariorota SET bilhetesReservados = bilhetesReservados - 1 WHERE idHorario = '" + idHorario + "'";
                conexao = conn.createStatement();
                rowsAffected = conexao.executeUpdate(updateHorarioQuery);
                if ( rowsAffected == 0){
                    %>
                    <script>alert('Erro!');</script>
                    <script>window.location.href = 'pag_utilizador.jsp';</script>
                    <%
                }

                String deleteReservasQuery = "DELETE FROM bilhete WHERE nomeUtilizador = '" + idUser + "'";
                conexao = conn.createStatement();
                rowsAffected = conexao.executeUpdate(deleteReservasQuery);
                if ( rowsAffected == 0 ){
                    %>
                    <script>alert('Erro!');</script>
                    <script>window.location.href = 'pag_utilizador.jsp';</script>
                    <%
                }
            }

            String deleteCarteiraQuery = "DELETE FROM carteira WHERE nomeUtilizador = '" + idUser + "'";
            conexao = conn.createStatement();
            rowsAffected = conexao.executeUpdate(deleteCarteiraQuery);
            if ( rowsAffected == 0 ){
                %>
                <script>alert('Erro ao eliminar carteira do utilizador!');</script>
                <script>window.location.href = 'pag_utilizador.jsp';</script>
                <%
            } else {
                %>
                <script>alert('Utilizador Eliminado!');</script>
                <script>window.location.href = 'pag_utilizador.jsp';</script>
                <%
            }

            String deleteUserQuery = "DELETE FROM user WHERE nomeUtilizador = '" + idUser + "'";
            conexao = conn.createStatement();
            rowsAffected = conexao.executeUpdate(deleteUserQuery);
            if ( rowsAffected == 0 ){
                %>
                <script>alert('Erro ao eliminar utilizador!');</script>
                <script>window.location.href = 'pag_utilizador.jsp';</script>
                <%
            } else {
                %>
                <script>alert('Utilizador Eliminado!');</script>
                <script>window.location.href = 'pag_utilizador.jsp';</script>
                <%
            }

        }
    } else if ( editar != null ){
        String updateQuery = "UPDATE user SET ";
        boolean notEmpty = false;
        String oldNome = idUser;
        
        if ( nomeNovo != null && !nomeNovo.isEmpty() ) {
            updateQuery += "nomeUtilizador = '" + nomeNovo + "', ";
            notEmpty = true;
            if ( tipoUtilizador.equals("cliente") || tipoUtilizador.equals("funcionario") || (tipoUtilizador.equals("admin") && idUser.equals(sessionUser)) ){  
                session.setAttribute("user", nomeNovo);
            }
            if ( tipoUtilizador.equals("cliente") ) {
                String updateCliente = "UPDATE bilhete SET nomeUtilizador = '" + nomeNovo + "' WHERE nomeUtilizador = '" + oldNome + "'";
                conexao = conn.createStatement();
                rowsAffected = conexao.executeUpdate(updateCliente);
                String updateCarteira = "UPDATE carteira SET nomeUtilizador = '" + nomeNovo + "' WHERE nomeUtilizador = '" + oldNome + "'";
                conexao = conn.createStatement();
                rowsAffected = conexao.executeUpdate(updateCarteira);
            } else if (tipoUtilizador.equals("admin") && idUser.equals(sessionUser)) {
                
            } else if ( tipoUtilizador.equals("admin") ) {
                String updateCliente = "UPDATE bilhete SET nomeUtilizador = '" + nomeNovo + "' WHERE nomeUtilizador = '" + oldNome + "'";
                conexao = conn.createStatement();
                rowsAffected = conexao.executeUpdate(updateCliente);
                String updateCarteira = "UPDATE carteira SET nomeUtilizador = '" + nomeNovo + "' WHERE nomeUtilizador = '" + oldNome + "'";
                conexao = conn.createStatement();
                rowsAffected = conexao.executeUpdate(updateCarteira);
            }
        }

        if ( passNova != null && !passNova.isEmpty() ) {
            passNova = md5Hash(passNova);
            updateQuery += "pass = '" + passNova + "', ";
            notEmpty = true;
        }
        
        if ( contactonovo != null && !contactonovo.isEmpty() ) {
            updateQuery += "telemovel = '" + contactonovo + "', ";
            notEmpty = true;
        }

        if ( mailnovo != null && !mailnovo.isEmpty() ) {
            updateQuery += "email = '" + mailnovo + "', ";
            notEmpty = true;
        }

        if ( notEmpty ) {
            updateQuery = updateQuery.replaceAll(",\\s*$", "");
            updateQuery += " WHERE nomeUtilizador = '" + idUser + "'";
        }

        conexao = conn.createStatement();
        rowsAffected = conexao.executeUpdate(updateQuery);

        if (rowsAffected > 0) {
            conexao.close();
            %>
            <script>alert('Dados alterados com sucesso!');</script>
            <script>window.location.href = 'pag_utilizador.jsp';</script>
            <%

        } else {
            conexao.close();
            %>
            <script>alert('Erro ao atualizar utilizador!');</script>
            <script>window.location.href = 'pag_utilizador.jsp';</script>
            <%
        }
    } else {
        conexao.close();
        %>
        <script>alert('Nenhum campo preenchido! O utilizador não foi alterado.');</script>
        <script>window.location.href = 'pag_utilizador.jsp';</script>
        <%
    }
}

    %>

    <%!
        // Funcao para gerar hash md5
        private String md5Hash(String input) {
            try {
                MessageDigest md = MessageDigest.getInstance("MD5");
                byte[] digest = md.digest(input.getBytes("UTF-8"));

                StringBuilder sb = new StringBuilder();
                for (byte b : digest) {
                    sb.append(String.format("%02x", b & 0xff));
                }
                return sb.toString();
            } catch (Exception e) {
                e.printStackTrace();
            }
            return null;
    }

%>