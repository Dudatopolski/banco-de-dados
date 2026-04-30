create database biblioteca;

use biblioteca;

create table usuario_sistema(
	id_usuario int unique  primary key auto_increment,
    nome_usuario varchar(100),
    senha varchar(20),
    nivel_acesso enum ('Professor','Diretor','Aluno'),
    status enum ('ativo','inativo','ausente')
);
create table editora (
	id_editora int unique primary key auto_increment,
	nome varchar(255),
	cidade varchar(100),
    país varchar(50),
    site varchar (150),
    contato varchar (255)
);
create table categoria (
	id_categoria int unique primary key auto_increment,
    nome varchar (100),
    descricao varchar (100)
);

create table livro(
	id_livro int unique primary key auto_increment,
    titulo varchar (200),
    ano_publicacao date,
    isbn varchar(100),
    numero_paginas int
);

create table autor (
	id_autor int unique primary key auto_increment,
	nome varchar(100),
    nacionalidade varchar(100),
    data_nascimento date,
    biografia varchar(255)
);

create table reserva(
	data_reserva date,
    status enum ('ativo','inativo','ausente')
);
create table exemplar(
	id_exemplar int unique primary key auto_increment,
    status enum ('ativo','inativo','ausente'),
    localizacao varchar(200)
);

create table leitor(
	id_leitor int unique primary key auto_increment,
    nome varchar(100),
    cpf char(11),
    data_nascimento date,
    email varchar(100),
    telefone char(15),
    tipo_usuario enum ('Professor','Diretor','Aluno'),
    data_cadastro date,
    status enum ('ativo','inativo','ausente')
); 
create table emprestimo (
	id_emprestimo int unique primary key auto_increment,
    data_emprestimo date,
    data_prevista_devolucao date,
    data_devolucao date,
    status enum ('Emprestado','Devolvido')
);

create table multa (
	id_multa int unique primary key auto_increment,
    dias_atraso int not null,
    valor decimal,
    status_pagamento enum ('pendente','pago'),
    data_pagamento date
);