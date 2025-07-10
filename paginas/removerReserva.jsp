<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="../basedados/basedados.h" %>

<%
String sessionUser = (String) session.getAttribute("user");

if (sessionUser != null) {
    String idBilhete = request.getParameter("idBilhete");
    String idHorario = request.getParameter("idHorario");
    
    Statement stmt = null;
    ResultSet rs = null;
    
    try {
        // Get preco e nomeUtilizador do bilhete antes de eliminar
        String getInfoSql = "SELECT preco, nomeUtilizador FROM bilhete WHERE idBilhete = " + idBilhete;
        stmt = conn.createStatement();
        rs = stmt.executeQuery(getInfoSql);
        
        if (rs.next()) {
            double preco = rs.getDouble("preco");
            String nomeUtilizador = rs.getString("nomeUtilizador");
            
            rs.close();
            stmt.close();
            
            // Dar refund do preco ao utilizador
            String updateCarteiraSql = "UPDATE carteira SET saldo = saldo + " + preco + " WHERE nomeUtilizador = '" + nomeUtilizador + "'";
            stmt = conn.createStatement();
            stmt.executeUpdate(updateCarteiraSql);
            stmt.close();
            
            // Deduzir preco da carteira de FelixBus
            String deduzirFelixBusSql = "UPDATE carteira SET saldo = saldo - " + preco + " WHERE nomeUtilizador = 'FelixBus'";
            stmt = conn.createStatement();
            stmt.executeUpdate(deduzirFelixBusSql);
            stmt.close();
        }
        
        // Remover o bilhete
        String removerSql = "DELETE FROM bilhete WHERE idBilhete = " + idBilhete;
        stmt = conn.createStatement();
        int deletedRows = stmt.executeUpdate(removerSql);
        stmt.close();
        
        // Atualizar o número de bilhetes reservados
        String updateQuery = "UPDATE horariorota SET bilhetesReservados = bilhetesReservados - 1 WHERE idHorario = '" + idHorario + "'";
        stmt = conn.createStatement();
        int updatedRows = stmt.executeUpdate(updateQuery);
        stmt.close();
        
        if (deletedRows > 0 && updatedRows > 0) {
%>
            <script>
                alert('Reserva removida!');
                setTimeout(function() { 
                    window.location.href = 'pag_gerirReservas.jsp'; 
                }, 0);
            </script>
<%
        } else {
%>
            <script>
                alert('Erro ao remover reserva!');
                setTimeout(function() { 
                    window.location.href = 'pag_gerirReservas.jsp'; 
                }, 0);
            </script>
<%
        }
        
    } catch (SQLException e) {
        e.printStackTrace();
%>
        <script>
            alert('Erro ao remover reserva!');
            setTimeout(function() { 
                window.location.href = 'pag_gerirReservas.jsp'; 
            }, 0);
        </script>
<%
    } finally {
        // Fechar recursos
        if (rs != null) {
            try { rs.close(); } catch (SQLException e) { }
        }
        if (stmt != null) {
            try { stmt.close(); } catch (SQLException e) { }
        }
    }
}
%>