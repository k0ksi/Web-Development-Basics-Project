-- CREATE SCHEMA `conference_scheduler` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;

CREATE TABLE `conference_scheduler`.`users` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `username` NVARCHAR(45) NOT NULL COMMENT '',
  `password` NVARCHAR(45) NOT NULL COMMENT '',
  `email` NVARCHAR(45) NOT NULL COMMENT '',
  PRIMARY KEY (`id`)  COMMENT '');
  
ALTER TABLE `conference_scheduler`.`users` 
ADD UNIQUE INDEX `username_UNIQUE` (`username` ASC)  COMMENT '',
ADD UNIQUE INDEX `email_UNIQUE` (`email` ASC)  COMMENT '';

CREATE TABLE `conference_scheduler`.`roles` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `name` NVARCHAR(45) NOT NULL COMMENT '',
  PRIMARY KEY (`id`)  COMMENT '',
  UNIQUE INDEX `name_UNIQUE` (`name` ASC)  COMMENT '');

ALTER TABLE `conference_scheduler`.`users` 
ADD COLUMN `role_id` INT NOT NULL COMMENT '' AFTER `email`,
ADD INDEX `fk_role_id_idx` (`role_id` ASC)  COMMENT '';
ALTER TABLE `conference_scheduler`.`users` 
ADD CONSTRAINT `fk_role_id`
  FOREIGN KEY (`role_id`)
  REFERENCES `conference_scheduler`.`roles` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

ALTER TABLE `conference_scheduler`.`roles` 
CHANGE COLUMN `name` `name` VARCHAR(45) NOT NULL DEFAULT 'user' COMMENT '' ;

INSERT INTO `conference_scheduler`.`roles` (`id`, `name`) VALUES ('1', 'user');

ALTER TABLE `conference_scheduler`.`users` 
DROP FOREIGN KEY `fk_role_id`;
ALTER TABLE `conference_scheduler`.`users` 
CHANGE COLUMN `role_id` `role_id` INT(11) NOT NULL DEFAULT 1 COMMENT '' ;
ALTER TABLE `conference_scheduler`.`users` 
ADD CONSTRAINT `fk_role_id`
  FOREIGN KEY (`role_id`)
  REFERENCES `conference_scheduler`.`roles` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
ALTER TABLE `conference_scheduler`.`users` 
DROP FOREIGN KEY `fk_role_id`;
ALTER TABLE `conference_scheduler`.`users` 
DROP COLUMN `role_id`,
DROP INDEX `fk_role_id_idx` ;
  
INSERT INTO `conference_scheduler`.`roles` (`id`, `name`) VALUES ('2', 'site administrator');
INSERT INTO `conference_scheduler`.`roles` (`id`, `name`) VALUES ('3', 'conference owner');
INSERT INTO `conference_scheduler`.`roles` (`id`, `name`) VALUES ('4', 'conference administrator');

CREATE TABLE `conference_scheduler`.`venue` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `name` NVARCHAR(45) NOT NULL COMMENT '',
  PRIMARY KEY (`id`)  COMMENT '');

CREATE TABLE `conference_scheduler`.`hall` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `name` NVARCHAR(45) NOT NULL COMMENT '',
  `venue_id` INT NOT NULL COMMENT '',
  PRIMARY KEY (`id`)  COMMENT '',
  INDEX `fk_venue_id_idx` (`venue_id` ASC)  COMMENT '',
  CONSTRAINT `fk_venue_id`
    FOREIGN KEY (`venue_id`)
    REFERENCES `conference_scheduler`.`venue` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
	
ALTER TABLE `conference_scheduler`.`hall` 
ADD COLUMN `limit` INT NOT NULL DEFAULT 50 COMMENT '' AFTER `venue_id`;

CREATE TABLE `conference_scheduler`.`lecture` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `name` NVARCHAR(45) NOT NULL COMMENT '',
  `description` NVARCHAR(45) NOT NULL COMMENT '',
  `start_time` DATETIME NOT NULL COMMENT '',
  `end_time` DATETIME NOT NULL COMMENT '',
  `speaker_id` INT NOT NULL COMMENT '',
  `hall_id` INT NOT NULL COMMENT '',
  `conference_id` INT NOT NULL COMMENT '',
  PRIMARY KEY (`id`)  COMMENT '');

ALTER TABLE `conference_scheduler`.`lecture` 
ADD INDEX `fk_speaker_id_idx` (`speaker_id` ASC)  COMMENT '',
ADD INDEX `fk_hall_id_idx` (`hall_id` ASC)  COMMENT '';
ALTER TABLE `conference_scheduler`.`lecture` 
ADD CONSTRAINT `fk_speaker_id`
  FOREIGN KEY (`speaker_id`)
  REFERENCES `conference_scheduler`.`users` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION,
ADD CONSTRAINT `fk_hall_id`
  FOREIGN KEY (`hall_id`)
  REFERENCES `conference_scheduler`.`hall` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;

CREATE TABLE `conference_scheduler`.`conference` (
  `id` INT NOT NULL AUTO_INCREMENT COMMENT '',
  `name` NVARCHAR(45) NOT NULL COMMENT '',
  `description` NVARCHAR(45) NOT NULL COMMENT '',
  `owner_id` INT NOT NULL COMMENT '',
  `venue_id` INT NOT NULL COMMENT '',
  PRIMARY KEY (`id`)  COMMENT '');

ALTER TABLE `conference_scheduler`.`conference` 
ADD INDEX `fk_conference_venue_id_idx` (`venue_id` ASC)  COMMENT '';
ALTER TABLE `conference_scheduler`.`conference` 
ADD CONSTRAINT `fk_conference_venue_id`
  FOREIGN KEY (`venue_id`)
  REFERENCES `conference_scheduler`.`venue` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
ALTER TABLE `conference_scheduler`.`conference` 
ADD INDEX `fk_conference_owner_id_idx` (`owner_id` ASC)  COMMENT '';
ALTER TABLE `conference_scheduler`.`conference` 
ADD CONSTRAINT `fk_conference_owner_id`
  FOREIGN KEY (`owner_id`)
  REFERENCES `conference_scheduler`.`users` (`id`)
  ON DELETE NO ACTION
  ON UPDATE NO ACTION;
  
ALTER TABLE `conference_scheduler`.`lecture`
ADD CONSTRAINT `fk_lecture_conference_id`
	FOREIGN KEY (`conference_id`)
	REFERENCES `conference_scheduler`.`conference` (`id`)
	ON DELETE NO ACTION
	ON UPDATE NO ACTION;
	
ALTER TABLE `conference_scheduler`.`conference` 
ADD COLUMN `start_date` DATETIME NOT NULL COMMENT '' AFTER `venue_id`,
ADD COLUMN `end_date` DATETIME NOT NULL COMMENT '' AFTER `start_date`;
  
  CREATE TABLE `conference_scheduler`.`conference_admins` (
  `conference_id` INT NOT NULL COMMENT '',
  `admin_id` INT NOT NULL COMMENT '',
  PRIMARY KEY (`conference_id`, `admin_id`)  COMMENT '',
  INDEX `fk_admin_id_idx` (`admin_id` ASC)  COMMENT '',
  CONSTRAINT `fk_conference_id`
    FOREIGN KEY (`conference_id`)
    REFERENCES `conference_scheduler`.`conference` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_admin_id`
    FOREIGN KEY (`admin_id`)
    REFERENCES `conference_scheduler`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
	
CREATE TABLE `conference_scheduler`.`user_roles` (
  `user_id` INT NOT NULL COMMENT '',
  `role_id` INT NOT NULL COMMENT '',
  PRIMARY KEY (`user_id`, `role_id`)  COMMENT '',
  INDEX `fk_role_index_id_idx` (`role_id` ASC)  COMMENT '',
  CONSTRAINT `fk_user_role_index_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `conference_scheduler`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_role_index_id`
    FOREIGN KEY (`role_id`)
    REFERENCES `conference_scheduler`.`roles` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);

  
CREATE TABLE `conference_scheduler`.`user_lectures` (
  `user_id` INT NOT NULL COMMENT '',
  `lecture_id` INT NOT NULL COMMENT '',
  PRIMARY KEY (`user_id`, `lecture_id`)  COMMENT '',
  INDEX `fk_lecture_user_id_idx` (`lecture_id` ASC)  COMMENT '',
  CONSTRAINT `fk_user_lecture_id`
    FOREIGN KEY (`user_id`)
    REFERENCES `conference_scheduler`.`users` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_lecture_user_id`
    FOREIGN KEY (`lecture_id`)
    REFERENCES `conference_scheduler`.`lecture` (`id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION);
    
ALTER TABLE `conference_scheduler`.`conference` 
DROP FOREIGN KEY `fk_conference_owner_id`,
DROP FOREIGN KEY `fk_conference_venue_id`;
ALTER TABLE `conference_scheduler`.`conference` 
ADD CONSTRAINT `fk_conference_owner_id`
  FOREIGN KEY (`owner_id`)
  REFERENCES `conference_scheduler`.`users` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
ADD CONSTRAINT `fk_conference_venue_id`
  FOREIGN KEY (`venue_id`)
  REFERENCES `conference_scheduler`.`venue` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;
  
ALTER TABLE `conference_scheduler`.`lecture` 
DROP FOREIGN KEY `fk_lecture_conference_id`;
ALTER TABLE `conference_scheduler`.`lecture` 
ADD CONSTRAINT `fk_lecture_conference_id`
  FOREIGN KEY (`conference_id`)
  REFERENCES `conference_scheduler`.`conference` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;
  
ALTER TABLE `conference_scheduler`.`user_lectures` 
DROP FOREIGN KEY `fk_user_lecture_id`,
DROP FOREIGN KEY `fk_lecture_user_id`;
ALTER TABLE `conference_scheduler`.`user_lectures` 
ADD CONSTRAINT `fk_user_lecture_id`
  FOREIGN KEY (`user_id`)
  REFERENCES `conference_scheduler`.`users` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
ADD CONSTRAINT `fk_lecture_user_id`
  FOREIGN KEY (`lecture_id`)
  REFERENCES `conference_scheduler`.`lecture` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;
  
ALTER TABLE `conference_scheduler`.`lecture` 
DROP FOREIGN KEY `fk_speaker_id`;
ALTER TABLE `conference_scheduler`.`lecture` 
ADD CONSTRAINT `fk_speaker_id`
  FOREIGN KEY (`speaker_id`)
  REFERENCES `conference_scheduler`.`users` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;
  
ALTER TABLE `conference_scheduler`.`user_roles` 
DROP FOREIGN KEY `fk_role_index_id`,
DROP FOREIGN KEY `fk_user_role_index_id`;
ALTER TABLE `conference_scheduler`.`user_roles` 
ADD CONSTRAINT `fk_role_index_id`
  FOREIGN KEY (`role_id`)
  REFERENCES `conference_scheduler`.`roles` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
ADD CONSTRAINT `fk_user_role_index_id`
  FOREIGN KEY (`user_id`)
  REFERENCES `conference_scheduler`.`users` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;
  
ALTER TABLE `conference_scheduler`.`conference_admins` 
DROP FOREIGN KEY `fk_admin_id`,
DROP FOREIGN KEY `fk_conference_id`;
ALTER TABLE `conference_scheduler`.`conference_admins` 
ADD CONSTRAINT `fk_admin_id`
  FOREIGN KEY (`admin_id`)
  REFERENCES `conference_scheduler`.`users` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE,
ADD CONSTRAINT `fk_conference_id`
  FOREIGN KEY (`conference_id`)
  REFERENCES `conference_scheduler`.`conference` (`id`)
  ON DELETE CASCADE
  ON UPDATE CASCADE;

INSERT INTO `conference_scheduler`.`users` (`id`, `username`, `password`, `email`) VALUES ('1', 'ginka342', 'ASDqwe123_', 'ginka342@gmail.com');
INSERT INTO `conference_scheduler`.`users` (`id`, `username`, `password`, `email`) VALUES ('2', 'pen4o0o', 'ASDqwe123_', 'pen4o0o@gmail.com');
INSERT INTO `conference_scheduler`.`users` (`id`, `username`, `password`, `email`) VALUES ('3', 'testUser123124', 'ASDqwe123_', 'testemail314@gmail.com');
INSERT INTO `conference_scheduler`.`users` (`id`, `username`, `password`, `email`) VALUES ('4', 'testUser123125', 'ASDqwe123_', 'testemail31443@gmail.com');

INSERT INTO `conference_scheduler`.`user_roles` (`user_id`, `role_id`) VALUES('1', '1');
INSERT INTO `conference_scheduler`.`user_roles` (`user_id`, `role_id`) VALUES('2', '1');
INSERT INTO `conference_scheduler`.`user_roles` (`user_id`, `role_id`) VALUES('3', '1');
INSERT INTO `conference_scheduler`.`user_roles` (`user_id`, `role_id`) VALUES('4', '1');

INSERT INTO `conference_scheduler`.`venue` (`id`, `name`) VALUES ('1', 'Gabrovo Palace');
INSERT INTO `conference_scheduler`.`venue` (`id`, `name`) VALUES ('2', 'Palace of Sports and culture Varna');
INSERT INTO `conference_scheduler`.`venue` (`id`, `name`) VALUES ('3', 'Arena Armeec Sofia');
INSERT INTO `conference_scheduler`.`venue` (`id`, `name`) VALUES ('4', 'Pleven Panorama');
INSERT INTO `conference_scheduler`.`venue` (`id`, `name`) VALUES ('5', 'London Underground');
INSERT INTO `conference_scheduler`.`venue` (`id`, `name`) VALUES ('6', 'Moda Bar Ultra Super Turbo Palace');
INSERT INTO `conference_scheduler`.`venue` (`id`, `name`) VALUES ('7', 'Tutrakanci hall of fame');
INSERT INTO `conference_scheduler`.`venue` (`id`, `name`) VALUES ('8', 'Washington DC in front of the white house');
INSERT INTO `conference_scheduler`.`venue` (`id`, `name`) VALUES ('9', 'The Req Square Palace');

INSERT INTO `conference_scheduler`.`hall` (`id`, `name`, `venue_id`, `limit`) VALUES ('1', 'Ground Lab', '3', '50');
INSERT INTO `conference_scheduler`.`hall` (`id`, `name`, `venue_id`, `limit`) VALUES ('2', 'Inspiration Lab', '2', '250');
INSERT INTO `conference_scheduler`.`hall` (`id`, `name`, `venue_id`, `limit`) VALUES ('3', 'The small room Lab', '4', '1');
INSERT INTO `conference_scheduler`.`hall` (`id`, `name`, `venue_id`, `limit`) VALUES ('4', 'The biggest computer hall in Gabrovo', '1', '3');
INSERT INTO `conference_scheduler`.`hall` (`id`, `name`, `venue_id`, `limit`) VALUES ('5', 'Magnificant hall', '5', '150');
INSERT INTO `conference_scheduler`.`hall` (`id`, `name`, `venue_id`, `limit`) VALUES ('6', 'Unique hall', '6', '100');
INSERT INTO `conference_scheduler`.`hall` (`id`, `name`, `venue_id`, `limit`) VALUES ('7', 'Lonely hearts hall', '7', '10');
INSERT INTO `conference_scheduler`.`hall` (`id`, `name`, `venue_id`, `limit`) VALUES ('8', 'Victory hall', '8', '7');
INSERT INTO `conference_scheduler`.`hall` (`id`, `name`, `venue_id`, `limit`) VALUES ('9', 'Kebap hall', '9', '13');

INSERT INTO `conference_scheduler`.`conference` (`description`, `id`, `name`, `owner_id`, `venue_id`, `start_date`, `end_date`) VALUES ('SoftUni Conference', '1', 'SoftUni Conf', '1', '1', '2015-11-22', '2015-11-23');
INSERT INTO `conference_scheduler`.`conference` (`description`, `id`, `name`, `owner_id`, `venue_id`, `start_date`, `end_date`) VALUES ('Sofia University Conference', '2', 'SU Conf', '1', '2', '2015-11-30', '2015-12-4');
INSERT INTO `conference_scheduler`.`conference` (`description`, `id`, `name`, `owner_id`, `venue_id`, `start_date`, `end_date`) VALUES ('Technical University Conference', '3', 'TU Conf', '2', '3', '2015-12-1', '2015-12-3');
INSERT INTO `conference_scheduler`.`conference` (`description`, `id`, `name`, `owner_id`, `venue_id`, `start_date`, `end_date`) VALUES ('Medical Conference', '4', 'Medical Conf', '2', '4', '2015-12-2', '2015-12-5');
INSERT INTO `conference_scheduler`.`conference` (`description`, `id`, `name`, `owner_id`, `venue_id`, `start_date`, `end_date`) VALUES ('Mercedes Conference', '5', 'Mercedes Conf', '1', '5', '2015-12-1', '2015-12-4');
INSERT INTO `conference_scheduler`.`conference` (`description`, `id`, `name`, `owner_id`, `venue_id`, `start_date`, `end_date`) VALUES ('Microsoft Conference', '6', 'Microsoft Conf', '1', '6', '2015-12-3', '2015-12-6');

INSERT INTO `conference_scheduler`.`conference_admins` (`admin_id`, `conference_id`) VALUES ('1', '1');
INSERT INTO `conference_scheduler`.`conference_admins` (`admin_id`, `conference_id`) VALUES ('2', '2');
INSERT INTO `conference_scheduler`.`conference_admins` (`admin_id`, `conference_id`) VALUES ('3', '3');
INSERT INTO `conference_scheduler`.`conference_admins` (`admin_id`, `conference_id`) VALUES ('4', '4');
INSERT INTO `conference_scheduler`.`conference_admins` (`admin_id`, `conference_id`) VALUES ('1', '5');
INSERT INTO `conference_scheduler`.`conference_admins` (`admin_id`, `conference_id`) VALUES ('2', '6');

INSERT INTO `conference_scheduler`.`lecture` (`conference_id`, `description`, `end_time`, `hall_id`, `id`, `name`, `speaker_id`, `start_time`) VALUES ('4', 'OOP Encapsulation and Polymorhism', '2015-12-2 14:00:00', '1', '1', 'OOP Lecture', '1', '2015-12-2 12:00:00');
INSERT INTO `conference_scheduler`.`lecture` (`conference_id`, `description`, `end_time`, `hall_id`, `id`, `name`, `speaker_id`, `start_time`) VALUES ('3', 'OOP Inheritance', '2015-12-1 15:00:00', '2', '2', 'C# Lecture', '2', '2015-12-1 13:00:00');
INSERT INTO `conference_scheduler`.`lecture` (`conference_id`, `description`, `end_time`, `hall_id`, `id`, `name`, `speaker_id`, `start_time`) VALUES ('2', 'OOP Exception Handling', '2015-12-3 16:00:00', '3', '3', 'Java Lecture', '4', '2015-12-3 13:00:00');
INSERT INTO `conference_scheduler`.`lecture` (`conference_id`, `description`, `end_time`, `hall_id`, `id`, `name`, `speaker_id`, `start_time`) VALUES ('1', 'Web Dev Basics Security', '2015-11-23 17:00:00', '4', '4', 'Web Dev Lecture', '3', '2015-11-23 14:00:00');
INSERT INTO `conference_scheduler`.`lecture` (`conference_id`, `description`, `end_time`, `hall_id`, `id`, `name`, `speaker_id`, `start_time`) VALUES ('6', 'ASP.NET New Features', '2015-12-3 18:00:00', '5', '5', 'ASP.NET Lecture', '2', '2015-12-3 15:00:00');
INSERT INTO `conference_scheduler`.`lecture` (`conference_id`, `description`, `end_time`, `hall_id`, `id`, `name`, `speaker_id`, `start_time`) VALUES ('5', 'Use Google properly', '2015-12-3 19:00:00', '6', '6', 'Google Lecture', '1', '2015-12-3 17:00:00');

INSERT INTO `conference_scheduler`.`lecture` (`conference_id`, `description`, `end_time`, `hall_id`, `id`, `name`, `speaker_id`, `start_time`) VALUES ('1', 'Algorithms lecture', '2015-12-3 19:00:00', '7', '7', 'Algorithms', '3', '2015-12-3 17:00:00');
INSERT INTO `conference_scheduler`.`lecture` (`conference_id`, `description`, `end_time`, `hall_id`, `id`, `name`, `speaker_id`, `start_time`) VALUES ('2', 'PHP Basics lecture', '2015-12-4 19:00:00', '8', '8', 'PHP Basics', '4', '2015-12-4 17:00:00');
INSERT INTO `conference_scheduler`.`lecture` (`conference_id`, `description`, `end_time`, `hall_id`, `id`, `name`, `speaker_id`, `start_time`) VALUES ('3', 'Advanced C# lecture', '2015-12-3 22:00:00', '9', '9', 'Advanced C#', '2', '2015-12-3 19:00:00');

INSERT INTO `conference_scheduler`.`user_lectures` (`user_id`, `lecture_id`) VALUES('1', '1');
INSERT INTO `conference_scheduler`.`user_lectures` (`user_id`, `lecture_id`) VALUES('2', '2');
