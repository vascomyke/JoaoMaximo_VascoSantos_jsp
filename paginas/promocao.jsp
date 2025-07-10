<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="../basedados/basedados.h" %>

<%
// Check if user is logged in
String sessionUser = (String) session.getAttribute("user");
if(sessionUser != null) {
    String idUser = request.getParameter("IdUser");
    String tipoUtilizador = request.getParameter("tipo");
    
    Statement stmt = null;
    ResultSet rs = null;
    String sql = null;
    
    try {
        stmt = conn.createStatement();
        
        // Check if despromover button was clicked
        if (request.getParameter("despromover") != null) {
            if ("funcionario".equals(tipoUtilizador)) {
                sql = "UPDATE user SET tipoUtilizador = 'cliente' WHERE nomeUtilizador = '" + idUser + "'";
                String insertSql = "INSERT INTO carteira (nomeUtilizador, saldo) VALUES ('" + idUser + "', 0)";
                stmt.executeUpdate(insertSql);
            } else if ("admin".equals(tipoUtilizador)) {
                session.setAttribute("userId", idUser);
                
                String checkAdminQuery = "SELECT * FROM user WHERE nomeUtilizador = '" + idUser + "' AND tipoUtilizador = 'admin'";
                String checkAdminCountQuery = "SELECT * FROM user WHERE tipoUtilizador = 'admin'";
                
                ResultSet checkAdmin = stmt.executeQuery(checkAdminQuery);
                ResultSet checkAdminCount = stmt.executeQuery(checkAdminCountQuery);
                
                int adminCount = 0;
                while(checkAdminCount.next()) {
                    adminCount++;
                }
                
                if (checkAdmin.next() && adminCount == 1) {
%>
                    <script>
                        alert('Não pode eliminar o admin sendo o único admin!');
                        window.location.href = 'pag_gestUtilizadores.jsp';
                    </script>
<%
                    return;
                } else {
                    sql = "UPDATE user SET tipoUtilizador = 'funcionario' WHERE nomeUtilizador = '" + idUser + "'";
                }
                
            } else if ("cliente".equals(tipoUtilizador)) {
%>
                <script>
                    alert('Impossível despromover cliente!');
                    setTimeout(function() { 
                        window.location.href = './pag_gestUtilizadores.jsp'; 
                    }, 0);
                </script>
<%
                return;
            }
            
        // Check if promover button was clicked
        } else if (request.getParameter("promover") != null) {
            if ("funcionario".equals(tipoUtilizador)) {
                sql = "UPDATE user SET tipoUtilizador = 'admin' WHERE nomeUtilizador = '" + idUser + "'";
                
            } else if ("cliente".equals(tipoUtilizador)) {
                sql = "UPDATE user SET tipoUtilizador = 'funcionario' WHERE nomeUtilizador = '" + idUser + "'";
                
                // Delete from carteira
                String sql2 = "DELETE FROM carteira WHERE nomeUtilizador = '" + idUser + "'";
                
                // Get all idhorario occurrences from bilhete table for the specific user
                String sqlSelect = "SELECT idhorario FROM bilhete WHERE nomeUtilizador = '" + idUser + "'";
                ResultSet result = stmt.executeQuery(sqlSelect);
                
                if (result != null) {
                    // For each idhorario found, decrease bilhetereservado count in horariorota table
                    while (result.next()) {
                        String idhorario = result.getString("idhorario");
                        
                        // Decrease bilhetesReservados by 1 for this specific idhorario
                        String sqlUpdate = "UPDATE horariorota SET bilhetesReservados = bilhetesReservados - 1 WHERE idhorario = '" + idhorario + "'";
                        
                        Statement updateStmt = conn.createStatement();
                        int rowsAffected = updateStmt.executeUpdate(sqlUpdate);
                        if (rowsAffected <= 0) {
                            out.println("Error updating horariorota for idhorario " + idhorario);
                        }
                        updateStmt.close();
                    }
                }
                
                // Delete from bilhete
                String sql3 = "DELETE FROM bilhete WHERE nomeUtilizador = '" + idUser + "'";
                
                // Execute the delete operations
                Statement deleteStmt = conn.createStatement();
                if (deleteStmt.executeUpdate(sql2) >= 0 && deleteStmt.executeUpdate(sql3) >= 0) {
                    out.println("Funcionario promovido");
                }
                deleteStmt.close();
                
            } else if ("admin".equals(tipoUtilizador)) {
%>
                <script>
                    alert('Impossível promover administrador!');
                    setTimeout(function() { 
                        window.location.href = './pag_gestUtilizadores.jsp'; 
                    }, 0);
                </script>
<%
                return;
            }
        }
        
        // Execute the main SQL update if it was set
        if (sql != null && !sql.isEmpty()) {
            int result = stmt.executeUpdate(sql);
            if (result > 0) {
                out.println("Utilizador (des)promovido com sucesso!");
%>
                <script>
                    setTimeout(function() { 
                        window.location.href = 'pag_gestUtilizadores.jsp'; 
                    }, 0);
                </script>
<%
            } else {
                out.println("Erro ao (des)promover utilizador");
            }
        }
        
    } catch(SQLException e) {
        out.println("Erro ao (des)promover utilizador: " + e.getMessage());
    } finally {
        if(rs != null) try { rs.close(); } catch(SQLException e) {}
        if(stmt != null) try { stmt.close(); } catch(SQLException e) {}
    }
    
} else {
%>
    <script>
        setTimeout(function(){ 
            window.location.href = './logout.jsp'; 
        }, 0);
    </script>
<%
}

// Close connection if it exists
if(conn != null) {
    try { 
        conn.close(); 
    } catch(SQLException e) {
        out.println("Error closing connection: " + e.getMessage());
    }
}
%>