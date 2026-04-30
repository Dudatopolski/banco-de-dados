-- Tipos de comentario
-- comenta uma linha

/*comenta um bloco de codigos */

-- criando um database

create database biblioteca;

-- selecionando o banco de dados
use biblioteca;

/*
criaçao da tabela de categorias
criando em 27/03/26
criado por marcio silva
*/
create table categorias(
	id int(10) auto_increment primary key unique,
    nome varchar(100) not null,
    descricao varchar (255) not null,
    created_at datetime,
    updated_at datetime
);

create table livros(
	id int(10) auto_increment primary key unique,
    titulo varchar (255),
    isnb varchar(255),
    ano_publicacao year(4),
    numero_paginas int(10),
    descricao text,
    localizacao varchar(120),
    created_at datetime,
    updated_at datetime
);

alter table livros 
add constraint FK_CATEGORIAS
foreign key (ID_CATEGORIAS)
references categorias (id)