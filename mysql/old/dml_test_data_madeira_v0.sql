CREATE PROCEDURE `generate_test_data` ()
BEGIN
	-- declare variables
	-- ------------------
    
	-- DECLARE variable_name datatype(size) DEFAULT default_value;
    declare my_transport_type_id bigint default 0;
    declare my_transport_id bigint default 0;
    declare canico_company_id bigint default 0;
    declare rodoeste_company_id bigint default 0;
    declare c_carreira2_line_id bigint default 0;
    declare c_carreira109_line_id bigint default 0;
    declare r_carreira1_line_id bigint default 0;
    declare trip_id bigint default 0;
    
    -- insert data
    -- ------------
    
    -- Transport Type
    insert into transporttype (name) values ("road");
    set @my_transport_type_id = last_insert_id();
    
    -- Transport
    insert into transport (transporttypeid, name) values (@my_transport_type_id, "bus");
    set @my_transport_id = last_insert_id();
    
    -- Company
    insert into company (transportid, name, fullname, address)
           values (@my_transport_id, "Caniço",
                   "Empresa de Autocarros do Caniço Lda.",
                   "Vargem - 9125 Caniço");
        set @canico_company_id = last_insert_id();
        
        insert into company (transportid, name, fullname, address)
                    values (@my_transport_id, "Rodoeste",
                            "Rodoeste – Transportadora Rodoviária da Madeira",
                            "Rua do Esmeraldo, 50 - 52 - 9000-051 Funchal");
    set @rodoeste_company_id = last_insert_id();
    
    -- Line
    insert into line (companyid, name, remarks)
           values (@canico_company_id, "Carreira 2", "Assomada (Portinho) - Funchal");
    set @c_carreira2_line_id = last_insert_id();
    insert into line (companyid, name, remarks)
           values (@canico_company_id, "Carreira 109", "Moinhos (Fontes) - Funchal");
    set @c_carreira109_line_id = last_insert_id();
    insert into line (companyid, name, remarks)
           values (@rodoeste_company_id, "Carreira 1", "Funchal - Ponte dos Frades (Câmara Lobos)");
    set @r_carreira1_line_id = last_insert_id();

    -- Station
    insert into station (name, code, latitude, longitude, description)
           values ("Portinho", null, 32.651383, -16.822528, null);
    insert into station (name, code, latitude, longitude, description)
           values ("Moinhos", null, 32.667758, -16.835076, null);
    insert into station (name, code, latitude, longitude, description)
           values ("Vargem", null, 32.6532748,-16.8423763, null);       
    insert into station (name, code, latitude, longitude, description)
           values ("Funchal - Caniço", null, 32.647631, -16.902801, null);
    insert into station (name, code, latitude, longitude, description)
           values ("Funchal - Rodoeste", null, 32.647147, -16.906418, null);
    insert into station (name, code, latitude, longitude, description)
           values ("Ponte dos Frades", null, 32.657220, -16.972647, null);
    insert into station (name, code, latitude, longitude, description)
           values ("Camara de Lobos", null, 32.648446, -16.973987, null);

    -- Route
    insert into route (lineid, startstationid, endstationid, remarks)
           values(@c_carreira2_line_id, (select id from station where name = "Portinho"),
                  (select id from station where name = "Funchal - Caniço"), null);
    insert into route (lineid, startstationid, endstationid, remarks)
           values(@c_carreira2_line_id, (select id from station where name = "Funchal - Caniço"),
                  (select id from station where name = "Portinho"), null);
    insert into route (lineid, startstationid, endstationid, remarks)
           values(@c_carreira109_line_id, (select id from station where name = "Moinhos"),
                  (select id from station where name = "Funchal - Caniço"), null);
    insert into route (lineid, startstationid, endstationid, remarks)
           values(@r_carreira1_line_id, (select id from station where name = "Funchal - Rodoeste"),
                  (select id from station where name = "Ponte dos Frades"), null);

    -- Week Operational Schedule
    insert into weekoperationalschedule (name, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
           values ("Segunda a Sexta", 1, 1, 1, 1, 1, 0, 0);
    insert into weekoperationalschedule (name, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
           values ("Sábados", 0, 0, 0, 0, 0, 1, 0);
    insert into weekoperationalschedule (name, monday, tuesday, wednesday, thursday, friday, saturday, sunday)
           values ("Domingos e Feriados", 0, 0, 0, 0, 0, 0, 1);

    -- Trip + Trip Detail
    -- carreira 2 - portinho -> funchal  - 5 trips

    -- 3 trips (2-6) 
    insert into trip (routeid, weekoperationalscheduleid, starttime, endtime, schoolperiod, remarks)
           values ((select id from route where lineid = @c_carreira2_line_id
                                        and startstationid = (select id from station where name = "Portinho")),
                   (select id from weekoperationalschedule where name = "Segunda a Sexta"),
                   "05:45:00", "06:25:00", 0, null);
    set @trip_id = last_insert_id();
    insert into tripdetail (tripid, stationid, arrivaltime, deltatime, seqorder)
           values (@trip_id, (select id from station where name = "Portinho"),
                   "05:45:00", "00:15:00", 1);
    insert into tripdetail (tripid, stationid, arrivaltime, deltatime, seqorder)
           values (@trip_id, (select id from station where name = "Vargem"),
                   "06:00:00", "00:25:00", 2);
    insert into tripdetail (tripid, stationid, arrivaltime, deltatime, seqorder)
           values (@trip_id, (select id from station where name = "Funchal - Caniço"),
                   "06:25:00", null, 3);
                   
    insert into trip (routeid, weekoperationalscheduleid, starttime, endtime, schoolperiod, remarks)
           values (select id from route where lineid = @c_carreira2_line_id,
                   select id from weekoperationalschedule where name = "Segunda a Sexta",
                   06:20:00, 07:00:00, 0, null);
    set @trip_id = last_insert_id();
    insert into tripdetail (tripid, stationid, arrivaltime, deltatime, seqorder)
           values (trip_id, select id from station where name = "Portinho",
                   06:20:00, 00:15:00, 1);
    insert into tripdetail (tripid, stationid, arrivaltime, deltatime, seqorder)
           values (trip_id, select id from station where name = "Vargem",
                   06:35:00, 00:25:00, 2);
    insert into tripdetail (tripid, stationid, arrivaltime, deltatime, seqorder)
           values (trip_id, select id from station where name = "Funchal - Caniço",
                   07:00:00, null, 3);
    
    insert into trip (routeid, weekoperationalscheduleid, starttime, endtime, schoolperiod, remarks)
           values (select id from route where lineid = @c_carreira2_line_id,
                   select id from weekoperationalschedule where name = "Segunda a Sexta",
                   06:20:00, 07:00:00, 0, null);
    set @trip_id = last_insert_id();
    insert into tripdetail (tripid, stationid, arrivaltime, deltatime, seqorder)
           values (trip_id, select id from station where name = "Portinho",
                   06:20:00, 00:15:00, 1);
    insert into tripdetail (tripid, stationid, arrivaltime, deltatime, seqorder)
           values (trip_id, select id from station where name = "Vargem",
                   06:35:00, 00:25:00, 2);
    insert into tripdetail (tripid, stationid, arrivaltime, deltatime, seqorder)
           values (trip_id, select id from station where name = "Funchal - Caniço",
                   07:00:00, null, 3);
                   
    -- + 1 trip (sab)
    insert into trip (routeid, weekoperationalscheduleid, starttime, endtime, schoolperiod, remarks)
           values (select id from route where lineid = @c_carreira2_line_id,
                   select id from weekoperationalschedule where name = "Sabados",
                   05:45:00, 06:25:00, 0, null);
    set @trip_id = last_insert_id();
    insert into tripdetail (tripid, stationid, arrivaltime, deltatime, seqorder)
           values (trip_id, select id from station where name = "Portinho",
                   05:45:00, 00:15:00, 1);
    insert into tripdetail (tripid, stationid, arrivaltime, deltatime, seqorder)
           values (trip_id, select id from station where name = "Vargem",
                   06:00:00, 00:25:00, 2);
    insert into tripdetail (tripid, stationid, arrivaltime, deltatime, seqorder)
           values (trip_id, select id from station where name = "Funchal - Caniço",
                   06:25:00, null, 3);

    -- + 1 trip (domingo)
    insert into trip (routeid, weekoperationalscheduleid, starttime, endtime, schoolperiod, remarks)
           values (select id from route where lineid = @c_carreira2_line_id,
                   select id from weekoperationalschedule where name = "Domingos e Feriados",
                   06:45:00, 07:25:00, 0, null);
    set @trip_id = last_insert_id();
    insert into tripdetail (tripid, stationid, arrivaltime, deltatime, seqorder)
           values (trip_id, select id from station where name = "Portinho",
                   07:45:00, 00:15:00, 1);
    insert into tripdetail (tripid, stationid, arrivaltime, deltatime, seqorder)
           values (trip_id, select id from station where name = "Vargem",
                   07:00:00, 00:25:00, 2);
    insert into tripdetail (tripid, stationid, arrivaltime, deltatime, seqorder)
           values (trip_id, select id from station where name = "Funchal - Caniço",
                   07:25:00, null, 3);

    -- carreira 2 - funchal -> portinho  - 2 trips

    -- 1 trips (2-6)

    -- + 1 trip (sab) 
    

    -- carreira 109 - moinhos -> funchal  - 1 trips -- 1 trips (2-6) (no details)
    
    -- carreira 1 - funchal -> ponte das frades  - 3 trips

    -- 1 trips (2-6)
    -- + 1 trip (sab)
    -- + 1 trip (dom)
    
END
