use [DW_PBM_Funcional]
		
				  declare @idtabela int = object_id ('t_FatoVendaProduto')
				  select 
					  object_name (ius.object_id) Tabela,
					  s.name indice,
					  s.rowcnt,
					  s.rowmodctr,
					  cast (100*(cast (s.rowmodctr as decimal (20,2))/cast (s.rowcnt as decimal (20,2))) as decimal (10,2)) as mod_in_percent,
					  stats_date(s.id, s.indid) as Lastupdate_Stat,
					  ius.user_seeks,
					  ius.user_lookups,
					  ius.user_scans,
					  ius.last_user_update,
					  ius.last_system_update
				  from sys.sysindexes s
				    join sys.dm_db_index_usage_stats ius
						on s.id = ius.object_id and s.indid = ius.index_id
					where  ius.object_id = @idtabela and
						ius.index_id > 0
						and s.rowcnt > 0
					order by mod_in_percent desc

					