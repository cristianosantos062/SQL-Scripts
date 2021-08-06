use master
go
select 
	DB_NAME(er.database_id) dbname, 
	er.session_id, er.status,
	er.blocking_session_id BlkBy,
	er.wait_time,
	er.wait_type,
	es.host_name,	
	es.login_name,
	es.login_time,
	es.last_request_end_time,
	er.wait_time,
	er.total_elapsed_time/60000 elapsed_time,
	er.cpu_time,
	er.command,
	OBJECT_NAME(st.objectid,er.database_id) [object_name],
	es.program_name,
	
	SubsTring(st.text,er.statement_start_offset/2, (Case When er.statement_end_offset = -1 Then Len(Convert(nVarChar(max), st.text))*2 
                                                                                                                  ELSE er.statement_end_offset
                                                                                                                  END 
       - er.statement_start_offset)/2) as TrechoQueryEmExecusao

from sys.dm_exec_requests er
Cross Apply sys.dm_exec_sql_text (er.sql_handle) st
Join sys.dm_exec_sessions es
on er.session_id = es.session_id
where er.session_id > 50
and DB_NAME(er.database_id)='DW_GestaoIntegrada_SOMPO'
order by cpu_time desc


select reads, writes, logical_reads from sys.dm_exec_requests where session_id = 80