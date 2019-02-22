-- Recursive query, joining columns
-- OBS - the UNPIVOT alias, when there is more than one column, must be numeric
-- DOC https://docs.oracle.com/cd/B19306_01/server.102/b14200/queries003.htm
-- DOC https://oracle-base.com/articles/11g/pivot-and-unpivot-operators-11gr1
-- Can be tested on https://livesql.oracle.com


SELECT coop, conta, nivel,col, PATH_COOP
  FROM ( 
  	     SELECT DISTINCT I.COOP_ORIGEM, I.CONTA_ORIGEM, I.COOP_DESTINO, I.CONTA_DESTINO, level nivel, SYS_CONNECT_BY_PATH(COOP_DESTINO||'-'||COOP_ORIGEM, '/') "PATH_COOP"
           FROM (select '0718' COOP_DESTINO, '811473' CONTA_DESTINO, '0101' COOP_ORIGEM, '123456' CONTA_ORIGEM from dual union all
           	     select '0101' COOP_DESTINO, '123456' CONTA_DESTINO, '1006' COOP_ORIGEM, '654321' CONTA_ORIGEM from dual union all
           	     select '0104' COOP_DESTINO, '147852' CONTA_DESTINO, '0605' COOP_ORIGEM, '963258' CONTA_ORIGEM from dual union all
           	     select '0605' COOP_DESTINO, '963258' CONTA_DESTINO, '0978' COOP_ORIGEM, '365478' CONTA_ORIGEM from dual
           	     ) I
          START WITH I.COOP_DESTINO = '0718' and I.CONTA_DESTINO = '811473'
        CONNECT BY 
        NOCYCLE PRIOR I.COOP_ORIGEM = I.COOP_DESTINO 
            AND PRIOR I.CONTA_ORIGEM = I.CONTA_DESTINO 
            AND LEVEL <= 3
	  
	 ) x UNPIVOT ( (COOP,CONTA) FOR COL IN ( (COOP_ORIGEM, CONTA_ORIGEM) as 1,(COOP_DESTINO, CONTA_DESTINO ) as 2 ))
 order by nivel,col desc;
