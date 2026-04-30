CREATE DATABASE cadastro_Juan_Gabriel;
USE cadastro_Juan_Gabriel;

CREATE TABLE pessoa (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    est_civil VARCHAR(20),
    data_nascimento DATE,
    rg VARCHAR(15),
    cpf VARCHAR(15),
    endereco VARCHAR(150),
    cidade VARCHAR(100),
    bairro VARCHAR(100),
    telefone VARCHAR(20),
    salario DECIMAL(10,2)
);

CREATE TABLE conjuge (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    data_nascimento DATE,
    rg VARCHAR(15),
    cpf VARCHAR(15),
    local_trabalho VARCHAR(100),
    salario DECIMAL(10,2),
    id_pessoa INT,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id)
);

CREATE TABLE parente (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    tipo VARCHAR(50),
    telefone VARCHAR(20),
    id_pessoa INT,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id)
);

CREATE TABLE referencia_comercial (
    id INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100),
    telefone VARCHAR(20),
    cidade VARCHAR(100),
    id_pessoa INT,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id)
);

INSERT INTO pessoa (nome, est_civil, data_nascimento, rg, cpf, endereco, cidade, bairro, telefone, salario) VALUES
('Juan Gabriel', 'Solteiro', '1995-05-20', '1234567', '11122233344', 'Rua das Flores, 100', 'Curitiba', 'Centro', '41988887777', 3500.00),
('Bruno Souza', 'Casado', '1988-03-15', '9876543', '22233344455', 'Av. Brasil, 200', 'Londrina', 'Zona Sul', '43999996666', 4200.00),
('Carla Mendes', 'Casada', '1990-07-10', '4567890', '33344455566', 'Rua A, 50', 'Maringá', 'Zona Norte', '44988885555', 2800.00),
('Diego Costa', 'Casado', '2000-09-22', '1122334', '44455566677', 'Rua B, 400', 'Ponta Grossa', 'Centro', '42977776666', 2500.00),
('Eduarda Lima', 'Casada', '1998-12-05', '2233445', '55566677788', 'Av. Central, 300', 'Cascavel', 'Zona Oeste', '45966665555', 3900.00);

INSERT INTO conjuge (nome, data_nascimento, rg, cpf, local_trabalho, salario, id_pessoa) VALUES
('Camila Santos', '1997-08-25', '1122445', '55544433322', 'Supermercado Q', 3100.00, 1),
('Mariana Souza', '1991-11-05', '4455667', '88877766655', 'Comércio Y', 2500.00, 2),
('Ricardo Lima', '1985-02-20', '7788990', '77766655544', 'Oficina Z', 2700.00, 3),
('Fernanda Costa', '2002-09-01', '6655443', '66655544433', 'Loja ABC', 1800.00, 4),
('João Silva', '1994-04-10', '3322114', '99988877766', 'Empresa X', 3200.00, 5);

INSERT INTO parente (nome, tipo, telefone, id_pessoa) VALUES
('Rafael', 'Irmão', '41999999999', 1),
('Paula', 'Prima', '42988888888', 2),
('Lucas', 'Tio', '43977777777', 3),
('Helena', 'Amiga', '44966666666', 4),
('Marcos', 'Pai', '45955555555', 5);

INSERT INTO referencia_comercial (nome, telefone, cidade, id_pessoa) VALUES
('Loja do João', '41911112222', 'Curitiba', 1),
('Supermercado Real', '43933334444', 'Londrina', 2),
('Farmácia Vida', '44955556666', 'Maringá', 3),
('Padaria Central', '42977778888', 'Ponta Grossa', 4),
('Auto Peças Brasil', '45999990000', 'Cascavel', 5);

UPDATE conjuge SET salario = salario + 500 WHERE id = 1;
DELETE FROM parente WHERE id = 3;
DELETE FROM referencia_comercial WHERE id = 1;

SELECT id, nome FROM pessoa WHERE nome = 'Juan Gabriel';
SELECT p.nome AS Pessoa, c.nome AS Conjuge
FROM pessoa p
LEFT JOIN conjuge c ON p.id = c.id_pessoa;

ALTER TABLE pessoa ADD COLUMN cargo VARCHAR(50);
UPDATE pessoa SET cargo = 'Analista de Sistemas' WHERE nome = 'Juan Gabriel';

CREATE TABLE emprego_anterior (
    id INT AUTO_INCREMENT PRIMARY KEY,
    empresa VARCHAR(100),
    cargo VARCHAR(50),
    salario DECIMAL(10,2),
    id_pessoa INT,
    FOREIGN KEY (id_pessoa) REFERENCES pessoa(id)
);

INSERT INTO emprego_anterior (empresa, cargo, salario, id_pessoa) VALUES
('Empresa Alpha', 'Assistente', 1800.00, 1),
('TechBeta', 'Estagiário', 1200.00, 2),
('SoftDev', 'Analista Júnior', 2200.00, 3),
('InovaTech', 'Técnico de Suporte', 2000.00, 4),
('FuturaWeb', 'Desenvolvedor', 2500.00, 5);

SELECT p.nome, e.empresa, e.cargo
FROM pessoa p
INNER JOIN emprego_anterior e ON p.id = e.id_pessoa;
