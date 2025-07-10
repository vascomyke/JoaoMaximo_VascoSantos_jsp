-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Tempo de geração: 10-Jul-2025 às 23:10
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
-- Banco de dados: `gestaoautocarros`
--
CREATE DATABASE gestaoautocarros;
USE gestaoautocarros;
-- --------------------------------------------------------

--
-- Estrutura da tabela `bilhete`
--

CREATE TABLE `bilhete` (
  `idBilhete` int(10) NOT NULL,
  `idHorario` int(10) NOT NULL,
  `nomeUtilizador` varchar(100) NOT NULL,
  `preco` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Estrutura da tabela `carteira`
--

CREATE TABLE `carteira` (
  `idCarteira` int(11) NOT NULL,
  `nomeUtilizador` varchar(100) NOT NULL,
  `saldo` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `carteira`
--

INSERT INTO `carteira` (`idCarteira`, `nomeUtilizador`, `saldo`) VALUES
(2, 'FelixBus', 1000),
(13, 'cliente', 10);

-- --------------------------------------------------------

--
-- Estrutura da tabela `horariorota`
--

CREATE TABLE `horariorota` (
  `idHorario` int(10) NOT NULL,
  `idRota` int(10) NOT NULL,
  `horario` varchar(100) NOT NULL,
  `bilhetesReservados` int(10) NOT NULL,
  `limiteBilhetes` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `horariorota`
--

INSERT INTO `horariorota` (`idHorario`, `idRota`, `horario`, `bilhetesReservados`, `limiteBilhetes`) VALUES
(1, 1, 'Dia 05 : Quinta-Feira : 15:00h', 0, 40),
(2, 1, 'Dia 02 : Segunda-Feira : 10:00h', 0, 49),
(3, 2, 'Dia 04 : Quarta-Feira : 14:30h', 0, 40),
(4, 2, 'Dia 03 : Terça-Feira : 11:00h', 0, 49),
(5, 3, 'Dia 02 : Segunda-Feira : 17:00h', 0, 49),
(6, 3, 'Dia 03 : Terça-Feira : 16:00h', 0, 49),
(7, 4, 'Dia 06 : Sexta-Feira : 10:00h', 0, 40),
(8, 4, 'Dia 04 : Quarta-Feira : 19:00h', 0, 49),
(9, 5, 'Dia 05 : Quinta-Feira : 18:00h', 0, 49),
(10, 5, 'Dia 02 : Segunda-Feira : 19:00h', 0, 40);

-- --------------------------------------------------------

--
-- Estrutura da tabela `rota`
--

CREATE TABLE `rota` (
  `idRota` int(10) NOT NULL,
  `origem` varchar(60) NOT NULL,
  `destino` varchar(60) NOT NULL,
  `preco` int(10) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Extraindo dados da tabela `rota`
--

INSERT INTO `rota` (`idRota`, `origem`, `destino`, `preco`) VALUES
(1, 'Castelo Branco', 'Coimbra', 9),
(2, 'Lisboa', 'Castelo Branco', 12),
(3, 'Coimbra', 'Porto', 12),
(4, 'Castelo Branco', 'Aveiro', 11),
(5, 'Évora', 'Santarém', 11);

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
('admin', '21232f297a57a5a743894a0e4a801fc3', 'admin@admin', 1234, 'admin'),
('cliente', '4983a0ab83ed86e0e7213c8783940193', 'cliente@gmail.com', 96000123, 'cliente'),
('funcionario', 'cc7a84634199040d54376793842fe035', 'funcionario@gmail.com', 960000002, 'funcionario');

--
-- Índices para tabelas despejadas
--

--
-- Índices para tabela `bilhete`
--
ALTER TABLE `bilhete`
  ADD PRIMARY KEY (`idBilhete`);

--
-- Índices para tabela `carteira`
--
ALTER TABLE `carteira`
  ADD PRIMARY KEY (`idCarteira`);

--
-- Índices para tabela `horariorota`
--
ALTER TABLE `horariorota`
  ADD PRIMARY KEY (`idHorario`);

--
-- Índices para tabela `rota`
--
ALTER TABLE `rota`
  ADD PRIMARY KEY (`idRota`);

--
-- Índices para tabela `user`
--
ALTER TABLE `user`
  ADD PRIMARY KEY (`nomeUtilizador`);

--
-- AUTO_INCREMENT de tabelas despejadas
--

--
-- AUTO_INCREMENT de tabela `bilhete`
--
ALTER TABLE `bilhete`
  MODIFY `idBilhete` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=27;

--
-- AUTO_INCREMENT de tabela `carteira`
--
ALTER TABLE `carteira`
  MODIFY `idCarteira` int(11) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT de tabela `horariorota`
--
ALTER TABLE `horariorota`
  MODIFY `idHorario` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT de tabela `rota`
--
ALTER TABLE `rota`
  MODIFY `idRota` int(10) NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
