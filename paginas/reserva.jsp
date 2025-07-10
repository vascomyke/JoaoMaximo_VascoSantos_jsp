<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*" %>
<%@ include file="../basedados/basedados.h" %>

<%
String sessionUser = (String) session.getAttribute("user");

if (sessionUser == null) {
%>
    <script>
        alert('Autentique-se primeiro!');
        window.location.href = 'pag_utilizador.jsp';
    </script>
<%
} else {
    String cliente = request.getParameter("cliente");
    String rota = request.getParameter("idRota");
    String idHorario = request.getParameter("idhorario");
    String editar = request.getParameter("editar");
    boolean isEditar = (editar != null && !editar.isEmpty());
    
    Statement stmt = null;
    ResultSet rs = null;
    
    try {
        // Verificar se existem reservas prévias para a mesma data e hora
        String checkReservaQuery = "SELECT * FROM bilhete WHERE idHorario = '" + idHorario + "' AND nomeUtilizador = '" + cliente + "'";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(checkReservaQuery);
        boolean temReserva = rs.next();
        rs.close();
        stmt.close();
        
        // Verificar se há vagas disponíveis
        String checkVagasQuery = "SELECT * FROM horariorota WHERE idHorario = '" + idHorario + "' AND bilhetesReservados = limiteBilhetes";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(checkVagasQuery);
        boolean naoTemVaga = rs.next();
        rs.close();
        stmt.close();
        
        // Obter preço da rota
        String precoQuery = "SELECT preco FROM rota WHERE idRota = '" + rota + "'";
        stmt = conn.createStatement();
        rs = stmt.executeQuery(precoQuery);
        
        double preco = 0.0;
        if (rs.next()) {
            preco = rs.getDouble("preco");
        } else {
%>
            <script>
                alert('Erro ao obter o preço. Tente mais tarde!');
                window.location.href = 'pag_novaReserva.jsp';
            </script>
<%
            return;
        }
        rs.close();
        stmt.close();
        
        // Se estiver a editar
        if (isEditar) {
            String bilhete = request.getParameter("bilhete");
            
            // Obter dados do bilhete antigo
            String oldPrecoQuery = "SELECT preco, idHorario, nomeUtilizador FROM bilhete WHERE idBilhete = '" + bilhete + "'";
            stmt = conn.createStatement();
            rs = stmt.executeQuery(oldPrecoQuery);
            
            if (rs.next()) {
                double oldPreco = rs.getDouble("preco");
                String oldidHorario = rs.getString("idHorario");
                String oldUtilizador = rs.getString("nomeUtilizador");
                
                rs.close();
                stmt.close();
                
                // Adicionar o saldo de volta ao cliente
                String updateQuery1 = "UPDATE carteira SET saldo = saldo + " + oldPreco + " WHERE nomeUtilizador = '" + oldUtilizador + "'";
                stmt = conn.createStatement();
                stmt.executeUpdate(updateQuery1);
                stmt.close();
                
                // Remover o saldo de FelixBus
                String updateQuery2 = "UPDATE carteira SET saldo = saldo - " + oldPreco + " WHERE nomeUtilizador = 'FelixBus'";
                stmt = conn.createStatement();
                stmt.executeUpdate(updateQuery2);
                stmt.close();
                
                // Apagar o bilhete antigo
                String deleteQuery = "DELETE FROM bilhete WHERE idBilhete = '" + bilhete + "'";
                stmt = conn.createStatement();
                stmt.executeUpdate(deleteQuery);
                stmt.close();
                
                // Atualizar o número de bilhetes reservados
                String decreaseQuery = "UPDATE horariorota SET bilhetesReservados = bilhetesReservados - 1 WHERE idHorario = '" + oldidHorario + "'";
                stmt = conn.createStatement();
                stmt.executeUpdate(decreaseQuery);
                stmt.close();
            }
        }
        
        // Verificar se o cliente tem saldo suficiente
        String checkSaldo = "SELECT saldo FROM carteira WHERE nomeUtilizador = '" + cliente + "' AND saldo >= " + preco;
        stmt = conn.createStatement();
        rs = stmt.executeQuery(checkSaldo);
        boolean temSaldo = rs.next();
        rs.close();
        stmt.close();
        
        // Validações
        if (temReserva && !isEditar) {
%>
            <script>
                alert('Já possui bilhete para este horário');
                window.location.href = 'pag_novaReserva.jsp';
            </script>
<%
        } else if (naoTemVaga) {
%>
            <script>
                alert('De momento não há vagas para este horário.');
                window.location.href = 'pag_novaReserva.jsp';
            </script>
<%
        } else if (!temSaldo) {
%>
            <script>
                alert('Adicione saldo para fazer esta operação.');
                window.location.href = 'pag_utilizador.jsp';
            </script>
<%
        } else {
            // Inserir nova reserva
            String sql = "INSERT INTO bilhete (idBilhete, idHorario, nomeUtilizador, preco) VALUES (NULL, '" + idHorario + "', '" + cliente + "', " + preco + ")";
            
            String updateQuery = "UPDATE horariorota SET bilhetesReservados = bilhetesReservados + 1 WHERE idHorario = '" + idHorario + "'";
            
            String updateCarteiraQuery = "UPDATE carteira SET saldo = saldo - " + preco + " WHERE nomeUtilizador = '" + cliente + "'";
            
            // Adicionar preço à carteira de FelixBus
            String addFelixBusQuery = "UPDATE carteira SET saldo = saldo + " + preco + " WHERE nomeUtilizador = 'FelixBus'";
            
            // Executar todas as queries
            boolean success = true;
            
            try {
                stmt = conn.createStatement();
                stmt.executeUpdate(updateQuery);
                stmt.close();
                
                stmt = conn.createStatement();
                stmt.executeUpdate(sql);
                stmt.close();
                
                stmt = conn.createStatement();
                stmt.executeUpdate(updateCarteiraQuery);
                stmt.close();
                
                stmt = conn.createStatement();
                stmt.executeUpdate(addFelixBusQuery);
                stmt.close();
                
            } catch (SQLException e) {
                success = false;
                e.printStackTrace();
            }
            
            if (success) {
%>
                <script>
                    alert('Bilhete comprado com sucesso!');
                    window.location.href = 'pag_utilizador.jsp';
                </script>
<%
            } else {
%>
                <script>
                    alert('Ocorreu um erro ao realizar a reserva. Por favor, tente novamente mais tarde.');
                    window.location.href = 'pag_utilizador.jsp';
                </script>
<%
            }
        }
        
    } catch (SQLException e) {
        e.printStackTrace();
%>
        <script>
            alert('Erro de base de dados. Tente novamente mais tarde.');
            window.location.href = 'pag_utilizador.jsp';
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