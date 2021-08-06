select 
	ec.session_id, 
	db_name(et.dbid) dbname, 
	es.status,
	es.total_elapsed_time,
	es.last_request_end_time,
	es.login_time,
	es.host_name,
	es.host_process_id, 
	et.text,
	es.program_name
from sys.dm_exec_connections ec
cross apply sys.dm_exec_sql_text(ec.most_recent_sql_handle) et
join sys.dm_exec_sessions es
on ec.session_id = es.session_id
where ec.session_id>50