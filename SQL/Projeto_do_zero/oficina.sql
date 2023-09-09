CREATE SCHEMA oficina;
USE oficina;

CREATE TABLE Clientes (
    ClienteID INT PRIMARY KEY,
    Nome VARCHAR(100) NOT NULL,
    CPF_CNPJ VARCHAR(20) UNIQUE NOT NULL
);

CREATE TABLE Veiculos (
    VeiculoID INT PRIMARY KEY,
    ClienteID INT,
    Modelo VARCHAR(50) NOT NULL,
    Ano INT NOT NULL,
    FOREIGN KEY (ClienteID) REFERENCES Clientes(ClienteID)
);

CREATE TABLE Servicos (
    ServicoID INT PRIMARY KEY,
    Descricao VARCHAR(200) NOT NULL,
    Preco DECIMAL(10, 2) NOT NULL
);

CREATE TABLE Atendimentos (
    AtendimentoID INT PRIMARY KEY,
    VeiculoID INT,
    ServicoID INT,
    Data DATE NOT NULL,
    FOREIGN KEY (VeiculoID) REFERENCES Veiculos(VeiculoID),
    FOREIGN KEY (ServicoID) REFERENCES Servicos(ServicoID)
);


-- Inserir dados na tabela Clientes
INSERT INTO Clientes (ClienteID, Nome, CPF_CNPJ)
VALUES
    (1, 'João da Silva', '123.456.789-01'),
    (2, 'Maria Pereira', '987.654.321-09'),
    (3, 'José Santos', '555.555.555-55');

-- Inserir dados na tabela Veiculos
INSERT INTO Veiculos (VeiculoID, ClienteID, Modelo, Ano)
VALUES
    (1, 1, 'Toyota Corolla', 2020),
    (2, 2, 'Honda Civic', 2019),
    (3, 3, 'Volkswagem Golf', 2018);

-- Inserir dados na tabela Servicos
INSERT INTO Servicos (ServicoID, Descricao, Preco)
VALUES
    (1, 'Troca de óleo', 50.00),
    (2, 'Alinhamento de rodas', 80.00),
    (3, 'Revisão completa', 200.00);

-- Inserir dados na tabela Atendimentos
INSERT INTO Atendimentos (AtendimentoID, VeiculoID, ServicoID, Data)
VALUES
    (1, 1, 1, '2023-01-15'),
    (2, 2, 2, '2023-02-20'),
    (3, 3, 3, '2023-03-25');


-- Qual veículo de cada cliente?
SELECT c.Nome, v.Modelo
FROM Clientes c
LEFT JOIN Veiculos v ON c.ClienteID = v.ClienteID;

-- Qual valor do gasto total por cliente?
SELECT c.Nome, SUM(s.Preco) AS TotalGasto
FROM Clientes c
LEFT JOIN Veiculos v ON c.ClienteID = v.ClienteID
LEFT JOIN Atendimentos a ON v.VeiculoID = a.VeiculoID
LEFT JOIN Servicos s ON a.ServicoID = s.ServicoID
GROUP BY c.Nome;

-- Clientes que gastaram 200 reais ou mais
SELECT c.Nome, SUM(s.Preco) AS TotalGasto
FROM Clientes c
LEFT JOIN Veiculos v ON c.ClienteID = v.ClienteID
LEFT JOIN Atendimentos a ON v.VeiculoID = a.VeiculoID
LEFT JOIN Servicos s ON a.ServicoID = s.ServicoID
GROUP BY c.Nome
HAVING TotalGasto >= 200;

-- nome do cliente e modelo do veículo com base no ano
SELECT c.Nome, v.Modelo,
    CASE WHEN v.Ano >= 2020 THEN 'Novo' ELSE 'Antigo' END AS Status
FROM Clientes c
INNER JOIN Veiculos v ON c.ClienteID = v.ClienteID;

