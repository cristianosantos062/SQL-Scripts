select top 10
	 qs.creation_time,
	 qs.last_execution_time,
	 qs.execution_count,
	 qs.total_worker_time/qs.execution_count/1000 media_total_worker_time,
	 qs.total_elapsed_time/qs.execution_count/1000 media_total_elapsed_time,
	 db_name (st.dbid) dbname,
	 Object_name (st.objectid) objectname,

	 SubsTring(st.text,qs.statement_start_offset/2, (Case When qs.statement_end_offset = -1 Then Len(Convert(nVarChar(max), st.text))*2 
																													  ELSE qs.statement_end_offset
																													  END 
		   - qs.statement_start_offset)/2) as TrechoQueryEmExecusao,
	qp.query_plan as PlanoCompleto
	--CAST(tpq.query_plan as XML) as TrechoPlanoEmExecusao 

from sys.dm_exec_query_stats qs
	--Cross apply sys.dm_exec_text_query_plan(qs.plan_handle, qs.statement_start_offset , qs.statement_end_offset) tpq
	Cross apply sys.dm_exec_query_plan (qs.plan_handle) qp
	Cross Apply sys.dm_exec_sql_text (qs.sql_handle) st

where qs.total_elapsed_time/execution_count/1000 > 120

order by media_total_worker_time desc