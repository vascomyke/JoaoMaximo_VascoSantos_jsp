<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest " %>
<%@ include file="../basedados/basedados.h"%>
<html>
<head>
  <meta charset="utf-8">
  <title>Login</title>
</head>
<style>
	body {
    background-image: url(./imgs/fundoLogin.jpg);
    background-position: top center;
    background-size: cover;
}

	#loading{
		background-color:#A9F5A9;
		width:380px;
		height:50px;
		margin: 200px auto 0px;
		overflow:hidden;
		box-shadow:0px 0px 5px #6F6666;
		text-align:center;
		font: bold 20px/50px sans-serif;
		color: white;
	}
</style>
<body>
</body>
</html>  


<%
String user = (String) session.getAttribute("user");

if (user != null){
    out.println(" <script> alert ('Erro. Tente Novamente!') </script>");
    out.println("<script>  setTimeout(function () { window.location.href = './logout.jsp'; }, 0)</script>");
}

Statement conexao = null;
ResultSet rs = null;

if (request.getMethod().equals("POST")) {
    String nomeUtilizador = request.getParameter("user");
    String pass = md5Hash(request.getParameter("pass"));

    String sql = "SELECT * FROM user WHERE nomeUtilizador = '" +nomeUtilizador+ "' AND pass = '" +pass+ "'";
    conexao = conn.createStatement();
    rs = conexao.executeQuery(sql);

    if (rs.next()) {
        if (rs.getString("tipoUtilizador").equals("cliente_nao_validado")){
            out.println("<script> alert ('Conta Ainda Não validada!<br>Por favor, Tente mais tarde!') </script>");
            rs.close();
            conexao.close();
            out.println("<script>  setTimeout(function () { window.location.href = './logout.jsp'; }, 0)</script>");
        } else {
            session.setAttribute("user", rs.getString("nomeUtilizador"));
            session.setAttribute("tipoUtilizador", rs.getString("tipoUtilizador"));
            rs.close();
            conexao.close();
            out.println("<script>setTimeout(function () { window.location.href = 'pag_utilizador.jsp'; }, 0)</script>");
        }
    } else {
        rs.close();
        conexao.close();
        out.println("<script> alert ('Dados invalidos!') </script>");
        out.println(nomeUtilizador);
        out.println(pass);
        out.println("<script>setTimeout(function () { window.location.href = 'logout.jsp'; }, 20000)</script>");
    }
}

%>

<%!
// Função para gerar o hash MD5
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
