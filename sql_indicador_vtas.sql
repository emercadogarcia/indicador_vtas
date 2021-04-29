/****sql para los indicadores */
select VIEW_NAME,TEXT_VC from ALL_VIEWS where view_name like 'VTA_VERTI%'
select VIEW_NAME,TEXT_VC from ALL_VIEWS where view_name like 'VTA_HOR%'
view VTA_VERTI:
(	SELECT EJERCICIO, MES AS MES,UEN,T1.CODIGO_ARTICULO, T1.ARTICULO_NOMBRE, T1.REG, COUNT(T1.CLIENTE_ID) AS CANT_CLIENTES, SUM(T1.				CANTIDAD_UNIT) AS CANTIDAD_UNIT, sum(T1.IMPORTE_FACTURADO) AS BS_IMPORTE_FACTURADO, (SELECT COUNT(NOMBRE) AS CANTIDAD_CLIENTES FROM 	(SELECT decode(CLIENTES.ZONA,'0410','SCZ','0420','LPZ','0430','CBBA','0440','TJA','0450','ALTO','0451','ALTO','0460','SCR','0461',		'SCR','0470','BENI','0471','BENI','SIN REG') REG, CLIENTES.*
	FROM CLIENTES WHERE CODIGO_EMPRESA='004' AND FECHA_BAJA IS NULL) T2 WHERE T2.REG= T1.REG GROUP BY REG) AS CANTIDAD_CLIENTES_REG
	FROM (SELECT EJERCICIO, V_MES AS MES, CODIGO_ARTICULO, ARTICULO_NOMBRE, CLIENTE_ID, CLIENTE_NOMBRE,UEN, REG, SUM(CANTIDAD) AS CANTIDAD_UNIT, SUM(IMP_FACTURADO) AS IMPORTE_FACTURADO fROM BOL_BI_VTAS_PPTO WHERE CANTIDAD>0 GROUP BY EJERCICIO,V_MES,CODIGO_ARTICULO, ARTICULO_NOMBRE,CLIENTE_ID,CLIENTE_NOMBRE,UEN, REG)  T1
	GROUP BY EJERCICIO, MES,UEN,T1.CODIGO_ARTICULO, T1.ARTICULO_NOMBRE, T1.REG
)

VIEW VTA_HOR    /**REVISAR SQL ****/
(SELECT EJERCICIO, MES, REG, CLIENTE_ID, CLIENTE_NOMBRE, UEN, SUM(CANTIDAD_UNIT) AS CANTIDAD_UNIT, count(CODIGO_ARTICULO) as cantidad_articulos,(SELECT CANTIDAD_PRODUCTO FROM (SELECT DESCRIPCION AS UEN, COUNT(CODIGO_ARTICULO) AS CANTIDAD_PRODUCTO FROM (SELECT A.codigo_articulo, A.descrip_comercial, F.DESCRIPCION FROM ARTICULOS A, FAMILIAS F WHERE A.codigo_empresa='004' AND A.CODIGO_SITUACION='A' AND A.CODIGO_ESTAD6='PT' AND A.CODIGO_EMPRESA=F.CODIGO_EMPRESA AND A.CODIGO_ESTAD5 = F.CODIGO_FAMILIA) P1 GROUP BY DESCRIPCION) T1 WHERE T1.UEN= P1.UEN) AS CANTIDAD_PROD_UEN,SUM(IMPORTE_FACTURADO) AS IMPORTE_FACTURADO 
	FROM (
		SELECT EJERCICIO,V_MES AS MES,REG,CLIENTE_ID,CLIENTE_NOMBRE,UEN,CODIGO_ARTICULO,ARTICULO_NOMBRE, SUM(CANTIDAD) AS CANTIDAD_UNIT, SUM(IMP_FACTURADO) AS IMPORTE_FACTURADO
		FROM BOL_BI_VTAS_PPTO
		GROUP BY EJERCICIO, V_MES, REG,CLIENTE_ID,CLIENTE_NOMBRE,UEN,CODIGO_ARTICULO,ARTICULO_NOMBRE) P1 
	GROUP BY EJERCICIO, MES,REG,CLIENTE_ID,CLIENTE_NOMBRE, UEN
)

/* ************* */
REGION | UEN | # clientes ttl | # Clie Visitado | # venta realizada a clie | # articulos vendidos | unidades vendidas | valor de la venta | promedio vta 6 meses UN|

SELECT EJERCICIO, V_MES AS MES, CODIGO_ARTICULO, ARTICULO_NOMBRE, CLIENTE_ID, CLIENTE_NOMBRE,UEN, REG, SUM(CANTIDAD) AS CANTIDAD_UNIT, SUM(IMP_FACTURADO) AS IMPORTE_FACTURADO fROM BOL_BI_VTAS_PPTO WHERE CANTIDAD>0 GROUP BY EJERCICIO,V_MES,CODIGO_ARTICULO, ARTICULO_NOMBRE,CLIENTE_ID,CLIENTE_NOMBRE,UEN, REG)

/** lista general de las ventas*****/
select ejercicio,v_mes,uen,reg,subreg,CLIENTE_ID,cliente_nombre,0 nro_clie_visitado,0 nro_vta_real ,cantidad,IMP_NETO,IMP_FACTURADO,0 prom_un_6m fROM BOL_BI_VTAS_PPTO WHERE CANTIDAD>0 and EJERCICIO='2021' and v_mes=02
/************************************************************************************************************************/

/***** select CLEITES atendidos por vendedor**/
with a as (
select ejercicio,v_mes,uen,reg,subreg,CLIENTE_ID cod,cliente_nombre descrip,VENDEDOR,0 nro_ttl_clie, sum(0) nro_clie_visitado,1 nro_clie_vta,0 nro_Art_vta ,sum(cantidad) un_clie,sum(IMP_NETO) bs_neto_clie,0 un_art,0 bs_neto_art,sum(0) prom_un_6m,'Clientes' dato FROM (SELECT BOL_BI_VTAS_PPTO.*,decode(uen,'BOL - PROCAPS',nombre_agente,'BOL - PROMEDICAL',nombre_agente,'BOL - SUIPHAR',substr(RPN2,5),'BOL - GRUNENTHAL',substr(RPN2,5),'BOL - HERSIL SA',(SELECT substr(NOMBRE,5) FROM VALORES_CLAVES V WHERE V.CLAVE ='RPN4' AND V.VALOR_CLAVE=(SELECT VALOR_CLAVE FROM  CLIENTES_CLAVES_ESTADISTICAS c WHERE c.CLAVE='RPN4' AND c.CODIGO_CLIENTE=BOL_BI_VTAS_PPTO.cliente_id AND c.CODIGO_EMPRESA='004')),'SIN UEN') VENDEDOR from BOL_BI_VTAS_PPTO) vta WHERE CANTIDAD>0 and EJERCICIO='2021' and v_mes=02 GROUP BY EJERCICIO, v_MES,UEN,reg,subreg,VENDEDOR,CLIENTE_ID,cliente_nombre
/****** Articulos vendidos por vendedor */ union all
select ejercicio,v_mes,uen,reg,subreg,CODIGO_ARTICULO cod,ARTICULO_NOMBRE descrip,VENDEDOR,0 nro_ttl_clie, sum(0) nro_clie_visitado,sum(0) nro_clie_vta,1 nro_Art_vta ,0 un_clie,0 bs_neto_clie,sum(cantidad) un_art,sum(IMP_NETO) bs_neto_art,sum(0) prom_un_6m,'Articulos' dato FROM (SELECT BOL_BI_VTAS_PPTO.*,decode(uen,'BOL - PROCAPS',nombre_agente,'BOL - PROMEDICAL',nombre_agente,'BOL - SUIPHAR',substr(RPN2,5),'BOL - GRUNENTHAL',substr(RPN2,5),'BOL - HERSIL SA',(SELECT substr(NOMBRE,5) FROM VALORES_CLAVES V WHERE V.CLAVE ='RPN4' AND V.VALOR_CLAVE=(SELECT VALOR_CLAVE FROM  CLIENTES_CLAVES_ESTADISTICAS c WHERE c.CLAVE='RPN4' AND c.CODIGO_CLIENTE=BOL_BI_VTAS_PPTO.cliente_id AND c.CODIGO_EMPRESA='004')),'SIN UEN') VENDEDOR from BOL_BI_VTAS_PPTO) vta WHERE CANTIDAD>0 and EJERCICIO='2021' and v_mes=02 GROUP BY EJERCICIO, v_MES,UEN,reg,subreg,VENDEDOR,CODIGO_ARTICULO,ARTICULO_NOMBRE ),
b as (SELECT to_number(ejercicio) ejercicio,to_number(v_MES) v_mes,reg,subreg,cod,descrip,vendedor,'Panel Clie' dato from bol_panel_clie group by ejercicio,v_MES,reg,subreg,vendedor,cod,descrip) 
select dato,ejercicio,v_mes,reg,subreg,cod,descrip,VENDEDOR,0 nro_ttl_clie, 0 nro_clie_visitado,1 nro_clie_vta,0 nro_Art_vta ,sum(un_clie) un_clie,sum(bs_neto_clie) bs_neto_clie,sum(un_art) un_art,sum(bs_neto_art) bs_neto_art,sum(0) prom_un_6m,0 nro_ttl_art,1 cont from a where dato='Clientes' group by dato,ejercicio,v_mes,reg,subreg,cod,descrip,VENDEDOR union all 
select dato,ejercicio,v_mes,reg,subreg,cod,descrip,VENDEDOR,0 nro_ttl_clie, 0 nro_clie_visitado,0 nro_clie_vta,1 nro_Art_vta ,sum(un_clie) un_clie,sum(bs_neto_clie) bs_neto_clie,sum(un_art) un_art,sum(bs_neto_art) bs_neto_art,sum(0) prom_un_6m,0 nro_ttl_art,1 cont from a where dato='Articulos' group by dato,ejercicio,v_mes,reg,subreg,cod,descrip,VENDEDOR 
UNION all
SELECT dato,ejercicio,v_mes,reg,subreg,cod,descrip,vendedor,1 nro_ttl_clie, 0 nro_clie_visitado,0 nro_clie_vta,0 nro_Art_vta ,0 un_clie,0 bs_neto_clie,0 un_art,0 bs_neto_art,0 prom_un_6m,0 nro_ttl_art,1 cont from b group by dato,ejercicio,v_mes,reg,subreg,cod,descrip,VENDEDOR 
union all
SELECT 'Total Art x rpn' dato,TO_number(ejercicio) ejercicio,to_number(v_mes) v_mes,reg,subreg,'TOTAL' cod,'ARTICULOS' descrip,vendedor,0 nro_ttl_clie, 0 nro_clie_visitado,0 nro_clie_vta,0 nro_Art_vta ,0 un_clie,0 bs_neto_clie,0 un_art,0 bs_neto_art,0 prom_un_6m,avg(articulo) nro_ttl_art,1 cont from (select BOL_PANEL_CLIE.*, (select count(*) ttl_prod from (select articulos.*,(SELECT descripcion FROM familias WHERE codigo_familia= articulos.codigo_estad5 AND numero_tabla = 5 AND ultimo_nivel = 'S' AND codigo_empresa =articulos.codigo_empresa) uen from articulos) art where  art.codigo_empresa='004' and art.codigo_estad6='PT' and art.codigo_situacion='A' AND art.TIPO_MATERIAL='M' AND art.CODIGO_ESTAD5 LIKE '040%' ) articulo from BOL_PANEL_CLIE) art_rpn_uen group by ejercicio,v_mes,reg,subreg,VENDEDOR 

http://wl3.erplibra.com:80/xmlpserver/ADAPTACIONES/CLIENTE/130391/INFORMES/bol_indicadores_vtas.xdo?&_xmode=2

/****** obtener total de clientes panel resumen********/
create or replace view bol_panel_clie as 
with panel as (select * FROM (SELECT clientes.*,(SELECT substr(NOMBRE,5) FROM VALORES_CLAVES V WHERE V.CLAVE ='RPN2' AND V.VALOR_CLAVE=(SELECT VALOR_CLAVE FROM CLIENTES_CLAVES_ESTADISTICAS c WHERE c.CLAVE='RPN2' AND c.CODIGO_CLIENTE=clientes.codigo_rapido AND c.CODIGO_EMPRESA='004')) RPN2,(SELECT substr(NOMBRE,5) FROM VALORES_CLAVES V WHERE V.CLAVE ='RPN4' AND V.VALOR_CLAVE=(SELECT VALOR_CLAVE FROM CLIENTES_CLAVES_ESTADISTICAS c WHERE c.CLAVE='RPN4' AND c.CODIGO_CLIENTE=clientes.codigo_rapido AND c.CODIGO_EMPRESA='004')) RPN4,decode(CLIENTES.ZONA,'0410','SCZ','0420','LPZ','0430','CBBA','0440','TJA','0450','ALTO','0451','ALTO','0460','SCR','0461','SCR','0470','BENI','0471','BENI','SIN REG') reg,decode(CLIENTES.ZONA,'0410','SCZ','0420','LPZ','0430','CBBA','0440','TJA','0450','ALTO','0451','ALTO','0460','SCR','0461','POT','0470','BENI','0471','PAN','SIN SUBREG') subreg,(select nombre from agentes a where a.empresa=clientes.codigo_empresa and a.codigo=(select agente from agentes_clientes ac where ac.empresa=clientes.codigo_empresa and ac.CODIGO_CLIENTE=clientes.codigo_rapido)) rpn1,to_char(sysdate,'YYYY') ejercicio,to_char(sysdate,'MM') v_mes from clientes) clie where codigo_empresa='004' and FECHA_BAJA is NULL AND ESTADO='BOL')
select ejercicio,v_mes, 'BOL - PROCAPS' uen,reg,subreg,codigo_rapido cod,razon_social2 descrip,rpn1 VENDEDOR from panel
GROUP BY ejercicio,v_mes,reg,subreg,rpn1,CODIGO_rapido,razon_social2 UNION ALL
select ejercicio,v_mes, 'BOL - PROMEDICAL' uen,reg,subreg,codigo_rapido cod,razon_social2 descrip,rpn1 VENDEDOR from panel
GROUP BY ejercicio,v_mes,reg,subreg,rpn1,CODIGO_rapido,razon_social2 UNION ALL
select ejercicio,v_mes, 'BOL - SUIPHAR' uen,reg,subreg,codigo_rapido cod,razon_social2 descrip,rpn2 VENDEDOR from panel
GROUP BY ejercicio,v_mes,reg,subreg,rpn2,CODIGO_rapido,razon_social2 UNION ALL
select ejercicio,v_mes, 'BOL - GRUNENTHAL' uen,reg,subreg,codigo_rapido cod,razon_social2 descrip,rpn2 VENDEDOR from panel
GROUP BY ejercicio,v_mes,reg,subreg,rpn2,CODIGO_rapido,razon_social2 UNION ALL
select ejercicio,v_mes, 'BOL - HERSIL SA' uen,reg,subreg,codigo_rapido cod,razon_social2 descrip,rpn4 VENDEDOR from panel
GROUP BY ejercicio,v_mes,reg,subreg,rpn4,CODIGO_rapido,razon_social2  
/***********/
SELECT ejercicio,v_MES,reg,subreg,cod,descrip,vendedor,1 nro_ttl_clie, 0 nro_clie_visitado,0 nro_clie_vta,0 nro_Art_vta ,0 un,0 bs_neto,0 bs_fact,0 prom_un_6m,0 nro_ttl_art,0 nro_ttl_art,1 cont from BOL_PANEL_CLIE group by ejercicio,v_MES,reg,subreg,vendedor,cod,descrip

select vendedor,cod,descrip, sum(1) nro_ttl_clie, count(*) ttl_clie from bol_panel_clie group by vendedor,cod,descrip

/*para el total de articulos */
SELECT to_number(ejercicio) ejercicio,to_number(v_MES) v_mes,reg,subreg,cod,descrip,vendedor,'Panel Clie' dato from bol_panel_clie group by ejercicio,v_MES,reg,subreg,vendedor,cod,descrip

select vendedor from bol_panel_clie group by vendedor
union 
select codigo_estad5 cod, uen descrip, count(*) ttl_prod from (select articulos.*,(SELECT descripcion FROM familias WHERE codigo_familia= articulos.codigo_estad5 AND numero_tabla = 5 AND ultimo_nivel = 'S' AND codigo_empresa =articulos.codigo_empresa) uen from articulos) art where  codigo_empresa='004' and codigo_estad6='PT' and codigo_situacion='A' AND TIPO_MATERIAL='M' AND CODIGO_ESTAD5 LIKE '040%'  group by codigo_estad5,uen

/************** PORTAFOLIO DE ARTICULOS ********************/
select ejercicioc,v_mes,reg  from (select articulos.*,(SELECT descripcion FROM familias WHERE codigo_familia= articulos.codigo_estad5 AND numero_tabla = 5 AND ultimo_nivel = 'S' AND codigo_empresa =articulos.codigo_empresa) uen from articulos) art where codigo_empresa='004'


/* numero de producto por UEN  tipo comerical activos y PT*/
select to_number(to_char(sysdate,'YYYY')) ejercicio,to_number(to_char(sysdate,'MM')) v_mes,codigo_estad5 cod, uen descrip, count(*) ttl_prod from (select articulos.*,(SELECT descripcion FROM familias WHERE codigo_familia= articulos.codigo_estad5 AND numero_tabla = 5 AND ultimo_nivel = 'S' AND codigo_empresa =articulos.codigo_empresa) uen from articulos) art where  codigo_empresa='004' and codigo_estad6='PT' and codigo_situacion='A' AND TIPO_MATERIAL='M' AND CODIGO_ESTAD5 LIKE '040%'  group by codigo_estad5,uen
/***************************/
SELECT COUNT(*) TTL_PROD FROM articulos where codigo_empresa='004' and codigo_estad6='PT' and codigo_situacion='A' AND TIPO_MATERIAL='M' AND CODIGO_ESTAD5 LIKE '040%'

select count(*) from articulos where codigo_articulo=BOL_BI_VTAS_PPTO.codigo_articulo and codigo_empresa='004' and codigo_estad6='PT' 

select CODIGO_ESTAD5,TIPO_MATERIAL, count(*) ttl_prod from articulos where  codigo_empresa='004' and codigo_estad6='PT' and codigo_situacion='A' AND TIPO_MATERIAL='M' AND CODIGO_ESTAD5 LIKE '040%'  group by CODIGO_ESTAD5,TIPO_MATERIAL

and


BOL - HERSIL SA
BOL - PROCAPS
BOL - PROMEDICAL
BOL - SUIPHAR

TO_NUMBER(to_char(sysdate,'MM'))
/*** codigo apoyo*/
SELECT estado,ZONA, COUNT(*) NRO_CLIE FROM CLIENTES where estado='BOL' AND  codigo_empresa='004' and FECHA_BAJA is NULL GROUP BY estado,ZONA
select nombre from agentes a where a.empresa='004' and a.codigo=(select agente from agentes_clientes ac where ac.empresa='004' and ac.CODIGO_CLIENTE='007177') 

(SELECT NOMBRE FROM VALORES_CLAVES V WHERE V.CLAVE ='RPN3' AND V.VALOR_CLAVE=(SELECT VALOR_CLAVE FROM CLIENTES_CLAVES_ESTADISTICAS c WHERE c.CLAVE='RPN3' AND c.CODIGO_CLIENTE=BOL_BI_VTAS_PPTO.cliente_id AND c.CODIGO_EMPRESA='004')) RPN3, (SELECT NOMBRE FROM VALORES_CLAVES V WHERE V.CLAVE ='RPN4' AND V.VALOR_CLAVE=(SELECT VALOR_CLAVE FROM  CLIENTES_CLAVES_ESTADISTICAS c WHERE c.CLAVE='RPN4' AND c.CODIGO_CLIENTE=BOL_BI_VTAS_PPTO.cliente_id AND c.CODIGO_EMPRESA='004')) RPN4,

select * from agentes_clientes where empresa='004' and CODIGO_CLIENTE='007177'
select * from agentes where empresa='004' and codigo='040110'

(SELECT A.codigo_articulo, A.descrip_comercial, F.DESCRIPCION FROM ARTICULOS A, FAMILIAS F WHERE A.codigo_empresa='004' AND A.CODIGO_SITUACION='A' AND A.CODIGO_ESTAD6='PT' AND A.CODIGO_EMPRESA=F.CODIGO_EMPRESA AND A.CODIGO_ESTAD5 = F.CODIGO_FAMILIA)

select * from (select articulos.*,(SELECT descripcion FROM familias WHERE codigo_familia= articulos.codigo_estad5 AND numero_tabla = 5 AND ultimo_nivel = 'S' AND codigo_empresa =articulos.codigo_empresa) uen from articulos) art where codigo_empresa='004'



select * fROM BOL_BI_VTAS_PPTO WHERE CANTIDAD>0 and EJERCICIO='2021' and v_mes=02
/*********************************/
vendedor
CASE when articulos.codigo_estad3 in ('VITAL CARE','PROCAPS','CLINICAL SP','EUROFARMA') THEN agentes.nif when articulos.codigo_estad3 in ('HERSIL') THEN trim(subStr(clientes.RPN4,0,3)) else trim(subStr(clientes.RPN2,0,3)) end GESTOR_VTAS

select * from clientes where codigo_empresa='004' and cliente='007490'

(SELECT NOMBRE FROM VALORES_CLAVES V WHERE V.CLAVE ='RPN2' AND V.VALOR_CLAVE=(SELECT VALOR_CLAVE FROM  CLIENTES_CLAVES_ESTADISTICAS c WHERE c.CLAVE='RPN2' AND c.CODIGO_CLIENTE=clientes.codigo_rapido AND c.CODIGO_EMPRESA=clientes.codigo_empresa)) RPN2,
(SELECT NOMBRE FROM VALORES_CLAVES V WHERE V.CLAVE ='RPN4' AND V.VALOR_CLAVE=(SELECT VALOR_CLAVE FROM  CLIENTES_CLAVES_ESTADISTICAS c WHERE c.CLAVE='RPN4' AND c.CODIGO_CLIENTE=clientes.codigo_rapido AND c.CODIGO_EMPRESA=clientes.codigo_empresa)) RPN4

/************articulos ****************/
select CODIGO_ARTICULO,descrip_comercial,CODIGO_ESTAD3 lab,CODIGO_ESTAD5 uen,CODIGO_ESTAD6 tipo_articulo,d_tipo_articulo,TIPO_MATERIAL,codigo_situacion from (select articulos.*,(SELECT descripcion FROM familias WHERE codigo_familia=articulos.codigo_estad6 AND numero_tabla = 6  AND ultimo_nivel = 'S' AND codigo_empresa =articulos.codigo_empresa) d_tipo_articulo from articulos) articulos where codigo_empresa='004' and CODIGO_ESTAD5 like '040%'

(SELECT descripcion FROM familias WHERE codigo_familia=articulos.codigo_estad6 AND numero_tabla = 6  AND ultimo_nivel = 'S' AND codigo_empresa =va_articulos.codigo_empresa)


/********* sql para dm bi ************/
with x as (
SELECT to_number(ejercicio) ejercicio,to_number(v_MES) v_mes,reg,cod,descrip,vendedor, 1 nro_ttl_clie,0 nro_clie_visitado,0 nro_clie_vta, 0 bs_neto_clie,'Panel Clie' dato from bol_panel_clie group by ejercicio,v_MES,reg,vendedor,cod,descrip
UNION ALL
/************VISITAS DE AGENTES *********/
select EJERCICIO, V_MES,reg, cliente COD, descrip,VENDEDOR,0 nro_ttl_clie, 1 nro_clie_visitado,0 nro_clie_vta, 0 bs_neto_clie,'Visitas' dato FROM (select AGENTES_VISITAS.*,extract(year from fecha) EJERCICIO, extract(MONTH from fecha) V_MES,(SELECT RAZON_SOCIAL2 FROM CLIENTES A WHERE A.CODIGO_EMPRESA=AGENTES_VISITAS.empresa AND A.codigo_rapido=AGENTES_VISITAS.cliente) descrip,(SELECT p.nombre FROM agentes p WHERE p.codigo = AGENTES_VISITAS.agente AND empresa = agentes_visitas.empresa) vendedor,decode((SELECT zona FROM CLIENTES A WHERE A.CODIGO_EMPRESA=AGENTES_VISITAS.empresa AND A.codigo_rapido=AGENTES_VISITAS.cliente),'0410','SCZ','0420','LPZ','0430','CBBA','0440','TJA','0450','ALTO','0451','ALTO','0460','SCR','0461','SCR','0470','BENI','0471','BENI','SIN REG') reg from agentes_visitas) agentes_visitas WHERE EMPRESA='004' and ejercicio=2021 and v_mes=TO_NUMBER(to_char(:p_fecha,'MM'))
group by EJERCICIO, v_MES,reg,VENDEDOR,cliente,descrip
) 
select EJERCICIO, V_MES,reg, VEN.DEDOR,sum(nro_ttl_clie) nro_ttl_clie, sum(nro_clie_visitado) nro_clie_visitado,sum( nro_clie_vta) nro_clie_vta, sum( bs_neto_clie) bs_neto_clie 
from x WHERE descrip NOT LIKE 'CLIENTE %' and vendedor not in ('RITA NORMINHA TOLEDO CHACON','CELIA LUJAN ORTUÑO ASTURIZAGA','-DISTRIBUIDORA','XIOMARA MARQUEZ GULLOZO','PAMELA JAQUELIN DELGADO PATTY','MONICA DANIELA AYAVIRI CALDERON','IRIS SONIA LUCAS APONTE','GENERAL') 
group by EJERCICIO, V_MES,reg, VENDEDOR