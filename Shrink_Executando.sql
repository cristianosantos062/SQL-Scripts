select 
	DB_NAME(er.database_id) dbname, 
	er.session_id, er.status,
	er.blocking_session_id BlkBy,
	er.wait_type,
	es.login_name,
	er.start_time,
	er.percent_complete,
	er.estimated_completion_time/60000 estimated_time_min,
	er.command,
	SubsTring(st.text,er.statement_start_offset/2, (Case When er.statement_end_offset = -1 Then Len(Convert(nVarChar(max), st.text))*2 
                                                                                                                  ELSE er.statement_end_offset
                                                                                                                  END 
       - er.statement_start_offset)/2) as TrechoQueryEmExecusao

from sys.dm_exec_requests er
Cross Apply sys.dm_exec_sql_text (er.sql_handle) st
Join sys.dm_exec_sessions es
on er.session_id = es.session_id
where er.percent_complete > 0