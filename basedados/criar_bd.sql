-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 12-Jun-2024 às 10:35
-- Versão do servidor: 10.4.32-MariaDB
-- versão do PHP: 8.2.12

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Banco de dados: `gestaocursos`
--
CREATE DATABASE gestaocursos;
USE gestaocursos;
-- --------------------------------------------------------

--
-- Estrutura da tabela `formacao`
--

CREATE TABLE `formacao` (
  `nomeFormacao` varchar(100) NOT NULL,
  `docente` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `formacao`
--

INSERT INTO `formacao` (`nomeFormacao`, `docente`) VALUES
('gestaoRedesSociais', 'docente'),
('operadorInformatica', 'docente'),
('operadorLogistica', 'docente'),
('pintorConstrucaoCivil', 'docente');

-- --------------------------------------------------------

--
-- Estrutura da tabela `horarioformacao`
--

CREATE TABLE `horarioformacao` (
  `idHorario` int(11) NOT NULL,
  `nomeFormacao` varchar(100) NOT NULL,
  `horario` varchar(100) NOT NULL,
  `inscricoes` int(100) NOT NULL,
  `limiteinscricoes` int(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `horarioformacao`
--

INSERT INTO `horarioformacao` (`idHorario`, `nomeFormacao`, `horario`, `inscricoes`, `limiteinscricoes`) VALUES
(1, 'operadorLogistica', 'Segunda-Feira : 10:00h', 0, 20),
(2, 'operadorLogistica', 'Quarta-Feira : 14:00h', 0, 20),
(3, 'pintorConstrucaoCivil', 'Terça-Feira : 11:00h', 0, 20),
(4, 'pintorConstrucaoCivil', 'Quinta-Feira : 16:00h', 0, 20),
(5, 'gestaoRedesSociais', 'Quarta-Feira : 16:00h', 0, 20),
(6, 'gestaoRedesSociais', 'Sexta-Feira : 17:00h', 0, 20),
(7, 'operadorInformatica', 'Segunda-Feira : 14:00h', 0, 1),
(8, 'operadorInformatica', 'Quinta-Feira : 10:00h', 0, 20);

-- --------------------------------------------------------

--
-- Estrutura da tabela `reservaformacao`
--

CREATE TABLE `reservaformacao` (
  `idReserva` int(100) NOT NULL,
  `nomeUtilizador` varchar(100) NOT NULL,
  `nomeFormacao` varchar(100) NOT NULL,
  `docente` varchar(100) NOT NULL,
  `idHorario` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `user`
--

CREATE TABLE `user` (
  `nomeUtilizador` varchar(100) NOT NULL,
  `pass` varchar(100) NOT NULL,
  `email` varchar(150) NOT NULL,
  `telemovel` int(15) NOT NULL,
  `tipoUtilizador` varchar(30) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `user`
--

INSERT INTO `user` (`nomeUtilizador`, `pass`, `email`, `telemovel`, `tipoUtilizador`) VALUES
('admin', '21232f297a57a5a743894a0e4a801fc3', 'admin@gmail.com', 123456789, 'admin'),
('aluno', 'ca0cd09a12abade3bf0777574d9f987f', 'aluno@gmail.com', 960000000, 'aluno'),
('docente', 'ac99fecf6fcb8c25d18788d14a5384ee', 'docente@gmail.com', 987987987, 'docente');

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `formacao`
--
ALTER TABLE `formacao`
  ADD PRIMARY KEY (`nomeFormacao`);

--
-- Índices para tabela `horarioformacao`
--
ALTER TABLE `horarioformacao`
  ADD PRIMARY KEY (`idHorario`);

--
-- Índices para tabela `reservaformacao`
--
ALTER TABLE `reservaformacao`
  ADD PRIMARY KEY (`idReserva`);

--
-- Índices para tabela `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`nomeUtilizador`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `horarioformacao`
--
ALTER TABLE `horarioformacao`
  MODIFY `idHorario` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT de tabela `reservaformacao`
--
ALTER TABLE `reservaformacao`
  MODIFY `idReserva` int(100) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=21;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
