select 
	db_name (st.dbid) dbname,
	OBJECT_NAME(es.object_id, es.database_id) objeto,
	qs.last_execution_time,

	SubsTring(st.text,qs.statement_start_offset/2, (Case When qs.statement_end_offset = -1 Then Len(Convert(nVarChar(max), st.text))*2 
																													  ELSE qs.statement_end_offset
																													  END 
		   - qs.statement_start_offset)/2) as TrechoQuqsyEmExecusao

from sys.dm_exec_query_stats qs
     Cross Apply sys.dm_exec_sql_text (qs.sql_handle) st
	 join sys.dm_exec_procedure_stats es on qs.sql_handle = es.sql_handle

where OBJECT_NAME(es.object_id, es.database_id)='SPN_ENQ_PROC_ProcessaApontamentos'
	order by last_execution_time desc