-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';


-- -----------------------------------------------------
-- Schema madeira
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `madeira` DEFAULT CHARACTER SET utf8 ;
SHOW WARNINGS;
USE `madeira` ;

-- -----------------------------------------------------
-- Table `madeira`.`transporttype`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `madeira`.`transporttype` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `madeira`.`transporttype` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'Id of the transport type',
  `name` VARCHAR(100) NULL COMMENT 'Name of the transport type',

  -- add constraints
  CONSTRAINT `pk_transporttype` PRIMARY KEY (`id`)
)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `madeira`.`transport`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `madeira`.`transport` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `madeira`.`transport` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'Id of the transport',
  `transporttypeid` BIGINT NULL COMMENT 'Id of the transport type',
  `name` VARCHAR(100) NULL COMMENT 'Name of the transport',

  -- add constraints
  CONSTRAINT `pk_transport` PRIMARY KEY (`id`),
  CONSTRAINT `fk_transport_transporttype_id`
    FOREIGN KEY (`transporttypeid`)
    REFERENCES `madeira`.`transporttype` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `idx_transport_transporttypeid` ON `madeira`.`transport` (`transporttypeid` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `madeira`.`company`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `madeira`.`company` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `madeira`.`company` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'Id of the company',
  `transportid` BIGINT NULL COMMENT 'Id of the transport',
  `name` VARCHAR(100) NULL COMMENT 'Name of the company (shortname)',
  `fullname` VARCHAR(256) NULL COMMENT 'Full name of the company',
  `address` VARCHAR(1000) NULL COMMENT 'Address of the company',
  
  -- add constraints
  CONSTRAINT `pk_company` PRIMARY KEY (`id`),
  CONSTRAINT `fk_company_transport_id`
    FOREIGN KEY (`transportid`)
    REFERENCES `madeira`.`transport` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `idx_company_transportid` ON `madeira`.`company` (`transportid` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `madeira`.`line`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `madeira`.`line` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `madeira`.`line` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'Id of the line',
  `companyid` BIGINT NULL COMMENT 'Id of the company',
  `name` VARCHAR(100) NULL COMMENT 'Name of the line',
  `remarks` VARCHAR(1000) NULL COMMENT 'Remarks about the line',

  -- add constraints
  CONSTRAINT `pk_line` PRIMARY KEY (`id`),
  CONSTRAINT `fk_line_company_id`
    FOREIGN KEY (`companyid`)
    REFERENCES `madeira`.`company` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `idx_line_companyid` ON `madeira`.`line` (`companyid` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `madeira`.`station`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `madeira`.`station` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `madeira`.`station` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'Id of the station',
  `name` VARCHAR(100) NULL COMMENT 'Name of the station',
  `code` VARCHAR(30) NULL COMMENT 'Internal code of the station',
  `latitude` FLOAT(10,6) NULL COMMENT 'Latitude coordinate',
  `longitude` FLOAT(10,6) NULL COMMENT 'Longitude coordinate',
  `description` VARCHAR(1000) NULL COMMENT 'Some details about the station',
  
  -- add constraints
  CONSTRAINT `pk_station` PRIMARY KEY (`id`)
)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `madeira`.`route`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `madeira`.`route` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `madeira`.`route` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'Id of the route',
  `lineid` BIGINT NULL COMMENT 'Id of the line',
  `startstationid` BIGINT NULL COMMENT 'Id of the start station',
  `endstationid` BIGINT NULL COMMENT 'Id of the end station',
  `remarks` VARCHAR(1000) NULL COMMENT 'Remarks about the route',
   
  -- add constraints
  CONSTRAINT `pk_route` PRIMARY KEY (`id`),
  CONSTRAINT `fk_route_line_id`
    FOREIGN KEY (`lineid`)
    REFERENCES `madeira`.`line` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_route_station_id_start`
    FOREIGN KEY (`startstationid`)
    REFERENCES `madeira`.`station` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_route_station_id_end`
    FOREIGN KEY (`endstationid`)
    REFERENCES `madeira`.`station` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `idx_route_lineid` ON `madeira`.`route` (`lineid` ASC) VISIBLE;

SHOW WARNINGS;
CREATE INDEX `idx_route_startstationid` ON `madeira`.`route` (`startstationid` ASC) VISIBLE;

SHOW WARNINGS;
CREATE INDEX `idx_route_endstationid` ON `madeira`.`route` (`endstationid` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `madeira`.`weekoperationalschedule`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `madeira`.`weekoperationalschedule` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `madeira`.`weekoperationalschedule` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'Id of the week operational schedule',
  `name` VARCHAR(100) NULL COMMENT 'Name of the week operational schedule',
  `monday` TINYINT NULL COMMENT 'Indicates if a trip operates on monday',
  `tuesday` TINYINT NULL COMMENT 'Indicates if a trip operates on tuesday',
  `wednesday` TINYINT NULL COMMENT 'Indicates if a trip operates on wednesday',
  `thursday` TINYINT NULL COMMENT 'Indicates if a trip operates on thursday',
  `friday` TINYINT NULL COMMENT 'Indicates if a trip operates on friday',
  `saturday` TINYINT NULL COMMENT 'Indicates if a trip operates on saturday',
  `sunday` TINYINT NULL COMMENT 'Indicates if a trip operates on sunday (Remark: For now, will include holidays)',
   
  -- add constraints
  CONSTRAINT `pk_weekoperationalschedule` PRIMARY KEY (`id`)
)
ENGINE = InnoDB;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `madeira`.`trip`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `madeira`.`trip` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `madeira`.`trip` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'Id of the trip',
  `routeid` BIGINT NULL COMMENT 'Id of the route',
  `weekoperationalscheduleid` BIGINT NULL COMMENT 'Id of the week operational schedule',
  `starttime` TIME NULL COMMENT 'Start time of the trip',
  `endtime` TIME NULL COMMENT 'End time of the trip',
  `schoolperiod` TINYINT NULL COMMENT 'Indicates if the trip is performed in school period',
  `remarks` VARCHAR(1000) NULL COMMENT 'Remarks of the trip',
     
  -- add constraints
  CONSTRAINT `pk_trip` PRIMARY KEY (`id`),
  CONSTRAINT `fk_trip_route_id`
    FOREIGN KEY (`routeid`)
    REFERENCES `madeira`.`route` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_trip_weekoperationalschedule_id`
    FOREIGN KEY (`weekoperationalscheduleid`)
    REFERENCES `madeira`.`weekoperationalschedule` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `idx_trip_lineid` ON `madeira`.`trip` (`routeid` ASC) VISIBLE;

SHOW WARNINGS;
CREATE INDEX `idx_trip_weekoperationscheduleid` ON `madeira`.`trip` (`weekoperationalscheduleid` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `madeira`.`tripdetail`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `madeira`.`tripdetail` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `madeira`.`tripdetail` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'Id of the trip detail',
  `stationid` BIGINT NULL COMMENT 'Id of the station',
  `tripid` BIGINT NULL COMMENT 'Id of the trip',
  `arrivaltime` TIME NULL COMMENT 'Arrival time in station',
  `deltatime` TIME NULL COMMENT 'Delta time until next station',
  `seqorder` INT NULL COMMENT 'Order number in the trip',
     
  -- add constraints
  CONSTRAINT `pk_tripdetail` PRIMARY KEY (`id`),
  CONSTRAINT `fk_tripdetail_trip_id`
    FOREIGN KEY (`tripid`)
    REFERENCES `madeira`.`trip` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_tripdetail_station_id`
    FOREIGN KEY (`stationid`)
    REFERENCES `madeira`.`station` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

SHOW WARNINGS;
CREATE INDEX `idx_tripdetail_tripid` ON `madeira`.`tripdetail` (`tripid` ASC) VISIBLE;

SHOW WARNINGS;
CREATE INDEX `idx_tripdetail_stationid` ON `madeira`.`tripdetail` (`stationid` ASC) VISIBLE;

SHOW WARNINGS;

-- -----------------------------------------------------
-- Table `madeira`.`operationalperiod`
-- -----------------------------------------------------
DROP TABLE IF EXISTS `madeira`.`operationalperiod` ;

SHOW WARNINGS;
CREATE TABLE IF NOT EXISTS `madeira`.`operationalperiod` (
  `id` BIGINT NOT NULL AUTO_INCREMENT COMMENT 'Id of the operational period',
  `name` VARCHAR(100) NULL COMMENT 'Name of the operational period',
  `startdate` DATE NULL COMMENT 'Start date of the operarional period',
  `enddate` DATE NULL COMMENT 'End date of the operational period',
     
  -- add constraints
  CONSTRAINT `pk_operationalperiod` PRIMARY KEY (`id`)
)
ENGINE = InnoDB;

SHOW WARNINGS;

SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
