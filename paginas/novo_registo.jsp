<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest" %>
<%@ include file="../basedados/basedados.h"%>
<%

Statement conexao = null;

if ("POST".equals(request.getMethod()) && request.getParameter("user") == null) {
    response.sendRedirect("pag_principal.jsp");
    return;
}

String user = (String) session.getAttribute("user");

String tipoUtilizador = "";
String sql = "SELECT tipoUtilizador FROM user WHERE nomeUtilizador = '" + user + "'";
        
// Execute the query
Statement stmt = conn.createStatement();
ResultSet rs = stmt.executeQuery(sql);

// Retrieve tipoUtilizador
if (rs.next()) {
    tipoUtilizador = rs.getString("tipoUtilizador");
}




try {
    if (request.getMethod().equals("POST")) {
        String nomeUtilizador = request.getParameter("user");
        String pass = request.getParameter("pass");
        String telemovel = request.getParameter("contacto");
        String email = request.getParameter("email");

        // Verificcar se nome ja existe na base de dados
        sql = "SELECT * FROM user WHERE nomeUtilizador = '" + nomeUtilizador + "'";
        conexao = conn.createStatement();
        ResultSet result = conexao.executeQuery(sql);
        //out.println(user + tipoUtilizador);

        if(result.next()) {
            out.println(" <script> alert ('Erro! O nome de utilizador já está em uso. Tente Novamente!') </script>");
            out.println("<script>  setTimeout(function () { window.location.href = './pag_registo.jsp'; }, 0)</script>");
            result.close();
            conexao.close();
            conn.close();
            return;
        } else {
            if (user == null){
                sql = "INSERT INTO carteira (`nomeUtilizador`, `saldo`) VALUES ('" + nomeUtilizador + "',0);";
                int rowsAffected = conexao.executeUpdate(sql);
                
                sql = "INSERT INTO user (`nomeUtilizador`, `telemovel`, `email`, `pass`, `tipoUtilizador`) VALUES ('" + nomeUtilizador + "','" + telemovel + "','" + email + "','" + md5Hash(pass) + "','" + "cliente_nao_validado" + "');";
                rowsAffected = conexao.executeUpdate(sql);


                if (rowsAffected > 0){
                    out.println("<script> alert ('Utilizador Criado!') </script>");
                    out.println("<script>  setTimeout(function () { window.location.href = './pag_utilizador.jsp'; }, 0)</script>");
                } else {
                    out.println("<script> alert ('Erro! Tente Novamente.') </script>");
                    out.println("<script>  setTimeout(function () { window.location.href = './pag_registo.jsp'; }, 0)</script>");
                }
            } else if (user != null && tipoUtilizador.equals("admin")){
                //out.println(user);
                sql = "INSERT INTO user (`nomeUtilizador`, `telemovel`, `email`, `pass`, `tipoUtilizador`) VALUES ('" + nomeUtilizador + "','" + telemovel + "','" + email + "','" + md5Hash(pass) + "','" + "aluno" + "');";
                int rowsAffected = conexao.executeUpdate(sql);
                //out.println(rowsAffected);
                if (rowsAffected > 0){
                    out.println("<script> alert ('Utilizador Criado!') </script>");
                    out.println("<script>  setTimeout(function () { window.location.href = './pag_utilizador.jsp'; }, 0)</script>");
                } else {
                    out.println("<script> alert ('Erro! Tente Novamente.') </script>");
                    out.println("<script>  setTimeout(function () { window.location.href = './pag_registo.jsp'; }, 0)</script>");
                }
            }
        }
    }
} catch (Exception e) {
    out.println("Error: " + e.getMessage());
} finally {
    fecharConexao(conn, conexao, null);
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

