print("Hola Mundo desde Python. Saludos !!!");



case when crmexpedientes_CAB.status_expediente='01' then round(sysdate-CRMEXPEDIENTES_CAB.FECHA_inicio,6) else round(crmexpedientes_CAB.FECHA_FIN_REAL-CRMEXPEDIENTES_CAB.FECHA_inicio,6) end