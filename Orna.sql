-- MySQL Workbench Synchronization
-- Generated: 2020-10-03 18:02
-- Model: Orna
-- Version: 1.0
-- Project: SF MAI Databases
-- Author: Danilin Aleksander

-- Создаем схему
CREATE SCHEMA IF NOT EXISTS `Orna` DEFAULT CHARACTER SET cp1251 ;

-- Удаляем структуру
DROP TABLE IF EXISTS `Orna`.`itemsdrop`;
DROP TABLE IF EXISTS `Orna`.`mhealth`;
DROP TABLE IF EXISTS `Orna`.`monstersfeatures`;
DROP TABLE IF EXISTS `Orna`.`gold`;
DROP TABLE IF EXISTS `Orna`.`features`;
DROP TABLE IF EXISTS `Orna`.`items`;
DROP TABLE IF EXISTS `Orna`.`monsters`;
DROP PROCEDURE IF EXISTS `Orna`.`sp_Items_Drops`;
DROP PROCEDURE IF EXISTS `Orna`.`sp_Monsters_Drops`;
DROP PROCEDURE IF EXISTS `Orna`.`sp_Monsters_Features`;
DROP PROCEDURE IF EXISTS `Orna`.`sp_Monsters_Gold`;
DROP PROCEDURE IF EXISTS `Orna`.`sp_Monsters_Health`;

-- Создаем таблицы
CREATE TABLE IF NOT EXISTS `Orna`.`Monsters` (
  `idMonster` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(255) NULL DEFAULT NULL,
  `Stars` TINYINT(8) NOT NULL,
  PRIMARY KEY (`idMonster`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = cp1251;

CREATE TABLE IF NOT EXISTS `Orna`.`MHealth` (
  `idMonster` INT(10) UNSIGNED NOT NULL,
  `Level` SMALLINT(8) NOT NULL,
  `Health` SMALLINT(8) NULL DEFAULT NULL,
  `Ward` SMALLINT(8) NULL DEFAULT NULL,
  PRIMARY KEY (`Level`, `idMonster`),
  INDEX `fk_MHealth_Monsters_idx` (`idMonster` ASC),
  CONSTRAINT `fk_MHealth_Monsters`
    FOREIGN KEY (`idMonster`)
    REFERENCES `Orna`.`Monsters` (`idMonster`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Orna`.`Gold` (
  `idMonster` INT(10) UNSIGNED NOT NULL,
  `Level` SMALLINT(8) NOT NULL,
  `Exp` SMALLINT(8) NULL DEFAULT NULL,
  `Gold` SMALLINT(8) NULL DEFAULT NULL,
  `Orn` SMALLINT(8) NULL DEFAULT NULL,
  PRIMARY KEY (`idMonster`, `Level`),
  INDEX `fk_Gold_Monsters1_idx` (`idMonster` ASC),
  CONSTRAINT `fk_Gold_Monsters1`
    FOREIGN KEY (`idMonster`)
    REFERENCES `Orna`.`Monsters` (`idMonster`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Orna`.`Items` (
  `idItem` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(255) NULL DEFAULT NULL,
  `Stars` TINYINT(8) NULL DEFAULT NULL,
  PRIMARY KEY (`idItem`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = cp1251;

CREATE TABLE IF NOT EXISTS `Orna`.`ItemsDrop` (
  `idMonster` INT(10) UNSIGNED NOT NULL,
  `Level` SMALLINT(8) NOT NULL,
  `idItem` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`Level`, `idMonster`, `idItem`),
  INDEX `fk_Drop_Items1_idx` (`idItem` ASC),
  INDEX `fk_Drop_Monsters1_idx` (`idMonster` ASC),
  CONSTRAINT `fk_Drop_Items1`
    FOREIGN KEY (`idItem`)
    REFERENCES `Orna`.`Items` (`idItem`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Drop_Monsters1`
    FOREIGN KEY (`idMonster`)
    REFERENCES `Orna`.`Monsters` (`idMonster`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

CREATE TABLE IF NOT EXISTS `Orna`.`Features` (
  `idFeature` INT(10) UNSIGNED NOT NULL AUTO_INCREMENT,
  `Name` VARCHAR(255) NULL DEFAULT NULL,
  PRIMARY KEY (`idFeature`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = cp1251;

CREATE TABLE IF NOT EXISTS `Orna`.`MonstersFeatures` (
  `idMonster` INT(10) UNSIGNED NOT NULL,
  `idFeature` INT(10) UNSIGNED NOT NULL,
  PRIMARY KEY (`idMonster`, `idFeature`),
  INDEX `fk_Monsters_Features_Monsters1_idx` (`idMonster` ASC),
  INDEX `fk_Monsters_Features_Features1_idx` (`idFeature` ASC),
  CONSTRAINT `fk_Monsters_Features_Monsters1`
    FOREIGN KEY (`idMonster`)
    REFERENCES `Orna`.`Monsters` (`idMonster`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_Monsters_Features_Features1`
    FOREIGN KEY (`idFeature`)
    REFERENCES `Orna`.`Features` (`idFeature`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;

-- Создаем процедуры
DELIMITER $$
USE `Orna`$$

/* Здоровье выбранного монстра по уровням */
CREATE PROCEDURE `sp_Monsters_Health` (prm_MonsterID INT)
BEGIN
    SELECT m.Name   AS name
         , m.Stars  AS Stars
         , h.Level  AS Level
         , h.Health AS Health
         , h.Ward   AS Ward
      FROM Monsters AS m
      JOIN MHealth  AS h
        ON h.idMonster = m.idMonster
     WHERE m.idMonster = prm_MonsterID
     ORDER BY h.Level;
END$$

/* Список вещей выпадающих с монстра */
CREATE PROCEDURE `sp_Monsters_Drops`  (prm_MonsterID INT)
BEGIN
    SELECT m.Name                              AS Name
         , m.Stars                             AS Stars
         , REPEAT('*', m.Stars)                AS StrStars
         , GROUP_CONCAT(i.Name SEPARATOR ', ') AS Item
      FROM Monsters AS m
      JOIN ItemsDrop AS d
        ON d.idMonster = m.idMonster
      JOIN Items AS i
        ON d.idItem = i.idItem
     WHERE m.idMonster = prm_MonsterID;
END$$

/* Количество золота и опыта за монстра по уровням */
CREATE PROCEDURE `sp_Monsters_Gold`  (prm_MonsterID INT)
BEGIN
    SELECT m.Name   AS Name
         , g.Level  AS Level
         , m.Stars  AS Stars
         , REPEAT('*', m.Stars) AS StrStars
         , g.Exp    AS Exp
         , g.Gold   AS Gold
         , g.Orn    AS Orn
      FROM Monsters AS m
      JOIN Gold  AS g
        ON g.idMonster = m.idMonster
     WHERE m.idMonster = prm_MonsterID
     ORDER BY g.Level;
END$$

/* Список монстров с которых выпадает предмет */
CREATE PROCEDURE `sp_Items_Drops` (prm_ItemID INT)
BEGIN
    SELECT i.Name   AS Item
         , i.Stars   AS Item_stars
         , REPEAT('*', i.Stars) AS StrStars
         , GROUP_CONCAT(m.Name SEPARATOR ', ') AS Monsters
      FROM Items AS i
      JOIN ItemsDrop  AS d
        ON d.idItem = i.idItem
      JOIN Monsters AS m
        ON m.idMonster = d.idMonster
     WHERE i.idItem = prm_ItemID;
END$$

/* Список особенностей монстров */
CREATE PROCEDURE `sp_Monsters_Features` ()
BEGIN
    SELECT f.Name AS Feature
         , m.Name AS Monter
      FROM Monsters AS m
      JOIN Monsters_Features AS mp
        ON mp.idMonter = m.idMonster
      JOIN Features AS f
        ON f.idFeature = mp.idFeature
     GROUP BY m.idMonster;
END$$

DELIMITER ;

-- Заполняем таблицы
-- Базовые
INSERT INTO `Orna`.`monsters`
(`idMonster`, `Name`, `Stars`)
VALUES
(1, 'Паук', 1),
(2, 'Мустанг', 2),
(3, 'Красный слизень', 1),
(4, 'Ястреб', 2),
(5, 'Драконит-маг', 2);

INSERT INTO `Orna`.`items`
(`idItem`, `Name`, `Stars`)
VALUES
(1, 'Малое зелье маны', 1),
(2, 'Зелье лечения', 2),
(3, 'Кожа', 1),
(4, 'Малое зелье маны', 1),
(5, 'Малый элексир', 2),
(6, 'Зелье маны', 2),
(7, 'Книга чудищ', 2),
(8, 'Клобук драконита', 2),
(9, 'Роба драконита', 2),
(10, 'Посох драконита', 2);

INSERT INTO `Orna`.`features`
(`idFeature`, `Name`)
VALUES
(null, null);

-- Производные
INSERT INTO `Orna`.`gold`
(`idMonster`, `Level`, `Exp`, `Gold`, `Orn`)
VALUES
(1, 3, 1, 6, 7),
(2, 38, 1179, 85, 13),
(2, 40, 1267, 108, 11),
(2, 47, 1451, 177, 13),
(3, 4, 107, 7, 6),
(4, 42, 1434, 96, 13),
(5, 39, 1335, 87, 10);

INSERT INTO `Orna`.`itemsdrop`
(`idMonster`, `Level`, `idItem`)
VALUES
(1, 3, 1),
(2, 40, 1),
(2, 38, 2),
(2, 47, 2),
(2, 47, 3),
(2, 40, 4),
(2, 38, 5),
(5, 39, 6),
(5, 39, 7),
(5, 39, 8),
(5, 39, 9),
(5, 39, 10);

INSERT INTO `Orna`.`mhealth`
(`idMonster`, `Level`, `Health`, `Ward`)
VALUES
(1, 3, 29, NULL),
(3, 4, 16, NULL),
(2, 38, 355, NULL),
(5, 39, 342, NULL),
(2, 40, 350, NULL),
(2, 42, 365, NULL),
(4, 42, 365, NULL),
(2, 47, 402, 91);

/*INSERT INTO `Orna`.`monstersfeatures`
(`idMonster`, `idFeature`)
VALUES
(NULL, NULL);*/
