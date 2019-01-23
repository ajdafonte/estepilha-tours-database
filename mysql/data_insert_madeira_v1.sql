-- Batch script to import data
-- ----------------------------


-- Define procedures

-- 1 - Create temporary tables
-- Entities with temporary tables: company, station, line, trip, tripdetail

delimiter //

drop procedure if exists createTempCompanyTable//


create procedure createTempCompanyTable () 
begin
	-- select ">> Start process to create a temporary table for companies";
  create temporary table if not exists tmpcompany (
     transportname varchar(100),
     name varchar(100),
     fullname varchar(256),
     address varchar(1000)
  ) engine = InnoDB;
    -- select ">> End process to create a temporary table for companies";
end//

drop procedure if exists createTempStationTable//

create procedure createTempStationTable () 
begin
	-- select ">> Start process to create a temporary table for stations";
	create temporary table if not exists tmpstation (
     companyname varchar(100),
     name varchar(100),
     code varchar(30),
     latitude float(10,6),
     longitude float(10,6),
     description varchar(1000)
  ) engine = InnoDB;
    -- select ">> End process to create a temporary table for stations";
end//

drop procedure if exists createTempLineTable//

create procedure createTempLineTable () 
begin
	-- select ">> Start process to create a temporary table for lines";
	create temporary table if not exists tmpline (
     companyname varchar(100),
     name varchar(100),
     startstationname varchar(100),
     endstationname varchar(100),
     remarks varchar(1000)
  ) engine = InnoDB;
    -- select ">> End process to create a temporary table for lines";
end//

drop procedure if exists createTempTripTable//

create procedure createTempTripTable () 
begin
	-- select ">> Start process to create a temporary table for trips";
    create temporary table if not exists tmptrip (
     routename varchar(100),
     wosname varchar(100),
     starttime time,
     endtime time,
     schoolperiod tinyint,
     remarks varchar(1000)
  ) engine = InnoDB;
    -- select ">> End process to create a temporary table for trips";
end//

drop procedure if exists createTempTripDetailTable//

create procedure createTempTripDetailTable () 
begin
	-- select ">> Start process to create a temporary table for trip details";
    create temporary table if not exists tmptripdetail (
     routename varchar(100),
     wosname varchar(100),
     starttime time,
     stationname varchar(100),
     arrivaltime time,
     deltatime time,
     seqorder int
  ) engine = InnoDB;
    -- select ">> End process to create a temporary table for trip details";
end//

drop procedure if exists dropAllTempTables//

create procedure dropAllTempTables()
begin
 -- select ">> Start process to drop all temporary tables";
 drop temporary table if exists tmpcompany;
 drop temporary table if exists tmpstation;
 drop temporary table if exists tmpline;
 drop temporary table if exists tmptrip;
 drop temporary table if exists tmptripdetail;
 -- select ">> End process to drop all temporary tables";
end//

drop procedure if exists createAllTempTables//

create procedure createAllTempTables()
begin
 -- select ">> Start process to create all temporary tables";
 call createTempCompanyTable();
 call createTempStationTable();
 call createTempLineTable();
 call createTempTripTable();
 call createTempTripDetailTable();
 -- select ">> End process to create all temporary tables";
end//

drop procedure if exists clearAllData//

create procedure clearAllData()
begin
 -- select ">> Start - clear all db data"; 
 delete from tripdetail;
 delete from trip;
 delete from weekoperationalschedule;
 delete from route;
 delete from line;
 delete from station;
 delete from company;
 delete from transport;
 delete from transporttype;
 -- select ">> End - clear all db data";
end//

drop procedure if exists createCompany//

create procedure createCompany(in transportName varchar(100), in name varchar(100), in fullname varchar(256),
                                  in address varchar(1000), out id BIGINT)
begin
 -- declare user variables
 set @v_transportId = 0;
 set @v_transportName = transportName;
 set @v_name = name;
 set @v_fullname = fullname;
 set @v_address = address;
 

 -- select concat(">> Start - Creating a company with name ", name);
 -- define prepared statements
 set @sqlSelectTransport = "select id into @v_transportId from transport where name = ?";
 set @sqlInsertCompany = "insert into company (transportid, name, fullname, address) values (?,?,?,?)";

 -- get transport id
 prepare stmtSelectTransport from @sqlSelectTransport;
 execute stmtSelectTransport using @v_transportName;

 -- select  concat("Obtained transport with id ", @v_transportId);

 -- insert company
 prepare stmtInsertCompany from @sqlInsertCompany;
 execute stmtInsertCompany using @v_transportId, @v_name, @v_fullname, @v_address;

 -- return company id
 set id = last_insert_id();
 -- select  concat(">> End - Created company with id ", result);
  
end//

drop procedure if exists createStation//

create procedure createStation(in companyName varchar(100), in name varchar(100), in code varchar(30), in latitude float(10,6),
                               in longitude float(10,6), in description varchar(1000), out id BIGINT)
begin

 -- declare user variables
 set @v_companyId = 0;
 set @v_companyName = companyName;
 set @v_name = name;
 set @v_code = code;
 set @v_latitude = latitude;
 set @v_longitude = longitude;
 set @v_description = description;
 

 -- select  concat(">> Start - Creating a station with name ", name);
 -- define prepared statements
 set @sqlSelectCompany = "select id into @v_companyId from company where name = ?";
 set @sqlInsertStation = "insert into station (companyid, name, code, latitude, longitude, description) values (?,?,?,?,?,?)";

 -- get company id
 prepare stmtSelectCompany from @sqlSelectCompany;
 execute stmtSelectCompany using @v_companyName;

 -- select  concat("Obtained company with id ", @v_companyId);

 -- insert station
 prepare stmtInsertStation from @sqlInsertStation;
 execute stmtInsertStation using @v_companyId, @v_name, @v_code, @v_latitude, @v_longitude, @v_description;

 -- return station id
 set id = last_insert_id();
 -- select  concat(">> End - Created station with id ", result);
  
end//


drop procedure if exists createLine//


create procedure createLine(in companyName varchar(100), in name varchar(100), in remarks varchar(1000), out id BIGINT)
begin
 -- declare user variables
 set @v_companyId = 0;
 set @v_companyName = companyName;
 set @v_name = name;
 set @v_remarks = remarks;
 

 -- select  concat(">> Start - Creating a line with name ", name);
 -- define prepared statements
 set @sqlSelectCompany = "select id into @v_companyId from company where name = ?";
 set @sqlInsertLine = "insert into line (companyid, name, remarks) values (?,?,?)";

 -- get company id
 prepare stmtSelectCompany from @sqlSelectCompany;
 execute stmtSelectCompany using @v_companyName;

 -- select  concat("Obtained company with id ", @v_companyId);

 -- insert station
 prepare stmtInsertLine from @sqlInsertLine;
 execute stmtInsertLine using @v_companyId, @v_name, @v_remarks;

 -- return line id
 set id = last_insert_id();
 -- select concat(">> End - Created line with id ", id);
  
end//


drop procedure if exists createRoute//


-- create procedure createRoute(in lineName varchar(100), in startStationName varchar(100), in endStationName varchar(100),
create procedure createRoute(in lineId bigint, in startStationName varchar(100), in endStationName varchar(100),
                                in name varchar(100), in remarks varchar(1000), out id BIGINT)
begin

 -- declare user variables
 -- set @v_lineId = 0;
 set @v_lineId = lineId;
 set @v_startStationId = 0;
 set @v_endStationId = 0;
 -- set @v_lineName = lineName;
 set @v_startStationName = startStationName;
 set @v_endStationName = endStationName;
 set @v_name = name;
 set @v_remarks = remarks;
 

 -- select concat(">> Start - Creating a route with name ", name);
 -- select  concat(">> Start - Creating a route of line with id ", @v_lineId);
 -- define prepared statements
 -- set @sqlSelectLine = "select id into @v_lineId from line where name = ?";
 set @sqlSelectStartStation = "select id into @v_startStationId from station where name = ?";
 set @sqlSelectEndStation = "select id into @v_endStationId from station where name = ?";
 set @sqlInsertRoute = "insert into route (lineid, startstationid, endstationid, name, remarks) values (?,?,?,?,?)";

 -- get line id
 -- prepare stmtSelectLine from @sqlSelectLine;
 -- execute stmtSelectLine using @v_lineName;
 -- select concat("Obtained line with id ", @v_lineId);

 -- get start station and end station ids
 prepare stmtSelectStartStationId from @sqlSelectStartStation;
 execute stmtSelectStartStationId using @v_startStationName;
 -- select  concat("Obtained start station with id ", @v_startStationId);
 prepare stmtSelectEndStationId from @sqlSelectEndStation;
 execute stmtSelectEndStationId using @v_endStationName;
 -- select  concat("Obtained end station with id ", @v_endStationId); 
 
 -- insert route
 prepare stmtInsertRoute from @sqlInsertRoute;
 execute stmtInsertRoute using @v_lineId, @v_startStationId, @v_endStationId, @v_name, @v_remarks;

 -- return route id
 set id = last_insert_id();
 -- select  concat(">> End - Created route with id ", result);
  
end//


drop procedure if exists createTrip//

create procedure createTrip(in routeName varchar(100), in wosName varchar(100), in startTime time, in endTime time,
                               in schoolPeriod tinyint, in remarks varchar(1000), out id BIGINT)
begin

 -- declare user variables
 set @v_routeId = 0;
 set @v_wosId = 0;
 set @v_routeName = routeName;
 set @v_wosName = wosName;
 set @v_startTime = startTime;
 set @v_endTime = endTime;
 set @v_schoolPeriod = schoolPeriod;
 set @v_remarks = remarks;
 

 -- select  concat(">> Start - Creating a trip with startTime ", startTime);
 -- define prepared statements
 set @sqlSelectRoute = "select id into @v_routeId from route where name = ?";
 set @sqlSelectWos = "select id into @v_wosId from weekoperationalschedule where name = ?";
 set @sqlInsertTrip = "insert into trip (routeid, weekoperationalscheduleid, starttime, endtime, schoolperiod, remarks) values (?,?,?,?,?,?)";

 -- get route id
 prepare stmtSelectRoute from @sqlSelectRoute;
 execute stmtSelectRoute using @v_routeName;
 -- select  concat("Obtained route with id ", @v_routeId);

 -- get week operational schedule id
 prepare stmtSelectWosId from @sqlSelectWos;
 execute stmtSelectWosId using @v_wosName;
 -- select  concat("Obtained week operational schedule with id ", @v_wosId);
 
 -- insert trip
 prepare stmtInsertTrip from @sqlInsertTrip;
 execute stmtInsertTrip using @v_routeId, @v_wosId, @v_startTime, @v_endTime, @v_schoolPeriod, @v_remarks;

 -- return route id
 set id = last_insert_id();
 -- select  concat(">> End - Created trip with id ", result);
  
end//


drop procedure if exists createTripDetail//


create procedure createTripDetail(in tripId bigint, in stationName varchar(100), in arrivalTime time, in deltaTime time,
                                     in seqOrder int, out id BIGINT)
begin

 -- declare user variables
 set @v_stationId = 0;
 set @v_tripId = tripId;
 set @v_stationName = stationName;
 set @v_arrivalTime = arrivalTime;
 set @v_deltaTime = deltaTime;
 set @v_seqOrder = seqOrder;
 

 -- select  concat(">> Start - Creating trip detail related with trip with id ", tripId);
 -- define prepared statements
 set @sqlSelectStation = "select id into @v_stationId from station where name = ?";
 set @sqlInsertTripDetail = "insert into tripdetail (tripid, stationid, arrivaltime, deltatime, seqorder) values (?,?,?,?,?)";

 -- get station id
 prepare stmtSelectStation from @sqlSelectStation;
 execute stmtSelectStation using @v_stationName;
 -- select  concat("Obtained station with id ", @v_stationId);
 
 -- insert trip detail
 prepare stmtInsertTripDetail from @sqlInsertTripDetail;
 execute stmtInsertTripDetail using @v_tripId, @v_stationId, @v_arrivalTime, @v_deltaTime, @v_seqOrder;

 -- return trip detail id
 set id = last_insert_id();
 -- select  concat(">> End - Created trip detail with id ", result);
  
end//


drop procedure if exists createCompanies//

create procedure createCompanies()
begin
 declare finished int default 0;
 declare transportName varchar(100);
 declare name varchar(100);
 declare fullName varchar(256);
 declare address varchar(1000);
 declare curCompany cursor for select * from tmpcompany;
 declare continue handler for not found set finished = 1;

 -- select  ">> Start - Creating companies";
 open curCompany;

 read_loop: loop
  fetch curCompany into transportName, name, fullName, address;
  if finished = 1
   then leave read_loop;
  end if;
  call createCompany(transportName, name, fullName, address, @id);
 end loop;

 close curCompany;
 -- select  ">> End - Creating companies";
end//

drop procedure if exists createStations//

create procedure createStations()
begin
 declare finished int default 0;
 declare companyName varchar(100);
 declare name varchar(100);
 declare code varchar(30);
 declare latitude float(10,6);
 declare longitude float(10,6);
 declare description varchar(1000);
 declare curStation cursor for select * from tmpstation;
 declare continue handler for not found set finished = 1;

 -- select  ">> Start - Creating stations";
 open curStation;

 read_stations_loop: loop
  fetch curStation into companyName, name, code, latitude, longitude, description;
  if finished = 1
   then leave read_stations_loop;
  end if;
  call createStation(companyName, name, code, latitude, longitude, description, @id);
 end loop;

 close curStation;
 -- select  ">> End - Creating stations";
end//

drop procedure if exists createTrips//

create procedure createTrips()
begin
 declare finished int default 0;
 declare routeName varchar(100);
 declare wosName varchar(100);
 declare startTime time;
 declare endTime time;
 declare schoolPeriod tinyint;
 declare remarks varchar(1000);
 declare stationName varchar(100);
 declare arrivalTime time;
 declare deltaTime time;
 declare seqOrder int;
 declare curTrip cursor for select * from tmptrip;
 declare continue handler for not found set finished = 1;

 -- select  ">> Start - Creating trips";
 open curTrip;

 read_trips_loop: loop
  fetch curTrip into routeName, wosName, startTime, endTime, schoolPeriod, remarks;
  if finished = 1
   then leave read_trips_loop;
  end if;
  call createTrip(routeName, wosName, startTime, endTime, schoolPeriod, remarks, @insertedTrip);
  call createTripDetails(@insertedTrip, routeName, wosName, startTime);
  -- select @insertedTrip;
 end loop;

 close curTrip;
 -- select  ">> End - Creating trips";
end//


drop procedure if exists createTripDetails//

create procedure createTripDetails(in tripId bigint, in routeNameCur varchar(100), in wosNameCur varchar(100), in startTimeCur time )
begin
 declare finished int default 0;
 declare routeName varchar(100);
 declare wosName varchar(100);
 declare startTime time;
 declare stationName varchar(100);
 declare arrivalTime time;
 declare deltaTime time;
 declare seqOrder int;
 declare curTripDetail cursor for select td.stationname, td.arrivaltime, td.deltatime, td.seqorder
                                  from tmptripdetail td
                                  where td.routename = routeNameCur and td.wosname = wosNameCur and td.starttime = startTimeCur
                                  order by td.seqorder;
 declare continue handler for not found set finished = 1;

 -- select  concat(">> Start - Creating trip details fro trip with id ", tripId);
 open curTripDetail;

 read_tripdetail_loop: loop
  fetch curtripdetail into stationName, arrivalTime, deltaTime, seqOrder;
  if finished = 1
   then leave read_tripdetail_loop;
  end if;
  call createTripDetail(tripId, stationName, arrivalTime, deltaTime, seqOrder, @insertTripDetailId);
 end loop;

 close curTripDetail;
 -- select  concat(">> End - Creating trip details fro trip with id ", tripId);
end//


drop procedure if exists createLinesAndRoutes//

create procedure createLinesAndRoutes()
begin
 declare finished int default 0;
 declare companyName varchar(100);
 declare name varchar(100);
 declare startStationName varchar(100);
 declare endStationName varchar(100);
 declare remarks varchar(1000);
 declare curLine cursor for select * from tmpline;
 declare continue handler for not found set finished = 1;

 -- select  ">> Start - Creating lines and routes";
 open curLine;

 read_lines_loop: loop
  fetch curLine into companyName, name, startStationName, endStationName, remarks;
  if finished = 1
   then leave read_lines_loop;
  end if;
  call createLine(companyName, name, remarks, @insertLineId);
  call createRoute(@insertLineId, startStationName, endStationName, concat(startStationName,"<->",endStationName), '--', @insertRouteId);
  call createRoute(@insertLineId, endStationName, startStationName, concat(endStationName,"<->",startStationName), '--', @insertRouteId);
  -- select @insertedTrip;
 end loop;

 close curLine;
 -- select  ">> End - Creating lines and routes";
end//

drop procedure if exists createWeekOperationSchedule//


create procedure createWeekOperationSchedule (in name varchar(100), in monday tinyint, in tuesday tinyint,
                                              in wednesday tinyint, in thursday tinyint, in friday tinyint,
                                              in saturday tinyint, in sunday tinyint, out id bigint)
begin

 -- declare user variables
 set @v_name = name;
 set @v_monday = monday;
 set @v_tuesday = tuesday;
 set @v_wednesday = wednesday;
 set @v_thursday = thursday;
 set @v_friday = friday;
 set @v_saturday = saturday;
 set @v_sunday = sunday;

 -- select  concat(">> Start - Creating week operational schedule with name ", name);
 -- define prepared statements
 set @sqlInsert = "insert into weekoperationalschedule (name, monday, tuesday, wednesday, thursday,
                                                  friday, saturday, sunday) values (?,?,?,?,?,?,?,?)";

 -- insert week operational scheudle
 prepare stmt from @sqlInsert;
 execute stmt using @v_name, @v_monday, @v_tuesday, @v_wednesday, @v_thursday, @v_friday, @v_saturday, @v_sunday;

 -- return week operational scheudle id
 set id = last_insert_id();
 -- select  concat(">> End - Created week operational schedule with id ", id);
  
end//
 

delimiter ;

-- -- data to be preloaded


-- -- Phase0 - Pre-load data (transporttype, transport and week operational schedule)

-- -- 0.1 Transport Type
-- insert into transporttype (name) values ("road");
-- set @my_transport_type_id = last_insert_id();
    
-- -- 0.2 Transport
-- insert into transport (transporttypeid, name) values (@my_transport_type_id, "bus");
-- set @my_transport_id = last_insert_id();
    
-- select * from transport where name = 'bus';
    
-- -- Week Operational Schedule
-- call createWeekOperationSchedule("Segunda a Sexta", 1, 1, 1, 1, 1, 0, 0);
-- call createWeekOperationSchedule("Sábados", 0, 0, 0, 0, 0, 1, 0);
-- call createWeekOperationSchedule("Domingos e Feriados", 0, 0, 0, 0, 0, 0, 1);

-- -- Phase1 - Load and store data from files in memory

-- -- 1.1 create all temp tables
-- call createAllTempTables();

-- -- 1.2 Load data from files

-- -- 1.2.1 load companies
-- load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\madeira-companies.csv'
-- into table tmpcompany
-- FIELDS TERMINATED BY ';' 
-- lines terminated by '\n'
-- ignore 1 rows
-- ;

-- -- 1.2.2 load stations
-- load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\madeira-stations.csv')
-- into table tmpstation
-- FIELDS TERMINATED BY ';' 
-- lines terminated by '\n'
-- ignore 1 rows
-- ;

-- -- 1.2.3 load lines
-- load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\madeira-lines.csv')
-- into table tmpline
-- FIELDS TERMINATED BY ';' 
-- lines terminated by '\n'
-- ignore 1 rows
-- ;

-- -- 1.2.4 load trips
-- load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\madeira-trips.csv' 
-- into table tmptrip
-- FIELDS TERMINATED BY ';'
-- lines starting by 'TR'   
--       terminated by '\n'
-- ignore 2 rows
-- (@seperator,routeName,wosName,startTime,endTime,@schoolPeriod,remarks)
-- set schoolperiod = if(@schoolperiod = 'TRUE', 1, 0)
-- ;

-- load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\madeira-trips.csv' 
-- into table tmptripdetail
-- FIELDS TERMINATED BY ';'
-- lines starting by 'TD'   
--       terminated by '\n'
-- ignore 2 rows
-- (@seperator,routeName,wosName,startTime,stationName,arrivalTime,deltaTime,seqOrder)
-- ;


-- -- Phase 2

-- -- 2.1 create companies
-- call createCompanies();

-- -- 2.2 create stations
-- call createStations();

-- -- 2.3 create lines and routes
-- call createLinesAndRoutes();

-- -- 2.4 create trips
-- call createTrips();

-- -- Close and free all resources (tmp tables)
-- call dropAllTempTables();





-- -- test samples

-- -- create temporary tables -- OK
-- create temporary table if not exists tmpcompany (
--   namecompany varchar(100),
--   addrrcompany varchar(100)
--   ) engine = InnoDB;
  
-- insert into tmpcompany values ("name1", "addr1");

-- select * 
-- from tmpcompany;

-- drop temporary table tmpcompany;


-- -- dummy stored procedures -- OK

-- delimiter //

-- drop procedure if exists hello//

-- create procedure hello()
-- begin
--   select "hello world";
-- end//
 
-- delimiter ;

-- call hello();

-- -- see dir path where files that can be loaded using 'load data infile' should be located
-- show variables like 'secure_file_priv';

-- select @@global.secure_file_priv;

-- -- load data from csv and store in tmp table -- OK

-- create temporary table if not exists tmpcompany (
--   companyName varchar(100),
--   companyNUmber bigint,
--   companyTime time,
--   isCompanyLda tinyint,
--   companyRemarks varchar(100),
--   companyLatitude float(10,6),
--   companyLongitude float(10,6),
--   companyDate date
--   ) engine = InnoDB;


-- insert into tmpcompany values ("name1", "addr1");

-- select * 
-- from tmpcompany;

-- -- sample 1
-- load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\dummy-csv.csv' 
-- into table tmpcompany 
-- FIELDS TERMINATED BY ',' 
-- lines terminated by '\n'
-- ignore 1 rows
-- (companyName,companyNumber,companyTime,@isCompanyLda,companyRemarks,companyLatitude,companyLongitude,@companyDate)
-- set companyDate = str_to_date(@companyDate, '%d/%m/%Y'),
--     isCompanyLda = if(@isCompanyLda = 'TRUE', 1, 0)
-- ;

-- select * 
-- from tmpcompany;

-- -- sample 2 - ignoring fields and having different type of data in the same file
-- load data infile 'C:\\ProgramData\\MySQL\\MySQL Server 8.0\\Uploads\\dummy-csv2.csv' 
-- into table tmpcompany 
-- FIELDS TERMINATED BY ','
-- lines starting by 'TR'   
--       terminated by '\n'
-- ignore 2 rows
-- (@sep,companyName,companyNumber,companyTime,@isCompanyLda,companyRemarks,companyLatitude,companyLongitude,@companyDate)
-- set companyDate = str_to_date(@companyDate, '%d/%m/%Y'),
--     isCompanyLda = if(@isCompanyLda = 'TRUE', 1, 0)
-- ;

-- -- prepared statements - dummy sample -- OK

-- PREPARE stmt1 FROM 'SELECT SQRT(POW(?,2) + POW(?,2)) AS hypotenuse';
-- SET @a = 3;
-- SET @b = 4;
-- EXECUTE stmt1 USING @a, @b;
-- DEALLOCATE PREPARE stmt1;

-- -- check how many prepared statements are "stored" - OK
-- SHOW GLOBAL STATUS LIKE '%prepared_stmt_count%';

-- -- dummy sample with cursors -- OK

-- -- create temporary tables
-- create temporary table if not exists tmpFinalCompany (
--   companyName varchar(100),
--   companyTime time
--   ) engine = InnoDB;

-- select *
-- from tmpFinalCompany;

-- delimiter //

-- drop procedure if exists cursorDemo//

-- create procedure cursorDemo()
-- begin
--  declare finished int default 0;
--  declare companyName varchar(100);
--  declare companyNumber bigint;
--  declare companyTime time;
--  declare isCompanyLda tinyint;
--  declare companyRemarks varchar(100);
--  declare companyLatitude float(10,6);
--  declare companyLongitude float(10,6);
--  declare companyDate date;
--  declare cur1 cursor for select * from tmpcompany;
--  declare continue handler for not found set finished = 1;

--  open cur1;

--  read_loop: loop
--   fetch cur1 into companyName, companyNumber, companyTime, isCompanyLda, companyRemarks, companyLatitude,
--                   companyLongitude, companyDate;
--   if finished = 1
--    then leave read_loop;
--   end if;
--   insert into tmpFinalCompany values (companyName, companyTime);
--  end loop;

--  close cur1;
-- end//

-- delimiter ;

-- select * from tmpcompany;

-- call cursorDemo();
-- select * from tmpFinalCompany;
-- delete from tmpFinalCompany;


-- -- test data

-- call createCompany("bus", "Canico", "Autocarro do Canico", "Tendeira", @id);
-- select @id;

-- call createStation("Canico", "Portinho", "C123", 32.651383, -16.822528, "Description", @idStation);

-- call createStation("Canico", "Funchal", "C321", 32.651384, -16.822529, "Description FNC", @idStation);
-- select @idStation;

-- select *
-- from company;

-- select * 
-- from station;

-- delete from company;

-- call createLine("Canico", "Carreira 2", "Linha principal", @id);

-- select * from line;

-- delete from line;

-- call createRoute("Carreira 2", "Portinho", "Funchal", "Portinho <-> Funchal", "Remarks", @id);
-- select @id;

-- select * from route;

-- delete from route;

-- call createTrip("Portinho <-> Funchal", "Sábados", "00:06:00", "00:07:00", 1, "RemarksTrip", @id);

-- select * from trip;

-- delete from trip;

-- call createTripDetail(1, "Portinho", "00:00:10", "00:08:00", 1, @id);

-- select * from tripdetail;

-- delete from tripdetail;
