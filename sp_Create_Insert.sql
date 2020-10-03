USE `wolflog`;
DROP procedure IF EXISTS `sp_Create_Insert`;

DELIMITER $$
USE `wolflog`$$
CREATE PROCEDURE `sp_Create_Insert`()
BEGIN
    DECLARE lMonsters TEXT;
    DECLARE lItems TEXT;
    DECLARE lItemsdrop TEXT;
    DECLARE lMhealth TEXT;
    DECLARE lMonsters_features TEXT;
    DECLARE lGold TEXT;
    DECLARE lFeatures TEXT;

    SELECT Group_Concat(CONCAT('(',idMonster,", '", Name, "', ", Stars,')') SEPARATOR ',\r\n')
    FROM Monsters INTO lMonsters;

    SELECT Group_Concat(CONCAT('(',idItem,", '", Name, "', ", Stars,')') SEPARATOR ',\r\n')
    FROM items INTO lItems;

    SELECT Group_Concat(CONCAT('(',idFeature,", '", Name, "')") SEPARATOR ',\r\n')
    FROM features INTO lFeatures;

    SELECT Group_Concat(CONCAT('(',idMonster, ', ', Level, ', ', Exp, ', ', Gold, ', ', Orn, ')') SEPARATOR ',\r\n')
    FROM gold INTO lGold;

    SELECT Group_Concat(CONCAT('(', idMonster, ', ', Level, ', ', idItem, ')') SEPARATOR ',\r\n')
    FROM itemsdrop INTO lItemsdrop;

    SELECT Group_Concat(CONCAT('(', idMonster, ', ', Level, ', ', Health, ', ', Ward, ')') SEPARATOR ',\r\n')
    FROM mhealth INTO lMhealth;

    SELECT Group_Concat(CONCAT('(', idMonster, ', ', idFeature, ')') SEPARATOR ',\r\n')
    FROM monsters_features INTO lmonsters_features;

    SELECT CONCAT(
           IFNULL(
               CONCAT(
                   "INSERT INTO `wolflog`.`monsters`\r\n(`idMonster`,`Name`,`Stars`)\r\nVALUES\r\n"
                 , lMonsters
                 , ';\r\n\r\n'
               ), '')
         , IFNULL(
               CONCAT(
                   "INSERT INTO `wolflog`.`items`\r\n(`idItem`, `Name`, `Stars`)\r\nVALUES\r\n"
                   , lItems
                   , ';\r\n\r\n'
               ), '')
         , IFNULL(
               CONCAT(
                   "INSERT INTO `wolflog`.`features`\r\n(`idFeature`, `Name`)\r\nVALUES\r\n"
                   , lFeatures
                   , ';\r\n\r\n'
               ), '')
         , IFNULL(
               CONCAT(
                   "INSERT INTO `wolflog`.`gold`\r\n(`idMonster`, `Level`, `Exp`, `Gold`, `Orn`)\r\nVALUES\r\n"
                   , lGold
                   , ';\r\n\r\n'
               ), '')
         , IFNULL(
               CONCAT(
                   "INSERT INTO `wolflog`.`itemsdrop`\r\n(`idMonster`, `Level`, `idItem`)\r\nVALUES\r\n"
                   , lItemsdrop
                   , ';\r\n\r\n'
               ), '')
         , IFNULL(
               CONCAT(
                   "INSERT INTO `wolflog`.`mhealth`\r\n(`idMonster`, `Level`, `Health`, `Ward`)\r\nVALUES\r\n"
                   , lMhealth
                   , ';\r\n\r\n'
               ), '')
         , IFNULL(
               CONCAT(
                   "INSERT INTO `wolflog`.`monsters_features`\r\n(`idMonster`, `idFeature`)\r\nVALUES\r\n"
                   , lmonsters_features, ';'
               ), '')
         ) AS LINE;
END$$

DELIMITER ;
