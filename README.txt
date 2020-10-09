### README DESAFIO DBSERVER ###

Qual Banco de Dados foi utilizado para o desenvolvimento? 
  - Foi utilizado o Oracle Database 12c 

Scripts para a criação das tabelas criadas :

###### TABLES ######

CREATE TABLE funcionarios 
  (func_id   NUMBER NOT NULL,
   func_nome VARCHAR2(200) NOT NULL, 
   CONSTRAINT func_pk PRIMARY KEY (func_id)
   ); 
   
  
   
CREATE TABLE restaurantes 
  (rest_id NUMBER NOT NULL, 
   rest_nome VARCHAR2(200) NOT NULL,
   CONSTRAINT rest_pk PRIMARY KEY (rest_id)
   ); 
   
   
CREATE TABLE votos
 (voto_id NUMBER NOT NULL, 
  restaurante_id NUMBER NOT NULL, 
  func_id        NUMBER NOT NULL, 
  dia_semana     DATE,
  CONSTRAINT voto_pk PRIMARY KEY (voto_id)
  );
  
  ALTER TABLE votos
  ADD CONSTRAINT fk_func
  FOREIGN KEY (func_id)
  REFERENCES funcionarios(func_id);
  
  
  ALTER TABLE votos
  ADD CONSTRAINT fk_rest
  FOREIGN KEY (restaurante_id)
  REFERENCES restaurantes(rest_id);


#### SEQUENCES #####

 CREATE SEQUENCE func_seq
  MINVALUE 1
  START WITH 1
  INCREMENT BY 1;
  
 CREATE SEQUENCE rest_seq
  MINVALUE 1
  START WITH 1
  INCREMENT BY 1;
  
 CREATE SEQUENCE voto_seq
  MINVALUE 1
  START WITH 1
  INCREMENT BY 1;


#### INSERTS ####

  INSERT INTO funcionarios VALUES(func_seq.nextval,'João Paulo');
  INSERT INTO funcionarios VALUES(func_seq.nextval,'Maria Clara');
  INSERT INTO funcionarios VALUES(func_seq.nextval,'Pedro Augusto');
  INSERT INTO funcionarios VALUES(func_seq.nextval,'Joana');
  INSERT INTO funcionarios VALUES(func_seq.nextval,'Fernanda'); 
  INSERT INTO funcionarios VALUES(func_seq.nextval,'Matheus'); 
  
  
  INSERT INTO restaurantes VALUES(rest_seq.nextval,'Coco Bambu');
  INSERT INTO restaurantes VALUES(rest_seq.nextval,'Mineirinho');
  INSERT INTO restaurantes VALUES(rest_seq.nextval,'Churrascaria do Zezé');
  INSERT INTO restaurantes VALUES(rest_seq.nextval,'Buffet da Dona Maria');
  INSERT INTO restaurantes VALUES(rest_seq.nextval,'Japa Japão'); 
  INSERT INTO restaurantes VALUES(rest_seq.nextval,'Costelinha do Gaúcho'); 
  INSERT INTO restaurantes VALUES(rest_seq.nextval,'Lanchão'); 


 - O que vale destacar no código implementado ? 
    
   Vale destacar a função criada para resgatar o resultado da votação e 
   a procedure para realizar a votação. 

 - O que poderia ser feito para melhorar o sistema ? 
   Poderia criar uma lógica para randomizar os votos quando a votação empatasse, 
   ou realizasse uma nova votação. 

 - Algo a mais que você tenha a dizer :) 
   Achei um desafio muito interessante de ser realizado. 




  