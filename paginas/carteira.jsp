<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest" %>
<%@ include file="../basedados/basedados.h" %>

<%
    // Check if user is logged in
    String user = (String) session.getAttribute("user");
    
    if (user != null) {
        String cliente = request.getParameter("cliente");
        String valorStr = request.getParameter("valor");
        
        if (cliente != null && valorStr != null) {
            double valor = Double.parseDouble(valorStr);
            
            Statement stmt = null;
            ResultSet rs = null;
            
            try {
                stmt = conn.createStatement();
                
                if (request.getParameter("levantar") != null) {
                    // Ver se utilizador tem saldo suficiente
                    String checkSaldoQuery = "SELECT * FROM carteira WHERE nomeUtilizador = '" + cliente + "' AND saldo < " + valor;
                    rs = stmt.executeQuery(checkSaldoQuery);
                    
                    if (rs.next()) {
                        // Saldo Insuficiente
                        %>
                        <script>
                            alert('Não tem saldo suficiente para esta operação!');
                            window.location.href = 'pag_utilizador.jsp';
                        </script>
                        <%
                    } else {
                        // Update saldo - lenvantamento
                        String updateSaldoQuery = "UPDATE carteira SET saldo = saldo - " + valor + " WHERE nomeUtilizador = '" + cliente + "'";
                        
                        int rowsAffected = stmt.executeUpdate(updateSaldoQuery);
                        
                        if (rowsAffected == 0) {
                            application.log("Erro ao levantar! Tente novamente mais tarde.");
                        } else {
                            %>
                            <script>
                                alert('Sucesso! Levantou <%= valor %> €');
                                window.location.href = 'pag_carteira.jsp';
                            </script>
                            <%
                        }
                    }
                    
                } else if (request.getParameter("depositar") != null) {
                    // Update saldo - deposito
                    String updateSaldoQuery = "UPDATE carteira SET saldo = saldo + " + valor + " WHERE nomeUtilizador = '" + cliente + "'";
                    
                    int rowsAffected = stmt.executeUpdate(updateSaldoQuery);
                    
                    if (rowsAffected == 0) {
                        // Log error
                        application.log("Erro ao depositar! Tente novamente mais tarde.");
                    } else {
                        %>
                        <script>
                            alert('Sucesso! Depositou <%= valor %> €');
                            window.location.href = 'pag_carteira.jsp';
                        </script>
                        <%
                    }
                }
                
            } catch (SQLException e) {
                application.log("Database error: " + e.getMessage());
                e.printStackTrace();
            } catch (NumberFormatException e) {
                application.log
                ("Invalid number format: " + e.getMessage());
            } finally {
                // Clean up resources
                if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (stmt != null) try { stmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    } else {
        // User not logged in - redirect to logout
        %>
        <script>
            setTimeout(function(){ window.location.href = './logout.jsp'; }, 0);
        </script>
        <%
    }
%>

<script>
    window.location.href = 'pag_utilizador.jsp';
</script>