select 
	wt.session_id, 
	wt.blocking_session_id,
	es.status,
	wt.wait_duration_ms,
	es.total_elapsed_time,
	db_name (tl.resource_database_id) Banco, 
	OBJECT_NAME(tl.resource_associated_entity_id,tl.resource_database_id) Objeto,
	tl.request_mode, 
	tl.request_status,
	wt.wait_type,
	wt.resource_description
  
  from sys.dm_tran_locks tl
      
      join sys.dm_os_waiting_tasks wt
		on tl.request_session_id = wt.session_id
	  
	  join sys.dm_exec_sessions es
		on tl.request_session_id = es.session_id

where
	--tl.resource_database_id=DB_ID('dbs600') 
	 --tl.resource_type='OBJECT'
	tl.request_status like 'WAIT'

ORDER BY wt.blocking_session_id asc

