  declare 
	  @Banco varchar(100) = 'GI_GestaoIntegrada_SOMPO',


	  @logspace nvarchar (25) = 'dbcc sqlperf(logspace)'
  drop table #t_LogSpace
  create table #t_LogSpace (databaseName varchar(100), LogSize_MB numeric, LogSpaceUsed_Perc numeric(10,2), Status int)
  Insert into #t_LogSpace EXECUTE sp_executesql @logspace
  select * from #t_LogSpace where  databaseName = @Banco