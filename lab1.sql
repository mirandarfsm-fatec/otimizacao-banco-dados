-- cmd para criar role e tablespace
/*
CREATE TABLESPACE mirandarfsm LOGGING DATAFILE '/u01/app/oracle/oradata/XE/mirandarfsm.dbf' SIZE 100m AUTOEXTEND ON NEXT 100m EXTENT MANAGEMENT LOCAL;
CREATE USER mirandarfsm IDENTIFIED BY 123456 DEFAULT TABLESPACE mirandarfsm QUOTA UNLIMITED ON mirandarfsm;
GRANT create session, alter session, create table, create procedure, create view, create materialized view, create trigger, create sequence, create any directory, create type, create synonym TO mirandarfsm;
*/

CREATE TABLE CUSTOMER(
CUSTOMER_ID NUMBER NOT NULL,
FIRST_NAME VARCHAR2(30) NOT NULL,
DATE_OF_BIRTH DATE NOT NULL,
CITY_NAME VARCHAR2(64) NOT NULL,
ADDRESS1 VARCHAR2(50) NOT NULL,
BALANCE VARCHAR2(6) NOT NULL
);

create table LANCAMENTO(
ID NUMBER,
DATA DATE,
CLIENTE NUMBER,
VALOR NUMBER(10,2)
);

-- user: system
/*
SELECT 
TABLESPACE_NAME,  
INITIAL_EXTENT, 
NEXT_EXTENT, 
MIN_EXTENTS,
MAX_EXTENTS,
PCT_INCREASE,
STATUS
FROM DBA_TABLESPACES;
*/

-- user: system
/*
SELECT 
FILE#,
STATUS,
ENABLED,
BYTES,
NAME
FROM V$DATAFILE;
*/

INSERT INTO customer VALUES (1,'Charlene',sysdate, 'Sioux Falls','2910 Andy Street', '50.00');

-- criar pl/sql para inserir um registro lançamento
CREATE SEQUENCE seq_lancamento_id;

DECLARE
BEGIN
-- to_date('2003/05/03 12:12', 'yyyy/mm/dd hh24:mi')
INSERT INTO lancamento VALUES (seq_lancamento_id.nextval,sysdate,1,25.00);
END;

-- inserir 500 registro
CREATE SEQUENCE seq_customer_id start with 2;

SET ECHO ON
SET SERVEROUTPUT ON
DECLARE
BEGIN
FOR i in 1..500 LOOP
DBMS_OUTPUT.PUT_LINE('teste'||i);
--Insert into customer (select seq_customer_id.nextval, FIRST_NAME, DATE_OF_BIRTH,CITY_NAME,ADDRESS1,BALANCE);*
INSERT INTO customer VALUES (seq_customer_id.nextval,'teste'||i,sysdate, 'RJ'||i,i||'Street', i);
END LOOP;
END;

/*
Criar um pl/sql que gere registros na tabela de lançamentos conforme a seguinte regra:
Criar 30.000 registros para cada cliente da tabela customer;
Esses registros devem estar distribuídos num período de 90 dias. Cada dia deve conter aprox. 300 registros de lançamentos.
Campo ID: preenchido com sequence.nextval. (Criar a sequence)
Campo data: preenchido pelo pl/sql com valor sequencial
Campo cliente: preenchido com a chave estrangeira da tabela customer.
Campo valor: preencher com a constante 15.
*/
SET ECHO ON
SET SERVEROUTPUT ON
DECLARE
VALOR CONSTANT REAL := 15.0;
v_date DATE;
BEGIN
FOR customer IN (SELECT CUSTOMER_ID FROM CUSTOMER) LOOP
DBMS_OUTPUT.PUT_LINE(customer.CUSTOMER_ID);
v_date := SYSDATE;
FOR i in 1..30000 LOOP
IF REMAINDER(i,333) = 0 THEN
v_date := v_date + 1;
END IF;
INSERT INTO lancamento VALUES (seq_lancamento_id.nextval,v_date,customer.CUSTOMER_ID,VALOR);
END LOOP;
END LOOP;
END;

select count(*) from CUSTOMER;
-- result: 501

select count(*) from LANCAMENTO;
-- result: 15030001

