/****** CONSULTA PARA VISTAS CRM UNIOD A LAS VENTAS POR CLIETNES*/

/**** PANEL CLIENTES*/

/*****VENTAS POR GESTOR RPN ******/

/******* PANEL DE CLIENTES POR GESTOR DE NEGOCIOS */

SELECT to_number(ejercicio) ejercicio,to_number(v_MES) v_mes,reg,cod,descrip,vendedor, 1 nro_ttl_clie,0 nro_clie_visitado,0 nro_clie_vta, 0 bs_neto_clie,'Panel Clie' dato from bol_panel_clie group by ejercicio,v_MES,reg,vendedor,cod,descrip
UNION ALL
/********ventas por cliente RPN *****/
select ejercicio,v_mes,reg,CLIENTE_ID cod,cliente_nombre descrip,VENDEDOR,0 nro_ttl_clie, 0 nro_clie_visitado,1 nro_clie_vta, sum(IMP_NETO) bs_neto_clie,'Clientes' dato FROM (SELECT BOL_BI_VTAS_PPTO.*,decode(uen,'BOL - PROCAPS',nombre_agente,'BOL - PROMEDICAL',nombre_agente,'BOL - SUIPHAR',substr(RPN2,5),'BOL - GRUNENTHAL',substr(RPN2,5),'BOL - HERSIL SA',(SELECT substr(NOMBRE,5) FROM VALORES_CLAVES V WHERE V.CLAVE ='RPN4' AND V.VALOR_CLAVE=(SELECT VALOR_CLAVE FROM  CLIENTES_CLAVES_ESTADISTICAS c WHERE c.CLAVE='RPN4' AND c.CODIGO_CLIENTE=BOL_BI_VTAS_PPTO.cliente_id AND c.CODIGO_EMPRESA='004')),'SIN UEN') VENDEDOR from BOL_BI_VTAS_PPTO) vta WHERE CANTIDAD>0 and EJERCICIO='2021' and v_mes=02 GROUP BY EJERCICIO, v_MES,reg,VENDEDOR,CLIENTE_ID,cliente_nombre
union all
/************VISITAS DE AGENTES *********/
select EJERCICIO, V_MES, cliente COD, descrip,VENDEDOR,0 nro_ttl_clie, 1 nro_clie_visitado,0 nro_clie_vta, 0 bs_neto_clie,'Visitas' dato FROM (select AGENTES_VISITAS.*,extract(year from fecha) EJERCICIO, extract(MONTH from fecha) V_MES,(SELECT RAZON_SOCIAL2 FROM CLIENTES A WHERE A.CODIGO_EMPRESA=AGENTES_VISITAS.empresa AND A.codigo_rapido=AGENTES_VISITAS.cliente) descrip,(SELECT p.nombre FROM agentes p WHERE p.codigo = AGENTES_VISITAS.agente AND empresa = agentes_visitas.empresa) vendedor from agentes_visitas) agentes_visitas WHERE EMPRESA='004' and ejercicio=2021 and v_mes=2
/****************************************/
AGENTES_VISITAS

select extract(year from fecha) EJERCICIO, extract(MONTH from fecha) V_MES,CODIGO COD,(SELECT RAZON_SOCIAL2 FROM CLIENTES A WHERE A.CODIGO_EMPRESA='004' AND A.CODIGO_CLIENTE=AGENTES_VISITAS.CODIGO) descrip,(SELECT p.nombre FROM agentes p WHERE p.codigo = AGENTES_VISITAS.agente AND empresa = agentes_visitas.empresa) VENDEDOR,0 nro_ttl_clie, 1 nro_clie_visitado,0 nro_clie_vta, 0 bs_neto_clie,'Visitas' dato 
FROM AGENTES_VISITAS WHERE EMPRESA='004'

select * FROM AGENTES_VISITAS
WHERE EMPRESA='004' AND CLIENTE='009357'
(SELECT p.nombre FROM agentes p WHERE p.codigo = AGENTES_VISITAS.agente AND empresa = agentes_visitas.empresa

SELECT RAZON_SOCIAL2 FROM CLIENTES A WHERE A.CODIGO_EMPRESA='004' AND A.CODIGO_CLIENTE=AGENTES_VISITAS.CODIGO