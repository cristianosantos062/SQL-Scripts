      -- top 10 TEMPDB Data Consumers
            select top 10
                  TSP.session_id, 
                  TSP.request_id, 
                  (select SUM(size)*1.0/128 from tempdb.sys.database_files where type_desc = 'ROWS') as tempdb_size_MB,
                  TSP.task_alloc as task_page_alloc,
                  TSP.task_alloc*1.0/128 as task_alloc_MB,
                  ((TSP.task_alloc*1.0/128) / (select SUM(size)*1.0/128 AS [size in MB] from tempdb.sys.database_files where type_desc = 'ROWS'))*100 as percent_used,
                  -- TSP.task_dealloc,  
                  SES.login_time,
                  SES.last_request_start_time,
                  SES.login_name,
                  SES.nt_domain,
                  SES.nt_user_name,
                  SES.[status],
                  SES.[host_name],
                  SES.[program_name],     
                  (SELECT SUBSTRING(text, REQ.statement_start_offset/2 + 1,
                          (CASE WHEN statement_end_offset = -1 
                                THEN LEN(CONVERT(nvarchar(max),text)) * 2 
                                       ELSE statement_end_offset 
                                END - REQ.statement_start_offset)/2)
                   FROM sys.dm_exec_sql_text(sql_handle)) AS query_text,
                  (SELECT query_plan from sys.dm_exec_query_plan(REQ.plan_handle)) as query_plan
            from  (Select     session_id, 
                                    request_id,
                                    sum(internal_objects_alloc_page_count + user_objects_alloc_page_count) as task_alloc,
                                    sum (internal_objects_dealloc_page_count + user_objects_dealloc_page_count) as task_dealloc
                              from sys.dm_db_task_space_usage 
                              group by session_id, request_id) as TSP 
                              left join sys.dm_exec_requests as REQ
                                    on (TSP.session_id = REQ.session_id and TSP.request_id = REQ.request_id)
                              left join sys.dm_exec_sessions as SES
                                    on TSP.session_id = SES.session_id
            where TSP.session_id > 50
                  and TSP.task_alloc > 0
            order by TSP.task_alloc DESC


