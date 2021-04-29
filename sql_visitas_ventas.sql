/****** CONSULTA PARA VISTAS CRM UNIOD A LAS VENTAS POR CLIETNES*/

/**** PANEL CLIENTES*/

/*****VENTAS POR GESTOR RPN ******/

/******* PANEL DE CLIENTES POR GESTOR DE NEGOCIOS */

SELECT to_number(ejercicio) ejercicio,to_number(v_MES) v_mes,reg,cod,descrip,vendedor, 1 nro_ttl_clie,0 nro_clie_visitado,0 nro_clie_vta, 0 bs_neto_clie,'Panel Clie' dato from bol_panel_clie group by ejercicio,v_MES,reg,vendedor,cod,descrip
UNION ALL
/********ventas por cliente RPN *****/
select ejercicio,v_mes,reg,CLIENTE_ID cod,cliente_nombre descrip,VENDEDOR,0 nro_ttl_clie, 0 nro_clie_visitado,1 nro_clie_vta, sum(IMP_NETO) bs_neto_clie,'Clientes' dato FROM (SELECT BOL_BI_VTAS_PPTO.*,decode(uen,'BOL - PROCAPS',nombre_agente,'BOL - PROMEDICAL',nombre_agente,'BOL - SUIPHAR',substr(RPN2,5),'BOL - GRUNENTHAL',substr(RPN2,5),'BOL - HERSIL SA',(SELECT substr(NOMBRE,5) FROM VALORES_CLAVES V WHERE V.CLAVE ='RPN4' AND V.VALOR_CLAVE=(SELECT VALOR_CLAVE FROM  CLIENTES_CLAVES_ESTADISTICAS c WHERE c.CLAVE='RPN4' AND c.CODIGO_CLIENTE=BOL_BI_VTAS_PPTO.cliente_id AND c.CODIGO_EMPRESA='004')),'SIN UEN') VENDEDOR from BOL_BI_VTAS_PPTO) vta WHERE CANTIDAD>0 and EJERCICIO=2021 and v_mes=02 GROUP BY EJERCICIO, v_MES,reg,VENDEDOR,CLIENTE_ID,cliente_nombre
union all
/************VISITAS DE AGENTES *********/
select EJERCICIO, V_MES,reg, cliente COD, descrip,VENDEDOR,0 nro_ttl_clie, 1 nro_clie_visitado,0 nro_clie_vta, 0 bs_neto_clie,'Visitas' dato FROM (select AGENTES_VISITAS.*,extract(year from fecha) EJERCICIO, extract(MONTH from fecha) V_MES,(SELECT RAZON_SOCIAL2 FROM CLIENTES A WHERE A.CODIGO_EMPRESA=AGENTES_VISITAS.empresa AND A.codigo_rapido=AGENTES_VISITAS.cliente) descrip,(SELECT p.nombre FROM agentes p WHERE p.codigo = AGENTES_VISITAS.agente AND empresa = agentes_visitas.empresa) vendedor,decode((SELECT zona FROM CLIENTES A WHERE A.CODIGO_EMPRESA=AGENTES_VISITAS.empresa AND A.codigo_rapido=AGENTES_VISITAS.cliente),'0410','SCZ','0420','LPZ','0430','CBBA','0440','TJA','0450','ALTO','0451','ALTO','0460','SCR','0461','SCR','0470','BENI','0471','BENI','SIN REG') reg from agentes_visitas) agentes_visitas WHERE EMPRESA='004' and ejercicio=2021 and v_mes=2
group by EJERCICIO, v_MES,reg,VENDEDOR,cliente,descrip
/****************************************/


/****** sql para BI DE LIBRA CON LOS PARAMETROS */
with x as (
SELECT to_number(ejercicio) ejercicio,to_number(v_MES) v_mes,reg,cod,descrip,vendedor, 1 nro_ttl_clie,0 nro_clie_visitado,0 nro_clie_vta, 0 bs_neto_clie,'Panel Clie' dato from bol_panel_clie group by ejercicio,v_MES,reg,vendedor,cod,descrip
UNION ALL
/********ventas por cliente RPN *****/
select ejercicio,v_mes,reg,CLIENTE_ID cod,cliente_nombre descrip,VENDEDOR,0 nro_ttl_clie, 0 nro_clie_visitado,1 nro_clie_vta, sum(IMP_NETO) bs_neto_clie,'Clientes' dato FROM (SELECT BOL_BI_VTAS_PPTO.*,decode(uen,'BOL - PROCAPS',nombre_agente,'BOL - PROMEDICAL',nombre_agente,'BOL - SUIPHAR',substr(RPN2,5),'BOL - GRUNENTHAL',substr(RPN2,5),'BOL - HERSIL SA',(SELECT substr(NOMBRE,5) FROM VALORES_CLAVES V WHERE V.CLAVE ='RPN4' AND V.VALOR_CLAVE=(SELECT VALOR_CLAVE FROM  CLIENTES_CLAVES_ESTADISTICAS c WHERE c.CLAVE='RPN4' AND c.CODIGO_CLIENTE=BOL_BI_VTAS_PPTO.cliente_id AND c.CODIGO_EMPRESA='004')),'SIN UEN') VENDEDOR from BOL_BI_VTAS_PPTO) vta WHERE CANTIDAD>0 and EJERCICIO=2021 and v_mes=02 GROUP BY EJERCICIO, v_MES,reg,VENDEDOR,CLIENTE_ID,cliente_nombre
union all
/************VISITAS DE AGENTES *********/
select EJERCICIO, V_MES,reg, cliente COD, descrip,VENDEDOR,0 nro_ttl_clie, 1 nro_clie_visitado,0 nro_clie_vta, 0 bs_neto_clie,'Visitas' dato FROM (select AGENTES_VISITAS.*,extract(year from fecha) EJERCICIO, extract(MONTH from fecha) V_MES,(SELECT RAZON_SOCIAL2 FROM CLIENTES A WHERE A.CODIGO_EMPRESA=AGENTES_VISITAS.empresa AND A.codigo_rapido=AGENTES_VISITAS.cliente) descrip,(SELECT p.nombre FROM agentes p WHERE p.codigo = AGENTES_VISITAS.agente AND empresa = agentes_visitas.empresa) vendedor,decode((SELECT zona FROM CLIENTES A WHERE A.CODIGO_EMPRESA=AGENTES_VISITAS.empresa AND A.codigo_rapido=AGENTES_VISITAS.cliente),'0410','SCZ','0420','LPZ','0430','CBBA','0440','TJA','0450','ALTO','0451','ALTO','0460','SCR','0461','SCR','0470','BENI','0471','BENI','SIN REG') reg from agentes_visitas) agentes_visitas WHERE EMPRESA='004' and ejercicio=2021 and v_mes=3
group by EJERCICIO, v_MES,reg,VENDEDOR,cliente,descrip
) 
select EJERCICIO, V_MES,reg, VENDEDOR,sum(nro_ttl_clie) nro_ttl_clie, sum(nro_clie_visitado) nro_clie_visitado,sum( nro_clie_vta) nro_clie_vta, sum( bs_neto_clie) bs_neto_clie from x where descrip NOT LIKE 'CLIENTE %' and vendedor not in ('RITA NORMINHA TOLEDO CHACON','CELIA LUJAN ORTUÑO ASTURIZAGA','-DISTRIBUIDORA','XIOMARA MARQUEZ GULLOZO','PAMELA JAQUELIN DELGADO PATTY','MONICA DANIELA AYAVIRI CALDERON','IRIS SONIA LUCAS APONTE','GENERAL') 
group by EJERCICIO, V_MES,reg, VENDEDOR



/***** data del reprote bi BD TTL*/

/*****NUEVO DATA SET del reporte de BOL_INDICADOR ******************/
with x as (
SELECT to_number(ejercicio) ejercicio,to_number(v_MES) v_mes,reg,cod,descrip,vendedor, 1 nro_ttl_clie,0 nro_clie_visitado,0 nro_clie_vta, 0 bs_neto_clie,'Panel Clie' dato from bol_panel_clie group by ejercicio,v_MES,reg,vendedor,cod,descrip
UNION ALL
/************VISITAS DE AGENTES *********/
select EJERCICIO, V_MES,reg, cliente COD, descrip,VENDEDOR,0 nro_ttl_clie, 1 nro_clie_visitado,0 nro_clie_vta, 0 bs_neto_clie,'Visitas' dato FROM (select AGENTES_VISITAS.*,extract(year from fecha) EJERCICIO, extract(MONTH from fecha) V_MES,(SELECT RAZON_SOCIAL2 FROM CLIENTES A WHERE A.CODIGO_EMPRESA=AGENTES_VISITAS.empresa AND A.codigo_rapido=AGENTES_VISITAS.cliente) descrip,(SELECT p.nombre FROM agentes p WHERE p.codigo = AGENTES_VISITAS.agente AND empresa = agentes_visitas.empresa) vendedor,decode((SELECT zona FROM CLIENTES A WHERE A.CODIGO_EMPRESA=AGENTES_VISITAS.empresa AND A.codigo_rapido=AGENTES_VISITAS.cliente),'0410','SCZ','0420','LPZ','0430','CBBA','0440','TJA','0450','ALTO','0451','ALTO','0460','SCR','0461','SCR','0470','BENI','0471','BENI','SIN REG') reg from agentes_visitas) agentes_visitas WHERE EMPRESA='004' and ejercicio=2021 and v_mes=TO_NUMBER(to_char(:p_fecha,'MM'))
group by EJERCICIO, v_MES,reg,VENDEDOR,cliente,descrip
) 
select EJERCICIO, reg, VENDEDOR,sum(nro_ttl_clie) nro_ttl_clie, sum(nro_clie_visitado) nro_clie_visitado,sum( nro_clie_vta) nro_clie_vta, sum( bs_neto_clie) bs_neto_clie 
from x WHERE descrip NOT LIKE 'CLIENTE %' and vendedor not in ('RITA NORMINHA TOLEDO CHACON','CELIA LUJAN ORTUÑO ASTURIZAGA','-DISTRIBUIDORA','XIOMARA MARQUEZ GULLOZO','PAMELA JAQUELIN DELGADO PATTY','MONICA DANIELA AYAVIRI CALDERON','IRIS SONIA LUCAS APONTE','GENERAL') 
group by EJERCICIO, reg, VENDEDOR

/* A LA SQL anterior se quito V_MES, para que duplicara en otros meses.*/


/***** OTENER EL PNALE REGION */
SELECT to_number(ejercicio) ejercicio,to_number(v_MES) v_mes,reg,cod,descrip,vendedor, 1 nro_ttl_clie,0 nro_clie_visitado,0 nro_clie_vta, 0 bs_neto_clie,'Panel Clie' dato from bol_panel_clie group by ejercicio,v_MES,reg,vendedor,cod,descrip

SELECT * from bol_panel_clie




:where_lov AND EXISTS(SELECT 1 FROM domicilios_envio de WHERE de.codigo_cliente = clientes.codigo_rapido AND de.empresa = clientes.codigo_empresa) AND (:parametros.filtrar_clientes_agente = 'N' OR :global.usuario = :global.superusuario OR :parametros.agente IS NULL OR EXISTS(SELECT 1 FROM agentes_clientes ac WHERE ac.codigo_cliente = clientes.codigo_rapido AND ac.agente IN(SELECT ag.codigo FROM agentes ag WHERE ag.empresa = :global.codigo_empresa START WITH ag.codigo = :parametros.agente AND ag.empresa = :global.codigo_empresa CONNECT BY PRIOR ag.codigo = ag.codigo_padre AND ag.empresa = :global.codigo_empresa) AND ac.empresa = clientes.codigo_empresa) OR :global.usuario IN (SELECT ag.usuario FROM agentes ag WHERE ag.empresa = :global.codigo_empresa and ag.tipo_agente = 3))