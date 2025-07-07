<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.io.*, java.security.MessageDigest" %>
<%@ include file="../basedados/basedados.h"%>
<%
    Statement conexao = null;
    ResultSet rs = null;
    int up1 = 0;
    int up2 = 0;
    int up3 = 0;

    int idHorarioOld = 0;
    String user = (String) session.getAttribute("user");
    
    String idReserva = request.getParameter("idReserva");
    String formacao = request.getParameter("formacao");
    String aluno = request.getParameter("aluno");
    String idHorario = request.getParameter("idHorario");
    


    if (user == null ) {
        out.println("<script>alert('Autentique-se Primeiro!')</script>");
        out.println("<script>setTimeout(function () { window.location.href = './pag_principal.jsp'; }, 0)</script>");
    } else  {

        String checkReservaQuery = "SELECT * FROM reservaformacao WHERE nomeFormacao = '" + formacao + "' AND nomeUtilizador = '" + aluno + "' AND idHorario = '" + idHorario + "'";
        conexao = conn.createStatement();
        rs = conexao.executeQuery(checkReservaQuery);
        boolean temReserva = rs.next();

        String checkVagasQuery = "SELECT * FROM horarioformacao WHERE idHorario = '" + idHorario + "' AND inscricoes = limiteinscricoes";
        conexao = conn.createStatement();
        rs = conexao.executeQuery(checkVagasQuery);
        boolean NaoTemVaga = rs.next();


        if (temReserva) {
            out.println("<script>alert('O aluno já tem inscrição na formação e no horário');window.location.href = 'pag_gerirReservas.jsp';</script>");
        } else if (NaoTemVaga){
            out.println("<script>alert('De momento não há vagas para esta formação.');window.location.href = 'pag_gerirReservas.jsp';</script>");
        } else {
            String idHorarioQuery = "SELECT idHorario FROM reservaformacao WHERE idReserva = '" + idReserva + "'";
            conexao = conn.createStatement();
            rs = conexao.executeQuery(idHorarioQuery);

            if (rs.next()){
                idHorarioOld =  rs.getInt("idHorario");
            }
            out.println(idHorarioOld);
            String update1 = "UPDATE horarioformacao SET inscricoes = inscricoes - 1 WHERE idHorario = '" + idHorarioOld + "'";
            String update2 = "UPDATE reservaformacao SET nomeUtilizador = '" + aluno + "', nomeFormacao = '" + formacao + "', idHorario = '" + idHorario + "' WHERE idReserva = '" + idReserva + "'";
            String update3 = "UPDATE horarioformacao SET inscricoes = inscricoes + 1 WHERE idHorario = '" + idHorario + "'";
            conexao = conn.createStatement();
            up1 = conexao.executeUpdate(update1);
            up2 = conexao.executeUpdate(update2);
            up3 = conexao.executeUpdate(update3);
            

            if ( up1 > 0 && up2 > 0 && up3 > 0 ) {
                out.println("<script>alert('Reserva atualizada com sucesso!'); window.location.href = 'pag_utilizador.jsp';</script>");
            } else {
                out.println("<script>alert('Ocorreu um erro ao atualizar a reserva. Por favor, tente novamente mais tarde.');window.location.href = 'pag_utilizador.jsp';</script>");
            }
        
        
        }

    }
%>