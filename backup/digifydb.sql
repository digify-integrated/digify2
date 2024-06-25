-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jun 25, 2024 at 04:33 PM
-- Server version: 10.4.28-MariaDB
-- PHP Version: 8.2.4

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
START TRANSACTION;
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8mb4 */;

--
-- Database: `digifydb`
--

DELIMITER $$
--
-- Procedures
--
DROP PROCEDURE IF EXISTS `buildAppModuleStack`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `buildAppModuleStack` (IN `p_user_account_id` INT)   BEGIN
    SELECT DISTINCT(am.app_module_id) as app_module_id, am.app_module_name, am.menu_item_id, app_logo, app_version
    FROM app_module am
    JOIN menu_item mi ON mi.app_module_id = am.app_module_id
    WHERE EXISTS (
        SELECT 1
        FROM role_permission mar
        WHERE mar.menu_item_id = mi.menu_item_id
        AND mar.read_access = 1
        AND mar.role_id IN (
            SELECT role_id
            FROM role_user_account
            WHERE user_account_id = p_user_account_id
        )
    )
    ORDER BY am.order_sequence;
END$$

DROP PROCEDURE IF EXISTS `buildMenuGroup`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `buildMenuGroup` (IN `p_user_account_id` INT, IN `p_app_module_id` INT)   BEGIN
    SELECT DISTINCT(mg.menu_group_id) as menu_group_id, mg.menu_group_name as menu_group_name
    FROM menu_group mg
    JOIN menu_item mi ON mi.menu_group_id = mg.menu_group_id
    WHERE EXISTS (
        SELECT 1
        FROM role_permission mar
        WHERE mar.menu_item_id = mi.menu_item_id
        AND mar.read_access = 1
        AND mar.role_id IN (
            SELECT role_id
            FROM role_user_account
            WHERE user_account_id = p_user_account_id
        )
    )
    AND mg.app_module_id = p_app_module_id
    ORDER BY mg.order_sequence;
END$$

DROP PROCEDURE IF EXISTS `buildMenuItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `buildMenuItem` (IN `p_user_account_id` INT, IN `p_menu_group_id` INT)   BEGIN
    SELECT mi.menu_item_id, mi.menu_item_name, mi.menu_group_id, mi.menu_item_url, mi.parent_id, mi.app_module_id, mi.menu_item_icon
    FROM menu_item AS mi
    INNER JOIN role_permission AS mar ON mi.menu_item_id = mar.menu_item_id
    INNER JOIN role_user_account AS ru ON mar.role_id = ru.role_id
    WHERE mar.read_access = 1 AND ru.user_account_id = p_user_account_id AND mi.menu_group_id = p_menu_group_id
    ORDER BY mi.order_sequence;
END$$

DROP PROCEDURE IF EXISTS `checkAccessRights`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkAccessRights` (IN `p_user_account_id` INT, IN `p_menu_item_id` INT, IN `p_access_type` VARCHAR(10))   BEGIN
	IF p_access_type = 'read' THEN
        SELECT COUNT(role_id) AS total
        FROM role_user_account
        WHERE user_account_id = p_user_account_id AND role_id IN (SELECT role_id FROM role_permission where read_access = 1 AND menu_item_id = p_menu_item_id);
    ELSEIF p_access_type = 'write' THEN
        SELECT COUNT(role_id) AS total
        FROM role_user_account
        WHERE user_account_id = p_user_account_id AND role_id IN (SELECT role_id FROM role_permission where write_access = 1 AND menu_item_id = p_menu_item_id);
    ELSEIF p_access_type = 'create' THEN
        SELECT COUNT(role_id) AS total
        FROM role_user_account
        WHERE user_account_id = p_user_account_id AND role_id IN (SELECT role_id FROM role_permission where create_access = 1 AND menu_item_id = p_menu_item_id);       
    ELSE
        SELECT COUNT(role_id) AS total
        FROM role_user_account
        WHERE user_account_id = p_user_account_id AND role_id IN (SELECT role_id FROM role_permission where delete_access = 1 AND menu_item_id = p_menu_item_id);
    END IF;
END$$

DROP PROCEDURE IF EXISTS `checkAppModuleExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkAppModuleExist` (IN `p_app_module_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM app_module
    WHERE app_module_id = p_app_module_id;
END$$

DROP PROCEDURE IF EXISTS `checkCityExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkCityExist` (IN `p_city_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM city
    WHERE city_id = p_city_id;
END$$

DROP PROCEDURE IF EXISTS `checkCompanyExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkCompanyExist` (IN `p_company_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM company
    WHERE company_id = p_company_id;
END$$

DROP PROCEDURE IF EXISTS `checkCountryExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkCountryExist` (IN `p_country_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM country
    WHERE country_id = p_country_id;
END$$

DROP PROCEDURE IF EXISTS `checkCurrencyExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkCurrencyExist` (IN `p_currency_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM currency
    WHERE currency_id = p_currency_id;
END$$

DROP PROCEDURE IF EXISTS `checkEmailNotificationTemplateExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkEmailNotificationTemplateExist` (IN `p_notification_setting_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM notification_setting_email_template
    WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `checkEmailSettingExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkEmailSettingExist` (IN `p_email_setting_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM email_setting
    WHERE email_setting_id = p_email_setting_id;
END$$

DROP PROCEDURE IF EXISTS `checkFileExtensionExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkFileExtensionExist` (IN `p_file_extension_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM file_extension
    WHERE file_extension_id = p_file_extension_id;
END$$

DROP PROCEDURE IF EXISTS `checkFileTypeExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkFileTypeExist` (IN `p_file_type_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM file_type
    WHERE file_type_id = p_file_type_id;
END$$

DROP PROCEDURE IF EXISTS `checkLoginCredentialsExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkLoginCredentialsExist` (IN `p_user_account_id` INT, IN `p_email` VARCHAR(255))   BEGIN
	SELECT COUNT(*) AS total
    FROM user_account
    WHERE user_account_id = p_user_account_id OR email = p_email;
END$$

DROP PROCEDURE IF EXISTS `checkMenuGroupExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkMenuGroupExist` (IN `p_menu_group_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM menu_group
    WHERE menu_group_id = p_menu_group_id;
END$$

DROP PROCEDURE IF EXISTS `checkMenuItemExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkMenuItemExist` (IN `p_menu_item_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM menu_item
    WHERE menu_item_id = p_menu_item_id;
END$$

DROP PROCEDURE IF EXISTS `checkNotificationSettingExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkNotificationSettingExist` (IN `p_notification_setting_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM notification_setting
    WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `checkRoleExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkRoleExist` (IN `p_role_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM role
    WHERE role_id = p_role_id;
END$$

DROP PROCEDURE IF EXISTS `checkRolePermissionExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkRolePermissionExist` (IN `p_role_permission_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM role_permission
    WHERE role_permission_id = p_role_permission_id;
END$$

DROP PROCEDURE IF EXISTS `checkRoleSystemActionPermissionExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkRoleSystemActionPermissionExist` (IN `p_role_system_action_permission_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM role_system_action_permission
    WHERE role_system_action_permission_id = p_role_system_action_permission_id;
END$$

DROP PROCEDURE IF EXISTS `checkRoleUserAccountExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkRoleUserAccountExist` (IN `p_role_user_account_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM role_user_account
    WHERE role_user_account_id = p_role_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `checkSMSNotificationTemplateExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkSMSNotificationTemplateExist` (IN `p_notification_setting_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM notification_setting_sms_template
    WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `checkStateExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkStateExist` (IN `p_state_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM state
    WHERE state_id = p_state_id;
END$$

DROP PROCEDURE IF EXISTS `checkSystemActionAccessRights`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkSystemActionAccessRights` (IN `p_user_account_id` INT, IN `p_system_action_id` INT)   BEGIN
    SELECT COUNT(role_id) AS total
    FROM role_system_action_permission 
    WHERE system_action_id = p_system_action_id AND system_action_access = 1 AND role_id IN (SELECT role_id FROM role_user_account WHERE user_account_id = p_user_account_id);
END$$

DROP PROCEDURE IF EXISTS `checkSystemActionExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkSystemActionExist` (IN `p_system_action_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM system_action
    WHERE system_action_id = p_system_action_id;
END$$

DROP PROCEDURE IF EXISTS `checkSystemNotificationTemplateExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkSystemNotificationTemplateExist` (IN `p_notification_setting_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM notification_setting_system_template
    WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `checkUploadSettingExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkUploadSettingExist` (IN `p_upload_setting_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM upload_setting
    WHERE upload_setting_id = p_upload_setting_id;
END$$

DROP PROCEDURE IF EXISTS `checkUploadSettingFileExtensionExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkUploadSettingFileExtensionExist` (IN `p_upload_setting_file_extension_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM upload_setting_file_extension
    WHERE upload_setting_file_extension_id = p_upload_setting_file_extension_id;
END$$

DROP PROCEDURE IF EXISTS `checkUserAccountEmailExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkUserAccountEmailExist` (IN `p_email` VARCHAR(255))   BEGIN
	SELECT COUNT(*) AS total
    FROM user_account
    WHERE email = p_email;
END$$

DROP PROCEDURE IF EXISTS `checkUserAccountEmailUpdateExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkUserAccountEmailUpdateExist` (IN `p_user_account_id` INT, IN `p_email` VARCHAR(255))   BEGIN
	SELECT COUNT(*) AS total
    FROM user_account
    WHERE email = p_email AND user_account_id != p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `checkUserAccountExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkUserAccountExist` (IN `p_user_account_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM user_account
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `deleteAppModule`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteAppModule` (IN `p_app_module_id` INT)   BEGIN
    DELETE FROM app_module WHERE app_module_id = p_app_module_id;
END$$

DROP PROCEDURE IF EXISTS `deleteCity`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCity` (IN `p_city_id` INT)   BEGIN
    DELETE FROM city WHERE city_id = p_city_id;
END$$

DROP PROCEDURE IF EXISTS `deleteCompany`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCompany` (IN `p_company_id` INT)   BEGIN
    DELETE FROM company WHERE company_id = p_company_id;
END$$

DROP PROCEDURE IF EXISTS `deleteCountry`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCountry` (IN `p_country_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM city WHERE country_id = p_country_id;
    DELETE FROM state WHERE country_id = p_country_id;
    DELETE FROM country WHERE country_id = p_country_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteCurrency`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCurrency` (IN `p_currency_id` INT)   BEGIN
    DELETE FROM currency WHERE currency_id = p_currency_id;
END$$

DROP PROCEDURE IF EXISTS `deleteEmailSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteEmailSetting` (IN `p_email_setting_id` INT)   BEGIN
   DELETE FROM email_setting WHERE email_setting_id = p_email_setting_id;
END$$

DROP PROCEDURE IF EXISTS `deleteFileExtension`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteFileExtension` (IN `p_file_extension_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM upload_setting_file_extension WHERE file_extension_id = p_file_extension_id;
    DELETE FROM file_extension WHERE file_extension_id = p_file_extension_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteFileType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteFileType` (IN `p_file_type_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM upload_setting_file_extension WHERE file_extension_id IN (SELECT file_extension_id FROM file_extension WHERE file_type_id = p_file_type_id);
    DELETE FROM file_extension WHERE file_type_id = p_file_type_id;
    DELETE FROM file_type WHERE file_type_id = p_file_type_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteMenuGroup`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteMenuGroup` (IN `p_menu_group_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM menu_group WHERE menu_group_id = p_menu_group_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteMenuItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteMenuItem` (IN `p_menu_item_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM role_permission WHERE menu_item_id = p_menu_item_id;
    DELETE FROM menu_item WHERE menu_item_id = p_menu_item_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteNotificationSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteNotificationSetting` (IN `p_notification_setting_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM notification_setting_email_template WHERE notification_setting_id = p_notification_setting_id;
    DELETE FROM notification_setting_system_template WHERE notification_setting_id = p_notification_setting_id;
    DELETE FROM notification_setting_sms_template WHERE notification_setting_id = p_notification_setting_id;
    DELETE FROM notification_setting WHERE notification_setting_id = p_notification_setting_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteRole`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteRole` (IN `p_role_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM role_permission WHERE role_id = p_role_id;
    DELETE FROM role_system_action_permission WHERE role_id = p_role_id;
    DELETE FROM role WHERE role_id = p_role_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteRolePermission`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteRolePermission` (IN `p_role_permission_id` INT)   BEGIN
   DELETE FROM role_permission WHERE role_permission_id = p_role_permission_id;
END$$

DROP PROCEDURE IF EXISTS `deleteRoleSystemActionPermission`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteRoleSystemActionPermission` (IN `p_role_system_action_permission_id` INT)   BEGIN
   DELETE FROM role_system_action_permission WHERE role_system_action_permission_id = p_role_system_action_permission_id;
END$$

DROP PROCEDURE IF EXISTS `deleteRoleUserAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteRoleUserAccount` (IN `p_role_user_account_id` INT)   BEGIN
   DELETE FROM role_user_account WHERE role_user_account_id = p_role_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `deleteState`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteState` (IN `p_state_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM city WHERE state_id = p_state_id;
    DELETE FROM state WHERE state_id = p_state_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteSystemAction`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteSystemAction` (IN `p_system_action_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM role_system_action_permission WHERE system_action_id = p_system_action_id;
    DELETE FROM system_action WHERE system_action_id = p_system_action_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteUploadSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteUploadSetting` (IN `p_upload_setting_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM upload_setting_file_extension WHERE upload_setting_id = p_upload_setting_id;
    DELETE FROM upload_setting WHERE upload_setting_id = p_upload_setting_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteUploadSettingFileExtension`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteUploadSettingFileExtension` (IN `p_upload_setting_file_extension_id` INT)   BEGIN
    DELETE FROM upload_setting_file_extension WHERE upload_setting_file_extension_id = p_upload_setting_file_extension_id;
END$$

DROP PROCEDURE IF EXISTS `deleteUserAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteUserAccount` (IN `p_user_account_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM role_user_account WHERE user_account_id = p_user_account_id;
    DELETE FROM password_history WHERE user_account_id = p_user_account_id;
    DELETE FROM user_account WHERE user_account_id = p_user_account_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `generateAppModuleOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateAppModuleOptions` ()   BEGIN
	SELECT app_module_id, app_module_name 
    FROM app_module 
    ORDER BY app_module_name;
END$$

DROP PROCEDURE IF EXISTS `generateAppModuleTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateAppModuleTable` ()   BEGIN
	SELECT app_module_id, app_module_name, app_module_description, app_version, app_logo, order_sequence 
    FROM app_module 
    ORDER BY app_module_id;
END$$

DROP PROCEDURE IF EXISTS `generateCityOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateCityOptions` ()   BEGIN
	SELECT city_id, city_name, state_name, country_name 
    FROM city 
    ORDER BY city_name;
END$$

DROP PROCEDURE IF EXISTS `generateCityTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateCityTable` (IN `p_filter_by_state` INT, IN `p_filter_by_country` INT)   BEGIN
    DECLARE query VARCHAR(5000);

    SET query = CONCAT('
        SELECT city_id, city_name, state_name, country_name
        FROM city 
        WHERE 1');

    IF p_filter_by_state IS NOT NULL THEN
        SET query = CONCAT(query, ' AND state_id = ', p_filter_by_state);
    END IF;

    IF p_filter_by_country IS NOT NULL THEN
        SET query = CONCAT(query, ' AND country_id = ', p_filter_by_country);
    END IF;

    SET query = CONCAT(query, ' ORDER BY city_name');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS `generateCompanyOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateCompanyOptions` ()   BEGIN
	SELECT company_id, company_name 
    FROM company 
    ORDER BY company_name;
END$$

DROP PROCEDURE IF EXISTS `generateCompanyTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateCompanyTable` (IN `p_filter_by_city` INT, IN `p_filter_by_state` INT, IN `p_filter_by_country` INT)   BEGIN
    DECLARE query VARCHAR(5000);

    SET query = CONCAT('
        SELECT company_id, company_name, address, city_name, state_name, country_name, company_logo
        FROM company 
        WHERE 1');

    IF p_filter_by_city IS NOT NULL THEN
        SET query = CONCAT(query, ' AND city_id = ', p_filter_by_city);
    END IF;

    IF p_filter_by_state IS NOT NULL THEN
        SET query = CONCAT(query, ' AND state_id = ', p_filter_by_state);
    END IF;

    IF p_filter_by_country IS NOT NULL THEN
        SET query = CONCAT(query, ' AND country_id = ', p_filter_by_country);
    END IF;

    SET query = CONCAT(query, ' ORDER BY company_name');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS `generateCountryOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateCountryOptions` ()   BEGIN
	SELECT country_id, country_name 
    FROM country 
    ORDER BY country_name;
END$$

DROP PROCEDURE IF EXISTS `generateCountryTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateCountryTable` ()   BEGIN
	SELECT country_id, country_name 
    FROM country 
    ORDER BY country_id;
END$$

DROP PROCEDURE IF EXISTS `generateCurrencyOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateCurrencyOptions` ()   BEGIN
	SELECT currency_id, currency_name, currency_symbol FROM currency 
    ORDER BY currency_name;
END$$

DROP PROCEDURE IF EXISTS `generateCurrencyTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateCurrencyTable` ()   BEGIN
    SELECT currency_id, currency_name, currency_symbol FROM currency;
END$$

DROP PROCEDURE IF EXISTS `generateEmailSettingTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateEmailSettingTable` ()   BEGIN
    SELECT email_setting_id, email_setting_name, email_setting_description 
    FROM email_setting
    ORDER BY email_setting_name;
END$$

DROP PROCEDURE IF EXISTS `generateFileExtensionDualListBoxOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateFileExtensionDualListBoxOptions` (IN `p_upload_setting_id` INT)   BEGIN
	SELECT file_extension_id, file_extension_name, file_extension
    FROM file_extension 
    WHERE file_extension_id NOT IN (SELECT file_extension_id FROM upload_setting_file_extension WHERE upload_setting_id = p_upload_setting_id)
    ORDER BY file_extension_name;
END$$

DROP PROCEDURE IF EXISTS `generateFileExtensionTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateFileExtensionTable` (IN `p_filter_by_file_type` INT)   BEGIN
    DECLARE query VARCHAR(5000);

    SET query = CONCAT('
        SELECT file_extension_id, file_extension_name, file_extension, file_type_name 
        FROM file_extension 
        WHERE 1');

    IF p_filter_by_file_type IS NOT NULL THEN
        SET query = CONCAT(query, ' AND file_type_id = ', p_filter_by_file_type);
    END IF;

    SET query = CONCAT(query, ' ORDER BY file_extension_name');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS `generateFileTypeOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateFileTypeOptions` ()   BEGIN
	SELECT file_type_id, file_type_name 
    FROM file_type 
    ORDER BY file_type_name;
END$$

DROP PROCEDURE IF EXISTS `generateFileTypeTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateFileTypeTable` ()   BEGIN
	SELECT file_type_id, file_type_name 
    FROM file_type 
    ORDER BY file_type_id;
END$$

DROP PROCEDURE IF EXISTS `generateInternalNotes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateInternalNotes` (IN `p_table_name` VARCHAR(255), IN `p_reference_id` INT)   BEGIN
	SELECT internal_notes_id, internal_note, internal_note_by, internal_note_date
    FROM internal_notes
    WHERE table_name = p_table_name AND reference_id  = p_reference_id
    ORDER BY internal_note_date DESC;
END$$

DROP PROCEDURE IF EXISTS `generateLogNotes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateLogNotes` (IN `p_table_name` VARCHAR(255), IN `p_reference_id` INT)   BEGIN
	SELECT log, changed_by, changed_at
    FROM audit_log
    WHERE table_name = p_table_name AND reference_id  = p_reference_id
    ORDER BY changed_at DESC;
END$$

DROP PROCEDURE IF EXISTS `generateMenuGroupOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateMenuGroupOptions` ()   BEGIN
	SELECT menu_group_id, menu_group_name 
    FROM menu_group 
    ORDER BY menu_group_name;
END$$

DROP PROCEDURE IF EXISTS `generateMenuGroupTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateMenuGroupTable` (IN `p_filter_by_app_module` INT)   BEGIN
    DECLARE query VARCHAR(5000);

    SET query = CONCAT('
        SELECT menu_group_id, menu_group_name, app_module_name, order_sequence 
        FROM menu_group 
        WHERE 1');

    IF p_filter_by_app_module IS NOT NULL AND p_filter_by_app_module <> '' THEN
        SET query = CONCAT(query, ' AND app_module_id = ', p_filter_by_app_module);
    END IF;

    SET query = CONCAT(query, ' ORDER BY menu_group_name');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS `generateMenuItemOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateMenuItemOptions` ()   BEGIN
	SELECT menu_item_id, menu_item_name 
    FROM menu_item 
    ORDER BY menu_item_name;
END$$

DROP PROCEDURE IF EXISTS `generateMenuItemRoleDualListBoxOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateMenuItemRoleDualListBoxOptions` (IN `p_menu_item_id` INT)   BEGIN
	SELECT role_id, role_name 
    FROM role 
    WHERE role_id NOT IN (SELECT role_id FROM role_permission WHERE menu_item_id = p_menu_item_id)
    ORDER BY role_name;
END$$

DROP PROCEDURE IF EXISTS `generateMenuItemRolePermissionTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateMenuItemRolePermissionTable` (IN `p_menu_item_id` INT)   BEGIN
	SELECT role_permission_id, role_name, read_access, write_access, create_access, delete_access 
    FROM role_permission
    WHERE menu_item_id = p_menu_item_id
    ORDER BY role_name;
END$$

DROP PROCEDURE IF EXISTS `generateMenuItemTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateMenuItemTable` (IN `p_filter_by_menu_group` INT, IN `p_filter_by_app_module` INT)   BEGIN
    DECLARE query VARCHAR(5000);

    SET query = CONCAT('
        SELECT menu_item_id, menu_item_name, menu_group_name, app_module_name, order_sequence 
        FROM menu_item 
        WHERE 1');

    IF p_filter_by_menu_group IS NOT NULL AND p_filter_by_menu_group <> '' THEN
        SET query = CONCAT(query, ' AND menu_group_id = ', p_filter_by_menu_group);
    END IF;

    IF p_filter_by_app_module IS NOT NULL AND p_filter_by_app_module <> '' THEN
        SET query = CONCAT(query, ' AND app_module_id = ', p_filter_by_app_module);
    END IF;

    SET query = CONCAT(query, ' ORDER BY menu_item_name');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS `generateNotificationSettingTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateNotificationSettingTable` ()   BEGIN
    SELECT notification_setting_id, notification_setting_name, notification_setting_description 
    FROM notification_setting
    ORDER BY notification_setting_name;
END$$

DROP PROCEDURE IF EXISTS `generateRoleMenuItemDualListBoxOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateRoleMenuItemDualListBoxOptions` (IN `p_role_id` INT)   BEGIN
	SELECT menu_item_id, menu_item_name 
    FROM menu_item 
    WHERE menu_item_id NOT IN (SELECT menu_item_id FROM role_permission WHERE role_id = p_role_id)
    ORDER BY menu_item_name;
END$$

DROP PROCEDURE IF EXISTS `generateRoleMenuItemPermissionTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateRoleMenuItemPermissionTable` (IN `p_role_id` INT)   BEGIN
	SELECT role_permission_id, menu_item_name, read_access, write_access, create_access, delete_access 
    FROM role_permission
    WHERE role_id = p_role_id
    ORDER BY menu_item_name;
END$$

DROP PROCEDURE IF EXISTS `generateRoleSystemActionDualListBoxOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateRoleSystemActionDualListBoxOptions` (IN `p_role_id` INT)   BEGIN
	SELECT system_action_id, system_action_name
    FROM system_action 
    WHERE system_action_id NOT IN (SELECT system_action_id FROM role_system_action_permission WHERE role_id = p_role_id)
    ORDER BY system_action_name;
END$$

DROP PROCEDURE IF EXISTS `generateRoleSystemActionPermissionTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateRoleSystemActionPermissionTable` (IN `p_role_id` INT)   BEGIN
	SELECT role_system_action_permission_id, system_action_name, system_action_access 
    FROM role_system_action_permission
    WHERE role_id = p_role_id
    ORDER BY system_action_name;
END$$

DROP PROCEDURE IF EXISTS `generateRoleTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateRoleTable` ()   BEGIN
	SELECT role_id, role_name, role_description
    FROM role 
    ORDER BY role_id;
END$$

DROP PROCEDURE IF EXISTS `generateRoleUserAccountDualListBoxOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateRoleUserAccountDualListBoxOptions` (IN `p_role_id` INT)   BEGIN
	SELECT user_account_id, file_as 
    FROM user_account 
    WHERE user_account_id NOT IN (SELECT user_account_id FROM role_user_account WHERE role_id = p_role_id)
    ORDER BY file_as;
END$$

DROP PROCEDURE IF EXISTS `generateRoleUserAccountTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateRoleUserAccountTable` (IN `p_role_id` INT)   BEGIN
	SELECT role_user_account_id, user_account_id, file_as 
    FROM role_user_account
    WHERE role_id = p_role_id
    ORDER BY file_as;
END$$

DROP PROCEDURE IF EXISTS `generateStateOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateStateOptions` ()   BEGIN
	SELECT state_id, state_name, country_name
    FROM state 
    ORDER BY state_name;
END$$

DROP PROCEDURE IF EXISTS `generateStateTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateStateTable` (IN `p_filter_by_country` INT)   BEGIN
    DECLARE query VARCHAR(5000);

    SET query = CONCAT('
        SELECT state_id, state_name, country_name 
        FROM state 
        WHERE 1');

    IF p_filter_by_country IS NOT NULL THEN
        SET query = CONCAT(query, ' AND country_id = ', p_filter_by_country);
    END IF;

    SET query = CONCAT(query, ' ORDER BY state_name');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS `generateSubmenuItemTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateSubmenuItemTable` (IN `p_parent_id` INT)   BEGIN
	SELECT * FROM menu_item
	WHERE parent_id = p_parent_id AND parent_id IS NOT NULL;
END$$

DROP PROCEDURE IF EXISTS `generateSystemActionRoleDualListBoxOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateSystemActionRoleDualListBoxOptions` (IN `p_system_action_id` INT)   BEGIN
	SELECT role_id, role_name 
    FROM role 
    WHERE role_id NOT IN (SELECT role_id FROM role_system_action_permission WHERE system_action_id = p_system_action_id)
    ORDER BY role_name;
END$$

DROP PROCEDURE IF EXISTS `generateSystemActionRolePermissionTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateSystemActionRolePermissionTable` (IN `p_system_action_id` INT)   BEGIN
	SELECT role_system_action_permission_id, role_name, system_action_access 
    FROM role_system_action_permission
    WHERE system_action_id = p_system_action_id
    ORDER BY role_name;
END$$

DROP PROCEDURE IF EXISTS `generateSystemActionTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateSystemActionTable` ()   BEGIN
	SELECT system_action_id, system_action_name, system_action_description
    FROM system_action 
    ORDER BY system_action_id;
END$$

DROP PROCEDURE IF EXISTS `generateUploadSettingFileExtensionTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateUploadSettingFileExtensionTable` (IN `p_upload_setting_id` INT)   BEGIN
    SELECT upload_setting_file_extension_id, file_extension_name, file_extension 
    FROM upload_setting_file_extension 
    WHERE upload_setting_id = p_upload_setting_id
    ORDER BY file_extension_name;
END$$

DROP PROCEDURE IF EXISTS `generateUploadSettingTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateUploadSettingTable` ()   BEGIN
    SELECT upload_setting_id, upload_setting_name, upload_setting_description, max_file_size 
    FROM upload_setting
    ORDER BY upload_setting_name;
END$$

DROP PROCEDURE IF EXISTS `generateUserAccountRoleDualListBoxOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateUserAccountRoleDualListBoxOptions` (IN `p_user_account_id` INT)   BEGIN
	SELECT role_id, role_name 
    FROM role 
    WHERE role_id NOT IN (SELECT role_id FROM role_user_account WHERE user_account_id = p_user_account_id)
    ORDER BY role_name;
END$$

DROP PROCEDURE IF EXISTS `generateUserAccountRoleList`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateUserAccountRoleList` (IN `p_user_account_id` INT)   BEGIN
	SELECT role_user_account_id, role_name, date_assigned
    FROM role_user_account
    WHERE user_account_id = p_user_account_id
    ORDER BY role_name;
END$$

DROP PROCEDURE IF EXISTS `generateUserAccountTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateUserAccountTable` (IN `p_filter_by_user_account_status` VARCHAR(10), IN `p_filter_by_user_account_lock_status` VARCHAR(10), IN `p_filter_password_expiry_start_date` DATE, IN `p_filter_password_expiry_end_date` DATE, IN `p_filter_last_connection_start_date` DATE, IN `p_filter_last_connection_end_date` DATE)   BEGIN
    DECLARE query VARCHAR(5000);

    SET query = CONCAT('
        SELECT * 
        FROM user_account 
        WHERE 1');

    IF p_filter_by_user_account_status IS NOT NULL AND p_filter_by_user_account_status != '' THEN
        SET query = CONCAT(query, ' AND active = ', QUOTE(p_filter_by_user_account_status));
    END IF;

    IF p_filter_by_user_account_lock_status IS NOT NULL AND p_filter_by_user_account_lock_status != '' THEN
        SET query = CONCAT(query, ' AND locked = ', QUOTE(p_filter_by_user_account_lock_status));
    END IF;

    IF p_filter_password_expiry_start_date IS NOT NULL AND p_filter_password_expiry_end_date IS NOT NULL THEN
        SET query = CONCAT(query, ' AND password_expiry_date BETWEEN ', QUOTE(p_filter_password_expiry_start_date), ' AND ', QUOTE(p_filter_password_expiry_end_date));
    END IF;

    IF p_filter_last_connection_start_date IS NOT NULL AND p_filter_last_connection_end_date IS NOT NULL THEN
        SET query = CONCAT(query, ' AND DATE(last_connection_date) BETWEEN ', QUOTE(p_filter_last_connection_start_date), ' AND ', QUOTE(p_filter_last_connection_end_date));
    END IF;

    SET query = CONCAT(query, ' ORDER BY file_as');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS `getAppModule`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAppModule` (IN `p_app_module_id` INT)   BEGIN
	SELECT * FROM app_module
	WHERE app_module_id = p_app_module_id;
END$$

DROP PROCEDURE IF EXISTS `getCity`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCity` (IN `p_city_id` INT)   BEGIN
	SELECT * FROM city
	WHERE city_id = p_city_id;
END$$

DROP PROCEDURE IF EXISTS `getCompany`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCompany` (IN `p_company_id` INT)   BEGIN
	SELECT * FROM company
	WHERE company_id = p_company_id;
END$$

DROP PROCEDURE IF EXISTS `getCountry`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCountry` (IN `p_country_id` INT)   BEGIN
	SELECT * FROM country
	WHERE country_id = p_country_id;
END$$

DROP PROCEDURE IF EXISTS `getCurrency`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCurrency` (IN `p_currency_id` INT)   BEGIN
	SELECT * FROM currency
	WHERE currency_id = p_currency_id;
END$$

DROP PROCEDURE IF EXISTS `getEmailNotificationTemplate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getEmailNotificationTemplate` (IN `p_notification_setting_id` INT)   BEGIN
	SELECT * FROM notification_setting_email_template
	WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `getEmailSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getEmailSetting` (IN `p_email_setting_id` INT)   BEGIN
	SELECT * FROM email_setting
    WHERE email_setting_id = p_email_setting_id;
END$$

DROP PROCEDURE IF EXISTS `getFileExtension`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getFileExtension` (IN `p_file_extension_id` INT)   BEGIN
	SELECT * FROM file_extension
	WHERE file_extension_id = p_file_extension_id;
END$$

DROP PROCEDURE IF EXISTS `getFileType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getFileType` (IN `p_file_type_id` INT)   BEGIN
	SELECT * FROM file_type
	WHERE file_type_id = p_file_type_id;
END$$

DROP PROCEDURE IF EXISTS `getInternalNotesAttachment`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getInternalNotesAttachment` (IN `p_internal_notes_id` INT)   BEGIN
	SELECT * FROM internal_notes_attachment
	WHERE internal_notes_id = p_internal_notes_id;
END$$

DROP PROCEDURE IF EXISTS `getLoginCredentials`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getLoginCredentials` (IN `p_user_account_id` INT, IN `p_email` VARCHAR(255))   BEGIN
	SELECT * FROM user_account
    WHERE user_account_id = p_user_account_id OR email = p_email;
END$$

DROP PROCEDURE IF EXISTS `getMenuGroup`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getMenuGroup` (IN `p_menu_group_id` INT)   BEGIN
	SELECT * FROM menu_group
	WHERE menu_group_id = p_menu_group_id;
END$$

DROP PROCEDURE IF EXISTS `getMenuItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getMenuItem` (IN `p_menu_item_id` INT)   BEGIN
	SELECT * FROM menu_item
	WHERE menu_item_id = p_menu_item_id;
END$$

DROP PROCEDURE IF EXISTS `getNotificationSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getNotificationSetting` (IN `p_notification_setting_id` INT)   BEGIN
	SELECT * FROM notification_setting
	WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `getPasswordHistory`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getPasswordHistory` (IN `p_user_account_id` INT, IN `p_email` VARCHAR(255))   BEGIN
	SELECT * FROM password_history
	WHERE user_account_id = p_user_account_id OR email = BINARY p_email;
END$$

DROP PROCEDURE IF EXISTS `getRole`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getRole` (IN `p_role_id` INT)   BEGIN
	SELECT * FROM role
    WHERE role_id = p_role_id;
END$$

DROP PROCEDURE IF EXISTS `getSecuritySetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getSecuritySetting` (IN `p_security_setting_id` INT)   BEGIN
	SELECT * FROM security_setting
	WHERE security_setting_id = p_security_setting_id;
END$$

DROP PROCEDURE IF EXISTS `getSMSNotificationTemplate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getSMSNotificationTemplate` (IN `p_notification_setting_id` INT)   BEGIN
	SELECT * FROM notification_setting_sms_template
	WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `getState`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getState` (IN `p_state_id` INT)   BEGIN
	SELECT * FROM state
	WHERE state_id = p_state_id;
END$$

DROP PROCEDURE IF EXISTS `getSystemAction`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getSystemAction` (IN `p_system_action_id` INT)   BEGIN
	SELECT * FROM system_action
    WHERE system_action_id = p_system_action_id;
END$$

DROP PROCEDURE IF EXISTS `getSystemNotificationTemplate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getSystemNotificationTemplate` (IN `p_notification_setting_id` INT)   BEGIN
	SELECT * FROM notification_setting_system_template
	WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `getUploadSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getUploadSetting` (IN `p_upload_setting_id` INT)   BEGIN
	SELECT * FROM upload_setting
	WHERE upload_setting_id = p_upload_setting_id;
END$$

DROP PROCEDURE IF EXISTS `getUploadSettingFileExtension`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getUploadSettingFileExtension` (IN `p_upload_setting_id` INT)   BEGIN
	SELECT * FROM upload_setting_file_extension
	WHERE upload_setting_id = p_upload_setting_id;
END$$

DROP PROCEDURE IF EXISTS `getUserAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getUserAccount` (IN `p_user_account_id` INT, IN `p_email` VARCHAR(255))   BEGIN
	SELECT * FROM user_account
    WHERE user_account_id = p_user_account_id OR email = p_email;
END$$

DROP PROCEDURE IF EXISTS `insertAppModule`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertAppModule` (IN `p_app_module_name` VARCHAR(100), IN `p_app_module_description` VARCHAR(500), IN `p_menu_item_id` INT, IN `p_menu_item_name` VARCHAR(100), IN `p_order_sequence` TINYINT(10), IN `p_last_log_by` INT, OUT `p_app_module_id` INT)   BEGIN
    INSERT INTO app_module (app_module_name, app_module_description, menu_item_id, menu_item_name, order_sequence, last_log_by) 
	VALUES(p_app_module_name, p_app_module_description, p_menu_item_id, p_menu_item_name, p_order_sequence, p_last_log_by);
	
    SET p_app_module_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertCity`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertCity` (IN `p_city_name` VARCHAR(100), IN `p_state_id` INT, IN `p_state_name` VARCHAR(100), IN `p_country_id` INT, IN `p_country_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_city_id` INT)   BEGIN
    INSERT INTO city (city_name, state_id, state_name, country_id, country_name, last_log_by) 
	VALUES(p_city_name, p_state_id, p_state_name, p_country_id, p_country_name, p_last_log_by);
	
    SET p_city_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertCompany`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertCompany` (IN `p_company_name` VARCHAR(100), IN `p_legal_name` VARCHAR(100), IN `p_address` VARCHAR(500), IN `p_city_id` INT, IN `p_city_name` VARCHAR(100), IN `p_state_id` INT, IN `p_state_name` VARCHAR(100), IN `p_country_id` INT, IN `p_country_name` VARCHAR(100), IN `p_currency_id` INT, IN `p_currency_name` VARCHAR(500), IN `p_currency_symbol` VARCHAR(10), IN `p_tax_id` VARCHAR(50), IN `p_phone` VARCHAR(50), IN `p_mobile` VARCHAR(50), IN `p_email` VARCHAR(500), IN `p_website` VARCHAR(500), IN `p_last_log_by` INT, OUT `p_company_id` INT)   BEGIN
    INSERT INTO company (company_name, legal_name, address, city_id, city_name, state_id, state_name, country_id, country_name, currency_id, currency_name, currency_symbol, tax_id, phone, mobile, email, website, last_log_by) 
	VALUES(p_company_name, p_legal_name, p_address, p_city_id, p_city_name, p_state_id, p_state_name, p_country_id, p_country_name, p_currency_id, p_currency_name, p_currency_symbol, p_tax_id, p_phone, p_mobile, p_email, p_website, p_last_log_by);
	
    SET p_company_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertCountry`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertCountry` (IN `p_country_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_country_id` INT)   BEGIN
    INSERT INTO country (country_name, last_log_by) 
	VALUES(p_country_name, p_last_log_by);
	
    SET p_country_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertCurrency`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertCurrency` (IN `p_currency_name` VARCHAR(100), IN `p_currency_symbol` VARCHAR(10), IN `p_last_log_by` INT, OUT `p_currency_id` INT)   BEGIN
    INSERT INTO currency (currency_name, currency_symbol, last_log_by) 
	VALUES(p_currency_name, p_currency_symbol, p_last_log_by);
	
    SET p_currency_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertEmailNotificationTemplate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertEmailNotificationTemplate` (IN `p_notification_setting_id` INT, IN `p_email_notification_subject` VARCHAR(200), IN `p_email_notification_body` LONGTEXT, IN `p_last_log_by` INT)   BEGIN
    INSERT INTO notification_setting_email_template (notification_setting_id, email_notification_subject, email_notification_body, last_log_by) 
	VALUES(p_notification_setting_id, p_email_notification_subject, p_email_notification_body, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertEmailSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertEmailSetting` (IN `p_email_setting_name` VARCHAR(100), IN `p_email_setting_description` VARCHAR(200), IN `p_mail_host` VARCHAR(100), IN `p_port` VARCHAR(10), IN `p_smtp_auth` INT(1), IN `p_smtp_auto_tls` INT(1), IN `p_mail_username` VARCHAR(200), IN `p_mail_password` VARCHAR(250), IN `p_mail_encryption` VARCHAR(20), IN `p_mail_from_name` VARCHAR(200), IN `p_mail_from_email` VARCHAR(200), IN `p_last_log_by` INT, OUT `p_email_setting_id` INT)   BEGIN
    INSERT INTO email_setting (email_setting_name, email_setting_description, mail_host, port, smtp_auth, smtp_auto_tls, mail_username, mail_password, mail_encryption, mail_from_name, mail_from_email, last_log_by) 
	VALUES(p_email_setting_name, p_email_setting_description, p_mail_host, p_port, p_smtp_auth, p_smtp_auto_tls, p_mail_username, p_mail_password, p_mail_encryption, p_mail_from_name, p_mail_from_email, p_last_log_by);
	
    SET p_email_setting_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertFileExtension`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertFileExtension` (IN `p_file_extension_name` VARCHAR(100), IN `p_file_extension` VARCHAR(10), IN `p_file_type_id` INT, IN `p_file_type_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_file_extension_id` INT)   BEGIN
    INSERT INTO file_extension (file_extension_name, file_extension, file_type_id, file_type_name, last_log_by) 
	VALUES(p_file_extension_name, p_file_extension, p_file_type_id, p_file_type_name, p_last_log_by);
	
    SET p_file_extension_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertFileType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertFileType` (IN `p_file_type_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_file_type_id` INT)   BEGIN
    INSERT INTO file_type (file_type_name, last_log_by) 
	VALUES(p_file_type_name, p_last_log_by);
	
    SET p_file_type_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertInternalNotes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertInternalNotes` (IN `p_table_name` VARCHAR(255), IN `p_reference_id` INT, IN `p_internal_note` VARCHAR(5000), IN `p_internal_note_by` INT, OUT `p_internal_notes_id` INT)   BEGIN
    INSERT INTO internal_notes (table_name, reference_id, internal_note, internal_note_by) 
	VALUES(p_table_name, p_reference_id, p_internal_note, p_internal_note_by);

    SET p_internal_notes_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertInternalNotesAttachment`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertInternalNotesAttachment` (IN `p_internal_notes_id` INT, IN `p_attachment_file_name` VARCHAR(500), IN `p_attachment_file_size` DOUBLE, IN `p_attachment_path_file` VARCHAR(500))   BEGIN
    INSERT INTO internal_notes_attachment (internal_notes_id, attachment_file_name, attachment_file_size, attachment_path_file) 
	VALUES(p_internal_notes_id, p_attachment_file_name, p_attachment_file_size, p_attachment_path_file);
END$$

DROP PROCEDURE IF EXISTS `insertMenuGroup`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertMenuGroup` (IN `p_menu_group_name` VARCHAR(100), IN `p_app_module_id` INT, IN `p_app_module_name` VARCHAR(100), IN `p_order_sequence` TINYINT(10), IN `p_last_log_by` INT, OUT `p_menu_group_id` INT)   BEGIN
    INSERT INTO menu_group (menu_group_name, app_module_id, app_module_name, order_sequence, last_log_by) 
	VALUES(p_menu_group_name, p_app_module_id, p_app_module_name, p_order_sequence, p_last_log_by);
	
    SET p_menu_group_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertMenuItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertMenuItem` (IN `p_menu_item_name` VARCHAR(100), IN `p_menu_item_url` VARCHAR(50), IN `p_menu_item_icon` VARCHAR(50), IN `p_menu_group_id` INT, IN `p_menu_group_name` VARCHAR(100), IN `p_app_module_id` INT, IN `p_app_module_name` VARCHAR(100), IN `p_parent_id` INT, IN `p_parent_name` VARCHAR(100), IN `p_order_sequence` TINYINT(10), IN `p_last_log_by` INT, OUT `p_menu_item_id` INT)   BEGIN
    INSERT INTO menu_item (menu_item_name, menu_item_url, menu_item_icon, menu_group_id, menu_group_name, app_module_id, app_module_name, parent_id, parent_name, order_sequence, last_log_by) 
	VALUES(p_menu_item_name, p_menu_item_url, p_menu_item_icon, p_menu_group_id, p_menu_group_name, p_app_module_id, p_app_module_name, p_parent_id, p_parent_name, p_order_sequence, p_last_log_by);
	
    SET p_menu_item_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertNotificationSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertNotificationSetting` (IN `p_notification_setting_name` VARCHAR(100), IN `p_notification_setting_description` VARCHAR(200), IN `p_last_log_by` INT, OUT `p_notification_setting_id` INT)   BEGIN
    INSERT INTO notification_setting (notification_setting_name, notification_setting_description, last_log_by) 
	VALUES(p_notification_setting_name, p_notification_setting_description, p_last_log_by);
	
    SET p_notification_setting_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertPasswordHistory`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertPasswordHistory` (IN `p_user_account_id` INT, IN `p_email` VARCHAR(255), IN `p_password` VARCHAR(255))   BEGIN
    INSERT INTO password_history (user_account_id, email, password, password_change_date) 
    VALUES (p_user_account_id, p_email, p_password, NOW());
END$$

DROP PROCEDURE IF EXISTS `insertRole`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertRole` (IN `p_role_name` VARCHAR(100), IN `p_role_description` VARCHAR(200), IN `p_last_log_by` INT, OUT `p_role_id` INT)   BEGIN
    INSERT INTO role (role_name, role_description, last_log_by) 
	VALUES(p_role_name, p_role_description, p_last_log_by);
	
    SET p_role_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertRolePermission`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertRolePermission` (IN `p_role_id` INT, IN `p_role_name` VARCHAR(100), IN `p_menu_item_id` INT, IN `p_menu_item_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    INSERT INTO role_permission (role_id, role_name, menu_item_id, menu_item_name, last_log_by) 
	VALUES(p_role_id, p_role_name, p_menu_item_id, p_menu_item_name, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertRoleSystemActionPermission`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertRoleSystemActionPermission` (IN `p_role_id` INT, IN `p_role_name` VARCHAR(100), IN `p_system_action_id` INT, IN `p_system_action_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    INSERT INTO role_system_action_permission (role_id, role_name, system_action_id, system_action_name, last_log_by) 
	VALUES(p_role_id, p_role_name, p_system_action_id, p_system_action_name, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertRoleUserAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertRoleUserAccount` (IN `p_role_id` INT, IN `p_role_name` VARCHAR(100), IN `p_user_account_id` INT, IN `p_file_as` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    INSERT INTO role_user_account (role_id, role_name, user_account_id, file_as, last_log_by) 
	VALUES(p_role_id, p_role_name, p_user_account_id, p_file_as, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertSMSNotificationTemplate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertSMSNotificationTemplate` (IN `p_notification_setting_id` INT, IN `p_sms_notification_message` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    INSERT INTO notification_setting_sms_template (notification_setting_id, sms_notification_message, last_log_by) 
	VALUES(p_notification_setting_id, p_sms_notification_message, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertState`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertState` (IN `p_state_name` VARCHAR(100), IN `p_country_id` INT, IN `p_country_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_state_id` INT)   BEGIN
    INSERT INTO state (state_name, country_id, country_name, last_log_by) 
	VALUES(p_state_name, p_country_id, p_country_name, p_last_log_by);
	
    SET p_state_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertSystemAction`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertSystemAction` (IN `p_system_action_name` VARCHAR(100), IN `p_system_action_description` VARCHAR(200), IN `p_last_log_by` INT, OUT `p_system_action_id` INT)   BEGIN
    INSERT INTO system_action (system_action_name, system_action_description, last_log_by) 
	VALUES(p_system_action_name, p_system_action_description, p_last_log_by);
	
    SET p_system_action_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertSystemNotificationTemplate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertSystemNotificationTemplate` (IN `p_notification_setting_id` INT, IN `p_system_notification_title` VARCHAR(200), IN `p_system_notification_message` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    INSERT INTO notification_setting_system_template (notification_setting_id, system_notification_title, system_notification_message, last_log_by) 
	VALUES(p_notification_setting_id, p_system_notification_title, p_system_notification_message, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertUploadSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertUploadSetting` (IN `p_upload_setting_name` VARCHAR(100), IN `p_upload_setting_description` VARCHAR(200), IN `p_max_file_size` DOUBLE, IN `p_last_log_by` INT, OUT `p_upload_setting_id` INT)   BEGIN
    INSERT INTO upload_setting (upload_setting_name, upload_setting_description, max_file_size, last_log_by) 
	VALUES(p_upload_setting_name, p_upload_setting_description, p_max_file_size, p_last_log_by);
	
    SET p_upload_setting_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertUploadSettingFileExtension`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertUploadSettingFileExtension` (IN `p_upload_setting_id` INT, IN `p_upload_setting_name` VARCHAR(100), IN `p_file_extension_id` INT, IN `p_file_extension_name` VARCHAR(100), IN `p_file_extension` VARCHAR(10), IN `p_last_log_by` INT)   BEGIN
    INSERT INTO upload_setting_file_extension (upload_setting_id, upload_setting_name, file_extension_id, file_extension_name, file_extension, last_log_by) 
	VALUES(p_upload_setting_id, p_upload_setting_name, p_file_extension_id, p_file_extension_name, p_file_extension, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertUserAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertUserAccount` (IN `p_file_as` VARCHAR(300), IN `p_email` VARCHAR(255), IN `p_password` VARCHAR(255), IN `p_password_expiry_date` DATE, IN `p_last_password_change` DATETIME, IN `p_last_log_by` INT, OUT `p_user_account_id` INT)   BEGIN
    INSERT INTO user_account (file_as, email, password, password_expiry_date, last_password_change, last_log_by) 
	VALUES(p_file_as, p_email, p_password, p_password_expiry_date, p_last_password_change, p_last_log_by);
	
    SET p_user_account_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `updateAccountLock`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateAccountLock` (IN `p_user_account_id` INT, IN `p_locked` VARCHAR(5), IN `p_account_lock_duration` INT)   BEGIN
	UPDATE user_account 
    SET locked = p_locked, account_lock_duration = p_account_lock_duration 
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateAppLogo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateAppLogo` (IN `p_app_module_id` INT, IN `p_app_logo` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    UPDATE app_module
    SET app_logo = p_app_logo,
        last_log_by = p_last_log_by
    WHERE app_module_id = p_app_module_id;
END$$

DROP PROCEDURE IF EXISTS `updateAppModule`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateAppModule` (IN `p_app_module_id` INT, IN `p_app_module_name` VARCHAR(100), IN `p_app_module_description` VARCHAR(500), IN `p_menu_item_id` INT, IN `p_menu_item_name` VARCHAR(100), IN `p_order_sequence` TINYINT(10), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE menu_group
    SET app_module_name = p_app_module_name,
        last_log_by = p_last_log_by
    WHERE app_module_id = p_app_module_id;

    UPDATE menu_item
    SET app_module_name = p_app_module_name,
        last_log_by = p_last_log_by
    WHERE app_module_id = p_app_module_id;

    UPDATE app_module
    SET app_module_name = p_app_module_name,
        app_module_description = p_app_module_description,
        menu_item_id = p_menu_item_id,
        menu_item_name = p_menu_item_name,
        order_sequence = p_order_sequence,
        last_log_by = p_last_log_by
    WHERE app_module_id = p_app_module_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateCity`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCity` (IN `p_city_id` INT, IN `p_city_name` VARCHAR(100), IN `p_state_id` INT, IN `p_state_name` VARCHAR(100), IN `p_country_id` INT, IN `p_country_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE company
    SET city_name = p_city_name,
        state_id = p_state_id,
        state_name = p_state_name,
        country_id = p_country_id,
        country_name = p_country_name,
        last_log_by = p_last_log_by
    WHERE city_id = p_city_id;

    UPDATE city
    SET city_name = p_city_name,
        state_id = p_state_id,
        state_name = p_state_name,
        country_id = p_country_id,
        country_name = p_country_name,
        last_log_by = p_last_log_by
    WHERE city_id = p_city_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateCompany`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCompany` (IN `p_company_id` INT, IN `p_company_name` VARCHAR(100), IN `p_legal_name` VARCHAR(100), IN `p_address` VARCHAR(500), IN `p_city_id` INT, IN `p_city_name` VARCHAR(100), IN `p_state_id` INT, IN `p_state_name` VARCHAR(100), IN `p_country_id` INT, IN `p_country_name` VARCHAR(100), IN `p_currency_id` INT, IN `p_currency_name` VARCHAR(500), IN `p_currency_symbol` VARCHAR(10), IN `p_tax_id` VARCHAR(50), IN `p_phone` VARCHAR(50), IN `p_mobile` VARCHAR(50), IN `p_email` VARCHAR(500), IN `p_website` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE company
    SET company_name = p_company_name,
        legal_name = p_legal_name,
        address = p_address,
        city_id = p_city_id,
        city_name = p_city_name,
        state_id = p_state_id,
        state_name = p_state_name,
        country_id = p_country_id,
        country_name = p_country_name,
        currency_id = p_currency_id,
        currency_name = p_currency_name,
        currency_symbol = p_currency_symbol,
        tax_id = p_tax_id,
        phone = p_phone,
        mobile = p_mobile,
        email = p_email,
        website = p_website,
        last_log_by = p_last_log_by
    WHERE company_id = p_company_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateCompanyLogo`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCompanyLogo` (IN `p_company_id` INT, IN `p_company_logo` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    UPDATE company
    SET company_logo = p_company_logo,
        last_log_by = p_last_log_by
    WHERE company_id = p_company_id;
END$$

DROP PROCEDURE IF EXISTS `updateCountry`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCountry` (IN `p_country_id` INT, IN `p_country_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE company
    SET country_name = p_country_name,
        last_log_by = p_last_log_by
    WHERE country_id = p_country_id;

    UPDATE city
    SET country_name = p_country_name,
        last_log_by = p_last_log_by
    WHERE country_id = p_country_id;

    UPDATE state
    SET country_name = p_country_name,
        last_log_by = p_last_log_by
    WHERE country_id = p_country_id;

    UPDATE country
    SET country_name = p_country_name,
        last_log_by = p_last_log_by
    WHERE country_id = p_country_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateCurrency`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCurrency` (IN `p_currency_id` INT, IN `p_currency_name` VARCHAR(100), IN `p_currency_symbol` VARCHAR(10), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE company
    SET currency_name = p_currency_name,
        currency_symbol = p_currency_symbol,
        last_log_by = p_last_log_by
    WHERE currency_id = p_currency_id;

    UPDATE currency
    SET currency_name = p_currency_name,
        currency_symbol = p_currency_symbol,
        last_log_by = p_last_log_by
    WHERE currency_id = p_currency_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateEmailNotificationChannelStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmailNotificationChannelStatus` (IN `p_notification_setting_id` INT, IN `p_email_notification` INT(1), IN `p_last_log_by` INT)   BEGIN
    UPDATE notification_setting
    SET email_notification = p_email_notification,
        last_log_by = p_last_log_by
    WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `updateEmailNotificationTemplate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmailNotificationTemplate` (IN `p_notification_setting_id` INT, IN `p_email_notification_subject` VARCHAR(200), IN `p_email_notification_body` LONGTEXT, IN `p_last_log_by` INT)   BEGIN
    UPDATE notification_setting_email_template
    SET email_notification_subject = p_email_notification_subject,
        email_notification_body = p_email_notification_body,
        last_log_by = p_last_log_by
    WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `updateEmailSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmailSetting` (IN `p_email_setting_id` INT, IN `p_email_setting_name` VARCHAR(100), IN `p_email_setting_description` VARCHAR(200), IN `p_mail_host` VARCHAR(100), IN `p_port` VARCHAR(10), IN `p_smtp_auth` INT(1), IN `p_smtp_auto_tls` INT(1), IN `p_mail_username` VARCHAR(200), IN `p_mail_password` VARCHAR(250), IN `p_mail_encryption` VARCHAR(20), IN `p_mail_from_name` VARCHAR(200), IN `p_mail_from_email` VARCHAR(200), IN `p_last_log_by` INT)   BEGIN
    UPDATE email_setting
    SET email_setting_name = p_email_setting_name,
        email_setting_description = p_email_setting_description,
        mail_host = p_mail_host,
        port = p_port,
        smtp_auth = p_smtp_auth,
        smtp_auto_tls = p_smtp_auto_tls,
        mail_username = p_mail_username,
        mail_password = p_mail_password,
        mail_encryption = p_mail_encryption,
        mail_from_name = p_mail_from_name,
        mail_from_email = p_mail_from_email,
        last_log_by = p_last_log_by
    WHERE email_setting_id = p_email_setting_id;
END$$

DROP PROCEDURE IF EXISTS `updateFailedOTPAttempts`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateFailedOTPAttempts` (IN `p_user_account_id` INT, IN `p_failed_otp_attempts` INT)   BEGIN
	UPDATE user_account 
    SET failed_otp_attempts = p_failed_otp_attempts
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateFileExtension`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateFileExtension` (IN `p_file_extension_id` INT, IN `p_file_extension_name` VARCHAR(100), IN `p_file_extension` VARCHAR(10), IN `p_file_type_id` INT, IN `p_file_type_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE upload_setting_file_extension
    SET file_extension_name = p_file_extension_name,
        file_extension = p_file_extension,
        last_log_by = p_last_log_by
    WHERE file_extension_id = p_file_extension_id;

    UPDATE file_extension
    SET file_extension_name = p_file_extension_name,
        file_extension = p_file_extension,
        file_type_id = p_file_type_id,
        file_type_name = p_file_type_name,
        last_log_by = p_last_log_by
    WHERE file_extension_id = p_file_extension_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateFileType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateFileType` (IN `p_file_type_id` INT, IN `p_file_type_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE file_extension
    SET file_type_name = p_file_type_name,
        last_log_by = p_last_log_by
    WHERE file_type_id = p_file_type_id;

    UPDATE file_type
    SET file_type_name = p_file_type_name,
        last_log_by = p_last_log_by
    WHERE file_type_id = p_file_type_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateLastConnection`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateLastConnection` (IN `p_user_account_id` INT, IN `p_session_token` VARCHAR(255), IN `p_last_connection_date` DATETIME)   BEGIN
	UPDATE user_account 
    SET session_token = p_session_token, last_connection_date = p_last_connection_date
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateLoginAttempt`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateLoginAttempt` (IN `p_user_account_id` INT, IN `p_failed_login_attempts` INT, IN `p_last_failed_login_attempt` DATETIME)   BEGIN
	UPDATE user_account 
    SET failed_login_attempts = p_failed_login_attempts, last_failed_login_attempt = p_last_failed_login_attempt
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateMenuGroup`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateMenuGroup` (IN `p_menu_group_id` INT, IN `p_menu_group_name` VARCHAR(100), IN `p_app_module_id` INT, IN `p_app_module_name` VARCHAR(100), IN `p_order_sequence` TINYINT(10), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE menu_item
    SET menu_group_name = p_menu_group_name,
        last_log_by = p_last_log_by
    WHERE menu_group_id = p_menu_group_id;

    UPDATE menu_group
    SET menu_group_name = p_menu_group_name,
        app_module_id = p_app_module_id,
        app_module_name = p_app_module_name,
        order_sequence = p_order_sequence,
        last_log_by = p_last_log_by
    WHERE menu_group_id = p_menu_group_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateMenuItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateMenuItem` (IN `p_menu_item_id` INT, IN `p_menu_item_name` VARCHAR(100), IN `p_menu_item_url` VARCHAR(50), IN `p_menu_item_icon` VARCHAR(50), IN `p_menu_group_id` INT, IN `p_menu_group_name` VARCHAR(100), IN `p_app_module_id` INT, IN `p_app_module_name` VARCHAR(100), IN `p_parent_id` INT, IN `p_parent_name` VARCHAR(100), IN `p_order_sequence` TINYINT(10), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE role_permission
    SET menu_item_name = p_menu_item_name,
        last_log_by = p_last_log_by
    WHERE menu_item_id = p_menu_item_id;

    UPDATE menu_item
    SET menu_item_name = p_menu_item_name,
        menu_item_url = p_menu_item_url,
        menu_item_icon = p_menu_item_icon,
        menu_group_id = p_menu_group_id,
        menu_group_name = p_menu_group_name,
        app_module_id = p_app_module_id,
        app_module_name = p_app_module_name,
        parent_id = p_parent_id,
        parent_name = p_parent_name,
        order_sequence = p_order_sequence,
        last_log_by = p_last_log_by
    WHERE menu_item_id = p_menu_item_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateMultipleLoginSessionsStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateMultipleLoginSessionsStatus` (IN `p_user_account_id` INT, IN `p_multiple_session` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE user_account
    SET multiple_session = p_multiple_session,
        last_log_by = p_last_log_by
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateNotificationSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateNotificationSetting` (IN `p_notification_setting_id` INT, IN `p_notification_setting_name` VARCHAR(100), IN `p_notification_setting_description` VARCHAR(200), IN `p_last_log_by` INT)   BEGIN
    UPDATE notification_setting
    SET notification_setting_name = p_notification_setting_name,
        notification_setting_description = p_notification_setting_description,
        last_log_by = p_last_log_by
    WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `updateOTP`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateOTP` (IN `p_user_account_id` INT, IN `p_otp` VARCHAR(255), IN `p_otp_expiry_date` DATETIME)   BEGIN
	UPDATE user_account 
    SET otp = p_otp, otp_expiry_date = p_otp_expiry_date, failed_otp_attempts = 0
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateOTPAsExpired`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateOTPAsExpired` (IN `p_user_account_id` INT, IN `p_otp_expiry_date` DATETIME)   BEGIN
	UPDATE user_account 
    SET otp_expiry_date = p_otp_expiry_date
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateResetToken`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateResetToken` (IN `p_user_account_id` INT, IN `p_reset_token` VARCHAR(255), IN `p_reset_token_expiry_date` DATETIME)   BEGIN
	UPDATE user_account 
    SET reset_token = p_reset_token, reset_token_expiry_date = p_reset_token_expiry_date
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateResetTokenAsExpired`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateResetTokenAsExpired` (IN `p_user_account_id` INT, IN `p_reset_token_expiry_date` DATETIME)   BEGIN
	UPDATE user_account 
    SET reset_token_expiry_date = p_reset_token_expiry_date
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateRole`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateRole` (IN `p_role_id` INT, IN `p_role_name` VARCHAR(100), IN `p_role_description` VARCHAR(200), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE role_permission
    SET role_name = p_role_name,
        last_log_by = p_last_log_by
    WHERE role_id = p_role_id;

    UPDATE role_system_action_permission
    SET role_name = p_role_name,
        last_log_by = p_last_log_by
    WHERE role_id = p_role_id;

    UPDATE role_user_account
    SET role_name = p_role_name,
        last_log_by = p_last_log_by
    WHERE role_id = p_role_id;

	UPDATE role
    SET role_name = p_role_name,
    role_name = p_role_name,
    role_description = p_role_description,
    last_log_by = p_last_log_by
    WHERE role_id = p_role_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateRolePermission`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateRolePermission` (IN `p_role_permission_id` INT, IN `p_access_type` VARCHAR(10), IN `p_access` TINYINT(1), IN `p_last_log_by` INT)   BEGIN
    IF p_access_type = 'read' THEN
        UPDATE role_permission
        SET read_access = p_access,
            last_log_by = p_last_log_by
        WHERE role_permission_id = p_role_permission_id;
    ELSEIF p_access_type = 'write' THEN
        UPDATE role_permission
        SET write_access = p_access,
            last_log_by = p_last_log_by
        WHERE role_permission_id = p_role_permission_id;
    ELSEIF p_access_type = 'create' THEN
        UPDATE role_permission
        SET create_access = p_access,
            last_log_by = p_last_log_by
        WHERE role_permission_id = p_role_permission_id;
    ELSE
        UPDATE role_permission
        SET delete_access = p_access,
            last_log_by = p_last_log_by
        WHERE role_permission_id = p_role_permission_id;
    END IF;
END$$

DROP PROCEDURE IF EXISTS `updateRoleSystemActionPermission`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateRoleSystemActionPermission` (IN `p_role_system_action_permission_id` INT, IN `p_system_action_access` TINYINT(1), IN `p_last_log_by` INT)   BEGIN
    UPDATE role_system_action_permission
    SET system_action_access = p_system_action_access,
        last_log_by = p_last_log_by
    WHERE role_system_action_permission_id = p_role_system_action_permission_id;
END$$

DROP PROCEDURE IF EXISTS `updateSecuritySetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSecuritySetting` (IN `p_max_failed_login` INT, IN `p_max_failed_otp_attempt` INT, IN `p_password_expiry_duration` INT, IN `p_otp_duration` INT, IN `p_reset_password_token_duration` INT, IN `p_session_inactivity_limit` INT, IN `p_password_recovery_link` VARCHAR(1000), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE security_setting
    SET value = p_max_failed_login,
        last_log_by = p_last_log_by
    WHERE security_setting_id = 1;

    UPDATE security_setting
    SET value = p_max_failed_otp_attempt,
        last_log_by = p_last_log_by
    WHERE security_setting_id = 2;

    UPDATE security_setting
    SET value = p_password_recovery_link,
        last_log_by = p_last_log_by
    WHERE security_setting_id = 3;

    UPDATE security_setting
    SET value = p_password_expiry_duration,
        last_log_by = p_last_log_by
    WHERE security_setting_id = 4;

    UPDATE security_setting
    SET value = p_session_inactivity_limit,
        last_log_by = p_last_log_by
    WHERE security_setting_id = 5;

    UPDATE security_setting
    SET value = p_otp_duration,
        last_log_by = p_last_log_by
    WHERE security_setting_id = 6;

    UPDATE security_setting
    SET value = p_reset_password_token_duration,
        last_log_by = p_last_log_by
    WHERE security_setting_id = 7;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateSMSNotificationChannelStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSMSNotificationChannelStatus` (IN `p_notification_setting_id` INT, IN `p_sms_notification` INT(1), IN `p_last_log_by` INT)   BEGIN
    UPDATE notification_setting
    SET sms_notification = p_sms_notification,
        last_log_by = p_last_log_by
    WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `updateSMSNotificationTemplate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSMSNotificationTemplate` (IN `p_notification_setting_id` INT, IN `p_sms_notification_message` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    UPDATE notification_setting_sms_template
    SET sms_notification_message = p_sms_notification_message,
        last_log_by = p_last_log_by
    WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `updateState`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateState` (IN `p_state_id` INT, IN `p_state_name` VARCHAR(100), IN `p_country_id` INT, IN `p_country_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE company
    SET state_name = p_state_name,
        country_id = p_country_id,
        country_name = p_country_name,
        last_log_by = p_last_log_by
    WHERE state_id = p_state_id;

    UPDATE city
    SET state_name = p_state_name,
        country_id = p_country_id,
        country_name = p_country_name,
        last_log_by = p_last_log_by
    WHERE state_id = p_state_id;

    UPDATE state
    SET state_name = p_state_name,
        country_id = p_country_id,
        country_name = p_country_name,
        last_log_by = p_last_log_by
    WHERE state_id = p_state_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateSystemAction`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSystemAction` (IN `p_system_action_id` INT, IN `p_system_action_name` VARCHAR(100), IN `p_system_action_description` VARCHAR(200), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE role_system_action_permission
    SET system_action_name = p_system_action_name,
        last_log_by = p_last_log_by
    WHERE system_action_id = p_system_action_id;

	UPDATE system_action
    SET system_action_name = p_system_action_name,
        system_action_description = p_system_action_description,
        last_log_by = p_last_log_by
    WHERE system_action_id = p_system_action_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateSystemNotificationChannelStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSystemNotificationChannelStatus` (IN `p_notification_setting_id` INT, IN `p_system_notification` INT(1), IN `p_last_log_by` INT)   BEGIN
    UPDATE notification_setting
    SET system_notification = p_system_notification,
        last_log_by = p_last_log_by
    WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `updateSystemNotificationTemplate`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSystemNotificationTemplate` (IN `p_notification_setting_id` INT, IN `p_system_notification_title` VARCHAR(200), IN `p_system_notification_message` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    UPDATE notification_setting_system_template
    SET system_notification_title = p_system_notification_title,
        system_notification_message = p_system_notification_message,
        last_log_by = p_last_log_by
    WHERE notification_setting_id = p_notification_setting_id;
END$$

DROP PROCEDURE IF EXISTS `updateTwoFactorAuthenticationStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateTwoFactorAuthenticationStatus` (IN `p_user_account_id` INT, IN `p_two_factor_auth` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE user_account
    SET two_factor_auth = p_two_factor_auth,
        last_log_by = p_last_log_by
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateUploadSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUploadSetting` (IN `p_upload_setting_id` INT, IN `p_upload_setting_name` VARCHAR(100), IN `p_upload_setting_description` VARCHAR(200), IN `p_max_file_size` DOUBLE, IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE upload_setting_file_extension
    SET upload_setting_name = p_upload_setting_name,
        last_log_by = p_last_log_by
    WHERE upload_setting_id = p_upload_setting_id;

    UPDATE upload_setting
    SET upload_setting_name = p_upload_setting_name,
        upload_setting_description = p_upload_setting_description,
        max_file_size = p_max_file_size,
        last_log_by = p_last_log_by
    WHERE upload_setting_id = p_upload_setting_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateUserAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUserAccount` (IN `p_user_account_id` INT, IN `p_file_as` VARCHAR(300), IN `p_email` VARCHAR(255), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE role_user_account
    SET file_as = p_file_as,
        last_log_by = p_last_log_by
    WHERE user_account_id = p_user_account_id;

    UPDATE user_account
    SET file_as = p_file_as,
        email = p_email,
        last_log_by = p_last_log_by
    WHERE user_account_id = p_user_account_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateUserAccountLock`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUserAccountLock` (IN `p_user_account_id` INT, IN `p_locked` VARCHAR(5), IN `p_account_lock_duration` INT, IN `p_last_log_by` INT)   BEGIN
	UPDATE user_account 
    SET locked = p_locked, account_lock_duration = p_account_lock_duration 
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateUserAccountPassword`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUserAccountPassword` (IN `p_user_account_id` INT, IN `p_password` VARCHAR(255), IN `p_password_expiry_date` DATE, IN `p_last_log_by` INT)   BEGIN
	UPDATE user_account 
    SET password = p_password, 
        password_expiry_date = p_password_expiry_date, 
        last_password_change = NOW(), 
        last_log_by = p_last_log_by
    WHERE p_user_account_id = user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateUserAccountProfilePicture`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUserAccountProfilePicture` (IN `p_user_account_id` INT, IN `p_profile_picture` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    UPDATE user_account
    SET profile_picture = p_profile_picture,
        last_log_by = p_last_log_by
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateUserAccountStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUserAccountStatus` (IN `p_user_account_id` INT, IN `p_active` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE user_account
    SET active = p_active,
        last_log_by = p_last_log_by
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateUserPassword`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUserPassword` (IN `p_user_account_id` INT, IN `p_email` VARCHAR(255), IN `p_password` VARCHAR(255), IN `p_password_expiry_date` DATE)   BEGIN
	UPDATE user_account 
    SET password = p_password, 
        password_expiry_date = p_password_expiry_date, 
        last_password_change = NOW(), 
        locked = 'No',
        failed_login_attempts = 0, 
        account_lock_duration = 0,
        last_log_by = p_user_account_id
    WHERE p_user_account_id = user_account_id OR email = BINARY p_email;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `app_module`
--

DROP TABLE IF EXISTS `app_module`;
CREATE TABLE `app_module` (
  `app_module_id` int(10) UNSIGNED NOT NULL,
  `app_module_name` varchar(100) NOT NULL,
  `app_module_description` varchar(500) NOT NULL,
  `app_logo` varchar(500) DEFAULT NULL,
  `app_version` varchar(50) NOT NULL DEFAULT '1.0.0',
  `menu_item_id` int(10) UNSIGNED NOT NULL,
  `menu_item_name` varchar(100) NOT NULL,
  `order_sequence` tinyint(10) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `app_module`
--

INSERT INTO `app_module` (`app_module_id`, `app_module_name`, `app_module_description`, `app_logo`, `app_version`, `menu_item_id`, `menu_item_name`, `order_sequence`, `created_date`, `last_log_by`) VALUES
(1, 'Settings', 'Centralized management hub for comprehensive organizational oversight and control.', './components/app-module/image/logo/1/setting.png', '1.0.0', 1, 'General Settings', 101, '2024-06-15 18:11:25', 2);

--
-- Triggers `app_module`
--
DROP TRIGGER IF EXISTS `app_module_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `app_module_trigger_insert` AFTER INSERT ON `app_module` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'App module created. <br/>';

    IF NEW.app_module_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>App Module Name: ", NEW.app_module_name);
    END IF;

    IF NEW.app_module_description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>App Module Description: ", NEW.app_module_description);
    END IF;

    IF NEW.app_version <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>App Version: ", NEW.app_version);
    END IF;

    IF NEW.menu_item_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Menu Item Name: ", NEW.menu_item_name);
    END IF;

    IF NEW.order_sequence <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Order Sequence: ", NEW.order_sequence);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('app_module', NEW.app_module_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `app_module_trigger_update`;
DELIMITER $$
CREATE TRIGGER `app_module_trigger_update` AFTER UPDATE ON `app_module` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.app_module_name <> OLD.app_module_name THEN
        SET audit_log = CONCAT(audit_log, "App Module Name: ", OLD.app_module_name, " -> ", NEW.app_module_name, "<br/>");
    END IF;

    IF NEW.app_module_description <> OLD.app_module_description THEN
        SET audit_log = CONCAT(audit_log, "App Module Description: ", OLD.app_module_description, " -> ", NEW.app_module_description, "<br/>");
    END IF;

    IF NEW.app_version <> OLD.app_version THEN
        SET audit_log = CONCAT(audit_log, "App Version: ", OLD.app_version, " -> ", NEW.app_version, "<br/>");
    END IF;

    IF NEW.menu_item_name <> OLD.menu_item_name THEN
        SET audit_log = CONCAT(audit_log, "Menu Item Name: ", OLD.menu_item_name, " -> ", NEW.menu_item_name, "<br/>");
    END IF;

    IF NEW.order_sequence <> OLD.order_sequence THEN
        SET audit_log = CONCAT(audit_log, "Order Sequence: ", OLD.order_sequence, " -> ", NEW.order_sequence, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('app_module', NEW.app_module_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `audit_log`
--

DROP TABLE IF EXISTS `audit_log`;
CREATE TABLE `audit_log` (
  `audit_log_id` int(10) UNSIGNED NOT NULL,
  `table_name` varchar(255) NOT NULL,
  `reference_id` int(11) NOT NULL,
  `log` text NOT NULL,
  `changed_by` int(10) UNSIGNED NOT NULL,
  `changed_at` datetime NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audit_log`
--

INSERT INTO `audit_log` (`audit_log_id`, `table_name`, `reference_id`, `log`, `changed_by`, `changed_at`) VALUES
(1, 'user_account', 2, 'Last Connection Date: 2024-06-15 20:35:22 -> 2024-06-16 08:28:54<br/>', 1, '2024-06-16 08:28:54'),
(2, 'user_account', 2, 'Last Connection Date: 2024-06-16 08:28:54 -> 2024-06-16 15:14:41<br/>', 1, '2024-06-16 15:14:41'),
(3, 'user_account', 2, 'Failed Login Attempts: 0 -> 1<br/>', 1, '2024-06-16 21:25:39'),
(4, 'user_account', 2, 'Failed Login Attempts: 1 -> 0<br/>', 1, '2024-06-16 21:25:44'),
(5, 'user_account', 2, 'Last Connection Date: 2024-06-16 15:14:41 -> 2024-06-16 21:25:44<br/>', 1, '2024-06-16 21:25:44'),
(6, 'user_account', 2, 'Last Connection Date: 2024-06-16 21:25:44 -> 2024-06-17 21:00:05<br/>', 1, '2024-06-17 21:00:05'),
(7, 'user_account', 2, 'Last Connection Date: 2024-06-17 21:00:05 -> 2024-06-18 16:22:10<br/>', 1, '2024-06-18 16:22:10'),
(8, 'user_account', 2, 'Last Connection Date: 2024-06-18 16:22:10 -> 2024-06-18 16:49:43<br/>', 1, '2024-06-18 16:49:43'),
(9, 'security_setting', 5, 'Value: 240 -> 30<br/>', 2, '2024-06-18 16:53:48'),
(10, 'user_account', 2, 'Last Connection Date: 2024-06-18 16:49:43 -> 2024-06-19 16:56:51<br/>', 1, '2024-06-19 16:56:51'),
(11, 'user_account', 2, 'Last Connection Date: 2024-06-19 16:56:51 -> 2024-06-19 17:03:03<br/>', 1, '2024-06-19 17:03:03'),
(12, 'menu_item', 2, 'Menu Item created. <br/><br/>Menu Item Name: Users & Companies<br/>Menu Item Icon: ti ti-users<br/>Menu Group Name: Administration<br/>App Module: Settings<br/>Order Sequence: 1', 1, '2024-06-19 17:25:04'),
(13, 'role_permission', 2, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Users & Companies<br/>Read Access: 1<br/>Date Assigned: 2024-06-19 17:25:30', 1, '2024-06-19 17:25:30'),
(14, 'menu_item', 3, 'Menu Item created. <br/><br/>Menu Item Name: User Account<br/>Menu Item URL: user-account.php<br/>Menu Group Name: Administration<br/>App Module: Settings<br/>Parent: Users & Companies<br/>Order Sequence: 1', 1, '2024-06-19 17:30:37'),
(15, 'menu_item', 4, 'Menu Item created. <br/><br/>Menu Item Name: Company<br/>Menu Item URL: company.php<br/>Menu Group Name: Administration<br/>App Module: Settings<br/>Parent: Users & Companies<br/>Order Sequence: 1', 1, '2024-06-19 17:30:37'),
(16, 'role_permission', 3, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: User Account<br/>Read Access: 1<br/>Write Access: 1<br/>Create Access: 1<br/>Delete Access: 1<br/>Date Assigned: 2024-06-19 17:30:37', 1, '2024-06-19 17:30:37'),
(17, 'role_permission', 4, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Company<br/>Read Access: 1<br/>Write Access: 1<br/>Create Access: 1<br/>Delete Access: 1<br/>Date Assigned: 2024-06-19 17:30:37', 1, '2024-06-19 17:30:37'),
(18, 'user_account', 2, 'Last Connection Date: 2024-06-19 17:03:03 -> 2024-06-20 08:47:43<br/>', 1, '2024-06-20 08:47:43'),
(19, 'menu_item', 4, 'Order Sequence: 1 -> 2<br/>', 1, '2024-06-20 09:09:18'),
(20, 'menu_item', 4, 'Order Sequence: 2 -> 3<br/>', 1, '2024-06-20 09:09:25'),
(21, 'menu_item', 5, 'Menu Item created. <br/><br/>Menu Item Name: App Module<br/>Menu Item URL: app-module.php<br/>Menu Item Icon: ti ti-box<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Order Sequence: 1', 1, '2024-06-20 11:37:17'),
(22, 'role_permission', 5, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: App Module<br/>Read Access: 1<br/>Write Access: 1<br/>Create Access: 1<br/>Delete Access: 1<br/>Date Assigned: 2024-06-20 11:37:17', 1, '2024-06-20 11:37:17'),
(23, 'user_account', 2, 'Last Connection Date: 2024-06-20 08:47:43 -> 2024-06-21 08:36:23<br/>', 1, '2024-06-21 08:36:23'),
(24, 'app_module', 2, 'App module created. <br/><br/>App Module Name: test<br/>App Module Description: test<br/>App Version: 1.0.0<br/>Menu Item Name: App Module<br/>Order Sequence: 1', 2, '2024-06-21 09:54:29'),
(25, 'upload_setting', 2, 'Upload Setting created. <br/><br/>Upload Setting Name: Internal Notes Attachment<br/>Upload Setting Description: Sets the upload setting when uploading internal notes attachement.<br/>Max File Size: 800', 1, '2024-06-21 12:26:58'),
(26, 'upload_setting_file_extension', 4, 'Upload Setting File Extension created. <br/><br/>Upload Setting Name: Internal Notes Attachment<br/>File Extension Name: PNG<br/>File Extension: png<br/>Date Assigned: 2024-06-21 12:26:58', 1, '2024-06-21 12:26:58'),
(27, 'upload_setting_file_extension', 5, 'Upload Setting File Extension created. <br/><br/>Upload Setting Name: Internal Notes Attachment<br/>File Extension Name: JPG<br/>File Extension: jpg<br/>Date Assigned: 2024-06-21 12:26:58', 1, '2024-06-21 12:26:58'),
(28, 'upload_setting_file_extension', 6, 'Upload Setting File Extension created. <br/><br/>Upload Setting Name: Internal Notes Attachment<br/>File Extension Name: JPEG<br/>File Extension: jpeg<br/>Date Assigned: 2024-06-21 12:26:58', 1, '2024-06-21 12:26:58'),
(29, 'upload_setting_file_extension', 7, 'Upload Setting File Extension created. <br/><br/>Upload Setting Name: Internal Notes Attachment<br/>File Extension Name: PDF<br/>File Extension: pdf<br/>Date Assigned: 2024-06-21 12:26:58', 1, '2024-06-21 12:26:58'),
(30, 'app_module', 1, 'Order Sequence: 100 -> 1<br/>', 1, '2024-06-21 13:58:51'),
(31, 'app_module', 1, 'Order Sequence: 1 -> 100<br/>', 2, '2024-06-21 14:03:01'),
(32, 'app_module', 1, 'Order Sequence: 100 -> 1<br/>', 2, '2024-06-21 14:09:46'),
(33, 'app_module', 1, 'App Module Name: Settings -> Setting<br/>', 2, '2024-06-21 14:09:50'),
(41, 'app_module', 1, 'App Module Name: Setting -> Settings<br/>Order Sequence: 1 -> 100<br/>', 2, '2024-06-21 15:18:51'),
(42, 'app_module', 1, 'Order Sequence: 100 -> 102<br/>', 2, '2024-06-21 16:54:13'),
(43, 'app_module', 1, 'Order Sequence: 102 -> 101<br/>', 2, '2024-06-21 17:13:01'),
(44, 'app_module', 1, 'Order Sequence: 101 -> 100<br/>', 2, '2024-06-21 17:23:19'),
(45, 'user_account', 2, 'Last Connection Date: 2024-06-21 08:36:23 -> 2024-06-22 10:30:22<br/>', 1, '2024-06-22 10:30:22'),
(46, 'app_module', 1, 'Order Sequence: 100 -> 101<br/>', 2, '2024-06-22 10:45:49'),
(47, 'app_module', 1, 'App Module Description: Centralized management hub for comprehensive organizational oversight and control -> Centralized management hub for comprehensive organizational oversight and control.<br/>', 2, '2024-06-22 10:46:06'),
(48, 'user_account', 2, 'Last Connection Date: 2024-06-22 10:30:22 -> 2024-06-22 16:46:07<br/>', 1, '2024-06-22 16:46:07'),
(49, 'system_action', 1, 'System action created. <br/><br/>System Action Name: Update System Settings<br/>System Action Description: Access to update the system settings.', 1, '2024-06-22 17:54:16'),
(50, 'system_action', 2, 'System action created. <br/><br/>System Action Name: Update Security Settings<br/>System Action Description: Access to update the security settings.', 1, '2024-06-22 17:54:16'),
(51, 'system_action', 3, 'System action created. <br/><br/>System Action Name: Activate User Account<br/>System Action Description: Access to activate the user account.', 1, '2024-06-22 17:54:16'),
(52, 'system_action', 4, 'System action created. <br/><br/>System Action Name: Deactivate User Account<br/>System Action Description: Access to deactivate the user account.', 1, '2024-06-22 17:54:16'),
(53, 'system_action', 5, 'System action created. <br/><br/>System Action Name: Lock User Account<br/>System Action Description: Access to lock the user account.', 1, '2024-06-22 17:54:16'),
(54, 'system_action', 6, 'System action created. <br/><br/>System Action Name: Unlock User Account<br/>System Action Description: Access to unlock the user account.', 1, '2024-06-22 17:54:16'),
(55, 'system_action', 7, 'System action created. <br/><br/>System Action Name: Add Role User Account<br/>System Action Description: Access to assign roles to user account.', 1, '2024-06-22 17:54:16'),
(56, 'system_action', 8, 'System action created. <br/><br/>System Action Name: Delete Role User Account<br/>System Action Description: Access to delete roles to user account.', 1, '2024-06-22 17:54:16'),
(57, 'system_action', 9, 'System action created. <br/><br/>System Action Name: Add Role Access<br/>System Action Description: Access to add role access.', 1, '2024-06-22 17:54:16'),
(58, 'system_action', 10, 'System action created. <br/><br/>System Action Name: Update Role Access<br/>System Action Description: Access to update role access.', 1, '2024-06-22 17:54:16'),
(59, 'system_action', 11, 'System action created. <br/><br/>System Action Name: Delete Role Access<br/>System Action Description: Access to delete role access.', 1, '2024-06-22 17:54:16'),
(60, 'system_action', 12, 'System action created. <br/><br/>System Action Name: Add Role System Action Access<br/>System Action Description: Access to add the role system action access.', 1, '2024-06-22 17:54:16'),
(61, 'system_action', 13, 'System action created. <br/><br/>System Action Name: Update Role System Action Access<br/>System Action Description: Access to update the role system action access.', 1, '2024-06-22 17:54:16'),
(62, 'system_action', 14, 'System action created. <br/><br/>System Action Name: Delete Role System Action Access<br/>System Action Description: Access to delete the role system action access.', 1, '2024-06-22 17:54:16'),
(63, 'system_action', 15, 'System action created. <br/><br/>System Action Name: Add File Extension Access<br/>System Action Description: Access to assign the file extension to the upload setting.', 1, '2024-06-22 17:54:16'),
(64, 'system_action', 16, 'System action created. <br/><br/>System Action Name: Delete File Extension Access<br/>System Action Description: Access to delete the file extension to the upload setting.', 1, '2024-06-22 17:54:16'),
(65, 'role_system_action_permission', 1, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Update System Settings<br/>System Action Access: 1<br/>Date Assigned: 2024-06-22 17:54:16', 1, '2024-06-22 17:54:16'),
(66, 'role_system_action_permission', 2, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Update Security Settings<br/>System Action Access: 1<br/>Date Assigned: 2024-06-22 17:54:16', 1, '2024-06-22 17:54:16'),
(67, 'role_system_action_permission', 3, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Activate User Account<br/>System Action Access: 1<br/>Date Assigned: 2024-06-22 17:54:16', 1, '2024-06-22 17:54:16'),
(68, 'role_system_action_permission', 4, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Deactivate User Account<br/>System Action Access: 1<br/>Date Assigned: 2024-06-22 17:54:16', 1, '2024-06-22 17:54:16'),
(69, 'role_system_action_permission', 5, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Lock User Account<br/>System Action Access: 1<br/>Date Assigned: 2024-06-22 17:54:16', 1, '2024-06-22 17:54:16'),
(70, 'role_system_action_permission', 6, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Unlock User Account<br/>System Action Access: 1<br/>Date Assigned: 2024-06-22 17:54:16', 1, '2024-06-22 17:54:16'),
(71, 'role_system_action_permission', 7, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Add Role User Account<br/>System Action Access: 1<br/>Date Assigned: 2024-06-22 17:54:17', 1, '2024-06-22 17:54:17'),
(72, 'role_system_action_permission', 8, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Delete Role User Account<br/>System Action Access: 1<br/>Date Assigned: 2024-06-22 17:54:17', 1, '2024-06-22 17:54:17'),
(73, 'role_system_action_permission', 9, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Add Role Access<br/>System Action Access: 1<br/>Date Assigned: 2024-06-22 17:54:17', 1, '2024-06-22 17:54:17'),
(74, 'role_system_action_permission', 10, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Update Role Access<br/>System Action Access: 1<br/>Date Assigned: 2024-06-22 17:54:17', 1, '2024-06-22 17:54:17'),
(75, 'role_system_action_permission', 11, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Delete Role Access<br/>System Action Access: 1<br/>Date Assigned: 2024-06-22 17:54:17', 1, '2024-06-22 17:54:17'),
(76, 'role_system_action_permission', 12, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Add Role System Action Access<br/>System Action Access: 1<br/>Date Assigned: 2024-06-22 17:54:17', 1, '2024-06-22 17:54:17'),
(77, 'role_system_action_permission', 13, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Update Role System Action Access<br/>System Action Access: 1<br/>Date Assigned: 2024-06-22 17:54:17', 1, '2024-06-22 17:54:17'),
(78, 'role_system_action_permission', 14, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Delete Role System Action Access<br/>System Action Access: 1<br/>Date Assigned: 2024-06-22 17:54:17', 1, '2024-06-22 17:54:17'),
(79, 'role_system_action_permission', 15, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Add File Extension Access<br/>System Action Access: 1<br/>Date Assigned: 2024-06-22 17:54:17', 1, '2024-06-22 17:54:17'),
(80, 'role_system_action_permission', 16, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Delete File Extension Access<br/>System Action Access: 1<br/>Date Assigned: 2024-06-22 17:54:17', 1, '2024-06-22 17:54:17'),
(81, 'user_account', 2, 'Last Connection Date: 2024-06-22 16:46:07 -> 2024-06-23 16:00:39<br/>', 1, '2024-06-23 16:00:39'),
(82, 'user_account', 2, 'Multiple Session: Yes -> No<br/>', 2, '2024-06-24 17:05:14'),
(83, 'user_account', 2, 'Multiple Session: No -> Yes<br/>', 2, '2024-06-24 17:05:15'),
(84, 'user_account', 2, 'Two-Factor Authentication: No -> Yes<br/>', 2, '2024-06-24 17:15:00'),
(85, 'user_account', 2, 'Two-Factor Authentication: Yes -> No<br/>', 2, '2024-06-24 17:15:04'),
(86, 'user_account', 2, 'Last Connection Date: 2024-06-23 16:00:39 -> 2024-06-25 09:19:26<br/>', 2, '2024-06-25 09:19:26'),
(87, 'user_account', 2, 'Two-Factor Authentication: No -> Yes<br/>', 2, '2024-06-25 10:19:06'),
(88, 'user_account', 2, 'Two-Factor Authentication: Yes -> No<br/>', 2, '2024-06-25 10:19:07'),
(89, 'role_user_account', 2, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: Administrator<br/>Date Assigned: 2024-06-25 10:43:09', 1, '2024-06-25 10:43:09'),
(90, 'role_user_account', 3, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: Administrator<br/>Date Assigned: 2024-06-25 10:44:55', 1, '2024-06-25 10:44:55'),
(91, 'security_setting', 3, 'Value: http://localhost/modernize/password-reset.php?id= -> http://localhost/digify2/password-reset.php?id=<br/>', 2, '2024-06-25 11:29:02'),
(92, 'role_permission', 6, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: User Interface<br/>Read Access: 1<br/>Date Assigned: 2024-06-25 11:43:13', 1, '2024-06-25 11:43:13'),
(93, 'role_permission', 7, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Menu Group<br/>Read Access: 1<br/>Write Access: 1<br/>Create Access: 1<br/>Delete Access: 1<br/>Date Assigned: 2024-06-25 11:43:13', 1, '2024-06-25 11:43:13'),
(94, 'role_permission', 8, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Menu Item<br/>Read Access: 1<br/>Write Access: 1<br/>Create Access: 1<br/>Delete Access: 1<br/>Date Assigned: 2024-06-25 11:43:13', 1, '2024-06-25 11:43:13'),
(95, 'menu_group', 2, 'Order Sequence: 100 -> 99<br/>', 2, '2024-06-25 15:34:07'),
(96, 'role_permission', 5, 'Delete Access: 1 -> 0<br/>', 2, '2024-06-25 16:23:00'),
(97, 'role_permission', 5, 'Delete Access: 0 -> 1<br/>', 2, '2024-06-25 16:23:11'),
(98, 'role_permission', 9, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Role<br/>Date Assigned: 2024-06-25 16:51:10', 2, '2024-06-25 16:51:10'),
(99, 'role_permission', 9, 'Read Access: 0 -> 1<br/>', 2, '2024-06-25 16:51:11'),
(100, 'role_permission', 9, 'Create Access: 0 -> 1<br/>', 2, '2024-06-25 16:51:12'),
(101, 'role_permission', 9, 'Write Access: 0 -> 1<br/>', 2, '2024-06-25 16:51:12'),
(102, 'role_permission', 9, 'Delete Access: 0 -> 1<br/>', 2, '2024-06-25 16:51:13'),
(103, 'role_permission', 10, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: System Action<br/>Date Assigned: 2024-06-25 17:20:10', 2, '2024-06-25 17:20:10'),
(104, 'role_permission', 10, 'Read Access: 0 -> 1<br/>', 2, '2024-06-25 17:20:11'),
(105, 'role_permission', 10, 'Create Access: 0 -> 1<br/>', 2, '2024-06-25 17:20:12'),
(106, 'role_permission', 10, 'Write Access: 0 -> 1<br/>', 2, '2024-06-25 17:20:13'),
(107, 'role_permission', 10, 'Delete Access: 0 -> 1<br/>', 2, '2024-06-25 17:20:13'),
(108, 'role_system_action_permission', 3, 'System Action Access: 1 -> 0<br/>', 2, '2024-06-25 17:21:17'),
(109, 'role_system_action_permission', 3, 'System Action Access: 0 -> 1<br/>', 2, '2024-06-25 17:21:18'),
(110, 'role_system_action_permission', 3, 'System Action Access: 1 -> 0<br/>', 2, '2024-06-25 17:22:47'),
(111, 'role_system_action_permission', 3, 'System Action Access: 0 -> 1<br/>', 2, '2024-06-25 17:22:48'),
(112, 'role_system_action_permission', 3, 'System Action Access: 1 -> 0<br/>', 2, '2024-06-25 17:22:48'),
(113, 'role_system_action_permission', 3, 'System Action Access: 0 -> 1<br/>', 2, '2024-06-25 17:22:49'),
(114, 'role_system_action_permission', 3, 'System Action Access: 1 -> 0<br/>', 2, '2024-06-25 17:22:49'),
(115, 'role_system_action_permission', 3, 'System Action Access: 0 -> 1<br/>', 2, '2024-06-25 17:22:50'),
(116, 'role_permission', 11, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Configuration<br/>Date Assigned: 2024-06-25 17:25:37', 2, '2024-06-25 17:25:37'),
(117, 'role_permission', 11, 'Read Access: 0 -> 1<br/>', 2, '2024-06-25 17:25:38'),
(118, 'role_permission', 11, 'Menu Item: Configuration -> Configurations<br/>', 2, '2024-06-25 17:25:43'),
(119, 'role_permission', 11, 'Menu Item: Configurations -> Localization<br/>', 2, '2024-06-25 17:27:56'),
(120, 'role_permission', 12, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: State<br/>Date Assigned: 2024-06-25 17:28:49', 2, '2024-06-25 17:28:49'),
(121, 'role_permission', 12, 'Read Access: 0 -> 1<br/>', 2, '2024-06-25 17:28:50'),
(122, 'role_permission', 12, 'Create Access: 0 -> 1<br/>', 2, '2024-06-25 17:28:51'),
(123, 'role_permission', 12, 'Write Access: 0 -> 1<br/>', 2, '2024-06-25 17:28:52'),
(124, 'role_permission', 12, 'Delete Access: 0 -> 1<br/>', 2, '2024-06-25 17:28:53'),
(125, 'role_permission', 13, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Country<br/>Date Assigned: 2024-06-25 17:29:23', 2, '2024-06-25 17:29:23'),
(126, 'role_permission', 13, 'Read Access: 0 -> 1<br/>', 2, '2024-06-25 17:29:24'),
(127, 'role_permission', 13, 'Create Access: 0 -> 1<br/>', 2, '2024-06-25 17:29:25'),
(128, 'role_permission', 13, 'Write Access: 0 -> 1<br/>', 2, '2024-06-25 17:29:25'),
(129, 'role_permission', 13, 'Delete Access: 0 -> 1<br/>', 2, '2024-06-25 17:29:26'),
(130, 'role_permission', 14, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: City<br/>Date Assigned: 2024-06-25 17:30:03', 2, '2024-06-25 17:30:03'),
(131, 'role_permission', 14, 'Read Access: 0 -> 1<br/>', 2, '2024-06-25 17:30:04'),
(132, 'role_permission', 14, 'Create Access: 0 -> 1<br/>', 2, '2024-06-25 17:30:05'),
(133, 'role_permission', 14, 'Write Access: 0 -> 1<br/>', 2, '2024-06-25 17:30:06'),
(134, 'role_permission', 14, 'Delete Access: 0 -> 1<br/>', 2, '2024-06-25 17:30:07'),
(135, 'role_permission', 15, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Currency<br/>Date Assigned: 2024-06-25 17:31:09', 2, '2024-06-25 17:31:09'),
(136, 'role_permission', 15, 'Read Access: 0 -> 1<br/>', 2, '2024-06-25 17:31:10'),
(137, 'role_permission', 15, 'Create Access: 0 -> 1<br/>', 2, '2024-06-25 17:31:12'),
(138, 'role_permission', 15, 'Write Access: 0 -> 1<br/>', 2, '2024-06-25 17:31:12'),
(139, 'role_permission', 15, 'Delete Access: 0 -> 1<br/>', 2, '2024-06-25 17:31:13'),
(140, 'user_account', 2, 'Last Connection Date: 2024-06-25 09:19:26 -> 2024-06-25 19:30:44<br/>', 2, '2024-06-25 19:30:44'),
(141, 'currency', 1, 'Currency created. <br/><br/>Currency Name: PHP<br/>Currency Symbol: Php', 2, '2024-06-25 19:47:52'),
(142, 'currency', 1, 'Currency Name: PHP -> PHP2<br/>Currency Symbol: Php -> 2<br/>', 2, '2024-06-25 19:48:05'),
(143, 'currency', 2, 'Currency created. <br/><br/>Currency Name: PHP<br/>Currency Symbol: Php', 2, '2024-06-25 19:48:21'),
(144, 'country', 1, 'Country created. <br/><br/>Country Name: Philippines', 2, '2024-06-25 20:02:11'),
(145, 'country', 1, 'Country Name: Philippines -> Philippiness<br/>', 2, '2024-06-25 20:02:17'),
(146, 'country', 1, 'Country Name: Philippiness -> Philippines<br/>', 2, '2024-06-25 20:02:20'),
(147, 'state', 1, 'State created. <br/><br/>State Name: Nueva Ecija<br/>Country: Philippines', 2, '2024-06-25 20:02:49'),
(148, 'state', 1, 'State Name: Nueva Ecija -> Nueva Ecijas<br/>', 2, '2024-06-25 20:02:56'),
(149, 'state', 1, 'State Name: Nueva Ecijas -> Nueva Ecija<br/>', 2, '2024-06-25 20:03:00'),
(150, 'city', 1, 'City created. <br/><br/>City Name: Cabanatuan<br/>State: Nueva Ecija<br/>Country: Philippines', 2, '2024-06-25 20:03:37'),
(151, 'city', 1, 'City Name: Cabanatuan -> Cabanatuans<br/>', 2, '2024-06-25 20:04:07'),
(152, 'city', 1, 'City Name: Cabanatuans -> Cabanatuan<br/>', 2, '2024-06-25 20:04:12'),
(153, 'company', 1, 'Company created. <br/><br/>Company Name: asd<br/>Legal Name: asd<br/>Address: asdasd<br/>City: Cabanatuan<br/>State: Nueva Ecija<br/>Country: Philippines<br/>Currency: PHP<br/>Currency Symbol: Php', 2, '2024-06-25 20:10:14'),
(154, 'company', 1, 'Tax ID:  -> 112<br/>Phone:  -> 1212<br/>Mobile:  -> 1212<br/>Email:  -> a@gmail.com<br/>Website:  -> 121212<br/>', 2, '2024-06-25 20:27:04'),
(155, 'role_permission', 16, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: File Configuration<br/>Date Assigned: 2024-06-25 20:46:46', 2, '2024-06-25 20:46:46'),
(156, 'role_permission', 16, 'Read Access: 0 -> 1<br/>', 2, '2024-06-25 20:46:47'),
(157, 'role_permission', 17, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Upload Setting<br/>Date Assigned: 2024-06-25 20:48:37', 2, '2024-06-25 20:48:37'),
(158, 'role_permission', 17, 'Read Access: 0 -> 1<br/>', 2, '2024-06-25 20:48:38'),
(159, 'role_permission', 17, 'Create Access: 0 -> 1<br/>', 2, '2024-06-25 20:48:39'),
(160, 'role_permission', 17, 'Write Access: 0 -> 1<br/>', 2, '2024-06-25 20:48:41'),
(161, 'role_permission', 17, 'Delete Access: 0 -> 1<br/>', 2, '2024-06-25 20:48:42'),
(162, 'role_permission', 18, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: File Type<br/>Date Assigned: 2024-06-25 20:49:20', 2, '2024-06-25 20:49:20'),
(163, 'role_permission', 18, 'Read Access: 0 -> 1<br/>', 2, '2024-06-25 20:49:22'),
(164, 'role_permission', 18, 'Create Access: 0 -> 1<br/>', 2, '2024-06-25 20:49:23'),
(165, 'role_permission', 18, 'Write Access: 0 -> 1<br/>', 2, '2024-06-25 20:49:24'),
(166, 'role_permission', 18, 'Delete Access: 0 -> 1<br/>', 2, '2024-06-25 20:49:25'),
(167, 'role_permission', 19, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: File Extension<br/>Date Assigned: 2024-06-25 20:49:49', 2, '2024-06-25 20:49:49'),
(168, 'role_permission', 19, 'Read Access: 0 -> 1<br/>', 2, '2024-06-25 20:49:52'),
(169, 'role_permission', 19, 'Create Access: 0 -> 1<br/>', 2, '2024-06-25 20:49:53'),
(170, 'role_permission', 19, 'Delete Access: 0 -> 1<br/>', 2, '2024-06-25 20:49:55'),
(171, 'role_permission', 19, 'Write Access: 0 -> 1<br/>', 2, '2024-06-25 20:49:56'),
(172, 'upload_setting', 3, 'Upload Setting created. <br/><br/>Upload Setting Name: Company Logo<br/>Upload Setting Description: Sets the upload setting when uploading company logo.<br/>Max File Size: 800', 2, '2024-06-25 20:59:00'),
(173, 'upload_setting_file_extension', 8, 'Upload Setting File Extension created. <br/><br/>Upload Setting Name: Company Logo<br/>File Extension Name: JPEG<br/>File Extension: jpeg<br/>Date Assigned: 2024-06-25 20:59:13', 2, '2024-06-25 20:59:13'),
(174, 'upload_setting_file_extension', 9, 'Upload Setting File Extension created. <br/><br/>Upload Setting Name: Company Logo<br/>File Extension Name: JPG<br/>File Extension: jpg<br/>Date Assigned: 2024-06-25 20:59:13', 2, '2024-06-25 20:59:13'),
(175, 'upload_setting_file_extension', 10, 'Upload Setting File Extension created. <br/><br/>Upload Setting Name: Company Logo<br/>File Extension Name: PNG<br/>File Extension: png<br/>Date Assigned: 2024-06-25 20:59:13', 2, '2024-06-25 20:59:13'),
(176, 'file_extension', 5, 'File Extension created. <br/><br/>File Extension Name: DOCX<br/>File Extension: .docx<br/>File Type: Document', 2, '2024-06-25 21:05:38'),
(177, 'menu_item', 20, 'Menu Item created. <br/><br/>Menu Item Name: Email Setting<br/>Menu Item URL: email-setting.php<br/>Menu Item Icon: ti ti-mail-forward<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Order Sequence: 5', 2, '2024-06-25 21:16:26'),
(178, 'role_permission', 20, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Email Setting<br/>Date Assigned: 2024-06-25 21:16:34', 2, '2024-06-25 21:16:34'),
(179, 'role_permission', 20, 'Read Access: 0 -> 1<br/>', 2, '2024-06-25 21:16:36'),
(180, 'role_permission', 20, 'Create Access: 0 -> 1<br/>', 2, '2024-06-25 21:16:37'),
(181, 'role_permission', 20, 'Write Access: 0 -> 1<br/>', 2, '2024-06-25 21:16:38'),
(182, 'role_permission', 20, 'Delete Access: 0 -> 1<br/>', 2, '2024-06-25 21:16:40'),
(183, 'email_setting', 1, 'Email Setting Description: \r\nEmail setting for security emails. -> Email setting for security emails.<br/>', 2, '2024-06-25 21:29:12'),
(184, 'menu_item', 21, 'Menu Item created. <br/><br/>Menu Item Name: Notification Setting<br/>Menu Item URL: notification-setting.php<br/>Menu Item Icon: ti ti-bell<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Order Sequence: 14', 2, '2024-06-25 21:34:21'),
(185, 'role_permission', 21, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Notification Setting<br/>Date Assigned: 2024-06-25 21:34:30', 2, '2024-06-25 21:34:30'),
(186, 'role_permission', 21, 'Read Access: 0 -> 1<br/>', 2, '2024-06-25 21:34:32'),
(187, 'role_permission', 21, 'Create Access: 0 -> 1<br/>', 2, '2024-06-25 21:34:33'),
(188, 'role_permission', 21, 'Write Access: 0 -> 1<br/>', 2, '2024-06-25 21:34:34'),
(189, 'role_permission', 21, 'Delete Access: 0 -> 1<br/>', 2, '2024-06-25 21:34:35'),
(190, 'notification_setting', 1, 'Notification Setting created. <br/><br/>Notification Setting Name: Forgot Password<br/>Notification Setting Description: Notification setting for forgot password<br/>System Notification: 1', 2, '2024-06-25 21:36:35'),
(191, 'notification_setting_system_template', 1, 'System Notification Template created. <br/><br/>System Notification Title: asd<br/>System Notification Message: asdasd', 2, '2024-06-25 22:18:42'),
(192, 'notification_setting_email_template', 1, 'Email Notification Template created. <br/><br/>Email Notification Subject: asd<br/>Email Notification Body: <p>asdasd</p>', 2, '2024-06-25 22:18:51'),
(193, 'notification_setting_sms_template', 1, 'SMS Notification Template created. <br/><br/>SMS Notification Message: asdasd', 2, '2024-06-25 22:18:57'),
(194, 'notification_setting_email_template', 1, 'Email Notification Body: <p>asdasd</p> -> <p>asdasdasdasd</p><br/>', 2, '2024-06-25 22:19:45'),
(195, 'user_account', 2, 'Last Connection Date: 2024-06-25 19:30:44 -> 2024-06-25 22:22:34<br/>', 2, '2024-06-25 22:22:34'),
(196, 'role_system_action_permission', 8, 'System Action Access: 1 -> 0<br/>', 2, '2024-06-25 22:23:39'),
(197, 'role_system_action_permission', 8, 'System Action Access: 0 -> 1<br/>', 2, '2024-06-25 22:23:40'),
(198, 'notification_setting', 1, 'Email Notification: 0 -> 1<br/>', 2, '2024-06-25 22:24:38'),
(199, 'notification_setting', 1, 'Email Notification: 1 -> 0<br/>', 2, '2024-06-25 22:24:39');

-- --------------------------------------------------------

--
-- Table structure for table `city`
--

DROP TABLE IF EXISTS `city`;
CREATE TABLE `city` (
  `city_id` int(10) UNSIGNED NOT NULL,
  `city_name` varchar(100) NOT NULL,
  `state_id` int(10) UNSIGNED NOT NULL,
  `state_name` varchar(100) NOT NULL,
  `country_id` int(10) UNSIGNED NOT NULL,
  `country_name` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `city`
--

INSERT INTO `city` (`city_id`, `city_name`, `state_id`, `state_name`, `country_id`, `country_name`, `created_date`, `last_log_by`) VALUES
(1, 'Cabanatuan', 1, 'Nueva Ecija', 1, 'Philippines', '2024-06-25 20:03:37', 2);

--
-- Triggers `city`
--
DROP TRIGGER IF EXISTS `city_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `city_trigger_insert` AFTER INSERT ON `city` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'City created. <br/>';

    IF NEW.city_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>City Name: ", NEW.city_name);
    END IF;

    IF NEW.state_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>State: ", NEW.state_name);
    END IF;

    IF NEW.country_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Country: ", NEW.country_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('city', NEW.city_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `city_trigger_update`;
DELIMITER $$
CREATE TRIGGER `city_trigger_update` AFTER UPDATE ON `city` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.city_name <> OLD.city_name THEN
        SET audit_log = CONCAT(audit_log, "City Name: ", OLD.city_name, " -> ", NEW.city_name, "<br/>");
    END IF;

    IF NEW.state_name <> OLD.state_name THEN
        SET audit_log = CONCAT(audit_log, "State: ", OLD.state_name, " -> ", NEW.state_name, "<br/>");
    END IF;

    IF NEW.country_name <> OLD.country_name THEN
        SET audit_log = CONCAT(audit_log, "Country: ", OLD.country_name, " -> ", NEW.country_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('city', NEW.city_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
CREATE TABLE `company` (
  `company_id` int(10) UNSIGNED NOT NULL,
  `company_name` varchar(100) NOT NULL,
  `legal_name` varchar(100) NOT NULL,
  `address` varchar(500) NOT NULL,
  `city_id` int(10) UNSIGNED NOT NULL,
  `city_name` varchar(100) NOT NULL,
  `state_id` int(10) UNSIGNED NOT NULL,
  `state_name` varchar(100) NOT NULL,
  `country_id` int(10) UNSIGNED NOT NULL,
  `country_name` varchar(100) NOT NULL,
  `currency_id` int(10) UNSIGNED NOT NULL,
  `currency_name` varchar(100) NOT NULL,
  `currency_symbol` varchar(10) NOT NULL,
  `tax_id` varchar(50) DEFAULT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `mobile` varchar(50) DEFAULT NULL,
  `email` varchar(500) DEFAULT NULL,
  `website` varchar(500) DEFAULT NULL,
  `company_logo` varchar(500) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `company`
--

INSERT INTO `company` (`company_id`, `company_name`, `legal_name`, `address`, `city_id`, `city_name`, `state_id`, `state_name`, `country_id`, `country_name`, `currency_id`, `currency_name`, `currency_symbol`, `tax_id`, `phone`, `mobile`, `email`, `website`, `company_logo`, `created_date`, `last_log_by`) VALUES
(1, 'asd', 'asd', 'asdasd', 1, 'Cabanatuan', 1, 'Nueva Ecija', 1, 'Philippines', 2, 'PHP', 'Php', '112', '1212', '1212', 'a@gmail.com', '121212', './components/company/image/logo/1/TTV0.jpg', '2024-06-25 20:10:14', 2);

--
-- Triggers `company`
--
DROP TRIGGER IF EXISTS `company_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `company_trigger_insert` AFTER INSERT ON `company` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Company created. <br/>';

    IF NEW.company_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Company Name: ", NEW.company_name);
    END IF;

    IF NEW.legal_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Legal Name: ", NEW.legal_name);
    END IF;

    IF NEW.address <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Address: ", NEW.address);
    END IF;

    IF NEW.city_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>City: ", NEW.city_name);
    END IF;

    IF NEW.state_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>State: ", NEW.state_name);
    END IF;

    IF NEW.country_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Country: ", NEW.country_name);
    END IF;

    IF NEW.currency_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Currency: ", NEW.currency_name);
    END IF;

    IF NEW.currency_symbol <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Currency Symbol: ", NEW.currency_symbol);
    END IF;

    IF NEW.tax_id <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Tax ID: ", NEW.tax_id);
    END IF;

    IF NEW.phone <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Phone: ", NEW.phone);
    END IF;

    IF NEW.mobile <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Mobile: ", NEW.mobile);
    END IF;

    IF NEW.email <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Email: ", NEW.email);
    END IF;

    IF NEW.website <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Website: ", NEW.website);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('company', NEW.company_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `company_trigger_update`;
DELIMITER $$
CREATE TRIGGER `company_trigger_update` AFTER UPDATE ON `company` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.company_name <> OLD.company_name THEN
        SET audit_log = CONCAT(audit_log, "Company Name: ", OLD.company_name, " -> ", NEW.company_name, "<br/>");
    END IF;

    IF NEW.legal_name <> OLD.legal_name THEN
        SET audit_log = CONCAT(audit_log, "Legal Name: ", OLD.legal_name, " -> ", NEW.legal_name, "<br/>");
    END IF;

    IF NEW.address <> OLD.address THEN
        SET audit_log = CONCAT(audit_log, "Address: ", OLD.address, " -> ", NEW.address, "<br/>");
    END IF;

    IF NEW.city_name <> OLD.city_name THEN
        SET audit_log = CONCAT(audit_log, "City: ", OLD.city_name, " -> ", NEW.city_name, "<br/>");
    END IF;

    IF NEW.state_name <> OLD.state_name THEN
        SET audit_log = CONCAT(audit_log, "State: ", OLD.state_name, " -> ", NEW.state_name, "<br/>");
    END IF;

    IF NEW.country_name <> OLD.country_name THEN
        SET audit_log = CONCAT(audit_log, "Country: ", OLD.country_name, " -> ", NEW.country_name, "<br/>");
    END IF;

    IF NEW.currency_name <> OLD.currency_name THEN
        SET audit_log = CONCAT(audit_log, "Currency: ", OLD.currency_name, " -> ", NEW.currency_name, "<br/>");
    END IF;

    IF NEW.currency_symbol <> OLD.currency_symbol THEN
        SET audit_log = CONCAT(audit_log, "Currency Symbol: ", OLD.currency_symbol, " -> ", NEW.currency_symbol, "<br/>");
    END IF;

    IF NEW.tax_id <> OLD.tax_id THEN
        SET audit_log = CONCAT(audit_log, "Tax ID: ", OLD.tax_id, " -> ", NEW.tax_id, "<br/>");
    END IF;

    IF NEW.phone <> OLD.phone THEN
        SET audit_log = CONCAT(audit_log, "Phone: ", OLD.phone, " -> ", NEW.phone, "<br/>");
    END IF;

    IF NEW.mobile <> OLD.mobile THEN
        SET audit_log = CONCAT(audit_log, "Mobile: ", OLD.mobile, " -> ", NEW.mobile, "<br/>");
    END IF;

    IF NEW.email <> OLD.email THEN
        SET audit_log = CONCAT(audit_log, "Email: ", OLD.email, " -> ", NEW.email, "<br/>");
    END IF;

    IF NEW.website <> OLD.website THEN
        SET audit_log = CONCAT(audit_log, "Website: ", OLD.website, " -> ", NEW.website, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('company', NEW.company_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `country`
--

DROP TABLE IF EXISTS `country`;
CREATE TABLE `country` (
  `country_id` int(10) UNSIGNED NOT NULL,
  `country_name` varchar(100) NOT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `country`
--

INSERT INTO `country` (`country_id`, `country_name`, `last_log_by`) VALUES
(1, 'Philippines', 2);

--
-- Triggers `country`
--
DROP TRIGGER IF EXISTS `country_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `country_trigger_insert` AFTER INSERT ON `country` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Country created. <br/>';

    IF NEW.country_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Country Name: ", NEW.country_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('country', NEW.country_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `country_trigger_update`;
DELIMITER $$
CREATE TRIGGER `country_trigger_update` AFTER UPDATE ON `country` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.country_name <> OLD.country_name THEN
        SET audit_log = CONCAT(audit_log, "Country Name: ", OLD.country_name, " -> ", NEW.country_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('country', NEW.country_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `currency`
--

DROP TABLE IF EXISTS `currency`;
CREATE TABLE `currency` (
  `currency_id` int(10) UNSIGNED NOT NULL,
  `currency_name` varchar(100) NOT NULL,
  `currency_symbol` varchar(10) NOT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `currency`
--

INSERT INTO `currency` (`currency_id`, `currency_name`, `currency_symbol`, `last_log_by`) VALUES
(2, 'PHP', 'Php', 2);

--
-- Triggers `currency`
--
DROP TRIGGER IF EXISTS `currency_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `currency_trigger_insert` AFTER INSERT ON `currency` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Currency created. <br/>';

    IF NEW.currency_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Currency Name: ", NEW.currency_name);
    END IF;

    IF NEW.currency_symbol <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Currency Symbol: ", NEW.currency_symbol);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('currency', NEW.currency_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `currency_trigger_update`;
DELIMITER $$
CREATE TRIGGER `currency_trigger_update` AFTER UPDATE ON `currency` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.currency_name <> OLD.currency_name THEN
        SET audit_log = CONCAT(audit_log, "Currency Name: ", OLD.currency_name, " -> ", NEW.currency_name, "<br/>");
    END IF;

    IF NEW.currency_symbol <> OLD.currency_symbol THEN
        SET audit_log = CONCAT(audit_log, "Currency Symbol: ", OLD.currency_symbol, " -> ", NEW.currency_symbol, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('currency', NEW.currency_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `email_setting`
--

DROP TABLE IF EXISTS `email_setting`;
CREATE TABLE `email_setting` (
  `email_setting_id` int(10) UNSIGNED NOT NULL,
  `email_setting_name` varchar(100) NOT NULL,
  `email_setting_description` varchar(200) NOT NULL,
  `mail_host` varchar(100) NOT NULL,
  `port` varchar(10) NOT NULL,
  `smtp_auth` int(1) NOT NULL,
  `smtp_auto_tls` int(1) NOT NULL,
  `mail_username` varchar(200) NOT NULL,
  `mail_password` varchar(250) NOT NULL,
  `mail_encryption` varchar(20) DEFAULT NULL,
  `mail_from_name` varchar(200) DEFAULT NULL,
  `mail_from_email` varchar(200) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `email_setting`
--

INSERT INTO `email_setting` (`email_setting_id`, `email_setting_name`, `email_setting_description`, `mail_host`, `port`, `smtp_auth`, `smtp_auto_tls`, `mail_username`, `mail_password`, `mail_encryption`, `mail_from_name`, `mail_from_email`, `created_date`, `last_log_by`) VALUES
(1, 'Security Email Setting', 'Email setting for security emails.', 'smtp.hostinger.com', '465', 1, 0, 'cgmi-noreply@christianmotors.ph', 'yVFPK7ZBpfBxkDMpCWHHqTC4SWBqBBHACThxc2117cE%3D', 'ssl', 'cgmi-noreply@christianmotors.ph', 'cgmi-noreply@christianmotors.ph', '2024-06-15 18:16:10', 2);

--
-- Triggers `email_setting`
--
DROP TRIGGER IF EXISTS `email_setting_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `email_setting_trigger_insert` AFTER INSERT ON `email_setting` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Email Setting created. <br/>';

    IF NEW.email_setting_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Email Setting Name: ", NEW.email_setting_name);
    END IF;

    IF NEW.email_setting_description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Email Setting Description: ", NEW.email_setting_description);
    END IF;

    IF NEW.mail_host <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Host: ", NEW.mail_host);
    END IF;

    IF NEW.port <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Port: ", NEW.port);
    END IF;

    IF NEW.smtp_auth <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>SMTP Authentication: ", NEW.smtp_auth);
    END IF;

    IF NEW.smtp_auto_tls <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>SMTP Auto TLS: ", NEW.smtp_auto_tls);
    END IF;

    IF NEW.mail_username <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Mail Username: ", NEW.mail_username);
    END IF;

    IF NEW.mail_encryption <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Mail Encryption: ", NEW.mail_encryption);
    END IF;

    IF NEW.mail_from_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Mail From Name: ", NEW.mail_from_name);
    END IF;

    IF NEW.mail_from_email <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Mail From Email: ", NEW.mail_from_email);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('email_setting', NEW.email_setting_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `email_setting_trigger_update`;
DELIMITER $$
CREATE TRIGGER `email_setting_trigger_update` AFTER UPDATE ON `email_setting` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.email_setting_name <> OLD.email_setting_name THEN
        SET audit_log = CONCAT(audit_log, "Email Setting Name: ", OLD.email_setting_name, " -> ", NEW.email_setting_name, "<br/>");
    END IF;

    IF NEW.email_setting_description <> OLD.email_setting_description THEN
        SET audit_log = CONCAT(audit_log, "Email Setting Description: ", OLD.email_setting_description, " -> ", NEW.email_setting_description, "<br/>");
    END IF;

    IF NEW.mail_host <> OLD.mail_host THEN
        SET audit_log = CONCAT(audit_log, "Host: ", OLD.mail_host, " -> ", NEW.mail_host, "<br/>");
    END IF;

    IF NEW.port <> OLD.port THEN
        SET audit_log = CONCAT(audit_log, "Port: ", OLD.port, " -> ", NEW.port, "<br/>");
    END IF;

    IF NEW.smtp_auth <> OLD.smtp_auth THEN
        SET audit_log = CONCAT(audit_log, "SMTP Authentication: ", OLD.smtp_auth, " -> ", NEW.smtp_auth, "<br/>");
    END IF;

    IF NEW.smtp_auto_tls <> OLD.smtp_auto_tls THEN
        SET audit_log = CONCAT(audit_log, "SMTP Auto TLS: ", OLD.smtp_auto_tls, " -> ", NEW.smtp_auto_tls, "<br/>");
    END IF;

    IF NEW.mail_username <> OLD.mail_username THEN
        SET audit_log = CONCAT(audit_log, "Mail Username: ", OLD.mail_username, " -> ", NEW.mail_username, "<br/>");
    END IF;

    IF NEW.mail_encryption <> OLD.mail_encryption THEN
        SET audit_log = CONCAT(audit_log, "Mail Encryption: ", OLD.mail_encryption, " -> ", NEW.mail_encryption, "<br/>");
    END IF;

    IF NEW.mail_from_name <> OLD.mail_from_name THEN
        SET audit_log = CONCAT(audit_log, "Mail From Name: ", OLD.mail_from_name, " -> ", NEW.mail_from_name, "<br/>");
    END IF;

    IF NEW.mail_from_email <> OLD.mail_from_email THEN
        SET audit_log = CONCAT(audit_log, "Mail From Email: ", OLD.mail_from_email, " -> ", NEW.mail_from_email, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('email_setting', NEW.email_setting_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `file_extension`
--

DROP TABLE IF EXISTS `file_extension`;
CREATE TABLE `file_extension` (
  `file_extension_id` int(10) UNSIGNED NOT NULL,
  `file_extension_name` varchar(100) NOT NULL,
  `file_extension` varchar(10) NOT NULL,
  `file_type_id` int(11) NOT NULL,
  `file_type_name` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `file_extension`
--

INSERT INTO `file_extension` (`file_extension_id`, `file_extension_name`, `file_extension`, `file_type_id`, `file_type_name`, `created_date`, `last_log_by`) VALUES
(1, 'PNG', 'png', 1, 'Image', '2024-06-25 20:55:31', 1),
(2, 'JPG', 'jpg', 1, 'Image', '2024-06-25 20:55:31', 1),
(3, 'JPEG', 'jpeg', 1, 'Image', '2024-06-25 20:55:31', 1),
(4, 'PDF', 'pdf', 2, 'Document', '2024-06-25 20:55:31', 1),
(5, 'DOCX', '.docx', 2, 'Document', '2024-06-25 21:05:38', 2);

--
-- Triggers `file_extension`
--
DROP TRIGGER IF EXISTS `file_extension_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `file_extension_trigger_insert` AFTER INSERT ON `file_extension` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'File Extension created. <br/>';

    IF NEW.file_extension_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>File Extension Name: ", NEW.file_extension_name);
    END IF;

    IF NEW.file_extension <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>File Extension: ", NEW.file_extension);
    END IF;

    IF NEW.file_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>File Type: ", NEW.file_type_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('file_extension', NEW.file_extension_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `file_extension_trigger_update`;
DELIMITER $$
CREATE TRIGGER `file_extension_trigger_update` AFTER UPDATE ON `file_extension` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.file_extension_name <> OLD.file_extension_name THEN
        SET audit_log = CONCAT(audit_log, "File Extension Name: ", OLD.file_extension_name, " -> ", NEW.file_extension_name, "<br/>");
    END IF;

    IF NEW.file_extension <> OLD.file_extension THEN
        SET audit_log = CONCAT(audit_log, "File Extension: ", OLD.file_extension, " -> ", NEW.file_extension, "<br/>");
    END IF;

    IF NEW.file_type_name <> OLD.file_type_name THEN
        SET audit_log = CONCAT(audit_log, "File Type: ", OLD.file_type_name, " -> ", NEW.file_type_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('file_extension', NEW.file_extension_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `file_type`
--

DROP TABLE IF EXISTS `file_type`;
CREATE TABLE `file_type` (
  `file_type_id` int(10) UNSIGNED NOT NULL,
  `file_type_name` varchar(100) NOT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `file_type`
--

INSERT INTO `file_type` (`file_type_id`, `file_type_name`, `last_log_by`, `created_date`) VALUES
(1, 'Image', 1, '2024-06-25 20:56:04'),
(2, 'Document', 1, '2024-06-25 20:56:04');

--
-- Triggers `file_type`
--
DROP TRIGGER IF EXISTS `file_type_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `file_type_trigger_insert` AFTER INSERT ON `file_type` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'File type created. <br/>';

    IF NEW.file_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>File Type Name: ", NEW.file_type_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('file_type', NEW.file_type_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `file_type_trigger_update`;
DELIMITER $$
CREATE TRIGGER `file_type_trigger_update` AFTER UPDATE ON `file_type` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.file_type_name <> OLD.file_type_name THEN
        SET audit_log = CONCAT(audit_log, "File Type Name: ", OLD.file_type_name, " -> ", NEW.file_type_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('file_type', NEW.file_type_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `internal_notes`
--

DROP TABLE IF EXISTS `internal_notes`;
CREATE TABLE `internal_notes` (
  `internal_notes_id` int(10) UNSIGNED NOT NULL,
  `table_name` varchar(255) NOT NULL,
  `reference_id` int(11) NOT NULL,
  `internal_note` varchar(5000) NOT NULL,
  `internal_note_by` int(10) UNSIGNED NOT NULL,
  `internal_note_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `internal_notes`
--

INSERT INTO `internal_notes` (`internal_notes_id`, `table_name`, `reference_id`, `internal_note`, `internal_note_by`, `internal_note_date`) VALUES
(1, 'app_module', 2, 'ads', 2, '2024-06-21 12:25:36'),
(2, 'app_module', 2, 'ads', 2, '2024-06-21 12:27:01'),
(3, 'app_module', 1, 'asd', 2, '2024-06-21 16:38:39'),
(4, 'app_module', 1, 'asdasd', 2, '2024-06-21 16:40:15'),
(5, 'app_module', 1, 'asd', 2, '2024-06-21 17:08:42'),
(6, 'app_module', 1, 'asd', 2, '2024-06-21 17:09:36'),
(7, 'app_module', 1, 'asdasd', 2, '2024-06-21 17:09:53'),
(8, 'app_module', 1, 'ssdfd', 2, '2024-06-21 17:13:22'),
(9, 'app_module', 1, 'test\r\n', 2, '2024-06-22 10:34:32'),
(10, 'user_account', 2, 'asd', 2, '2024-06-24 17:21:15'),
(11, 'currency', 2, 'Test', 2, '2024-06-25 22:25:51');

-- --------------------------------------------------------

--
-- Table structure for table `internal_notes_attachment`
--

DROP TABLE IF EXISTS `internal_notes_attachment`;
CREATE TABLE `internal_notes_attachment` (
  `internal_notes_attachment_id` int(10) UNSIGNED NOT NULL,
  `internal_notes_id` int(10) UNSIGNED NOT NULL,
  `attachment_file_name` varchar(500) NOT NULL,
  `attachment_file_size` double NOT NULL,
  `attachment_path_file` varchar(500) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `internal_notes_attachment`
--

INSERT INTO `internal_notes_attachment` (`internal_notes_attachment_id`, `internal_notes_id`, `attachment_file_name`, `attachment_file_size`, `attachment_path_file`) VALUES
(1, 3, 'Agulto', 212362, './components/global/files/internal_notes/3/Agulto.png'),
(2, 3, 'download', 222999, './components/global/files/internal_notes/3/download.jpg'),
(3, 5, 'download', 222999, './components/global/files/internal_notes/5/download.jpg'),
(4, 11, 'Lawrence Resume', 85774, './components/global/files/internal_notes/11/Lawrence Resume.pdf');

-- --------------------------------------------------------

--
-- Table structure for table `menu_group`
--

DROP TABLE IF EXISTS `menu_group`;
CREATE TABLE `menu_group` (
  `menu_group_id` int(10) UNSIGNED NOT NULL,
  `menu_group_name` varchar(100) NOT NULL,
  `app_module_id` int(10) UNSIGNED NOT NULL,
  `app_module_name` varchar(100) NOT NULL,
  `order_sequence` tinyint(10) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `menu_group`
--

INSERT INTO `menu_group` (`menu_group_id`, `menu_group_name`, `app_module_id`, `app_module_name`, `order_sequence`, `created_date`, `last_log_by`) VALUES
(1, 'Technical', 1, 'Settings', 100, '2024-06-21 15:16:45', 2),
(2, 'Administration', 1, 'Settings', 99, '2024-06-21 15:16:45', 2);

--
-- Triggers `menu_group`
--
DROP TRIGGER IF EXISTS `menu_group_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `menu_group_trigger_insert` AFTER INSERT ON `menu_group` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Menu group created. <br/>';

    IF NEW.menu_group_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Menu Group Name: ", NEW.menu_group_name);
    END IF;

    IF NEW.app_module_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>App Module: ", NEW.app_module_name);
    END IF;

    IF NEW.order_sequence <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Order Sequence: ", NEW.order_sequence);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('menu_group', NEW.menu_group_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `menu_group_trigger_update`;
DELIMITER $$
CREATE TRIGGER `menu_group_trigger_update` AFTER UPDATE ON `menu_group` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.menu_group_name <> OLD.menu_group_name THEN
        SET audit_log = CONCAT(audit_log, "Menu Group Name: ", OLD.menu_group_name, " -> ", NEW.menu_group_name, "<br/>");
    END IF;
    
      IF NEW.app_module_name <> OLD.app_module_name THEN
        SET audit_log = CONCAT(audit_log, "App Module: ", OLD.app_module_name, " -> ", NEW.app_module_name, "<br/>");
    END IF;

    IF NEW.order_sequence <> OLD.order_sequence THEN
        SET audit_log = CONCAT(audit_log, "Order Sequence: ", OLD.order_sequence, " -> ", NEW.order_sequence, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('menu_group', NEW.menu_group_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `menu_item`
--

DROP TABLE IF EXISTS `menu_item`;
CREATE TABLE `menu_item` (
  `menu_item_id` int(10) UNSIGNED NOT NULL,
  `menu_item_name` varchar(100) NOT NULL,
  `menu_item_url` varchar(50) DEFAULT NULL,
  `menu_item_icon` varchar(50) DEFAULT NULL,
  `menu_group_id` int(10) UNSIGNED NOT NULL,
  `menu_group_name` varchar(100) NOT NULL,
  `app_module_id` int(10) UNSIGNED NOT NULL,
  `app_module_name` varchar(100) NOT NULL,
  `parent_id` int(10) UNSIGNED DEFAULT NULL,
  `parent_name` varchar(100) DEFAULT NULL,
  `order_sequence` tinyint(10) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `menu_item`
--

INSERT INTO `menu_item` (`menu_item_id`, `menu_item_name`, `menu_item_url`, `menu_item_icon`, `menu_group_id`, `menu_group_name`, `app_module_id`, `app_module_name`, `parent_id`, `parent_name`, `order_sequence`, `created_date`, `last_log_by`) VALUES
(1, 'General Settings', 'general-settings.php', 'ti ti-settings', 1, 'Technical', 1, 'Settings', 0, '', 2, '2024-06-21 15:18:43', 2),
(2, 'Users & Companies', '', 'ti ti-users', 2, 'Administration', 1, 'Settings', 0, '', 1, '2024-06-21 15:18:43', 2),
(3, 'User Account', 'user-account.php', '', 2, 'Administration', 1, 'Settings', 2, 'Users & Companies', 1, '2024-06-21 15:18:43', 2),
(4, 'Company', 'company.php', '', 2, 'Administration', 1, 'Settings', 2, 'Users & Companies', 3, '2024-06-21 15:18:43', 2),
(5, 'App Module', 'app-module.php', 'ti ti-box', 1, 'Technical', 1, 'Settings', 0, NULL, 1, '2024-06-21 15:18:43', 2),
(6, 'User Interface', '', 'ti ti-layout-sidebar', 1, 'Technical', 1, 'Settings', 0, NULL, 4, '2024-06-25 11:43:13', 2),
(7, 'Menu Group', 'menu-group.php', '', 1, 'Technical', 1, 'Settings', 6, 'User Interface', 1, '2024-06-25 11:43:13', 2),
(8, 'Menu Item', 'menu-item.php', '', 1, 'Technical', 1, 'Settings', 6, 'User Interface', 2, '2024-06-25 11:43:13', 2),
(9, 'Role', 'role.php', 'ti ti-hierarchy-2', 2, 'Administration', 1, 'Settings', 0, NULL, 2, '2024-06-25 16:51:04', 2),
(10, 'System Action', 'system-action.php', '', 1, 'Technical', 1, 'Settings', 6, 'User Interface', 3, '2024-06-25 17:19:47', 2),
(11, 'Localization', '', 'ti ti-map-pin', 1, 'Technical', 1, 'Settings', NULL, NULL, 2, '2024-06-25 17:25:32', 2),
(12, 'State', 'state.php', '', 1, 'Technical', 1, 'Settings', 11, 'Localization', 10, '2024-06-25 17:28:43', 2),
(13, 'Country', 'country.php', '', 1, 'Technical', 1, 'Settings', 11, 'Localization', 4, '2024-06-25 17:29:18', 2),
(14, 'City', 'city.php', '', 1, 'Technical', 1, 'Settings', 11, 'Localization', 3, '2024-06-25 17:29:59', 2),
(15, 'Currency', 'currency.php', '', 1, 'Technical', 1, 'Settings', 11, 'Localization', 2, '2024-06-25 17:31:04', 2),
(16, 'File Configuration', '', 'ti ti-file-symlink', 1, 'Technical', 1, 'Settings', 0, NULL, 6, '2024-06-25 20:46:41', 2),
(17, 'Upload Setting', 'upload-setting.php', '', 1, 'Technical', 1, 'Settings', 16, 'File Configuration', 1, '2024-06-25 20:48:30', 2),
(18, 'File Type', 'file-type.php', '', 1, 'Technical', 1, 'Settings', 16, 'File Configuration', 2, '2024-06-25 20:49:16', 2),
(19, 'File Extension', 'file-extension.php', '', 1, 'Technical', 1, 'Settings', 16, 'File Configuration', 3, '2024-06-25 20:49:45', 2),
(20, 'Email Setting', 'email-setting.php', 'ti ti-mail-forward', 1, 'Technical', 1, 'Settings', 0, NULL, 5, '2024-06-25 21:16:26', 2),
(21, 'Notification Setting', 'notification-setting.php', 'ti ti-bell', 1, 'Technical', 1, 'Settings', 0, NULL, 14, '2024-06-25 21:34:21', 2);

--
-- Triggers `menu_item`
--
DROP TRIGGER IF EXISTS `menu_item_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `menu_item_trigger_insert` AFTER INSERT ON `menu_item` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Menu Item created. <br/>';

    IF NEW.menu_item_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Menu Item Name: ", NEW.menu_item_name);
    END IF;

    IF NEW.menu_item_url <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Menu Item URL: ", NEW.menu_item_url);
    END IF;

    IF NEW.menu_item_icon <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Menu Item Icon: ", NEW.menu_item_icon);
    END IF;

    IF NEW.menu_group_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Menu Group Name: ", NEW.menu_group_name);
    END IF;

    IF NEW.app_module_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>App Module: ", NEW.app_module_name);
    END IF;

    IF NEW.parent_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Parent: ", NEW.parent_name);
    END IF;

    IF NEW.order_sequence <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Order Sequence: ", NEW.order_sequence);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('menu_item', NEW.menu_item_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `menu_item_trigger_update`;
DELIMITER $$
CREATE TRIGGER `menu_item_trigger_update` AFTER UPDATE ON `menu_item` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.menu_item_name <> OLD.menu_item_name THEN
        SET audit_log = CONCAT(audit_log, "Menu Item Name: ", OLD.menu_item_name, " -> ", NEW.menu_item_name, "<br/>");
    END IF;

    IF NEW.menu_item_url <> OLD.menu_item_url THEN
        SET audit_log = CONCAT(audit_log, "Menu Item URL: ", OLD.menu_item_url, " -> ", NEW.menu_item_url, "<br/>");
    END IF;

    IF NEW.menu_item_icon <> OLD.menu_item_icon THEN
        SET audit_log = CONCAT(audit_log, "Menu Item Icon: ", OLD.menu_item_icon, " -> ", NEW.menu_item_icon, "<br/>");
    END IF;

    IF NEW.menu_group_name <> OLD.menu_group_name THEN
        SET audit_log = CONCAT(audit_log, "Menu Group Name: ", OLD.menu_group_name, " -> ", NEW.menu_group_name, "<br/>");
    END IF;

    IF NEW.app_module_name <> OLD.app_module_name THEN
        SET audit_log = CONCAT(audit_log, "App Module: ", OLD.app_module_name, " -> ", NEW.app_module_name, "<br/>");
    END IF;

    IF NEW.parent_name <> OLD.parent_name THEN
        SET audit_log = CONCAT(audit_log, "Parent: ", OLD.parent_name, " -> ", NEW.parent_name, "<br/>");
    END IF;

    IF NEW.order_sequence <> OLD.order_sequence THEN
        SET audit_log = CONCAT(audit_log, "Order Sequence: ", OLD.order_sequence, " -> ", NEW.order_sequence, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('menu_item', NEW.menu_item_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `notification_setting`
--

DROP TABLE IF EXISTS `notification_setting`;
CREATE TABLE `notification_setting` (
  `notification_setting_id` int(10) UNSIGNED NOT NULL,
  `notification_setting_name` varchar(100) NOT NULL,
  `notification_setting_description` varchar(200) NOT NULL,
  `system_notification` int(1) NOT NULL DEFAULT 1,
  `email_notification` int(1) NOT NULL DEFAULT 0,
  `sms_notification` int(1) NOT NULL DEFAULT 0,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notification_setting`
--

INSERT INTO `notification_setting` (`notification_setting_id`, `notification_setting_name`, `notification_setting_description`, `system_notification`, `email_notification`, `sms_notification`, `created_date`, `last_log_by`) VALUES
(1, 'Forgot Password', 'Notification setting for forgot password', 1, 0, 0, '2024-06-25 21:36:35', 2);

--
-- Triggers `notification_setting`
--
DROP TRIGGER IF EXISTS `notification_setting_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `notification_setting_trigger_insert` AFTER INSERT ON `notification_setting` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Notification Setting created. <br/>';

    IF NEW.notification_setting_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Notification Setting Name: ", NEW.notification_setting_name);
    END IF;

    IF NEW.notification_setting_description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Notification Setting Description: ", NEW.notification_setting_description);
    END IF;

    IF NEW.system_notification <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>System Notification: ", NEW.system_notification);
    END IF;

    IF NEW.email_notification <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Email Notification: ", NEW.email_notification);
    END IF;

    IF NEW.sms_notification <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>SMS Notification: ", NEW.sms_notification);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('notification_setting', NEW.notification_setting_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `notification_setting_trigger_update`;
DELIMITER $$
CREATE TRIGGER `notification_setting_trigger_update` AFTER UPDATE ON `notification_setting` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.notification_setting_name <> OLD.notification_setting_name THEN
        SET audit_log = CONCAT(audit_log, "Notification Setting Name: ", OLD.notification_setting_name, " -> ", NEW.notification_setting_name, "<br/>");
    END IF;

    IF NEW.notification_setting_description <> OLD.notification_setting_description THEN
        SET audit_log = CONCAT(audit_log, "Notification Setting Description: ", OLD.notification_setting_description, " -> ", NEW.notification_setting_description, "<br/>");
    END IF;

    IF NEW.system_notification <> OLD.system_notification THEN
        SET audit_log = CONCAT(audit_log, "System Notification: ", OLD.system_notification, " -> ", NEW.system_notification, "<br/>");
    END IF;

    IF NEW.email_notification <> OLD.email_notification THEN
        SET audit_log = CONCAT(audit_log, "Email Notification: ", OLD.email_notification, " -> ", NEW.email_notification, "<br/>");
    END IF;

    IF NEW.sms_notification <> OLD.sms_notification THEN
        SET audit_log = CONCAT(audit_log, "SMS Notification: ", OLD.sms_notification, " -> ", NEW.sms_notification, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('notification_setting', NEW.notification_setting_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `notification_setting_email_template`
--

DROP TABLE IF EXISTS `notification_setting_email_template`;
CREATE TABLE `notification_setting_email_template` (
  `notification_setting_email_id` int(10) UNSIGNED NOT NULL,
  `notification_setting_id` int(10) UNSIGNED NOT NULL,
  `email_notification_subject` varchar(200) NOT NULL,
  `email_notification_body` longtext NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notification_setting_email_template`
--

INSERT INTO `notification_setting_email_template` (`notification_setting_email_id`, `notification_setting_id`, `email_notification_subject`, `email_notification_body`, `created_date`, `last_log_by`) VALUES
(1, 1, 'asd', '<p>asdasdasdasd</p>', '2024-06-25 22:18:51', 2);

--
-- Triggers `notification_setting_email_template`
--
DROP TRIGGER IF EXISTS `notification_setting_email_template_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `notification_setting_email_template_trigger_insert` AFTER INSERT ON `notification_setting_email_template` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Email Notification Template created. <br/>';

    IF NEW.email_notification_subject <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Email Notification Subject: ", NEW.email_notification_subject);
    END IF;

    IF NEW.email_notification_body <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Email Notification Body: ", NEW.email_notification_body);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('notification_setting_email_template', NEW.notification_setting_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `notification_setting_email_template_trigger_update`;
DELIMITER $$
CREATE TRIGGER `notification_setting_email_template_trigger_update` AFTER UPDATE ON `notification_setting_email_template` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.email_notification_subject <> OLD.email_notification_subject THEN
        SET audit_log = CONCAT(audit_log, "Email Notification Subject: ", OLD.email_notification_subject, " -> ", NEW.email_notification_subject, "<br/>");
    END IF;

    IF NEW.email_notification_body <> OLD.email_notification_body THEN
        SET audit_log = CONCAT(audit_log, "Email Notification Body: ", OLD.email_notification_body, " -> ", NEW.email_notification_body, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('notification_setting_email_template', NEW.notification_setting_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `notification_setting_sms_template`
--

DROP TABLE IF EXISTS `notification_setting_sms_template`;
CREATE TABLE `notification_setting_sms_template` (
  `notification_setting_sms_id` int(10) UNSIGNED NOT NULL,
  `notification_setting_id` int(10) UNSIGNED NOT NULL,
  `sms_notification_message` varchar(500) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notification_setting_sms_template`
--

INSERT INTO `notification_setting_sms_template` (`notification_setting_sms_id`, `notification_setting_id`, `sms_notification_message`, `created_date`, `last_log_by`) VALUES
(1, 1, 'asdasd', '2024-06-25 22:18:57', 2);

--
-- Triggers `notification_setting_sms_template`
--
DROP TRIGGER IF EXISTS `notification_setting_sms_template_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `notification_setting_sms_template_trigger_insert` AFTER INSERT ON `notification_setting_sms_template` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'SMS Notification Template created. <br/>';

    IF NEW.sms_notification_message <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>SMS Notification Message: ", NEW.sms_notification_message);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('notification_setting_sms_template', NEW.notification_setting_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `notification_setting_sms_template_trigger_update`;
DELIMITER $$
CREATE TRIGGER `notification_setting_sms_template_trigger_update` AFTER UPDATE ON `notification_setting_sms_template` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.sms_notification_message <> OLD.sms_notification_message THEN
        SET audit_log = CONCAT(audit_log, "SMS Notification Message: ", OLD.sms_notification_message, " -> ", NEW.sms_notification_message, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('notification_setting_sms_template', NEW.notification_setting_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `notification_setting_system_template`
--

DROP TABLE IF EXISTS `notification_setting_system_template`;
CREATE TABLE `notification_setting_system_template` (
  `notification_setting_system_id` int(10) UNSIGNED NOT NULL,
  `notification_setting_id` int(10) UNSIGNED NOT NULL,
  `system_notification_title` varchar(200) NOT NULL,
  `system_notification_message` varchar(500) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `notification_setting_system_template`
--

INSERT INTO `notification_setting_system_template` (`notification_setting_system_id`, `notification_setting_id`, `system_notification_title`, `system_notification_message`, `created_date`, `last_log_by`) VALUES
(1, 1, 'asd', 'asdasd', '2024-06-25 22:18:42', 2);

--
-- Triggers `notification_setting_system_template`
--
DROP TRIGGER IF EXISTS `notification_setting_system_template_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `notification_setting_system_template_trigger_insert` AFTER INSERT ON `notification_setting_system_template` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'System Notification Template created. <br/>';

    IF NEW.system_notification_title <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>System Notification Title: ", NEW.system_notification_title);
    END IF;

    IF NEW.system_notification_message <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>System Notification Message: ", NEW.system_notification_message);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('notification_setting_system_template', NEW.notification_setting_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `notification_setting_system_template_trigger_update`;
DELIMITER $$
CREATE TRIGGER `notification_setting_system_template_trigger_update` AFTER UPDATE ON `notification_setting_system_template` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.system_notification_title <> OLD.system_notification_title THEN
        SET audit_log = CONCAT(audit_log, "System Notification Title: ", OLD.system_notification_title, " -> ", NEW.system_notification_title, "<br/>");
    END IF;

    IF NEW.system_notification_message <> OLD.system_notification_message THEN
        SET audit_log = CONCAT(audit_log, "System Notification Message: ", OLD.system_notification_message, " -> ", NEW.system_notification_message, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('notification_setting_system_template', NEW.notification_setting_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `password_history`
--

DROP TABLE IF EXISTS `password_history`;
CREATE TABLE `password_history` (
  `password_history_id` int(10) UNSIGNED NOT NULL,
  `user_account_id` int(10) UNSIGNED NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `password_change_date` datetime DEFAULT current_timestamp(),
  `created_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `role`
--

DROP TABLE IF EXISTS `role`;
CREATE TABLE `role` (
  `role_id` int(10) UNSIGNED NOT NULL,
  `role_name` varchar(100) NOT NULL,
  `role_description` varchar(200) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `role`
--

INSERT INTO `role` (`role_id`, `role_name`, `role_description`, `created_date`, `last_log_by`) VALUES
(1, 'Administrator', 'Full access to all features and data within the system. This role have similar access levels to the Admin but is not as powerful as the Super Admin.', '2024-06-15 18:15:35', 1);

--
-- Triggers `role`
--
DROP TRIGGER IF EXISTS `role_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `role_trigger_insert` AFTER INSERT ON `role` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Role created. <br/>';

    IF NEW.role_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Role Name: ", NEW.role_name);
    END IF;

    IF NEW.role_description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Role Description: ", NEW.role_description);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('role', NEW.role_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `role_trigger_update`;
DELIMITER $$
CREATE TRIGGER `role_trigger_update` AFTER UPDATE ON `role` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.role_name <> OLD.role_name THEN
        SET audit_log = CONCAT(audit_log, "Role Name: ", OLD.role_name, " -> ", NEW.role_name, "<br/>");
    END IF;

    IF NEW.role_description <> OLD.role_description THEN
        SET audit_log = CONCAT(audit_log, "Role Description: ", OLD.role_description, " -> ", NEW.role_description, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('role', NEW.role_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `role_permission`
--

DROP TABLE IF EXISTS `role_permission`;
CREATE TABLE `role_permission` (
  `role_permission_id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `role_name` varchar(100) NOT NULL,
  `menu_item_id` int(10) UNSIGNED NOT NULL,
  `menu_item_name` varchar(100) NOT NULL,
  `read_access` tinyint(1) NOT NULL DEFAULT 0,
  `write_access` tinyint(1) NOT NULL DEFAULT 0,
  `create_access` tinyint(1) NOT NULL DEFAULT 0,
  `delete_access` tinyint(1) NOT NULL DEFAULT 0,
  `date_assigned` datetime NOT NULL DEFAULT current_timestamp(),
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `role_permission`
--

INSERT INTO `role_permission` (`role_permission_id`, `role_id`, `role_name`, `menu_item_id`, `menu_item_name`, `read_access`, `write_access`, `create_access`, `delete_access`, `date_assigned`, `created_date`, `last_log_by`) VALUES
(1, 1, 'Administrator', 1, 'General Setting', 1, 0, 0, 0, '2024-06-15 18:15:35', '2024-06-15 18:15:35', 1),
(2, 1, 'Administrator', 2, 'Users & Companies', 1, 0, 0, 0, '2024-06-19 17:25:30', '2024-06-19 17:25:30', 1),
(3, 1, 'Administrator', 3, 'User Account', 1, 1, 1, 1, '2024-06-19 17:30:37', '2024-06-19 17:30:37', 1),
(4, 1, 'Administrator', 4, 'Company', 1, 1, 1, 1, '2024-06-19 17:30:37', '2024-06-19 17:30:37', 1),
(5, 1, 'Administrator', 5, 'App Module', 1, 1, 1, 1, '2024-06-20 11:37:17', '2024-06-20 11:37:17', 2),
(6, 1, 'Administrator', 6, 'User Interface', 1, 0, 0, 0, '2024-06-25 11:43:13', '2024-06-25 11:43:13', 2),
(7, 1, 'Administrator', 7, 'Menu Group', 1, 1, 1, 1, '2024-06-25 11:43:13', '2024-06-25 11:43:13', 1),
(8, 1, 'Administrator', 8, 'Menu Item', 1, 1, 1, 1, '2024-06-25 11:43:13', '2024-06-25 11:43:13', 1),
(9, 1, 'Administrator', 9, 'Role', 1, 1, 1, 1, '2024-06-25 16:51:10', '2024-06-25 16:51:10', 2),
(10, 1, 'Administrator', 10, 'System Action', 1, 1, 1, 1, '2024-06-25 17:20:10', '2024-06-25 17:20:10', 2),
(11, 1, 'Administrator', 11, 'Localization', 1, 0, 0, 0, '2024-06-25 17:25:37', '2024-06-25 17:25:37', 2),
(12, 1, 'Administrator', 12, 'State', 1, 1, 1, 1, '2024-06-25 17:28:49', '2024-06-25 17:28:49', 2),
(13, 1, 'Administrator', 13, 'Country', 1, 1, 1, 1, '2024-06-25 17:29:23', '2024-06-25 17:29:23', 2),
(14, 1, 'Administrator', 14, 'City', 1, 1, 1, 1, '2024-06-25 17:30:03', '2024-06-25 17:30:03', 2),
(15, 1, 'Administrator', 15, 'Currency', 1, 1, 1, 1, '2024-06-25 17:31:09', '2024-06-25 17:31:09', 2),
(16, 1, 'Administrator', 16, 'File Configuration', 1, 0, 0, 0, '2024-06-25 20:46:46', '2024-06-25 20:46:46', 2),
(17, 1, 'Administrator', 17, 'Upload Setting', 1, 1, 1, 1, '2024-06-25 20:48:37', '2024-06-25 20:48:37', 2),
(18, 1, 'Administrator', 18, 'File Type', 1, 1, 1, 1, '2024-06-25 20:49:20', '2024-06-25 20:49:20', 2),
(19, 1, 'Administrator', 19, 'File Extension', 1, 1, 1, 1, '2024-06-25 20:49:49', '2024-06-25 20:49:49', 2),
(20, 1, 'Administrator', 20, 'Email Setting', 1, 1, 1, 1, '2024-06-25 21:16:34', '2024-06-25 21:16:34', 2),
(21, 1, 'Administrator', 21, 'Notification Setting', 1, 1, 1, 1, '2024-06-25 21:34:30', '2024-06-25 21:34:30', 2);

--
-- Triggers `role_permission`
--
DROP TRIGGER IF EXISTS `role_permission_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `role_permission_trigger_insert` AFTER INSERT ON `role_permission` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Role permission created. <br/>';

    IF NEW.role_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Role Name: ", NEW.role_name);
    END IF;

    IF NEW.menu_item_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Menu Item Name: ", NEW.menu_item_name);
    END IF;

    IF NEW.read_access <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Read Access: ", NEW.read_access);
    END IF;

    IF NEW.write_access <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Write Access: ", NEW.write_access);
    END IF;

    IF NEW.create_access <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Create Access: ", NEW.create_access);
    END IF;

    IF NEW.delete_access <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Delete Access: ", NEW.delete_access);
    END IF;

    IF NEW.date_assigned <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Date Assigned: ", NEW.date_assigned);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('role_permission', NEW.role_permission_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `role_permission_trigger_update`;
DELIMITER $$
CREATE TRIGGER `role_permission_trigger_update` AFTER UPDATE ON `role_permission` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.role_name <> OLD.role_name THEN
        SET audit_log = CONCAT(audit_log, "Role Name: ", OLD.role_name, " -> ", NEW.role_name, "<br/>");
    END IF;

    IF NEW.menu_item_name <> OLD.menu_item_name THEN
        SET audit_log = CONCAT(audit_log, "Menu Item: ", OLD.menu_item_name, " -> ", NEW.menu_item_name, "<br/>");
    END IF;

    IF NEW.read_access <> OLD.read_access THEN
        SET audit_log = CONCAT(audit_log, "Read Access: ", OLD.read_access, " -> ", NEW.read_access, "<br/>");
    END IF;

    IF NEW.write_access <> OLD.write_access THEN
        SET audit_log = CONCAT(audit_log, "Write Access: ", OLD.write_access, " -> ", NEW.write_access, "<br/>");
    END IF;

    IF NEW.create_access <> OLD.create_access THEN
        SET audit_log = CONCAT(audit_log, "Create Access: ", OLD.create_access, " -> ", NEW.create_access, "<br/>");
    END IF;

    IF NEW.delete_access <> OLD.delete_access THEN
        SET audit_log = CONCAT(audit_log, "Delete Access: ", OLD.delete_access, " -> ", NEW.delete_access, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('role_permission', NEW.role_permission_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `role_system_action_permission`
--

DROP TABLE IF EXISTS `role_system_action_permission`;
CREATE TABLE `role_system_action_permission` (
  `role_system_action_permission_id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `role_name` varchar(100) NOT NULL,
  `system_action_id` int(10) UNSIGNED NOT NULL,
  `system_action_name` varchar(100) NOT NULL,
  `system_action_access` tinyint(1) NOT NULL DEFAULT 0,
  `date_assigned` datetime NOT NULL DEFAULT current_timestamp(),
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `role_system_action_permission`
--

INSERT INTO `role_system_action_permission` (`role_system_action_permission_id`, `role_id`, `role_name`, `system_action_id`, `system_action_name`, `system_action_access`, `date_assigned`, `created_date`, `last_log_by`) VALUES
(1, 1, 'Administrator', 1, 'Update System Settings', 1, '2024-06-22 17:54:16', '2024-06-22 17:54:16', 1),
(2, 1, 'Administrator', 2, 'Update Security Settings', 1, '2024-06-22 17:54:16', '2024-06-22 17:54:16', 1),
(3, 1, 'Administrator', 3, 'Activate User Account', 1, '2024-06-22 17:54:16', '2024-06-22 17:54:16', 2),
(4, 1, 'Administrator', 4, 'Deactivate User Account', 1, '2024-06-22 17:54:16', '2024-06-22 17:54:16', 1),
(5, 1, 'Administrator', 5, 'Lock User Account', 1, '2024-06-22 17:54:16', '2024-06-22 17:54:16', 1),
(6, 1, 'Administrator', 6, 'Unlock User Account', 1, '2024-06-22 17:54:16', '2024-06-22 17:54:16', 1),
(7, 1, 'Administrator', 7, 'Add Role User Account', 1, '2024-06-22 17:54:17', '2024-06-22 17:54:17', 1),
(8, 1, 'Administrator', 8, 'Delete Role User Account', 1, '2024-06-22 17:54:17', '2024-06-22 17:54:17', 2),
(9, 1, 'Administrator', 9, 'Add Role Access', 1, '2024-06-22 17:54:17', '2024-06-22 17:54:17', 1),
(10, 1, 'Administrator', 10, 'Update Role Access', 1, '2024-06-22 17:54:17', '2024-06-22 17:54:17', 1),
(11, 1, 'Administrator', 11, 'Delete Role Access', 1, '2024-06-22 17:54:17', '2024-06-22 17:54:17', 1),
(12, 1, 'Administrator', 12, 'Add Role System Action Access', 1, '2024-06-22 17:54:17', '2024-06-22 17:54:17', 1),
(13, 1, 'Administrator', 13, 'Update Role System Action Access', 1, '2024-06-22 17:54:17', '2024-06-22 17:54:17', 1),
(14, 1, 'Administrator', 14, 'Delete Role System Action Access', 1, '2024-06-22 17:54:17', '2024-06-22 17:54:17', 1),
(15, 1, 'Administrator', 15, 'Add File Extension Access', 1, '2024-06-22 17:54:17', '2024-06-22 17:54:17', 1),
(16, 1, 'Administrator', 16, 'Delete File Extension Access', 1, '2024-06-22 17:54:17', '2024-06-22 17:54:17', 1);

--
-- Triggers `role_system_action_permission`
--
DROP TRIGGER IF EXISTS `role_system_action_permission_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `role_system_action_permission_trigger_insert` AFTER INSERT ON `role_system_action_permission` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Role system action permission created. <br/>';

    IF NEW.role_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Role Name: ", NEW.role_name);
    END IF;

    IF NEW.system_action_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>System Action Name: ", NEW.system_action_name);
    END IF;

    IF NEW.system_action_access <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>System Action Access: ", NEW.system_action_access);
    END IF;

    IF NEW.date_assigned <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Date Assigned: ", NEW.date_assigned);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('role_system_action_permission', NEW.role_system_action_permission_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `role_system_action_permission_trigger_update`;
DELIMITER $$
CREATE TRIGGER `role_system_action_permission_trigger_update` AFTER UPDATE ON `role_system_action_permission` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.role_name <> OLD.role_name THEN
        SET audit_log = CONCAT(audit_log, "Role Name: ", OLD.role_name, " -> ", NEW.role_name, "<br/>");
    END IF;

    IF NEW.system_action_name <> OLD.system_action_name THEN
        SET audit_log = CONCAT(audit_log, "System Action: ", OLD.system_action_name, " -> ", NEW.system_action_name, "<br/>");
    END IF;

    IF NEW.system_action_access <> OLD.system_action_access THEN
        SET audit_log = CONCAT(audit_log, "System Action Access: ", OLD.system_action_access, " -> ", NEW.system_action_access, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('role_system_action_permission', NEW.role_system_action_permission_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `role_user_account`
--

DROP TABLE IF EXISTS `role_user_account`;
CREATE TABLE `role_user_account` (
  `role_user_account_id` int(10) UNSIGNED NOT NULL,
  `role_id` int(10) UNSIGNED NOT NULL,
  `role_name` varchar(100) NOT NULL,
  `user_account_id` int(10) UNSIGNED NOT NULL,
  `file_as` varchar(300) NOT NULL,
  `date_assigned` datetime NOT NULL DEFAULT current_timestamp(),
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `role_user_account`
--

INSERT INTO `role_user_account` (`role_user_account_id`, `role_id`, `role_name`, `user_account_id`, `file_as`, `date_assigned`, `created_date`, `last_log_by`) VALUES
(3, 1, 'Administrator', 2, 'Administrator', '2024-06-25 10:44:55', '2024-06-25 10:44:55', 1);

--
-- Triggers `role_user_account`
--
DROP TRIGGER IF EXISTS `role_user_account_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `role_user_account_trigger_insert` AFTER INSERT ON `role_user_account` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Role user account created. <br/>';

    IF NEW.role_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Role Name: ", NEW.role_name);
    END IF;

    IF NEW.file_as <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>User Account Name: ", NEW.file_as);
    END IF;

    IF NEW.date_assigned <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Date Assigned: ", NEW.date_assigned);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('role_user_account', NEW.role_user_account_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `role_user_account_trigger_update`;
DELIMITER $$
CREATE TRIGGER `role_user_account_trigger_update` AFTER UPDATE ON `role_user_account` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.role_name <> OLD.role_name THEN
        SET audit_log = CONCAT(audit_log, "Role Name: ", OLD.role_name, " -> ", NEW.role_name, "<br/>");
    END IF;

    IF NEW.file_as <> OLD.file_as THEN
        SET audit_log = CONCAT(audit_log, "User Account Name: ", OLD.file_as, " -> ", NEW.file_as, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('role_user_account', NEW.role_user_account_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `security_setting`
--

DROP TABLE IF EXISTS `security_setting`;
CREATE TABLE `security_setting` (
  `security_setting_id` int(10) UNSIGNED NOT NULL,
  `security_setting_name` varchar(100) NOT NULL,
  `value` varchar(1000) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `security_setting`
--

INSERT INTO `security_setting` (`security_setting_id`, `security_setting_name`, `value`, `created_date`, `last_log_by`) VALUES
(1, 'Max Failed Login Attempt', '5', '2024-06-17 21:34:43', 2),
(2, 'Max Failed OTP Attempt', '5', '2024-06-17 21:34:43', 2),
(3, 'Default Forgot Password Link', 'http://localhost/digify2/password-reset.php?id=', '2024-06-17 21:34:43', 2),
(4, 'Password Expiry Duration', '180', '2024-06-17 21:34:43', 2),
(5, 'Session Timeout Duration', '30', '2024-06-17 21:34:43', 2),
(6, 'OTP Duration', '5', '2024-06-17 21:34:43', 2),
(7, 'Reset Password Token Duration', '10', '2024-06-17 21:34:43', 2);

--
-- Triggers `security_setting`
--
DROP TRIGGER IF EXISTS `security_setting_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `security_setting_trigger_insert` AFTER INSERT ON `security_setting` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Security Setting created. <br/>';

    IF NEW.security_setting_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Security Setting Name: ", NEW.security_setting_name);
    END IF;

    IF NEW.value <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Value: ", NEW.value);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('security_setting', NEW.security_setting_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `security_setting_trigger_update`;
DELIMITER $$
CREATE TRIGGER `security_setting_trigger_update` AFTER UPDATE ON `security_setting` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.security_setting_name <> OLD.security_setting_name THEN
        SET audit_log = CONCAT(audit_log, "Security Setting Name: ", OLD.security_setting_name, " -> ", NEW.security_setting_name, "<br/>");
    END IF;

    IF NEW.value <> OLD.value THEN
        SET audit_log = CONCAT(audit_log, "Value: ", OLD.value, " -> ", NEW.value, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('security_setting', NEW.security_setting_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `state`
--

DROP TABLE IF EXISTS `state`;
CREATE TABLE `state` (
  `state_id` int(10) UNSIGNED NOT NULL,
  `state_name` varchar(100) NOT NULL,
  `country_id` int(10) UNSIGNED NOT NULL,
  `country_name` varchar(100) NOT NULL,
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `state`
--

INSERT INTO `state` (`state_id`, `state_name`, `country_id`, `country_name`, `last_log_by`) VALUES
(1, 'Nueva Ecija', 1, 'Philippines', 2);

--
-- Triggers `state`
--
DROP TRIGGER IF EXISTS `state_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `state_trigger_insert` AFTER INSERT ON `state` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'State created. <br/>';

    IF NEW.state_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>State Name: ", NEW.state_name);
    END IF;

    IF NEW.country_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Country: ", NEW.country_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('state', NEW.state_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `state_trigger_update`;
DELIMITER $$
CREATE TRIGGER `state_trigger_update` AFTER UPDATE ON `state` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.state_name <> OLD.state_name THEN
        SET audit_log = CONCAT(audit_log, "State Name: ", OLD.state_name, " -> ", NEW.state_name, "<br/>");
    END IF;

    IF NEW.country_name <> OLD.country_name THEN
        SET audit_log = CONCAT(audit_log, "Country: ", OLD.country_name, " -> ", NEW.country_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('state', NEW.state_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `system_action`
--

DROP TABLE IF EXISTS `system_action`;
CREATE TABLE `system_action` (
  `system_action_id` int(10) UNSIGNED NOT NULL,
  `system_action_name` varchar(100) NOT NULL,
  `system_action_description` varchar(200) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `system_action`
--

INSERT INTO `system_action` (`system_action_id`, `system_action_name`, `system_action_description`, `created_date`, `last_log_by`) VALUES
(1, 'Update System Settings', 'Access to update the system settings.', '2024-06-22 17:54:16', 1),
(2, 'Update Security Settings', 'Access to update the security settings.', '2024-06-22 17:54:16', 1),
(3, 'Activate User Account', 'Access to activate the user account.', '2024-06-22 17:54:16', 2),
(4, 'Deactivate User Account', 'Access to deactivate the user account.', '2024-06-22 17:54:16', 1),
(5, 'Lock User Account', 'Access to lock the user account.', '2024-06-22 17:54:16', 1),
(6, 'Unlock User Account', 'Access to unlock the user account.', '2024-06-22 17:54:16', 1),
(7, 'Add Role User Account', 'Access to assign roles to user account.', '2024-06-22 17:54:16', 1),
(8, 'Delete Role User Account', 'Access to delete roles to user account.', '2024-06-22 17:54:16', 1),
(9, 'Add Role Access', 'Access to add role access.', '2024-06-22 17:54:16', 1),
(10, 'Update Role Access', 'Access to update role access.', '2024-06-22 17:54:16', 1),
(11, 'Delete Role Access', 'Access to delete role access.', '2024-06-22 17:54:16', 1),
(12, 'Add Role System Action Access', 'Access to add the role system action access.', '2024-06-22 17:54:16', 1),
(13, 'Update Role System Action Access', 'Access to update the role system action access.', '2024-06-22 17:54:16', 1),
(14, 'Delete Role System Action Access', 'Access to delete the role system action access.', '2024-06-22 17:54:16', 1),
(15, 'Add File Extension Access', 'Access to assign the file extension to the upload setting.', '2024-06-22 17:54:16', 1),
(16, 'Delete File Extension Access', 'Access to delete the file extension to the upload setting.', '2024-06-22 17:54:16', 1);

--
-- Triggers `system_action`
--
DROP TRIGGER IF EXISTS `system_action_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `system_action_trigger_insert` AFTER INSERT ON `system_action` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'System action created. <br/>';

    IF NEW.system_action_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>System Action Name: ", NEW.system_action_name);
    END IF;

    IF NEW.system_action_description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>System Action Description: ", NEW.system_action_description);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('system_action', NEW.system_action_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `system_action_trigger_update`;
DELIMITER $$
CREATE TRIGGER `system_action_trigger_update` AFTER UPDATE ON `system_action` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.system_action_name <> OLD.system_action_name THEN
        SET audit_log = CONCAT(audit_log, "System Action Name: ", OLD.system_action_name, " -> ", NEW.system_action_name, "<br/>");
    END IF;

    IF NEW.system_action_description <> OLD.system_action_description THEN
        SET audit_log = CONCAT(audit_log, "System Action Description: ", OLD.system_action_description, " -> ", NEW.system_action_description, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('system_action', NEW.system_action_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `upload_setting`
--

DROP TABLE IF EXISTS `upload_setting`;
CREATE TABLE `upload_setting` (
  `upload_setting_id` int(10) UNSIGNED NOT NULL,
  `upload_setting_name` varchar(100) NOT NULL,
  `upload_setting_description` varchar(200) NOT NULL,
  `max_file_size` double NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `upload_setting`
--

INSERT INTO `upload_setting` (`upload_setting_id`, `upload_setting_name`, `upload_setting_description`, `max_file_size`, `created_date`, `last_log_by`) VALUES
(1, 'User Account Profile Picture', 'Sets the upload setting when uploading user account profile picture.', 800, '2024-06-21 12:11:40', 1),
(2, 'Internal Notes Attachment', 'Sets the upload setting when uploading internal notes attachement.', 800, '2024-06-21 12:26:58', 1),
(3, 'Company Logo', 'Sets the upload setting when uploading company logo.', 800, '2024-06-25 20:59:00', 2);

--
-- Triggers `upload_setting`
--
DROP TRIGGER IF EXISTS `upload_setting_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `upload_setting_trigger_insert` AFTER INSERT ON `upload_setting` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Upload Setting created. <br/>';

    IF NEW.upload_setting_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Upload Setting Name: ", NEW.upload_setting_name);
    END IF;

    IF NEW.upload_setting_description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Upload Setting Description: ", NEW.upload_setting_description);
    END IF;

    IF NEW.max_file_size <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Max File Size: ", NEW.max_file_size);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('upload_setting', NEW.upload_setting_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `upload_setting_trigger_update`;
DELIMITER $$
CREATE TRIGGER `upload_setting_trigger_update` AFTER UPDATE ON `upload_setting` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.upload_setting_name <> OLD.upload_setting_name THEN
        SET audit_log = CONCAT(audit_log, "Upload Setting Name: ", OLD.upload_setting_name, " -> ", NEW.upload_setting_name, "<br/>");
    END IF;

    IF NEW.upload_setting_description <> OLD.upload_setting_description THEN
        SET audit_log = CONCAT(audit_log, "Upload Setting Description: ", OLD.upload_setting_description, " -> ", NEW.upload_setting_description, "<br/>");
    END IF;

    IF NEW.max_file_size <> OLD.max_file_size THEN
        SET audit_log = CONCAT(audit_log, "Max File Size: ", OLD.max_file_size, " -> ", NEW.max_file_size, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('upload_setting', NEW.upload_setting_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `upload_setting_file_extension`
--

DROP TABLE IF EXISTS `upload_setting_file_extension`;
CREATE TABLE `upload_setting_file_extension` (
  `upload_setting_file_extension_id` int(10) UNSIGNED NOT NULL,
  `upload_setting_id` int(10) UNSIGNED NOT NULL,
  `upload_setting_name` varchar(100) NOT NULL,
  `file_extension_id` int(10) UNSIGNED NOT NULL,
  `file_extension_name` varchar(100) NOT NULL,
  `file_extension` varchar(10) NOT NULL,
  `date_assigned` datetime DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `upload_setting_file_extension`
--

INSERT INTO `upload_setting_file_extension` (`upload_setting_file_extension_id`, `upload_setting_id`, `upload_setting_name`, `file_extension_id`, `file_extension_name`, `file_extension`, `date_assigned`, `last_log_by`) VALUES
(1, 1, 'User Account Profile Picture', 1, 'PNG', 'png', '2024-06-21 12:11:40', 1),
(2, 1, 'User Account Profile Picture', 2, 'JPG', 'jpg', '2024-06-21 12:11:40', 1),
(3, 1, 'User Account Profile Picture', 3, 'JPEG', 'jpeg', '2024-06-21 12:11:40', 1),
(4, 2, 'Internal Notes Attachment', 1, 'PNG', 'png', '2024-06-21 12:26:58', 1),
(5, 2, 'Internal Notes Attachment', 2, 'JPG', 'jpg', '2024-06-21 12:26:58', 1),
(6, 2, 'Internal Notes Attachment', 3, 'JPEG', 'jpeg', '2024-06-21 12:26:58', 1),
(7, 2, 'Internal Notes Attachment', 4, 'PDF', 'pdf', '2024-06-21 12:26:58', 1),
(8, 3, 'Company Logo', 3, 'JPEG', 'jpeg', '2024-06-25 20:59:13', 2),
(9, 3, 'Company Logo', 2, 'JPG', 'jpg', '2024-06-25 20:59:13', 2),
(10, 3, 'Company Logo', 1, 'PNG', 'png', '2024-06-25 20:59:13', 2);

--
-- Triggers `upload_setting_file_extension`
--
DROP TRIGGER IF EXISTS `upload_setting_file_extension_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `upload_setting_file_extension_trigger_insert` AFTER INSERT ON `upload_setting_file_extension` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Upload Setting File Extension created. <br/>';

    IF NEW.upload_setting_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Upload Setting Name: ", NEW.upload_setting_name);
    END IF;

    IF NEW.file_extension_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>File Extension Name: ", NEW.file_extension_name);
    END IF;

    IF NEW.file_extension <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>File Extension: ", NEW.file_extension);
    END IF;

    IF NEW.date_assigned <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Date Assigned: ", NEW.date_assigned);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('upload_setting_file_extension', NEW.upload_setting_file_extension_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `user_account`
--

DROP TABLE IF EXISTS `user_account`;
CREATE TABLE `user_account` (
  `user_account_id` int(10) UNSIGNED NOT NULL,
  `file_as` varchar(300) NOT NULL,
  `email` varchar(255) NOT NULL,
  `password` varchar(255) NOT NULL,
  `profile_picture` varchar(500) DEFAULT NULL,
  `locked` varchar(5) NOT NULL DEFAULT 'No',
  `active` varchar(5) NOT NULL DEFAULT 'No',
  `last_failed_login_attempt` datetime DEFAULT NULL,
  `failed_login_attempts` int(11) NOT NULL DEFAULT 0,
  `last_connection_date` datetime DEFAULT NULL,
  `password_expiry_date` date NOT NULL,
  `reset_token` varchar(255) DEFAULT NULL,
  `reset_token_expiry_date` datetime DEFAULT NULL,
  `receive_notification` varchar(5) NOT NULL DEFAULT 'Yes',
  `two_factor_auth` varchar(5) NOT NULL DEFAULT 'Yes',
  `otp` varchar(255) DEFAULT NULL,
  `otp_expiry_date` datetime DEFAULT NULL,
  `failed_otp_attempts` int(11) NOT NULL DEFAULT 0,
  `last_password_change` datetime DEFAULT NULL,
  `account_lock_duration` int(11) NOT NULL DEFAULT 0,
  `last_password_reset` datetime DEFAULT NULL,
  `multiple_session` varchar(5) DEFAULT 'Yes',
  `session_token` varchar(255) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_account`
--

INSERT INTO `user_account` (`user_account_id`, `file_as`, `email`, `password`, `profile_picture`, `locked`, `active`, `last_failed_login_attempt`, `failed_login_attempts`, `last_connection_date`, `password_expiry_date`, `reset_token`, `reset_token_expiry_date`, `receive_notification`, `two_factor_auth`, `otp`, `otp_expiry_date`, `failed_otp_attempts`, `last_password_change`, `account_lock_duration`, `last_password_reset`, `multiple_session`, `session_token`, `created_date`, `last_log_by`) VALUES
(1, 'CGMI Bot', 'cgmids@christianmotors.ph', 'RYHObc8sNwIxdPDNJwCsO8bXKZJXYx7RjTgEWMC17FY%3D', NULL, 'No', 'Yes', NULL, 0, NULL, '2025-12-30', NULL, NULL, 'Yes', 'No', NULL, NULL, 0, NULL, 0, NULL, 'Yes', NULL, '2024-06-15 18:08:25', 1),
(2, 'Administrator', 'lawrenceagulto.317@gmail.com', 'RYHObc8sNwIxdPDNJwCsO8bXKZJXYx7RjTgEWMC17FY%3D', NULL, 'No', 'Yes', NULL, 0, '2024-06-25 22:22:34', '2025-12-30', NULL, NULL, 'Yes', 'No', NULL, NULL, 0, NULL, 0, NULL, 'Yes', '6ExTsbiwDQ%2FRcZKoJgwjFJSHlnix24r0LXM7KAT%2BIB8%3D', '2024-06-15 18:08:25', 2);

--
-- Triggers `user_account`
--
DROP TRIGGER IF EXISTS `user_account_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `user_account_trigger_insert` AFTER INSERT ON `user_account` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'User account created. <br/>';

    IF NEW.file_as <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>File As: ", NEW.file_as);
    END IF;

    IF NEW.email <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Email: ", NEW.email);
    END IF;

    IF NEW.locked <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Locked: ", NEW.locked);
    END IF;

    IF NEW.active <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Active: ", NEW.active);
    END IF;

    IF NEW.last_failed_login_attempt <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Last Failed Login Attempt: ", NEW.last_failed_login_attempt);
    END IF;

    IF NEW.failed_login_attempts <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Failed Login Attempts: ", NEW.failed_login_attempts);
    END IF;

    IF NEW.last_connection_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Last Connection Date: ", NEW.last_connection_date);
    END IF;

    IF NEW.password_expiry_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Password Expiry Date: ", NEW.password_expiry_date);
    END IF;

    IF NEW.receive_notification <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Receive Notification: ", NEW.receive_notification);
    END IF;

    IF NEW.two_factor_auth <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Two-Factor Authentication: ", NEW.two_factor_auth);
    END IF;

    IF NEW.last_password_change <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Last Password Change: ", NEW.last_password_change);
    END IF;

    IF NEW.last_password_reset <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Last Password Reset: ", NEW.last_password_reset);
    END IF;

    IF NEW.multiple_session <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Multiple Session: ", NEW.multiple_session);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('user_account', NEW.user_account_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `user_account_trigger_update`;
DELIMITER $$
CREATE TRIGGER `user_account_trigger_update` AFTER UPDATE ON `user_account` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.file_as <> OLD.file_as THEN
        SET audit_log = CONCAT(audit_log, "File As: ", OLD.file_as, " -> ", NEW.file_as, "<br/>");
    END IF;

    IF NEW.email <> OLD.email THEN
        SET audit_log = CONCAT(audit_log, "Email: ", OLD.email, " -> ", NEW.email, "<br/>");
    END IF;

    IF NEW.locked <> OLD.locked THEN
        SET audit_log = CONCAT(audit_log, "Locked: ", OLD.locked, " -> ", NEW.locked, "<br/>");
    END IF;

    IF NEW.active <> OLD.active THEN
        SET audit_log = CONCAT(audit_log, "Active: ", OLD.active, " -> ", NEW.active, "<br/>");
    END IF;

    IF NEW.last_failed_login_attempt <> OLD.last_failed_login_attempt THEN
        SET audit_log = CONCAT(audit_log, "Last Failed Login Attempt: ", OLD.last_failed_login_attempt, " -> ", NEW.last_failed_login_attempt, "<br/>");
    END IF;

    IF NEW.failed_login_attempts <> OLD.failed_login_attempts THEN
        SET audit_log = CONCAT(audit_log, "Failed Login Attempts: ", OLD.failed_login_attempts, " -> ", NEW.failed_login_attempts, "<br/>");
    END IF;

    IF NEW.last_connection_date <> OLD.last_connection_date THEN
        SET audit_log = CONCAT(audit_log, "Last Connection Date: ", OLD.last_connection_date, " -> ", NEW.last_connection_date, "<br/>");
    END IF;

    IF NEW.password_expiry_date <> OLD.password_expiry_date THEN
        SET audit_log = CONCAT(audit_log, "Password Expiry Date: ", OLD.password_expiry_date, " -> ", NEW.password_expiry_date, "<br/>");
    END IF;

    IF NEW.receive_notification <> OLD.receive_notification THEN
        SET audit_log = CONCAT(audit_log, "Receive Notification: ", OLD.receive_notification, " -> ", NEW.receive_notification, "<br/>");
    END IF;

    IF NEW.two_factor_auth <> OLD.two_factor_auth THEN
        SET audit_log = CONCAT(audit_log, "Two-Factor Authentication: ", OLD.two_factor_auth, " -> ", NEW.two_factor_auth, "<br/>");
    END IF;

    IF NEW.last_password_change <> OLD.last_password_change THEN
        SET audit_log = CONCAT(audit_log, "Last Password Change: ", OLD.last_password_change, " -> ", NEW.last_password_change, "<br/>");
    END IF;

    IF NEW.last_password_reset <> OLD.last_password_reset THEN
        SET audit_log = CONCAT(audit_log, "Last Password Reset: ", OLD.last_password_reset, " -> ", NEW.last_password_reset, "<br/>");
    END IF;

    IF NEW.multiple_session <> OLD.multiple_session THEN
        SET audit_log = CONCAT(audit_log, "Multiple Session: ", OLD.multiple_session, " -> ", NEW.multiple_session, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('user_account', NEW.user_account_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `app_module`
--
ALTER TABLE `app_module`
  ADD PRIMARY KEY (`app_module_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `app_module_index_app_module_id` (`app_module_id`),
  ADD KEY `app_module_index_menu_item_id` (`menu_item_id`);

--
-- Indexes for table `audit_log`
--
ALTER TABLE `audit_log`
  ADD PRIMARY KEY (`audit_log_id`),
  ADD KEY `audit_log_index_audit_log_id` (`audit_log_id`),
  ADD KEY `audit_log_index_table_name` (`table_name`),
  ADD KEY `audit_log_index_reference_id` (`reference_id`),
  ADD KEY `audit_log_index_changed_by` (`changed_by`);

--
-- Indexes for table `city`
--
ALTER TABLE `city`
  ADD PRIMARY KEY (`city_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `city_index_city_id` (`city_id`),
  ADD KEY `city_index_state_id` (`state_id`),
  ADD KEY `city_index_country_id` (`country_id`);

--
-- Indexes for table `company`
--
ALTER TABLE `company`
  ADD PRIMARY KEY (`company_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `company_index_company_id` (`company_id`),
  ADD KEY `company_index_city_id` (`city_id`),
  ADD KEY `company_index_state_id` (`state_id`),
  ADD KEY `company_index_country_id` (`country_id`),
  ADD KEY `company_index_currency_id` (`currency_id`);

--
-- Indexes for table `country`
--
ALTER TABLE `country`
  ADD PRIMARY KEY (`country_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `country_index_country_id` (`country_id`);

--
-- Indexes for table `currency`
--
ALTER TABLE `currency`
  ADD PRIMARY KEY (`currency_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `currency_index_currency_id` (`currency_id`);

--
-- Indexes for table `email_setting`
--
ALTER TABLE `email_setting`
  ADD PRIMARY KEY (`email_setting_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `email_setting_index_email_setting_id` (`email_setting_id`);

--
-- Indexes for table `file_extension`
--
ALTER TABLE `file_extension`
  ADD PRIMARY KEY (`file_extension_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `file_extension_index_file_extension_id` (`file_extension_id`),
  ADD KEY `file_extension_index_file_type_id` (`file_type_id`);

--
-- Indexes for table `file_type`
--
ALTER TABLE `file_type`
  ADD PRIMARY KEY (`file_type_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `file_type_index_file_type_id` (`file_type_id`);

--
-- Indexes for table `internal_notes`
--
ALTER TABLE `internal_notes`
  ADD PRIMARY KEY (`internal_notes_id`),
  ADD KEY `internal_note_by` (`internal_note_by`),
  ADD KEY `internal_notes_index_internal_notes_id` (`internal_notes_id`),
  ADD KEY `internal_notes_index_table_name` (`table_name`),
  ADD KEY `internal_notes_index_reference_id` (`reference_id`);

--
-- Indexes for table `internal_notes_attachment`
--
ALTER TABLE `internal_notes_attachment`
  ADD PRIMARY KEY (`internal_notes_attachment_id`),
  ADD KEY `internal_notes_attachment_index_internal_notes_id` (`internal_notes_attachment_id`),
  ADD KEY `internal_notes_attachment_index_table_name` (`internal_notes_id`);

--
-- Indexes for table `menu_group`
--
ALTER TABLE `menu_group`
  ADD PRIMARY KEY (`menu_group_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `app_module_id` (`app_module_id`),
  ADD KEY `menu_group_index_menu_group_id` (`menu_group_id`);

--
-- Indexes for table `menu_item`
--
ALTER TABLE `menu_item`
  ADD PRIMARY KEY (`menu_item_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `menu_group_id` (`menu_group_id`),
  ADD KEY `menu_item_index_menu_item_id` (`menu_item_id`),
  ADD KEY `menu_item_index_app_module_id` (`app_module_id`);

--
-- Indexes for table `notification_setting`
--
ALTER TABLE `notification_setting`
  ADD PRIMARY KEY (`notification_setting_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `notification_setting_index_notification_setting_id` (`notification_setting_id`);

--
-- Indexes for table `notification_setting_email_template`
--
ALTER TABLE `notification_setting_email_template`
  ADD PRIMARY KEY (`notification_setting_email_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `notification_setting_email_index_notification_setting_email_id` (`notification_setting_email_id`),
  ADD KEY `notification_setting_email_index_notification_setting_id` (`notification_setting_id`);

--
-- Indexes for table `notification_setting_sms_template`
--
ALTER TABLE `notification_setting_sms_template`
  ADD PRIMARY KEY (`notification_setting_sms_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `notification_setting_sms_index_notification_setting_sms_id` (`notification_setting_sms_id`),
  ADD KEY `notification_setting_sms_index_notification_setting_id` (`notification_setting_id`);

--
-- Indexes for table `notification_setting_system_template`
--
ALTER TABLE `notification_setting_system_template`
  ADD PRIMARY KEY (`notification_setting_system_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `notification_setting_system_index_notification_setting_system_id` (`notification_setting_system_id`),
  ADD KEY `notification_setting_system_index_notification_setting_id` (`notification_setting_id`);

--
-- Indexes for table `password_history`
--
ALTER TABLE `password_history`
  ADD PRIMARY KEY (`password_history_id`),
  ADD KEY `password_history_index_password_history_id` (`password_history_id`),
  ADD KEY `password_history_index_user_account_id` (`user_account_id`),
  ADD KEY `password_history_index_email` (`email`);

--
-- Indexes for table `role`
--
ALTER TABLE `role`
  ADD PRIMARY KEY (`role_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `role_index_role_id` (`role_id`);

--
-- Indexes for table `role_permission`
--
ALTER TABLE `role_permission`
  ADD PRIMARY KEY (`role_permission_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `role_permission_index_role_permission_id` (`role_permission_id`),
  ADD KEY `role_permission_index_menu_item_id` (`menu_item_id`),
  ADD KEY `role_permission_index_role_id` (`role_id`);

--
-- Indexes for table `role_system_action_permission`
--
ALTER TABLE `role_system_action_permission`
  ADD PRIMARY KEY (`role_system_action_permission_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `role_system_action_permission_index_system_action_permission_id` (`role_system_action_permission_id`),
  ADD KEY `role_system_action_permission_index_system_action_id` (`system_action_id`),
  ADD KEY `role_system_action_permissionn_index_role_id` (`role_id`);

--
-- Indexes for table `role_user_account`
--
ALTER TABLE `role_user_account`
  ADD PRIMARY KEY (`role_user_account_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `role_user_account_index_role_user_account_id` (`role_user_account_id`),
  ADD KEY `role_user_account_permission_index_user_account_id` (`user_account_id`),
  ADD KEY `role_user_account_permissionn_index_role_id` (`role_id`);

--
-- Indexes for table `security_setting`
--
ALTER TABLE `security_setting`
  ADD PRIMARY KEY (`security_setting_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `security_setting_index_security_setting_id` (`security_setting_id`);

--
-- Indexes for table `state`
--
ALTER TABLE `state`
  ADD PRIMARY KEY (`state_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `state_index_state_id` (`state_id`),
  ADD KEY `state_index_country_id` (`country_id`);

--
-- Indexes for table `system_action`
--
ALTER TABLE `system_action`
  ADD PRIMARY KEY (`system_action_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `system_action_index_system_action_id` (`system_action_id`);

--
-- Indexes for table `upload_setting`
--
ALTER TABLE `upload_setting`
  ADD PRIMARY KEY (`upload_setting_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `upload_setting_index_upload_setting_id` (`upload_setting_id`);

--
-- Indexes for table `upload_setting_file_extension`
--
ALTER TABLE `upload_setting_file_extension`
  ADD PRIMARY KEY (`upload_setting_file_extension_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `upload_setting_file_ext_index_upload_setting_file_extension_id` (`upload_setting_file_extension_id`),
  ADD KEY `upload_setting_file_ext_index_upload_setting_id` (`upload_setting_id`),
  ADD KEY `upload_setting_file_ext_index_file_extension_id` (`file_extension_id`);

--
-- Indexes for table `user_account`
--
ALTER TABLE `user_account`
  ADD PRIMARY KEY (`user_account_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `user_account_index_user_account_id` (`user_account_id`),
  ADD KEY `user_account_index_email` (`email`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `app_module`
--
ALTER TABLE `app_module`
  MODIFY `app_module_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `audit_log`
--
ALTER TABLE `audit_log`
  MODIFY `audit_log_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=200;

--
-- AUTO_INCREMENT for table `city`
--
ALTER TABLE `city`
  MODIFY `city_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `company`
--
ALTER TABLE `company`
  MODIFY `company_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `country`
--
ALTER TABLE `country`
  MODIFY `country_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `currency`
--
ALTER TABLE `currency`
  MODIFY `currency_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `email_setting`
--
ALTER TABLE `email_setting`
  MODIFY `email_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `file_extension`
--
ALTER TABLE `file_extension`
  MODIFY `file_extension_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `file_type`
--
ALTER TABLE `file_type`
  MODIFY `file_type_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `internal_notes`
--
ALTER TABLE `internal_notes`
  MODIFY `internal_notes_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `internal_notes_attachment`
--
ALTER TABLE `internal_notes_attachment`
  MODIFY `internal_notes_attachment_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `menu_group`
--
ALTER TABLE `menu_group`
  MODIFY `menu_group_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `menu_item`
--
ALTER TABLE `menu_item`
  MODIFY `menu_item_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `notification_setting`
--
ALTER TABLE `notification_setting`
  MODIFY `notification_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `notification_setting_email_template`
--
ALTER TABLE `notification_setting_email_template`
  MODIFY `notification_setting_email_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `notification_setting_sms_template`
--
ALTER TABLE `notification_setting_sms_template`
  MODIFY `notification_setting_sms_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `notification_setting_system_template`
--
ALTER TABLE `notification_setting_system_template`
  MODIFY `notification_setting_system_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `password_history`
--
ALTER TABLE `password_history`
  MODIFY `password_history_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `role`
--
ALTER TABLE `role`
  MODIFY `role_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `role_permission`
--
ALTER TABLE `role_permission`
  MODIFY `role_permission_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=22;

--
-- AUTO_INCREMENT for table `role_system_action_permission`
--
ALTER TABLE `role_system_action_permission`
  MODIFY `role_system_action_permission_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `role_user_account`
--
ALTER TABLE `role_user_account`
  MODIFY `role_user_account_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `security_setting`
--
ALTER TABLE `security_setting`
  MODIFY `security_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `state`
--
ALTER TABLE `state`
  MODIFY `state_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `system_action`
--
ALTER TABLE `system_action`
  MODIFY `system_action_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `upload_setting`
--
ALTER TABLE `upload_setting`
  MODIFY `upload_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `upload_setting_file_extension`
--
ALTER TABLE `upload_setting_file_extension`
  MODIFY `upload_setting_file_extension_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `user_account`
--
ALTER TABLE `user_account`
  MODIFY `user_account_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `app_module`
--
ALTER TABLE `app_module`
  ADD CONSTRAINT `app_module_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `audit_log`
--
ALTER TABLE `audit_log`
  ADD CONSTRAINT `audit_log_ibfk_1` FOREIGN KEY (`changed_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `city`
--
ALTER TABLE `city`
  ADD CONSTRAINT `city_ibfk_1` FOREIGN KEY (`country_id`) REFERENCES `country` (`country_id`),
  ADD CONSTRAINT `city_ibfk_2` FOREIGN KEY (`state_id`) REFERENCES `state` (`state_id`),
  ADD CONSTRAINT `city_ibfk_3` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `company`
--
ALTER TABLE `company`
  ADD CONSTRAINT `company_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `country`
--
ALTER TABLE `country`
  ADD CONSTRAINT `country_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `currency`
--
ALTER TABLE `currency`
  ADD CONSTRAINT `currency_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `email_setting`
--
ALTER TABLE `email_setting`
  ADD CONSTRAINT `email_setting_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `file_extension`
--
ALTER TABLE `file_extension`
  ADD CONSTRAINT `file_extension_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `file_type`
--
ALTER TABLE `file_type`
  ADD CONSTRAINT `file_type_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `internal_notes`
--
ALTER TABLE `internal_notes`
  ADD CONSTRAINT `internal_notes_ibfk_1` FOREIGN KEY (`internal_note_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `internal_notes_attachment`
--
ALTER TABLE `internal_notes_attachment`
  ADD CONSTRAINT `internal_notes_attachment_ibfk_1` FOREIGN KEY (`internal_notes_id`) REFERENCES `internal_notes` (`internal_notes_id`);

--
-- Constraints for table `menu_group`
--
ALTER TABLE `menu_group`
  ADD CONSTRAINT `menu_group_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`),
  ADD CONSTRAINT `menu_group_ibfk_2` FOREIGN KEY (`app_module_id`) REFERENCES `app_module` (`app_module_id`);

--
-- Constraints for table `menu_item`
--
ALTER TABLE `menu_item`
  ADD CONSTRAINT `menu_item_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`),
  ADD CONSTRAINT `menu_item_ibfk_2` FOREIGN KEY (`menu_group_id`) REFERENCES `menu_group` (`menu_group_id`),
  ADD CONSTRAINT `menu_item_ibfk_3` FOREIGN KEY (`app_module_id`) REFERENCES `app_module` (`app_module_id`);

--
-- Constraints for table `notification_setting`
--
ALTER TABLE `notification_setting`
  ADD CONSTRAINT `notification_setting_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `notification_setting_email_template`
--
ALTER TABLE `notification_setting_email_template`
  ADD CONSTRAINT `notification_setting_email_template_ibfk_1` FOREIGN KEY (`notification_setting_id`) REFERENCES `notification_setting` (`notification_setting_id`),
  ADD CONSTRAINT `notification_setting_email_template_ibfk_2` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `notification_setting_sms_template`
--
ALTER TABLE `notification_setting_sms_template`
  ADD CONSTRAINT `notification_setting_sms_template_ibfk_1` FOREIGN KEY (`notification_setting_id`) REFERENCES `notification_setting` (`notification_setting_id`),
  ADD CONSTRAINT `notification_setting_sms_template_ibfk_2` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `notification_setting_system_template`
--
ALTER TABLE `notification_setting_system_template`
  ADD CONSTRAINT `notification_setting_system_template_ibfk_1` FOREIGN KEY (`notification_setting_id`) REFERENCES `notification_setting` (`notification_setting_id`),
  ADD CONSTRAINT `notification_setting_system_template_ibfk_2` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `password_history`
--
ALTER TABLE `password_history`
  ADD CONSTRAINT `password_history_ibfk_1` FOREIGN KEY (`user_account_id`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `role`
--
ALTER TABLE `role`
  ADD CONSTRAINT `role_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `role_permission`
--
ALTER TABLE `role_permission`
  ADD CONSTRAINT `role_permission_ibfk_1` FOREIGN KEY (`menu_item_id`) REFERENCES `menu_item` (`menu_item_id`),
  ADD CONSTRAINT `role_permission_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`),
  ADD CONSTRAINT `role_permission_ibfk_3` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `role_system_action_permission`
--
ALTER TABLE `role_system_action_permission`
  ADD CONSTRAINT `role_system_action_permission_ibfk_1` FOREIGN KEY (`system_action_id`) REFERENCES `system_action` (`system_action_id`),
  ADD CONSTRAINT `role_system_action_permission_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`),
  ADD CONSTRAINT `role_system_action_permission_ibfk_3` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `role_user_account`
--
ALTER TABLE `role_user_account`
  ADD CONSTRAINT `role_user_account_ibfk_1` FOREIGN KEY (`user_account_id`) REFERENCES `user_account` (`user_account_id`),
  ADD CONSTRAINT `role_user_account_ibfk_2` FOREIGN KEY (`role_id`) REFERENCES `role` (`role_id`),
  ADD CONSTRAINT `role_user_account_ibfk_3` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `security_setting`
--
ALTER TABLE `security_setting`
  ADD CONSTRAINT `security_setting_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `state`
--
ALTER TABLE `state`
  ADD CONSTRAINT `state_ibfk_1` FOREIGN KEY (`country_id`) REFERENCES `country` (`country_id`),
  ADD CONSTRAINT `state_ibfk_2` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `system_action`
--
ALTER TABLE `system_action`
  ADD CONSTRAINT `system_action_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `upload_setting`
--
ALTER TABLE `upload_setting`
  ADD CONSTRAINT `upload_setting_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `upload_setting_file_extension`
--
ALTER TABLE `upload_setting_file_extension`
  ADD CONSTRAINT `upload_setting_file_extension_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `user_account`
--
ALTER TABLE `user_account`
  ADD CONSTRAINT `user_account_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
