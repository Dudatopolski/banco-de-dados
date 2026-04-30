-- drop database biblioteca;
create database biblioteca;
use biblioteca;

create table usuario_sistema (
	id_usuario int not null auto_increment primary key, 
    nome_usuario varchar(255) not null,
    senha varchar(50) not null,
    nivel_acesso enum('aluno','professor','usuario') not null,
    status enum('ativo', 'inativo', 'ausente' ) not null
);

create table editora(
	id_editora int not null auto_increment primary key, 
    nome varchar(255) not null,
    cidade varchar(100) not null,
    pais varchar(100) not null,
    site varchar(100) not null,
    contato varchar(255) not null
);

create table categoria(
	id_categoria int not null auto_increment primary key,
    nome varchar (255) not null,
    descricao varchar(255) not null
);

create table livro(
	id_livro  int not null auto_increment primary key,
    titulo varchar(255) not null,
    ano_publicacao int,
    isbn varchar(25),
    numero_paginas int
);

create table autor(
	id_autor  int not null auto_increment primary key,
    nome varchar(255) not null,
    nacionalidade varchar(255) not null,
    data_nascimento int,
    biografia varchar(255)
);

create table exemplar(
	id_exemplar int not null auto_increment primary key,
    status enum('ativo', 'inativo', 'ausente' ) not null,
    localizacao varchar(255)
);

create table leitor(
	id_leitor int not null auto_increment primary key,
    nome varchar(255),
    cpf char(13),
    data_nasc date,
    email varchar(255),
    telefone varchar(20),
    endereco varchar(255),
    tipo_usuario varchar(255),
    data_cadastro date,
    status enum('ativo','inativo','ausente')
);

create table emprestimo(
	id_emprestimo int not null auto_increment primary key,
    data_emprestimo date,
    data_prevista_devolucao date,
    data_devolicao date,
    status enum('ativo','inativo','ausente')
);

create table multa(
	id_multa int not null auto_increment primary key,
    dias_atraso int,
    valor int,
	status_pagamento ENUM('pendente', 'pago', 'cancelado'),
    data_pagamento date
);

create table reserva(
	id_reserva int not null auto_increment primary key,
    data_reserva date,
    status enum('pendente', 'confirmada','cancelada','concluida')
);

