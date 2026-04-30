use etec;

-- selecioando todos os professores
select * from professor;

-- inicia uma alteração ou uma alter 
begin; 
update professor set nome = "juan gabriel" where id_professor = 1;

-- retorna as alteraç]oes do begin
rollback;

-- finaliza as alterações
commit;

begin;
update professor set nome = "Maria Eduarda" where id_professor = 3;
rollback;
commit;

-- selecionando apenas oque eu alterei
select * from professor
where id_professor = 3;

begin;
update professor set nome = "marcos vinicius pereira" where id_professor = 3;

begin;
update professor set disciplina_especialidade = "matematica" where id_professor = 4;

select * from professor
where DISCIPLINA_ESPECIALIDADE = "matematica";

-- deletando dados
delete from professor where telefone = "(11) 99999-1111";

-- retorna as alteraç]oes do begin
rollback;

-- finaliza as alterações
commit;

select * FROM professor_disciplina_turma A, professor B
where A.ID_PROFESSOR = B.ID_PROFESSOR
;

select * from professor;
select * from professor_disciplina_turma;

begin;
delete from professor_disciplina_turma where ID_RELACAO = 1;
rollback;

select *, A.id_professor, B.nome, C.Nome as especialidade
 from professor_disciplina_turma A, disciplina B, disciplina C, turma T
where A.ID_professor = B.id_disciplina
 and A.ID_DISCIPLINA = C.ID_DISCIPLINA
 and A.ID_DISCIPLINA = T.ID_TURMA
;

select *  from curso;

insert into professor (NOME, CPF, EMAIL, TELEFONE, FORMACAO, DISCIPLINA_ESPECIALIDADE) values('Fabricio de Oliveira Passos', '192.837.465-00', 'fabricio.passos@escola.com', '(11) 93333-7777', 'Licenciatura em Matemática', 'Matemática');
