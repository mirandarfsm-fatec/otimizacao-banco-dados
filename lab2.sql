-- Cria PK
Alter table lancamento add primary key (id);

-- Desabilita PK
Alter table lancamento disable primary key;

Select * from lancamento where id = 1000;
-- time: 4941079

-- Habilita PK
Alter table lancamento enable primary key;

Select * from lancamento where id = 1000;
-- time: 23450

Select a.FIRST_NAME, sum(valor) from customer a, lancamento b 
  where a.customer_id = b.cliente group by a.FIRST_NAME;
-- time: 17764965

Select FIRST_NAME, BALANCE from customer;
-- time: 46331

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
-- BYTES: 838860800


-- user: system
/*
select LAST_LOAD_TIME, ELAPSED_TIME, MODULE, SQL_TEXT from v$sql  order by LAST_LOAD_TIME desc;
*/