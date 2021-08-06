use master
go
select 
	mg.session_id, 
	db_name (er.database_id) [db_name],
	mg.request_time,
	mg.grant_time, 
	mg.requested_memory_kb,
	mg.granted_memory_kb,
	mg.query_cost,
	mg.dop,
	OBJECT_NAME(st.objectid,er.database_id) [object_name],
	SubsTring(st.text,er.statement_start_offset/2, (Case When er.statement_end_offset = -1 Then Len(Convert(nVarChar(max), st.text))*2 
                                                                                                                ELSE er.statement_end_offset
                                                                                                                END 
       - er.statement_start_offset)/2) as TrechoQueryEmExecusao,
    qp.query_plan

from sys.dm_exec_query_memory_grants mg

Cross apply sys.dm_exec_sql_text (mg.plan_handle) st
Cross apply sys.dm_exec_query_plan (mg.plan_handle) qp
join 
	sys.dm_exec_requests er
	on mg.session_id=er.session_id
order by granted_memory_kb desc

	go

	select sum (requested_memory_kb)/1024.00 requested_memory_MB, sum (granted_memory_kb)/1024.00 granted_memory_MB from sys.dm_exec_query_memory_grants