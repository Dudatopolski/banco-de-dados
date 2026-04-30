CREATE DATABASE IF NOT EXISTS sistema_biblioteca
CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

USE sistema_biblioteca;

-- =========================================
-- REMOVER TABELAS SE JÁ EXISTIREM
-- =========================================
DROP TABLE IF EXISTS multas;
DROP TABLE IF EXISTS reservas;
DROP TABLE IF EXISTS emprestimos;
DROP TABLE IF EXISTS exemplares;
DROP TABLE IF EXISTS livro_autor;
DROP TABLE IF EXISTS livros;
DROP TABLE IF EXISTS autores;
DROP TABLE IF EXISTS editoras;
DROP TABLE IF EXISTS categorias;
DROP TABLE IF EXISTS usuarios;

-- =========================================
-- TABELA DE USUÁRIOS
-- ADMIN e ALUNO
-- =========================================
CREATE TABLE usuarios (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    usuario VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(150) NOT NULL UNIQUE,
    senha VARCHAR(255) NOT NULL,
    perfil ENUM('ADMIN', 'ALUNO') NOT NULL,
    cpf VARCHAR(14) NULL UNIQUE,
    telefone VARCHAR(20) NULL,
    endereco VARCHAR(255) NULL,
    status ENUM('ATIVO', 'BLOQUEADO') NOT NULL DEFAULT 'ATIVO',
    data_cadastro DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB;

-- =========================================
-- TABELA DE CATEGORIAS
-- =========================================
CREATE TABLE categorias (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL UNIQUE,
    descricao VARCHAR(255) NULL
) ENGINE=InnoDB;

-- =========================================
-- TABELA DE EDITORAS
-- =========================================
CREATE TABLE editoras (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL UNIQUE,
    cidade VARCHAR(100) NULL,
    pais VARCHAR(100) NULL,
    site VARCHAR(200) NULL,
    contato VARCHAR(150) NULL
) ENGINE=InnoDB;

-- =========================================
-- TABELA DE AUTORES
-- =========================================
CREATE TABLE autores (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(150) NOT NULL,
    nacionalidade VARCHAR(100) NULL,
    data_nascimento DATE NULL,
    biografia TEXT NULL
) ENGINE=InnoDB;

-- =========================================
-- TABELA DE LIVROS
-- =========================================
CREATE TABLE livros (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    titulo VARCHAR(255) NOT NULL,
    isbn VARCHAR(20) NULL UNIQUE,
    ano_publicacao YEAR NULL,
    numero_paginas INT UNSIGNED NULL,
    descricao TEXT NULL,
    id_editora INT UNSIGNED NULL,
    id_categoria INT UNSIGNED NULL,
    localizacao VARCHAR(120) NULL
) ENGINE=InnoDB;

-- =========================================
-- TABELA RELACIONAMENTO LIVRO x AUTOR
-- =========================================
CREATE TABLE livro_autor (
    id_livro INT UNSIGNED NOT NULL,
    id_autor INT UNSIGNED NOT NULL,
    PRIMARY KEY (id_livro, id_autor)
) ENGINE=InnoDB;

-- =========================================
-- TABELA DE EXEMPLARES
-- cada livro pode ter vários exemplares
-- =========================================
CREATE TABLE exemplares (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_livro INT UNSIGNED NOT NULL,
    codigo_exemplar VARCHAR(50) NOT NULL UNIQUE,
    status ENUM('DISPONIVEL', 'EMPRESTADO', 'RESERVADO', 'MANUTENCAO') NOT NULL DEFAULT 'DISPONIVEL',
    observacoes TEXT NULL
) ENGINE=InnoDB;

-- =========================================
-- TABELA DE EMPRÉSTIMOS
-- =========================================
CREATE TABLE emprestimos (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT UNSIGNED NOT NULL,
    id_exemplar INT UNSIGNED NOT NULL,
    data_emprestimo DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_prevista_devolucao DATETIME NOT NULL,
    data_devolucao DATETIME NULL,
    status ENUM('EM_ANDAMENTO', 'DEVOLVIDO', 'ATRASADO') NOT NULL DEFAULT 'EM_ANDAMENTO',
    observacoes TEXT NULL
) ENGINE=InnoDB;

-- =========================================
-- TABELA DE RESERVAS
-- =========================================
CREATE TABLE reservas (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_usuario INT UNSIGNED NOT NULL,
    id_livro INT UNSIGNED NOT NULL,
    data_reserva DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    status ENUM('ATIVA', 'ATENDIDA', 'CANCELADA', 'EXPIRADA') NOT NULL DEFAULT 'ATIVA'
) ENGINE=InnoDB;

-- =========================================
-- TABELA DE MULTAS
-- =========================================
CREATE TABLE multas (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    id_emprestimo INT UNSIGNED NOT NULL UNIQUE,
    dias_atraso INT UNSIGNED NOT NULL DEFAULT 0,
    valor DECIMAL(10,2) NOT NULL DEFAULT 0.00,
    status_pagamento ENUM('PENDENTE', 'PAGO') NOT NULL DEFAULT 'PENDENTE',
    data_pagamento DATETIME NULL
) ENGINE=InnoDB;

-- =========================================
-- ALTER TABLE - RELACIONAMENTOS
-- =========================================

ALTER TABLE livros
ADD CONSTRAINT fk_livros_editoras
FOREIGN KEY (id_editora) REFERENCES editoras(id)
ON UPDATE CASCADE
ON DELETE SET NULL;

ALTER TABLE livros
ADD CONSTRAINT fk_livros_categorias
FOREIGN KEY (id_categoria) REFERENCES categorias(id)
ON UPDATE CASCADE
ON DELETE SET NULL;

ALTER TABLE livro_autor
ADD CONSTRAINT fk_livro_autor_livro
FOREIGN KEY (id_livro) REFERENCES livros(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE livro_autor
ADD CONSTRAINT fk_livro_autor_autor
FOREIGN KEY (id_autor) REFERENCES autores(id)
ON UPDATE CASCADE
ON DELETE CASCADE;

ALTER TABLE exemplares
ADD CONSTRAINT fk_exemplares_livros
FOREIGN KEY (id_livro) REFERENCES livros(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

ALTER TABLE emprestimos
ADD CONSTRAINT fk_emprestimos_usuarios
FOREIGN KEY (id_usuario) REFERENCES usuarios(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

ALTER TABLE emprestimos
ADD CONSTRAINT fk_emprestimos_exemplares
FOREIGN KEY (id_exemplar) REFERENCES exemplares(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

ALTER TABLE reservas
ADD CONSTRAINT fk_reservas_usuarios
FOREIGN KEY (id_usuario) REFERENCES usuarios(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

ALTER TABLE reservas
ADD CONSTRAINT fk_reservas_livros
FOREIGN KEY (id_livro) REFERENCES livros(id)
ON UPDATE CASCADE
ON DELETE RESTRICT;

ALTER TABLE multas
ADD CONSTRAINT fk_multas_emprestimos
FOREIGN KEY (id_emprestimo) REFERENCES emprestimos(id)
ON UPDATE CASCADE
ON DELETE CASCADE;
-- =========================================
-- TRIGGER: NÃO PERMITE EMPRÉSTIMO PARA ALUNO BLOQUEADO
-- =========================================

-- Altera o delimitador padrão do MySQL de ; para $$
-- Isso é necessário porque dentro da trigger usamos vários comandos com ;
DELIMITER $$

-- Cria uma trigger chamada trg_before_insert_emprestimos
-- Essa trigger será executada antes de inserir um registro na tabela emprestimos
CREATE TRIGGER trg_before_insert_emprestimos

-- Define que a trigger será executada antes do INSERT
BEFORE INSERT ON emprestimos

-- Indica que a trigger será executada para cada linha inserida
FOR EACH ROW
BEGIN

    -- Declara uma variável para armazenar o status do usuário
    DECLARE v_status_usuario VARCHAR(20);

    -- Declara uma variável para armazenar o perfil do usuário
    DECLARE v_perfil_usuario VARCHAR(20);

    -- Declara uma variável para armazenar o status do exemplar
    DECLARE v_status_exemplar VARCHAR(20);

    -- Declara uma variável para contar multas pendentes
    -- O valor inicial é 0
    DECLARE v_multas_pendentes INT DEFAULT 0;

    -- Busca o status e o perfil do usuário que está tentando fazer o empréstimo
    SELECT status, perfil

    -- Armazena os valores encontrados nas variáveis
    INTO v_status_usuario, v_perfil_usuario

    -- Informa que os dados serão buscados na tabela usuarios
    FROM usuarios

    -- Filtra o usuário pelo id informado no novo empréstimo
    WHERE id = NEW.id_usuario;

    -- Verifica se o perfil do usuário é diferente de ALUNO
    IF v_perfil_usuario <> 'ALUNO' THEN

        -- Interrompe o INSERT e gera um erro personalizado
        SIGNAL SQLSTATE '45000'

        -- Mensagem exibida quando o usuário não é aluno
        SET MESSAGE_TEXT = 'Apenas alunos podem realizar empréstimos.';

    -- Finaliza a condição IF
    END IF;

    -- Verifica se o status do usuário é BLOQUEADO
    IF v_status_usuario = 'BLOQUEADO' THEN

        -- Interrompe o INSERT e gera um erro personalizado
        SIGNAL SQLSTATE '45000'

        -- Mensagem exibida quando o aluno está bloqueado
        SET MESSAGE_TEXT = 'Aluno bloqueado não pode realizar empréstimos.';

    -- Finaliza a condição IF
    END IF;

    -- Busca o status do exemplar que está sendo emprestado
    SELECT status

    -- Armazena o status encontrado na variável v_status_exemplar
    INTO v_status_exemplar

    -- Informa que a busca será feita na tabela exemplares
    FROM exemplares

    -- Filtra o exemplar pelo id informado no novo empréstimo
    WHERE id = NEW.id_exemplar;

    -- Verifica se o exemplar não está disponível
    IF v_status_exemplar <> 'DISPONIVEL' THEN

        -- Interrompe o INSERT e gera um erro personalizado
        SIGNAL SQLSTATE '45000'

        -- Mensagem exibida quando o exemplar está indisponível
        SET MESSAGE_TEXT = 'Exemplar indisponível para empréstimo.';

    -- Finaliza a condição IF
    END IF;

    -- Conta quantas multas pendentes o aluno possui
    SELECT COUNT(*)

    -- Armazena a quantidade encontrada na variável v_multas_pendentes
    INTO v_multas_pendentes

    -- Informa que a consulta será feita na tabela multas
    FROM multas m

    -- Relaciona a tabela multas com a tabela emprestimos
    INNER JOIN emprestimos e ON e.id = m.id_emprestimo

    -- Filtra apenas os empréstimos do usuário atual
    WHERE e.id_usuario = NEW.id_usuario

      -- Filtra apenas multas com pagamento pendente
      AND m.status_pagamento = 'PENDENTE';

    -- Verifica se existe pelo menos uma multa pendente
    IF v_multas_pendentes > 0 THEN

        -- Interrompe o INSERT e gera um erro personalizado
        SIGNAL SQLSTATE '45000'

        -- Mensagem exibida quando o aluno possui multa pendente
        SET MESSAGE_TEXT = 'Aluno possui multa pendente.';

    -- Finaliza a condição IF
    END IF;

-- Finaliza o bloco da trigger
END$$

-- Retorna o delimitador padrão para ;
DELIMITER ;


