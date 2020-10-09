-- Created on 07/10/2020 by JÉSSICA CAROLINE COSTA E SILVA 
DECLARE
v_msg           VARCHAR2(200);
msg             VARCHAR2(200);
votado          VARCHAR2(500);
  -- 

--=================================================================== 
  -- PROCEDURE PARA REALIZAÇÃO DOS VOTOS NOS RESTAURANTES PREFERIDOS 
--=================================================================== 
  
  PROCEDURE votar_restaurante(v_func_id    IN NUMBER
                             ,v_rest_id    IN NUMBER
                             ,v_dia_semana IN DATE) IS
    -- 
    v_voto          VARCHAR2(200);
    v_inicio_semana DATE;
    v_rest_repetido BOOLEAN := FALSE;
    start_date      number;
    end_date        number;
    business_date   DATE;
    v_dia_hoje      NUMBER;
    v_rest_repet    NUMBER;
    v_rest_votado   NUMBER;
    v_nome_func     VARCHAR2(200);
    v_nome_rest     VARCHAR2(200);
     
    -- 
  BEGIN
    /*Validar se o funcionario ja votou */
    SELECT COUNT(v.voto_id) voto
      INTO v_voto
      FROM votos v
     WHERE v.func_id = v_func_id
       AND to_char(v.dia_semana,'dd/MM/yyyy') = to_char(v_dia_semana,'dd/MM/yyyy');
  
    IF (v_voto > 0) THEN
    
      dbms_output.put_line('Votação já realizada no dia');
    
    ELSE
      /*Qual o dia de hoje */
      SELECT to_number(to_char(SYSDATE,'D')) dia
        INTO v_dia_hoje
        FROM dual;
    
      /*Qual o dia que inicia a semana*/
      SELECT v_dia_semana - v_dia_hoje + 1
        INTO v_inicio_semana
        FROM dual;
        
                    
      /*Validar se o restaurante foi votado*/ 
      BEGIN
        start_date := to_number(to_char(v_inicio_semana,'j'));
        end_date   := to_number(to_char(v_dia_semana-1,'j'));
        FOR cur_r IN start_date .. end_date
        LOOP
          business_date := to_date(cur_r,'j');
  
            SELECT CASE WHEN EXISTS ( SELECT r_id
                                        FROM (SELECT COUNT(v.restaurante_id) rest
                                                    ,v.restaurante_id r_id
                                                FROM votos v
                                               WHERE to_date(v.dia_semana) = to_date(business_date)                                         
                                               GROUP BY v.restaurante_id
                                               ORDER BY rest DESC)
                                       WHERE ROWNUM = 1) THEN 1 ELSE 0 END
                                              INTO v_rest_votado
                                              FROM DUAL;
                                                        
                                          IF(v_rest_votado = 1) THEN 
                                            SELECT r_id
                                              INTO v_rest_votado
                                              FROM (SELECT COUNT(v.restaurante_id) rest
                                                          ,v.restaurante_id r_id
                                                      FROM votos v
                                                     WHERE to_date(v.dia_semana) = to_date(business_date)
                                                     GROUP BY v.restaurante_id
                                                     ORDER BY rest DESC)
                                             WHERE ROWNUM = 1;
                                        END IF; 
          
          
          IF(v_rest_votado = v_rest_id)  THEN
                v_rest_repetido := TRUE; 
          END IF; 
        END LOOP; 
    
      IF (v_rest_repetido) THEN
        dbms_output.put_line('O restaurante já foi escolhido essa semana');
      ELSE
        INSERT INTO votos
        VALUES
          (voto_seq.nextval
          ,v_rest_id
          ,v_func_id
          ,v_dia_semana);
          COMMIT; 
          
          SELECT f.func_nome
               , r.rest_nome
            INTO v_nome_func
               , v_nome_rest
            FROM funcionarios f
               , restaurantes r 
           WHERE f.func_id = v_func_id
             AND r.rest_id = v_rest_id; 
          
          
          
          dbms_output.put_line('Votação realizada pelo '|| v_nome_func ||' com sucesso no restaurante '|| v_nome_rest|| '');
      END IF;
      
      END;
    
    END IF;
  EXCEPTION
    WHEN OTHERS THEN
      dbms_output.put_line('Ocorreu um erro:' || SQLERRM);
  END votar_restaurante;
  
 --=================================================== 
  -- FUNÇÃO PARA RETORNAR RESULTADO DA VOTAÇÃO 
--=================================================== 
  
  FUNCTION get_Resultado_votacao(v_dia_semana VARCHAR2) RETURN VARCHAR2 IS 
    v_votado VARCHAR2(200);
    v_result_votacao  VARCHAR2(500);
     BEGIN 
       SELECT rest_nome
        INTO v_votado
        FROM (SELECT COUNT(v.restaurante_id) rest
                    , r.rest_nome
                FROM votos v
                   , restaurantes r 
               WHERE to_date(v.dia_semana) = to_date(v_dia_semana)
                 AND r.rest_id = v.restaurante_id
               GROUP BY r.rest_nome
               ORDER BY rest DESC)
       WHERE ROWNUM = 1;
       
      v_result_votacao := 'O restaurante votado foi o '||v_votado||' para o dia '|| v_dia_semana||'';
       
     RETURN v_result_votacao; 
     
  END get_Resultado_votacao; 


--=================================================== 
  -- MAIN 
--=================================================== 
BEGIN  

    votar_restaurante(1,5,SYSDATE);
    votar_restaurante(2,5,SYSDATE);
    votar_restaurante(3,5,SYSDATE);
    votar_restaurante(4,1,SYSDATE);
    
    votado := get_resultado_votacao(SYSDATE); 
    
    dbms_output.put_line(votado);
    
EXCEPTION
  WHEN OTHERS THEN
    dbms_output.put_line('Erro:' || SQLERRM);
END;