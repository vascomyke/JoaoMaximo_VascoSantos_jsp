<%@ page contentType="text/html;charset=UTF-8" language="java" %>

<html>
<head>
<style>
	body{
		background-image:url(./imgs/fundoLogin.jpg);
		background-position: top center;
	}
</style>
<body>
</body>
</head>
</html>  

<%
	if (session != null) {
        // invalida sessao
        session.invalidate();
    }
	response.sendRedirect("./pag_principal.jsp");
%>