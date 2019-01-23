-- Phase0 - Pre-load data (transporttype, transport and week operational schedule)

-- 0.0 Drop all tempo tables
call dropAllTempTables();
call clearAllData();
 
-- 0.1 Transport Type
insert into transporttype (name) values ("road");
set @my_transport_type_id = last_insert_id();
    
-- 0.2 Transport
insert into transport (transporttypeid, name) values (@my_transport_type_id, "Bus");
set @my_transport_id = last_insert_id();

-- Week Operational Schedule
call createWeekOperationSchedule("Segunda a Sexta", 1, 1, 1, 1, 1, 0, 0, @insertWosId);
call createWeekOperationSchedule("Sábados", 0, 0, 0, 0, 0, 1, 0, @insertWosId);
call createWeekOperationSchedule("Domingos e Feriados", 0, 0, 0, 0, 0, 0, 1, @insertWosId);

-- Phase1 - Load and store data from files in memory

-- 1.1 create all temp tables
call createAllTempTables();

-- 1.2 Load data from files

-- 1.2.1 load companies
load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\madeira-companies.csv'
into table tmpcompany
FIELDS TERMINATED BY ';' 
lines terminated by '\n'
ignore 1 rows
;

-- 1.2.2 load stations
load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\madeira-stations.csv'
into table tmpstation
FIELDS TERMINATED BY ';' 
lines terminated by '\n'
ignore 1 rows
;

-- 1.2.3 load lines
load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\madeira-lines.csv'
into table tmpline
FIELDS TERMINATED BY ';' 
lines terminated by '\n'
ignore 1 rows
;

-- 1.2.4 load trips
load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\madeira-trips.csv' 
into table tmptrip
FIELDS TERMINATED BY ';'
lines starting by 'TR'   
      terminated by '\n'
ignore 2 rows
(@seperator,routeName,wosName,startTime,endTime,@schoolPeriod,remarks)
set schoolperiod = if(@schoolperiod = 'TRUE', 1, 0)
;

load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\madeira-trips.csv' 
into table tmptripdetail
FIELDS TERMINATED BY ';'
lines starting by 'TD'   
      terminated by '\n'
ignore 2 rows
(@seperator,routeName,wosName,startTime,stationName,arrivalTime,deltaTime,seqOrder)
;


-- Phase 2

-- 2.1 create companies
call createCompanies();

-- 2.2 create stations
call createStations();

-- 2.3 create lines and routes
call createLinesAndRoutes();

-- 2.4 create trips
call createTrips();

-- Close and free all resources (tmp tables)
call dropAllTempTables();
