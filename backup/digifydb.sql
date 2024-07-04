-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Jul 04, 2024 at 11:29 AM
-- Server version: 10.4.32-MariaDB
-- PHP Version: 8.2.12

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
    SELECT DISTINCT(am.app_module_id) as app_module_id, am.app_module_name, am.menu_item_id, app_logo, app_version, app_module_description
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
    ORDER BY am.order_sequence, am.app_module_name;
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
    ORDER BY mi.order_sequence, mi.menu_item_name;
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

DROP PROCEDURE IF EXISTS `checkAddressTypeExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkAddressTypeExist` (IN `p_address_type_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM address_type
    WHERE address_type_id = p_address_type_id;
END$$

DROP PROCEDURE IF EXISTS `checkAppModuleExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkAppModuleExist` (IN `p_app_module_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM app_module
    WHERE app_module_id = p_app_module_id;
END$$

DROP PROCEDURE IF EXISTS `checkBankAccountTypeExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkBankAccountTypeExist` (IN `p_bank_account_type_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM bank_account_type
    WHERE bank_account_type_id = p_bank_account_type_id;
END$$

DROP PROCEDURE IF EXISTS `checkBankExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkBankExist` (IN `p_bank_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM bank
    WHERE bank_id = p_bank_id;
END$$

DROP PROCEDURE IF EXISTS `checkBloodTypeExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkBloodTypeExist` (IN `p_blood_type_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM blood_type
    WHERE blood_type_id = p_blood_type_id;
END$$

DROP PROCEDURE IF EXISTS `checkCityExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkCityExist` (IN `p_city_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM city
    WHERE city_id = p_city_id;
END$$

DROP PROCEDURE IF EXISTS `checkCivilStatusExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkCivilStatusExist` (IN `p_civil_status_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM civil_status
    WHERE civil_status_id = p_civil_status_id;
END$$

DROP PROCEDURE IF EXISTS `checkCompanyExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkCompanyExist` (IN `p_company_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM company
    WHERE company_id = p_company_id;
END$$

DROP PROCEDURE IF EXISTS `checkContactInformationTypeExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkContactInformationTypeExist` (IN `p_contact_information_type_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM contact_information_type
    WHERE contact_information_type_id = p_contact_information_type_id;
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

DROP PROCEDURE IF EXISTS `checkDepartmentExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkDepartmentExist` (IN `p_department_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM department
    WHERE department_id = p_department_id;
END$$

DROP PROCEDURE IF EXISTS `checkDepartureReasonExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkDepartureReasonExist` (IN `p_departure_reason_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM departure_reason
    WHERE departure_reason_id = p_departure_reason_id;
END$$

DROP PROCEDURE IF EXISTS `checkEducationalStageExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkEducationalStageExist` (IN `p_educational_stage_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM educational_stage
    WHERE educational_stage_id = p_educational_stage_id;
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

DROP PROCEDURE IF EXISTS `checkEmploymentTypeExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkEmploymentTypeExist` (IN `p_employment_type_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM employment_type
    WHERE employment_type_id = p_employment_type_id;
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

DROP PROCEDURE IF EXISTS `checkGenderExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkGenderExist` (IN `p_gender_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM gender
    WHERE gender_id = p_gender_id;
END$$

DROP PROCEDURE IF EXISTS `checkIDTypeExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkIDTypeExist` (IN `p_id_type_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM id_type
    WHERE id_type_id = p_id_type_id;
END$$

DROP PROCEDURE IF EXISTS `checkJobPositionExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkJobPositionExist` (IN `p_job_position_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM job_position
    WHERE job_position_id = p_job_position_id;
END$$

DROP PROCEDURE IF EXISTS `checkLanguageExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkLanguageExist` (IN `p_language_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM language
    WHERE language_id = p_language_id;
END$$

DROP PROCEDURE IF EXISTS `checkLanguageProficiencyExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkLanguageProficiencyExist` (IN `p_language_proficiency_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM language_proficiency
    WHERE language_proficiency_id = p_language_proficiency_id;
END$$

DROP PROCEDURE IF EXISTS `checkLoginCredentialsExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkLoginCredentialsExist` (IN `p_user_account_id` INT, IN `p_credentials` VARCHAR(255))   BEGIN
	SELECT COUNT(*) AS total
    FROM user_account
    WHERE user_account_id = p_user_account_id OR username = p_credentials OR email = p_credentials;
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

DROP PROCEDURE IF EXISTS `checkRelationExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkRelationExist` (IN `p_relation_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM relation
    WHERE relation_id = p_relation_id;
END$$

DROP PROCEDURE IF EXISTS `checkReligionExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkReligionExist` (IN `p_religion_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM religion
    WHERE religion_id = p_religion_id;
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

DROP PROCEDURE IF EXISTS `checkScheduleTypeExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkScheduleTypeExist` (IN `p_schedule_type_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM schedule_type
    WHERE schedule_type_id = p_schedule_type_id;
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

DROP PROCEDURE IF EXISTS `checkUICustomizationSettingExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkUICustomizationSettingExist` (IN `p_user_account__id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM ui_customization_setting
	WHERE user_account_id = p_user_account__id;
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

DROP PROCEDURE IF EXISTS `checkWorkHoursExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkWorkHoursExist` (IN `p_work_hours_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM work_hours
    WHERE work_hours_id = p_work_hours_id;
END$$

DROP PROCEDURE IF EXISTS `checkWorkHoursOverlap`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkWorkHoursOverlap` (IN `p_work_hours_id` INT, IN `p_work_schedule_id` INT, IN `p_day_of_week` VARCHAR(20), IN `p_day_period` VARCHAR(20), IN `p_start_time` TIME, IN `p_end_time` TIME)   BEGIN
    IF p_work_hours_id IS NOT NULL OR p_work_hours_id <> '' THEN
        SELECT COUNT(*) AS total
        FROM work_hours
        WHERE work_hours_id != p_work_hours_id
        AND work_schedule_id = p_work_schedule_id
        AND day_of_week = p_day_of_week
        AND (start_time BETWEEN p_start_time AND p_end_time OR end_time BETWEEN p_start_time AND p_end_time);
    ELSE
        SELECT COUNT(*) AS total
        FROM work_hours
        WHERE work_hours_id != p_work_hours_id
        AND day_of_week = p_day_of_week
        AND (start_time BETWEEN p_start_time AND p_end_time OR end_time BETWEEN p_start_time AND p_end_time);
    END IF;
END$$

DROP PROCEDURE IF EXISTS `checkWorkLocationExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkWorkLocationExist` (IN `p_work_location_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM work_location
    WHERE work_location_id = p_work_location_id;
END$$

DROP PROCEDURE IF EXISTS `checkWorkScheduleExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkWorkScheduleExist` (IN `p_work_schedule_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM work_schedule
    WHERE work_schedule_id = p_work_schedule_id;
END$$

DROP PROCEDURE IF EXISTS `deleteAddressType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteAddressType` (IN `p_address_type_id` INT)   BEGIN
    DELETE FROM address_type WHERE address_type_id = p_address_type_id;
END$$

DROP PROCEDURE IF EXISTS `deleteAppModule`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteAppModule` (IN `p_app_module_id` INT)   BEGIN
    DELETE FROM app_module WHERE app_module_id = p_app_module_id;
END$$

DROP PROCEDURE IF EXISTS `deleteBank`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteBank` (IN `p_bank_id` INT)   BEGIN
    DELETE FROM bank WHERE bank_id = p_bank_id;
END$$

DROP PROCEDURE IF EXISTS `deleteBankAccountType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteBankAccountType` (IN `p_bank_account_type_id` INT)   BEGIN
    DELETE FROM bank_account_type WHERE bank_account_type_id = p_bank_account_type_id;
END$$

DROP PROCEDURE IF EXISTS `deleteBloodType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteBloodType` (IN `p_blood_type_id` INT)   BEGIN
    DELETE FROM blood_type WHERE blood_type_id = p_blood_type_id;
END$$

DROP PROCEDURE IF EXISTS `deleteCity`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCity` (IN `p_city_id` INT)   BEGIN
    DELETE FROM city WHERE city_id = p_city_id;
END$$

DROP PROCEDURE IF EXISTS `deleteCivilStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCivilStatus` (IN `p_civil_status_id` INT)   BEGIN
    DELETE FROM civil_status WHERE civil_status_id = p_civil_status_id;
END$$

DROP PROCEDURE IF EXISTS `deleteCompany`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCompany` (IN `p_company_id` INT)   BEGIN
    DELETE FROM company WHERE company_id = p_company_id;
END$$

DROP PROCEDURE IF EXISTS `deleteContactInformationType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteContactInformationType` (IN `p_contact_information_type_id` INT)   BEGIN
    DELETE FROM contact_information_type WHERE contact_information_type_id = p_contact_information_type_id;
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

DROP PROCEDURE IF EXISTS `deleteDepartment`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteDepartment` (IN `p_department_id` INT)   BEGIN
    DELETE FROM department WHERE department_id = p_department_id;
END$$

DROP PROCEDURE IF EXISTS `deleteDepartureReason`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteDepartureReason` (IN `p_departure_reason_id` INT)   BEGIN
    DELETE FROM departure_reason WHERE departure_reason_id = p_departure_reason_id;
END$$

DROP PROCEDURE IF EXISTS `deleteEducationalStage`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteEducationalStage` (IN `p_educational_stage_id` INT)   BEGIN
    DELETE FROM educational_stage WHERE educational_stage_id = p_educational_stage_id;
END$$

DROP PROCEDURE IF EXISTS `deleteEmailSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteEmailSetting` (IN `p_email_setting_id` INT)   BEGIN
   DELETE FROM email_setting WHERE email_setting_id = p_email_setting_id;
END$$

DROP PROCEDURE IF EXISTS `deleteEmploymentType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteEmploymentType` (IN `p_employment_type_id` INT)   BEGIN
    DELETE FROM employment_type WHERE employment_type_id = p_employment_type_id;
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

DROP PROCEDURE IF EXISTS `deleteGender`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteGender` (IN `p_gender_id` INT)   BEGIN
    DELETE FROM gender WHERE gender_id = p_gender_id;
END$$

DROP PROCEDURE IF EXISTS `deleteIDType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteIDType` (IN `p_id_type_id` INT)   BEGIN
    DELETE FROM id_type WHERE id_type_id = p_id_type_id;
END$$

DROP PROCEDURE IF EXISTS `deleteJobPosition`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteJobPosition` (IN `p_job_position_id` INT)   BEGIN
    DELETE FROM job_position WHERE job_position_id = p_job_position_id;
END$$

DROP PROCEDURE IF EXISTS `deleteLanguage`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteLanguage` (IN `p_language_id` INT)   BEGIN
    DELETE FROM language WHERE language_id = p_language_id;
END$$

DROP PROCEDURE IF EXISTS `deleteLanguageProficiency`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteLanguageProficiency` (IN `p_language_proficiency_id` INT)   BEGIN
    DELETE FROM language_proficiency WHERE language_proficiency_id = p_language_proficiency_id;
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

DROP PROCEDURE IF EXISTS `deleteRelation`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteRelation` (IN `p_relation_id` INT)   BEGIN
    DELETE FROM relation WHERE relation_id = p_relation_id;
END$$

DROP PROCEDURE IF EXISTS `deleteReligion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteReligion` (IN `p_religion_id` INT)   BEGIN
    DELETE FROM religion WHERE religion_id = p_religion_id;
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
    DELETE FROM role_user_account WHERE role_id = p_role_id;
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

DROP PROCEDURE IF EXISTS `deleteScheduleType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteScheduleType` (IN `p_schedule_type_id` INT)   BEGIN
    DELETE FROM schedule_type WHERE schedule_type_id = p_schedule_type_id;
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

DROP PROCEDURE IF EXISTS `deleteWorkHours`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteWorkHours` (IN `p_work_hours_id` INT)   BEGIN
    DELETE FROM work_hours WHERE work_hours_id = p_work_hours_id;
END$$

DROP PROCEDURE IF EXISTS `deleteWorkLocation`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteWorkLocation` (IN `p_work_location_id` INT)   BEGIN
    DELETE FROM work_location WHERE work_location_id = p_work_location_id;
END$$

DROP PROCEDURE IF EXISTS `deleteWorkSchedule`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteWorkSchedule` (IN `p_work_schedule_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM work_hours WHERE work_schedule_id = p_work_schedule_id;
    DELETE FROM work_schedule WHERE work_schedule_id = p_work_schedule_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `generateAddressTypeOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateAddressTypeOptions` ()   BEGIN
	SELECT address_type_id, address_type_name 
    FROM address_type 
    ORDER BY address_type_name;
END$$

DROP PROCEDURE IF EXISTS `generateAddressTypeTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateAddressTypeTable` ()   BEGIN
	SELECT address_type_id, address_type_name 
    FROM address_type 
    ORDER BY address_type_id;
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

DROP PROCEDURE IF EXISTS `generateBankAccountTypeOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateBankAccountTypeOptions` ()   BEGIN
	SELECT bank_account_type_id, bank_account_type_name 
    FROM bank_account_type 
    ORDER BY bank_account_type_name;
END$$

DROP PROCEDURE IF EXISTS `generateBankAccountTypeTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateBankAccountTypeTable` ()   BEGIN
	SELECT bank_account_type_id, bank_account_type_name 
    FROM bank_account_type 
    ORDER BY bank_account_type_id;
END$$

DROP PROCEDURE IF EXISTS `generateBankOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateBankOptions` ()   BEGIN
	SELECT bank_id, bank_name
    FROM bank 
    ORDER BY bank_name;
END$$

DROP PROCEDURE IF EXISTS `generateBankTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateBankTable` ()   BEGIN
	SELECT bank_id, bank_name, bank_identifier_code
    FROM bank 
    ORDER BY bank_id;
END$$

DROP PROCEDURE IF EXISTS `generateBloodTypeOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateBloodTypeOptions` ()   BEGIN
	SELECT blood_type_id, blood_type_name 
    FROM blood_type 
    ORDER BY blood_type_name;
END$$

DROP PROCEDURE IF EXISTS `generateBloodTypeTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateBloodTypeTable` ()   BEGIN
	SELECT blood_type_id, blood_type_name 
    FROM blood_type 
    ORDER BY blood_type_id;
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

    IF p_filter_by_state IS NOT NULL AND p_filter_by_state != '' THEN
        SET query = CONCAT(query, ' AND state_id = ', p_filter_by_state);
    END IF;

    IF p_filter_by_country IS NOT NULL AND p_filter_by_country != '' THEN
        SET query = CONCAT(query, ' AND country_id = ', p_filter_by_country);
    END IF;

    SET query = CONCAT(query, ' ORDER BY city_name');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS `generateCivilStatusOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateCivilStatusOptions` ()   BEGIN
	SELECT civil_status_id, civil_status_name 
    FROM civil_status 
    ORDER BY civil_status_name;
END$$

DROP PROCEDURE IF EXISTS `generateCivilStatusTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateCivilStatusTable` ()   BEGIN
	SELECT civil_status_id, civil_status_name 
    FROM civil_status 
    ORDER BY civil_status_id;
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

    IF p_filter_by_city IS NOT NULL AND p_filter_by_city != '' THEN
        SET query = CONCAT(query, ' AND city_id = ', p_filter_by_city);
    END IF;

    IF p_filter_by_state IS NOT NULL AND p_filter_by_state != '' THEN
        SET query = CONCAT(query, ' AND state_id = ', p_filter_by_state);
    END IF;

    IF p_filter_by_country IS NOT NULL AND p_filter_by_country != '' THEN
        SET query = CONCAT(query, ' AND country_id = ', p_filter_by_country);
    END IF;

    SET query = CONCAT(query, ' ORDER BY company_name');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS `generateContactInformationTypeOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateContactInformationTypeOptions` ()   BEGIN
	SELECT contact_information_type_id, contact_information_type_name 
    FROM contact_information_type 
    ORDER BY contact_information_type_name;
END$$

DROP PROCEDURE IF EXISTS `generateContactInformationTypeTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateContactInformationTypeTable` ()   BEGIN
	SELECT contact_information_type_id, contact_information_type_name 
    FROM contact_information_type 
    ORDER BY contact_information_type_id;
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

DROP PROCEDURE IF EXISTS `generateDepartmentOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateDepartmentOptions` (IN `p_department_id` INT)   BEGIN
    IF p_department_id IS NOT NULL AND p_department_id != '' THEN
        SELECT department_id, department_name 
        FROM department 
        WHERE department_id != p_department_id
        ORDER BY department_name;
    ELSE
        SELECT department_id, department_name 
        FROM department 
        ORDER BY department_name;
    END IF;
END$$

DROP PROCEDURE IF EXISTS `generateDepartmentTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateDepartmentTable` ()   BEGIN
    SELECT department_id, department_name, parent_department_name, manager_name 
    FROM department;
END$$

DROP PROCEDURE IF EXISTS `generateDepartureReasonOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateDepartureReasonOptions` ()   BEGIN
	SELECT departure_reason_id, departure_reason_name 
    FROM departure_reason 
    ORDER BY departure_reason_name;
END$$

DROP PROCEDURE IF EXISTS `generateDepartureReasonTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateDepartureReasonTable` ()   BEGIN
	SELECT departure_reason_id, departure_reason_name 
    FROM departure_reason 
    ORDER BY departure_reason_id;
END$$

DROP PROCEDURE IF EXISTS `generateEducationalStageOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateEducationalStageOptions` ()   BEGIN
	SELECT educational_stage_id, educational_stage_name 
    FROM educational_stage 
    ORDER BY educational_stage_name;
END$$

DROP PROCEDURE IF EXISTS `generateEducationalStageTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateEducationalStageTable` ()   BEGIN
	SELECT educational_stage_id, educational_stage_name 
    FROM educational_stage 
    ORDER BY educational_stage_id;
END$$

DROP PROCEDURE IF EXISTS `generateEmailSettingTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateEmailSettingTable` ()   BEGIN
    SELECT email_setting_id, email_setting_name, email_setting_description 
    FROM email_setting
    ORDER BY email_setting_name;
END$$

DROP PROCEDURE IF EXISTS `generateEmploymentTypeOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateEmploymentTypeOptions` ()   BEGIN
	SELECT employment_type_id, employment_type_name 
    FROM employment_type 
    ORDER BY employment_type_name;
END$$

DROP PROCEDURE IF EXISTS `generateEmploymentTypeTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateEmploymentTypeTable` ()   BEGIN
	SELECT employment_type_id, employment_type_name 
    FROM employment_type 
    ORDER BY employment_type_id;
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

    IF p_filter_by_file_type IS NOT NULL AND p_filter_by_file_type != '' THEN
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

DROP PROCEDURE IF EXISTS `generateGenderOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateGenderOptions` ()   BEGIN
	SELECT gender_id, gender_name 
    FROM gender 
    ORDER BY gender_name;
END$$

DROP PROCEDURE IF EXISTS `generateGenderTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateGenderTable` ()   BEGIN
	SELECT gender_id, gender_name 
    FROM gender 
    ORDER BY gender_id;
END$$

DROP PROCEDURE IF EXISTS `generateIDTypeOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateIDTypeOptions` ()   BEGIN
	SELECT id_type_id, id_type_name 
    FROM id_type 
    ORDER BY id_type_name;
END$$

DROP PROCEDURE IF EXISTS `generateIDTypeTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateIDTypeTable` ()   BEGIN
	SELECT id_type_id, id_type_name 
    FROM id_type 
    ORDER BY id_type_id;
END$$

DROP PROCEDURE IF EXISTS `generateInternalNotes`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateInternalNotes` (IN `p_table_name` VARCHAR(255), IN `p_reference_id` INT)   BEGIN
	SELECT internal_notes_id, internal_note, internal_note_by, internal_note_date
    FROM internal_notes
    WHERE table_name = p_table_name AND reference_id  = p_reference_id
    ORDER BY internal_note_date DESC;
END$$

DROP PROCEDURE IF EXISTS `generateJobPositionOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateJobPositionOptions` ()   BEGIN
	SELECT job_position_id, job_position_name 
    FROM job_position 
    ORDER BY job_position_name;
END$$

DROP PROCEDURE IF EXISTS `generateJobPositionTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateJobPositionTable` ()   BEGIN
	SELECT job_position_id, job_position_name 
    FROM job_position 
    ORDER BY job_position_id;
END$$

DROP PROCEDURE IF EXISTS `generateLanguageOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateLanguageOptions` ()   BEGIN
	SELECT language_id, language_name 
    FROM language 
    ORDER BY language_name;
END$$

DROP PROCEDURE IF EXISTS `generateLanguageProficiencyOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateLanguageProficiencyOptions` ()   BEGIN
	SELECT language_proficiency_id, language_proficiency_name, language_proficiency_description
    FROM language_proficiency 
    ORDER BY language_proficiency_name;
END$$

DROP PROCEDURE IF EXISTS `generateLanguageProficiencyTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateLanguageProficiencyTable` ()   BEGIN
	SELECT language_proficiency_id, language_proficiency_name, language_proficiency_description
    FROM language_proficiency 
    ORDER BY language_proficiency_id;
END$$

DROP PROCEDURE IF EXISTS `generateLanguageTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateLanguageTable` ()   BEGIN
	SELECT language_id, language_name 
    FROM language 
    ORDER BY language_id;
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

DROP PROCEDURE IF EXISTS `generateRelationOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateRelationOptions` ()   BEGIN
	SELECT relation_id, relation_name 
    FROM relation 
    ORDER BY relation_name;
END$$

DROP PROCEDURE IF EXISTS `generateRelationTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateRelationTable` ()   BEGIN
	SELECT relation_id, relation_name 
    FROM relation 
    ORDER BY relation_id;
END$$

DROP PROCEDURE IF EXISTS `generateReligionOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateReligionOptions` ()   BEGIN
	SELECT religion_id, religion_name 
    FROM religion 
    ORDER BY religion_name;
END$$

DROP PROCEDURE IF EXISTS `generateReligionTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateReligionTable` ()   BEGIN
	SELECT religion_id, religion_name 
    FROM religion 
    ORDER BY religion_id;
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

DROP PROCEDURE IF EXISTS `generateScheduleTypeOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateScheduleTypeOptions` ()   BEGIN
	SELECT schedule_type_id, schedule_type_name 
    FROM schedule_type 
    ORDER BY schedule_type_name;
END$$

DROP PROCEDURE IF EXISTS `generateScheduleTypeTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateScheduleTypeTable` ()   BEGIN
	SELECT schedule_type_id, schedule_type_name 
    FROM schedule_type 
    ORDER BY schedule_type_id;
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

    IF p_filter_by_country IS NOT NULL AND p_filter_by_country <> '' THEN
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

DROP PROCEDURE IF EXISTS `generateWorkHoursTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateWorkHoursTable` (IN `p_work_schedule_id` INT)   BEGIN
    SELECT work_hours_id, day_of_week, day_period, start_time, end_time, notes
    FROM work_hours WHERE work_schedule_id = p_work_schedule_id;
END$$

DROP PROCEDURE IF EXISTS `generateWorkLocationOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateWorkLocationOptions` ()   BEGIN
	SELECT work_location_id, work_location_name 
    FROM work_location 
    ORDER BY work_location_name;
END$$

DROP PROCEDURE IF EXISTS `generateWorkLocationTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateWorkLocationTable` (IN `p_filter_by_city` INT, IN `p_filter_by_state` INT, IN `p_filter_by_country` INT)   BEGIN
    DECLARE query VARCHAR(5000);

    SET query = CONCAT('
        SELECT work_location_id, work_location_name, address, city_name, state_name, country_name
        FROM work_location 
        WHERE 1');

    IF p_filter_by_city IS NOT NULL AND p_filter_by_city != '' THEN
        SET query = CONCAT(query, ' AND city_id = ', p_filter_by_city);
    END IF;

    IF p_filter_by_state IS NOT NULL AND p_filter_by_state != '' THEN
        SET query = CONCAT(query, ' AND state_id = ', p_filter_by_state);
    END IF;

    IF p_filter_by_country IS NOT NULL AND p_filter_by_country != '' THEN
        SET query = CONCAT(query, ' AND country_id = ', p_filter_by_country);
    END IF;

    SET query = CONCAT(query, ' ORDER BY work_location_name');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS `generateWorkScheduleOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateWorkScheduleOptions` ()   BEGIN
	SELECT work_schedule_id, work_schedule_name 
    FROM work_schedule 
    ORDER BY work_schedule_name;
END$$

DROP PROCEDURE IF EXISTS `generateWorkScheduleTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateWorkScheduleTable` (IN `p_filter_by_schedule_type` INT)   BEGIN
    DECLARE query VARCHAR(5000);

    SET query = CONCAT('
        SELECT work_schedule_id, work_schedule_name, schedule_type_name
        FROM work_schedule 
        WHERE 1');

    IF p_filter_by_schedule_type IS NOT NULL AND p_filter_by_schedule_type != '' THEN
        SET query = CONCAT(query, ' AND schedule_type_id = ', p_filter_by_schedule_type);
    END IF;

    SET query = CONCAT(query, ' ORDER BY work_schedule_name');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS `getAddressType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAddressType` (IN `p_address_type_id` INT)   BEGIN
	SELECT * FROM address_type
	WHERE address_type_id = p_address_type_id;
END$$

DROP PROCEDURE IF EXISTS `getAppModule`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAppModule` (IN `p_app_module_id` INT)   BEGIN
	SELECT * FROM app_module
	WHERE app_module_id = p_app_module_id;
END$$

DROP PROCEDURE IF EXISTS `getBank`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getBank` (IN `p_bank_id` INT)   BEGIN
	SELECT * FROM bank
	WHERE bank_id = p_bank_id;
END$$

DROP PROCEDURE IF EXISTS `getBankAccountType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getBankAccountType` (IN `p_bank_account_type_id` INT)   BEGIN
	SELECT * FROM bank_account_type
	WHERE bank_account_type_id = p_bank_account_type_id;
END$$

DROP PROCEDURE IF EXISTS `getBloodType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getBloodType` (IN `p_blood_type_id` INT)   BEGIN
	SELECT * FROM blood_type
	WHERE blood_type_id = p_blood_type_id;
END$$

DROP PROCEDURE IF EXISTS `getCity`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCity` (IN `p_city_id` INT)   BEGIN
	SELECT * FROM city
	WHERE city_id = p_city_id;
END$$

DROP PROCEDURE IF EXISTS `getCivilStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCivilStatus` (IN `p_civil_status_id` INT)   BEGIN
	SELECT * FROM civil_status
	WHERE civil_status_id = p_civil_status_id;
END$$

DROP PROCEDURE IF EXISTS `getCompany`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCompany` (IN `p_company_id` INT)   BEGIN
	SELECT * FROM company
	WHERE company_id = p_company_id;
END$$

DROP PROCEDURE IF EXISTS `getContactInformationType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getContactInformationType` (IN `p_contact_information_type_id` INT)   BEGIN
	SELECT * FROM contact_information_type
	WHERE contact_information_type_id = p_contact_information_type_id;
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

DROP PROCEDURE IF EXISTS `getDepartment`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getDepartment` (IN `p_department_id` INT)   BEGIN
	SELECT * FROM department
	WHERE department_id = p_department_id;
END$$

DROP PROCEDURE IF EXISTS `getDepartureReason`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getDepartureReason` (IN `p_departure_reason_id` INT)   BEGIN
	SELECT * FROM departure_reason
	WHERE departure_reason_id = p_departure_reason_id;
END$$

DROP PROCEDURE IF EXISTS `getEducationalStage`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getEducationalStage` (IN `p_educational_stage_id` INT)   BEGIN
	SELECT * FROM educational_stage
	WHERE educational_stage_id = p_educational_stage_id;
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

DROP PROCEDURE IF EXISTS `getEmploymentType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getEmploymentType` (IN `p_employment_type_id` INT)   BEGIN
	SELECT * FROM employment_type
	WHERE employment_type_id = p_employment_type_id;
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

DROP PROCEDURE IF EXISTS `getGender`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getGender` (IN `p_gender_id` INT)   BEGIN
	SELECT * FROM gender
	WHERE gender_id = p_gender_id;
END$$

DROP PROCEDURE IF EXISTS `getIDType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getIDType` (IN `p_id_type_id` INT)   BEGIN
	SELECT * FROM id_type
	WHERE id_type_id = p_id_type_id;
END$$

DROP PROCEDURE IF EXISTS `getInternalNotesAttachment`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getInternalNotesAttachment` (IN `p_internal_notes_id` INT)   BEGIN
	SELECT * FROM internal_notes_attachment
	WHERE internal_notes_id = p_internal_notes_id;
END$$

DROP PROCEDURE IF EXISTS `getJobPosition`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getJobPosition` (IN `p_job_position_id` INT)   BEGIN
	SELECT * FROM job_position
	WHERE job_position_id = p_job_position_id;
END$$

DROP PROCEDURE IF EXISTS `getLanguage`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getLanguage` (IN `p_language_id` INT)   BEGIN
	SELECT * FROM language
	WHERE language_id = p_language_id;
END$$

DROP PROCEDURE IF EXISTS `getLanguageProficiency`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getLanguageProficiency` (IN `p_language_proficiency_id` INT)   BEGIN
	SELECT * FROM language_proficiency
	WHERE language_proficiency_id = p_language_proficiency_id;
END$$

DROP PROCEDURE IF EXISTS `getLoginCredentials`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getLoginCredentials` (IN `p_user_account_id` INT, IN `p_credentials` VARCHAR(255))   BEGIN
	SELECT * FROM user_account
    WHERE user_account_id = p_user_account_id OR username = p_credentials OR email = p_credentials;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `getPasswordHistory` (IN `p_user_account_id` INT)   BEGIN
	SELECT * FROM password_history
	WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `getRelation`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getRelation` (IN `p_relation_id` INT)   BEGIN
	SELECT * FROM relation
	WHERE relation_id = p_relation_id;
END$$

DROP PROCEDURE IF EXISTS `getReligion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getReligion` (IN `p_religion_id` INT)   BEGIN
	SELECT * FROM religion
	WHERE religion_id = p_religion_id;
END$$

DROP PROCEDURE IF EXISTS `getRole`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getRole` (IN `p_role_id` INT)   BEGIN
	SELECT * FROM role
    WHERE role_id = p_role_id;
END$$

DROP PROCEDURE IF EXISTS `getScheduleType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getScheduleType` (IN `p_schedule_type_id` INT)   BEGIN
	SELECT * FROM schedule_type
	WHERE schedule_type_id = p_schedule_type_id;
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

DROP PROCEDURE IF EXISTS `getUICustomizationSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getUICustomizationSetting` (IN `p_user_account__id` INT)   BEGIN
	SELECT * FROM ui_customization_setting
	WHERE user_account_id = p_user_account__id;
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

DROP PROCEDURE IF EXISTS `getWorkHours`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getWorkHours` (IN `p_work_hours_id` INT)   BEGIN
	SELECT * FROM work_hours
	WHERE work_hours_id = p_work_hours_id;
END$$

DROP PROCEDURE IF EXISTS `getWorkLocation`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getWorkLocation` (IN `p_work_location_id` INT)   BEGIN
	SELECT * FROM work_location
	WHERE work_location_id = p_work_location_id;
END$$

DROP PROCEDURE IF EXISTS `getWorkSchedule`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getWorkSchedule` (IN `p_work_schedule_id` INT)   BEGIN
	SELECT * FROM work_schedule
	WHERE work_schedule_id = p_work_schedule_id;
END$$

DROP PROCEDURE IF EXISTS `insertAddressType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertAddressType` (IN `p_address_type_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_address_type_id` INT)   BEGIN
    INSERT INTO address_type (address_type_name, last_log_by) 
	VALUES(p_address_type_name, p_last_log_by);
	
    SET p_address_type_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertAppModule`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertAppModule` (IN `p_app_module_name` VARCHAR(100), IN `p_app_module_description` VARCHAR(500), IN `p_menu_item_id` INT, IN `p_menu_item_name` VARCHAR(100), IN `p_order_sequence` TINYINT(10), IN `p_last_log_by` INT, OUT `p_app_module_id` INT)   BEGIN
    INSERT INTO app_module (app_module_name, app_module_description, menu_item_id, menu_item_name, order_sequence, last_log_by) 
	VALUES(p_app_module_name, p_app_module_description, p_menu_item_id, p_menu_item_name, p_order_sequence, p_last_log_by);
	
    SET p_app_module_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertBank`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertBank` (IN `p_bank_name` VARCHAR(100), IN `p_bank_identifier_code` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_bank_id` INT)   BEGIN
    INSERT INTO bank (bank_name, bank_identifier_code, last_log_by) 
	VALUES(p_bank_name, p_bank_identifier_code, p_last_log_by);
	
    SET p_bank_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertBankAccountType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertBankAccountType` (IN `p_bank_account_type_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_bank_account_type_id` INT)   BEGIN
    INSERT INTO bank_account_type (bank_account_type_name, last_log_by) 
	VALUES(p_bank_account_type_name, p_last_log_by);
	
    SET p_bank_account_type_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertBloodType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertBloodType` (IN `p_blood_type_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_blood_type_id` INT)   BEGIN
    INSERT INTO blood_type (blood_type_name, last_log_by) 
	VALUES(p_blood_type_name, p_last_log_by);
	
    SET p_blood_type_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertCity`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertCity` (IN `p_city_name` VARCHAR(100), IN `p_state_id` INT, IN `p_state_name` VARCHAR(100), IN `p_country_id` INT, IN `p_country_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_city_id` INT)   BEGIN
    INSERT INTO city (city_name, state_id, state_name, country_id, country_name, last_log_by) 
	VALUES(p_city_name, p_state_id, p_state_name, p_country_id, p_country_name, p_last_log_by);
	
    SET p_city_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertCivilStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertCivilStatus` (IN `p_civil_status_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_civil_status_id` INT)   BEGIN
    INSERT INTO civil_status (civil_status_name, last_log_by) 
	VALUES(p_civil_status_name, p_last_log_by);
	
    SET p_civil_status_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertCompany`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertCompany` (IN `p_company_name` VARCHAR(100), IN `p_legal_name` VARCHAR(100), IN `p_address` VARCHAR(500), IN `p_city_id` INT, IN `p_city_name` VARCHAR(100), IN `p_state_id` INT, IN `p_state_name` VARCHAR(100), IN `p_country_id` INT, IN `p_country_name` VARCHAR(100), IN `p_currency_id` INT, IN `p_currency_name` VARCHAR(500), IN `p_currency_symbol` VARCHAR(10), IN `p_tax_id` VARCHAR(50), IN `p_phone` VARCHAR(50), IN `p_mobile` VARCHAR(50), IN `p_email` VARCHAR(500), IN `p_website` VARCHAR(500), IN `p_last_log_by` INT, OUT `p_company_id` INT)   BEGIN
    INSERT INTO company (company_name, legal_name, address, city_id, city_name, state_id, state_name, country_id, country_name, currency_id, currency_name, currency_symbol, tax_id, phone, mobile, email, website, last_log_by) 
	VALUES(p_company_name, p_legal_name, p_address, p_city_id, p_city_name, p_state_id, p_state_name, p_country_id, p_country_name, p_currency_id, p_currency_name, p_currency_symbol, p_tax_id, p_phone, p_mobile, p_email, p_website, p_last_log_by);
	
    SET p_company_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertContactInformationType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertContactInformationType` (IN `p_contact_information_type_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_contact_information_type_id` INT)   BEGIN
    INSERT INTO contact_information_type (contact_information_type_name, last_log_by) 
	VALUES(p_contact_information_type_name, p_last_log_by);
	
    SET p_contact_information_type_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertCountry`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertCountry` (IN `p_country_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_country_id` INT)   BEGIN
    INSERT INTO country (country_name, last_log_by) 
	VALUES(p_country_name, p_last_log_by);
	
    SET p_country_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertCurrency`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertCurrency` (IN `p_currency_name` VARCHAR(100), IN `p_currency_code` VARCHAR(10), IN `p_currency_symbol` VARCHAR(10), IN `p_exchange_rate` DOUBLE, IN `p_last_log_by` INT, OUT `p_currency_id` INT)   BEGIN
    INSERT INTO currency (currency_name, currency_code, currency_symbol, exchange_rate, last_log_by) 
	VALUES(p_currency_name, p_currency_code, p_currency_symbol, p_exchange_rate, p_last_log_by);
	
    SET p_currency_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertDepartment`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertDepartment` (IN `p_department_name` VARCHAR(100), IN `p_parent_department_id` INT, IN `p_parent_department_name` VARCHAR(100), IN `p_manager_id` INT, IN `p_manager_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_department_id` INT)   BEGIN
    INSERT INTO department (department_name, parent_department_id, parent_department_name, manager_id, manager_name, last_log_by) 
	VALUES(p_department_name, p_parent_department_id, p_parent_department_name, p_manager_id, p_manager_name, p_last_log_by);
	
    SET p_department_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertDepartureReason`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertDepartureReason` (IN `p_departure_reason_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_departure_reason_id` INT)   BEGIN
    INSERT INTO departure_reason (departure_reason_name, last_log_by) 
	VALUES(p_departure_reason_name, p_last_log_by);
	
    SET p_departure_reason_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertEducationalStage`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertEducationalStage` (IN `p_educational_stage_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_educational_stage_id` INT)   BEGIN
    INSERT INTO educational_stage (educational_stage_name, last_log_by) 
	VALUES(p_educational_stage_name, p_last_log_by);
	
    SET p_educational_stage_id = LAST_INSERT_ID();
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

DROP PROCEDURE IF EXISTS `insertEmploymentType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertEmploymentType` (IN `p_employment_type_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_employment_type_id` INT)   BEGIN
    INSERT INTO employment_type (employment_type_name, last_log_by) 
	VALUES(p_employment_type_name, p_last_log_by);
	
    SET p_employment_type_id = LAST_INSERT_ID();
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

DROP PROCEDURE IF EXISTS `insertGender`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertGender` (IN `p_gender_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_gender_id` INT)   BEGIN
    INSERT INTO gender (gender_name, last_log_by) 
	VALUES(p_gender_name, p_last_log_by);
	
    SET p_gender_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertIDType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertIDType` (IN `p_id_type_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_id_type_id` INT)   BEGIN
    INSERT INTO id_type (id_type_name, last_log_by) 
	VALUES(p_id_type_name, p_last_log_by);
	
    SET p_id_type_id = LAST_INSERT_ID();
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

DROP PROCEDURE IF EXISTS `insertJobPosition`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertJobPosition` (IN `p_job_position_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_job_position_id` INT)   BEGIN
    INSERT INTO job_position (job_position_name, last_log_by) 
	VALUES(p_job_position_name, p_last_log_by);
	
    SET p_job_position_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertLanguage`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertLanguage` (IN `p_language_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_language_id` INT)   BEGIN
    INSERT INTO language (language_name, last_log_by) 
	VALUES(p_language_name, p_last_log_by);
	
    SET p_language_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertLanguageProficiency`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertLanguageProficiency` (IN `p_language_proficiency_name` VARCHAR(100), IN `p_language_proficiency_description` VARCHAR(200), IN `p_last_log_by` INT, OUT `p_language_proficiency_id` INT)   BEGIN
    INSERT INTO language_proficiency (language_proficiency_name, language_proficiency_description, last_log_by) 
	VALUES(p_language_proficiency_name, p_language_proficiency_description, p_last_log_by);
	
    SET p_language_proficiency_id = LAST_INSERT_ID();
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertPasswordHistory` (IN `p_user_account_id` INT, IN `p_password` VARCHAR(255))   BEGIN
    INSERT INTO password_history (user_account_id, password, password_change_date) 
    VALUES (p_user_account_id, p_password, NOW());
END$$

DROP PROCEDURE IF EXISTS `insertRelation`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertRelation` (IN `p_relation_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_relation_id` INT)   BEGIN
    INSERT INTO relation (relation_name, last_log_by) 
	VALUES(p_relation_name, p_last_log_by);
	
    SET p_relation_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertReligion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertReligion` (IN `p_religion_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_religion_id` INT)   BEGIN
    INSERT INTO religion (religion_name, last_log_by) 
	VALUES(p_religion_name, p_last_log_by);
	
    SET p_religion_id = LAST_INSERT_ID();
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

DROP PROCEDURE IF EXISTS `insertScheduleType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertScheduleType` (IN `p_schedule_type_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_schedule_type_id` INT)   BEGIN
    INSERT INTO schedule_type (schedule_type_name, last_log_by) 
	VALUES(p_schedule_type_name, p_last_log_by);
	
    SET p_schedule_type_id = LAST_INSERT_ID();
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

DROP PROCEDURE IF EXISTS `insertUICustomizationSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertUICustomizationSetting` (IN `p_user_account__id` INT, IN `p_type` VARCHAR(30), IN `p_customization_value` VARCHAR(20), IN `p_last_log_by` INT)   BEGIN
	IF p_type = 'sidebar type' THEN
        INSERT INTO ui_customization_setting (user_account_id, sidebar_type, last_log_by) 
	    VALUES(p_user_account__id, p_customization_value, p_last_log_by);
    ELSEIF p_type = 'boxed layout' THEN
        INSERT INTO ui_customization_setting (user_account_id, boxed_layout, last_log_by) 
	    VALUES(p_user_account__id, p_customization_value, p_last_log_by);
    ELSEIF p_type = 'theme' THEN
        INSERT INTO ui_customization_setting (user_account_id, theme, last_log_by) 
	    VALUES(p_user_account__id, p_customization_value, p_last_log_by);
    ELSEIF p_type = 'color theme' THEN
        INSERT INTO ui_customization_setting (user_account_id, color_theme, last_log_by) 
	    VALUES(p_user_account__id, p_customization_value, p_last_log_by);
    ELSE
        INSERT INTO ui_customization_setting (user_account_id, card_border, last_log_by) 
	    VALUES(p_user_account__id, p_customization_value, p_last_log_by);
    END IF;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertUserAccount` (IN `p_file_as` VARCHAR(300), IN `p_email` VARCHAR(255), IN `p_username` VARCHAR(100), IN `p_password` VARCHAR(255), IN `p_password_expiry_date` DATE, IN `p_last_password_change` DATETIME, IN `p_last_log_by` INT, OUT `p_user_account_id` INT)   BEGIN
    INSERT INTO user_account (file_as, email, username, password, password_expiry_date, last_password_change, last_log_by) 
	VALUES(p_file_as, p_email, p_username, p_password, p_password_expiry_date, p_last_password_change, p_last_log_by);
	
    SET p_user_account_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertWorkHours`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertWorkHours` (IN `p_work_schedule_id` INT, IN `p_day_of_week` VARCHAR(20), IN `p_day_period` VARCHAR(20), IN `p_start_time` TIME, IN `p_end_time` TIME, IN `p_notes` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    INSERT INTO work_hours (work_schedule_id, day_of_week, day_period, start_time, end_time, notes, last_log_by) 
	VALUES(p_work_schedule_id, p_day_of_week, p_day_period, p_start_time, p_end_time, p_notes, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertWorkLocation`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertWorkLocation` (IN `p_work_location_name` VARCHAR(100), IN `p_address` VARCHAR(500), IN `p_city_id` INT, IN `p_city_name` VARCHAR(100), IN `p_state_id` INT, IN `p_state_name` VARCHAR(100), IN `p_country_id` INT, IN `p_country_name` VARCHAR(100), IN `p_phone` VARCHAR(50), IN `p_mobile` VARCHAR(50), IN `p_email` VARCHAR(500), IN `p_last_log_by` INT, OUT `p_work_location_id` INT)   BEGIN
    INSERT INTO work_location (work_location_name, address, city_id, city_name, state_id, state_name, country_id, country_name, phone, mobile, email, last_log_by) 
	VALUES(p_work_location_name, p_address, p_city_id, p_city_name, p_state_id, p_state_name, p_country_id, p_country_name, p_phone, p_mobile, p_email, p_last_log_by);
	
    SET p_work_location_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertWorkSchedule`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertWorkSchedule` (IN `p_work_schedule_name` VARCHAR(100), IN `p_schedule_type_id` INT, IN `p_schedule_type_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_work_schedule_id` INT)   BEGIN
    INSERT INTO work_schedule (work_schedule_name, schedule_type_id, schedule_type_name, last_log_by) 
	VALUES(p_work_schedule_name, p_schedule_type_id, p_schedule_type_name, p_last_log_by);
	
    SET p_work_schedule_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `updateAccountLock`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateAccountLock` (IN `p_user_account_id` INT, IN `p_locked` VARCHAR(5), IN `p_account_lock_duration` INT)   BEGIN
	UPDATE user_account 
    SET locked = p_locked, account_lock_duration = p_account_lock_duration 
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateAddressType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateAddressType` (IN `p_address_type_id` INT, IN `p_address_type_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE address_type
    SET address_type_name = p_address_type_name,
        last_log_by = p_last_log_by
    WHERE address_type_id = p_address_type_id;
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

DROP PROCEDURE IF EXISTS `updateBank`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateBank` (IN `p_bank_id` INT, IN `p_bank_name` VARCHAR(100), IN `p_bank_identifier_code` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE bank
    SET bank_name = p_bank_name,
        bank_identifier_code = p_bank_identifier_code,
        last_log_by = p_last_log_by
    WHERE bank_id = p_bank_id;
END$$

DROP PROCEDURE IF EXISTS `updateBankAccountType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateBankAccountType` (IN `p_bank_account_type_id` INT, IN `p_bank_account_type_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE bank_account_type
    SET bank_account_type_name = p_bank_account_type_name,
        last_log_by = p_last_log_by
    WHERE bank_account_type_id = p_bank_account_type_id;
END$$

DROP PROCEDURE IF EXISTS `updateBloodType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateBloodType` (IN `p_blood_type_id` INT, IN `p_blood_type_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE blood_type
    SET blood_type_name = p_blood_type_name,
        last_log_by = p_last_log_by
    WHERE blood_type_id = p_blood_type_id;
END$$

DROP PROCEDURE IF EXISTS `updateCity`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCity` (IN `p_city_id` INT, IN `p_city_name` VARCHAR(100), IN `p_state_id` INT, IN `p_state_name` VARCHAR(100), IN `p_country_id` INT, IN `p_country_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE work_locations
    SET city_name = p_city_name,
        state_id = p_state_id,
        state_name = p_state_name,
        country_id = p_country_id,
        country_name = p_country_name,
        last_log_by = p_last_log_by
    WHERE city_id = p_city_id;

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

DROP PROCEDURE IF EXISTS `updateCivilStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCivilStatus` (IN `p_civil_status_id` INT, IN `p_civil_status_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE civil_status
    SET civil_status_name = p_civil_status_name,
        last_log_by = p_last_log_by
    WHERE civil_status_id = p_civil_status_id;
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

DROP PROCEDURE IF EXISTS `updateContactInformationType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateContactInformationType` (IN `p_contact_information_type_id` INT, IN `p_contact_information_type_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE contact_information_type
    SET contact_information_type_name = p_contact_information_type_name,
        last_log_by = p_last_log_by
    WHERE contact_information_type_id = p_contact_information_type_id;
END$$

DROP PROCEDURE IF EXISTS `updateCountry`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCountry` (IN `p_country_id` INT, IN `p_country_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE work_locations
    SET country_name = p_country_name,
        last_log_by = p_last_log_by
    WHERE country_id = p_country_id;

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
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCurrency` (IN `p_currency_id` INT, IN `p_currency_name` VARCHAR(100), IN `p_currency_code` VARCHAR(10), IN `p_currency_symbol` VARCHAR(10), IN `p_exchange_rate` DOUBLE, IN `p_last_log_by` INT)   BEGIN
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
        currency_code = p_currency_code,
        currency_symbol = p_currency_symbol,
        exchange_rate = p_exchange_rate,
        last_log_by = p_last_log_by
    WHERE currency_id = p_currency_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateDepartment`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateDepartment` (IN `p_department_id` INT, IN `p_department_name` VARCHAR(100), IN `p_parent_department_id` INT, IN `p_parent_department_name` VARCHAR(100), IN `p_manager_id` INT, IN `p_manager_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE department
    SET parent_department_name = p_department_name,
        last_log_by = p_last_log_by
    WHERE parent_department_id = p_department_id;

    UPDATE department
    SET department_name = p_department_name,
        parent_department_id = p_parent_department_id,
        parent_department_name = p_parent_department_name,
        manager_id = p_manager_id,
        manager_name = p_manager_name,
        last_log_by = p_last_log_by
    WHERE department_id = p_department_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateDepartureReason`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateDepartureReason` (IN `p_departure_reason_id` INT, IN `p_departure_reason_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE departure_reason
    SET departure_reason_name = p_departure_reason_name,
        last_log_by = p_last_log_by
    WHERE departure_reason_id = p_departure_reason_id;
END$$

DROP PROCEDURE IF EXISTS `updateEducationalStage`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEducationalStage` (IN `p_educational_stage_id` INT, IN `p_educational_stage_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE educational_stage
    SET educational_stage_name = p_educational_stage_name,
        last_log_by = p_last_log_by
    WHERE educational_stage_id = p_educational_stage_id;
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

DROP PROCEDURE IF EXISTS `updateEmploymentType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmploymentType` (IN `p_employment_type_id` INT, IN `p_employment_type_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE employment_type
    SET employment_type_name = p_employment_type_name,
        last_log_by = p_last_log_by
    WHERE employment_type_id = p_employment_type_id;
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

DROP PROCEDURE IF EXISTS `updateGender`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateGender` (IN `p_gender_id` INT, IN `p_gender_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE gender
    SET gender_name = p_gender_name,
        last_log_by = p_last_log_by
    WHERE gender_id = p_gender_id;
END$$

DROP PROCEDURE IF EXISTS `updateIDType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateIDType` (IN `p_id_type_id` INT, IN `p_id_type_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE id_type
    SET id_type_name = p_id_type_name,
        last_log_by = p_last_log_by
    WHERE id_type_id = p_id_type_id;
END$$

DROP PROCEDURE IF EXISTS `updateJobPosition`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateJobPosition` (IN `p_job_position_id` INT, IN `p_job_position_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE job_position
    SET job_position_name = p_job_position_name,
        last_log_by = p_last_log_by
    WHERE job_position_id = p_job_position_id;
END$$

DROP PROCEDURE IF EXISTS `updateLanguage`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateLanguage` (IN `p_language_id` INT, IN `p_language_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE language
    SET language_name = p_language_name,
        last_log_by = p_last_log_by
    WHERE language_id = p_language_id;
END$$

DROP PROCEDURE IF EXISTS `updateLanguageProficiency`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateLanguageProficiency` (IN `p_language_proficiency_id` INT, IN `p_language_proficiency_name` VARCHAR(100), IN `p_language_proficiency_description` VARCHAR(200), IN `p_last_log_by` INT)   BEGIN
    UPDATE language_proficiency
    SET language_proficiency_name = p_language_proficiency_name,
        language_proficiency_description = p_language_proficiency_description,
        last_log_by = p_last_log_by
    WHERE language_proficiency_id = p_language_proficiency_id;
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
        app_module_id = p_app_module_id,
        app_module_name = p_app_module_name,
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

DROP PROCEDURE IF EXISTS `updateRelation`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateRelation` (IN `p_relation_id` INT, IN `p_relation_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE relation
    SET relation_name = p_relation_name,
        last_log_by = p_last_log_by
    WHERE relation_id = p_relation_id;
END$$

DROP PROCEDURE IF EXISTS `updateReligion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateReligion` (IN `p_religion_id` INT, IN `p_religion_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE religion
    SET religion_name = p_religion_name,
        last_log_by = p_last_log_by
    WHERE religion_id = p_religion_id;
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

DROP PROCEDURE IF EXISTS `updateScheduleType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateScheduleType` (IN `p_schedule_type_id` INT, IN `p_schedule_type_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE work_schedule
    SET schedule_type_name = p_schedule_type_name,
        last_log_by = p_last_log_by
    WHERE schedule_type_id = p_schedule_type_id;

    UPDATE schedule_type
    SET schedule_type_name = p_schedule_type_name,
        last_log_by = p_last_log_by
    WHERE schedule_type_id = p_schedule_type_id;

    COMMIT;
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

    UPDATE work_locations
    SET state_name = p_state_name,
        country_id = p_country_id,
        country_name = p_country_name,
        last_log_by = p_last_log_by
    WHERE state_id = p_state_id;

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

DROP PROCEDURE IF EXISTS `updateUICustomizationSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUICustomizationSetting` (IN `p_user_account__id` INT, IN `p_type` VARCHAR(30), IN `p_customization_value` VARCHAR(20), IN `p_last_log_by` INT)   BEGIN
	IF p_type = 'sidebar type' THEN
        UPDATE ui_customization_setting
        SET sidebar_type = p_customization_value,
        last_log_by = p_last_log_by
       	WHERE user_account_id = p_user_account__id;
    ELSEIF p_type = 'boxed layout' THEN
        UPDATE ui_customization_setting
        SET boxed_layout = p_customization_value,
        last_log_by = p_last_log_by
       	WHERE user_account_id = p_user_account__id;
    ELSEIF p_type = 'theme' THEN
        UPDATE ui_customization_setting
        SET theme = p_customization_value,
        last_log_by = p_last_log_by
       	WHERE user_account_id = p_user_account__id;
    ELSEIF p_type = 'color theme' THEN
        UPDATE ui_customization_setting
        SET color_theme = p_customization_value,
        last_log_by = p_last_log_by
       	WHERE user_account_id = p_user_account__id;
    ELSE
        UPDATE ui_customization_setting
        SET card_border = p_customization_value,
        last_log_by = p_last_log_by
       	WHERE user_account_id = p_user_account__id;
    END IF;
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUserAccount` (IN `p_user_account_id` INT, IN `p_file_as` VARCHAR(300), IN `p_email` VARCHAR(255), IN `p_username` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
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
        username = p_username,
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUserPassword` (IN `p_user_account_id` INT, IN `p_credentials` VARCHAR(255), IN `p_password` VARCHAR(255), IN `p_password_expiry_date` DATE)   BEGIN
	UPDATE user_account 
    SET password = p_password, 
        password_expiry_date = p_password_expiry_date, 
        last_password_change = NOW(), 
        locked = 'No',
        failed_login_attempts = 0, 
        account_lock_duration = 0,
        last_log_by = p_user_account_id
    WHERE p_user_account_id = user_account_id OR username = p_credentials OR email = BINARY p_credentials;
END$$

DROP PROCEDURE IF EXISTS `updateWorkHours`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateWorkHours` (IN `p_work_hours_id` INT, IN `p_work_schedule_id` INT, IN `p_day_of_week` VARCHAR(20), IN `p_day_period` VARCHAR(20), IN `p_start_time` TIME, IN `p_end_time` TIME, IN `p_notes` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    UPDATE work_hours
    SET work_schedule_id = p_work_schedule_id,
        day_of_week = p_day_of_week,
        day_period = p_day_period,
        start_time = p_start_time,
        end_time = p_end_time,
        notes = p_notes,
        last_log_by = p_last_log_by
    WHERE work_hours_id = p_work_hours_id;
END$$

DROP PROCEDURE IF EXISTS `updateWorkLocation`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateWorkLocation` (IN `p_work_location_id` INT, IN `p_work_location_name` VARCHAR(100), IN `p_address` VARCHAR(500), IN `p_city_id` INT, IN `p_city_name` VARCHAR(100), IN `p_state_id` INT, IN `p_state_name` VARCHAR(100), IN `p_country_id` INT, IN `p_country_name` VARCHAR(100), IN `p_phone` VARCHAR(50), IN `p_mobile` VARCHAR(50), IN `p_email` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE work_location
    SET work_location_name = p_work_location_name,
        address = p_address,
        city_id = p_city_id,
        city_name = p_city_name,
        state_id = p_state_id,
        state_name = p_state_name,
        country_id = p_country_id,
        country_name = p_country_name,
        phone = p_phone,
        mobile = p_mobile,
        email = p_email,
        last_log_by = p_last_log_by
    WHERE work_location_id = p_work_location_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateWorkSchedule`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateWorkSchedule` (IN `p_work_schedule_id` INT, IN `p_work_schedule_name` VARCHAR(100), IN `p_schedule_type_id` INT, IN `p_schedule_type_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE work_schedule
    SET work_schedule_name = p_work_schedule_name,
        schedule_type_id = p_schedule_type_id,
        schedule_type_name = p_schedule_type_name,
        last_log_by = p_last_log_by
    WHERE work_schedule_id = p_work_schedule_id;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `address_type`
--

DROP TABLE IF EXISTS `address_type`;
CREATE TABLE `address_type` (
  `address_type_id` int(10) UNSIGNED NOT NULL,
  `address_type_name` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `address_type`
--

INSERT INTO `address_type` (`address_type_id`, `address_type_name`, `created_date`, `last_log_by`) VALUES
(1, 'Home Address', '2024-07-03 09:29:42', 2),
(2, 'Billing Address', '2024-07-03 09:29:55', 2),
(3, 'Mailing Address', '2024-07-03 09:30:02', 2),
(4, 'Shipping Address', '2024-07-03 09:30:13', 2),
(5, 'Work Address', '2024-07-03 09:30:20', 2);

--
-- Triggers `address_type`
--
DROP TRIGGER IF EXISTS `address_type_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `address_type_trigger_insert` AFTER INSERT ON `address_type` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Address type created. <br/>';

    IF NEW.address_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Address Type Name: ", NEW.address_type_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('address_type', NEW.address_type_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `address_type_trigger_update`;
DELIMITER $$
CREATE TRIGGER `address_type_trigger_update` AFTER UPDATE ON `address_type` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.address_type_name <> OLD.address_type_name THEN
        SET audit_log = CONCAT(audit_log, "Address Type Name: ", OLD.address_type_name, " -> ", NEW.address_type_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('address_type', NEW.address_type_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
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
(1, 'Settings', 'Centralized management hub for comprehensive organizational oversight and control', './components/app-module/image/logo/1/setting.png', '1.0.0', 22, 'Account Setting', 100, '2024-06-26 13:43:48', 2),
(2, 'Employees', 'Centralize employee information', './components/app-module/image/logo/2/kwDc.png', '1.0.0', 23, 'Inventory Overview', 1, '2024-06-27 15:30:44', 2);

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
  `changed_at` datetime NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `audit_log`
--

INSERT INTO `audit_log` (`audit_log_id`, `table_name`, `reference_id`, `log`, `changed_by`, `changed_at`, `created_date`) VALUES
(1, 'app_module', 1, 'App module created. <br/><br/>App Module Name: Settings<br/>App Module Description: Centralized management hub for comprehensive organizational oversight and control<br/>App Version: 1.0.0<br/>Menu Item Name: General Settings<br/>Order Sequence: 100', 1, '2024-06-26 13:43:48', '2024-06-26 13:43:48'),
(2, 'menu_group', 1, 'Menu group created. <br/><br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Order Sequence: 100', 1, '2024-06-26 14:28:45', '2024-06-26 14:28:45'),
(3, 'menu_group', 2, 'Menu group created. <br/><br/>Menu Group Name: Administration<br/>App Module: Settings<br/>Order Sequence: 1', 1, '2024-06-26 14:28:45', '2024-06-26 14:28:45'),
(4, 'menu_group', 3, 'Menu group created. <br/><br/>Menu Group Name: Configurations<br/>App Module: Settings<br/>Order Sequence: 50', 1, '2024-06-26 14:28:45', '2024-06-26 14:28:45'),
(5, 'menu_item', 2, 'Menu Item created. <br/><br/>Menu Item Name: App Module<br/>Menu Item URL: app-module.php<br/>Menu Item Icon: ti ti-box<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Order Sequence: 1', 1, '2024-06-26 14:28:46', '2024-06-26 14:28:46'),
(6, 'menu_item', 3, 'Menu Item created. <br/><br/>Menu Item Name: General Settings<br/>Menu Item URL: general-settings.php<br/>Menu Item Icon: ti ti-settings<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Order Sequence: 7', 1, '2024-06-26 14:28:46', '2024-06-26 14:28:46'),
(7, 'menu_item', 4, 'Menu Item created. <br/><br/>Menu Item Name: Users & Companies<br/>Menu Item Icon: ti ti-users<br/>Menu Group Name: Administration<br/>App Module: Settings<br/>Order Sequence: 21', 1, '2024-06-26 14:28:46', '2024-06-26 14:28:46'),
(8, 'menu_item', 5, 'Menu Item created. <br/><br/>Menu Item Name: User Account<br/>Menu Item URL: user-account.php<br/>Menu Group Name: Administration<br/>App Module: Settings<br/>Parent: Users & Companies<br/>Order Sequence: 21', 1, '2024-06-26 14:28:46', '2024-06-26 14:28:46'),
(9, 'menu_item', 6, 'Menu Item created. <br/><br/>Menu Item Name: Company<br/>Menu Item URL: company.php<br/>Menu Group Name: Administration<br/>App Module: Settings<br/>Parent: Users & Companies<br/>Order Sequence: 3', 1, '2024-06-26 14:28:46', '2024-06-26 14:28:46'),
(10, 'menu_item', 7, 'Menu Item created. <br/><br/>Menu Item Name: Role<br/>Menu Item URL: role.php<br/>Menu Item Icon: ti ti-hierarchy-2<br/>Menu Group Name: Administration<br/>App Module: Settings<br/>Order Sequence: 3', 1, '2024-06-26 14:28:46', '2024-06-26 14:28:46'),
(11, 'menu_item', 8, 'Menu Item created. <br/><br/>Menu Item Name: User Interface<br/>Menu Item Icon: ti ti-layout-sidebar<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Order Sequence: 2', 1, '2024-06-26 14:28:46', '2024-06-26 14:28:46'),
(12, 'menu_item', 9, 'Menu Item created. <br/><br/>Menu Item Name: Menu Group<br/>Menu Item URL: menu-group.php<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Parent: User Interface<br/>Order Sequence: 1', 1, '2024-06-26 14:28:46', '2024-06-26 14:28:46'),
(13, 'menu_item', 10, 'Menu Item created. <br/><br/>Menu Item Name: Menu Item<br/>Menu Item URL: menu-item.php<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Parent: User Interface<br/>Order Sequence: 2', 1, '2024-06-26 14:28:46', '2024-06-26 14:28:46'),
(14, 'menu_item', 11, 'Menu Item created. <br/><br/>Menu Item Name: System Action<br/>Menu Item URL: system-action.php<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Parent: User Interface<br/>Order Sequence: 2', 1, '2024-06-26 14:28:46', '2024-06-26 14:28:46'),
(15, 'menu_item', 12, 'Menu Item created. <br/><br/>Menu Item Name: Localization<br/>Menu Item Icon: ti ti-map-pin<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Order Sequence: 12', 1, '2024-06-26 14:28:46', '2024-06-26 14:28:46'),
(16, 'menu_item', 13, 'Menu Item created. <br/><br/>Menu Item Name: City<br/>Menu Item URL: city.php<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Parent: Localization<br/>Order Sequence: 12', 1, '2024-06-26 14:28:46', '2024-06-26 14:28:46'),
(17, 'menu_item', 14, 'Menu Item created. <br/><br/>Menu Item Name: Country<br/>Menu Item URL: country.php<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Parent: Localization<br/>Order Sequence: 13', 1, '2024-06-26 14:28:46', '2024-06-26 14:28:46'),
(18, 'menu_item', 15, 'Menu Item created. <br/><br/>Menu Item Name: State<br/>Menu Item URL: state.php<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Parent: Localization<br/>Order Sequence: 19', 1, '2024-06-26 14:28:46', '2024-06-26 14:28:46'),
(19, 'menu_item', 16, 'Menu Item created. <br/><br/>Menu Item Name: Currency<br/>Menu Item URL: currency.php<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Parent: Localization<br/>Order Sequence: 14', 1, '2024-06-26 14:28:46', '2024-06-26 14:28:46'),
(20, 'menu_item', 17, 'Menu Item created. <br/><br/>Menu Item Name: File Configuration<br/>Menu Item Icon: ti ti-file-symlink<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Order Sequence: 6', 1, '2024-06-26 14:28:46', '2024-06-26 14:28:46'),
(21, 'menu_item', 18, 'Menu Item created. <br/><br/>Menu Item Name: Upload Setting<br/>Menu Item URL: upload-setting.php<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Parent: File Configuration<br/>Order Sequence: 21', 1, '2024-06-26 14:28:46', '2024-06-26 14:28:46'),
(22, 'menu_item', 19, 'Menu Item created. <br/><br/>Menu Item Name: File Type<br/>Menu Item URL: file-type.php<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Parent: File Configuration<br/>Order Sequence: 6', 1, '2024-06-26 14:28:46', '2024-06-26 14:28:46'),
(23, 'menu_item', 20, 'Menu Item created. <br/><br/>Menu Item Name: File Extension<br/>Menu Item URL: file-extension.php<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Parent: File Configuration<br/>Order Sequence: 7', 1, '2024-06-26 14:28:46', '2024-06-26 14:28:46'),
(24, 'menu_item', 21, 'Menu Item created. <br/><br/>Menu Item Name: Email Setting<br/>Menu Item URL: email-setting.php<br/>Menu Item Icon: ti ti-mail-forward<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Order Sequence: 5', 1, '2024-06-26 14:28:46', '2024-06-26 14:28:46'),
(25, 'menu_item', 22, 'Menu Item created. <br/><br/>Menu Item Name: Notification Setting<br/>Menu Item URL: notification-setting.php<br/>Menu Item Icon: ti ti-bell<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Order Sequence: 14', 1, '2024-06-26 14:28:46', '2024-06-26 14:28:46'),
(26, 'role', 1, 'Role created. <br/><br/>Role Name: Administrator<br/>Role Description: Full access to all features and data within the system. This role have similar access levels to the Admin but is not as powerful as the Super Admin.', 1, '2024-06-26 14:31:00', '2024-06-26 14:31:00'),
(27, 'menu_item', 1, 'Menu Item created. <br/><br/>Menu Item Name: App Module<br/>Menu Item URL: app-module.php<br/>Menu Item Icon: ti ti-box<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Order Sequence: 1', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(28, 'menu_item', 2, 'Menu Item created. <br/><br/>Menu Item Name: General Settings<br/>Menu Item URL: general-settings.php<br/>Menu Item Icon: ti ti-settings<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Order Sequence: 7', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(29, 'menu_item', 3, 'Menu Item created. <br/><br/>Menu Item Name: Users & Companies<br/>Menu Item Icon: ti ti-users<br/>Menu Group Name: Administration<br/>App Module: Settings<br/>Order Sequence: 21', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(30, 'menu_item', 4, 'Menu Item created. <br/><br/>Menu Item Name: User Account<br/>Menu Item URL: user-account.php<br/>Menu Group Name: Administration<br/>App Module: Settings<br/>Parent: Users & Companies<br/>Order Sequence: 21', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(31, 'menu_item', 5, 'Menu Item created. <br/><br/>Menu Item Name: Company<br/>Menu Item URL: company.php<br/>Menu Group Name: Administration<br/>App Module: Settings<br/>Parent: Users & Companies<br/>Order Sequence: 3', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(32, 'menu_item', 6, 'Menu Item created. <br/><br/>Menu Item Name: Role<br/>Menu Item URL: role.php<br/>Menu Item Icon: ti ti-hierarchy-2<br/>Menu Group Name: Administration<br/>App Module: Settings<br/>Order Sequence: 3', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(33, 'menu_item', 7, 'Menu Item created. <br/><br/>Menu Item Name: User Interface<br/>Menu Item Icon: ti ti-layout-sidebar<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Order Sequence: 2', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(34, 'menu_item', 8, 'Menu Item created. <br/><br/>Menu Item Name: Menu Group<br/>Menu Item URL: menu-group.php<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Parent: User Interface<br/>Order Sequence: 1', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(35, 'menu_item', 9, 'Menu Item created. <br/><br/>Menu Item Name: Menu Item<br/>Menu Item URL: menu-item.php<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Parent: User Interface<br/>Order Sequence: 2', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(36, 'menu_item', 10, 'Menu Item created. <br/><br/>Menu Item Name: System Action<br/>Menu Item URL: system-action.php<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Parent: User Interface<br/>Order Sequence: 2', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(37, 'menu_item', 11, 'Menu Item created. <br/><br/>Menu Item Name: Localization<br/>Menu Item Icon: ti ti-map-pin<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Order Sequence: 12', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(38, 'menu_item', 12, 'Menu Item created. <br/><br/>Menu Item Name: City<br/>Menu Item URL: city.php<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Parent: Localization<br/>Order Sequence: 12', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(39, 'menu_item', 13, 'Menu Item created. <br/><br/>Menu Item Name: Country<br/>Menu Item URL: country.php<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Parent: Localization<br/>Order Sequence: 13', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(40, 'menu_item', 14, 'Menu Item created. <br/><br/>Menu Item Name: State<br/>Menu Item URL: state.php<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Parent: Localization<br/>Order Sequence: 19', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(41, 'menu_item', 15, 'Menu Item created. <br/><br/>Menu Item Name: Currency<br/>Menu Item URL: currency.php<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Parent: Localization<br/>Order Sequence: 14', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(42, 'menu_item', 16, 'Menu Item created. <br/><br/>Menu Item Name: File Configuration<br/>Menu Item Icon: ti ti-file-symlink<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Order Sequence: 6', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(43, 'menu_item', 17, 'Menu Item created. <br/><br/>Menu Item Name: Upload Setting<br/>Menu Item URL: upload-setting.php<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Parent: File Configuration<br/>Order Sequence: 21', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(44, 'menu_item', 18, 'Menu Item created. <br/><br/>Menu Item Name: File Type<br/>Menu Item URL: file-type.php<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Parent: File Configuration<br/>Order Sequence: 6', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(45, 'menu_item', 19, 'Menu Item created. <br/><br/>Menu Item Name: File Extension<br/>Menu Item URL: file-extension.php<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Parent: File Configuration<br/>Order Sequence: 7', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(46, 'menu_item', 20, 'Menu Item created. <br/><br/>Menu Item Name: Email Setting<br/>Menu Item URL: email-setting.php<br/>Menu Item Icon: ti ti-mail-forward<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Order Sequence: 5', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(47, 'menu_item', 21, 'Menu Item created. <br/><br/>Menu Item Name: Notification Setting<br/>Menu Item URL: notification-setting.php<br/>Menu Item Icon: ti ti-bell<br/>Menu Group Name: Technical<br/>App Module: Settings<br/>Order Sequence: 14', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(48, 'role_permission', 2, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: App Module<br/>Read Access: 1<br/>Write Access: 1<br/>Create Access: 1<br/>Delete Access: 1<br/>Date Assigned: 2024-06-26 15:17:26', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(49, 'role_permission', 3, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: General Settings<br/>Read Access: 1<br/>Write Access: 1<br/>Create Access: 1<br/>Delete Access: 1<br/>Date Assigned: 2024-06-26 15:17:26', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(50, 'role_permission', 4, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Users & Companies<br/>Read Access: 1<br/>Date Assigned: 2024-06-26 15:17:26', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(51, 'role_permission', 5, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: User Account<br/>Read Access: 1<br/>Write Access: 1<br/>Create Access: 1<br/>Delete Access: 1<br/>Date Assigned: 2024-06-26 15:17:26', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(52, 'role_permission', 6, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Company<br/>Read Access: 1<br/>Write Access: 1<br/>Create Access: 1<br/>Delete Access: 1<br/>Date Assigned: 2024-06-26 15:17:26', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(53, 'role_permission', 7, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Role<br/>Read Access: 1<br/>Write Access: 1<br/>Create Access: 1<br/>Delete Access: 1<br/>Date Assigned: 2024-06-26 15:17:26', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(54, 'role_permission', 8, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: User Interface<br/>Read Access: 1<br/>Date Assigned: 2024-06-26 15:17:26', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(55, 'role_permission', 9, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Menu Group<br/>Read Access: 1<br/>Write Access: 1<br/>Create Access: 1<br/>Delete Access: 1<br/>Date Assigned: 2024-06-26 15:17:26', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(56, 'role_permission', 10, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Menu Item<br/>Read Access: 1<br/>Write Access: 1<br/>Create Access: 1<br/>Delete Access: 1<br/>Date Assigned: 2024-06-26 15:17:26', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(57, 'role_permission', 11, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: System Action<br/>Read Access: 1<br/>Write Access: 1<br/>Create Access: 1<br/>Delete Access: 1<br/>Date Assigned: 2024-06-26 15:17:26', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(58, 'role_permission', 12, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Localization<br/>Read Access: 1<br/>Date Assigned: 2024-06-26 15:17:26', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(59, 'role_permission', 13, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: City<br/>Read Access: 1<br/>Write Access: 1<br/>Create Access: 1<br/>Delete Access: 1<br/>Date Assigned: 2024-06-26 15:17:26', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(60, 'role_permission', 14, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Country<br/>Read Access: 1<br/>Write Access: 1<br/>Create Access: 1<br/>Delete Access: 1<br/>Date Assigned: 2024-06-26 15:17:26', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(61, 'role_permission', 15, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: State<br/>Read Access: 1<br/>Write Access: 1<br/>Create Access: 1<br/>Delete Access: 1<br/>Date Assigned: 2024-06-26 15:17:26', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(62, 'role_permission', 16, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Currency<br/>Read Access: 1<br/>Write Access: 1<br/>Create Access: 1<br/>Delete Access: 1<br/>Date Assigned: 2024-06-26 15:17:26', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(63, 'role_permission', 17, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: File Configuration<br/>Read Access: 1<br/>Date Assigned: 2024-06-26 15:17:26', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(64, 'role_permission', 18, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Upload Setting<br/>Read Access: 1<br/>Write Access: 1<br/>Create Access: 1<br/>Delete Access: 1<br/>Date Assigned: 2024-06-26 15:17:26', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(65, 'role_permission', 19, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: File Type<br/>Read Access: 1<br/>Write Access: 1<br/>Create Access: 1<br/>Delete Access: 1<br/>Date Assigned: 2024-06-26 15:17:26', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(66, 'role_permission', 20, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: File Extension<br/>Read Access: 1<br/>Write Access: 1<br/>Create Access: 1<br/>Delete Access: 1<br/>Date Assigned: 2024-06-26 15:17:26', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(67, 'role_permission', 21, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Email Setting<br/>Read Access: 1<br/>Write Access: 1<br/>Create Access: 1<br/>Delete Access: 1<br/>Date Assigned: 2024-06-26 15:17:26', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(68, 'role_permission', 22, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Notification Setting<br/>Read Access: 1<br/>Write Access: 1<br/>Create Access: 1<br/>Delete Access: 1<br/>Date Assigned: 2024-06-26 15:17:26', 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26'),
(69, 'system_action', 1, 'System action created. <br/><br/>System Action Name: Update System Settings<br/>System Action Description: Access to update the system settings.', 1, '2024-06-26 15:18:24', '2024-06-26 15:18:24'),
(70, 'system_action', 2, 'System action created. <br/><br/>System Action Name: Update Security Settings<br/>System Action Description: Access to update the security settings.', 1, '2024-06-26 15:18:24', '2024-06-26 15:18:24'),
(71, 'system_action', 3, 'System action created. <br/><br/>System Action Name: Activate User Account<br/>System Action Description: Access to activate the user account.', 1, '2024-06-26 15:18:24', '2024-06-26 15:18:24'),
(72, 'system_action', 4, 'System action created. <br/><br/>System Action Name: Deactivate User Account<br/>System Action Description: Access to deactivate the user account.', 1, '2024-06-26 15:18:24', '2024-06-26 15:18:24'),
(73, 'system_action', 5, 'System action created. <br/><br/>System Action Name: Lock User Account<br/>System Action Description: Access to lock the user account.', 1, '2024-06-26 15:18:24', '2024-06-26 15:18:24'),
(74, 'system_action', 6, 'System action created. <br/><br/>System Action Name: Unlock User Account<br/>System Action Description: Access to unlock the user account.', 1, '2024-06-26 15:18:24', '2024-06-26 15:18:24'),
(75, 'system_action', 7, 'System action created. <br/><br/>System Action Name: Add Role User Account<br/>System Action Description: Access to assign roles to user account.', 1, '2024-06-26 15:18:24', '2024-06-26 15:18:24'),
(76, 'system_action', 8, 'System action created. <br/><br/>System Action Name: Delete Role User Account<br/>System Action Description: Access to delete roles to user account.', 1, '2024-06-26 15:18:24', '2024-06-26 15:18:24'),
(77, 'system_action', 9, 'System action created. <br/><br/>System Action Name: Add Role Access<br/>System Action Description: Access to add role access.', 1, '2024-06-26 15:18:24', '2024-06-26 15:18:24'),
(78, 'system_action', 10, 'System action created. <br/><br/>System Action Name: Update Role Access<br/>System Action Description: Access to update role access.', 1, '2024-06-26 15:18:24', '2024-06-26 15:18:24'),
(79, 'system_action', 11, 'System action created. <br/><br/>System Action Name: Delete Role Access<br/>System Action Description: Access to delete role access.', 1, '2024-06-26 15:18:24', '2024-06-26 15:18:24'),
(80, 'system_action', 12, 'System action created. <br/><br/>System Action Name: Add Role System Action Access<br/>System Action Description: Access to add the role system action access.', 1, '2024-06-26 15:18:24', '2024-06-26 15:18:24'),
(81, 'system_action', 13, 'System action created. <br/><br/>System Action Name: Update Role System Action Access<br/>System Action Description: Access to update the role system action access.', 1, '2024-06-26 15:18:24', '2024-06-26 15:18:24'),
(82, 'system_action', 14, 'System action created. <br/><br/>System Action Name: Delete Role System Action Access<br/>System Action Description: Access to delete the role system action access.', 1, '2024-06-26 15:18:24', '2024-06-26 15:18:24'),
(83, 'system_action', 15, 'System action created. <br/><br/>System Action Name: Add File Extension Access<br/>System Action Description: Access to assign the file extension to the upload setting.', 1, '2024-06-26 15:18:24', '2024-06-26 15:18:24'),
(84, 'system_action', 16, 'System action created. <br/><br/>System Action Name: Delete File Extension Access<br/>System Action Description: Access to delete the file extension to the upload setting.', 1, '2024-06-26 15:18:24', '2024-06-26 15:18:24'),
(85, 'role_system_action_permission', 1, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Update System Settings<br/>System Action Access: 1<br/>Date Assigned: 2024-06-26 15:18:29', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29'),
(86, 'role_system_action_permission', 2, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Update Security Settings<br/>System Action Access: 1<br/>Date Assigned: 2024-06-26 15:18:29', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29'),
(87, 'role_system_action_permission', 3, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Activate User Account<br/>System Action Access: 1<br/>Date Assigned: 2024-06-26 15:18:29', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29'),
(88, 'role_system_action_permission', 4, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Deactivate User Account<br/>System Action Access: 1<br/>Date Assigned: 2024-06-26 15:18:29', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29'),
(89, 'role_system_action_permission', 5, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Lock User Account<br/>System Action Access: 1<br/>Date Assigned: 2024-06-26 15:18:29', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29'),
(90, 'role_system_action_permission', 6, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Unlock User Account<br/>System Action Access: 1<br/>Date Assigned: 2024-06-26 15:18:29', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29'),
(91, 'role_system_action_permission', 7, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Add Role User Account<br/>System Action Access: 1<br/>Date Assigned: 2024-06-26 15:18:29', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29'),
(92, 'role_system_action_permission', 8, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Delete Role User Account<br/>System Action Access: 1<br/>Date Assigned: 2024-06-26 15:18:29', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29'),
(93, 'role_system_action_permission', 9, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Add Role Access<br/>System Action Access: 1<br/>Date Assigned: 2024-06-26 15:18:29', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29'),
(94, 'role_system_action_permission', 10, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Update Role Access<br/>System Action Access: 1<br/>Date Assigned: 2024-06-26 15:18:29', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29'),
(95, 'role_system_action_permission', 11, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Delete Role Access<br/>System Action Access: 1<br/>Date Assigned: 2024-06-26 15:18:29', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29'),
(96, 'role_system_action_permission', 12, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Add Role System Action Access<br/>System Action Access: 1<br/>Date Assigned: 2024-06-26 15:18:29', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29'),
(97, 'role_system_action_permission', 13, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Update Role System Action Access<br/>System Action Access: 1<br/>Date Assigned: 2024-06-26 15:18:29', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29'),
(98, 'role_system_action_permission', 14, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Delete Role System Action Access<br/>System Action Access: 1<br/>Date Assigned: 2024-06-26 15:18:29', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29'),
(99, 'role_system_action_permission', 15, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Add File Extension Access<br/>System Action Access: 1<br/>Date Assigned: 2024-06-26 15:18:29', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29'),
(100, 'role_system_action_permission', 16, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Delete File Extension Access<br/>System Action Access: 1<br/>Date Assigned: 2024-06-26 15:18:29', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29'),
(101, 'role_user_account', 1, 'Role user account created. <br/><br/>Role Name: Administrator<br/>User Account Name: Administrator<br/>Date Assigned: 2024-06-26 15:18:35', 1, '2024-06-26 15:18:35', '2024-06-26 15:18:35'),
(102, 'menu_item', 7, 'Order Sequence: 2 -> 16<br/>', 2, '2024-06-26 15:21:53', '2024-06-26 15:21:53'),
(103, 'country', 1, 'Country created. <br/><br/>Country Name: Afghanistan', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(104, 'country', 2, 'Country created. <br/><br/>Country Name: Aland Islands', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(105, 'country', 3, 'Country created. <br/><br/>Country Name: Albania', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(106, 'country', 4, 'Country created. <br/><br/>Country Name: Algeria', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(107, 'country', 5, 'Country created. <br/><br/>Country Name: American Samoa', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(108, 'country', 6, 'Country created. <br/><br/>Country Name: Andorra', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(109, 'country', 7, 'Country created. <br/><br/>Country Name: Angola', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(110, 'country', 8, 'Country created. <br/><br/>Country Name: Anguilla', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(111, 'country', 9, 'Country created. <br/><br/>Country Name: Antarctica', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(112, 'country', 10, 'Country created. <br/><br/>Country Name: Antigua And Barbuda', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(113, 'country', 11, 'Country created. <br/><br/>Country Name: Argentina', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(114, 'country', 12, 'Country created. <br/><br/>Country Name: Armenia', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(115, 'country', 13, 'Country created. <br/><br/>Country Name: Aruba', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(116, 'country', 14, 'Country created. <br/><br/>Country Name: Australia', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(117, 'country', 15, 'Country created. <br/><br/>Country Name: Austria', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(118, 'country', 16, 'Country created. <br/><br/>Country Name: Azerbaijan', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(119, 'country', 17, 'Country created. <br/><br/>Country Name: Bahrain', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(120, 'country', 18, 'Country created. <br/><br/>Country Name: Bangladesh', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(121, 'country', 19, 'Country created. <br/><br/>Country Name: Barbados', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(122, 'country', 20, 'Country created. <br/><br/>Country Name: Belarus', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(123, 'country', 21, 'Country created. <br/><br/>Country Name: Belgium', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(124, 'country', 22, 'Country created. <br/><br/>Country Name: Belize', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(125, 'country', 23, 'Country created. <br/><br/>Country Name: Benin', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(126, 'country', 24, 'Country created. <br/><br/>Country Name: Bermuda', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(127, 'country', 25, 'Country created. <br/><br/>Country Name: Bhutan', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(128, 'country', 26, 'Country created. <br/><br/>Country Name: Bolivia', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(129, 'country', 27, 'Country created. <br/><br/>Country Name: Bonaire, Sint Eustatius and Saba', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(130, 'country', 28, 'Country created. <br/><br/>Country Name: Bosnia and Herzegovina', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(131, 'country', 29, 'Country created. <br/><br/>Country Name: Botswana', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(132, 'country', 30, 'Country created. <br/><br/>Country Name: Bouvet Island', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(133, 'country', 31, 'Country created. <br/><br/>Country Name: Brazil', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(134, 'country', 32, 'Country created. <br/><br/>Country Name: British Indian Ocean Territory', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(135, 'country', 33, 'Country created. <br/><br/>Country Name: Brunei', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(136, 'country', 34, 'Country created. <br/><br/>Country Name: Bulgaria', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(137, 'country', 35, 'Country created. <br/><br/>Country Name: Burkina Faso', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(138, 'country', 36, 'Country created. <br/><br/>Country Name: Burundi', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(139, 'country', 37, 'Country created. <br/><br/>Country Name: Cambodia', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(140, 'country', 38, 'Country created. <br/><br/>Country Name: Cameroon', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(141, 'country', 39, 'Country created. <br/><br/>Country Name: Canada', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(142, 'country', 40, 'Country created. <br/><br/>Country Name: Cape Verde', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(143, 'country', 41, 'Country created. <br/><br/>Country Name: Cayman Islands', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(144, 'country', 42, 'Country created. <br/><br/>Country Name: Central African Republic', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(145, 'country', 43, 'Country created. <br/><br/>Country Name: Chad', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(146, 'country', 44, 'Country created. <br/><br/>Country Name: Chile', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(147, 'country', 45, 'Country created. <br/><br/>Country Name: China', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(148, 'country', 46, 'Country created. <br/><br/>Country Name: Christmas Island', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(149, 'country', 47, 'Country created. <br/><br/>Country Name: Cocos (Keeling) Islands', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(150, 'country', 48, 'Country created. <br/><br/>Country Name: Colombia', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(151, 'country', 49, 'Country created. <br/><br/>Country Name: Comoros', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(152, 'country', 50, 'Country created. <br/><br/>Country Name: Congo', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(153, 'country', 51, 'Country created. <br/><br/>Country Name: Cook Islands', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(154, 'country', 52, 'Country created. <br/><br/>Country Name: Costa Rica', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(155, 'country', 53, 'Country created. <br/><br/>Country Name: Cote D Ivoire (Ivory Coast)', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(156, 'country', 54, 'Country created. <br/><br/>Country Name: Croatia', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(157, 'country', 55, 'Country created. <br/><br/>Country Name: Cuba', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(158, 'country', 56, 'Country created. <br/><br/>Country Name: CuraÃ§ao', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(159, 'country', 57, 'Country created. <br/><br/>Country Name: Cyprus', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(160, 'country', 58, 'Country created. <br/><br/>Country Name: Czech Republic', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(161, 'country', 59, 'Country created. <br/><br/>Country Name: Democratic Republic of the Congo', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(162, 'country', 60, 'Country created. <br/><br/>Country Name: Denmark', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(163, 'country', 61, 'Country created. <br/><br/>Country Name: Djibouti', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(164, 'country', 62, 'Country created. <br/><br/>Country Name: Dominica', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(165, 'country', 63, 'Country created. <br/><br/>Country Name: Dominican Republic', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(166, 'country', 64, 'Country created. <br/><br/>Country Name: East Timor', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(167, 'country', 65, 'Country created. <br/><br/>Country Name: Ecuador', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(168, 'country', 66, 'Country created. <br/><br/>Country Name: Egypt', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(169, 'country', 67, 'Country created. <br/><br/>Country Name: El Salvador', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(170, 'country', 68, 'Country created. <br/><br/>Country Name: Equatorial Guinea', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(171, 'country', 69, 'Country created. <br/><br/>Country Name: Eritrea', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(172, 'country', 70, 'Country created. <br/><br/>Country Name: Estonia', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(173, 'country', 71, 'Country created. <br/><br/>Country Name: Ethiopia', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(174, 'country', 72, 'Country created. <br/><br/>Country Name: Falkland Islands', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(175, 'country', 73, 'Country created. <br/><br/>Country Name: Faroe Islands', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(176, 'country', 74, 'Country created. <br/><br/>Country Name: Fiji Islands', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(177, 'country', 75, 'Country created. <br/><br/>Country Name: Finland', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(178, 'country', 76, 'Country created. <br/><br/>Country Name: France', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(179, 'country', 77, 'Country created. <br/><br/>Country Name: French Guiana', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(180, 'country', 78, 'Country created. <br/><br/>Country Name: French Polynesia', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(181, 'country', 79, 'Country created. <br/><br/>Country Name: French Southern Territories', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(182, 'country', 80, 'Country created. <br/><br/>Country Name: Gabon', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(183, 'country', 81, 'Country created. <br/><br/>Country Name: Gambia The', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(184, 'country', 82, 'Country created. <br/><br/>Country Name: Georgia', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(185, 'country', 83, 'Country created. <br/><br/>Country Name: Germany', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(186, 'country', 84, 'Country created. <br/><br/>Country Name: Ghana', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(187, 'country', 85, 'Country created. <br/><br/>Country Name: Gibraltar', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(188, 'country', 86, 'Country created. <br/><br/>Country Name: Greece', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(189, 'country', 87, 'Country created. <br/><br/>Country Name: Greenland', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(190, 'country', 88, 'Country created. <br/><br/>Country Name: Grenada', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(191, 'country', 89, 'Country created. <br/><br/>Country Name: Guadeloupe', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(192, 'country', 90, 'Country created. <br/><br/>Country Name: Guam', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(193, 'country', 91, 'Country created. <br/><br/>Country Name: Guatemala', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(194, 'country', 92, 'Country created. <br/><br/>Country Name: Guernsey and Alderney', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(195, 'country', 93, 'Country created. <br/><br/>Country Name: Guinea', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(196, 'country', 94, 'Country created. <br/><br/>Country Name: Guinea-Bissau', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(197, 'country', 95, 'Country created. <br/><br/>Country Name: Guyana', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(198, 'country', 96, 'Country created. <br/><br/>Country Name: Haiti', 1, '2024-06-26 15:33:55', '2024-06-26 15:33:55'),
(199, 'country', 97, 'Country created. <br/><br/>Country Name: Heard Island and McDonald Islands', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(200, 'country', 98, 'Country created. <br/><br/>Country Name: Honduras', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(201, 'country', 99, 'Country created. <br/><br/>Country Name: Hong Kong S.A.R.', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(202, 'country', 100, 'Country created. <br/><br/>Country Name: Hungary', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(203, 'country', 101, 'Country created. <br/><br/>Country Name: Iceland', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(204, 'country', 102, 'Country created. <br/><br/>Country Name: India', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(205, 'country', 103, 'Country created. <br/><br/>Country Name: Indonesia', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(206, 'country', 104, 'Country created. <br/><br/>Country Name: Iran', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(207, 'country', 105, 'Country created. <br/><br/>Country Name: Iraq', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(208, 'country', 106, 'Country created. <br/><br/>Country Name: Ireland', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(209, 'country', 107, 'Country created. <br/><br/>Country Name: Israel', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(210, 'country', 108, 'Country created. <br/><br/>Country Name: Italy', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(211, 'country', 109, 'Country created. <br/><br/>Country Name: Jamaica', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(212, 'country', 110, 'Country created. <br/><br/>Country Name: Japan', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(213, 'country', 111, 'Country created. <br/><br/>Country Name: Jersey', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(214, 'country', 112, 'Country created. <br/><br/>Country Name: Jordan', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(215, 'country', 113, 'Country created. <br/><br/>Country Name: Kazakhstan', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(216, 'country', 114, 'Country created. <br/><br/>Country Name: Kenya', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(217, 'country', 115, 'Country created. <br/><br/>Country Name: Kiribati', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(218, 'country', 116, 'Country created. <br/><br/>Country Name: Kosovo', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(219, 'country', 117, 'Country created. <br/><br/>Country Name: Kuwait', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(220, 'country', 118, 'Country created. <br/><br/>Country Name: Kyrgyzstan', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(221, 'country', 119, 'Country created. <br/><br/>Country Name: Laos', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(222, 'country', 120, 'Country created. <br/><br/>Country Name: Latvia', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(223, 'country', 121, 'Country created. <br/><br/>Country Name: Lebanon', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(224, 'country', 122, 'Country created. <br/><br/>Country Name: Lesotho', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(225, 'country', 123, 'Country created. <br/><br/>Country Name: Liberia', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(226, 'country', 124, 'Country created. <br/><br/>Country Name: Libya', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(227, 'country', 125, 'Country created. <br/><br/>Country Name: Liechtenstein', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(228, 'country', 126, 'Country created. <br/><br/>Country Name: Lithuania', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(229, 'country', 127, 'Country created. <br/><br/>Country Name: Luxembourg', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(230, 'country', 128, 'Country created. <br/><br/>Country Name: Macau S.A.R.', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(231, 'country', 129, 'Country created. <br/><br/>Country Name: Madagascar', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(232, 'country', 130, 'Country created. <br/><br/>Country Name: Malawi', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(233, 'country', 131, 'Country created. <br/><br/>Country Name: Malaysia', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(234, 'country', 132, 'Country created. <br/><br/>Country Name: Maldives', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(235, 'country', 133, 'Country created. <br/><br/>Country Name: Mali', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(236, 'country', 134, 'Country created. <br/><br/>Country Name: Malta', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(237, 'country', 135, 'Country created. <br/><br/>Country Name: Man (Isle of)', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(238, 'country', 136, 'Country created. <br/><br/>Country Name: Marshall Islands', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(239, 'country', 137, 'Country created. <br/><br/>Country Name: Martinique', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(240, 'country', 138, 'Country created. <br/><br/>Country Name: Mauritania', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(241, 'country', 139, 'Country created. <br/><br/>Country Name: Mauritius', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(242, 'country', 140, 'Country created. <br/><br/>Country Name: Mayotte', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(243, 'country', 141, 'Country created. <br/><br/>Country Name: Mexico', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(244, 'country', 142, 'Country created. <br/><br/>Country Name: Micronesia', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(245, 'country', 143, 'Country created. <br/><br/>Country Name: Moldova', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(246, 'country', 144, 'Country created. <br/><br/>Country Name: Monaco', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(247, 'country', 145, 'Country created. <br/><br/>Country Name: Mongolia', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(248, 'country', 146, 'Country created. <br/><br/>Country Name: Montenegro', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(249, 'country', 147, 'Country created. <br/><br/>Country Name: Montserrat', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(250, 'country', 148, 'Country created. <br/><br/>Country Name: Morocco', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(251, 'country', 149, 'Country created. <br/><br/>Country Name: Mozambique', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(252, 'country', 150, 'Country created. <br/><br/>Country Name: Myanmar', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(253, 'country', 151, 'Country created. <br/><br/>Country Name: Namibia', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(254, 'country', 152, 'Country created. <br/><br/>Country Name: Nauru', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(255, 'country', 153, 'Country created. <br/><br/>Country Name: Nepal', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(256, 'country', 154, 'Country created. <br/><br/>Country Name: Netherlands', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(257, 'country', 155, 'Country created. <br/><br/>Country Name: New Caledonia', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(258, 'country', 156, 'Country created. <br/><br/>Country Name: New Zealand', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(259, 'country', 157, 'Country created. <br/><br/>Country Name: Nicaragua', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(260, 'country', 158, 'Country created. <br/><br/>Country Name: Niger', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(261, 'country', 159, 'Country created. <br/><br/>Country Name: Nigeria', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(262, 'country', 160, 'Country created. <br/><br/>Country Name: Niue', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(263, 'country', 161, 'Country created. <br/><br/>Country Name: Norfolk Island', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(264, 'country', 162, 'Country created. <br/><br/>Country Name: North Korea', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(265, 'country', 163, 'Country created. <br/><br/>Country Name: North Macedonia', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(266, 'country', 164, 'Country created. <br/><br/>Country Name: Northern Mariana Islands', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(267, 'country', 165, 'Country created. <br/><br/>Country Name: Norway', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(268, 'country', 166, 'Country created. <br/><br/>Country Name: Oman', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(269, 'country', 167, 'Country created. <br/><br/>Country Name: Pakistan', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(270, 'country', 168, 'Country created. <br/><br/>Country Name: Palau', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(271, 'country', 169, 'Country created. <br/><br/>Country Name: Palestinian Territory Occupied', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(272, 'country', 170, 'Country created. <br/><br/>Country Name: Panama', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(273, 'country', 171, 'Country created. <br/><br/>Country Name: Papua new Guinea', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(274, 'country', 172, 'Country created. <br/><br/>Country Name: Paraguay', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(275, 'country', 173, 'Country created. <br/><br/>Country Name: Peru', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(276, 'country', 174, 'Country created. <br/><br/>Country Name: Philippines', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(277, 'country', 175, 'Country created. <br/><br/>Country Name: Pitcairn Island', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(278, 'country', 176, 'Country created. <br/><br/>Country Name: Poland', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(279, 'country', 177, 'Country created. <br/><br/>Country Name: Portugal', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(280, 'country', 178, 'Country created. <br/><br/>Country Name: Puerto Rico', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(281, 'country', 179, 'Country created. <br/><br/>Country Name: Qatar', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(282, 'country', 180, 'Country created. <br/><br/>Country Name: Reunion', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(283, 'country', 181, 'Country created. <br/><br/>Country Name: Romania', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(284, 'country', 182, 'Country created. <br/><br/>Country Name: Russia', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(285, 'country', 183, 'Country created. <br/><br/>Country Name: Rwanda', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(286, 'country', 184, 'Country created. <br/><br/>Country Name: Saint Helena', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(287, 'country', 185, 'Country created. <br/><br/>Country Name: Saint Kitts And Nevis', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(288, 'country', 186, 'Country created. <br/><br/>Country Name: Saint Lucia', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56');
INSERT INTO `audit_log` (`audit_log_id`, `table_name`, `reference_id`, `log`, `changed_by`, `changed_at`, `created_date`) VALUES
(289, 'country', 187, 'Country created. <br/><br/>Country Name: Saint Pierre and Miquelon', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(290, 'country', 188, 'Country created. <br/><br/>Country Name: Saint Vincent And The Grenadines', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(291, 'country', 189, 'Country created. <br/><br/>Country Name: Saint-Barthelemy', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(292, 'country', 190, 'Country created. <br/><br/>Country Name: Saint-Martin (French part)', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(293, 'country', 191, 'Country created. <br/><br/>Country Name: Samoa', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(294, 'country', 192, 'Country created. <br/><br/>Country Name: San Marino', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(295, 'country', 193, 'Country created. <br/><br/>Country Name: Sao Tome and Principe', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(296, 'country', 194, 'Country created. <br/><br/>Country Name: Saudi Arabia', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(297, 'country', 195, 'Country created. <br/><br/>Country Name: Senegal', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(298, 'country', 196, 'Country created. <br/><br/>Country Name: Serbia', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(299, 'country', 197, 'Country created. <br/><br/>Country Name: Seychelles', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(300, 'country', 198, 'Country created. <br/><br/>Country Name: Sierra Leone', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(301, 'country', 199, 'Country created. <br/><br/>Country Name: Singapore', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(302, 'country', 200, 'Country created. <br/><br/>Country Name: Sint Maarten (Dutch part)', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(303, 'country', 201, 'Country created. <br/><br/>Country Name: Slovakia', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(304, 'country', 202, 'Country created. <br/><br/>Country Name: Slovenia', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(305, 'country', 203, 'Country created. <br/><br/>Country Name: Solomon Islands', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(306, 'country', 204, 'Country created. <br/><br/>Country Name: Somalia', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(307, 'country', 205, 'Country created. <br/><br/>Country Name: South Africa', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(308, 'country', 206, 'Country created. <br/><br/>Country Name: South Georgia', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(309, 'country', 207, 'Country created. <br/><br/>Country Name: South Korea', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(310, 'country', 208, 'Country created. <br/><br/>Country Name: South Sudan', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(311, 'country', 209, 'Country created. <br/><br/>Country Name: Spain', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(312, 'country', 210, 'Country created. <br/><br/>Country Name: Sri Lanka', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(313, 'country', 211, 'Country created. <br/><br/>Country Name: Sudan', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(314, 'country', 212, 'Country created. <br/><br/>Country Name: Suriname', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(315, 'country', 213, 'Country created. <br/><br/>Country Name: Svalbard And Jan Mayen Islands', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(316, 'country', 214, 'Country created. <br/><br/>Country Name: Swaziland', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(317, 'country', 215, 'Country created. <br/><br/>Country Name: Sweden', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(318, 'country', 216, 'Country created. <br/><br/>Country Name: Switzerland', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(319, 'country', 217, 'Country created. <br/><br/>Country Name: Syria', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(320, 'country', 218, 'Country created. <br/><br/>Country Name: Taiwan', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(321, 'country', 219, 'Country created. <br/><br/>Country Name: Tajikistan', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(322, 'country', 220, 'Country created. <br/><br/>Country Name: Tanzania', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(323, 'country', 221, 'Country created. <br/><br/>Country Name: Thailand', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(324, 'country', 222, 'Country created. <br/><br/>Country Name: The Bahamas', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(325, 'country', 223, 'Country created. <br/><br/>Country Name: Togo', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(326, 'country', 224, 'Country created. <br/><br/>Country Name: Tokelau', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(327, 'country', 225, 'Country created. <br/><br/>Country Name: Tonga', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(328, 'country', 226, 'Country created. <br/><br/>Country Name: Trinidad And Tobago', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(329, 'country', 227, 'Country created. <br/><br/>Country Name: Tunisia', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(330, 'country', 228, 'Country created. <br/><br/>Country Name: Turkey', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(331, 'country', 229, 'Country created. <br/><br/>Country Name: Turkmenistan', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(332, 'country', 230, 'Country created. <br/><br/>Country Name: Turks And Caicos Islands', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(333, 'country', 231, 'Country created. <br/><br/>Country Name: Tuvalu', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(334, 'country', 232, 'Country created. <br/><br/>Country Name: Uganda', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(335, 'country', 233, 'Country created. <br/><br/>Country Name: Ukraine', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(336, 'country', 234, 'Country created. <br/><br/>Country Name: United Arab Emirates', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(337, 'country', 235, 'Country created. <br/><br/>Country Name: United Kingdom', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(338, 'country', 236, 'Country created. <br/><br/>Country Name: United States', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(339, 'country', 237, 'Country created. <br/><br/>Country Name: United States Minor Outlying Islands', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(340, 'country', 238, 'Country created. <br/><br/>Country Name: Uruguay', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(341, 'country', 239, 'Country created. <br/><br/>Country Name: Uzbekistan', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(342, 'country', 240, 'Country created. <br/><br/>Country Name: Vanuatu', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(343, 'country', 241, 'Country created. <br/><br/>Country Name: Vatican City State (Holy See)', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(344, 'country', 242, 'Country created. <br/><br/>Country Name: Venezuela', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(345, 'country', 243, 'Country created. <br/><br/>Country Name: Vietnam', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(346, 'country', 244, 'Country created. <br/><br/>Country Name: Virgin Islands (British)', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(347, 'country', 245, 'Country created. <br/><br/>Country Name: Virgin Islands (US)', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(348, 'country', 246, 'Country created. <br/><br/>Country Name: Wallis And Futuna Islands', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(349, 'country', 247, 'Country created. <br/><br/>Country Name: Western Sahara', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(350, 'country', 248, 'Country created. <br/><br/>Country Name: Yemen', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(351, 'country', 249, 'Country created. <br/><br/>Country Name: Zambia', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(352, 'country', 250, 'Country created. <br/><br/>Country Name: Zimbabwe', 1, '2024-06-26 15:33:56', '2024-06-26 15:33:56'),
(353, 'state', 83, 'State created. <br/><br/>State Name: Metro Manila<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(354, 'state', 84, 'State created. <br/><br/>State Name: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(355, 'state', 85, 'State created. <br/><br/>State Name: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(356, 'state', 86, 'State created. <br/><br/>State Name: La Union<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(357, 'state', 87, 'State created. <br/><br/>State Name: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(358, 'state', 88, 'State created. <br/><br/>State Name: Batanes<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(359, 'state', 89, 'State created. <br/><br/>State Name: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(360, 'state', 90, 'State created. <br/><br/>State Name: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(361, 'state', 91, 'State created. <br/><br/>State Name: Nueva Vizcaya<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(362, 'state', 92, 'State created. <br/><br/>State Name: Quirino<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(363, 'state', 93, 'State created. <br/><br/>State Name: Bataan<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(364, 'state', 94, 'State created. <br/><br/>State Name: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(365, 'state', 95, 'State created. <br/><br/>State Name: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(366, 'state', 96, 'State created. <br/><br/>State Name: Pampanga<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(367, 'state', 97, 'State created. <br/><br/>State Name: Tarlac<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(368, 'state', 98, 'State created. <br/><br/>State Name: Zambales<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(369, 'state', 99, 'State created. <br/><br/>State Name: Aurora<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(370, 'state', 100, 'State created. <br/><br/>State Name: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(371, 'state', 101, 'State created. <br/><br/>State Name: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(372, 'state', 102, 'State created. <br/><br/>State Name: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(373, 'state', 103, 'State created. <br/><br/>State Name: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(374, 'state', 104, 'State created. <br/><br/>State Name: Rizal<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(375, 'state', 105, 'State created. <br/><br/>State Name: Marinduque<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(376, 'state', 106, 'State created. <br/><br/>State Name: Occidental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(377, 'state', 107, 'State created. <br/><br/>State Name: Oriental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(378, 'state', 108, 'State created. <br/><br/>State Name: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(379, 'state', 109, 'State created. <br/><br/>State Name: Romblon<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(380, 'state', 110, 'State created. <br/><br/>State Name: Albay<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(381, 'state', 111, 'State created. <br/><br/>State Name: Camarines Norte<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(382, 'state', 112, 'State created. <br/><br/>State Name: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(383, 'state', 113, 'State created. <br/><br/>State Name: Catanduanes<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(384, 'state', 114, 'State created. <br/><br/>State Name: Masbate<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(385, 'state', 115, 'State created. <br/><br/>State Name: Sorsogon<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(386, 'state', 116, 'State created. <br/><br/>State Name: Aklan<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(387, 'state', 117, 'State created. <br/><br/>State Name: Antique<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(388, 'state', 118, 'State created. <br/><br/>State Name: Capiz<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(389, 'state', 119, 'State created. <br/><br/>State Name: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(390, 'state', 120, 'State created. <br/><br/>State Name: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(391, 'state', 121, 'State created. <br/><br/>State Name: Guimaras<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(392, 'state', 122, 'State created. <br/><br/>State Name: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(393, 'state', 123, 'State created. <br/><br/>State Name: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(394, 'state', 124, 'State created. <br/><br/>State Name: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(395, 'state', 125, 'State created. <br/><br/>State Name: Siquijor<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(396, 'state', 126, 'State created. <br/><br/>State Name: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(397, 'state', 127, 'State created. <br/><br/>State Name: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(398, 'state', 128, 'State created. <br/><br/>State Name: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(399, 'state', 129, 'State created. <br/><br/>State Name: Samar<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(400, 'state', 130, 'State created. <br/><br/>State Name: Southern Leyte<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(401, 'state', 131, 'State created. <br/><br/>State Name: Biliran<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(402, 'state', 132, 'State created. <br/><br/>State Name: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(403, 'state', 133, 'State created. <br/><br/>State Name: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(404, 'state', 134, 'State created. <br/><br/>State Name: Zamboanga Sibugay<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(405, 'state', 135, 'State created. <br/><br/>State Name: Bukidnon<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(406, 'state', 136, 'State created. <br/><br/>State Name: Camiguin<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(407, 'state', 137, 'State created. <br/><br/>State Name: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(408, 'state', 138, 'State created. <br/><br/>State Name: Misamis Occidental<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(409, 'state', 139, 'State created. <br/><br/>State Name: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(410, 'state', 140, 'State created. <br/><br/>State Name: Davao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(411, 'state', 141, 'State created. <br/><br/>State Name: Davao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(412, 'state', 142, 'State created. <br/><br/>State Name: Davao Oriental<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(413, 'state', 143, 'State created. <br/><br/>State Name: Davao de Oro<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(414, 'state', 144, 'State created. <br/><br/>State Name: Davao Occidental<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(415, 'state', 145, 'State created. <br/><br/>State Name: Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(416, 'state', 146, 'State created. <br/><br/>State Name: South Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(417, 'state', 147, 'State created. <br/><br/>State Name: Sultan Kudarat<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(418, 'state', 148, 'State created. <br/><br/>State Name: Sarangani<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(419, 'state', 149, 'State created. <br/><br/>State Name: Abra<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(420, 'state', 150, 'State created. <br/><br/>State Name: Benguet<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(421, 'state', 151, 'State created. <br/><br/>State Name: Ifugao<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(422, 'state', 152, 'State created. <br/><br/>State Name: Kalinga<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(423, 'state', 153, 'State created. <br/><br/>State Name: Mountain Province<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(424, 'state', 154, 'State created. <br/><br/>State Name: Apayao<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(425, 'state', 155, 'State created. <br/><br/>State Name: Basilan<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(426, 'state', 156, 'State created. <br/><br/>State Name: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(427, 'state', 157, 'State created. <br/><br/>State Name: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(428, 'state', 158, 'State created. <br/><br/>State Name: Sulu<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(429, 'state', 159, 'State created. <br/><br/>State Name: Tawi-Tawi<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(430, 'state', 160, 'State created. <br/><br/>State Name: Agusan del Norte<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(431, 'state', 161, 'State created. <br/><br/>State Name: Agusan del Sur<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(432, 'state', 162, 'State created. <br/><br/>State Name: Surigao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(433, 'state', 163, 'State created. <br/><br/>State Name: Surigao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(434, 'state', 164, 'State created. <br/><br/>State Name: Dinagat Islands<br/>Country: Philippines', 1, '2024-06-26 15:40:07', '2024-06-26 15:40:07'),
(435, 'state', 1, 'State created. <br/><br/>State Name: Metro Manila<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(436, 'state', 2, 'State created. <br/><br/>State Name: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(437, 'state', 3, 'State created. <br/><br/>State Name: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(438, 'state', 4, 'State created. <br/><br/>State Name: La Union<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(439, 'state', 5, 'State created. <br/><br/>State Name: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(440, 'state', 6, 'State created. <br/><br/>State Name: Batanes<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(441, 'state', 7, 'State created. <br/><br/>State Name: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(442, 'state', 8, 'State created. <br/><br/>State Name: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(443, 'state', 9, 'State created. <br/><br/>State Name: Nueva Vizcaya<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(444, 'state', 10, 'State created. <br/><br/>State Name: Quirino<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(445, 'state', 11, 'State created. <br/><br/>State Name: Bataan<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(446, 'state', 12, 'State created. <br/><br/>State Name: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(447, 'state', 13, 'State created. <br/><br/>State Name: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(448, 'state', 14, 'State created. <br/><br/>State Name: Pampanga<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(449, 'state', 15, 'State created. <br/><br/>State Name: Tarlac<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(450, 'state', 16, 'State created. <br/><br/>State Name: Zambales<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(451, 'state', 17, 'State created. <br/><br/>State Name: Aurora<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(452, 'state', 18, 'State created. <br/><br/>State Name: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(453, 'state', 19, 'State created. <br/><br/>State Name: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(454, 'state', 20, 'State created. <br/><br/>State Name: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(455, 'state', 21, 'State created. <br/><br/>State Name: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(456, 'state', 22, 'State created. <br/><br/>State Name: Rizal<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(457, 'state', 23, 'State created. <br/><br/>State Name: Marinduque<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(458, 'state', 24, 'State created. <br/><br/>State Name: Occidental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(459, 'state', 25, 'State created. <br/><br/>State Name: Oriental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(460, 'state', 26, 'State created. <br/><br/>State Name: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(461, 'state', 27, 'State created. <br/><br/>State Name: Romblon<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(462, 'state', 28, 'State created. <br/><br/>State Name: Albay<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(463, 'state', 29, 'State created. <br/><br/>State Name: Camarines Norte<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(464, 'state', 30, 'State created. <br/><br/>State Name: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(465, 'state', 31, 'State created. <br/><br/>State Name: Catanduanes<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(466, 'state', 32, 'State created. <br/><br/>State Name: Masbate<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(467, 'state', 33, 'State created. <br/><br/>State Name: Sorsogon<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(468, 'state', 34, 'State created. <br/><br/>State Name: Aklan<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(469, 'state', 35, 'State created. <br/><br/>State Name: Antique<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(470, 'state', 36, 'State created. <br/><br/>State Name: Capiz<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(471, 'state', 37, 'State created. <br/><br/>State Name: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(472, 'state', 38, 'State created. <br/><br/>State Name: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(473, 'state', 39, 'State created. <br/><br/>State Name: Guimaras<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(474, 'state', 40, 'State created. <br/><br/>State Name: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(475, 'state', 41, 'State created. <br/><br/>State Name: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(476, 'state', 42, 'State created. <br/><br/>State Name: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(477, 'state', 43, 'State created. <br/><br/>State Name: Siquijor<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(478, 'state', 44, 'State created. <br/><br/>State Name: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(479, 'state', 45, 'State created. <br/><br/>State Name: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(480, 'state', 46, 'State created. <br/><br/>State Name: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(481, 'state', 47, 'State created. <br/><br/>State Name: Samar<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(482, 'state', 48, 'State created. <br/><br/>State Name: Southern Leyte<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(483, 'state', 49, 'State created. <br/><br/>State Name: Biliran<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(484, 'state', 50, 'State created. <br/><br/>State Name: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(485, 'state', 51, 'State created. <br/><br/>State Name: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(486, 'state', 52, 'State created. <br/><br/>State Name: Zamboanga Sibugay<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(487, 'state', 53, 'State created. <br/><br/>State Name: Bukidnon<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(488, 'state', 54, 'State created. <br/><br/>State Name: Camiguin<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(489, 'state', 55, 'State created. <br/><br/>State Name: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(490, 'state', 56, 'State created. <br/><br/>State Name: Misamis Occidental<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(491, 'state', 57, 'State created. <br/><br/>State Name: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(492, 'state', 58, 'State created. <br/><br/>State Name: Davao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(493, 'state', 59, 'State created. <br/><br/>State Name: Davao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(494, 'state', 60, 'State created. <br/><br/>State Name: Davao Oriental<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(495, 'state', 61, 'State created. <br/><br/>State Name: Davao de Oro<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(496, 'state', 62, 'State created. <br/><br/>State Name: Davao Occidental<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(497, 'state', 63, 'State created. <br/><br/>State Name: Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(498, 'state', 64, 'State created. <br/><br/>State Name: South Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(499, 'state', 65, 'State created. <br/><br/>State Name: Sultan Kudarat<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(500, 'state', 66, 'State created. <br/><br/>State Name: Sarangani<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(501, 'state', 67, 'State created. <br/><br/>State Name: Abra<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(502, 'state', 68, 'State created. <br/><br/>State Name: Benguet<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(503, 'state', 69, 'State created. <br/><br/>State Name: Ifugao<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(504, 'state', 70, 'State created. <br/><br/>State Name: Kalinga<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(505, 'state', 71, 'State created. <br/><br/>State Name: Mountain Province<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(506, 'state', 72, 'State created. <br/><br/>State Name: Apayao<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(507, 'state', 73, 'State created. <br/><br/>State Name: Basilan<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(508, 'state', 74, 'State created. <br/><br/>State Name: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(509, 'state', 75, 'State created. <br/><br/>State Name: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(510, 'state', 76, 'State created. <br/><br/>State Name: Sulu<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(511, 'state', 77, 'State created. <br/><br/>State Name: Tawi-Tawi<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(512, 'state', 78, 'State created. <br/><br/>State Name: Agusan del Norte<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(513, 'state', 79, 'State created. <br/><br/>State Name: Agusan del Sur<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(514, 'state', 80, 'State created. <br/><br/>State Name: Surigao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(515, 'state', 81, 'State created. <br/><br/>State Name: Surigao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(516, 'state', 82, 'State created. <br/><br/>State Name: Dinagat Islands<br/>Country: Philippines', 1, '2024-06-26 15:40:48', '2024-06-26 15:40:48'),
(517, 'city', 1, 'City created. <br/><br/>City Name: Adams<br/>State: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(518, 'city', 2, 'City created. <br/><br/>City Name: Bacarra<br/>State: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(519, 'city', 3, 'City created. <br/><br/>City Name: Badoc<br/>State: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(520, 'city', 4, 'City created. <br/><br/>City Name: Bangui<br/>State: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(521, 'city', 5, 'City created. <br/><br/>City Name: City of Batac<br/>State: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(522, 'city', 6, 'City created. <br/><br/>City Name: Burgos<br/>State: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(523, 'city', 7, 'City created. <br/><br/>City Name: Carasi<br/>State: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(524, 'city', 8, 'City created. <br/><br/>City Name: Currimao<br/>State: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(525, 'city', 9, 'City created. <br/><br/>City Name: Dingras<br/>State: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(526, 'city', 10, 'City created. <br/><br/>City Name: Dumalneg<br/>State: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(527, 'city', 11, 'City created. <br/><br/>City Name: Banna<br/>State: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(528, 'city', 12, 'City created. <br/><br/>City Name: City of Laoag<br/>State: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(529, 'city', 13, 'City created. <br/><br/>City Name: Marcos<br/>State: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(530, 'city', 14, 'City created. <br/><br/>City Name: Nueva Era<br/>State: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(531, 'city', 15, 'City created. <br/><br/>City Name: Pagudpud<br/>State: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(532, 'city', 16, 'City created. <br/><br/>City Name: Paoay<br/>State: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(533, 'city', 17, 'City created. <br/><br/>City Name: Pasuquin<br/>State: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(534, 'city', 18, 'City created. <br/><br/>City Name: Piddig<br/>State: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(535, 'city', 19, 'City created. <br/><br/>City Name: Pinili<br/>State: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(536, 'city', 20, 'City created. <br/><br/>City Name: San Nicolas<br/>State: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(537, 'city', 21, 'City created. <br/><br/>City Name: Sarrat<br/>State: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(538, 'city', 22, 'City created. <br/><br/>City Name: Solsona<br/>State: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(539, 'city', 23, 'City created. <br/><br/>City Name: Vintar<br/>State: Ilocos Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(540, 'city', 24, 'City created. <br/><br/>City Name: Alilem<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(541, 'city', 25, 'City created. <br/><br/>City Name: Banayoyo<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(542, 'city', 26, 'City created. <br/><br/>City Name: Bantay<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(543, 'city', 27, 'City created. <br/><br/>City Name: Burgos<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(544, 'city', 28, 'City created. <br/><br/>City Name: Cabugao<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(545, 'city', 29, 'City created. <br/><br/>City Name: City of Candon<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(546, 'city', 30, 'City created. <br/><br/>City Name: Caoayan<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(547, 'city', 31, 'City created. <br/><br/>City Name: Cervantes<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(548, 'city', 32, 'City created. <br/><br/>City Name: Galimuyod<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(549, 'city', 33, 'City created. <br/><br/>City Name: Gregorio del Pilar<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(550, 'city', 34, 'City created. <br/><br/>City Name: Lidlidda<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(551, 'city', 35, 'City created. <br/><br/>City Name: Magsingal<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(552, 'city', 36, 'City created. <br/><br/>City Name: Nagbukel<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(553, 'city', 37, 'City created. <br/><br/>City Name: Narvacan<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(554, 'city', 38, 'City created. <br/><br/>City Name: Quirino<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(555, 'city', 39, 'City created. <br/><br/>City Name: Salcedo<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(556, 'city', 40, 'City created. <br/><br/>City Name: San Emilio<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(557, 'city', 41, 'City created. <br/><br/>City Name: San Esteban<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(558, 'city', 42, 'City created. <br/><br/>City Name: San Ildefonso<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(559, 'city', 43, 'City created. <br/><br/>City Name: San Juan<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(560, 'city', 44, 'City created. <br/><br/>City Name: San Vicente<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(561, 'city', 45, 'City created. <br/><br/>City Name: Santa<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(562, 'city', 46, 'City created. <br/><br/>City Name: Santa Catalina<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(563, 'city', 47, 'City created. <br/><br/>City Name: Santa Cruz<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(564, 'city', 48, 'City created. <br/><br/>City Name: Santa Lucia<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(565, 'city', 49, 'City created. <br/><br/>City Name: Santa Maria<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(566, 'city', 50, 'City created. <br/><br/>City Name: Santiago<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(567, 'city', 51, 'City created. <br/><br/>City Name: Santo Domingo<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(568, 'city', 52, 'City created. <br/><br/>City Name: Sigay<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(569, 'city', 53, 'City created. <br/><br/>City Name: Sinait<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(570, 'city', 54, 'City created. <br/><br/>City Name: Sugpon<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(571, 'city', 55, 'City created. <br/><br/>City Name: Suyo<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(572, 'city', 56, 'City created. <br/><br/>City Name: Tagudin<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(573, 'city', 57, 'City created. <br/><br/>City Name: City of Vigan<br/>State: Ilocos Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(574, 'city', 58, 'City created. <br/><br/>City Name: Agoo<br/>State: La Union<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(575, 'city', 59, 'City created. <br/><br/>City Name: Aringay<br/>State: La Union<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(576, 'city', 60, 'City created. <br/><br/>City Name: Bacnotan<br/>State: La Union<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(577, 'city', 61, 'City created. <br/><br/>City Name: Bagulin<br/>State: La Union<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(578, 'city', 62, 'City created. <br/><br/>City Name: Balaoan<br/>State: La Union<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(579, 'city', 63, 'City created. <br/><br/>City Name: Bangar<br/>State: La Union<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(580, 'city', 64, 'City created. <br/><br/>City Name: Bauang<br/>State: La Union<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(581, 'city', 65, 'City created. <br/><br/>City Name: Burgos<br/>State: La Union<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(582, 'city', 66, 'City created. <br/><br/>City Name: Caba<br/>State: La Union<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(583, 'city', 67, 'City created. <br/><br/>City Name: Luna<br/>State: La Union<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(584, 'city', 68, 'City created. <br/><br/>City Name: Naguilian<br/>State: La Union<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(585, 'city', 69, 'City created. <br/><br/>City Name: Pugo<br/>State: La Union<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(586, 'city', 70, 'City created. <br/><br/>City Name: Rosario<br/>State: La Union<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(587, 'city', 71, 'City created. <br/><br/>City Name: City of San Fernando<br/>State: La Union<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(588, 'city', 72, 'City created. <br/><br/>City Name: San Gabriel<br/>State: La Union<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(589, 'city', 73, 'City created. <br/><br/>City Name: San Juan<br/>State: La Union<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(590, 'city', 74, 'City created. <br/><br/>City Name: Santo Tomas<br/>State: La Union<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(591, 'city', 75, 'City created. <br/><br/>City Name: Santol<br/>State: La Union<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(592, 'city', 76, 'City created. <br/><br/>City Name: Sudipen<br/>State: La Union<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(593, 'city', 77, 'City created. <br/><br/>City Name: Tubao<br/>State: La Union<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(594, 'city', 78, 'City created. <br/><br/>City Name: Agno<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(595, 'city', 79, 'City created. <br/><br/>City Name: Aguilar<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(596, 'city', 80, 'City created. <br/><br/>City Name: City of Alaminos<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(597, 'city', 81, 'City created. <br/><br/>City Name: Alcala<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(598, 'city', 82, 'City created. <br/><br/>City Name: Anda<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(599, 'city', 83, 'City created. <br/><br/>City Name: Asingan<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(600, 'city', 84, 'City created. <br/><br/>City Name: Balungao<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(601, 'city', 85, 'City created. <br/><br/>City Name: Bani<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(602, 'city', 86, 'City created. <br/><br/>City Name: Basista<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(603, 'city', 87, 'City created. <br/><br/>City Name: Bautista<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(604, 'city', 88, 'City created. <br/><br/>City Name: Bayambang<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(605, 'city', 89, 'City created. <br/><br/>City Name: Binalonan<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(606, 'city', 90, 'City created. <br/><br/>City Name: Binmaley<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(607, 'city', 91, 'City created. <br/><br/>City Name: Bolinao<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(608, 'city', 92, 'City created. <br/><br/>City Name: Bugallon<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(609, 'city', 93, 'City created. <br/><br/>City Name: Burgos<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(610, 'city', 94, 'City created. <br/><br/>City Name: Calasiao<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(611, 'city', 95, 'City created. <br/><br/>City Name: City of Dagupan<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(612, 'city', 96, 'City created. <br/><br/>City Name: Dasol<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(613, 'city', 97, 'City created. <br/><br/>City Name: Infanta<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(614, 'city', 98, 'City created. <br/><br/>City Name: Labrador<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(615, 'city', 99, 'City created. <br/><br/>City Name: Lingayen<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(616, 'city', 100, 'City created. <br/><br/>City Name: Mabini<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(617, 'city', 101, 'City created. <br/><br/>City Name: Malasiqui<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(618, 'city', 102, 'City created. <br/><br/>City Name: Manaoag<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(619, 'city', 103, 'City created. <br/><br/>City Name: Mangaldan<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(620, 'city', 104, 'City created. <br/><br/>City Name: Mangatarem<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(621, 'city', 105, 'City created. <br/><br/>City Name: Mapandan<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(622, 'city', 106, 'City created. <br/><br/>City Name: Natividad<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(623, 'city', 107, 'City created. <br/><br/>City Name: Pozorrubio<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(624, 'city', 108, 'City created. <br/><br/>City Name: Rosales<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(625, 'city', 109, 'City created. <br/><br/>City Name: City of San Carlos<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(626, 'city', 110, 'City created. <br/><br/>City Name: San Fabian<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(627, 'city', 111, 'City created. <br/><br/>City Name: San Jacinto<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(628, 'city', 112, 'City created. <br/><br/>City Name: San Manuel<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13'),
(629, 'city', 113, 'City created. <br/><br/>City Name: San Nicolas<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:13', '2024-06-26 15:48:13');
INSERT INTO `audit_log` (`audit_log_id`, `table_name`, `reference_id`, `log`, `changed_by`, `changed_at`, `created_date`) VALUES
(630, 'city', 114, 'City created. <br/><br/>City Name: San Quintin<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(631, 'city', 115, 'City created. <br/><br/>City Name: Santa Barbara<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(632, 'city', 116, 'City created. <br/><br/>City Name: Santa Maria<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(633, 'city', 117, 'City created. <br/><br/>City Name: Santo Tomas<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(634, 'city', 118, 'City created. <br/><br/>City Name: Sison<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(635, 'city', 119, 'City created. <br/><br/>City Name: Sual<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(636, 'city', 120, 'City created. <br/><br/>City Name: Tayug<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(637, 'city', 121, 'City created. <br/><br/>City Name: Umingan<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(638, 'city', 122, 'City created. <br/><br/>City Name: Urbiztondo<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(639, 'city', 123, 'City created. <br/><br/>City Name: City of Urdaneta<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(640, 'city', 124, 'City created. <br/><br/>City Name: Villasis<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(641, 'city', 125, 'City created. <br/><br/>City Name: Laoac<br/>State: Pangasinan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(642, 'city', 126, 'City created. <br/><br/>City Name: Basco<br/>State: Batanes<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(643, 'city', 127, 'City created. <br/><br/>City Name: Itbayat<br/>State: Batanes<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(644, 'city', 128, 'City created. <br/><br/>City Name: Ivana<br/>State: Batanes<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(645, 'city', 129, 'City created. <br/><br/>City Name: Mahatao<br/>State: Batanes<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(646, 'city', 130, 'City created. <br/><br/>City Name: Sabtang<br/>State: Batanes<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(647, 'city', 131, 'City created. <br/><br/>City Name: Uyugan<br/>State: Batanes<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(648, 'city', 132, 'City created. <br/><br/>City Name: Abulug<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(649, 'city', 133, 'City created. <br/><br/>City Name: Alcala<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(650, 'city', 134, 'City created. <br/><br/>City Name: Allacapan<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(651, 'city', 135, 'City created. <br/><br/>City Name: Amulung<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(652, 'city', 136, 'City created. <br/><br/>City Name: Aparri<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(653, 'city', 137, 'City created. <br/><br/>City Name: Baggao<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(654, 'city', 138, 'City created. <br/><br/>City Name: Ballesteros<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(655, 'city', 139, 'City created. <br/><br/>City Name: Buguey<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(656, 'city', 140, 'City created. <br/><br/>City Name: Calayan<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(657, 'city', 141, 'City created. <br/><br/>City Name: Camalaniugan<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(658, 'city', 142, 'City created. <br/><br/>City Name: Claveria<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(659, 'city', 143, 'City created. <br/><br/>City Name: Enrile<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(660, 'city', 144, 'City created. <br/><br/>City Name: Gattaran<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(661, 'city', 145, 'City created. <br/><br/>City Name: Gonzaga<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(662, 'city', 146, 'City created. <br/><br/>City Name: Iguig<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(663, 'city', 147, 'City created. <br/><br/>City Name: Lal-Lo<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(664, 'city', 148, 'City created. <br/><br/>City Name: Lasam<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(665, 'city', 149, 'City created. <br/><br/>City Name: Pamplona<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(666, 'city', 150, 'City created. <br/><br/>City Name: Peñablanca<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(667, 'city', 151, 'City created. <br/><br/>City Name: Piat<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(668, 'city', 152, 'City created. <br/><br/>City Name: Rizal<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(669, 'city', 153, 'City created. <br/><br/>City Name: Sanchez-Mira<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(670, 'city', 154, 'City created. <br/><br/>City Name: Santa Ana<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(671, 'city', 155, 'City created. <br/><br/>City Name: Santa Praxedes<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(672, 'city', 156, 'City created. <br/><br/>City Name: Santa Teresita<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(673, 'city', 157, 'City created. <br/><br/>City Name: Santo Niño<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(674, 'city', 158, 'City created. <br/><br/>City Name: Solana<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(675, 'city', 159, 'City created. <br/><br/>City Name: Tuao<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(676, 'city', 160, 'City created. <br/><br/>City Name: Tuguegarao City<br/>State: Cagayan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(677, 'city', 161, 'City created. <br/><br/>City Name: Alicia<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(678, 'city', 162, 'City created. <br/><br/>City Name: Angadanan<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(679, 'city', 163, 'City created. <br/><br/>City Name: Aurora<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(680, 'city', 164, 'City created. <br/><br/>City Name: Benito Soliven<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(681, 'city', 165, 'City created. <br/><br/>City Name: Burgos<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(682, 'city', 166, 'City created. <br/><br/>City Name: Cabagan<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(683, 'city', 167, 'City created. <br/><br/>City Name: Cabatuan<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(684, 'city', 168, 'City created. <br/><br/>City Name: City of Cauayan<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(685, 'city', 169, 'City created. <br/><br/>City Name: Cordon<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(686, 'city', 170, 'City created. <br/><br/>City Name: Dinapigue<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(687, 'city', 171, 'City created. <br/><br/>City Name: Divilacan<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(688, 'city', 172, 'City created. <br/><br/>City Name: Echague<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(689, 'city', 173, 'City created. <br/><br/>City Name: Gamu<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(690, 'city', 174, 'City created. <br/><br/>City Name: City of Ilagan<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(691, 'city', 175, 'City created. <br/><br/>City Name: Jones<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(692, 'city', 176, 'City created. <br/><br/>City Name: Luna<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(693, 'city', 177, 'City created. <br/><br/>City Name: Maconacon<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(694, 'city', 178, 'City created. <br/><br/>City Name: Delfin Albano<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(695, 'city', 179, 'City created. <br/><br/>City Name: Mallig<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(696, 'city', 180, 'City created. <br/><br/>City Name: Naguilian<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(697, 'city', 181, 'City created. <br/><br/>City Name: Palanan<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(698, 'city', 182, 'City created. <br/><br/>City Name: Quezon<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(699, 'city', 183, 'City created. <br/><br/>City Name: Quirino<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(700, 'city', 184, 'City created. <br/><br/>City Name: Ramon<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(701, 'city', 185, 'City created. <br/><br/>City Name: Reina Mercedes<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(702, 'city', 186, 'City created. <br/><br/>City Name: Roxas<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(703, 'city', 187, 'City created. <br/><br/>City Name: San Agustin<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(704, 'city', 188, 'City created. <br/><br/>City Name: San Guillermo<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(705, 'city', 189, 'City created. <br/><br/>City Name: San Isidro<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(706, 'city', 190, 'City created. <br/><br/>City Name: San Manuel<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(707, 'city', 191, 'City created. <br/><br/>City Name: San Mariano<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(708, 'city', 192, 'City created. <br/><br/>City Name: San Mateo<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(709, 'city', 193, 'City created. <br/><br/>City Name: San Pablo<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(710, 'city', 194, 'City created. <br/><br/>City Name: Santa Maria<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(711, 'city', 195, 'City created. <br/><br/>City Name: City of Santiago<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(712, 'city', 196, 'City created. <br/><br/>City Name: Santo Tomas<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(713, 'city', 197, 'City created. <br/><br/>City Name: Tumauini<br/>State: Isabela<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(714, 'city', 198, 'City created. <br/><br/>City Name: Ambaguio<br/>State: Nueva Vizcaya<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(715, 'city', 199, 'City created. <br/><br/>City Name: Aritao<br/>State: Nueva Vizcaya<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(716, 'city', 200, 'City created. <br/><br/>City Name: Bagabag<br/>State: Nueva Vizcaya<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(717, 'city', 201, 'City created. <br/><br/>City Name: Bambang<br/>State: Nueva Vizcaya<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(718, 'city', 202, 'City created. <br/><br/>City Name: Bayombong<br/>State: Nueva Vizcaya<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(719, 'city', 203, 'City created. <br/><br/>City Name: Diadi<br/>State: Nueva Vizcaya<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(720, 'city', 204, 'City created. <br/><br/>City Name: Dupax del Norte<br/>State: Nueva Vizcaya<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(721, 'city', 205, 'City created. <br/><br/>City Name: Dupax del Sur<br/>State: Nueva Vizcaya<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(722, 'city', 206, 'City created. <br/><br/>City Name: Kasibu<br/>State: Nueva Vizcaya<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(723, 'city', 207, 'City created. <br/><br/>City Name: Kayapa<br/>State: Nueva Vizcaya<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(724, 'city', 208, 'City created. <br/><br/>City Name: Quezon<br/>State: Nueva Vizcaya<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(725, 'city', 209, 'City created. <br/><br/>City Name: Santa Fe<br/>State: Nueva Vizcaya<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(726, 'city', 210, 'City created. <br/><br/>City Name: Solano<br/>State: Nueva Vizcaya<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(727, 'city', 211, 'City created. <br/><br/>City Name: Villaverde<br/>State: Nueva Vizcaya<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(728, 'city', 212, 'City created. <br/><br/>City Name: Alfonso Castaneda<br/>State: Nueva Vizcaya<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(729, 'city', 213, 'City created. <br/><br/>City Name: Aglipay<br/>State: Quirino<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(730, 'city', 214, 'City created. <br/><br/>City Name: Cabarroguis<br/>State: Quirino<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(731, 'city', 215, 'City created. <br/><br/>City Name: Diffun<br/>State: Quirino<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(732, 'city', 216, 'City created. <br/><br/>City Name: Maddela<br/>State: Quirino<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(733, 'city', 217, 'City created. <br/><br/>City Name: Saguday<br/>State: Quirino<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(734, 'city', 218, 'City created. <br/><br/>City Name: Nagtipunan<br/>State: Quirino<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(735, 'city', 219, 'City created. <br/><br/>City Name: Abucay<br/>State: Bataan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(736, 'city', 220, 'City created. <br/><br/>City Name: Bagac<br/>State: Bataan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(737, 'city', 221, 'City created. <br/><br/>City Name: City of Balanga<br/>State: Bataan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(738, 'city', 222, 'City created. <br/><br/>City Name: Dinalupihan<br/>State: Bataan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(739, 'city', 223, 'City created. <br/><br/>City Name: Hermosa<br/>State: Bataan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(740, 'city', 224, 'City created. <br/><br/>City Name: Limay<br/>State: Bataan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(741, 'city', 225, 'City created. <br/><br/>City Name: Mariveles<br/>State: Bataan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(742, 'city', 226, 'City created. <br/><br/>City Name: Morong<br/>State: Bataan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(743, 'city', 227, 'City created. <br/><br/>City Name: Orani<br/>State: Bataan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(744, 'city', 228, 'City created. <br/><br/>City Name: Orion<br/>State: Bataan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(745, 'city', 229, 'City created. <br/><br/>City Name: Pilar<br/>State: Bataan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(746, 'city', 230, 'City created. <br/><br/>City Name: Samal<br/>State: Bataan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(747, 'city', 231, 'City created. <br/><br/>City Name: Angat<br/>State: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(748, 'city', 232, 'City created. <br/><br/>City Name: Balagtas<br/>State: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(749, 'city', 233, 'City created. <br/><br/>City Name: Baliuag<br/>State: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(750, 'city', 234, 'City created. <br/><br/>City Name: Bocaue<br/>State: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(751, 'city', 235, 'City created. <br/><br/>City Name: Bulacan<br/>State: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(752, 'city', 236, 'City created. <br/><br/>City Name: Bustos<br/>State: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(753, 'city', 237, 'City created. <br/><br/>City Name: Calumpit<br/>State: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(754, 'city', 238, 'City created. <br/><br/>City Name: Guiguinto<br/>State: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(755, 'city', 239, 'City created. <br/><br/>City Name: Hagonoy<br/>State: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(756, 'city', 240, 'City created. <br/><br/>City Name: City of Malolos<br/>State: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(757, 'city', 241, 'City created. <br/><br/>City Name: Marilao<br/>State: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(758, 'city', 242, 'City created. <br/><br/>City Name: City of Meycauayan<br/>State: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(759, 'city', 243, 'City created. <br/><br/>City Name: Norzagaray<br/>State: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(760, 'city', 244, 'City created. <br/><br/>City Name: Obando<br/>State: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(761, 'city', 245, 'City created. <br/><br/>City Name: Pandi<br/>State: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(762, 'city', 246, 'City created. <br/><br/>City Name: Paombong<br/>State: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(763, 'city', 247, 'City created. <br/><br/>City Name: Plaridel<br/>State: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(764, 'city', 248, 'City created. <br/><br/>City Name: Pulilan<br/>State: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(765, 'city', 249, 'City created. <br/><br/>City Name: San Ildefonso<br/>State: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(766, 'city', 250, 'City created. <br/><br/>City Name: City of San Jose Del Monte<br/>State: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(767, 'city', 251, 'City created. <br/><br/>City Name: San Miguel<br/>State: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(768, 'city', 252, 'City created. <br/><br/>City Name: San Rafael<br/>State: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(769, 'city', 253, 'City created. <br/><br/>City Name: Santa Maria<br/>State: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(770, 'city', 254, 'City created. <br/><br/>City Name: Doña Remedios Trinidad<br/>State: Bulacan<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(771, 'city', 255, 'City created. <br/><br/>City Name: Aliaga<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(772, 'city', 256, 'City created. <br/><br/>City Name: Bongabon<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(773, 'city', 257, 'City created. <br/><br/>City Name: City of Cabanatuan<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(774, 'city', 258, 'City created. <br/><br/>City Name: Cabiao<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(775, 'city', 259, 'City created. <br/><br/>City Name: Carranglan<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(776, 'city', 260, 'City created. <br/><br/>City Name: Cuyapo<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(777, 'city', 261, 'City created. <br/><br/>City Name: Gabaldon<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(778, 'city', 262, 'City created. <br/><br/>City Name: City of Gapan<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(779, 'city', 263, 'City created. <br/><br/>City Name: General Mamerto Natividad<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(780, 'city', 264, 'City created. <br/><br/>City Name: General Tinio<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(781, 'city', 265, 'City created. <br/><br/>City Name: Guimba<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(782, 'city', 266, 'City created. <br/><br/>City Name: Jaen<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(783, 'city', 267, 'City created. <br/><br/>City Name: Laur<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(784, 'city', 268, 'City created. <br/><br/>City Name: Licab<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(785, 'city', 269, 'City created. <br/><br/>City Name: Llanera<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(786, 'city', 270, 'City created. <br/><br/>City Name: Lupao<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(787, 'city', 271, 'City created. <br/><br/>City Name: Science City of Muñoz<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(788, 'city', 272, 'City created. <br/><br/>City Name: Nampicuan<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(789, 'city', 273, 'City created. <br/><br/>City Name: City of Palayan<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(790, 'city', 274, 'City created. <br/><br/>City Name: Pantabangan<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(791, 'city', 275, 'City created. <br/><br/>City Name: Peñaranda<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(792, 'city', 276, 'City created. <br/><br/>City Name: Quezon<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(793, 'city', 277, 'City created. <br/><br/>City Name: Rizal<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(794, 'city', 278, 'City created. <br/><br/>City Name: San Antonio<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(795, 'city', 279, 'City created. <br/><br/>City Name: San Isidro<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(796, 'city', 280, 'City created. <br/><br/>City Name: San Jose City<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(797, 'city', 281, 'City created. <br/><br/>City Name: San Leonardo<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(798, 'city', 282, 'City created. <br/><br/>City Name: Santa Rosa<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(799, 'city', 283, 'City created. <br/><br/>City Name: Santo Domingo<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(800, 'city', 284, 'City created. <br/><br/>City Name: Talavera<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(801, 'city', 285, 'City created. <br/><br/>City Name: Talugtug<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(802, 'city', 286, 'City created. <br/><br/>City Name: Zaragoza<br/>State: Nueva Ecija<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(803, 'city', 287, 'City created. <br/><br/>City Name: City of Angeles<br/>State: Pampanga<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(804, 'city', 288, 'City created. <br/><br/>City Name: Apalit<br/>State: Pampanga<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(805, 'city', 289, 'City created. <br/><br/>City Name: Arayat<br/>State: Pampanga<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(806, 'city', 290, 'City created. <br/><br/>City Name: Bacolor<br/>State: Pampanga<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(807, 'city', 291, 'City created. <br/><br/>City Name: Candaba<br/>State: Pampanga<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(808, 'city', 292, 'City created. <br/><br/>City Name: Floridablanca<br/>State: Pampanga<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(809, 'city', 293, 'City created. <br/><br/>City Name: Guagua<br/>State: Pampanga<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(810, 'city', 294, 'City created. <br/><br/>City Name: Lubao<br/>State: Pampanga<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(811, 'city', 295, 'City created. <br/><br/>City Name: Mabalacat City<br/>State: Pampanga<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(812, 'city', 296, 'City created. <br/><br/>City Name: Macabebe<br/>State: Pampanga<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(813, 'city', 297, 'City created. <br/><br/>City Name: Magalang<br/>State: Pampanga<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(814, 'city', 298, 'City created. <br/><br/>City Name: Masantol<br/>State: Pampanga<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(815, 'city', 299, 'City created. <br/><br/>City Name: Mexico<br/>State: Pampanga<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(816, 'city', 300, 'City created. <br/><br/>City Name: Minalin<br/>State: Pampanga<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(817, 'city', 301, 'City created. <br/><br/>City Name: Porac<br/>State: Pampanga<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(818, 'city', 302, 'City created. <br/><br/>City Name: City of San Fernando<br/>State: Pampanga<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(819, 'city', 303, 'City created. <br/><br/>City Name: San Luis<br/>State: Pampanga<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(820, 'city', 304, 'City created. <br/><br/>City Name: San Simon<br/>State: Pampanga<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(821, 'city', 305, 'City created. <br/><br/>City Name: Santa Ana<br/>State: Pampanga<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(822, 'city', 306, 'City created. <br/><br/>City Name: Santa Rita<br/>State: Pampanga<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(823, 'city', 307, 'City created. <br/><br/>City Name: Santo Tomas<br/>State: Pampanga<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(824, 'city', 308, 'City created. <br/><br/>City Name: Sasmuan<br/>State: Pampanga<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(825, 'city', 309, 'City created. <br/><br/>City Name: Anao<br/>State: Tarlac<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(826, 'city', 310, 'City created. <br/><br/>City Name: Bamban<br/>State: Tarlac<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(827, 'city', 311, 'City created. <br/><br/>City Name: Camiling<br/>State: Tarlac<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(828, 'city', 312, 'City created. <br/><br/>City Name: Capas<br/>State: Tarlac<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(829, 'city', 313, 'City created. <br/><br/>City Name: Concepcion<br/>State: Tarlac<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(830, 'city', 314, 'City created. <br/><br/>City Name: Gerona<br/>State: Tarlac<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(831, 'city', 315, 'City created. <br/><br/>City Name: La Paz<br/>State: Tarlac<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(832, 'city', 316, 'City created. <br/><br/>City Name: Mayantoc<br/>State: Tarlac<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(833, 'city', 317, 'City created. <br/><br/>City Name: Moncada<br/>State: Tarlac<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(834, 'city', 318, 'City created. <br/><br/>City Name: Paniqui<br/>State: Tarlac<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(835, 'city', 319, 'City created. <br/><br/>City Name: Pura<br/>State: Tarlac<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(836, 'city', 320, 'City created. <br/><br/>City Name: Ramos<br/>State: Tarlac<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(837, 'city', 321, 'City created. <br/><br/>City Name: San Clemente<br/>State: Tarlac<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(838, 'city', 322, 'City created. <br/><br/>City Name: San Manuel<br/>State: Tarlac<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(839, 'city', 323, 'City created. <br/><br/>City Name: Santa Ignacia<br/>State: Tarlac<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(840, 'city', 324, 'City created. <br/><br/>City Name: City of Tarlac<br/>State: Tarlac<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(841, 'city', 325, 'City created. <br/><br/>City Name: Victoria<br/>State: Tarlac<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(842, 'city', 326, 'City created. <br/><br/>City Name: San Jose<br/>State: Tarlac<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(843, 'city', 327, 'City created. <br/><br/>City Name: Botolan<br/>State: Zambales<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(844, 'city', 328, 'City created. <br/><br/>City Name: Cabangan<br/>State: Zambales<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(845, 'city', 329, 'City created. <br/><br/>City Name: Candelaria<br/>State: Zambales<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(846, 'city', 330, 'City created. <br/><br/>City Name: Castillejos<br/>State: Zambales<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(847, 'city', 331, 'City created. <br/><br/>City Name: Iba<br/>State: Zambales<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(848, 'city', 332, 'City created. <br/><br/>City Name: Masinloc<br/>State: Zambales<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(849, 'city', 333, 'City created. <br/><br/>City Name: City of Olongapo<br/>State: Zambales<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(850, 'city', 334, 'City created. <br/><br/>City Name: Palauig<br/>State: Zambales<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(851, 'city', 335, 'City created. <br/><br/>City Name: San Antonio<br/>State: Zambales<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(852, 'city', 336, 'City created. <br/><br/>City Name: San Felipe<br/>State: Zambales<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(853, 'city', 337, 'City created. <br/><br/>City Name: San Marcelino<br/>State: Zambales<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(854, 'city', 338, 'City created. <br/><br/>City Name: San Narciso<br/>State: Zambales<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(855, 'city', 339, 'City created. <br/><br/>City Name: Santa Cruz<br/>State: Zambales<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(856, 'city', 340, 'City created. <br/><br/>City Name: Subic<br/>State: Zambales<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(857, 'city', 341, 'City created. <br/><br/>City Name: Baler<br/>State: Aurora<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(858, 'city', 342, 'City created. <br/><br/>City Name: Casiguran<br/>State: Aurora<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(859, 'city', 343, 'City created. <br/><br/>City Name: Dilasag<br/>State: Aurora<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(860, 'city', 344, 'City created. <br/><br/>City Name: Dinalungan<br/>State: Aurora<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(861, 'city', 345, 'City created. <br/><br/>City Name: Dingalan<br/>State: Aurora<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(862, 'city', 346, 'City created. <br/><br/>City Name: Dipaculao<br/>State: Aurora<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(863, 'city', 347, 'City created. <br/><br/>City Name: Maria Aurora<br/>State: Aurora<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(864, 'city', 348, 'City created. <br/><br/>City Name: San Luis<br/>State: Aurora<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(865, 'city', 349, 'City created. <br/><br/>City Name: Agoncillo<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(866, 'city', 350, 'City created. <br/><br/>City Name: Alitagtag<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(867, 'city', 351, 'City created. <br/><br/>City Name: Balayan<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(868, 'city', 352, 'City created. <br/><br/>City Name: Balete<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(869, 'city', 353, 'City created. <br/><br/>City Name: Batangas City<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(870, 'city', 354, 'City created. <br/><br/>City Name: Bauan<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(871, 'city', 355, 'City created. <br/><br/>City Name: Calaca<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(872, 'city', 356, 'City created. <br/><br/>City Name: Calatagan<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(873, 'city', 357, 'City created. <br/><br/>City Name: Cuenca<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(874, 'city', 358, 'City created. <br/><br/>City Name: Ibaan<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(875, 'city', 359, 'City created. <br/><br/>City Name: Laurel<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(876, 'city', 360, 'City created. <br/><br/>City Name: Lemery<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(877, 'city', 361, 'City created. <br/><br/>City Name: Lian<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(878, 'city', 362, 'City created. <br/><br/>City Name: City of Lipa<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(879, 'city', 363, 'City created. <br/><br/>City Name: Lobo<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(880, 'city', 364, 'City created. <br/><br/>City Name: Mabini<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(881, 'city', 365, 'City created. <br/><br/>City Name: Malvar<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(882, 'city', 366, 'City created. <br/><br/>City Name: Mataasnakahoy<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(883, 'city', 367, 'City created. <br/><br/>City Name: Nasugbu<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(884, 'city', 368, 'City created. <br/><br/>City Name: Padre Garcia<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(885, 'city', 369, 'City created. <br/><br/>City Name: Rosario<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(886, 'city', 370, 'City created. <br/><br/>City Name: San Jose<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(887, 'city', 371, 'City created. <br/><br/>City Name: San Juan<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(888, 'city', 372, 'City created. <br/><br/>City Name: San Luis<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(889, 'city', 373, 'City created. <br/><br/>City Name: San Nicolas<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(890, 'city', 374, 'City created. <br/><br/>City Name: San Pascual<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(891, 'city', 375, 'City created. <br/><br/>City Name: Santa Teresita<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(892, 'city', 376, 'City created. <br/><br/>City Name: City of Sto. Tomas<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(893, 'city', 377, 'City created. <br/><br/>City Name: Taal<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(894, 'city', 378, 'City created. <br/><br/>City Name: Talisay<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(895, 'city', 379, 'City created. <br/><br/>City Name: City of Tanauan<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(896, 'city', 380, 'City created. <br/><br/>City Name: Taysan<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(897, 'city', 381, 'City created. <br/><br/>City Name: Tingloy<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(898, 'city', 382, 'City created. <br/><br/>City Name: Tuy<br/>State: Batangas<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(899, 'city', 383, 'City created. <br/><br/>City Name: Alfonso<br/>State: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(900, 'city', 384, 'City created. <br/><br/>City Name: Amadeo<br/>State: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(901, 'city', 385, 'City created. <br/><br/>City Name: City of Bacoor<br/>State: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(902, 'city', 386, 'City created. <br/><br/>City Name: Carmona<br/>State: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(903, 'city', 387, 'City created. <br/><br/>City Name: City of Cavite<br/>State: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(904, 'city', 388, 'City created. <br/><br/>City Name: City of Dasmariñas<br/>State: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(905, 'city', 389, 'City created. <br/><br/>City Name: General Emilio Aguinaldo<br/>State: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(906, 'city', 390, 'City created. <br/><br/>City Name: City of General Trias<br/>State: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(907, 'city', 391, 'City created. <br/><br/>City Name: City of Imus<br/>State: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(908, 'city', 392, 'City created. <br/><br/>City Name: Indang<br/>State: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(909, 'city', 393, 'City created. <br/><br/>City Name: Kawit<br/>State: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(910, 'city', 394, 'City created. <br/><br/>City Name: Magallanes<br/>State: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(911, 'city', 395, 'City created. <br/><br/>City Name: Maragondon<br/>State: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(912, 'city', 396, 'City created. <br/><br/>City Name: Mendez<br/>State: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(913, 'city', 397, 'City created. <br/><br/>City Name: Naic<br/>State: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(914, 'city', 398, 'City created. <br/><br/>City Name: Noveleta<br/>State: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(915, 'city', 399, 'City created. <br/><br/>City Name: Rosario<br/>State: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(916, 'city', 400, 'City created. <br/><br/>City Name: Silang<br/>State: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(917, 'city', 401, 'City created. <br/><br/>City Name: City of Tagaytay<br/>State: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(918, 'city', 402, 'City created. <br/><br/>City Name: Tanza<br/>State: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(919, 'city', 403, 'City created. <br/><br/>City Name: Ternate<br/>State: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(920, 'city', 404, 'City created. <br/><br/>City Name: City of Trece Martires<br/>State: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(921, 'city', 405, 'City created. <br/><br/>City Name: Gen. Mariano Alvarez<br/>State: Cavite<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(922, 'city', 406, 'City created. <br/><br/>City Name: Alaminos<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(923, 'city', 407, 'City created. <br/><br/>City Name: Bay<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(924, 'city', 408, 'City created. <br/><br/>City Name: City of Biñan<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(925, 'city', 409, 'City created. <br/><br/>City Name: City of Cabuyao<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(926, 'city', 410, 'City created. <br/><br/>City Name: City of Calamba<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(927, 'city', 411, 'City created. <br/><br/>City Name: Calauan<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(928, 'city', 412, 'City created. <br/><br/>City Name: Cavinti<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(929, 'city', 413, 'City created. <br/><br/>City Name: Famy<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(930, 'city', 414, 'City created. <br/><br/>City Name: Kalayaan<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(931, 'city', 415, 'City created. <br/><br/>City Name: Liliw<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(932, 'city', 416, 'City created. <br/><br/>City Name: Los Baños<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(933, 'city', 417, 'City created. <br/><br/>City Name: Luisiana<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(934, 'city', 418, 'City created. <br/><br/>City Name: Lumban<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(935, 'city', 419, 'City created. <br/><br/>City Name: Mabitac<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(936, 'city', 420, 'City created. <br/><br/>City Name: Magdalena<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(937, 'city', 421, 'City created. <br/><br/>City Name: Majayjay<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(938, 'city', 422, 'City created. <br/><br/>City Name: Nagcarlan<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(939, 'city', 423, 'City created. <br/><br/>City Name: Paete<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(940, 'city', 424, 'City created. <br/><br/>City Name: Pagsanjan<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(941, 'city', 425, 'City created. <br/><br/>City Name: Pakil<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14');
INSERT INTO `audit_log` (`audit_log_id`, `table_name`, `reference_id`, `log`, `changed_by`, `changed_at`, `created_date`) VALUES
(942, 'city', 426, 'City created. <br/><br/>City Name: Pangil<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:14', '2024-06-26 15:48:14'),
(943, 'city', 427, 'City created. <br/><br/>City Name: Pila<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(944, 'city', 428, 'City created. <br/><br/>City Name: Rizal<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(945, 'city', 429, 'City created. <br/><br/>City Name: City of San Pablo<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(946, 'city', 430, 'City created. <br/><br/>City Name: City of San Pedro<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(947, 'city', 431, 'City created. <br/><br/>City Name: Santa Cruz<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(948, 'city', 432, 'City created. <br/><br/>City Name: Santa Maria<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(949, 'city', 433, 'City created. <br/><br/>City Name: City of Santa Rosa<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(950, 'city', 434, 'City created. <br/><br/>City Name: Siniloan<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(951, 'city', 435, 'City created. <br/><br/>City Name: Victoria<br/>State: Laguna<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(952, 'city', 436, 'City created. <br/><br/>City Name: Agdangan<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(953, 'city', 437, 'City created. <br/><br/>City Name: Alabat<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(954, 'city', 438, 'City created. <br/><br/>City Name: Atimonan<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(955, 'city', 439, 'City created. <br/><br/>City Name: Buenavista<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(956, 'city', 440, 'City created. <br/><br/>City Name: Burdeos<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(957, 'city', 441, 'City created. <br/><br/>City Name: Calauag<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(958, 'city', 442, 'City created. <br/><br/>City Name: Candelaria<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(959, 'city', 443, 'City created. <br/><br/>City Name: Catanauan<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(960, 'city', 444, 'City created. <br/><br/>City Name: Dolores<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(961, 'city', 445, 'City created. <br/><br/>City Name: General Luna<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(962, 'city', 446, 'City created. <br/><br/>City Name: General Nakar<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(963, 'city', 447, 'City created. <br/><br/>City Name: Guinayangan<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(964, 'city', 448, 'City created. <br/><br/>City Name: Gumaca<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(965, 'city', 449, 'City created. <br/><br/>City Name: Infanta<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(966, 'city', 450, 'City created. <br/><br/>City Name: Jomalig<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(967, 'city', 451, 'City created. <br/><br/>City Name: Lopez<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(968, 'city', 452, 'City created. <br/><br/>City Name: Lucban<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(969, 'city', 453, 'City created. <br/><br/>City Name: City of Lucena<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(970, 'city', 454, 'City created. <br/><br/>City Name: Macalelon<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(971, 'city', 455, 'City created. <br/><br/>City Name: Mauban<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(972, 'city', 456, 'City created. <br/><br/>City Name: Mulanay<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(973, 'city', 457, 'City created. <br/><br/>City Name: Padre Burgos<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(974, 'city', 458, 'City created. <br/><br/>City Name: Pagbilao<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(975, 'city', 459, 'City created. <br/><br/>City Name: Panukulan<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(976, 'city', 460, 'City created. <br/><br/>City Name: Patnanungan<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(977, 'city', 461, 'City created. <br/><br/>City Name: Perez<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(978, 'city', 462, 'City created. <br/><br/>City Name: Pitogo<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(979, 'city', 463, 'City created. <br/><br/>City Name: Plaridel<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(980, 'city', 464, 'City created. <br/><br/>City Name: Polillo<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(981, 'city', 465, 'City created. <br/><br/>City Name: Quezon<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(982, 'city', 466, 'City created. <br/><br/>City Name: Real<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(983, 'city', 467, 'City created. <br/><br/>City Name: Sampaloc<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(984, 'city', 468, 'City created. <br/><br/>City Name: San Andres<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(985, 'city', 469, 'City created. <br/><br/>City Name: San Antonio<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(986, 'city', 470, 'City created. <br/><br/>City Name: San Francisco<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(987, 'city', 471, 'City created. <br/><br/>City Name: San Narciso<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(988, 'city', 472, 'City created. <br/><br/>City Name: Sariaya<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(989, 'city', 473, 'City created. <br/><br/>City Name: Tagkawayan<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(990, 'city', 474, 'City created. <br/><br/>City Name: City of Tayabas<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(991, 'city', 475, 'City created. <br/><br/>City Name: Tiaong<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(992, 'city', 476, 'City created. <br/><br/>City Name: Unisan<br/>State: Quezon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(993, 'city', 477, 'City created. <br/><br/>City Name: Angono<br/>State: Rizal<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(994, 'city', 478, 'City created. <br/><br/>City Name: City of Antipolo<br/>State: Rizal<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(995, 'city', 479, 'City created. <br/><br/>City Name: Baras<br/>State: Rizal<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(996, 'city', 480, 'City created. <br/><br/>City Name: Binangonan<br/>State: Rizal<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(997, 'city', 481, 'City created. <br/><br/>City Name: Cainta<br/>State: Rizal<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(998, 'city', 482, 'City created. <br/><br/>City Name: Cardona<br/>State: Rizal<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(999, 'city', 483, 'City created. <br/><br/>City Name: Jala-Jala<br/>State: Rizal<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1000, 'city', 484, 'City created. <br/><br/>City Name: Rodriguez<br/>State: Rizal<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1001, 'city', 485, 'City created. <br/><br/>City Name: Morong<br/>State: Rizal<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1002, 'city', 486, 'City created. <br/><br/>City Name: Pililla<br/>State: Rizal<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1003, 'city', 487, 'City created. <br/><br/>City Name: San Mateo<br/>State: Rizal<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1004, 'city', 488, 'City created. <br/><br/>City Name: Tanay<br/>State: Rizal<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1005, 'city', 489, 'City created. <br/><br/>City Name: Taytay<br/>State: Rizal<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1006, 'city', 490, 'City created. <br/><br/>City Name: Teresa<br/>State: Rizal<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1007, 'city', 491, 'City created. <br/><br/>City Name: Boac<br/>State: Marinduque<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1008, 'city', 492, 'City created. <br/><br/>City Name: Buenavista<br/>State: Marinduque<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1009, 'city', 493, 'City created. <br/><br/>City Name: Gasan<br/>State: Marinduque<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1010, 'city', 494, 'City created. <br/><br/>City Name: Mogpog<br/>State: Marinduque<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1011, 'city', 495, 'City created. <br/><br/>City Name: Santa Cruz<br/>State: Marinduque<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1012, 'city', 496, 'City created. <br/><br/>City Name: Torrijos<br/>State: Marinduque<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1013, 'city', 497, 'City created. <br/><br/>City Name: Abra De Ilog<br/>State: Occidental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1014, 'city', 498, 'City created. <br/><br/>City Name: Calintaan<br/>State: Occidental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1015, 'city', 499, 'City created. <br/><br/>City Name: Looc<br/>State: Occidental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1016, 'city', 500, 'City created. <br/><br/>City Name: Lubang<br/>State: Occidental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1017, 'city', 501, 'City created. <br/><br/>City Name: Magsaysay<br/>State: Occidental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1018, 'city', 502, 'City created. <br/><br/>City Name: Mamburao<br/>State: Occidental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1019, 'city', 503, 'City created. <br/><br/>City Name: Paluan<br/>State: Occidental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1020, 'city', 504, 'City created. <br/><br/>City Name: Rizal<br/>State: Occidental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1021, 'city', 505, 'City created. <br/><br/>City Name: Sablayan<br/>State: Occidental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1022, 'city', 506, 'City created. <br/><br/>City Name: San Jose<br/>State: Occidental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1023, 'city', 507, 'City created. <br/><br/>City Name: Santa Cruz<br/>State: Occidental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1024, 'city', 508, 'City created. <br/><br/>City Name: Baco<br/>State: Oriental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1025, 'city', 509, 'City created. <br/><br/>City Name: Bansud<br/>State: Oriental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1026, 'city', 510, 'City created. <br/><br/>City Name: Bongabong<br/>State: Oriental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1027, 'city', 511, 'City created. <br/><br/>City Name: Bulalacao<br/>State: Oriental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1028, 'city', 512, 'City created. <br/><br/>City Name: City of Calapan<br/>State: Oriental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1029, 'city', 513, 'City created. <br/><br/>City Name: Gloria<br/>State: Oriental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1030, 'city', 514, 'City created. <br/><br/>City Name: Mansalay<br/>State: Oriental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1031, 'city', 515, 'City created. <br/><br/>City Name: Naujan<br/>State: Oriental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1032, 'city', 516, 'City created. <br/><br/>City Name: Pinamalayan<br/>State: Oriental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1033, 'city', 517, 'City created. <br/><br/>City Name: Pola<br/>State: Oriental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1034, 'city', 518, 'City created. <br/><br/>City Name: Puerto Galera<br/>State: Oriental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1035, 'city', 519, 'City created. <br/><br/>City Name: Roxas<br/>State: Oriental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1036, 'city', 520, 'City created. <br/><br/>City Name: San Teodoro<br/>State: Oriental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1037, 'city', 521, 'City created. <br/><br/>City Name: Socorro<br/>State: Oriental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1038, 'city', 522, 'City created. <br/><br/>City Name: Victoria<br/>State: Oriental Mindoro<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1039, 'city', 523, 'City created. <br/><br/>City Name: Aborlan<br/>State: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1040, 'city', 524, 'City created. <br/><br/>City Name: Agutaya<br/>State: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1041, 'city', 525, 'City created. <br/><br/>City Name: Araceli<br/>State: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1042, 'city', 526, 'City created. <br/><br/>City Name: Balabac<br/>State: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1043, 'city', 527, 'City created. <br/><br/>City Name: Bataraza<br/>State: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1044, 'city', 528, 'City created. <br/><br/>City Name: Brooke S Point<br/>State: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1045, 'city', 529, 'City created. <br/><br/>City Name: Busuanga<br/>State: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1046, 'city', 530, 'City created. <br/><br/>City Name: Cagayancillo<br/>State: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1047, 'city', 531, 'City created. <br/><br/>City Name: Coron<br/>State: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1048, 'city', 532, 'City created. <br/><br/>City Name: Cuyo<br/>State: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1049, 'city', 533, 'City created. <br/><br/>City Name: Dumaran<br/>State: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1050, 'city', 534, 'City created. <br/><br/>City Name: El Nido<br/>State: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1051, 'city', 535, 'City created. <br/><br/>City Name: Linapacan<br/>State: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1052, 'city', 536, 'City created. <br/><br/>City Name: Magsaysay<br/>State: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1053, 'city', 537, 'City created. <br/><br/>City Name: Narra<br/>State: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1054, 'city', 538, 'City created. <br/><br/>City Name: City of Puerto Princesa<br/>State: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1055, 'city', 539, 'City created. <br/><br/>City Name: Quezon<br/>State: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1056, 'city', 540, 'City created. <br/><br/>City Name: Roxas<br/>State: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1057, 'city', 541, 'City created. <br/><br/>City Name: San Vicente<br/>State: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1058, 'city', 542, 'City created. <br/><br/>City Name: Taytay<br/>State: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1059, 'city', 543, 'City created. <br/><br/>City Name: Kalayaan<br/>State: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1060, 'city', 544, 'City created. <br/><br/>City Name: Culion<br/>State: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1061, 'city', 545, 'City created. <br/><br/>City Name: Rizal<br/>State: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1062, 'city', 546, 'City created. <br/><br/>City Name: Sofronio Española<br/>State: Palawan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1063, 'city', 547, 'City created. <br/><br/>City Name: Alcantara<br/>State: Romblon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1064, 'city', 548, 'City created. <br/><br/>City Name: Banton<br/>State: Romblon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1065, 'city', 549, 'City created. <br/><br/>City Name: Cajidiocan<br/>State: Romblon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1066, 'city', 550, 'City created. <br/><br/>City Name: Calatrava<br/>State: Romblon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1067, 'city', 551, 'City created. <br/><br/>City Name: Concepcion<br/>State: Romblon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1068, 'city', 552, 'City created. <br/><br/>City Name: Corcuera<br/>State: Romblon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1069, 'city', 553, 'City created. <br/><br/>City Name: Looc<br/>State: Romblon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1070, 'city', 554, 'City created. <br/><br/>City Name: Magdiwang<br/>State: Romblon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1071, 'city', 555, 'City created. <br/><br/>City Name: Odiongan<br/>State: Romblon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1072, 'city', 556, 'City created. <br/><br/>City Name: Romblon<br/>State: Romblon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1073, 'city', 557, 'City created. <br/><br/>City Name: San Agustin<br/>State: Romblon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1074, 'city', 558, 'City created. <br/><br/>City Name: San Andres<br/>State: Romblon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1075, 'city', 559, 'City created. <br/><br/>City Name: San Fernando<br/>State: Romblon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1076, 'city', 560, 'City created. <br/><br/>City Name: San Jose<br/>State: Romblon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1077, 'city', 561, 'City created. <br/><br/>City Name: Santa Fe<br/>State: Romblon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1078, 'city', 562, 'City created. <br/><br/>City Name: Ferrol<br/>State: Romblon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1079, 'city', 563, 'City created. <br/><br/>City Name: Santa Maria<br/>State: Romblon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1080, 'city', 564, 'City created. <br/><br/>City Name: Bacacay<br/>State: Albay<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1081, 'city', 565, 'City created. <br/><br/>City Name: Camalig<br/>State: Albay<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1082, 'city', 566, 'City created. <br/><br/>City Name: Daraga<br/>State: Albay<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1083, 'city', 567, 'City created. <br/><br/>City Name: Guinobatan<br/>State: Albay<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1084, 'city', 568, 'City created. <br/><br/>City Name: Jovellar<br/>State: Albay<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1085, 'city', 569, 'City created. <br/><br/>City Name: City of Legazpi<br/>State: Albay<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1086, 'city', 570, 'City created. <br/><br/>City Name: Libon<br/>State: Albay<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1087, 'city', 571, 'City created. <br/><br/>City Name: City of Ligao<br/>State: Albay<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1088, 'city', 572, 'City created. <br/><br/>City Name: Malilipot<br/>State: Albay<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1089, 'city', 573, 'City created. <br/><br/>City Name: Malinao<br/>State: Albay<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1090, 'city', 574, 'City created. <br/><br/>City Name: Manito<br/>State: Albay<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1091, 'city', 575, 'City created. <br/><br/>City Name: Oas<br/>State: Albay<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1092, 'city', 576, 'City created. <br/><br/>City Name: Pio Duran<br/>State: Albay<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1093, 'city', 577, 'City created. <br/><br/>City Name: Polangui<br/>State: Albay<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1094, 'city', 578, 'City created. <br/><br/>City Name: Rapu-Rapu<br/>State: Albay<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1095, 'city', 579, 'City created. <br/><br/>City Name: Santo Domingo<br/>State: Albay<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1096, 'city', 580, 'City created. <br/><br/>City Name: City of Tabaco<br/>State: Albay<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1097, 'city', 581, 'City created. <br/><br/>City Name: Tiwi<br/>State: Albay<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1098, 'city', 582, 'City created. <br/><br/>City Name: Basud<br/>State: Camarines Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1099, 'city', 583, 'City created. <br/><br/>City Name: Capalonga<br/>State: Camarines Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1100, 'city', 584, 'City created. <br/><br/>City Name: Daet<br/>State: Camarines Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1101, 'city', 585, 'City created. <br/><br/>City Name: San Lorenzo Ruiz<br/>State: Camarines Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1102, 'city', 586, 'City created. <br/><br/>City Name: Jose Panganiban<br/>State: Camarines Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1103, 'city', 587, 'City created. <br/><br/>City Name: Labo<br/>State: Camarines Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1104, 'city', 588, 'City created. <br/><br/>City Name: Mercedes<br/>State: Camarines Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1105, 'city', 589, 'City created. <br/><br/>City Name: Paracale<br/>State: Camarines Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1106, 'city', 590, 'City created. <br/><br/>City Name: San Vicente<br/>State: Camarines Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1107, 'city', 591, 'City created. <br/><br/>City Name: Santa Elena<br/>State: Camarines Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1108, 'city', 592, 'City created. <br/><br/>City Name: Talisay<br/>State: Camarines Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1109, 'city', 593, 'City created. <br/><br/>City Name: Vinzons<br/>State: Camarines Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1110, 'city', 594, 'City created. <br/><br/>City Name: Baao<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1111, 'city', 595, 'City created. <br/><br/>City Name: Balatan<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1112, 'city', 596, 'City created. <br/><br/>City Name: Bato<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1113, 'city', 597, 'City created. <br/><br/>City Name: Bombon<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1114, 'city', 598, 'City created. <br/><br/>City Name: Buhi<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1115, 'city', 599, 'City created. <br/><br/>City Name: Bula<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1116, 'city', 600, 'City created. <br/><br/>City Name: Cabusao<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1117, 'city', 601, 'City created. <br/><br/>City Name: Calabanga<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1118, 'city', 602, 'City created. <br/><br/>City Name: Camaligan<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1119, 'city', 603, 'City created. <br/><br/>City Name: Canaman<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1120, 'city', 604, 'City created. <br/><br/>City Name: Caramoan<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1121, 'city', 605, 'City created. <br/><br/>City Name: Del Gallego<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1122, 'city', 606, 'City created. <br/><br/>City Name: Gainza<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1123, 'city', 607, 'City created. <br/><br/>City Name: Garchitorena<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1124, 'city', 608, 'City created. <br/><br/>City Name: Goa<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1125, 'city', 609, 'City created. <br/><br/>City Name: City of Iriga<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1126, 'city', 610, 'City created. <br/><br/>City Name: Lagonoy<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1127, 'city', 611, 'City created. <br/><br/>City Name: Libmanan<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1128, 'city', 612, 'City created. <br/><br/>City Name: Lupi<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1129, 'city', 613, 'City created. <br/><br/>City Name: Magarao<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1130, 'city', 614, 'City created. <br/><br/>City Name: Milaor<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1131, 'city', 615, 'City created. <br/><br/>City Name: Minalabac<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1132, 'city', 616, 'City created. <br/><br/>City Name: Nabua<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1133, 'city', 617, 'City created. <br/><br/>City Name: City of Naga<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1134, 'city', 618, 'City created. <br/><br/>City Name: Ocampo<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1135, 'city', 619, 'City created. <br/><br/>City Name: Pamplona<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1136, 'city', 620, 'City created. <br/><br/>City Name: Pasacao<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1137, 'city', 621, 'City created. <br/><br/>City Name: Pili<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1138, 'city', 622, 'City created. <br/><br/>City Name: Presentacion<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1139, 'city', 623, 'City created. <br/><br/>City Name: Ragay<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1140, 'city', 624, 'City created. <br/><br/>City Name: Sagñay<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1141, 'city', 625, 'City created. <br/><br/>City Name: San Fernando<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1142, 'city', 626, 'City created. <br/><br/>City Name: San Jose<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1143, 'city', 627, 'City created. <br/><br/>City Name: Sipocot<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1144, 'city', 628, 'City created. <br/><br/>City Name: Siruma<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1145, 'city', 629, 'City created. <br/><br/>City Name: Tigaon<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1146, 'city', 630, 'City created. <br/><br/>City Name: Tinambac<br/>State: Camarines Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1147, 'city', 631, 'City created. <br/><br/>City Name: Bagamanoc<br/>State: Catanduanes<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1148, 'city', 632, 'City created. <br/><br/>City Name: Baras<br/>State: Catanduanes<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1149, 'city', 633, 'City created. <br/><br/>City Name: Bato<br/>State: Catanduanes<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1150, 'city', 634, 'City created. <br/><br/>City Name: Caramoran<br/>State: Catanduanes<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1151, 'city', 635, 'City created. <br/><br/>City Name: Gigmoto<br/>State: Catanduanes<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1152, 'city', 636, 'City created. <br/><br/>City Name: Pandan<br/>State: Catanduanes<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1153, 'city', 637, 'City created. <br/><br/>City Name: Panganiban<br/>State: Catanduanes<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1154, 'city', 638, 'City created. <br/><br/>City Name: San Andres<br/>State: Catanduanes<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1155, 'city', 639, 'City created. <br/><br/>City Name: San Miguel<br/>State: Catanduanes<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1156, 'city', 640, 'City created. <br/><br/>City Name: Viga<br/>State: Catanduanes<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1157, 'city', 641, 'City created. <br/><br/>City Name: Virac<br/>State: Catanduanes<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1158, 'city', 642, 'City created. <br/><br/>City Name: Aroroy<br/>State: Masbate<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1159, 'city', 643, 'City created. <br/><br/>City Name: Baleno<br/>State: Masbate<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1160, 'city', 644, 'City created. <br/><br/>City Name: Balud<br/>State: Masbate<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1161, 'city', 645, 'City created. <br/><br/>City Name: Batuan<br/>State: Masbate<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1162, 'city', 646, 'City created. <br/><br/>City Name: Cataingan<br/>State: Masbate<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1163, 'city', 647, 'City created. <br/><br/>City Name: Cawayan<br/>State: Masbate<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1164, 'city', 648, 'City created. <br/><br/>City Name: Claveria<br/>State: Masbate<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1165, 'city', 649, 'City created. <br/><br/>City Name: Dimasalang<br/>State: Masbate<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1166, 'city', 650, 'City created. <br/><br/>City Name: Esperanza<br/>State: Masbate<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1167, 'city', 651, 'City created. <br/><br/>City Name: Mandaon<br/>State: Masbate<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1168, 'city', 652, 'City created. <br/><br/>City Name: City of Masbate<br/>State: Masbate<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1169, 'city', 653, 'City created. <br/><br/>City Name: Milagros<br/>State: Masbate<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1170, 'city', 654, 'City created. <br/><br/>City Name: Mobo<br/>State: Masbate<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1171, 'city', 655, 'City created. <br/><br/>City Name: Monreal<br/>State: Masbate<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1172, 'city', 656, 'City created. <br/><br/>City Name: Palanas<br/>State: Masbate<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1173, 'city', 657, 'City created. <br/><br/>City Name: Pio V. Corpuz<br/>State: Masbate<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1174, 'city', 658, 'City created. <br/><br/>City Name: Placer<br/>State: Masbate<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1175, 'city', 659, 'City created. <br/><br/>City Name: San Fernando<br/>State: Masbate<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1176, 'city', 660, 'City created. <br/><br/>City Name: San Jacinto<br/>State: Masbate<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1177, 'city', 661, 'City created. <br/><br/>City Name: San Pascual<br/>State: Masbate<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1178, 'city', 662, 'City created. <br/><br/>City Name: Uson<br/>State: Masbate<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1179, 'city', 663, 'City created. <br/><br/>City Name: Barcelona<br/>State: Sorsogon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1180, 'city', 664, 'City created. <br/><br/>City Name: Bulan<br/>State: Sorsogon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1181, 'city', 665, 'City created. <br/><br/>City Name: Bulusan<br/>State: Sorsogon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1182, 'city', 666, 'City created. <br/><br/>City Name: Casiguran<br/>State: Sorsogon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1183, 'city', 667, 'City created. <br/><br/>City Name: Castilla<br/>State: Sorsogon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1184, 'city', 668, 'City created. <br/><br/>City Name: Donsol<br/>State: Sorsogon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1185, 'city', 669, 'City created. <br/><br/>City Name: Gubat<br/>State: Sorsogon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1186, 'city', 670, 'City created. <br/><br/>City Name: Irosin<br/>State: Sorsogon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1187, 'city', 671, 'City created. <br/><br/>City Name: Juban<br/>State: Sorsogon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1188, 'city', 672, 'City created. <br/><br/>City Name: Magallanes<br/>State: Sorsogon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1189, 'city', 673, 'City created. <br/><br/>City Name: Matnog<br/>State: Sorsogon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1190, 'city', 674, 'City created. <br/><br/>City Name: Pilar<br/>State: Sorsogon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1191, 'city', 675, 'City created. <br/><br/>City Name: Prieto Diaz<br/>State: Sorsogon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1192, 'city', 676, 'City created. <br/><br/>City Name: Santa Magdalena<br/>State: Sorsogon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1193, 'city', 677, 'City created. <br/><br/>City Name: City of Sorsogon<br/>State: Sorsogon<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1194, 'city', 678, 'City created. <br/><br/>City Name: Altavas<br/>State: Aklan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1195, 'city', 679, 'City created. <br/><br/>City Name: Balete<br/>State: Aklan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1196, 'city', 680, 'City created. <br/><br/>City Name: Banga<br/>State: Aklan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1197, 'city', 681, 'City created. <br/><br/>City Name: Batan<br/>State: Aklan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1198, 'city', 682, 'City created. <br/><br/>City Name: Buruanga<br/>State: Aklan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1199, 'city', 683, 'City created. <br/><br/>City Name: Ibajay<br/>State: Aklan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1200, 'city', 684, 'City created. <br/><br/>City Name: Kalibo<br/>State: Aklan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1201, 'city', 685, 'City created. <br/><br/>City Name: Lezo<br/>State: Aklan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1202, 'city', 686, 'City created. <br/><br/>City Name: Libacao<br/>State: Aklan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1203, 'city', 687, 'City created. <br/><br/>City Name: Madalag<br/>State: Aklan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1204, 'city', 688, 'City created. <br/><br/>City Name: Makato<br/>State: Aklan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1205, 'city', 689, 'City created. <br/><br/>City Name: Malay<br/>State: Aklan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1206, 'city', 690, 'City created. <br/><br/>City Name: Malinao<br/>State: Aklan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1207, 'city', 691, 'City created. <br/><br/>City Name: Nabas<br/>State: Aklan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1208, 'city', 692, 'City created. <br/><br/>City Name: New Washington<br/>State: Aklan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1209, 'city', 693, 'City created. <br/><br/>City Name: Numancia<br/>State: Aklan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1210, 'city', 694, 'City created. <br/><br/>City Name: Tangalan<br/>State: Aklan<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1211, 'city', 695, 'City created. <br/><br/>City Name: Anini-Y<br/>State: Antique<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1212, 'city', 696, 'City created. <br/><br/>City Name: Barbaza<br/>State: Antique<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1213, 'city', 697, 'City created. <br/><br/>City Name: Belison<br/>State: Antique<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1214, 'city', 698, 'City created. <br/><br/>City Name: Bugasong<br/>State: Antique<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1215, 'city', 699, 'City created. <br/><br/>City Name: Caluya<br/>State: Antique<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1216, 'city', 700, 'City created. <br/><br/>City Name: Culasi<br/>State: Antique<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1217, 'city', 701, 'City created. <br/><br/>City Name: Tobias Fornier<br/>State: Antique<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1218, 'city', 702, 'City created. <br/><br/>City Name: Hamtic<br/>State: Antique<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1219, 'city', 703, 'City created. <br/><br/>City Name: Laua-An<br/>State: Antique<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1220, 'city', 704, 'City created. <br/><br/>City Name: Libertad<br/>State: Antique<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1221, 'city', 705, 'City created. <br/><br/>City Name: Pandan<br/>State: Antique<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1222, 'city', 706, 'City created. <br/><br/>City Name: Patnongon<br/>State: Antique<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1223, 'city', 707, 'City created. <br/><br/>City Name: San Jose<br/>State: Antique<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1224, 'city', 708, 'City created. <br/><br/>City Name: San Remigio<br/>State: Antique<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1225, 'city', 709, 'City created. <br/><br/>City Name: Sebaste<br/>State: Antique<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1226, 'city', 710, 'City created. <br/><br/>City Name: Sibalom<br/>State: Antique<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1227, 'city', 711, 'City created. <br/><br/>City Name: Tibiao<br/>State: Antique<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1228, 'city', 712, 'City created. <br/><br/>City Name: Valderrama<br/>State: Antique<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1229, 'city', 713, 'City created. <br/><br/>City Name: Cuartero<br/>State: Capiz<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1230, 'city', 714, 'City created. <br/><br/>City Name: Dao<br/>State: Capiz<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1231, 'city', 715, 'City created. <br/><br/>City Name: Dumalag<br/>State: Capiz<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1232, 'city', 716, 'City created. <br/><br/>City Name: Dumarao<br/>State: Capiz<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1233, 'city', 717, 'City created. <br/><br/>City Name: Ivisan<br/>State: Capiz<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1234, 'city', 718, 'City created. <br/><br/>City Name: Jamindan<br/>State: Capiz<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1235, 'city', 719, 'City created. <br/><br/>City Name: Ma-Ayon<br/>State: Capiz<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1236, 'city', 720, 'City created. <br/><br/>City Name: Mambusao<br/>State: Capiz<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1237, 'city', 721, 'City created. <br/><br/>City Name: Panay<br/>State: Capiz<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1238, 'city', 722, 'City created. <br/><br/>City Name: Panitan<br/>State: Capiz<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1239, 'city', 723, 'City created. <br/><br/>City Name: Pilar<br/>State: Capiz<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1240, 'city', 724, 'City created. <br/><br/>City Name: Pontevedra<br/>State: Capiz<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1241, 'city', 725, 'City created. <br/><br/>City Name: President Roxas<br/>State: Capiz<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1242, 'city', 726, 'City created. <br/><br/>City Name: City of Roxas<br/>State: Capiz<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1243, 'city', 727, 'City created. <br/><br/>City Name: Sapi-An<br/>State: Capiz<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1244, 'city', 728, 'City created. <br/><br/>City Name: Sigma<br/>State: Capiz<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1245, 'city', 729, 'City created. <br/><br/>City Name: Tapaz<br/>State: Capiz<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1246, 'city', 730, 'City created. <br/><br/>City Name: Ajuy<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1247, 'city', 731, 'City created. <br/><br/>City Name: Alimodian<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1248, 'city', 732, 'City created. <br/><br/>City Name: Anilao<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1249, 'city', 733, 'City created. <br/><br/>City Name: Badiangan<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1250, 'city', 734, 'City created. <br/><br/>City Name: Balasan<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:15', '2024-06-26 15:48:15'),
(1251, 'city', 735, 'City created. <br/><br/>City Name: Banate<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1252, 'city', 736, 'City created. <br/><br/>City Name: Barotac Nuevo<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16');
INSERT INTO `audit_log` (`audit_log_id`, `table_name`, `reference_id`, `log`, `changed_by`, `changed_at`, `created_date`) VALUES
(1253, 'city', 737, 'City created. <br/><br/>City Name: Barotac Viejo<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1254, 'city', 738, 'City created. <br/><br/>City Name: Batad<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1255, 'city', 739, 'City created. <br/><br/>City Name: Bingawan<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1256, 'city', 740, 'City created. <br/><br/>City Name: Cabatuan<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1257, 'city', 741, 'City created. <br/><br/>City Name: Calinog<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1258, 'city', 742, 'City created. <br/><br/>City Name: Carles<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1259, 'city', 743, 'City created. <br/><br/>City Name: Concepcion<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1260, 'city', 744, 'City created. <br/><br/>City Name: Dingle<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1261, 'city', 745, 'City created. <br/><br/>City Name: Dueñas<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1262, 'city', 746, 'City created. <br/><br/>City Name: Dumangas<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1263, 'city', 747, 'City created. <br/><br/>City Name: Estancia<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1264, 'city', 748, 'City created. <br/><br/>City Name: Guimbal<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1265, 'city', 749, 'City created. <br/><br/>City Name: Igbaras<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1266, 'city', 750, 'City created. <br/><br/>City Name: City of Iloilo<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1267, 'city', 751, 'City created. <br/><br/>City Name: Janiuay<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1268, 'city', 752, 'City created. <br/><br/>City Name: Lambunao<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1269, 'city', 753, 'City created. <br/><br/>City Name: Leganes<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1270, 'city', 754, 'City created. <br/><br/>City Name: Lemery<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1271, 'city', 755, 'City created. <br/><br/>City Name: Leon<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1272, 'city', 756, 'City created. <br/><br/>City Name: Maasin<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1273, 'city', 757, 'City created. <br/><br/>City Name: Miagao<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1274, 'city', 758, 'City created. <br/><br/>City Name: Mina<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1275, 'city', 759, 'City created. <br/><br/>City Name: New Lucena<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1276, 'city', 760, 'City created. <br/><br/>City Name: Oton<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1277, 'city', 761, 'City created. <br/><br/>City Name: City of Passi<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1278, 'city', 762, 'City created. <br/><br/>City Name: Pavia<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1279, 'city', 763, 'City created. <br/><br/>City Name: Pototan<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1280, 'city', 764, 'City created. <br/><br/>City Name: San Dionisio<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1281, 'city', 765, 'City created. <br/><br/>City Name: San Enrique<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1282, 'city', 766, 'City created. <br/><br/>City Name: San Joaquin<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1283, 'city', 767, 'City created. <br/><br/>City Name: San Miguel<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1284, 'city', 768, 'City created. <br/><br/>City Name: San Rafael<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1285, 'city', 769, 'City created. <br/><br/>City Name: Santa Barbara<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1286, 'city', 770, 'City created. <br/><br/>City Name: Sara<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1287, 'city', 771, 'City created. <br/><br/>City Name: Tigbauan<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1288, 'city', 772, 'City created. <br/><br/>City Name: Tubungan<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1289, 'city', 773, 'City created. <br/><br/>City Name: Zarraga<br/>State: Iloilo<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1290, 'city', 774, 'City created. <br/><br/>City Name: City of Bacolod<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1291, 'city', 775, 'City created. <br/><br/>City Name: City of Bago<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1292, 'city', 776, 'City created. <br/><br/>City Name: Binalbagan<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1293, 'city', 777, 'City created. <br/><br/>City Name: City of Cadiz<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1294, 'city', 778, 'City created. <br/><br/>City Name: Calatrava<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1295, 'city', 779, 'City created. <br/><br/>City Name: Candoni<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1296, 'city', 780, 'City created. <br/><br/>City Name: Cauayan<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1297, 'city', 781, 'City created. <br/><br/>City Name: Enrique B. Magalona<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1298, 'city', 782, 'City created. <br/><br/>City Name: City of Escalante<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1299, 'city', 783, 'City created. <br/><br/>City Name: City of Himamaylan<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1300, 'city', 784, 'City created. <br/><br/>City Name: Hinigaran<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1301, 'city', 785, 'City created. <br/><br/>City Name: Hinoba-an<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1302, 'city', 786, 'City created. <br/><br/>City Name: Ilog<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1303, 'city', 787, 'City created. <br/><br/>City Name: Isabela<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1304, 'city', 788, 'City created. <br/><br/>City Name: City of Kabankalan<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1305, 'city', 789, 'City created. <br/><br/>City Name: City of La Carlota<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1306, 'city', 790, 'City created. <br/><br/>City Name: La Castellana<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1307, 'city', 791, 'City created. <br/><br/>City Name: Manapla<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1308, 'city', 792, 'City created. <br/><br/>City Name: Moises Padilla<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1309, 'city', 793, 'City created. <br/><br/>City Name: Murcia<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1310, 'city', 794, 'City created. <br/><br/>City Name: Pontevedra<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1311, 'city', 795, 'City created. <br/><br/>City Name: Pulupandan<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1312, 'city', 796, 'City created. <br/><br/>City Name: City of Sagay<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1313, 'city', 797, 'City created. <br/><br/>City Name: City of San Carlos<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1314, 'city', 798, 'City created. <br/><br/>City Name: San Enrique<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1315, 'city', 799, 'City created. <br/><br/>City Name: City of Silay<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1316, 'city', 800, 'City created. <br/><br/>City Name: City of Sipalay<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1317, 'city', 801, 'City created. <br/><br/>City Name: City of Talisay<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1318, 'city', 802, 'City created. <br/><br/>City Name: Toboso<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1319, 'city', 803, 'City created. <br/><br/>City Name: Valladolid<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1320, 'city', 804, 'City created. <br/><br/>City Name: City of Victorias<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1321, 'city', 805, 'City created. <br/><br/>City Name: Salvador Benedicto<br/>State: Negros Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1322, 'city', 806, 'City created. <br/><br/>City Name: Buenavista<br/>State: Guimaras<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1323, 'city', 807, 'City created. <br/><br/>City Name: Jordan<br/>State: Guimaras<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1324, 'city', 808, 'City created. <br/><br/>City Name: Nueva Valencia<br/>State: Guimaras<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1325, 'city', 809, 'City created. <br/><br/>City Name: San Lorenzo<br/>State: Guimaras<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1326, 'city', 810, 'City created. <br/><br/>City Name: Sibunag<br/>State: Guimaras<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1327, 'city', 811, 'City created. <br/><br/>City Name: Alburquerque<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1328, 'city', 812, 'City created. <br/><br/>City Name: Alicia<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1329, 'city', 813, 'City created. <br/><br/>City Name: Anda<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1330, 'city', 814, 'City created. <br/><br/>City Name: Antequera<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1331, 'city', 815, 'City created. <br/><br/>City Name: Baclayon<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1332, 'city', 816, 'City created. <br/><br/>City Name: Balilihan<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1333, 'city', 817, 'City created. <br/><br/>City Name: Batuan<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1334, 'city', 818, 'City created. <br/><br/>City Name: Bilar<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1335, 'city', 819, 'City created. <br/><br/>City Name: Buenavista<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1336, 'city', 820, 'City created. <br/><br/>City Name: Calape<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1337, 'city', 821, 'City created. <br/><br/>City Name: Candijay<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1338, 'city', 822, 'City created. <br/><br/>City Name: Carmen<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1339, 'city', 823, 'City created. <br/><br/>City Name: Catigbian<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1340, 'city', 824, 'City created. <br/><br/>City Name: Clarin<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1341, 'city', 825, 'City created. <br/><br/>City Name: Corella<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1342, 'city', 826, 'City created. <br/><br/>City Name: Cortes<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1343, 'city', 827, 'City created. <br/><br/>City Name: Dagohoy<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1344, 'city', 828, 'City created. <br/><br/>City Name: Danao<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1345, 'city', 829, 'City created. <br/><br/>City Name: Dauis<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1346, 'city', 830, 'City created. <br/><br/>City Name: Dimiao<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1347, 'city', 831, 'City created. <br/><br/>City Name: Duero<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1348, 'city', 832, 'City created. <br/><br/>City Name: Garcia Hernandez<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1349, 'city', 833, 'City created. <br/><br/>City Name: Guindulman<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1350, 'city', 834, 'City created. <br/><br/>City Name: Inabanga<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1351, 'city', 835, 'City created. <br/><br/>City Name: Jagna<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1352, 'city', 836, 'City created. <br/><br/>City Name: Getafe<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1353, 'city', 837, 'City created. <br/><br/>City Name: Lila<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1354, 'city', 838, 'City created. <br/><br/>City Name: Loay<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1355, 'city', 839, 'City created. <br/><br/>City Name: Loboc<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1356, 'city', 840, 'City created. <br/><br/>City Name: Loon<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1357, 'city', 841, 'City created. <br/><br/>City Name: Mabini<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1358, 'city', 842, 'City created. <br/><br/>City Name: Maribojoc<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1359, 'city', 843, 'City created. <br/><br/>City Name: Panglao<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1360, 'city', 844, 'City created. <br/><br/>City Name: Pilar<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1361, 'city', 845, 'City created. <br/><br/>City Name: Pres. Carlos P. Garcia<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1362, 'city', 846, 'City created. <br/><br/>City Name: Sagbayan<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1363, 'city', 847, 'City created. <br/><br/>City Name: San Isidro<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1364, 'city', 848, 'City created. <br/><br/>City Name: San Miguel<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1365, 'city', 849, 'City created. <br/><br/>City Name: Sevilla<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1366, 'city', 850, 'City created. <br/><br/>City Name: Sierra Bullones<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1367, 'city', 851, 'City created. <br/><br/>City Name: Sikatuna<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1368, 'city', 852, 'City created. <br/><br/>City Name: City of Tagbilaran<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1369, 'city', 853, 'City created. <br/><br/>City Name: Talibon<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1370, 'city', 854, 'City created. <br/><br/>City Name: Trinidad<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1371, 'city', 855, 'City created. <br/><br/>City Name: Tubigon<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1372, 'city', 856, 'City created. <br/><br/>City Name: Ubay<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1373, 'city', 857, 'City created. <br/><br/>City Name: Valencia<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1374, 'city', 858, 'City created. <br/><br/>City Name: Bien Unido<br/>State: Bohol<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1375, 'city', 859, 'City created. <br/><br/>City Name: Alcantara<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1376, 'city', 860, 'City created. <br/><br/>City Name: Alcoy<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1377, 'city', 861, 'City created. <br/><br/>City Name: Alegria<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1378, 'city', 862, 'City created. <br/><br/>City Name: Aloguinsan<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1379, 'city', 863, 'City created. <br/><br/>City Name: Argao<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1380, 'city', 864, 'City created. <br/><br/>City Name: Asturias<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1381, 'city', 865, 'City created. <br/><br/>City Name: Badian<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1382, 'city', 866, 'City created. <br/><br/>City Name: Balamban<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1383, 'city', 867, 'City created. <br/><br/>City Name: Bantayan<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1384, 'city', 868, 'City created. <br/><br/>City Name: Barili<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1385, 'city', 869, 'City created. <br/><br/>City Name: City of Bogo<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1386, 'city', 870, 'City created. <br/><br/>City Name: Boljoon<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1387, 'city', 871, 'City created. <br/><br/>City Name: Borbon<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1388, 'city', 872, 'City created. <br/><br/>City Name: City of Carcar<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1389, 'city', 873, 'City created. <br/><br/>City Name: Carmen<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1390, 'city', 874, 'City created. <br/><br/>City Name: Catmon<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1391, 'city', 875, 'City created. <br/><br/>City Name: City of Cebu<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1392, 'city', 876, 'City created. <br/><br/>City Name: Compostela<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1393, 'city', 877, 'City created. <br/><br/>City Name: Consolacion<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1394, 'city', 878, 'City created. <br/><br/>City Name: Cordova<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1395, 'city', 879, 'City created. <br/><br/>City Name: Daanbantayan<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1396, 'city', 880, 'City created. <br/><br/>City Name: Dalaguete<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1397, 'city', 881, 'City created. <br/><br/>City Name: Danao City<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1398, 'city', 882, 'City created. <br/><br/>City Name: Dumanjug<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1399, 'city', 883, 'City created. <br/><br/>City Name: Ginatilan<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1400, 'city', 884, 'City created. <br/><br/>City Name: City of Lapu-Lapu<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1401, 'city', 885, 'City created. <br/><br/>City Name: Liloan<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1402, 'city', 886, 'City created. <br/><br/>City Name: Madridejos<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1403, 'city', 887, 'City created. <br/><br/>City Name: Malabuyoc<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1404, 'city', 888, 'City created. <br/><br/>City Name: City of Mandaue<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1405, 'city', 889, 'City created. <br/><br/>City Name: Medellin<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1406, 'city', 890, 'City created. <br/><br/>City Name: Minglanilla<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1407, 'city', 891, 'City created. <br/><br/>City Name: Moalboal<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1408, 'city', 892, 'City created. <br/><br/>City Name: City of Naga<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1409, 'city', 893, 'City created. <br/><br/>City Name: Oslob<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1410, 'city', 894, 'City created. <br/><br/>City Name: Pilar<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1411, 'city', 895, 'City created. <br/><br/>City Name: Pinamungajan<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1412, 'city', 896, 'City created. <br/><br/>City Name: Poro<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1413, 'city', 897, 'City created. <br/><br/>City Name: Ronda<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1414, 'city', 898, 'City created. <br/><br/>City Name: Samboan<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1415, 'city', 899, 'City created. <br/><br/>City Name: San Fernando<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1416, 'city', 900, 'City created. <br/><br/>City Name: San Francisco<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1417, 'city', 901, 'City created. <br/><br/>City Name: San Remigio<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1418, 'city', 902, 'City created. <br/><br/>City Name: Santa Fe<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1419, 'city', 903, 'City created. <br/><br/>City Name: Santander<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1420, 'city', 904, 'City created. <br/><br/>City Name: Sibonga<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1421, 'city', 905, 'City created. <br/><br/>City Name: Sogod<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1422, 'city', 906, 'City created. <br/><br/>City Name: Tabogon<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1423, 'city', 907, 'City created. <br/><br/>City Name: Tabuelan<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1424, 'city', 908, 'City created. <br/><br/>City Name: City of Talisay<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1425, 'city', 909, 'City created. <br/><br/>City Name: City of Toledo<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1426, 'city', 910, 'City created. <br/><br/>City Name: Tuburan<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1427, 'city', 911, 'City created. <br/><br/>City Name: Tudela<br/>State: Cebu<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1428, 'city', 912, 'City created. <br/><br/>City Name: Amlan<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1429, 'city', 913, 'City created. <br/><br/>City Name: Ayungon<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1430, 'city', 914, 'City created. <br/><br/>City Name: Bacong<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1431, 'city', 915, 'City created. <br/><br/>City Name: City of Bais<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1432, 'city', 916, 'City created. <br/><br/>City Name: Basay<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1433, 'city', 917, 'City created. <br/><br/>City Name: City of Bayawan<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1434, 'city', 918, 'City created. <br/><br/>City Name: Bindoy<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1435, 'city', 919, 'City created. <br/><br/>City Name: City of Canlaon<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1436, 'city', 920, 'City created. <br/><br/>City Name: Dauin<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1437, 'city', 921, 'City created. <br/><br/>City Name: City of Dumaguete<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1438, 'city', 922, 'City created. <br/><br/>City Name: City of Guihulngan<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1439, 'city', 923, 'City created. <br/><br/>City Name: Jimalalud<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1440, 'city', 924, 'City created. <br/><br/>City Name: La Libertad<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1441, 'city', 925, 'City created. <br/><br/>City Name: Mabinay<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1442, 'city', 926, 'City created. <br/><br/>City Name: Manjuyod<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1443, 'city', 927, 'City created. <br/><br/>City Name: Pamplona<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1444, 'city', 928, 'City created. <br/><br/>City Name: San Jose<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1445, 'city', 929, 'City created. <br/><br/>City Name: Santa Catalina<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1446, 'city', 930, 'City created. <br/><br/>City Name: Siaton<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1447, 'city', 931, 'City created. <br/><br/>City Name: Sibulan<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1448, 'city', 932, 'City created. <br/><br/>City Name: City of Tanjay<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1449, 'city', 933, 'City created. <br/><br/>City Name: Tayasan<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1450, 'city', 934, 'City created. <br/><br/>City Name: Valencia<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1451, 'city', 935, 'City created. <br/><br/>City Name: Vallehermoso<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1452, 'city', 936, 'City created. <br/><br/>City Name: Zamboanguita<br/>State: Negros Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1453, 'city', 937, 'City created. <br/><br/>City Name: Enrique Villanueva<br/>State: Siquijor<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1454, 'city', 938, 'City created. <br/><br/>City Name: Larena<br/>State: Siquijor<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1455, 'city', 939, 'City created. <br/><br/>City Name: Lazi<br/>State: Siquijor<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1456, 'city', 940, 'City created. <br/><br/>City Name: Maria<br/>State: Siquijor<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1457, 'city', 941, 'City created. <br/><br/>City Name: San Juan<br/>State: Siquijor<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1458, 'city', 942, 'City created. <br/><br/>City Name: Siquijor<br/>State: Siquijor<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1459, 'city', 943, 'City created. <br/><br/>City Name: Arteche<br/>State: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1460, 'city', 944, 'City created. <br/><br/>City Name: Balangiga<br/>State: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1461, 'city', 945, 'City created. <br/><br/>City Name: Balangkayan<br/>State: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1462, 'city', 946, 'City created. <br/><br/>City Name: City of Borongan<br/>State: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1463, 'city', 947, 'City created. <br/><br/>City Name: Can-Avid<br/>State: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1464, 'city', 948, 'City created. <br/><br/>City Name: Dolores<br/>State: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1465, 'city', 949, 'City created. <br/><br/>City Name: General Macarthur<br/>State: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1466, 'city', 950, 'City created. <br/><br/>City Name: Giporlos<br/>State: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1467, 'city', 951, 'City created. <br/><br/>City Name: Guiuan<br/>State: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1468, 'city', 952, 'City created. <br/><br/>City Name: Hernani<br/>State: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1469, 'city', 953, 'City created. <br/><br/>City Name: Jipapad<br/>State: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1470, 'city', 954, 'City created. <br/><br/>City Name: Lawaan<br/>State: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1471, 'city', 955, 'City created. <br/><br/>City Name: Llorente<br/>State: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1472, 'city', 956, 'City created. <br/><br/>City Name: Maslog<br/>State: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1473, 'city', 957, 'City created. <br/><br/>City Name: Maydolong<br/>State: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1474, 'city', 958, 'City created. <br/><br/>City Name: Mercedes<br/>State: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1475, 'city', 959, 'City created. <br/><br/>City Name: Oras<br/>State: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1476, 'city', 960, 'City created. <br/><br/>City Name: Quinapondan<br/>State: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1477, 'city', 961, 'City created. <br/><br/>City Name: Salcedo<br/>State: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1478, 'city', 962, 'City created. <br/><br/>City Name: San Julian<br/>State: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1479, 'city', 963, 'City created. <br/><br/>City Name: San Policarpo<br/>State: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1480, 'city', 964, 'City created. <br/><br/>City Name: Sulat<br/>State: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1481, 'city', 965, 'City created. <br/><br/>City Name: Taft<br/>State: Eastern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1482, 'city', 966, 'City created. <br/><br/>City Name: Abuyog<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1483, 'city', 967, 'City created. <br/><br/>City Name: Alangalang<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1484, 'city', 968, 'City created. <br/><br/>City Name: Albuera<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1485, 'city', 969, 'City created. <br/><br/>City Name: Babatngon<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1486, 'city', 970, 'City created. <br/><br/>City Name: Barugo<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1487, 'city', 971, 'City created. <br/><br/>City Name: Bato<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1488, 'city', 972, 'City created. <br/><br/>City Name: City of Baybay<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1489, 'city', 973, 'City created. <br/><br/>City Name: Burauen<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1490, 'city', 974, 'City created. <br/><br/>City Name: Calubian<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1491, 'city', 975, 'City created. <br/><br/>City Name: Capoocan<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1492, 'city', 976, 'City created. <br/><br/>City Name: Carigara<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1493, 'city', 977, 'City created. <br/><br/>City Name: Dagami<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1494, 'city', 978, 'City created. <br/><br/>City Name: Dulag<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1495, 'city', 979, 'City created. <br/><br/>City Name: Hilongos<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1496, 'city', 980, 'City created. <br/><br/>City Name: Hindang<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1497, 'city', 981, 'City created. <br/><br/>City Name: Inopacan<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1498, 'city', 982, 'City created. <br/><br/>City Name: Isabel<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1499, 'city', 983, 'City created. <br/><br/>City Name: Jaro<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1500, 'city', 984, 'City created. <br/><br/>City Name: Javier<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1501, 'city', 985, 'City created. <br/><br/>City Name: Julita<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1502, 'city', 986, 'City created. <br/><br/>City Name: Kananga<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1503, 'city', 987, 'City created. <br/><br/>City Name: La Paz<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1504, 'city', 988, 'City created. <br/><br/>City Name: Leyte<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1505, 'city', 989, 'City created. <br/><br/>City Name: Macarthur<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1506, 'city', 990, 'City created. <br/><br/>City Name: Mahaplag<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1507, 'city', 991, 'City created. <br/><br/>City Name: Matag-Ob<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1508, 'city', 992, 'City created. <br/><br/>City Name: Matalom<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1509, 'city', 993, 'City created. <br/><br/>City Name: Mayorga<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1510, 'city', 994, 'City created. <br/><br/>City Name: Merida<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1511, 'city', 995, 'City created. <br/><br/>City Name: Ormoc City<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1512, 'city', 996, 'City created. <br/><br/>City Name: Palo<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1513, 'city', 997, 'City created. <br/><br/>City Name: Palompon<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1514, 'city', 998, 'City created. <br/><br/>City Name: Pastrana<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1515, 'city', 999, 'City created. <br/><br/>City Name: San Isidro<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1516, 'city', 1000, 'City created. <br/><br/>City Name: San Miguel<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1517, 'city', 1001, 'City created. <br/><br/>City Name: Santa Fe<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1518, 'city', 1002, 'City created. <br/><br/>City Name: Tabango<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1519, 'city', 1003, 'City created. <br/><br/>City Name: Tabontabon<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1520, 'city', 1004, 'City created. <br/><br/>City Name: City of Tacloban<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1521, 'city', 1005, 'City created. <br/><br/>City Name: Tanauan<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1522, 'city', 1006, 'City created. <br/><br/>City Name: Tolosa<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1523, 'city', 1007, 'City created. <br/><br/>City Name: Tunga<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1524, 'city', 1008, 'City created. <br/><br/>City Name: Villaba<br/>State: Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1525, 'city', 1009, 'City created. <br/><br/>City Name: Allen<br/>State: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1526, 'city', 1010, 'City created. <br/><br/>City Name: Biri<br/>State: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1527, 'city', 1011, 'City created. <br/><br/>City Name: Bobon<br/>State: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1528, 'city', 1012, 'City created. <br/><br/>City Name: Capul<br/>State: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1529, 'city', 1013, 'City created. <br/><br/>City Name: Catarman<br/>State: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1530, 'city', 1014, 'City created. <br/><br/>City Name: Catubig<br/>State: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1531, 'city', 1015, 'City created. <br/><br/>City Name: Gamay<br/>State: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1532, 'city', 1016, 'City created. <br/><br/>City Name: Laoang<br/>State: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1533, 'city', 1017, 'City created. <br/><br/>City Name: Lapinig<br/>State: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1534, 'city', 1018, 'City created. <br/><br/>City Name: Las Navas<br/>State: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1535, 'city', 1019, 'City created. <br/><br/>City Name: Lavezares<br/>State: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1536, 'city', 1020, 'City created. <br/><br/>City Name: Mapanas<br/>State: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1537, 'city', 1021, 'City created. <br/><br/>City Name: Mondragon<br/>State: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1538, 'city', 1022, 'City created. <br/><br/>City Name: Palapag<br/>State: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1539, 'city', 1023, 'City created. <br/><br/>City Name: Pambujan<br/>State: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1540, 'city', 1024, 'City created. <br/><br/>City Name: Rosario<br/>State: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1541, 'city', 1025, 'City created. <br/><br/>City Name: San Antonio<br/>State: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1542, 'city', 1026, 'City created. <br/><br/>City Name: San Isidro<br/>State: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1543, 'city', 1027, 'City created. <br/><br/>City Name: San Jose<br/>State: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1544, 'city', 1028, 'City created. <br/><br/>City Name: San Roque<br/>State: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1545, 'city', 1029, 'City created. <br/><br/>City Name: San Vicente<br/>State: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1546, 'city', 1030, 'City created. <br/><br/>City Name: Silvino Lobos<br/>State: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1547, 'city', 1031, 'City created. <br/><br/>City Name: Victoria<br/>State: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1548, 'city', 1032, 'City created. <br/><br/>City Name: Lope De Vega<br/>State: Northern Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1549, 'city', 1033, 'City created. <br/><br/>City Name: Almagro<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1550, 'city', 1034, 'City created. <br/><br/>City Name: Basey<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1551, 'city', 1035, 'City created. <br/><br/>City Name: City of Calbayog<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1552, 'city', 1036, 'City created. <br/><br/>City Name: Calbiga<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1553, 'city', 1037, 'City created. <br/><br/>City Name: City of Catbalogan<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1554, 'city', 1038, 'City created. <br/><br/>City Name: Daram<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1555, 'city', 1039, 'City created. <br/><br/>City Name: Gandara<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1556, 'city', 1040, 'City created. <br/><br/>City Name: Hinabangan<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1557, 'city', 1041, 'City created. <br/><br/>City Name: Jiabong<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1558, 'city', 1042, 'City created. <br/><br/>City Name: Marabut<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1559, 'city', 1043, 'City created. <br/><br/>City Name: Matuguinao<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1560, 'city', 1044, 'City created. <br/><br/>City Name: Motiong<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16'),
(1561, 'city', 1045, 'City created. <br/><br/>City Name: Pinabacdao<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:16', '2024-06-26 15:48:16');
INSERT INTO `audit_log` (`audit_log_id`, `table_name`, `reference_id`, `log`, `changed_by`, `changed_at`, `created_date`) VALUES
(1562, 'city', 1046, 'City created. <br/><br/>City Name: San Jose De Buan<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1563, 'city', 1047, 'City created. <br/><br/>City Name: San Sebastian<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1564, 'city', 1048, 'City created. <br/><br/>City Name: Santa Margarita<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1565, 'city', 1049, 'City created. <br/><br/>City Name: Santa Rita<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1566, 'city', 1050, 'City created. <br/><br/>City Name: Santo Niño<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1567, 'city', 1051, 'City created. <br/><br/>City Name: Talalora<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1568, 'city', 1052, 'City created. <br/><br/>City Name: Tarangnan<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1569, 'city', 1053, 'City created. <br/><br/>City Name: Villareal<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1570, 'city', 1054, 'City created. <br/><br/>City Name: Paranas<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1571, 'city', 1055, 'City created. <br/><br/>City Name: Zumarraga<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1572, 'city', 1056, 'City created. <br/><br/>City Name: Tagapul-An<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1573, 'city', 1057, 'City created. <br/><br/>City Name: San Jorge<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1574, 'city', 1058, 'City created. <br/><br/>City Name: Pagsanghan<br/>State: Samar<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1575, 'city', 1059, 'City created. <br/><br/>City Name: Anahawan<br/>State: Southern Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1576, 'city', 1060, 'City created. <br/><br/>City Name: Bontoc<br/>State: Southern Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1577, 'city', 1061, 'City created. <br/><br/>City Name: Hinunangan<br/>State: Southern Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1578, 'city', 1062, 'City created. <br/><br/>City Name: Hinundayan<br/>State: Southern Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1579, 'city', 1063, 'City created. <br/><br/>City Name: Libagon<br/>State: Southern Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1580, 'city', 1064, 'City created. <br/><br/>City Name: Liloan<br/>State: Southern Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1581, 'city', 1065, 'City created. <br/><br/>City Name: City of Maasin<br/>State: Southern Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1582, 'city', 1066, 'City created. <br/><br/>City Name: Macrohon<br/>State: Southern Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1583, 'city', 1067, 'City created. <br/><br/>City Name: Malitbog<br/>State: Southern Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1584, 'city', 1068, 'City created. <br/><br/>City Name: Padre Burgos<br/>State: Southern Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1585, 'city', 1069, 'City created. <br/><br/>City Name: Pintuyan<br/>State: Southern Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1586, 'city', 1070, 'City created. <br/><br/>City Name: Saint Bernard<br/>State: Southern Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1587, 'city', 1071, 'City created. <br/><br/>City Name: San Francisco<br/>State: Southern Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1588, 'city', 1072, 'City created. <br/><br/>City Name: San Juan<br/>State: Southern Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1589, 'city', 1073, 'City created. <br/><br/>City Name: San Ricardo<br/>State: Southern Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1590, 'city', 1074, 'City created. <br/><br/>City Name: Silago<br/>State: Southern Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1591, 'city', 1075, 'City created. <br/><br/>City Name: Sogod<br/>State: Southern Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1592, 'city', 1076, 'City created. <br/><br/>City Name: Tomas Oppus<br/>State: Southern Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1593, 'city', 1077, 'City created. <br/><br/>City Name: Limasawa<br/>State: Southern Leyte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1594, 'city', 1078, 'City created. <br/><br/>City Name: Almeria<br/>State: Biliran<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1595, 'city', 1079, 'City created. <br/><br/>City Name: Biliran<br/>State: Biliran<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1596, 'city', 1080, 'City created. <br/><br/>City Name: Cabucgayan<br/>State: Biliran<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1597, 'city', 1081, 'City created. <br/><br/>City Name: Caibiran<br/>State: Biliran<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1598, 'city', 1082, 'City created. <br/><br/>City Name: Culaba<br/>State: Biliran<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1599, 'city', 1083, 'City created. <br/><br/>City Name: Kawayan<br/>State: Biliran<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1600, 'city', 1084, 'City created. <br/><br/>City Name: Maripipi<br/>State: Biliran<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1601, 'city', 1085, 'City created. <br/><br/>City Name: Naval<br/>State: Biliran<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1602, 'city', 1086, 'City created. <br/><br/>City Name: City of Dapitan<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1603, 'city', 1087, 'City created. <br/><br/>City Name: City of Dipolog<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1604, 'city', 1088, 'City created. <br/><br/>City Name: Katipunan<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1605, 'city', 1089, 'City created. <br/><br/>City Name: La Libertad<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1606, 'city', 1090, 'City created. <br/><br/>City Name: Labason<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1607, 'city', 1091, 'City created. <br/><br/>City Name: Liloy<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1608, 'city', 1092, 'City created. <br/><br/>City Name: Manukan<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1609, 'city', 1093, 'City created. <br/><br/>City Name: Mutia<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1610, 'city', 1094, 'City created. <br/><br/>City Name: Piñan<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1611, 'city', 1095, 'City created. <br/><br/>City Name: Polanco<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1612, 'city', 1096, 'City created. <br/><br/>City Name: Pres. Manuel A. Roxas<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1613, 'city', 1097, 'City created. <br/><br/>City Name: Rizal<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1614, 'city', 1098, 'City created. <br/><br/>City Name: Salug<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1615, 'city', 1099, 'City created. <br/><br/>City Name: Sergio Osmeña Sr.<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1616, 'city', 1100, 'City created. <br/><br/>City Name: Siayan<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1617, 'city', 1101, 'City created. <br/><br/>City Name: Sibuco<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1618, 'city', 1102, 'City created. <br/><br/>City Name: Sibutad<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1619, 'city', 1103, 'City created. <br/><br/>City Name: Sindangan<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1620, 'city', 1104, 'City created. <br/><br/>City Name: Siocon<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1621, 'city', 1105, 'City created. <br/><br/>City Name: Sirawai<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1622, 'city', 1106, 'City created. <br/><br/>City Name: Tampilisan<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1623, 'city', 1107, 'City created. <br/><br/>City Name: Jose Dalman<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1624, 'city', 1108, 'City created. <br/><br/>City Name: Gutalac<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1625, 'city', 1109, 'City created. <br/><br/>City Name: Baliguian<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1626, 'city', 1110, 'City created. <br/><br/>City Name: Godod<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1627, 'city', 1111, 'City created. <br/><br/>City Name: Bacungan<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1628, 'city', 1112, 'City created. <br/><br/>City Name: Kalawit<br/>State: Zamboanga del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1629, 'city', 1113, 'City created. <br/><br/>City Name: Aurora<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1630, 'city', 1114, 'City created. <br/><br/>City Name: Bayog<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1631, 'city', 1115, 'City created. <br/><br/>City Name: Dimataling<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1632, 'city', 1116, 'City created. <br/><br/>City Name: Dinas<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1633, 'city', 1117, 'City created. <br/><br/>City Name: Dumalinao<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1634, 'city', 1118, 'City created. <br/><br/>City Name: Dumingag<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1635, 'city', 1119, 'City created. <br/><br/>City Name: Kumalarang<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1636, 'city', 1120, 'City created. <br/><br/>City Name: Labangan<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1637, 'city', 1121, 'City created. <br/><br/>City Name: Lapuyan<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1638, 'city', 1122, 'City created. <br/><br/>City Name: Mahayag<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1639, 'city', 1123, 'City created. <br/><br/>City Name: Margosatubig<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1640, 'city', 1124, 'City created. <br/><br/>City Name: Midsalip<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1641, 'city', 1125, 'City created. <br/><br/>City Name: Molave<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1642, 'city', 1126, 'City created. <br/><br/>City Name: City of Pagadian<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1643, 'city', 1127, 'City created. <br/><br/>City Name: Ramon Magsaysay<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1644, 'city', 1128, 'City created. <br/><br/>City Name: San Miguel<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1645, 'city', 1129, 'City created. <br/><br/>City Name: San Pablo<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1646, 'city', 1130, 'City created. <br/><br/>City Name: Tabina<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1647, 'city', 1131, 'City created. <br/><br/>City Name: Tambulig<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1648, 'city', 1132, 'City created. <br/><br/>City Name: Tukuran<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1649, 'city', 1133, 'City created. <br/><br/>City Name: City of Zamboanga<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1650, 'city', 1134, 'City created. <br/><br/>City Name: Lakewood<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1651, 'city', 1135, 'City created. <br/><br/>City Name: Josefina<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1652, 'city', 1136, 'City created. <br/><br/>City Name: Pitogo<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1653, 'city', 1137, 'City created. <br/><br/>City Name: Sominot<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1654, 'city', 1138, 'City created. <br/><br/>City Name: Vincenzo A. Sagun<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1655, 'city', 1139, 'City created. <br/><br/>City Name: Guipos<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1656, 'city', 1140, 'City created. <br/><br/>City Name: Tigbao<br/>State: Zamboanga del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1657, 'city', 1141, 'City created. <br/><br/>City Name: Alicia<br/>State: Zamboanga Sibugay<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1658, 'city', 1142, 'City created. <br/><br/>City Name: Buug<br/>State: Zamboanga Sibugay<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1659, 'city', 1143, 'City created. <br/><br/>City Name: Diplahan<br/>State: Zamboanga Sibugay<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1660, 'city', 1144, 'City created. <br/><br/>City Name: Imelda<br/>State: Zamboanga Sibugay<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1661, 'city', 1145, 'City created. <br/><br/>City Name: Ipil<br/>State: Zamboanga Sibugay<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1662, 'city', 1146, 'City created. <br/><br/>City Name: Kabasalan<br/>State: Zamboanga Sibugay<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1663, 'city', 1147, 'City created. <br/><br/>City Name: Mabuhay<br/>State: Zamboanga Sibugay<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1664, 'city', 1148, 'City created. <br/><br/>City Name: Malangas<br/>State: Zamboanga Sibugay<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1665, 'city', 1149, 'City created. <br/><br/>City Name: Naga<br/>State: Zamboanga Sibugay<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1666, 'city', 1150, 'City created. <br/><br/>City Name: Olutanga<br/>State: Zamboanga Sibugay<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1667, 'city', 1151, 'City created. <br/><br/>City Name: Payao<br/>State: Zamboanga Sibugay<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1668, 'city', 1152, 'City created. <br/><br/>City Name: Roseller Lim<br/>State: Zamboanga Sibugay<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1669, 'city', 1153, 'City created. <br/><br/>City Name: Siay<br/>State: Zamboanga Sibugay<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1670, 'city', 1154, 'City created. <br/><br/>City Name: Talusan<br/>State: Zamboanga Sibugay<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1671, 'city', 1155, 'City created. <br/><br/>City Name: Titay<br/>State: Zamboanga Sibugay<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1672, 'city', 1156, 'City created. <br/><br/>City Name: Tungawan<br/>State: Zamboanga Sibugay<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1673, 'city', 1157, 'City created. <br/><br/>City Name: City of Isabela<br/>State: Zamboanga Sibugay<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1674, 'city', 1158, 'City created. <br/><br/>City Name: Baungon<br/>State: Bukidnon<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1675, 'city', 1159, 'City created. <br/><br/>City Name: Damulog<br/>State: Bukidnon<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1676, 'city', 1160, 'City created. <br/><br/>City Name: Dangcagan<br/>State: Bukidnon<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1677, 'city', 1161, 'City created. <br/><br/>City Name: Don Carlos<br/>State: Bukidnon<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1678, 'city', 1162, 'City created. <br/><br/>City Name: Impasug-ong<br/>State: Bukidnon<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1679, 'city', 1163, 'City created. <br/><br/>City Name: Kadingilan<br/>State: Bukidnon<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1680, 'city', 1164, 'City created. <br/><br/>City Name: Kalilangan<br/>State: Bukidnon<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1681, 'city', 1165, 'City created. <br/><br/>City Name: Kibawe<br/>State: Bukidnon<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1682, 'city', 1166, 'City created. <br/><br/>City Name: Kitaotao<br/>State: Bukidnon<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1683, 'city', 1167, 'City created. <br/><br/>City Name: Lantapan<br/>State: Bukidnon<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1684, 'city', 1168, 'City created. <br/><br/>City Name: Libona<br/>State: Bukidnon<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1685, 'city', 1169, 'City created. <br/><br/>City Name: City of Malaybalay<br/>State: Bukidnon<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1686, 'city', 1170, 'City created. <br/><br/>City Name: Malitbog<br/>State: Bukidnon<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1687, 'city', 1171, 'City created. <br/><br/>City Name: Manolo Fortich<br/>State: Bukidnon<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1688, 'city', 1172, 'City created. <br/><br/>City Name: Maramag<br/>State: Bukidnon<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1689, 'city', 1173, 'City created. <br/><br/>City Name: Pangantucan<br/>State: Bukidnon<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1690, 'city', 1174, 'City created. <br/><br/>City Name: Quezon<br/>State: Bukidnon<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1691, 'city', 1175, 'City created. <br/><br/>City Name: San Fernando<br/>State: Bukidnon<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1692, 'city', 1176, 'City created. <br/><br/>City Name: Sumilao<br/>State: Bukidnon<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1693, 'city', 1177, 'City created. <br/><br/>City Name: Talakag<br/>State: Bukidnon<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1694, 'city', 1178, 'City created. <br/><br/>City Name: City of Valencia<br/>State: Bukidnon<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1695, 'city', 1179, 'City created. <br/><br/>City Name: Cabanglasan<br/>State: Bukidnon<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1696, 'city', 1180, 'City created. <br/><br/>City Name: Catarman<br/>State: Camiguin<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1697, 'city', 1181, 'City created. <br/><br/>City Name: Guinsiliban<br/>State: Camiguin<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1698, 'city', 1182, 'City created. <br/><br/>City Name: Mahinog<br/>State: Camiguin<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1699, 'city', 1183, 'City created. <br/><br/>City Name: Mambajao<br/>State: Camiguin<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1700, 'city', 1184, 'City created. <br/><br/>City Name: Sagay<br/>State: Camiguin<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1701, 'city', 1185, 'City created. <br/><br/>City Name: Bacolod<br/>State: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1702, 'city', 1186, 'City created. <br/><br/>City Name: Baloi<br/>State: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1703, 'city', 1187, 'City created. <br/><br/>City Name: Baroy<br/>State: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1704, 'city', 1188, 'City created. <br/><br/>City Name: City of Iligan<br/>State: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1705, 'city', 1189, 'City created. <br/><br/>City Name: Kapatagan<br/>State: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1706, 'city', 1190, 'City created. <br/><br/>City Name: Sultan Naga Dimaporo<br/>State: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1707, 'city', 1191, 'City created. <br/><br/>City Name: Kauswagan<br/>State: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1708, 'city', 1192, 'City created. <br/><br/>City Name: Kolambugan<br/>State: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1709, 'city', 1193, 'City created. <br/><br/>City Name: Lala<br/>State: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1710, 'city', 1194, 'City created. <br/><br/>City Name: Linamon<br/>State: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1711, 'city', 1195, 'City created. <br/><br/>City Name: Magsaysay<br/>State: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1712, 'city', 1196, 'City created. <br/><br/>City Name: Maigo<br/>State: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1713, 'city', 1197, 'City created. <br/><br/>City Name: Matungao<br/>State: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1714, 'city', 1198, 'City created. <br/><br/>City Name: Munai<br/>State: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1715, 'city', 1199, 'City created. <br/><br/>City Name: Nunungan<br/>State: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1716, 'city', 1200, 'City created. <br/><br/>City Name: Pantao Ragat<br/>State: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1717, 'city', 1201, 'City created. <br/><br/>City Name: Poona Piagapo<br/>State: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1718, 'city', 1202, 'City created. <br/><br/>City Name: Salvador<br/>State: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1719, 'city', 1203, 'City created. <br/><br/>City Name: Sapad<br/>State: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1720, 'city', 1204, 'City created. <br/><br/>City Name: Tagoloan<br/>State: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1721, 'city', 1205, 'City created. <br/><br/>City Name: Tangcal<br/>State: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1722, 'city', 1206, 'City created. <br/><br/>City Name: Tubod<br/>State: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1723, 'city', 1207, 'City created. <br/><br/>City Name: Pantar<br/>State: Lanao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1724, 'city', 1208, 'City created. <br/><br/>City Name: Aloran<br/>State: Misamis Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1725, 'city', 1209, 'City created. <br/><br/>City Name: Baliangao<br/>State: Misamis Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1726, 'city', 1210, 'City created. <br/><br/>City Name: Bonifacio<br/>State: Misamis Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1727, 'city', 1211, 'City created. <br/><br/>City Name: Calamba<br/>State: Misamis Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1728, 'city', 1212, 'City created. <br/><br/>City Name: Clarin<br/>State: Misamis Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1729, 'city', 1213, 'City created. <br/><br/>City Name: Concepcion<br/>State: Misamis Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1730, 'city', 1214, 'City created. <br/><br/>City Name: Jimenez<br/>State: Misamis Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1731, 'city', 1215, 'City created. <br/><br/>City Name: Lopez Jaena<br/>State: Misamis Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1732, 'city', 1216, 'City created. <br/><br/>City Name: City of Oroquieta<br/>State: Misamis Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1733, 'city', 1217, 'City created. <br/><br/>City Name: City of Ozamiz<br/>State: Misamis Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1734, 'city', 1218, 'City created. <br/><br/>City Name: Panaon<br/>State: Misamis Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1735, 'city', 1219, 'City created. <br/><br/>City Name: Plaridel<br/>State: Misamis Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1736, 'city', 1220, 'City created. <br/><br/>City Name: Sapang Dalaga<br/>State: Misamis Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1737, 'city', 1221, 'City created. <br/><br/>City Name: Sinacaban<br/>State: Misamis Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1738, 'city', 1222, 'City created. <br/><br/>City Name: City of Tangub<br/>State: Misamis Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1739, 'city', 1223, 'City created. <br/><br/>City Name: Tudela<br/>State: Misamis Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1740, 'city', 1224, 'City created. <br/><br/>City Name: Don Victoriano Chiongbian<br/>State: Misamis Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1741, 'city', 1225, 'City created. <br/><br/>City Name: Alubijid<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1742, 'city', 1226, 'City created. <br/><br/>City Name: Balingasag<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1743, 'city', 1227, 'City created. <br/><br/>City Name: Balingoan<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1744, 'city', 1228, 'City created. <br/><br/>City Name: Binuangan<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1745, 'city', 1229, 'City created. <br/><br/>City Name: City of Cagayan De Oro<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1746, 'city', 1230, 'City created. <br/><br/>City Name: Claveria<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1747, 'city', 1231, 'City created. <br/><br/>City Name: City of El Salvador<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1748, 'city', 1232, 'City created. <br/><br/>City Name: City of Gingoog<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1749, 'city', 1233, 'City created. <br/><br/>City Name: Gitagum<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1750, 'city', 1234, 'City created. <br/><br/>City Name: Initao<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1751, 'city', 1235, 'City created. <br/><br/>City Name: Jasaan<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1752, 'city', 1236, 'City created. <br/><br/>City Name: Kinoguitan<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1753, 'city', 1237, 'City created. <br/><br/>City Name: Lagonglong<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1754, 'city', 1238, 'City created. <br/><br/>City Name: Laguindingan<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1755, 'city', 1239, 'City created. <br/><br/>City Name: Libertad<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1756, 'city', 1240, 'City created. <br/><br/>City Name: Lugait<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1757, 'city', 1241, 'City created. <br/><br/>City Name: Magsaysay<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1758, 'city', 1242, 'City created. <br/><br/>City Name: Manticao<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1759, 'city', 1243, 'City created. <br/><br/>City Name: Medina<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1760, 'city', 1244, 'City created. <br/><br/>City Name: Naawan<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1761, 'city', 1245, 'City created. <br/><br/>City Name: Opol<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1762, 'city', 1246, 'City created. <br/><br/>City Name: Salay<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1763, 'city', 1247, 'City created. <br/><br/>City Name: Sugbongcogon<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1764, 'city', 1248, 'City created. <br/><br/>City Name: Tagoloan<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1765, 'city', 1249, 'City created. <br/><br/>City Name: Talisayan<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1766, 'city', 1250, 'City created. <br/><br/>City Name: Villanueva<br/>State: Misamis Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1767, 'city', 1251, 'City created. <br/><br/>City Name: Asuncion<br/>State: Davao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1768, 'city', 1252, 'City created. <br/><br/>City Name: Carmen<br/>State: Davao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1769, 'city', 1253, 'City created. <br/><br/>City Name: Kapalong<br/>State: Davao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1770, 'city', 1254, 'City created. <br/><br/>City Name: New Corella<br/>State: Davao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1771, 'city', 1255, 'City created. <br/><br/>City Name: City of Panabo<br/>State: Davao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1772, 'city', 1256, 'City created. <br/><br/>City Name: Island Garden City of Samal<br/>State: Davao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1773, 'city', 1257, 'City created. <br/><br/>City Name: Santo Tomas<br/>State: Davao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1774, 'city', 1258, 'City created. <br/><br/>City Name: City of Tagum<br/>State: Davao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1775, 'city', 1259, 'City created. <br/><br/>City Name: Talaingod<br/>State: Davao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1776, 'city', 1260, 'City created. <br/><br/>City Name: Braulio E. Dujali<br/>State: Davao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1777, 'city', 1261, 'City created. <br/><br/>City Name: San Isidro<br/>State: Davao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1778, 'city', 1262, 'City created. <br/><br/>City Name: Bansalan<br/>State: Davao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1779, 'city', 1263, 'City created. <br/><br/>City Name: City of Davao<br/>State: Davao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1780, 'city', 1264, 'City created. <br/><br/>City Name: City of Digos<br/>State: Davao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1781, 'city', 1265, 'City created. <br/><br/>City Name: Hagonoy<br/>State: Davao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1782, 'city', 1266, 'City created. <br/><br/>City Name: Kiblawan<br/>State: Davao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1783, 'city', 1267, 'City created. <br/><br/>City Name: Magsaysay<br/>State: Davao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1784, 'city', 1268, 'City created. <br/><br/>City Name: Malalag<br/>State: Davao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1785, 'city', 1269, 'City created. <br/><br/>City Name: Matanao<br/>State: Davao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1786, 'city', 1270, 'City created. <br/><br/>City Name: Padada<br/>State: Davao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1787, 'city', 1271, 'City created. <br/><br/>City Name: Santa Cruz<br/>State: Davao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1788, 'city', 1272, 'City created. <br/><br/>City Name: Sulop<br/>State: Davao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1789, 'city', 1273, 'City created. <br/><br/>City Name: Baganga<br/>State: Davao Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1790, 'city', 1274, 'City created. <br/><br/>City Name: Banaybanay<br/>State: Davao Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1791, 'city', 1275, 'City created. <br/><br/>City Name: Boston<br/>State: Davao Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1792, 'city', 1276, 'City created. <br/><br/>City Name: Caraga<br/>State: Davao Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1793, 'city', 1277, 'City created. <br/><br/>City Name: Cateel<br/>State: Davao Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1794, 'city', 1278, 'City created. <br/><br/>City Name: Governor Generoso<br/>State: Davao Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1795, 'city', 1279, 'City created. <br/><br/>City Name: Lupon<br/>State: Davao Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1796, 'city', 1280, 'City created. <br/><br/>City Name: Manay<br/>State: Davao Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1797, 'city', 1281, 'City created. <br/><br/>City Name: City of Mati<br/>State: Davao Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1798, 'city', 1282, 'City created. <br/><br/>City Name: San Isidro<br/>State: Davao Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1799, 'city', 1283, 'City created. <br/><br/>City Name: Tarragona<br/>State: Davao Oriental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1800, 'city', 1284, 'City created. <br/><br/>City Name: Compostela<br/>State: Davao de Oro<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1801, 'city', 1285, 'City created. <br/><br/>City Name: Laak<br/>State: Davao de Oro<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1802, 'city', 1286, 'City created. <br/><br/>City Name: Mabini<br/>State: Davao de Oro<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1803, 'city', 1287, 'City created. <br/><br/>City Name: Maco<br/>State: Davao de Oro<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1804, 'city', 1288, 'City created. <br/><br/>City Name: Maragusan<br/>State: Davao de Oro<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1805, 'city', 1289, 'City created. <br/><br/>City Name: Mawab<br/>State: Davao de Oro<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1806, 'city', 1290, 'City created. <br/><br/>City Name: Monkayo<br/>State: Davao de Oro<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1807, 'city', 1291, 'City created. <br/><br/>City Name: Montevista<br/>State: Davao de Oro<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1808, 'city', 1292, 'City created. <br/><br/>City Name: Nabunturan<br/>State: Davao de Oro<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1809, 'city', 1293, 'City created. <br/><br/>City Name: New Bataan<br/>State: Davao de Oro<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1810, 'city', 1294, 'City created. <br/><br/>City Name: Pantukan<br/>State: Davao de Oro<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1811, 'city', 1295, 'City created. <br/><br/>City Name: Don Marcelino<br/>State: Davao Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1812, 'city', 1296, 'City created. <br/><br/>City Name: Jose Abad Santos<br/>State: Davao Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1813, 'city', 1297, 'City created. <br/><br/>City Name: Malita<br/>State: Davao Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1814, 'city', 1298, 'City created. <br/><br/>City Name: Santa Maria<br/>State: Davao Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1815, 'city', 1299, 'City created. <br/><br/>City Name: Sarangani<br/>State: Davao Occidental<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1816, 'city', 1300, 'City created. <br/><br/>City Name: Alamada<br/>State: Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1817, 'city', 1301, 'City created. <br/><br/>City Name: Carmen<br/>State: Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1818, 'city', 1302, 'City created. <br/><br/>City Name: Kabacan<br/>State: Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1819, 'city', 1303, 'City created. <br/><br/>City Name: City of Kidapawan<br/>State: Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1820, 'city', 1304, 'City created. <br/><br/>City Name: Libungan<br/>State: Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1821, 'city', 1305, 'City created. <br/><br/>City Name: Magpet<br/>State: Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1822, 'city', 1306, 'City created. <br/><br/>City Name: Makilala<br/>State: Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1823, 'city', 1307, 'City created. <br/><br/>City Name: Matalam<br/>State: Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1824, 'city', 1308, 'City created. <br/><br/>City Name: Midsayap<br/>State: Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1825, 'city', 1309, 'City created. <br/><br/>City Name: M Lang<br/>State: Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1826, 'city', 1310, 'City created. <br/><br/>City Name: Pigkawayan<br/>State: Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1827, 'city', 1311, 'City created. <br/><br/>City Name: Pikit<br/>State: Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1828, 'city', 1312, 'City created. <br/><br/>City Name: President Roxas<br/>State: Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1829, 'city', 1313, 'City created. <br/><br/>City Name: Tulunan<br/>State: Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1830, 'city', 1314, 'City created. <br/><br/>City Name: Antipas<br/>State: Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1831, 'city', 1315, 'City created. <br/><br/>City Name: Banisilan<br/>State: Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1832, 'city', 1316, 'City created. <br/><br/>City Name: Aleosan<br/>State: Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1833, 'city', 1317, 'City created. <br/><br/>City Name: Arakan<br/>State: Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1834, 'city', 1318, 'City created. <br/><br/>City Name: Banga<br/>State: South Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1835, 'city', 1319, 'City created. <br/><br/>City Name: City of General Santos<br/>State: South Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1836, 'city', 1320, 'City created. <br/><br/>City Name: City of Koronadal<br/>State: South Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1837, 'city', 1321, 'City created. <br/><br/>City Name: Norala<br/>State: South Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1838, 'city', 1322, 'City created. <br/><br/>City Name: Polomolok<br/>State: South Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1839, 'city', 1323, 'City created. <br/><br/>City Name: Surallah<br/>State: South Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1840, 'city', 1324, 'City created. <br/><br/>City Name: Tampakan<br/>State: South Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1841, 'city', 1325, 'City created. <br/><br/>City Name: Tantangan<br/>State: South Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1842, 'city', 1326, 'City created. <br/><br/>City Name: T Boli<br/>State: South Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1843, 'city', 1327, 'City created. <br/><br/>City Name: Tupi<br/>State: South Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1844, 'city', 1328, 'City created. <br/><br/>City Name: Santo Niño<br/>State: South Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1845, 'city', 1329, 'City created. <br/><br/>City Name: Lake Sebu<br/>State: South Cotabato<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1846, 'city', 1330, 'City created. <br/><br/>City Name: Bagumbayan<br/>State: Sultan Kudarat<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1847, 'city', 1331, 'City created. <br/><br/>City Name: Columbio<br/>State: Sultan Kudarat<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1848, 'city', 1332, 'City created. <br/><br/>City Name: Esperanza<br/>State: Sultan Kudarat<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1849, 'city', 1333, 'City created. <br/><br/>City Name: Isulan<br/>State: Sultan Kudarat<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1850, 'city', 1334, 'City created. <br/><br/>City Name: Kalamansig<br/>State: Sultan Kudarat<br/>Country: Philippines', 1, '2024-06-26 15:48:17', '2024-06-26 15:48:17'),
(1851, 'city', 1335, 'City created. <br/><br/>City Name: Lebak<br/>State: Sultan Kudarat<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1852, 'city', 1336, 'City created. <br/><br/>City Name: Lutayan<br/>State: Sultan Kudarat<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1853, 'city', 1337, 'City created. <br/><br/>City Name: Lambayong<br/>State: Sultan Kudarat<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1854, 'city', 1338, 'City created. <br/><br/>City Name: Palimbang<br/>State: Sultan Kudarat<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1855, 'city', 1339, 'City created. <br/><br/>City Name: President Quirino<br/>State: Sultan Kudarat<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1856, 'city', 1340, 'City created. <br/><br/>City Name: City of Tacurong<br/>State: Sultan Kudarat<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1857, 'city', 1341, 'City created. <br/><br/>City Name: Sen. Ninoy Aquino<br/>State: Sultan Kudarat<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1858, 'city', 1342, 'City created. <br/><br/>City Name: Alabel<br/>State: Sarangani<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18');
INSERT INTO `audit_log` (`audit_log_id`, `table_name`, `reference_id`, `log`, `changed_by`, `changed_at`, `created_date`) VALUES
(1859, 'city', 1343, 'City created. <br/><br/>City Name: Glan<br/>State: Sarangani<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1860, 'city', 1344, 'City created. <br/><br/>City Name: Kiamba<br/>State: Sarangani<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1861, 'city', 1345, 'City created. <br/><br/>City Name: Maasim<br/>State: Sarangani<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1862, 'city', 1346, 'City created. <br/><br/>City Name: Maitum<br/>State: Sarangani<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1863, 'city', 1347, 'City created. <br/><br/>City Name: Malapatan<br/>State: Sarangani<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1864, 'city', 1348, 'City created. <br/><br/>City Name: Malungon<br/>State: Sarangani<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1865, 'city', 1349, 'City created. <br/><br/>City Name: Cotabato City<br/>State: Sarangani<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1866, 'city', 1350, 'City created. <br/><br/>City Name: Manila<br/>State: Metro Manila<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1867, 'city', 1351, 'City created. <br/><br/>City Name: Mandaluyong City<br/>State: Metro Manila<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1868, 'city', 1352, 'City created. <br/><br/>City Name: Marikina City<br/>State: Metro Manila<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1869, 'city', 1353, 'City created. <br/><br/>City Name: Pasig City<br/>State: Metro Manila<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1870, 'city', 1354, 'City created. <br/><br/>City Name: Quezon City<br/>State: Metro Manila<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1871, 'city', 1355, 'City created. <br/><br/>City Name: San Juan City<br/>State: Metro Manila<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1872, 'city', 1356, 'City created. <br/><br/>City Name: Caloocan City<br/>State: Metro Manila<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1873, 'city', 1357, 'City created. <br/><br/>City Name: Malabon City<br/>State: Metro Manila<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1874, 'city', 1358, 'City created. <br/><br/>City Name: Navotas City<br/>State: Metro Manila<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1875, 'city', 1359, 'City created. <br/><br/>City Name: Valenzuela City<br/>State: Metro Manila<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1876, 'city', 1360, 'City created. <br/><br/>City Name: Las Piñas City<br/>State: Metro Manila<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1877, 'city', 1361, 'City created. <br/><br/>City Name: Makati City<br/>State: Metro Manila<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1878, 'city', 1362, 'City created. <br/><br/>City Name: Muntinlupa City<br/>State: Metro Manila<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1879, 'city', 1363, 'City created. <br/><br/>City Name: Parañaque City<br/>State: Metro Manila<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1880, 'city', 1364, 'City created. <br/><br/>City Name: Pasay City<br/>State: Metro Manila<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1881, 'city', 1365, 'City created. <br/><br/>City Name: Pateros<br/>State: Metro Manila<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1882, 'city', 1366, 'City created. <br/><br/>City Name: Taguig City<br/>State: Metro Manila<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1883, 'city', 1367, 'City created. <br/><br/>City Name: Bangued<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1884, 'city', 1368, 'City created. <br/><br/>City Name: Boliney<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1885, 'city', 1369, 'City created. <br/><br/>City Name: Bucay<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1886, 'city', 1370, 'City created. <br/><br/>City Name: Bucloc<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1887, 'city', 1371, 'City created. <br/><br/>City Name: Daguioman<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1888, 'city', 1372, 'City created. <br/><br/>City Name: Danglas<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1889, 'city', 1373, 'City created. <br/><br/>City Name: Dolores<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1890, 'city', 1374, 'City created. <br/><br/>City Name: La Paz<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1891, 'city', 1375, 'City created. <br/><br/>City Name: Lacub<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1892, 'city', 1376, 'City created. <br/><br/>City Name: Lagangilang<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1893, 'city', 1377, 'City created. <br/><br/>City Name: Lagayan<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1894, 'city', 1378, 'City created. <br/><br/>City Name: Langiden<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1895, 'city', 1379, 'City created. <br/><br/>City Name: Licuan-Baay<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1896, 'city', 1380, 'City created. <br/><br/>City Name: Luba<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1897, 'city', 1381, 'City created. <br/><br/>City Name: Malibcong<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1898, 'city', 1382, 'City created. <br/><br/>City Name: Manabo<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1899, 'city', 1383, 'City created. <br/><br/>City Name: Peñarrubia<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1900, 'city', 1384, 'City created. <br/><br/>City Name: Pidigan<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1901, 'city', 1385, 'City created. <br/><br/>City Name: Pilar<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1902, 'city', 1386, 'City created. <br/><br/>City Name: Sallapadan<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1903, 'city', 1387, 'City created. <br/><br/>City Name: San Isidro<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1904, 'city', 1388, 'City created. <br/><br/>City Name: San Juan<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1905, 'city', 1389, 'City created. <br/><br/>City Name: San Quintin<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1906, 'city', 1390, 'City created. <br/><br/>City Name: Tayum<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1907, 'city', 1391, 'City created. <br/><br/>City Name: Tineg<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1908, 'city', 1392, 'City created. <br/><br/>City Name: Tubo<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1909, 'city', 1393, 'City created. <br/><br/>City Name: Villaviciosa<br/>State: Abra<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1910, 'city', 1394, 'City created. <br/><br/>City Name: Atok<br/>State: Benguet<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1911, 'city', 1395, 'City created. <br/><br/>City Name: City of Baguio<br/>State: Benguet<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1912, 'city', 1396, 'City created. <br/><br/>City Name: Bakun<br/>State: Benguet<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1913, 'city', 1397, 'City created. <br/><br/>City Name: Bokod<br/>State: Benguet<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1914, 'city', 1398, 'City created. <br/><br/>City Name: Buguias<br/>State: Benguet<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1915, 'city', 1399, 'City created. <br/><br/>City Name: Itogon<br/>State: Benguet<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1916, 'city', 1400, 'City created. <br/><br/>City Name: Kabayan<br/>State: Benguet<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1917, 'city', 1401, 'City created. <br/><br/>City Name: Kapangan<br/>State: Benguet<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1918, 'city', 1402, 'City created. <br/><br/>City Name: Kibungan<br/>State: Benguet<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1919, 'city', 1403, 'City created. <br/><br/>City Name: La Trinidad<br/>State: Benguet<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1920, 'city', 1404, 'City created. <br/><br/>City Name: Mankayan<br/>State: Benguet<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1921, 'city', 1405, 'City created. <br/><br/>City Name: Sablan<br/>State: Benguet<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1922, 'city', 1406, 'City created. <br/><br/>City Name: Tuba<br/>State: Benguet<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1923, 'city', 1407, 'City created. <br/><br/>City Name: Tublay<br/>State: Benguet<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1924, 'city', 1408, 'City created. <br/><br/>City Name: Banaue<br/>State: Ifugao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1925, 'city', 1409, 'City created. <br/><br/>City Name: Hungduan<br/>State: Ifugao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1926, 'city', 1410, 'City created. <br/><br/>City Name: Kiangan<br/>State: Ifugao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1927, 'city', 1411, 'City created. <br/><br/>City Name: Lagawe<br/>State: Ifugao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1928, 'city', 1412, 'City created. <br/><br/>City Name: Lamut<br/>State: Ifugao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1929, 'city', 1413, 'City created. <br/><br/>City Name: Mayoyao<br/>State: Ifugao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1930, 'city', 1414, 'City created. <br/><br/>City Name: Alfonso Lista<br/>State: Ifugao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1931, 'city', 1415, 'City created. <br/><br/>City Name: Aguinaldo<br/>State: Ifugao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1932, 'city', 1416, 'City created. <br/><br/>City Name: Hingyon<br/>State: Ifugao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1933, 'city', 1417, 'City created. <br/><br/>City Name: Tinoc<br/>State: Ifugao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1934, 'city', 1418, 'City created. <br/><br/>City Name: Asipulo<br/>State: Ifugao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1935, 'city', 1419, 'City created. <br/><br/>City Name: Balbalan<br/>State: Kalinga<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1936, 'city', 1420, 'City created. <br/><br/>City Name: Lubuagan<br/>State: Kalinga<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1937, 'city', 1421, 'City created. <br/><br/>City Name: Pasil<br/>State: Kalinga<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1938, 'city', 1422, 'City created. <br/><br/>City Name: Pinukpuk<br/>State: Kalinga<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1939, 'city', 1423, 'City created. <br/><br/>City Name: Rizal<br/>State: Kalinga<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1940, 'city', 1424, 'City created. <br/><br/>City Name: City of Tabuk<br/>State: Kalinga<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1941, 'city', 1425, 'City created. <br/><br/>City Name: Tanudan<br/>State: Kalinga<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1942, 'city', 1426, 'City created. <br/><br/>City Name: Tinglayan<br/>State: Kalinga<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1943, 'city', 1427, 'City created. <br/><br/>City Name: Barlig<br/>State: Mountain Province<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1944, 'city', 1428, 'City created. <br/><br/>City Name: Bauko<br/>State: Mountain Province<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1945, 'city', 1429, 'City created. <br/><br/>City Name: Besao<br/>State: Mountain Province<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1946, 'city', 1430, 'City created. <br/><br/>City Name: Bontoc<br/>State: Mountain Province<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1947, 'city', 1431, 'City created. <br/><br/>City Name: Natonin<br/>State: Mountain Province<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1948, 'city', 1432, 'City created. <br/><br/>City Name: Paracelis<br/>State: Mountain Province<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1949, 'city', 1433, 'City created. <br/><br/>City Name: Sabangan<br/>State: Mountain Province<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1950, 'city', 1434, 'City created. <br/><br/>City Name: Sadanga<br/>State: Mountain Province<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1951, 'city', 1435, 'City created. <br/><br/>City Name: Sagada<br/>State: Mountain Province<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1952, 'city', 1436, 'City created. <br/><br/>City Name: Tadian<br/>State: Mountain Province<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1953, 'city', 1437, 'City created. <br/><br/>City Name: Calanasan<br/>State: Apayao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1954, 'city', 1438, 'City created. <br/><br/>City Name: Conner<br/>State: Apayao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1955, 'city', 1439, 'City created. <br/><br/>City Name: Flora<br/>State: Apayao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1956, 'city', 1440, 'City created. <br/><br/>City Name: Kabugao<br/>State: Apayao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1957, 'city', 1441, 'City created. <br/><br/>City Name: Luna<br/>State: Apayao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1958, 'city', 1442, 'City created. <br/><br/>City Name: Pudtol<br/>State: Apayao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1959, 'city', 1443, 'City created. <br/><br/>City Name: Santa Marcela<br/>State: Apayao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1960, 'city', 1444, 'City created. <br/><br/>City Name: City of Lamitan<br/>State: Basilan<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1961, 'city', 1445, 'City created. <br/><br/>City Name: Lantawan<br/>State: Basilan<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1962, 'city', 1446, 'City created. <br/><br/>City Name: Maluso<br/>State: Basilan<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1963, 'city', 1447, 'City created. <br/><br/>City Name: Sumisip<br/>State: Basilan<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1964, 'city', 1448, 'City created. <br/><br/>City Name: Tipo-Tipo<br/>State: Basilan<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1965, 'city', 1449, 'City created. <br/><br/>City Name: Tuburan<br/>State: Basilan<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1966, 'city', 1450, 'City created. <br/><br/>City Name: Akbar<br/>State: Basilan<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1967, 'city', 1451, 'City created. <br/><br/>City Name: Al-Barka<br/>State: Basilan<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1968, 'city', 1452, 'City created. <br/><br/>City Name: Hadji Mohammad Ajul<br/>State: Basilan<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1969, 'city', 1453, 'City created. <br/><br/>City Name: Ungkaya Pukan<br/>State: Basilan<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1970, 'city', 1454, 'City created. <br/><br/>City Name: Hadji Muhtamad<br/>State: Basilan<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1971, 'city', 1455, 'City created. <br/><br/>City Name: Tabuan-Lasa<br/>State: Basilan<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1972, 'city', 1456, 'City created. <br/><br/>City Name: Bacolod-Kalawi<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1973, 'city', 1457, 'City created. <br/><br/>City Name: Balabagan<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1974, 'city', 1458, 'City created. <br/><br/>City Name: Balindong<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1975, 'city', 1459, 'City created. <br/><br/>City Name: Bayang<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1976, 'city', 1460, 'City created. <br/><br/>City Name: Binidayan<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1977, 'city', 1461, 'City created. <br/><br/>City Name: Bubong<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1978, 'city', 1462, 'City created. <br/><br/>City Name: Butig<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1979, 'city', 1463, 'City created. <br/><br/>City Name: Ganassi<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1980, 'city', 1464, 'City created. <br/><br/>City Name: Kapai<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1981, 'city', 1465, 'City created. <br/><br/>City Name: Lumba-Bayabao<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1982, 'city', 1466, 'City created. <br/><br/>City Name: Lumbatan<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1983, 'city', 1467, 'City created. <br/><br/>City Name: Madalum<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1984, 'city', 1468, 'City created. <br/><br/>City Name: Madamba<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1985, 'city', 1469, 'City created. <br/><br/>City Name: Malabang<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1986, 'city', 1470, 'City created. <br/><br/>City Name: Marantao<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1987, 'city', 1471, 'City created. <br/><br/>City Name: City of Marawi<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1988, 'city', 1472, 'City created. <br/><br/>City Name: Masiu<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1989, 'city', 1473, 'City created. <br/><br/>City Name: Mulondo<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1990, 'city', 1474, 'City created. <br/><br/>City Name: Pagayawan<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1991, 'city', 1475, 'City created. <br/><br/>City Name: Piagapo<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1992, 'city', 1476, 'City created. <br/><br/>City Name: Poona Bayabao<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1993, 'city', 1477, 'City created. <br/><br/>City Name: Pualas<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1994, 'city', 1478, 'City created. <br/><br/>City Name: Ditsaan-Ramain<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1995, 'city', 1479, 'City created. <br/><br/>City Name: Saguiaran<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1996, 'city', 1480, 'City created. <br/><br/>City Name: Tamparan<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1997, 'city', 1481, 'City created. <br/><br/>City Name: Taraka<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1998, 'city', 1482, 'City created. <br/><br/>City Name: Tubaran<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(1999, 'city', 1483, 'City created. <br/><br/>City Name: Tugaya<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2000, 'city', 1484, 'City created. <br/><br/>City Name: Wao<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2001, 'city', 1485, 'City created. <br/><br/>City Name: Marogong<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2002, 'city', 1486, 'City created. <br/><br/>City Name: Calanogas<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2003, 'city', 1487, 'City created. <br/><br/>City Name: Buadiposo-Buntong<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2004, 'city', 1488, 'City created. <br/><br/>City Name: Maguing<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2005, 'city', 1489, 'City created. <br/><br/>City Name: Picong<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2006, 'city', 1490, 'City created. <br/><br/>City Name: Lumbayanague<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2007, 'city', 1491, 'City created. <br/><br/>City Name: Amai Manabilang<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2008, 'city', 1492, 'City created. <br/><br/>City Name: Tagoloan Ii<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2009, 'city', 1493, 'City created. <br/><br/>City Name: Kapatagan<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2010, 'city', 1494, 'City created. <br/><br/>City Name: Sultan Dumalondong<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2011, 'city', 1495, 'City created. <br/><br/>City Name: Lumbaca-Unayan<br/>State: Lanao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2012, 'city', 1496, 'City created. <br/><br/>City Name: Ampatuan<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2013, 'city', 1497, 'City created. <br/><br/>City Name: Buldon<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2014, 'city', 1498, 'City created. <br/><br/>City Name: Buluan<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2015, 'city', 1499, 'City created. <br/><br/>City Name: Datu Paglas<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2016, 'city', 1500, 'City created. <br/><br/>City Name: Datu Piang<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2017, 'city', 1501, 'City created. <br/><br/>City Name: Datu Odin Sinsuat<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2018, 'city', 1502, 'City created. <br/><br/>City Name: Shariff Aguak<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2019, 'city', 1503, 'City created. <br/><br/>City Name: Matanog<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2020, 'city', 1504, 'City created. <br/><br/>City Name: Pagalungan<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2021, 'city', 1505, 'City created. <br/><br/>City Name: Parang<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2022, 'city', 1506, 'City created. <br/><br/>City Name: Sultan Kudarat<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2023, 'city', 1507, 'City created. <br/><br/>City Name: Sultan Sa Barongis<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2024, 'city', 1508, 'City created. <br/><br/>City Name: Kabuntalan<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2025, 'city', 1509, 'City created. <br/><br/>City Name: Upi<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2026, 'city', 1510, 'City created. <br/><br/>City Name: Talayan<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2027, 'city', 1511, 'City created. <br/><br/>City Name: South Upi<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2028, 'city', 1512, 'City created. <br/><br/>City Name: Barira<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2029, 'city', 1513, 'City created. <br/><br/>City Name: Gen. S.K. Pendatun<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2030, 'city', 1514, 'City created. <br/><br/>City Name: Mamasapano<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2031, 'city', 1515, 'City created. <br/><br/>City Name: Talitay<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2032, 'city', 1516, 'City created. <br/><br/>City Name: Pagagawan<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2033, 'city', 1517, 'City created. <br/><br/>City Name: Paglat<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2034, 'city', 1518, 'City created. <br/><br/>City Name: Sultan Mastura<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2035, 'city', 1519, 'City created. <br/><br/>City Name: Guindulungan<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2036, 'city', 1520, 'City created. <br/><br/>City Name: Datu Saudi-Ampatuan<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2037, 'city', 1521, 'City created. <br/><br/>City Name: Datu Unsay<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2038, 'city', 1522, 'City created. <br/><br/>City Name: Datu Abdullah Sangki<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2039, 'city', 1523, 'City created. <br/><br/>City Name: Rajah Buayan<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2040, 'city', 1524, 'City created. <br/><br/>City Name: Datu Blah T. Sinsuat<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2041, 'city', 1525, 'City created. <br/><br/>City Name: Datu Anggal Midtimbang<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2042, 'city', 1526, 'City created. <br/><br/>City Name: Mangudadatu<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2043, 'city', 1527, 'City created. <br/><br/>City Name: Pandag<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2044, 'city', 1528, 'City created. <br/><br/>City Name: Northern Kabuntalan<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2045, 'city', 1529, 'City created. <br/><br/>City Name: Datu Hoffer Ampatuan<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2046, 'city', 1530, 'City created. <br/><br/>City Name: Datu Salibo<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2047, 'city', 1531, 'City created. <br/><br/>City Name: Shariff Saydona Mustapha<br/>State: Maguindanao<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2048, 'city', 1532, 'City created. <br/><br/>City Name: Indanan<br/>State: Sulu<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2049, 'city', 1533, 'City created. <br/><br/>City Name: Jolo<br/>State: Sulu<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2050, 'city', 1534, 'City created. <br/><br/>City Name: Kalingalan Caluang<br/>State: Sulu<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2051, 'city', 1535, 'City created. <br/><br/>City Name: Luuk<br/>State: Sulu<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2052, 'city', 1536, 'City created. <br/><br/>City Name: Maimbung<br/>State: Sulu<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2053, 'city', 1537, 'City created. <br/><br/>City Name: Hadji Panglima Tahil<br/>State: Sulu<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2054, 'city', 1538, 'City created. <br/><br/>City Name: Old Panamao<br/>State: Sulu<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2055, 'city', 1539, 'City created. <br/><br/>City Name: Pangutaran<br/>State: Sulu<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2056, 'city', 1540, 'City created. <br/><br/>City Name: Parang<br/>State: Sulu<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2057, 'city', 1541, 'City created. <br/><br/>City Name: Pata<br/>State: Sulu<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2058, 'city', 1542, 'City created. <br/><br/>City Name: Patikul<br/>State: Sulu<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2059, 'city', 1543, 'City created. <br/><br/>City Name: Siasi<br/>State: Sulu<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2060, 'city', 1544, 'City created. <br/><br/>City Name: Talipao<br/>State: Sulu<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2061, 'city', 1545, 'City created. <br/><br/>City Name: Tapul<br/>State: Sulu<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2062, 'city', 1546, 'City created. <br/><br/>City Name: Tongkil<br/>State: Sulu<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2063, 'city', 1547, 'City created. <br/><br/>City Name: Panglima Estino<br/>State: Sulu<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2064, 'city', 1548, 'City created. <br/><br/>City Name: Lugus<br/>State: Sulu<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2065, 'city', 1549, 'City created. <br/><br/>City Name: Pandami<br/>State: Sulu<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2066, 'city', 1550, 'City created. <br/><br/>City Name: Omar<br/>State: Sulu<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2067, 'city', 1551, 'City created. <br/><br/>City Name: Panglima Sugala<br/>State: Tawi-Tawi<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2068, 'city', 1552, 'City created. <br/><br/>City Name: Bongao (Capital)<br/>State: Tawi-Tawi<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2069, 'city', 1553, 'City created. <br/><br/>City Name: Mapun<br/>State: Tawi-Tawi<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2070, 'city', 1554, 'City created. <br/><br/>City Name: Simunul<br/>State: Tawi-Tawi<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2071, 'city', 1555, 'City created. <br/><br/>City Name: Sitangkai<br/>State: Tawi-Tawi<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2072, 'city', 1556, 'City created. <br/><br/>City Name: South Ubian<br/>State: Tawi-Tawi<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2073, 'city', 1557, 'City created. <br/><br/>City Name: Tandubas<br/>State: Tawi-Tawi<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2074, 'city', 1558, 'City created. <br/><br/>City Name: Turtle Islands<br/>State: Tawi-Tawi<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2075, 'city', 1559, 'City created. <br/><br/>City Name: Languyan<br/>State: Tawi-Tawi<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2076, 'city', 1560, 'City created. <br/><br/>City Name: Sapa-Sapa<br/>State: Tawi-Tawi<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2077, 'city', 1561, 'City created. <br/><br/>City Name: Sibutu<br/>State: Tawi-Tawi<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2078, 'city', 1562, 'City created. <br/><br/>City Name: Buenavista<br/>State: Agusan del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2079, 'city', 1563, 'City created. <br/><br/>City Name: City of Butuan<br/>State: Agusan del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2080, 'city', 1564, 'City created. <br/><br/>City Name: City of Cabadbaran<br/>State: Agusan del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2081, 'city', 1565, 'City created. <br/><br/>City Name: Carmen<br/>State: Agusan del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2082, 'city', 1566, 'City created. <br/><br/>City Name: Jabonga<br/>State: Agusan del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2083, 'city', 1567, 'City created. <br/><br/>City Name: Kitcharao<br/>State: Agusan del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2084, 'city', 1568, 'City created. <br/><br/>City Name: Las Nieves<br/>State: Agusan del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2085, 'city', 1569, 'City created. <br/><br/>City Name: Magallanes<br/>State: Agusan del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2086, 'city', 1570, 'City created. <br/><br/>City Name: Nasipit<br/>State: Agusan del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2087, 'city', 1571, 'City created. <br/><br/>City Name: Santiago<br/>State: Agusan del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2088, 'city', 1572, 'City created. <br/><br/>City Name: Tubay<br/>State: Agusan del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2089, 'city', 1573, 'City created. <br/><br/>City Name: Remedios T. Romualdez<br/>State: Agusan del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2090, 'city', 1574, 'City created. <br/><br/>City Name: City of Bayugan<br/>State: Agusan del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2091, 'city', 1575, 'City created. <br/><br/>City Name: Bunawan<br/>State: Agusan del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2092, 'city', 1576, 'City created. <br/><br/>City Name: Esperanza<br/>State: Agusan del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2093, 'city', 1577, 'City created. <br/><br/>City Name: La Paz<br/>State: Agusan del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2094, 'city', 1578, 'City created. <br/><br/>City Name: Loreto<br/>State: Agusan del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2095, 'city', 1579, 'City created. <br/><br/>City Name: Prosperidad<br/>State: Agusan del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2096, 'city', 1580, 'City created. <br/><br/>City Name: Rosario<br/>State: Agusan del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2097, 'city', 1581, 'City created. <br/><br/>City Name: San Francisco<br/>State: Agusan del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2098, 'city', 1582, 'City created. <br/><br/>City Name: San Luis<br/>State: Agusan del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2099, 'city', 1583, 'City created. <br/><br/>City Name: Santa Josefa<br/>State: Agusan del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2100, 'city', 1584, 'City created. <br/><br/>City Name: Talacogon<br/>State: Agusan del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2101, 'city', 1585, 'City created. <br/><br/>City Name: Trento<br/>State: Agusan del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2102, 'city', 1586, 'City created. <br/><br/>City Name: Veruela<br/>State: Agusan del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2103, 'city', 1587, 'City created. <br/><br/>City Name: Sibagat<br/>State: Agusan del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2104, 'city', 1588, 'City created. <br/><br/>City Name: Alegria<br/>State: Surigao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2105, 'city', 1589, 'City created. <br/><br/>City Name: Bacuag<br/>State: Surigao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2106, 'city', 1590, 'City created. <br/><br/>City Name: Burgos<br/>State: Surigao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2107, 'city', 1591, 'City created. <br/><br/>City Name: Claver<br/>State: Surigao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2108, 'city', 1592, 'City created. <br/><br/>City Name: Dapa<br/>State: Surigao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2109, 'city', 1593, 'City created. <br/><br/>City Name: Del Carmen<br/>State: Surigao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2110, 'city', 1594, 'City created. <br/><br/>City Name: General Luna<br/>State: Surigao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2111, 'city', 1595, 'City created. <br/><br/>City Name: Gigaquit<br/>State: Surigao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2112, 'city', 1596, 'City created. <br/><br/>City Name: Mainit<br/>State: Surigao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2113, 'city', 1597, 'City created. <br/><br/>City Name: Malimono<br/>State: Surigao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2114, 'city', 1598, 'City created. <br/><br/>City Name: Pilar<br/>State: Surigao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2115, 'city', 1599, 'City created. <br/><br/>City Name: Placer<br/>State: Surigao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2116, 'city', 1600, 'City created. <br/><br/>City Name: San Benito<br/>State: Surigao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2117, 'city', 1601, 'City created. <br/><br/>City Name: San Francisco<br/>State: Surigao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2118, 'city', 1602, 'City created. <br/><br/>City Name: San Isidro<br/>State: Surigao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2119, 'city', 1603, 'City created. <br/><br/>City Name: Santa Monica<br/>State: Surigao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2120, 'city', 1604, 'City created. <br/><br/>City Name: Sison<br/>State: Surigao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2121, 'city', 1605, 'City created. <br/><br/>City Name: Socorro<br/>State: Surigao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2122, 'city', 1606, 'City created. <br/><br/>City Name: City of Surigao<br/>State: Surigao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2123, 'city', 1607, 'City created. <br/><br/>City Name: Tagana-An<br/>State: Surigao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2124, 'city', 1608, 'City created. <br/><br/>City Name: Tubod<br/>State: Surigao del Norte<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2125, 'city', 1609, 'City created. <br/><br/>City Name: Barobo<br/>State: Surigao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2126, 'city', 1610, 'City created. <br/><br/>City Name: Bayabas<br/>State: Surigao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2127, 'city', 1611, 'City created. <br/><br/>City Name: City of Bislig<br/>State: Surigao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2128, 'city', 1612, 'City created. <br/><br/>City Name: Cagwait<br/>State: Surigao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2129, 'city', 1613, 'City created. <br/><br/>City Name: Cantilan<br/>State: Surigao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2130, 'city', 1614, 'City created. <br/><br/>City Name: Carmen<br/>State: Surigao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2131, 'city', 1615, 'City created. <br/><br/>City Name: Carrascal<br/>State: Surigao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2132, 'city', 1616, 'City created. <br/><br/>City Name: Cortes<br/>State: Surigao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2133, 'city', 1617, 'City created. <br/><br/>City Name: Hinatuan<br/>State: Surigao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2134, 'city', 1618, 'City created. <br/><br/>City Name: Lanuza<br/>State: Surigao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2135, 'city', 1619, 'City created. <br/><br/>City Name: Lianga<br/>State: Surigao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2136, 'city', 1620, 'City created. <br/><br/>City Name: Lingig<br/>State: Surigao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2137, 'city', 1621, 'City created. <br/><br/>City Name: Madrid<br/>State: Surigao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2138, 'city', 1622, 'City created. <br/><br/>City Name: Marihatag<br/>State: Surigao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2139, 'city', 1623, 'City created. <br/><br/>City Name: San Agustin<br/>State: Surigao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2140, 'city', 1624, 'City created. <br/><br/>City Name: San Miguel<br/>State: Surigao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2141, 'city', 1625, 'City created. <br/><br/>City Name: Tagbina<br/>State: Surigao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2142, 'city', 1626, 'City created. <br/><br/>City Name: Tago<br/>State: Surigao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2143, 'city', 1627, 'City created. <br/><br/>City Name: City of Tandag<br/>State: Surigao del Sur<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2144, 'city', 1628, 'City created. <br/><br/>City Name: Basilisa<br/>State: Dinagat Islands<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2145, 'city', 1629, 'City created. <br/><br/>City Name: Cagdianao<br/>State: Dinagat Islands<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2146, 'city', 1630, 'City created. <br/><br/>City Name: Dinagat<br/>State: Dinagat Islands<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2147, 'city', 1631, 'City created. <br/><br/>City Name: Libjo<br/>State: Dinagat Islands<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2148, 'city', 1632, 'City created. <br/><br/>City Name: Loreto<br/>State: Dinagat Islands<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2149, 'city', 1633, 'City created. <br/><br/>City Name: San Jose<br/>State: Dinagat Islands<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2150, 'city', 1634, 'City created. <br/><br/>City Name: Tubajon<br/>State: Dinagat Islands<br/>Country: Philippines', 1, '2024-06-26 15:48:18', '2024-06-26 15:48:18'),
(2151, 'file_extension', 1, 'File Extension created. <br/><br/>File Extension Name: AIF<br/>File Extension: aif<br/>File Type: Audio', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2152, 'file_extension', 2, 'File Extension created. <br/><br/>File Extension Name: CDA<br/>File Extension: cda<br/>File Type: Audio', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2153, 'file_extension', 3, 'File Extension created. <br/><br/>File Extension Name: MID<br/>File Extension: mid<br/>File Type: Audio', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2154, 'file_extension', 4, 'File Extension created. <br/><br/>File Extension Name: MIDI<br/>File Extension: midi<br/>File Type: Audio', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2155, 'file_extension', 5, 'File Extension created. <br/><br/>File Extension Name: MP3<br/>File Extension: mp3<br/>File Type: Audio', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2156, 'file_extension', 6, 'File Extension created. <br/><br/>File Extension Name: MPA<br/>File Extension: mpa<br/>File Type: Audio', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2157, 'file_extension', 7, 'File Extension created. <br/><br/>File Extension Name: OGG<br/>File Extension: ogg<br/>File Type: Audio', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2158, 'file_extension', 8, 'File Extension created. <br/><br/>File Extension Name: WAV<br/>File Extension: wav<br/>File Type: Audio', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2159, 'file_extension', 9, 'File Extension created. <br/><br/>File Extension Name: WMA<br/>File Extension: wma<br/>File Type: Audio', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36');
INSERT INTO `audit_log` (`audit_log_id`, `table_name`, `reference_id`, `log`, `changed_by`, `changed_at`, `created_date`) VALUES
(2160, 'file_extension', 10, 'File Extension created. <br/><br/>File Extension Name: WPL<br/>File Extension: wpl<br/>File Type: Audio', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2161, 'file_extension', 11, 'File Extension created. <br/><br/>File Extension Name: 7Z<br/>File Extension: 7z<br/>File Type: Compressed', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2162, 'file_extension', 12, 'File Extension created. <br/><br/>File Extension Name: ARJ<br/>File Extension: arj<br/>File Type: Compressed', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2163, 'file_extension', 13, 'File Extension created. <br/><br/>File Extension Name: DEB<br/>File Extension: deb<br/>File Type: Compressed', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2164, 'file_extension', 14, 'File Extension created. <br/><br/>File Extension Name: PKG<br/>File Extension: pkg<br/>File Type: Compressed', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2165, 'file_extension', 15, 'File Extension created. <br/><br/>File Extension Name: RAR<br/>File Extension: rar<br/>File Type: Compressed', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2166, 'file_extension', 16, 'File Extension created. <br/><br/>File Extension Name: RPM<br/>File Extension: rpm<br/>File Type: Compressed', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2167, 'file_extension', 17, 'File Extension created. <br/><br/>File Extension Name: TAR.GZ<br/>File Extension: tar.gz<br/>File Type: Compressed', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2168, 'file_extension', 18, 'File Extension created. <br/><br/>File Extension Name: Z<br/>File Extension: z<br/>File Type: Compressed', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2169, 'file_extension', 19, 'File Extension created. <br/><br/>File Extension Name: ZIP<br/>File Extension: zip<br/>File Type: Compressed', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2170, 'file_extension', 20, 'File Extension created. <br/><br/>File Extension Name: BIN<br/>File Extension: bin<br/>File Type: Disk and Media', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2171, 'file_extension', 21, 'File Extension created. <br/><br/>File Extension Name: DMG<br/>File Extension: dmg<br/>File Type: Disk and Media', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2172, 'file_extension', 22, 'File Extension created. <br/><br/>File Extension Name: ISO<br/>File Extension: iso<br/>File Type: Disk and Media', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2173, 'file_extension', 23, 'File Extension created. <br/><br/>File Extension Name: TOAST<br/>File Extension: toast<br/>File Type: Disk and Media', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2174, 'file_extension', 24, 'File Extension created. <br/><br/>File Extension Name: VCD<br/>File Extension: vcd<br/>File Type: Disk and Media', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2175, 'file_extension', 25, 'File Extension created. <br/><br/>File Extension Name: CSV<br/>File Extension: csv<br/>File Type: Data and Database', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2176, 'file_extension', 26, 'File Extension created. <br/><br/>File Extension Name: DAT<br/>File Extension: dat<br/>File Type: Data and Database', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2177, 'file_extension', 27, 'File Extension created. <br/><br/>File Extension Name: DB<br/>File Extension: db<br/>File Type: Data and Database', 1, '2024-06-26 16:21:36', '2024-06-26 16:21:36'),
(2178, 'file_extension', 28, 'File Extension created. <br/><br/>File Extension Name: DBF<br/>File Extension: dbf<br/>File Type: Data and Database', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2179, 'file_extension', 29, 'File Extension created. <br/><br/>File Extension Name: LOG<br/>File Extension: log<br/>File Type: Data and Database', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2180, 'file_extension', 30, 'File Extension created. <br/><br/>File Extension Name: MDB<br/>File Extension: mdb<br/>File Type: Data and Database', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2181, 'file_extension', 31, 'File Extension created. <br/><br/>File Extension Name: SAV<br/>File Extension: sav<br/>File Type: Data and Database', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2182, 'file_extension', 32, 'File Extension created. <br/><br/>File Extension Name: SQL<br/>File Extension: sql<br/>File Type: Data and Database', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2183, 'file_extension', 33, 'File Extension created. <br/><br/>File Extension Name: TAR<br/>File Extension: tar<br/>File Type: Data and Database', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2184, 'file_extension', 34, 'File Extension created. <br/><br/>File Extension Name: XML<br/>File Extension: xml<br/>File Type: Data and Database', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2185, 'file_extension', 35, 'File Extension created. <br/><br/>File Extension Name: EMAIL<br/>File Extension: email<br/>File Type: Email', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2186, 'file_extension', 36, 'File Extension created. <br/><br/>File Extension Name: EML<br/>File Extension: eml<br/>File Type: Email', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2187, 'file_extension', 37, 'File Extension created. <br/><br/>File Extension Name: EMLX<br/>File Extension: emlx<br/>File Type: Email', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2188, 'file_extension', 38, 'File Extension created. <br/><br/>File Extension Name: MSG<br/>File Extension: msg<br/>File Type: Email', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2189, 'file_extension', 39, 'File Extension created. <br/><br/>File Extension Name: OFT<br/>File Extension: oft<br/>File Type: Email', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2190, 'file_extension', 40, 'File Extension created. <br/><br/>File Extension Name: OST<br/>File Extension: ost<br/>File Type: Email', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2191, 'file_extension', 41, 'File Extension created. <br/><br/>File Extension Name: PST<br/>File Extension: pst<br/>File Type: Email', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2192, 'file_extension', 42, 'File Extension created. <br/><br/>File Extension Name: VCF<br/>File Extension: vcf<br/>File Type: Email', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2193, 'file_extension', 43, 'File Extension created. <br/><br/>File Extension Name: APK<br/>File Extension: apk<br/>File Type: Executable', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2194, 'file_extension', 44, 'File Extension created. <br/><br/>File Extension Name: BAT<br/>File Extension: bat<br/>File Type: Executable', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2195, 'file_extension', 45, 'File Extension created. <br/><br/>File Extension Name: BIN<br/>File Extension: bin<br/>File Type: Executable', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2196, 'file_extension', 46, 'File Extension created. <br/><br/>File Extension Name: CGI<br/>File Extension: cgi<br/>File Type: Executable', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2197, 'file_extension', 47, 'File Extension created. <br/><br/>File Extension Name: PL<br/>File Extension: pl<br/>File Type: Executable', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2198, 'file_extension', 48, 'File Extension created. <br/><br/>File Extension Name: COM<br/>File Extension: com<br/>File Type: Executable', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2199, 'file_extension', 49, 'File Extension created. <br/><br/>File Extension Name: EXE<br/>File Extension: exe<br/>File Type: Executable', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2200, 'file_extension', 50, 'File Extension created. <br/><br/>File Extension Name: GADGET<br/>File Extension: gadget<br/>File Type: Executable', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2201, 'file_extension', 51, 'File Extension created. <br/><br/>File Extension Name: JAR<br/>File Extension: jar<br/>File Type: Executable', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2202, 'file_extension', 52, 'File Extension created. <br/><br/>File Extension Name: WSF<br/>File Extension: wsf<br/>File Type: Executable', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2203, 'file_extension', 53, 'File Extension created. <br/><br/>File Extension Name: FNT<br/>File Extension: fnt<br/>File Type: Font', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2204, 'file_extension', 54, 'File Extension created. <br/><br/>File Extension Name: FON<br/>File Extension: fon<br/>File Type: Font', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2205, 'file_extension', 55, 'File Extension created. <br/><br/>File Extension Name: OTF<br/>File Extension: otf<br/>File Type: Font', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2206, 'file_extension', 56, 'File Extension created. <br/><br/>File Extension Name: TTF<br/>File Extension: ttf<br/>File Type: Font', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2207, 'file_extension', 57, 'File Extension created. <br/><br/>File Extension Name: AI<br/>File Extension: ai<br/>File Type: Image', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2208, 'file_extension', 58, 'File Extension created. <br/><br/>File Extension Name: BMP<br/>File Extension: bmp<br/>File Type: Image', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2209, 'file_extension', 59, 'File Extension created. <br/><br/>File Extension Name: GIF<br/>File Extension: gif<br/>File Type: Image', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2210, 'file_extension', 60, 'File Extension created. <br/><br/>File Extension Name: ICO<br/>File Extension: ico<br/>File Type: Image', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2211, 'file_extension', 61, 'File Extension created. <br/><br/>File Extension Name: JPG<br/>File Extension: jpg<br/>File Type: Image', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2212, 'file_extension', 62, 'File Extension created. <br/><br/>File Extension Name: JPEG<br/>File Extension: jpeg<br/>File Type: Image', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2213, 'file_extension', 63, 'File Extension created. <br/><br/>File Extension Name: PNG<br/>File Extension: png<br/>File Type: Image', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2214, 'file_extension', 64, 'File Extension created. <br/><br/>File Extension Name: PS<br/>File Extension: ps<br/>File Type: Image', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2215, 'file_extension', 65, 'File Extension created. <br/><br/>File Extension Name: PSD<br/>File Extension: psd<br/>File Type: Image', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2216, 'file_extension', 66, 'File Extension created. <br/><br/>File Extension Name: SVG<br/>File Extension: svg<br/>File Type: Image', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2217, 'file_extension', 67, 'File Extension created. <br/><br/>File Extension Name: TIF<br/>File Extension: tif<br/>File Type: Image', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2218, 'file_extension', 68, 'File Extension created. <br/><br/>File Extension Name: TIFF<br/>File Extension: tiff<br/>File Type: Image', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2219, 'file_extension', 69, 'File Extension created. <br/><br/>File Extension Name: WEBP<br/>File Extension: webp<br/>File Type: Image', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2220, 'file_extension', 70, 'File Extension created. <br/><br/>File Extension Name: ASP<br/>File Extension: asp<br/>File Type: Internet Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2221, 'file_extension', 71, 'File Extension created. <br/><br/>File Extension Name: ASPX<br/>File Extension: aspx<br/>File Type: Internet Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2222, 'file_extension', 72, 'File Extension created. <br/><br/>File Extension Name: CER<br/>File Extension: cer<br/>File Type: Internet Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2223, 'file_extension', 73, 'File Extension created. <br/><br/>File Extension Name: CFM<br/>File Extension: cfm<br/>File Type: Internet Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2224, 'file_extension', 74, 'File Extension created. <br/><br/>File Extension Name: CGI<br/>File Extension: cgi<br/>File Type: Internet Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2225, 'file_extension', 75, 'File Extension created. <br/><br/>File Extension Name: PL<br/>File Extension: pl<br/>File Type: Internet Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2226, 'file_extension', 76, 'File Extension created. <br/><br/>File Extension Name: CSS<br/>File Extension: css<br/>File Type: Internet Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2227, 'file_extension', 77, 'File Extension created. <br/><br/>File Extension Name: HTM<br/>File Extension: htm<br/>File Type: Internet Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2228, 'file_extension', 78, 'File Extension created. <br/><br/>File Extension Name: HTML<br/>File Extension: html<br/>File Type: Internet Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2229, 'file_extension', 79, 'File Extension created. <br/><br/>File Extension Name: JS<br/>File Extension: js<br/>File Type: Internet Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2230, 'file_extension', 80, 'File Extension created. <br/><br/>File Extension Name: JSP<br/>File Extension: jsp<br/>File Type: Internet Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2231, 'file_extension', 81, 'File Extension created. <br/><br/>File Extension Name: PART<br/>File Extension: part<br/>File Type: Internet Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2232, 'file_extension', 82, 'File Extension created. <br/><br/>File Extension Name: PHP<br/>File Extension: php<br/>File Type: Internet Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2233, 'file_extension', 83, 'File Extension created. <br/><br/>File Extension Name: PY<br/>File Extension: py<br/>File Type: Internet Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2234, 'file_extension', 84, 'File Extension created. <br/><br/>File Extension Name: RSS<br/>File Extension: rss<br/>File Type: Internet Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2235, 'file_extension', 85, 'File Extension created. <br/><br/>File Extension Name: XHTML<br/>File Extension: xhtml<br/>File Type: Internet Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2236, 'file_extension', 86, 'File Extension created. <br/><br/>File Extension Name: KEY<br/>File Extension: key<br/>File Type: Presentation', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2237, 'file_extension', 87, 'File Extension created. <br/><br/>File Extension Name: ODP<br/>File Extension: odp<br/>File Type: Presentation', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2238, 'file_extension', 88, 'File Extension created. <br/><br/>File Extension Name: PPS<br/>File Extension: pps<br/>File Type: Presentation', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2239, 'file_extension', 89, 'File Extension created. <br/><br/>File Extension Name: PPT<br/>File Extension: ppt<br/>File Type: Presentation', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2240, 'file_extension', 90, 'File Extension created. <br/><br/>File Extension Name: PPTX<br/>File Extension: pptx<br/>File Type: Presentation', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2241, 'file_extension', 91, 'File Extension created. <br/><br/>File Extension Name: ODS<br/>File Extension: ods<br/>File Type: Spreadsheet', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2242, 'file_extension', 92, 'File Extension created. <br/><br/>File Extension Name: XLS<br/>File Extension: xls<br/>File Type: Spreadsheet', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2243, 'file_extension', 93, 'File Extension created. <br/><br/>File Extension Name: XLSM<br/>File Extension: xlsm<br/>File Type: Spreadsheet', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2244, 'file_extension', 94, 'File Extension created. <br/><br/>File Extension Name: XLSX<br/>File Extension: xlsx<br/>File Type: Spreadsheet', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2245, 'file_extension', 95, 'File Extension created. <br/><br/>File Extension Name: BAK<br/>File Extension: bak<br/>File Type: System Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2246, 'file_extension', 96, 'File Extension created. <br/><br/>File Extension Name: CAB<br/>File Extension: cab<br/>File Type: System Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2247, 'file_extension', 97, 'File Extension created. <br/><br/>File Extension Name: CFG<br/>File Extension: cfg<br/>File Type: System Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2248, 'file_extension', 98, 'File Extension created. <br/><br/>File Extension Name: CPL<br/>File Extension: cpl<br/>File Type: System Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2249, 'file_extension', 99, 'File Extension created. <br/><br/>File Extension Name: CUR<br/>File Extension: cur<br/>File Type: System Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2250, 'file_extension', 100, 'File Extension created. <br/><br/>File Extension Name: DLL<br/>File Extension: dll<br/>File Type: System Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2251, 'file_extension', 101, 'File Extension created. <br/><br/>File Extension Name: DMP<br/>File Extension: dmp<br/>File Type: System Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2252, 'file_extension', 102, 'File Extension created. <br/><br/>File Extension Name: DRV<br/>File Extension: drv<br/>File Type: System Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2253, 'file_extension', 103, 'File Extension created. <br/><br/>File Extension Name: ICNS<br/>File Extension: icns<br/>File Type: System Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2254, 'file_extension', 104, 'File Extension created. <br/><br/>File Extension Name: INI<br/>File Extension: ini<br/>File Type: System Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2255, 'file_extension', 105, 'File Extension created. <br/><br/>File Extension Name: LNK<br/>File Extension: lnk<br/>File Type: System Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2256, 'file_extension', 106, 'File Extension created. <br/><br/>File Extension Name: MSI<br/>File Extension: msi<br/>File Type: System Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2257, 'file_extension', 107, 'File Extension created. <br/><br/>File Extension Name: SYS<br/>File Extension: sys<br/>File Type: System Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2258, 'file_extension', 108, 'File Extension created. <br/><br/>File Extension Name: TMP<br/>File Extension: tmp<br/>File Type: System Related', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2259, 'file_extension', 109, 'File Extension created. <br/><br/>File Extension Name: 3G2<br/>File Extension: 3g2<br/>File Type: Video', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2260, 'file_extension', 110, 'File Extension created. <br/><br/>File Extension Name: 3GP<br/>File Extension: 3gp<br/>File Type: Video', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2261, 'file_extension', 111, 'File Extension created. <br/><br/>File Extension Name: AVI<br/>File Extension: avi<br/>File Type: Video', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2262, 'file_extension', 112, 'File Extension created. <br/><br/>File Extension Name: FLV<br/>File Extension: flv<br/>File Type: Video', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2263, 'file_extension', 113, 'File Extension created. <br/><br/>File Extension Name: H264<br/>File Extension: h264<br/>File Type: Video', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2264, 'file_extension', 114, 'File Extension created. <br/><br/>File Extension Name: M4V<br/>File Extension: m4v<br/>File Type: Video', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2265, 'file_extension', 115, 'File Extension created. <br/><br/>File Extension Name: MKV<br/>File Extension: mkv<br/>File Type: Video', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2266, 'file_extension', 116, 'File Extension created. <br/><br/>File Extension Name: MOV<br/>File Extension: mov<br/>File Type: Video', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2267, 'file_extension', 117, 'File Extension created. <br/><br/>File Extension Name: MP4<br/>File Extension: mp4<br/>File Type: Video', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2268, 'file_extension', 118, 'File Extension created. <br/><br/>File Extension Name: MPG<br/>File Extension: mpg<br/>File Type: Video', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2269, 'file_extension', 119, 'File Extension created. <br/><br/>File Extension Name: MPEG<br/>File Extension: mpeg<br/>File Type: Video', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2270, 'file_extension', 120, 'File Extension created. <br/><br/>File Extension Name: RM<br/>File Extension: rm<br/>File Type: Video', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2271, 'file_extension', 121, 'File Extension created. <br/><br/>File Extension Name: SWF<br/>File Extension: swf<br/>File Type: Video', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2272, 'file_extension', 122, 'File Extension created. <br/><br/>File Extension Name: VOB<br/>File Extension: vob<br/>File Type: Video', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2273, 'file_extension', 123, 'File Extension created. <br/><br/>File Extension Name: WEBM<br/>File Extension: webm<br/>File Type: Video', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2274, 'file_extension', 124, 'File Extension created. <br/><br/>File Extension Name: WMV<br/>File Extension: wmv<br/>File Type: Video', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2275, 'file_extension', 125, 'File Extension created. <br/><br/>File Extension Name: DOC<br/>File Extension: doc<br/>File Type: Word Processor', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2276, 'file_extension', 126, 'File Extension created. <br/><br/>File Extension Name: DOCX<br/>File Extension: docx<br/>File Type: Word Processor', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2277, 'file_extension', 127, 'File Extension created. <br/><br/>File Extension Name: PDF<br/>File Extension: pdf<br/>File Type: Word Processor', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2278, 'file_extension', 128, 'File Extension created. <br/><br/>File Extension Name: RTF<br/>File Extension: rtf<br/>File Type: Word Processor', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2279, 'file_extension', 129, 'File Extension created. <br/><br/>File Extension Name: TEX<br/>File Extension: tex<br/>File Type: Word Processor', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2280, 'file_extension', 130, 'File Extension created. <br/><br/>File Extension Name: TXT<br/>File Extension: txt<br/>File Type: Word Processor', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2281, 'file_extension', 131, 'File Extension created. <br/><br/>File Extension Name: WPD<br/>File Extension: wpd<br/>File Type: Word Processor', 1, '2024-06-26 16:21:37', '2024-06-26 16:21:37'),
(2282, 'upload_setting', 1, 'Upload Setting created. <br/><br/>Upload Setting Name: App Logo<br/>Upload Setting Description: Sets the upload setting when uploading app logo.<br/>Max File Size: 800', 1, '2024-06-26 16:34:32', '2024-06-26 16:34:32'),
(2283, 'upload_setting', 2, 'Upload Setting created. <br/><br/>Upload Setting Name: Internal Notes Attachment<br/>Upload Setting Description: Sets the upload setting when uploading internal notes attachement.<br/>Max File Size: 800', 1, '2024-06-26 16:34:32', '2024-06-26 16:34:32'),
(2284, 'email_setting', 1, 'Email Setting created. <br/><br/>Email Setting Name: Security Email Setting<br/>Email Setting Description: \r\nEmail setting for security emails.<br/>Host: smtp.hostinger.com<br/>Port: 465<br/>SMTP Authentication: 1<br/>Mail Username: cgmi-noreply@christianmotors.ph<br/>Mail Encryption: ssl<br/>Mail From Name: cgmi-noreply@christianmotors.ph<br/>Mail From Email: cgmi-noreply@christianmotors.ph', 1, '2024-06-26 16:43:58', '2024-06-26 16:43:58'),
(2285, 'user_account', 2, 'Last Connection Date: 2024-06-26 16:55:07 -> 2024-06-26 19:13:10<br/>', 1, '2024-06-26 19:13:10', '2024-06-26 19:13:10'),
(2286, 'user_account', 2, 'Failed Login Attempts: 0 -> 1<br/>', 1, '2024-06-26 21:31:18', '2024-06-26 21:31:18'),
(2287, 'user_account', 2, 'Last Failed Login Attempt: 2024-06-26 21:31:18 -> 2024-06-26 21:33:02<br/>Failed Login Attempts: 1 -> 2<br/>', 1, '2024-06-26 21:33:02', '2024-06-26 21:33:02'),
(2288, 'user_account', 2, 'Failed Login Attempts: 2 -> 0<br/>', 1, '2024-06-26 21:33:07', '2024-06-26 21:33:07'),
(2289, 'user_account', 2, 'Last Connection Date: 2024-06-26 19:13:10 -> 2024-06-26 21:33:07<br/>', 1, '2024-06-26 21:33:07', '2024-06-26 21:33:07'),
(2290, 'user_account', 2, 'Last Connection Date: 2024-06-26 21:33:07 -> 2024-06-26 21:39:45<br/>', 1, '2024-06-26 21:39:45', '2024-06-26 21:39:45'),
(2291, 'user_account', 2, 'Last Connection Date: 2024-06-26 21:39:45 -> 2024-06-26 21:57:37<br/>', 1, '2024-06-26 21:57:37', '2024-06-26 21:57:37'),
(2292, 'menu_group', 4, 'Menu group created. <br/><br/>Menu Group Name: Profile<br/>App Module: Settings<br/>Order Sequence: 1', 2, '2024-06-27 14:49:24', '2024-06-27 14:49:24'),
(2293, 'menu_group', 2, 'Order Sequence: 1 -> 5<br/>', 2, '2024-06-27 14:49:35', '2024-06-27 14:49:35'),
(2294, 'menu_item', 22, 'Menu Item created. <br/><br/>Menu Item Name: Account Setting<br/>Menu Item URL: account-setting.php<br/>Menu Item Icon: ti ti-tool<br/>Menu Group Name: Profile<br/>App Module: Settings<br/>Order Sequence: 1', 2, '2024-06-27 14:52:08', '2024-06-27 14:52:08'),
(2295, 'role_permission', 23, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Account Setting<br/>Date Assigned: 2024-06-27 14:52:13', 2, '2024-06-27 14:52:13', '2024-06-27 14:52:13'),
(2296, 'role_permission', 23, 'Read Access: 0 -> 1<br/>', 2, '2024-06-27 14:52:15', '2024-06-27 14:52:15'),
(2297, 'role_permission', 23, 'Write Access: 0 -> 1<br/>', 2, '2024-06-27 14:52:16', '2024-06-27 14:52:16'),
(2298, 'menu_item', 6, 'Menu Item Icon: ti ti-hierarchy-2 -> ti ti-sitemap<br/>', 2, '2024-06-27 14:52:49', '2024-06-27 14:52:49'),
(2299, 'notification_setting', 1, 'Notification Setting created. <br/><br/>Notification Setting Name: Login OTP<br/>Notification Setting Description: Notification setting for Login OTP received by the users.<br/>System Notification: 1', 2, '2024-06-27 14:59:41', '2024-06-27 14:59:41'),
(2300, 'notification_setting', 1, 'Email Notification: 0 -> 1<br/>', 2, '2024-06-27 14:59:46', '2024-06-27 14:59:46'),
(2301, 'notification_setting', 1, 'System Notification: 1 -> 0<br/>', 2, '2024-06-27 14:59:46', '2024-06-27 14:59:46'),
(2302, 'notification_setting_email_template', 1, 'Email Notification Template created. <br/><br/>Email Notification Subject: Login OTP - Secure Access to Your Account<br/>Email Notification Body: <p>To ensure the security of your account, we have generated a unique One-Time Password (OTP) for you to use during the login process. Please use the following OTP to access your account:</p>\n<p><br>OTP:&nbsp;<strong>{OTP_CODE}</strong></p>\n<p><br>Please note that this OTP is valid for &nbsp;<strong>#{OTP_CODE_VALIDITY}</strong>. Once you have logged in successfully, we recommend enabling two-factor authentication for an added layer of security.<br>If you did not initiate this login or believe it was sent to you in error, please disregard this email and delete it immediately. Your account\'s security remains our utmost priority.</p>\n<p>Note: This is an automatically generated email. Please do not reply to this address.</p>', 2, '2024-06-27 15:02:58', '2024-06-27 15:02:58'),
(2303, 'notification_setting', 2, 'Notification Setting created. <br/><br/>Notification Setting Name: Forgot Password<br/>Notification Setting Description: Notification setting when the user initiates forgot password.<br/>System Notification: 1', 2, '2024-06-27 15:03:26', '2024-06-27 15:03:26'),
(2304, 'notification_setting', 2, 'Email Notification: 0 -> 1<br/>', 2, '2024-06-27 15:03:28', '2024-06-27 15:03:28'),
(2305, 'notification_setting', 2, 'System Notification: 1 -> 0<br/>', 2, '2024-06-27 15:03:29', '2024-06-27 15:03:29'),
(2306, 'notification_setting_email_template', 2, 'Email Notification Template created. <br/><br/>Email Notification Subject: Password Reset Request - Action Required<br/>Email Notification Body: <p>We received a request to reset your password. To proceed with the password reset, please follow the steps below:</p>\n<ol>\n<li>\n<p>Click on the following link to reset your password:&nbsp; <strong><a href=\"#{RESET_LINK}\">Password Reset Link</a></strong></p>\n</li>\n<li>\n<p>If you did not request this password reset, please ignore this email. Your account remains secure.</p>\n</li>\n</ol>\n<p>Please note that this link is time-sensitive and will expire after <strong>#{RESET_LINK_VALIDITY}</strong>. If you do not reset your password within this timeframe, you may need to request another password reset.</p>\n<p><br>If you did not initiate this password reset request or believe it was sent to you in error, please disregard this email and delete it immediately. Your account\'s security remains our utmost priority.<br><br>Note: This is an automatically generated email. Please do not reply to this address.</p>', 2, '2024-06-27 15:13:04', '2024-06-27 15:13:04'),
(2307, 'menu_group', 5, 'Menu group created. <br/><br/>Menu Group Name: Inventory Dashboard<br/>App Module: Settings<br/>Order Sequence: 1', 2, '2024-06-27 15:29:15', '2024-06-27 15:29:15'),
(2308, 'menu_item', 23, 'Menu Item created. <br/><br/>Menu Item Name: Inventory Overview<br/>Menu Item URL: inventory-overview.php<br/>Menu Item Icon: ti ti-home<br/>Menu Group Name: Inventory Dashboard<br/>App Module: Settings<br/>Order Sequence: 1', 2, '2024-06-27 15:30:10', '2024-06-27 15:30:10'),
(2309, 'app_module', 2, 'App module created. <br/><br/>App Module Name: Inventory<br/>App Module Description: Manage your stock and logistics activities<br/>App Version: 1.0.0<br/>Menu Item Name: Inventory Overview<br/>Order Sequence: 1', 2, '2024-06-27 15:30:44', '2024-06-27 15:30:44'),
(2310, 'menu_group', 5, 'App Module: Settings -> Inventory<br/>', 2, '2024-06-27 15:31:23', '2024-06-27 15:31:23'),
(2311, 'role_permission', 24, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Inventory Overview<br/>Date Assigned: 2024-06-27 15:31:42', 2, '2024-06-27 15:31:42', '2024-06-27 15:31:42'),
(2312, 'role_permission', 24, 'Read Access: 0 -> 1<br/>', 2, '2024-06-27 15:31:43', '2024-06-27 15:31:43'),
(2313, 'menu_item', 23, 'App Module: Settings -> Inventory<br/>', 2, '2024-06-27 15:32:11', '2024-06-27 15:32:11'),
(2314, 'app_module', 1, 'Menu Item Name: General Settings -> Account Setting<br/>', 2, '2024-06-27 16:05:57', '2024-06-27 16:05:57'),
(2315, 'menu_group', 6, 'Menu group created. <br/><br/>Menu Group Name: Warehouse Management<br/>App Module: Inventory<br/>Order Sequence: 23', 2, '2024-06-27 17:17:10', '2024-06-27 17:17:10'),
(2316, 'menu_item', 24, 'Menu Item created. <br/><br/>Menu Item Name: Warehouses<br/>Menu Item URL: warehouses.php<br/>Menu Item Icon: ti ti-building-warehouse<br/>Menu Group Name: Warehouse Management<br/>App Module: Inventory<br/>Order Sequence: 23', 2, '2024-06-27 17:18:42', '2024-06-27 17:18:42'),
(2317, 'role_permission', 25, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Warehouses<br/>Date Assigned: 2024-06-27 17:18:46', 2, '2024-06-27 17:18:46', '2024-06-27 17:18:46'),
(2318, 'role_permission', 25, 'Read Access: 0 -> 1<br/>', 2, '2024-06-27 17:18:47', '2024-06-27 17:18:47'),
(2319, 'role_permission', 25, 'Create Access: 0 -> 1<br/>', 2, '2024-06-27 17:18:48', '2024-06-27 17:18:48'),
(2320, 'role_permission', 25, 'Write Access: 0 -> 1<br/>', 2, '2024-06-27 17:18:48', '2024-06-27 17:18:48'),
(2321, 'role_permission', 25, 'Delete Access: 0 -> 1<br/>', 2, '2024-06-27 17:18:49', '2024-06-27 17:18:49'),
(2322, 'menu_group', 5, 'App Module: Inventory -> Centralize employee information<br/>', 2, '2024-06-28 08:47:30', '2024-06-28 08:47:30'),
(2323, 'menu_group', 6, 'App Module: Inventory -> Centralize employee information<br/>', 2, '2024-06-28 08:47:30', '2024-06-28 08:47:30'),
(2324, 'menu_item', 23, 'App Module: Inventory -> Centralize employee information<br/>', 2, '2024-06-28 08:47:30', '2024-06-28 08:47:30'),
(2325, 'menu_item', 24, 'App Module: Inventory -> Centralize employee information<br/>', 2, '2024-06-28 08:47:30', '2024-06-28 08:47:30'),
(2326, 'app_module', 2, 'App Module Name: Inventory -> Centralize employee information<br/>', 2, '2024-06-28 08:47:30', '2024-06-28 08:47:30'),
(2327, 'menu_group', 5, 'App Module: Centralize employee information -> Employees<br/>', 2, '2024-06-28 09:06:55', '2024-06-28 09:06:55'),
(2328, 'menu_group', 6, 'App Module: Centralize employee information -> Employees<br/>', 2, '2024-06-28 09:06:55', '2024-06-28 09:06:55'),
(2329, 'menu_item', 23, 'App Module: Centralize employee information -> Employees<br/>', 2, '2024-06-28 09:06:55', '2024-06-28 09:06:55'),
(2330, 'menu_item', 24, 'App Module: Centralize employee information -> Employees<br/>', 2, '2024-06-28 09:06:55', '2024-06-28 09:06:55'),
(2331, 'app_module', 2, 'App Module Name: Centralize employee information -> Employees<br/>App Module Description: Manage your stock and logistics activities -> Centralize employee information<br/>', 2, '2024-06-28 09:06:55', '2024-06-28 09:06:55'),
(2332, 'menu_item', 24, 'Menu Group Name: Warehouse Management -> Employee Configuration<br/>', 2, '2024-06-28 09:25:39', '2024-06-28 09:25:39'),
(2333, 'menu_group', 6, 'Menu Group Name: Warehouse Management -> Employee Configuration<br/>', 2, '2024-06-28 09:25:39', '2024-06-28 09:25:39'),
(2334, 'menu_item', 23, 'Menu Group Name: Inventory Dashboard -> Employees<br/>', 2, '2024-06-28 09:27:34', '2024-06-28 09:27:34'),
(2335, 'menu_group', 5, 'Menu Group Name: Inventory Dashboard -> Employees<br/>', 2, '2024-06-28 09:27:34', '2024-06-28 09:27:34'),
(2336, 'role_permission', 24, 'Menu Item: Inventory Overview -> Employees<br/>', 2, '2024-06-28 09:38:13', '2024-06-28 09:38:13'),
(2337, 'menu_item', 23, 'Menu Item Name: Inventory Overview -> Employees<br/>Menu Item URL: inventory-overview.php -> employees.php<br/>Menu Item Icon: ti ti-home -> ti ti-users<br/>', 2, '2024-06-28 09:38:13', '2024-06-28 09:38:13'),
(2338, 'role_permission', 24, 'Create Access: 0 -> 1<br/>', 2, '2024-06-28 09:38:27', '2024-06-28 09:38:27'),
(2339, 'role_permission', 24, 'Write Access: 0 -> 1<br/>', 2, '2024-06-28 09:38:28', '2024-06-28 09:38:28'),
(2340, 'role_permission', 24, 'Delete Access: 0 -> 1<br/>', 2, '2024-06-28 09:38:28', '2024-06-28 09:38:28'),
(2341, 'role_permission', 25, 'Menu Item: Warehouses -> Department<br/>', 2, '2024-06-28 09:48:35', '2024-06-28 09:48:35'),
(2342, 'menu_item', 24, 'Menu Item Name: Warehouses -> Department<br/>Menu Item URL: warehouses.php -> department.php<br/>Menu Item Icon: ti ti-building-warehouse -> ti ti-hierarchy-2<br/>Order Sequence: 23 -> 4<br/>', 2, '2024-06-28 09:48:35', '2024-06-28 09:48:35'),
(2343, 'menu_item', 25, 'Menu Item created. <br/><br/>Menu Item Name: Work Location<br/>Menu Item URL: work-location.php<br/>Menu Item Icon: ti ti-map-pin<br/>Menu Group Name: Employee Configuration<br/>App Module: Employees<br/>Order Sequence: 23', 2, '2024-06-28 10:38:12', '2024-06-28 10:38:12'),
(2344, 'role_permission', 26, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Work Location<br/>Date Assigned: 2024-06-28 10:38:17', 2, '2024-06-28 10:38:17', '2024-06-28 10:38:17'),
(2345, 'role_permission', 26, 'Read Access: 0 -> 1<br/>', 2, '2024-06-28 10:38:18', '2024-06-28 10:38:18'),
(2346, 'role_permission', 26, 'Create Access: 0 -> 1<br/>', 2, '2024-06-28 10:38:19', '2024-06-28 10:38:19'),
(2347, 'role_permission', 26, 'Write Access: 0 -> 1<br/>', 2, '2024-06-28 10:38:20', '2024-06-28 10:38:20'),
(2348, 'role_permission', 26, 'Delete Access: 0 -> 1<br/>', 2, '2024-06-28 10:38:21', '2024-06-28 10:38:21'),
(2349, 'menu_item', 26, 'Menu Item created. <br/><br/>Menu Item Name: Work Schedules<br/>Menu Item URL: work-schedules.php<br/>Menu Item Icon: ti ti-calendar-stats<br/>Menu Group Name: Employee Configuration<br/>App Module: Employees<br/>Order Sequence: 24', 2, '2024-06-28 10:43:21', '2024-06-28 10:43:21'),
(2350, 'role_permission', 27, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Work Schedules<br/>Date Assigned: 2024-06-28 10:43:25', 2, '2024-06-28 10:43:25', '2024-06-28 10:43:25'),
(2351, 'role_permission', 27, 'Read Access: 0 -> 1<br/>', 2, '2024-06-28 10:43:26', '2024-06-28 10:43:26'),
(2352, 'role_permission', 27, 'Create Access: 0 -> 1<br/>', 2, '2024-06-28 10:43:27', '2024-06-28 10:43:27'),
(2353, 'role_permission', 27, 'Write Access: 0 -> 1<br/>', 2, '2024-06-28 10:43:27', '2024-06-28 10:43:27'),
(2354, 'role_permission', 27, 'Delete Access: 0 -> 1<br/>', 2, '2024-06-28 10:43:28', '2024-06-28 10:43:28'),
(2355, 'menu_item', 27, 'Menu Item created. <br/><br/>Menu Item Name: Employment Types<br/>Menu Item URL: employment-types.php<br/>Menu Item Icon: ti ti-briefcase<br/>Menu Group Name: Employee Configuration<br/>App Module: Employees<br/>Order Sequence: 5', 2, '2024-06-28 10:45:01', '2024-06-28 10:45:01'),
(2356, 'role_permission', 28, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Employment Types<br/>Date Assigned: 2024-06-28 10:45:05', 2, '2024-06-28 10:45:05', '2024-06-28 10:45:05'),
(2357, 'role_permission', 28, 'Read Access: 0 -> 1<br/>', 2, '2024-06-28 10:45:06', '2024-06-28 10:45:06'),
(2358, 'role_permission', 28, 'Create Access: 0 -> 1<br/>', 2, '2024-06-28 10:45:07', '2024-06-28 10:45:07'),
(2359, 'role_permission', 28, 'Write Access: 0 -> 1<br/>', 2, '2024-06-28 10:45:10', '2024-06-28 10:45:10'),
(2360, 'role_permission', 28, 'Delete Access: 0 -> 1<br/>', 2, '2024-06-28 10:45:10', '2024-06-28 10:45:10'),
(2361, 'menu_item', 28, 'Menu Item created. <br/><br/>Menu Item Name: Departure Reasons<br/>Menu Item URL: departure-reasons.php<br/>Menu Item Icon: ti ti-user-minus<br/>Menu Group Name: Employee Configuration<br/>App Module: Employees<br/>Order Sequence: 5', 2, '2024-06-28 10:46:48', '2024-06-28 10:46:48'),
(2362, 'role_permission', 29, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Departure Reasons<br/>Date Assigned: 2024-06-28 10:50:01', 2, '2024-06-28 10:50:01', '2024-06-28 10:50:01'),
(2363, 'role_permission', 29, 'Read Access: 0 -> 1<br/>', 2, '2024-06-28 10:50:03', '2024-06-28 10:50:03'),
(2364, 'role_permission', 29, 'Create Access: 0 -> 1<br/>', 2, '2024-06-28 10:50:04', '2024-06-28 10:50:04'),
(2365, 'role_permission', 29, 'Write Access: 0 -> 1<br/>', 2, '2024-06-28 10:50:05', '2024-06-28 10:50:05'),
(2366, 'role_permission', 29, 'Delete Access: 0 -> 1<br/>', 2, '2024-06-28 10:50:05', '2024-06-28 10:50:05'),
(2367, 'menu_item', 29, 'Menu Item created. <br/><br/>Menu Item Name: Job Positions<br/>Menu Item URL: job-positions.php<br/>Menu Item Icon: ti ti-id<br/>Menu Group Name: Employee Configuration<br/>App Module: Employees<br/>Order Sequence: 10', 2, '2024-06-28 10:56:17', '2024-06-28 10:56:17'),
(2368, 'role_permission', 30, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Job Positions<br/>Date Assigned: 2024-06-28 10:56:21', 2, '2024-06-28 10:56:21', '2024-06-28 10:56:21'),
(2369, 'role_permission', 30, 'Read Access: 0 -> 1<br/>', 2, '2024-06-28 10:56:22', '2024-06-28 10:56:22'),
(2370, 'role_permission', 30, 'Create Access: 0 -> 1<br/>', 2, '2024-06-28 10:56:22', '2024-06-28 10:56:22'),
(2371, 'role_permission', 30, 'Write Access: 0 -> 1<br/>', 2, '2024-06-28 10:56:23', '2024-06-28 10:56:23'),
(2372, 'role_permission', 30, 'Delete Access: 0 -> 1<br/>', 2, '2024-06-28 10:56:24', '2024-06-28 10:56:24'),
(2373, 'role_permission', 25, 'Menu Item: Department -> Departments<br/>', 2, '2024-06-28 10:56:57', '2024-06-28 10:56:57'),
(2374, 'menu_item', 24, 'Menu Item Name: Department -> Departments<br/>Menu Item URL: department.php -> departments.php<br/>', 2, '2024-06-28 10:56:57', '2024-06-28 10:56:57'),
(2375, 'role_permission', 26, 'Menu Item: Work Location -> Work Locations<br/>', 2, '2024-06-28 10:57:09', '2024-06-28 10:57:09'),
(2376, 'menu_item', 25, 'Menu Item Name: Work Location -> Work Locations<br/>Menu Item URL: work-location.php -> work-locations.php<br/>', 2, '2024-06-28 10:57:09', '2024-06-28 10:57:09'),
(2377, 'departure_reasons', 1, 'Departure Reason Name: Settings -> Settingsss<br/>', 2, '2024-06-28 14:03:50', '2024-06-28 14:03:50'),
(2378, 'departure_reasons', 2, 'Departure reason created. <br/><br/>Departure Reason Name: test', 2, '2024-06-28 14:04:42', '2024-06-28 14:04:42'),
(2379, 'departure_reasons', 3, 'Departure reason created. <br/><br/>Departure Reason Name: test2', 2, '2024-06-28 14:05:03', '2024-06-28 14:05:03'),
(2380, 'employment_types', 1, 'Employment type created. <br/><br/>Employment Type Name: test', 2, '2024-06-28 15:57:35', '2024-06-28 15:57:35'),
(2381, 'employment_types', 1, 'Employment Type Name: test -> testasd<br/>', 2, '2024-06-28 15:58:36', '2024-06-28 15:58:36'),
(2382, 'employment_types', 1, 'Employment Type Name: testasd -> testasdasd<br/>', 2, '2024-06-28 15:58:38', '2024-06-28 15:58:38'),
(2383, 'employment_types', 2, 'Employment type created. <br/><br/>Employment Type Name: asdasd', 2, '2024-06-28 15:58:46', '2024-06-28 15:58:46'),
(2384, 'employment_types', 3, 'Employment type created. <br/><br/>Employment Type Name: asd', 2, '2024-06-28 15:58:49', '2024-06-28 15:58:49'),
(2385, 'employment_types', 4, 'Employment type created. <br/><br/>Employment Type Name: test', 2, '2024-06-28 16:07:15', '2024-06-28 16:07:15'),
(2386, 'user_account', 2, 'Failed Login Attempts: 0 -> 1<br/>', 1, '2024-06-29 16:55:54', '2024-06-29 16:55:54'),
(2387, 'user_account', 2, 'Failed Login Attempts: 1 -> 0<br/>', 1, '2024-06-29 16:55:59', '2024-06-29 16:55:59'),
(2388, 'user_account', 2, 'Last Connection Date: 2024-06-26 21:57:37 -> 2024-06-29 16:55:59<br/>', 1, '2024-06-29 16:55:59', '2024-06-29 16:55:59'),
(2389, 'work_locations', 1, 'Work locations created. <br/><br/>Work Locations Name: test<br/>Address: test<br/>City: Aborlan<br/>State: Palawan<br/>Country: Philippines<br/>Phone: asd', 2, '2024-06-29 17:22:40', '2024-06-29 17:22:40'),
(2390, 'work_locations', 2, 'Work locations created. <br/><br/>Work Locations Name: test<br/>Address: test<br/>City: Aborlan<br/>State: Palawan<br/>Country: Philippines', 2, '2024-06-29 17:23:33', '2024-06-29 17:23:33'),
(2391, 'work_locations', 3, 'Work locations created. <br/><br/>Work Locations Name: test<br/>Address: test<br/>City: Abra De Ilog<br/>State: Occidental Mindoro<br/>Country: Philippines<br/>Phone: asd', 2, '2024-06-29 18:16:11', '2024-06-29 18:16:11'),
(2392, 'work_locations', 3, 'Mobile:  -> asdasd<br/>Email:  -> asd@gmail.com<br/>', 2, '2024-06-29 18:16:55', '2024-06-29 18:16:55'),
(2393, 'work_locations', 3, 'Email: asd@gmail.com -> asd@gmail.comsad<br/>', 2, '2024-06-29 18:19:20', '2024-06-29 18:19:20'),
(2394, 'work_locations', 4, 'Work locations created. <br/><br/>Work Locations Name: testt<br/>Address: testt<br/>City: Aborlan<br/>State: Palawan<br/>Country: Philippines<br/>Phone: asd', 2, '2024-06-29 18:22:50', '2024-06-29 18:22:50'),
(2395, 'employment_types', 5, 'Employment type created. <br/><br/>Employment Type Name: test', 2, '2024-06-29 18:24:16', '2024-06-29 18:24:16'),
(2396, 'employment_types', 6, 'Employment type created. <br/><br/>Employment Type Name: test2', 2, '2024-06-29 18:25:04', '2024-06-29 18:25:04'),
(2397, 'employment_types', 6, 'Employment Type Name: test2 -> test2test<br/>', 2, '2024-06-29 18:25:09', '2024-06-29 18:25:09'),
(2398, 'employment_types', 7, 'Employment type created. <br/><br/>Employment Type Name: test', 2, '2024-06-29 18:25:13', '2024-06-29 18:25:13'),
(2399, 'employment_types', 8, 'Employment type created. <br/><br/>Employment Type Name: test', 2, '2024-06-29 18:34:10', '2024-06-29 18:34:10'),
(2400, 'departure_reasons', 4, 'Departure reason created. <br/><br/>Departure Reason Name: test', 2, '2024-06-29 18:54:42', '2024-06-29 18:54:42'),
(2401, 'departure_reasons', 5, 'Departure reason created. <br/><br/>Departure Reason Name: test', 2, '2024-06-29 18:54:50', '2024-06-29 18:54:50'),
(2402, 'departure_reasons', 4, 'Departure Reason Name: test -> test222<br/>', 2, '2024-06-29 18:55:03', '2024-06-29 18:55:03'),
(2403, 'job_positions', 1, 'Job position created. <br/><br/>Job Position Name: test', 2, '2024-07-01 09:43:13', '2024-07-01 09:43:13'),
(2404, 'job_positions', 1, 'Job Position Name: test -> test2<br/>', 2, '2024-07-01 09:43:21', '2024-07-01 09:43:21'),
(2405, 'job_positions', 2, 'Job position created. <br/><br/>Job Position Name: test', 2, '2024-07-01 09:54:03', '2024-07-01 09:54:03'),
(2406, 'role_permission', 29, 'Menu Item: Departure Reasons -> Departure Reason<br/>', 2, '2024-07-01 10:46:09', '2024-07-01 10:46:09'),
(2407, 'menu_item', 28, 'Menu Item Name: Departure Reasons -> Departure Reason<br/>Menu Item URL: departure-reasons.php -> departure-reason.php<br/>', 2, '2024-07-01 10:46:09', '2024-07-01 10:46:09'),
(2408, 'role_permission', 25, 'Menu Item: Departments -> Department<br/>', 2, '2024-07-01 10:46:22', '2024-07-01 10:46:22'),
(2409, 'menu_item', 24, 'Menu Item Name: Departments -> Department<br/>Menu Item URL: departments.php -> department.php<br/>', 2, '2024-07-01 10:46:22', '2024-07-01 10:46:22'),
(2410, 'role_permission', 30, 'Menu Item: Job Positions -> Job Position<br/>', 2, '2024-07-01 10:46:34', '2024-07-01 10:46:34'),
(2411, 'menu_item', 29, 'Menu Item Name: Job Positions -> Job Position<br/>Menu Item URL: job-positions.php -> job-position.php<br/>', 2, '2024-07-01 10:46:34', '2024-07-01 10:46:34'),
(2412, 'role_permission', 28, 'Menu Item: Employment Types -> Employment Type<br/>', 2, '2024-07-01 10:47:11', '2024-07-01 10:47:11'),
(2413, 'menu_item', 27, 'Menu Item Name: Employment Types -> Employment Type<br/>Menu Item URL: employment-types.php -> employment-type.php<br/>', 2, '2024-07-01 10:47:11', '2024-07-01 10:47:11'),
(2414, 'role_permission', 26, 'Menu Item: Work Locations -> Work Location<br/>', 2, '2024-07-01 10:47:20', '2024-07-01 10:47:20'),
(2415, 'menu_item', 25, 'Menu Item Name: Work Locations -> Work Location<br/>Menu Item URL: work-locations.php -> work-location.php<br/>', 2, '2024-07-01 10:47:20', '2024-07-01 10:47:20'),
(2416, 'role_permission', 27, 'Menu Item: Work Schedules -> Work Schedule<br/>', 2, '2024-07-01 10:47:35', '2024-07-01 10:47:35'),
(2417, 'menu_item', 26, 'Menu Item Name: Work Schedules -> Work Schedule<br/>Menu Item URL: work-schedules.php -> work-schedule.php<br/>', 2, '2024-07-01 10:47:35', '2024-07-01 10:47:35'),
(2418, 'role_permission', 24, 'Menu Item: Employees -> Employee<br/>', 2, '2024-07-01 10:47:50', '2024-07-01 10:47:50'),
(2419, 'menu_item', 23, 'Menu Item Name: Employees -> Employee<br/>Menu Item URL: employees.php -> employee.php<br/>', 2, '2024-07-01 10:47:50', '2024-07-01 10:47:50'),
(2420, 'departure_reason', 1, 'Departure reason created. <br/><br/>Departure Reason Name: test', 2, '2024-07-01 11:00:15', '2024-07-01 11:00:15'),
(2421, 'employment_type', 1, 'Employment type created. <br/><br/>Employment Type Name: test', 2, '2024-07-01 11:02:13', '2024-07-01 11:02:13'),
(2422, 'employment_type', 1, 'Employment Type Name: test -> testtest<br/>', 2, '2024-07-01 11:02:19', '2024-07-01 11:02:19'),
(2423, 'work_location', 1, 'Work location created. <br/><br/>Work Location Name: test<br/>Address: test<br/>City: Aborlan<br/>State: Palawan<br/>Country: Philippines', 2, '2024-07-01 11:02:31', '2024-07-01 11:02:31'),
(2424, 'work_location', 1, 'Work Location Name: test -> testt<br/>Address: test -> testt<br/>City: Aborlan -> Abulug<br/>State: Palawan -> Cagayan<br/>', 2, '2024-07-01 11:02:38', '2024-07-01 11:02:38'),
(2425, 'work_location', 1, 'Work Location Name: testt -> testttes<br/>Address: testt -> testttest<br/>', 2, '2024-07-01 11:04:14', '2024-07-01 11:04:14'),
(2426, 'work_location', 1, 'Work Location Name: testttes -> testttestes<br/>Address: testttest -> testttesttest<br/>', 2, '2024-07-01 11:04:26', '2024-07-01 11:04:26'),
(2427, 'job_position', 1, 'Job position created. <br/><br/>Job Position Name: test', 2, '2024-07-01 11:04:59', '2024-07-01 11:04:59'),
(2428, 'job_position', 2, 'Job position created. <br/><br/>Job Position Name: test', 2, '2024-07-01 11:07:24', '2024-07-01 11:07:24'),
(2429, 'job_position', 2, 'Job Position Name: test -> testtest<br/>', 2, '2024-07-01 11:07:30', '2024-07-01 11:07:30'),
(2430, 'work_location', 2, 'Work location created. <br/><br/>Work Location Name: test<br/>Address: test<br/>City: Aborlan<br/>State: Palawan<br/>Country: Philippines', 2, '2024-07-01 11:11:48', '2024-07-01 11:11:48'),
(2431, 'menu_item', 30, 'Menu Item created. <br/><br/>Menu Item Name: Work Schedule Type<br/>Menu Item URL: work-schedule-type.php<br/>Menu Group Name: Employee Configuration<br/>App Module: Employees<br/>Order Sequence: 25', 2, '2024-07-01 14:52:27', '2024-07-01 14:52:27'),
(2432, 'role_permission', 31, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Work Schedule Type<br/>Date Assigned: 2024-07-01 14:52:33', 2, '2024-07-01 14:52:33', '2024-07-01 14:52:33'),
(2433, 'role_permission', 31, 'Read Access: 0 -> 1<br/>', 2, '2024-07-01 14:52:35', '2024-07-01 14:52:35'),
(2434, 'role_permission', 31, 'Create Access: 0 -> 1<br/>', 2, '2024-07-01 14:52:35', '2024-07-01 14:52:35'),
(2435, 'role_permission', 31, 'Write Access: 0 -> 1<br/>', 2, '2024-07-01 14:52:36', '2024-07-01 14:52:36'),
(2436, 'role_permission', 31, 'Delete Access: 0 -> 1<br/>', 2, '2024-07-01 14:52:37', '2024-07-01 14:52:37'),
(2437, 'menu_item', 30, 'Menu Item Icon:  -> ti ti-calendar-stats<br/>', 2, '2024-07-01 14:54:28', '2024-07-01 14:54:28');
INSERT INTO `audit_log` (`audit_log_id`, `table_name`, `reference_id`, `log`, `changed_by`, `changed_at`, `created_date`) VALUES
(2438, 'menu_item', 31, 'Menu Item created. <br/><br/>Menu Item Name: Scheduling<br/>Menu Item Icon: ti ti-calendar-time<br/>Menu Group Name: Employee Configuration<br/>App Module: Employees<br/>Order Sequence: 24', 2, '2024-07-01 14:59:44', '2024-07-01 14:59:44'),
(2439, 'role_permission', 32, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Scheduling<br/>Date Assigned: 2024-07-01 14:59:48', 2, '2024-07-01 14:59:48', '2024-07-01 14:59:48'),
(2440, 'role_permission', 32, 'Read Access: 0 -> 1<br/>', 2, '2024-07-01 14:59:49', '2024-07-01 14:59:49'),
(2441, 'menu_item', 26, 'Menu Item Icon: ti ti-calendar-stats -> <br/>Order Sequence: 24 -> 1<br/>', 2, '2024-07-01 15:00:20', '2024-07-01 15:00:20'),
(2442, 'menu_item', 30, 'Menu Item Icon: ti ti-calendar-stats -> <br/>Order Sequence: 25 -> 2<br/>', 2, '2024-07-01 15:00:33', '2024-07-01 15:00:33'),
(2443, 'role_permission', 31, 'Menu Item: Work Schedule Type -> Schedule Type<br/>', 2, '2024-07-01 15:09:21', '2024-07-01 15:09:21'),
(2444, 'menu_item', 30, 'Menu Item Name: Work Schedule Type -> Schedule Type<br/>Menu Item URL: work-schedule-type.php -> schedule-type.php<br/>', 2, '2024-07-01 15:09:21', '2024-07-01 15:09:21'),
(2445, 'schedule_type', 1, 'Schedule type created. <br/><br/>Schedule Type Name: Fixed', 2, '2024-07-01 15:48:39', '2024-07-01 15:48:39'),
(2446, 'schedule_type', 1, 'Schedule Type Name: Fixed -> Fixed test<br/>', 2, '2024-07-01 15:49:14', '2024-07-01 15:49:14'),
(2447, 'schedule_type', 1, 'Schedule Type Name: Fixed test -> Fixed<br/>', 2, '2024-07-01 15:49:18', '2024-07-01 15:49:18'),
(2448, 'schedule_type', 2, 'Schedule type created. <br/><br/>Schedule Type Name: Flexible', 2, '2024-07-02 09:49:09', '2024-07-02 09:49:09'),
(2449, 'schedule_type', 3, 'Schedule type created. <br/><br/>Schedule Type Name: Shifting', 2, '2024-07-02 09:49:26', '2024-07-02 09:49:26'),
(2450, 'work_schedule', 5, 'Schedule Type Name: Fixed -> Flexible<br/>', 2, '2024-07-02 10:17:16', '2024-07-02 10:17:16'),
(2451, 'work_schedule', 5, 'Schedule Type Name: Flexible -> Fixed<br/>', 2, '2024-07-02 10:17:21', '2024-07-02 10:17:21'),
(2452, 'system_action', 17, 'System action created. <br/><br/>System Action Name: Add Work Hours<br/>System Action Description: Access to add the work hours.', 2, '2024-07-02 10:23:36', '2024-07-02 10:23:36'),
(2453, 'role_system_action_permission', 17, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Add Work Hours<br/>Date Assigned: 2024-07-02 10:23:41', 2, '2024-07-02 10:23:41', '2024-07-02 10:23:41'),
(2454, 'role_system_action_permission', 17, 'System Action Access: 0 -> 1<br/>', 2, '2024-07-02 10:23:42', '2024-07-02 10:23:42'),
(2455, 'system_action', 18, 'System action created. <br/><br/>System Action Name: Update Work Hours<br/>System Action Description: Access to update the work hours.', 2, '2024-07-02 10:23:59', '2024-07-02 10:23:59'),
(2456, 'role_system_action_permission', 18, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Update Work Hours<br/>Date Assigned: 2024-07-02 10:24:05', 2, '2024-07-02 10:24:05', '2024-07-02 10:24:05'),
(2457, 'role_system_action_permission', 18, 'System Action Access: 0 -> 1<br/>', 2, '2024-07-02 10:24:06', '2024-07-02 10:24:06'),
(2458, 'system_action', 19, 'System action created. <br/><br/>System Action Name: Delete Work Hours<br/>System Action Description: Access to delete the work hours.', 2, '2024-07-02 10:24:19', '2024-07-02 10:24:19'),
(2459, 'role_system_action_permission', 19, 'Role system action permission created. <br/><br/>Role Name: Administrator<br/>System Action Name: Delete Work Hours<br/>Date Assigned: 2024-07-02 10:24:23', 2, '2024-07-02 10:24:23', '2024-07-02 10:24:23'),
(2460, 'role_system_action_permission', 19, 'System Action Access: 0 -> 1<br/>', 2, '2024-07-02 10:24:24', '2024-07-02 10:24:24'),
(2461, 'work_hours', 1, 'Work hours created. <br/><br/>Day of Week: Monday<br/>Day Period: Morning<br/>Start Time: 08:00:00<br/>End Time: 12:00:00<br/>Notes: test', 2, '2024-07-02 15:52:29', '2024-07-02 15:52:29'),
(2462, 'work_hours', 2, 'Work hours created. <br/><br/>Day of Week: Tuesday<br/>Day Period: Afternoon<br/>Start Time: 09:01:00<br/>End Time: 12:30:00<br/>Notes: testasdasd', 2, '2024-07-02 16:01:51', '2024-07-02 16:01:51'),
(2463, 'work_hours', 3, 'Work hours created. <br/><br/>Day of Week: Wednesday<br/>Day Period: Evening<br/>Start Time: 09:03:00<br/>End Time: 16:30:00<br/>Notes: testasdasd', 2, '2024-07-02 16:02:52', '2024-07-02 16:02:52'),
(2464, 'work_hours', 4, 'Work hours created. <br/><br/>Day of Week: Monday<br/>Day Period: Morning<br/>Start Time: 08:00:00<br/>End Time: 12:00:00<br/>Notes: test', 2, '2024-07-02 16:05:24', '2024-07-02 16:05:24'),
(2465, 'work_hours', 5, 'Work hours created. <br/><br/>Day of Week: Thursday<br/>Day Period: Afternoon<br/>Start Time: 08:30:00<br/>End Time: 12:20:00<br/>Notes: test', 2, '2024-07-02 16:06:09', '2024-07-02 16:06:09'),
(2466, 'work_hours', 1, 'Day of Week: Monday -> Thursday<br/>', 2, '2024-07-02 16:08:01', '2024-07-02 16:08:01'),
(2467, 'work_hours', 2, 'Start Time: 09:01:00 -> 09:30:00<br/>End Time: 12:30:00 -> 12:35:00<br/>', 2, '2024-07-02 16:21:58', '2024-07-02 16:21:58'),
(2468, 'work_hours', 4, 'Day Period: Morning -> Afternoon<br/>', 2, '2024-07-02 16:26:57', '2024-07-02 16:26:57'),
(2469, 'work_hours', 6, 'Work hours created. <br/><br/>Day of Week: Saturday<br/>Day Period: Morning<br/>Start Time: 08:00:00<br/>End Time: 17:30:00', 2, '2024-07-02 16:44:12', '2024-07-02 16:44:12'),
(2470, 'work_hours', 7, 'Work hours created. <br/><br/>Day of Week: Wednesday<br/>Day Period: Evening<br/>Start Time: 08:00:00<br/>End Time: 14:05:00', 2, '2024-07-02 16:47:08', '2024-07-02 16:47:08'),
(2471, 'menu_item', 32, 'Menu Item created. <br/><br/>Menu Item Name: Contact Information Type<br/>Menu Item URL: contact-information-type.php<br/>Menu Item Icon: ti ti-device-mobile<br/>Menu Group Name: Configurations<br/>App Module: Settings<br/>Order Sequence: 3', 2, '2024-07-02 17:02:55', '2024-07-02 17:02:55'),
(2472, 'role_permission', 33, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Contact Information Type<br/>Date Assigned: 2024-07-02 17:02:59', 2, '2024-07-02 17:02:59', '2024-07-02 17:02:59'),
(2473, 'role_permission', 33, 'Read Access: 0 -> 1<br/>', 2, '2024-07-02 17:02:59', '2024-07-02 17:02:59'),
(2474, 'role_permission', 33, 'Create Access: 0 -> 1<br/>', 2, '2024-07-02 17:03:00', '2024-07-02 17:03:00'),
(2475, 'role_permission', 33, 'Write Access: 0 -> 1<br/>', 2, '2024-07-02 17:03:01', '2024-07-02 17:03:01'),
(2476, 'role_permission', 33, 'Delete Access: 0 -> 1<br/>', 2, '2024-07-02 17:03:02', '2024-07-02 17:03:02'),
(2477, 'menu_item', 33, 'Menu Item created. <br/><br/>Menu Item Name: ID Type<br/>Menu Item URL: id-type.php<br/>Menu Item Icon: ti ti-id<br/>Menu Group Name: Configurations<br/>App Module: Settings<br/>Order Sequence: 9', 2, '2024-07-02 17:05:17', '2024-07-02 17:05:17'),
(2478, 'role_permission', 34, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: ID Type<br/>Date Assigned: 2024-07-02 17:05:20', 2, '2024-07-02 17:05:20', '2024-07-02 17:05:20'),
(2479, 'role_permission', 34, 'Read Access: 0 -> 1<br/>', 2, '2024-07-02 17:05:21', '2024-07-02 17:05:21'),
(2480, 'role_permission', 34, 'Create Access: 0 -> 1<br/>', 2, '2024-07-02 17:05:22', '2024-07-02 17:05:22'),
(2481, 'role_permission', 34, 'Write Access: 0 -> 1<br/>', 2, '2024-07-02 17:05:23', '2024-07-02 17:05:23'),
(2482, 'role_permission', 34, 'Delete Access: 0 -> 1<br/>', 2, '2024-07-02 17:05:23', '2024-07-02 17:05:23'),
(2483, 'menu_item', 34, 'Menu Item created. <br/><br/>Menu Item Name: Bank<br/>Menu Item URL: bank.php<br/>Menu Item Icon: ti ti-building-bank<br/>Menu Group Name: Configurations<br/>App Module: Settings<br/>Order Sequence: 2', 2, '2024-07-02 17:06:13', '2024-07-02 17:06:13'),
(2484, 'role_permission', 35, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Bank<br/>Date Assigned: 2024-07-02 17:06:16', 2, '2024-07-02 17:06:16', '2024-07-02 17:06:16'),
(2485, 'role_permission', 35, 'Read Access: 0 -> 1<br/>', 2, '2024-07-02 17:06:17', '2024-07-02 17:06:17'),
(2486, 'role_permission', 35, 'Create Access: 0 -> 1<br/>', 2, '2024-07-02 17:06:18', '2024-07-02 17:06:18'),
(2487, 'role_permission', 35, 'Write Access: 0 -> 1<br/>', 2, '2024-07-02 17:06:19', '2024-07-02 17:06:19'),
(2488, 'role_permission', 35, 'Delete Access: 0 -> 1<br/>', 2, '2024-07-02 17:06:19', '2024-07-02 17:06:19'),
(2489, 'menu_item', 35, 'Menu Item created. <br/><br/>Menu Item Name: Bank Account Type<br/>Menu Item URL: bank-account-type.php<br/>Menu Item Icon: ti ti-building-community<br/>Menu Group Name: Configurations<br/>App Module: Settings<br/>Order Sequence: 3', 2, '2024-07-02 17:07:16', '2024-07-02 17:07:16'),
(2490, 'role_permission', 36, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Bank Account Type<br/>Date Assigned: 2024-07-02 17:07:21', 2, '2024-07-02 17:07:21', '2024-07-02 17:07:21'),
(2491, 'role_permission', 36, 'Read Access: 0 -> 1<br/>', 2, '2024-07-02 17:07:23', '2024-07-02 17:07:23'),
(2492, 'role_permission', 36, 'Create Access: 0 -> 1<br/>', 2, '2024-07-02 17:07:23', '2024-07-02 17:07:23'),
(2493, 'role_permission', 36, 'Write Access: 0 -> 1<br/>', 2, '2024-07-02 17:07:24', '2024-07-02 17:07:24'),
(2494, 'role_permission', 36, 'Delete Access: 0 -> 1<br/>', 2, '2024-07-02 17:07:25', '2024-07-02 17:07:25'),
(2495, 'menu_item', 35, 'Order Sequence: 3 -> 2<br/>', 2, '2024-07-02 17:08:44', '2024-07-02 17:08:44'),
(2496, 'menu_item', 36, 'Menu Item created. <br/><br/>Menu Item Name: Relation<br/>Menu Item URL: relation.php<br/>Menu Group Name: Configurations<br/>App Module: Settings<br/>Order Sequence: 18', 2, '2024-07-02 17:09:40', '2024-07-02 17:09:40'),
(2497, 'menu_item', 36, 'Menu Item Icon:  -> ti ti-social<br/>', 2, '2024-07-02 17:10:39', '2024-07-02 17:10:39'),
(2498, 'role_permission', 37, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Relation<br/>Date Assigned: 2024-07-02 17:10:43', 2, '2024-07-02 17:10:43', '2024-07-02 17:10:43'),
(2499, 'role_permission', 37, 'Read Access: 0 -> 1<br/>', 2, '2024-07-02 17:10:44', '2024-07-02 17:10:44'),
(2500, 'role_permission', 37, 'Create Access: 0 -> 1<br/>', 2, '2024-07-02 17:10:45', '2024-07-02 17:10:45'),
(2501, 'role_permission', 37, 'Write Access: 0 -> 1<br/>', 2, '2024-07-02 17:10:47', '2024-07-02 17:10:47'),
(2502, 'role_permission', 37, 'Delete Access: 0 -> 1<br/>', 2, '2024-07-02 17:10:48', '2024-07-02 17:10:48'),
(2503, 'menu_item', 37, 'Menu Item created. <br/><br/>Menu Item Name: Educational Stage<br/>Menu Item URL: educational-stage.php<br/>Menu Item Icon: ti ti-school<br/>Menu Group Name: Configurations<br/>App Module: Settings<br/>Order Sequence: 5', 2, '2024-07-02 17:11:54', '2024-07-02 17:11:54'),
(2504, 'role_permission', 38, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Educational Stage<br/>Date Assigned: 2024-07-02 17:11:57', 2, '2024-07-02 17:11:57', '2024-07-02 17:11:57'),
(2505, 'role_permission', 38, 'Read Access: 0 -> 1<br/>', 2, '2024-07-02 17:11:58', '2024-07-02 17:11:58'),
(2506, 'role_permission', 38, 'Create Access: 0 -> 1<br/>', 2, '2024-07-02 17:11:59', '2024-07-02 17:11:59'),
(2507, 'role_permission', 38, 'Write Access: 0 -> 1<br/>', 2, '2024-07-02 17:12:00', '2024-07-02 17:12:00'),
(2508, 'role_permission', 38, 'Delete Access: 0 -> 1<br/>', 2, '2024-07-02 17:12:00', '2024-07-02 17:12:00'),
(2509, 'menu_item', 38, 'Menu Item created. <br/><br/>Menu Item Name: Language<br/>Menu Item URL: language.php<br/>Menu Item Icon: ti ti-language<br/>Menu Group Name: Configurations<br/>App Module: Settings<br/>Order Sequence: 12', 2, '2024-07-02 17:21:10', '2024-07-02 17:21:10'),
(2510, 'role_permission', 39, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Language<br/>Date Assigned: 2024-07-02 17:21:16', 2, '2024-07-02 17:21:16', '2024-07-02 17:21:16'),
(2511, 'role_permission', 39, 'Read Access: 0 -> 1<br/>', 2, '2024-07-02 17:21:18', '2024-07-02 17:21:18'),
(2512, 'role_permission', 39, 'Create Access: 0 -> 1<br/>', 2, '2024-07-02 17:21:18', '2024-07-02 17:21:18'),
(2513, 'role_permission', 39, 'Write Access: 0 -> 1<br/>', 2, '2024-07-02 17:21:19', '2024-07-02 17:21:19'),
(2514, 'role_permission', 39, 'Delete Access: 0 -> 1<br/>', 2, '2024-07-02 17:21:20', '2024-07-02 17:21:20'),
(2515, 'menu_item', 39, 'Menu Item created. <br/><br/>Menu Item Name: Language Proficiency<br/>Menu Item URL: language-proficiency.php<br/>Menu Item Icon: ti ti-messages<br/>Menu Group Name: Configurations<br/>App Module: Settings<br/>Order Sequence: 12', 2, '2024-07-02 17:23:14', '2024-07-02 17:23:14'),
(2516, 'role_permission', 40, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Language Proficiency<br/>Date Assigned: 2024-07-02 17:23:19', 2, '2024-07-02 17:23:19', '2024-07-02 17:23:19'),
(2517, 'role_permission', 40, 'Read Access: 0 -> 1<br/>', 2, '2024-07-02 17:23:21', '2024-07-02 17:23:21'),
(2518, 'role_permission', 40, 'Create Access: 0 -> 1<br/>', 2, '2024-07-02 17:23:22', '2024-07-02 17:23:22'),
(2519, 'role_permission', 40, 'Write Access: 0 -> 1<br/>', 2, '2024-07-02 17:23:23', '2024-07-02 17:23:23'),
(2520, 'role_permission', 40, 'Delete Access: 0 -> 1<br/>', 2, '2024-07-02 17:23:23', '2024-07-02 17:23:23'),
(2521, 'menu_item', 40, 'Menu Item created. <br/><br/>Menu Item Name: Civil Status<br/>Menu Item URL: civil-status.php<br/>Menu Item Icon: ti ti-chart-circles<br/>Menu Group Name: Configurations<br/>App Module: Settings<br/>Order Sequence: 3', 2, '2024-07-02 17:26:17', '2024-07-02 17:26:17'),
(2522, 'role_permission', 41, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Civil Status<br/>Date Assigned: 2024-07-02 17:26:21', 2, '2024-07-02 17:26:21', '2024-07-02 17:26:21'),
(2523, 'role_permission', 41, 'Read Access: 0 -> 1<br/>', 2, '2024-07-02 17:26:23', '2024-07-02 17:26:23'),
(2524, 'role_permission', 41, 'Create Access: 0 -> 1<br/>', 2, '2024-07-02 17:26:24', '2024-07-02 17:26:24'),
(2525, 'role_permission', 41, 'Write Access: 0 -> 1<br/>', 2, '2024-07-02 17:26:25', '2024-07-02 17:26:25'),
(2526, 'role_permission', 41, 'Delete Access: 0 -> 1<br/>', 2, '2024-07-02 17:26:25', '2024-07-02 17:26:25'),
(2527, 'menu_item', 41, 'Menu Item created. <br/><br/>Menu Item Name: Gender<br/>Menu Item URL: gender.php<br/>Menu Item Icon: ti ti-friends<br/>Menu Group Name: Configurations<br/>App Module: Settings<br/>Order Sequence: 7', 2, '2024-07-02 17:27:18', '2024-07-02 17:27:18'),
(2528, 'role_permission', 42, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Gender<br/>Date Assigned: 2024-07-02 17:27:22', 2, '2024-07-02 17:27:22', '2024-07-02 17:27:22'),
(2529, 'role_permission', 42, 'Read Access: 0 -> 1<br/>', 2, '2024-07-02 17:27:23', '2024-07-02 17:27:23'),
(2530, 'role_permission', 42, 'Create Access: 0 -> 1<br/>', 2, '2024-07-02 17:27:24', '2024-07-02 17:27:24'),
(2531, 'role_permission', 42, 'Write Access: 0 -> 1<br/>', 2, '2024-07-02 17:27:24', '2024-07-02 17:27:24'),
(2532, 'role_permission', 42, 'Delete Access: 0 -> 1<br/>', 2, '2024-07-02 17:27:25', '2024-07-02 17:27:25'),
(2533, 'menu_item', 42, 'Menu Item created. <br/><br/>Menu Item Name: Blood Type<br/>Menu Item URL: blood-type.php<br/>Menu Item Icon: ti ti-droplet-filled<br/>Menu Group Name: Configurations<br/>App Module: Settings<br/>Order Sequence: 2', 2, '2024-07-02 17:28:23', '2024-07-02 17:28:23'),
(2534, 'role_permission', 43, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Blood Type<br/>Date Assigned: 2024-07-02 17:28:26', 2, '2024-07-02 17:28:26', '2024-07-02 17:28:26'),
(2535, 'role_permission', 43, 'Read Access: 0 -> 1<br/>', 2, '2024-07-02 17:28:27', '2024-07-02 17:28:27'),
(2536, 'role_permission', 43, 'Create Access: 0 -> 1<br/>', 2, '2024-07-02 17:28:27', '2024-07-02 17:28:27'),
(2537, 'role_permission', 43, 'Write Access: 0 -> 1<br/>', 2, '2024-07-02 17:28:28', '2024-07-02 17:28:28'),
(2538, 'role_permission', 43, 'Delete Access: 0 -> 1<br/>', 2, '2024-07-02 17:28:28', '2024-07-02 17:28:28'),
(2539, 'menu_item', 43, 'Menu Item created. <br/><br/>Menu Item Name: Religion<br/>Menu Item URL: religion.php<br/>Menu Item Icon: ti ti-building-church<br/>Menu Group Name: Configurations<br/>App Module: Settings<br/>Order Sequence: 18', 2, '2024-07-02 17:29:10', '2024-07-02 17:29:10'),
(2540, 'role_permission', 44, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Religion<br/>Date Assigned: 2024-07-02 17:29:14', 2, '2024-07-02 17:29:14', '2024-07-02 17:29:14'),
(2541, 'role_permission', 44, 'Read Access: 0 -> 1<br/>', 2, '2024-07-02 17:29:15', '2024-07-02 17:29:15'),
(2542, 'role_permission', 44, 'Create Access: 0 -> 1<br/>', 2, '2024-07-02 17:29:16', '2024-07-02 17:29:16'),
(2543, 'role_permission', 44, 'Write Access: 0 -> 1<br/>', 2, '2024-07-02 17:29:16', '2024-07-02 17:29:16'),
(2544, 'role_permission', 44, 'Delete Access: 0 -> 1<br/>', 2, '2024-07-02 17:29:17', '2024-07-02 17:29:17'),
(2545, 'menu_item', 44, 'Menu Item created. <br/><br/>Menu Item Name: Address Type<br/>Menu Item URL: address-type.php<br/>Menu Item Icon: ti ti-map-2<br/>Menu Group Name: Configurations<br/>App Module: Settings<br/>Order Sequence: 1', 2, '2024-07-02 17:30:03', '2024-07-02 17:30:03'),
(2546, 'role_permission', 45, 'Role permission created. <br/><br/>Role Name: Administrator<br/>Menu Item Name: Address Type<br/>Date Assigned: 2024-07-02 17:30:07', 2, '2024-07-02 17:30:07', '2024-07-02 17:30:07'),
(2547, 'role_permission', 45, 'Read Access: 0 -> 1<br/>', 2, '2024-07-02 17:30:08', '2024-07-02 17:30:08'),
(2548, 'role_permission', 45, 'Create Access: 0 -> 1<br/>', 2, '2024-07-02 17:30:08', '2024-07-02 17:30:08'),
(2549, 'role_permission', 45, 'Write Access: 0 -> 1<br/>', 2, '2024-07-02 17:30:10', '2024-07-02 17:30:10'),
(2550, 'role_permission', 45, 'Write Access: 1 -> 0<br/>', 2, '2024-07-02 17:30:10', '2024-07-02 17:30:10'),
(2551, 'role_permission', 45, 'Delete Access: 0 -> 1<br/>', 2, '2024-07-02 17:30:11', '2024-07-02 17:30:11'),
(2552, 'role_permission', 45, 'Write Access: 0 -> 1<br/>', 2, '2024-07-02 17:30:12', '2024-07-02 17:30:12'),
(2553, 'user_account', 2, 'Failed Login Attempts: 0 -> 1<br/>', 1, '2024-07-02 19:52:28', '2024-07-02 19:52:28'),
(2554, 'user_account', 2, 'Failed Login Attempts: 1 -> 0<br/>', 1, '2024-07-02 19:52:31', '2024-07-02 19:52:31'),
(2555, 'user_account', 2, 'Last Connection Date: 2024-06-29 16:55:59 -> 2024-07-02 19:52:31<br/>', 1, '2024-07-02 19:52:31', '2024-07-02 19:52:31'),
(2556, 'address_type', 1, 'Address type created. <br/><br/>Address Type Name: test', 2, '2024-07-02 20:46:41', '2024-07-02 20:46:41'),
(2557, 'address_type', 1, 'Address Type Name: test -> testasd<br/>', 2, '2024-07-02 20:51:02', '2024-07-02 20:51:02'),
(2558, 'address_type', 2, 'Address type created. <br/><br/>Address Type Name: test\\', 2, '2024-07-02 20:51:11', '2024-07-02 20:51:11'),
(2559, 'address_type', 3, 'Address type created. <br/><br/>Address Type Name: test', 2, '2024-07-02 20:51:15', '2024-07-02 20:51:15'),
(2560, 'address_type', 1, 'Address type created. <br/><br/>Address Type Name: Home Address', 2, '2024-07-03 09:29:42', '2024-07-03 09:29:42'),
(2561, 'address_type', 2, 'Address type created. <br/><br/>Address Type Name: Billing Address', 2, '2024-07-03 09:29:55', '2024-07-03 09:29:55'),
(2562, 'address_type', 3, 'Address type created. <br/><br/>Address Type Name: Mailing Address', 2, '2024-07-03 09:30:02', '2024-07-03 09:30:02'),
(2563, 'address_type', 4, 'Address type created. <br/><br/>Address Type Name: Shipping Address', 2, '2024-07-03 09:30:13', '2024-07-03 09:30:13'),
(2564, 'address_type', 5, 'Address type created. <br/><br/>Address Type Name: Work Address', 2, '2024-07-03 09:30:20', '2024-07-03 09:30:20'),
(2565, 'blood_type', 1, 'Blood type created. <br/><br/>Blood Type Name: test', 2, '2024-07-03 09:47:45', '2024-07-03 09:47:45'),
(2566, 'blood_type', 1, 'Blood Type Name: test -> test2<br/>', 2, '2024-07-03 09:47:51', '2024-07-03 09:47:51'),
(2567, 'employment_type', 2, 'Employment type created. <br/><br/>Employment Type Name: test', 2, '2024-07-03 09:49:33', '2024-07-03 09:49:33'),
(2568, 'departure_reason', 2, 'Departure reason created. <br/><br/>Departure Reason Name: test', 2, '2024-07-03 09:49:47', '2024-07-03 09:49:47'),
(2569, 'blood_type', 2, 'Blood type created. <br/><br/>Blood Type Name: testr', 2, '2024-07-03 09:53:32', '2024-07-03 09:53:32'),
(2570, 'blood_type', 1, 'Blood type created. <br/><br/>Blood Type Name: A+', 2, '2024-07-03 09:55:30', '2024-07-03 09:55:30'),
(2571, 'blood_type', 2, 'Blood type created. <br/><br/>Blood Type Name: A-', 2, '2024-07-03 09:55:36', '2024-07-03 09:55:36'),
(2572, 'blood_type', 3, 'Blood type created. <br/><br/>Blood Type Name: AB+', 2, '2024-07-03 09:55:41', '2024-07-03 09:55:41'),
(2573, 'blood_type', 4, 'Blood type created. <br/><br/>Blood Type Name: AB-', 2, '2024-07-03 09:55:46', '2024-07-03 09:55:46'),
(2574, 'blood_type', 5, 'Blood type created. <br/><br/>Blood Type Name: B+', 2, '2024-07-03 09:55:51', '2024-07-03 09:55:51'),
(2575, 'blood_type', 6, 'Blood type created. <br/><br/>Blood Type Name: B-', 2, '2024-07-03 09:55:56', '2024-07-03 09:55:56'),
(2576, 'blood_type', 7, 'Blood type created. <br/><br/>Blood Type Name: O+', 2, '2024-07-03 09:56:01', '2024-07-03 09:56:01'),
(2577, 'blood_type', 8, 'Blood type created. <br/><br/>Blood Type Name: O-', 2, '2024-07-03 09:56:07', '2024-07-03 09:56:07'),
(2578, 'civil_status', 1, 'Civil status created. <br/><br/>Civil Status Name: test', 2, '2024-07-03 10:11:04', '2024-07-03 10:11:04'),
(2579, 'civil_status', 2, 'Civil status created. <br/><br/>Civil Status Name: test', 2, '2024-07-03 10:11:07', '2024-07-03 10:11:07'),
(2580, 'civil_status', 2, 'Civil Status Name: test -> test2<br/>', 2, '2024-07-03 10:11:10', '2024-07-03 10:11:10'),
(2581, 'civil_status', 1, 'Civil status created. <br/><br/>Civil Status Name: Divorced', 2, '2024-07-03 10:12:10', '2024-07-03 10:12:10'),
(2582, 'civil_status', 2, 'Civil status created. <br/><br/>Civil Status Name: Engaged', 2, '2024-07-03 10:12:19', '2024-07-03 10:12:19'),
(2583, 'civil_status', 3, 'Civil status created. <br/><br/>Civil Status Name: In a Relationship', 2, '2024-07-03 10:12:24', '2024-07-03 10:12:24'),
(2584, 'civil_status', 4, 'Civil status created. <br/><br/>Civil Status Name: Married', 2, '2024-07-03 10:12:28', '2024-07-03 10:12:28'),
(2585, 'civil_status', 5, 'Civil status created. <br/><br/>Civil Status Name: Separated', 2, '2024-07-03 10:12:32', '2024-07-03 10:12:32'),
(2586, 'civil_status', 6, 'Civil status created. <br/><br/>Civil Status Name: Single', 2, '2024-07-03 10:12:37', '2024-07-03 10:12:37'),
(2587, 'civil_status', 7, 'Civil status created. <br/><br/>Civil Status Name: Widowed', 2, '2024-07-03 10:12:42', '2024-07-03 10:12:42'),
(2588, 'educational_stage', 1, 'Educational stage created. <br/><br/>Educational Stage Name: College', 2, '2024-07-03 10:29:33', '2024-07-03 10:29:33'),
(2589, 'educational_stage', 2, 'Educational stage created. <br/><br/>Educational Stage Name: test', 2, '2024-07-03 10:29:39', '2024-07-03 10:29:39'),
(2590, 'educational_stage', 2, 'Educational Stage Name: test -> test2<br/>', 2, '2024-07-03 10:29:43', '2024-07-03 10:29:43'),
(2591, 'educational_stage', 1, 'Educational stage created. <br/><br/>Educational Stage Name: College', 2, '2024-07-03 10:30:05', '2024-07-03 10:30:05'),
(2592, 'educational_stage', 2, 'Educational stage created. <br/><br/>Educational Stage Name: Junior High School', 2, '2024-07-03 10:30:10', '2024-07-03 10:30:10'),
(2593, 'educational_stage', 3, 'Educational stage created. <br/><br/>Educational Stage Name: Postgraduate', 2, '2024-07-03 10:30:13', '2024-07-03 10:30:13'),
(2594, 'educational_stage', 4, 'Educational stage created. <br/><br/>Educational Stage Name: Preschool', 2, '2024-07-03 10:30:17', '2024-07-03 10:30:17'),
(2595, 'educational_stage', 5, 'Educational stage created. <br/><br/>Educational Stage Name: Primary School', 2, '2024-07-03 10:30:21', '2024-07-03 10:30:21'),
(2596, 'educational_stage', 6, 'Educational stage created. <br/><br/>Educational Stage Name: Senior High School', 2, '2024-07-03 10:30:25', '2024-07-03 10:30:25'),
(2597, 'id_type', 1, 'ID type created. <br/><br/>ID Type Name: Barangay ID', 2, '2024-07-03 10:36:39', '2024-07-03 10:36:39'),
(2598, 'id_type', 1, 'ID Type Name: Barangay ID -> Barangay IDs<br/>', 2, '2024-07-03 10:36:42', '2024-07-03 10:36:42'),
(2599, 'id_type', 2, 'ID type created. <br/><br/>ID Type Name: test', 2, '2024-07-03 10:36:47', '2024-07-03 10:36:47'),
(2600, 'id_type', 1, 'ID type created. <br/><br/>ID Type Name: Barangay ID', 2, '2024-07-03 10:38:07', '2024-07-03 10:38:07'),
(2601, 'id_type', 2, 'ID type created. <br/><br/>ID Type Name: Company ID', 2, '2024-07-03 10:38:14', '2024-07-03 10:38:14'),
(2602, 'id_type', 3, 'ID type created. <br/><br/>ID Type Name: Driver\'s License', 2, '2024-07-03 10:38:18', '2024-07-03 10:38:18'),
(2603, 'id_type', 4, 'ID type created. <br/><br/>ID Type Name: Government Service Insurance System (GSIS) ID', 2, '2024-07-03 10:38:23', '2024-07-03 10:38:23'),
(2604, 'id_type', 5, 'ID type created. <br/><br/>ID Type Name: Home Development Mutual Fund (Pag-IBIG) ID', 2, '2024-07-03 10:38:27', '2024-07-03 10:38:27'),
(2605, 'id_type', 6, 'ID type created. <br/><br/>ID Type Name: National Bureau of Investigation (NBI) Clearance', 2, '2024-07-03 10:38:32', '2024-07-03 10:38:32'),
(2606, 'id_type', 7, 'ID type created. <br/><br/>ID Type Name: 	National ID', 2, '2024-07-03 10:38:35', '2024-07-03 10:38:35'),
(2607, 'id_type', 8, 'ID type created. <br/><br/>ID Type Name: 	PhilHealth ID', 2, '2024-07-03 10:38:39', '2024-07-03 10:38:39'),
(2608, 'id_type', 8, 'ID Type Name: 	PhilHealth ID -> PhilHealth ID<br/>', 2, '2024-07-03 10:38:43', '2024-07-03 10:38:43'),
(2609, 'id_type', 7, 'ID Type Name: 	National ID -> National ID<br/>', 2, '2024-07-03 10:39:05', '2024-07-03 10:39:05'),
(2610, 'id_type', 9, 'ID type created. <br/><br/>ID Type Name: Philippine Passport', 2, '2024-07-03 10:39:42', '2024-07-03 10:39:42'),
(2611, 'id_type', 10, 'ID type created. <br/><br/>ID Type Name: Police Clearance', 2, '2024-07-03 10:39:46', '2024-07-03 10:39:46'),
(2612, 'id_type', 11, 'ID type created. <br/><br/>ID Type Name: Postal ID', 2, '2024-07-03 10:39:52', '2024-07-03 10:39:52'),
(2613, 'id_type', 12, 'ID type created. <br/><br/>ID Type Name: Professional Regulation Commission (PRC) ID', 2, '2024-07-03 10:39:59', '2024-07-03 10:39:59'),
(2614, 'id_type', 13, 'ID type created. <br/><br/>ID Type Name: Senior Citizen ID', 2, '2024-07-03 10:40:05', '2024-07-03 10:40:05'),
(2615, 'id_type', 14, 'ID type created. <br/><br/>ID Type Name: Social Security System (SSS) ID', 2, '2024-07-03 10:40:10', '2024-07-03 10:40:10'),
(2616, 'id_type', 15, 'ID type created. <br/><br/>ID Type Name: Student ID', 2, '2024-07-03 10:40:16', '2024-07-03 10:40:16'),
(2617, 'id_type', 16, 'ID type created. <br/><br/>ID Type Name: Taxpayer Identification Number (TIN) ID', 2, '2024-07-03 10:40:21', '2024-07-03 10:40:21'),
(2618, 'id_type', 17, 'ID type created. <br/><br/>ID Type Name: Unified Multi-Purpose ID (UMID)', 2, '2024-07-03 10:40:31', '2024-07-03 10:40:31'),
(2619, 'id_type', 18, 'ID type created. <br/><br/>ID Type Name: Voter\'s ID', 2, '2024-07-03 10:40:37', '2024-07-03 10:40:37'),
(2620, 'gender', 1, 'Gender created. <br/><br/>Gender Name: test', 2, '2024-07-03 10:52:04', '2024-07-03 10:52:04'),
(2621, 'gender', 2, 'Gender created. <br/><br/>Gender Name: test2', 2, '2024-07-03 10:52:09', '2024-07-03 10:52:09'),
(2622, 'gender', 2, 'Gender Name: test2 -> test23<br/>', 2, '2024-07-03 10:52:12', '2024-07-03 10:52:12'),
(2623, 'gender', 1, 'Gender created. <br/><br/>Gender Name: Male', 2, '2024-07-03 10:52:37', '2024-07-03 10:52:37'),
(2624, 'gender', 2, 'Gender created. <br/><br/>Gender Name: Female', 2, '2024-07-03 10:52:42', '2024-07-03 10:52:42'),
(2625, 'language', 1, 'Language created. <br/><br/>Language Name: test', 2, '2024-07-03 10:58:52', '2024-07-03 10:58:52'),
(2626, 'language', 1, 'Language Name: test -> test2<br/>', 2, '2024-07-03 10:58:55', '2024-07-03 10:58:55'),
(2627, 'language', 2, 'Language created. <br/><br/>Language Name: test3', 2, '2024-07-03 10:58:59', '2024-07-03 10:58:59'),
(2628, 'language', 3, 'Language created. <br/><br/>Language Name: test5', 2, '2024-07-03 10:59:03', '2024-07-03 10:59:03'),
(2629, 'language', 1, 'Language created. <br/><br/>Language Name: Afrikaans', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2630, 'language', 2, 'Language created. <br/><br/>Language Name: Amharic', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2631, 'language', 3, 'Language created. <br/><br/>Language Name: Arabic', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2632, 'language', 4, 'Language created. <br/><br/>Language Name: Assamese', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2633, 'language', 5, 'Language created. <br/><br/>Language Name: Azerbaijani', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2634, 'language', 6, 'Language created. <br/><br/>Language Name: Belarusian', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2635, 'language', 7, 'Language created. <br/><br/>Language Name: Bulgarian', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2636, 'language', 8, 'Language created. <br/><br/>Language Name: Bhojpuri', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2637, 'language', 9, 'Language created. <br/><br/>Language Name: Bengali', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2638, 'language', 10, 'Language created. <br/><br/>Language Name: Bosnian', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2639, 'language', 11, 'Language created. <br/><br/>Language Name: Catalan, Valencian', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2640, 'language', 12, 'Language created. <br/><br/>Language Name: Cebuano', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2641, 'language', 13, 'Language created. <br/><br/>Language Name: Czech', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2642, 'language', 14, 'Language created. <br/><br/>Language Name: Danish', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2643, 'language', 15, 'Language created. <br/><br/>Language Name: German', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2644, 'language', 16, 'Language created. <br/><br/>Language Name: English', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2645, 'language', 17, 'Language created. <br/><br/>Language Name: Ewe', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2646, 'language', 18, 'Language created. <br/><br/>Language Name: Greek, Modern', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2647, 'language', 19, 'Language created. <br/><br/>Language Name: Spanish', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2648, 'language', 20, 'Language created. <br/><br/>Language Name: Estonian', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2649, 'language', 21, 'Language created. <br/><br/>Language Name: Basque', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2650, 'language', 22, 'Language created. <br/><br/>Language Name: Persian', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2651, 'language', 23, 'Language created. <br/><br/>Language Name: Fula', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2652, 'language', 24, 'Language created. <br/><br/>Language Name: Finnish', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2653, 'language', 25, 'Language created. <br/><br/>Language Name: French', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2654, 'language', 26, 'Language created. <br/><br/>Language Name: Irish', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2655, 'language', 27, 'Language created. <br/><br/>Language Name: Galician', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2656, 'language', 28, 'Language created. <br/><br/>Language Name: Guarani', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2657, 'language', 29, 'Language created. <br/><br/>Language Name: Gujarati', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2658, 'language', 30, 'Language created. <br/><br/>Language Name: Hausa', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2659, 'language', 31, 'Language created. <br/><br/>Language Name: Haitian Creole', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2660, 'language', 32, 'Language created. <br/><br/>Language Name: Hebrew (modern)', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2661, 'language', 33, 'Language created. <br/><br/>Language Name: Hindi', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2662, 'language', 34, 'Language created. <br/><br/>Language Name: Chhattisgarhi', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2663, 'language', 35, 'Language created. <br/><br/>Language Name: Croatian', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2664, 'language', 36, 'Language created. <br/><br/>Language Name: Hungarian', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2665, 'language', 37, 'Language created. <br/><br/>Language Name: Armenian', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2666, 'language', 38, 'Language created. <br/><br/>Language Name: Indonesian', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2667, 'language', 39, 'Language created. <br/><br/>Language Name: Igbo', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2668, 'language', 40, 'Language created. <br/><br/>Language Name: Icelandic', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2669, 'language', 41, 'Language created. <br/><br/>Language Name: Italian', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2670, 'language', 42, 'Language created. <br/><br/>Language Name: Japanese', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2671, 'language', 43, 'Language created. <br/><br/>Language Name: Syro-Palestinian Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2672, 'language', 44, 'Language created. <br/><br/>Language Name: Javanese', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2673, 'language', 45, 'Language created. <br/><br/>Language Name: Georgian', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2674, 'language', 46, 'Language created. <br/><br/>Language Name: Kikuyu', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2675, 'language', 47, 'Language created. <br/><br/>Language Name: Kyrgyz', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2676, 'language', 48, 'Language created. <br/><br/>Language Name: Kuanyama', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2677, 'language', 49, 'Language created. <br/><br/>Language Name: Kazakh', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2678, 'language', 50, 'Language created. <br/><br/>Language Name: Khmer', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2679, 'language', 51, 'Language created. <br/><br/>Language Name: Kannada', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2680, 'language', 52, 'Language created. <br/><br/>Language Name: Korean', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2681, 'language', 53, 'Language created. <br/><br/>Language Name: Krio', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2682, 'language', 54, 'Language created. <br/><br/>Language Name: Kashmiri', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2683, 'language', 55, 'Language created. <br/><br/>Language Name: Kurdish', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2684, 'language', 56, 'Language created. <br/><br/>Language Name: Latin', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2685, 'language', 57, 'Language created. <br/><br/>Language Name: Lithuanian', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2686, 'language', 58, 'Language created. <br/><br/>Language Name: Luxembourgish', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2687, 'language', 59, 'Language created. <br/><br/>Language Name: Latvian', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2688, 'language', 60, 'Language created. <br/><br/>Language Name: Magahi', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2689, 'language', 61, 'Language created. <br/><br/>Language Name: Maithili', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2690, 'language', 62, 'Language created. <br/><br/>Language Name: Malagasy', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2691, 'language', 63, 'Language created. <br/><br/>Language Name: Macedonian', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2692, 'language', 64, 'Language created. <br/><br/>Language Name: Malayalam', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2693, 'language', 65, 'Language created. <br/><br/>Language Name: Mongolian', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2694, 'language', 66, 'Language created. <br/><br/>Language Name: Marathi (Marāṭhī)', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2695, 'language', 67, 'Language created. <br/><br/>Language Name: Malay', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2696, 'language', 68, 'Language created. <br/><br/>Language Name: Maltese', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2697, 'language', 69, 'Language created. <br/><br/>Language Name: Burmese', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2698, 'language', 70, 'Language created. <br/><br/>Language Name: Nepali', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2699, 'language', 71, 'Language created. <br/><br/>Language Name: Dutch', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2700, 'language', 72, 'Language created. <br/><br/>Language Name: Norwegian', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2701, 'language', 73, 'Language created. <br/><br/>Language Name: Oromo', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2702, 'language', 74, 'Language created. <br/><br/>Language Name: Odia', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2703, 'language', 75, 'Language created. <br/><br/>Language Name: Oromo', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2704, 'language', 76, 'Language created. <br/><br/>Language Name: Panjabi, Punjabi', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2705, 'language', 77, 'Language created. <br/><br/>Language Name: Polish', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2706, 'language', 78, 'Language created. <br/><br/>Language Name: Pashto', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2707, 'language', 79, 'Language created. <br/><br/>Language Name: Portuguese', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2708, 'language', 80, 'Language created. <br/><br/>Language Name: Rundi', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2709, 'language', 81, 'Language created. <br/><br/>Language Name: Romanian, Moldavian, Moldovan', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2710, 'language', 82, 'Language created. <br/><br/>Language Name: Russian', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2711, 'language', 83, 'Language created. <br/><br/>Language Name: Kinyarwanda', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2712, 'language', 84, 'Language created. <br/><br/>Language Name: Sindhi', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2713, 'language', 85, 'Language created. <br/><br/>Language Name: Argentine Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2714, 'language', 86, 'Language created. <br/><br/>Language Name: Brazilian Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2715, 'language', 87, 'Language created. <br/><br/>Language Name: Chinese Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2716, 'language', 88, 'Language created. <br/><br/>Language Name: Colombian Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2717, 'language', 89, 'Language created. <br/><br/>Language Name: German Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2718, 'language', 90, 'Language created. <br/><br/>Language Name: Algerian Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2719, 'language', 91, 'Language created. <br/><br/>Language Name: Ecuadorian Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2720, 'language', 92, 'Language created. <br/><br/>Language Name: Spanish Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2721, 'language', 93, 'Language created. <br/><br/>Language Name: Ethiopian Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2722, 'language', 94, 'Language created. <br/><br/>Language Name: French Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2723, 'language', 95, 'Language created. <br/><br/>Language Name: British Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2724, 'language', 96, 'Language created. <br/><br/>Language Name: Ghanaian Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2725, 'language', 97, 'Language created. <br/><br/>Language Name: Irish Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2726, 'language', 98, 'Language created. <br/><br/>Language Name: Indopakistani Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2727, 'language', 99, 'Language created. <br/><br/>Language Name: Persian Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2728, 'language', 100, 'Language created. <br/><br/>Language Name: Italian Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2729, 'language', 101, 'Language created. <br/><br/>Language Name: Japanese Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2730, 'language', 102, 'Language created. <br/><br/>Language Name: Kenyan Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2731, 'language', 103, 'Language created. <br/><br/>Language Name: Korean Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2732, 'language', 104, 'Language created. <br/><br/>Language Name: Moroccan Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2733, 'language', 105, 'Language created. <br/><br/>Language Name: Mexican Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2734, 'language', 106, 'Language created. <br/><br/>Language Name: Malaysian Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2735, 'language', 107, 'Language created. <br/><br/>Language Name: Philippine Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2736, 'language', 108, 'Language created. <br/><br/>Language Name: Polish Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2737, 'language', 109, 'Language created. <br/><br/>Language Name: Portuguese Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2738, 'language', 110, 'Language created. <br/><br/>Language Name: Russian Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2739, 'language', 111, 'Language created. <br/><br/>Language Name: Saudi Arabian Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2740, 'language', 112, 'Language created. <br/><br/>Language Name: El Salvadoran Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2741, 'language', 113, 'Language created. <br/><br/>Language Name: Turkish Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2742, 'language', 114, 'Language created. <br/><br/>Language Name: Tanzanian Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2743, 'language', 115, 'Language created. <br/><br/>Language Name: Ukrainian Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2744, 'language', 116, 'Language created. <br/><br/>Language Name: American Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2745, 'language', 117, 'Language created. <br/><br/>Language Name: South African Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2746, 'language', 118, 'Language created. <br/><br/>Language Name: Zimbabwe Sign Language', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2747, 'language', 119, 'Language created. <br/><br/>Language Name: Sinhala, Sinhalese', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2748, 'language', 120, 'Language created. <br/><br/>Language Name: Slovak', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2749, 'language', 121, 'Language created. <br/><br/>Language Name: Saraiki', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2750, 'language', 122, 'Language created. <br/><br/>Language Name: Slovene', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2751, 'language', 123, 'Language created. <br/><br/>Language Name: Shona', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2752, 'language', 124, 'Language created. <br/><br/>Language Name: Somali', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2753, 'language', 125, 'Language created. <br/><br/>Language Name: Albanian', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2754, 'language', 126, 'Language created. <br/><br/>Language Name: Serbian', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2755, 'language', 127, 'Language created. <br/><br/>Language Name: Swati', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2756, 'language', 128, 'Language created. <br/><br/>Language Name: Sunda', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2757, 'language', 129, 'Language created. <br/><br/>Language Name: Swedish', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2758, 'language', 130, 'Language created. <br/><br/>Language Name: Swahili', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2759, 'language', 131, 'Language created. <br/><br/>Language Name: Sylheti', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2760, 'language', 132, 'Language created. <br/><br/>Language Name: Tagalog', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2761, 'language', 133, 'Language created. <br/><br/>Language Name: Tamil', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2762, 'language', 134, 'Language created. <br/><br/>Language Name: Telugu', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2763, 'language', 135, 'Language created. <br/><br/>Language Name: Thai', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2764, 'language', 136, 'Language created. <br/><br/>Language Name: Tibetan', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2765, 'language', 137, 'Language created. <br/><br/>Language Name: Tigrinya', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2766, 'language', 138, 'Language created. <br/><br/>Language Name: Turkmen', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2767, 'language', 139, 'Language created. <br/><br/>Language Name: Tswana', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2768, 'language', 140, 'Language created. <br/><br/>Language Name: Turkish', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2769, 'language', 141, 'Language created. <br/><br/>Language Name: Uyghur', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2770, 'language', 142, 'Language created. <br/><br/>Language Name: Ukrainian', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2771, 'language', 143, 'Language created. <br/><br/>Language Name: Urdu', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2772, 'language', 144, 'Language created. <br/><br/>Language Name: Uzbek', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2773, 'language', 145, 'Language created. <br/><br/>Language Name: Vietnamese', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2774, 'language', 146, 'Language created. <br/><br/>Language Name: Xhosa', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2775, 'language', 147, 'Language created. <br/><br/>Language Name: Yiddish', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2776, 'language', 148, 'Language created. <br/><br/>Language Name: Yoruba', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2777, 'language', 149, 'Language created. <br/><br/>Language Name: Cantonese', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2778, 'language', 150, 'Language created. <br/><br/>Language Name: Chinese', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2779, 'language', 151, 'Language created. <br/><br/>Language Name: Zulu', 1, '2024-07-03 11:02:53', '2024-07-03 11:02:53'),
(2780, 'relation', 1, 'Relation created. <br/><br/>Relation Name: test', 2, '2024-07-03 11:11:54', '2024-07-03 11:11:54'),
(2781, 'relation', 1, 'Relation Name: test -> test2<br/>', 2, '2024-07-03 11:11:58', '2024-07-03 11:11:58'),
(2782, 'relation', 2, 'Relation created. <br/><br/>Relation Name: test3', 2, '2024-07-03 11:12:01', '2024-07-03 11:12:01'),
(2783, 'relation', 3, 'Relation created. <br/><br/>Relation Name: test', 2, '2024-07-03 11:12:03', '2024-07-03 11:12:03'),
(2784, 'relation', 1, 'Relation created. <br/><br/>Relation Name: Aunt', 2, '2024-07-03 11:13:01', '2024-07-03 11:13:01'),
(2785, 'relation', 2, 'Relation created. <br/><br/>Relation Name: Brother', 2, '2024-07-03 11:13:06', '2024-07-03 11:13:06'),
(2786, 'relation', 3, 'Relation created. <br/><br/>Relation Name: Cousin', 2, '2024-07-03 11:13:11', '2024-07-03 11:13:11'),
(2787, 'relation', 4, 'Relation created. <br/><br/>Relation Name: Daughter', 2, '2024-07-03 11:13:14', '2024-07-03 11:13:14'),
(2788, 'relation', 5, 'Relation created. <br/><br/>Relation Name: Father', 2, '2024-07-03 11:13:18', '2024-07-03 11:13:18'),
(2789, 'relation', 6, 'Relation created. <br/><br/>Relation Name: Friend', 2, '2024-07-03 11:13:24', '2024-07-03 11:13:24'),
(2790, 'relation', 7, 'Relation created. <br/><br/>Relation Name: Grandchild', 2, '2024-07-03 11:13:29', '2024-07-03 11:13:29'),
(2791, 'relation', 8, 'Relation created. <br/><br/>Relation Name: Grandparent', 2, '2024-07-03 11:13:32', '2024-07-03 11:13:32'),
(2792, 'relation', 9, 'Relation created. <br/><br/>Relation Name: Mother', 2, '2024-07-03 11:13:36', '2024-07-03 11:13:36'),
(2793, 'relation', 10, 'Relation created. <br/><br/>Relation Name: Partner', 2, '2024-07-03 11:13:39', '2024-07-03 11:13:39'),
(2794, 'relation', 11, 'Relation created. <br/><br/>Relation Name: Roommate', 2, '2024-07-03 11:13:44', '2024-07-03 11:13:44'),
(2795, 'relation', 12, 'Relation created. <br/><br/>Relation Name: Sister', 2, '2024-07-03 11:13:50', '2024-07-03 11:13:50');
INSERT INTO `audit_log` (`audit_log_id`, `table_name`, `reference_id`, `log`, `changed_by`, `changed_at`, `created_date`) VALUES
(2796, 'relation', 13, 'Relation created. <br/><br/>Relation Name: Son', 2, '2024-07-03 11:13:54', '2024-07-03 11:13:54'),
(2797, 'relation', 14, 'Relation created. <br/><br/>Relation Name: Spouse', 2, '2024-07-03 11:13:58', '2024-07-03 11:13:58'),
(2798, 'relation', 15, 'Relation created. <br/><br/>Relation Name: Uncle', 2, '2024-07-03 11:14:02', '2024-07-03 11:14:02'),
(2799, 'religion', 1, 'Religion created. <br/><br/>Religion Name: test', 2, '2024-07-03 11:14:36', '2024-07-03 11:14:36'),
(2800, 'religion', 1, 'Religion Name: test -> test2<br/>', 2, '2024-07-03 11:14:38', '2024-07-03 11:14:38'),
(2801, 'religion', 2, 'Religion created. <br/><br/>Religion Name: test3', 2, '2024-07-03 11:14:42', '2024-07-03 11:14:42'),
(2802, 'religion', 3, 'Religion created. <br/><br/>Religion Name: test4', 2, '2024-07-03 11:14:45', '2024-07-03 11:14:45'),
(2803, 'religion', 1, 'Religion created. <br/><br/>Religion Name: Aglipayan Church', 2, '2024-07-03 11:16:35', '2024-07-03 11:16:35'),
(2804, 'religion', 2, 'Religion created. <br/><br/>Religion Name: Atheist', 2, '2024-07-03 11:16:39', '2024-07-03 11:16:39'),
(2805, 'religion', 3, 'Religion created. <br/><br/>Religion Name: Baptists', 2, '2024-07-03 11:16:43', '2024-07-03 11:16:43'),
(2806, 'religion', 4, 'Religion created. <br/><br/>Religion Name: Buddhism', 2, '2024-07-03 11:16:49', '2024-07-03 11:16:49'),
(2807, 'religion', 5, 'Religion created. <br/><br/>Religion Name: Hinduism', 2, '2024-07-03 11:16:53', '2024-07-03 11:16:53'),
(2808, 'religion', 6, 'Religion created. <br/><br/>Religion Name: Iglesia ni Cristo', 2, '2024-07-03 11:16:57', '2024-07-03 11:16:57'),
(2809, 'religion', 7, 'Religion created. <br/><br/>Religion Name: Indigenous Beliefs', 2, '2024-07-03 11:17:00', '2024-07-03 11:17:00'),
(2810, 'religion', 8, 'Religion created. <br/><br/>Religion Name: Islam', 2, '2024-07-03 11:17:04', '2024-07-03 11:17:04'),
(2811, 'religion', 9, 'Religion created. <br/><br/>Religion Name: Members Church of God International', 2, '2024-07-03 11:17:08', '2024-07-03 11:17:08'),
(2812, 'religion', 10, 'Religion created. <br/><br/>Religion Name: Methodists', 2, '2024-07-03 11:17:12', '2024-07-03 11:17:12'),
(2813, 'religion', 11, 'Religion created. <br/><br/>Religion Name: Pentecostals', 2, '2024-07-03 11:17:17', '2024-07-03 11:17:17'),
(2814, 'religion', 12, 'Religion created. <br/><br/>Religion Name: Roman Catholic', 2, '2024-07-03 11:17:21', '2024-07-03 11:17:21'),
(2815, 'bank_account_type', 1, 'Bank account type created. <br/><br/>Bank Account Type Name: test', 2, '2024-07-03 11:38:55', '2024-07-03 11:38:55'),
(2816, 'bank_account_type', 2, 'Bank account type created. <br/><br/>Bank Account Type Name: test2', 2, '2024-07-03 11:38:59', '2024-07-03 11:38:59'),
(2817, 'bank_account_type', 3, 'Bank account type created. <br/><br/>Bank Account Type Name: test3', 2, '2024-07-03 11:39:03', '2024-07-03 11:39:03'),
(2818, 'bank_account_type', 3, 'Bank Account Type Name: test3 -> test34<br/>', 2, '2024-07-03 11:39:08', '2024-07-03 11:39:08'),
(2819, 'bank_account_type', 1, 'Bank account type created. <br/><br/>Bank Account Type Name: test', 2, '2024-07-03 11:40:43', '2024-07-03 11:40:43'),
(2820, 'bank_account_type', 1, 'Bank account type created. <br/><br/>Bank Account Type Name: Checking Account', 2, '2024-07-03 11:42:43', '2024-07-03 11:42:43'),
(2821, 'bank_account_type', 2, 'Bank account type created. <br/><br/>Bank Account Type Name: Savings Account', 2, '2024-07-03 11:42:56', '2024-07-03 11:42:56'),
(2822, 'contact_information_type', 1, 'Contact information type created. <br/><br/>Contact Information Type Name: test', 2, '2024-07-03 11:58:03', '2024-07-03 11:58:03'),
(2823, 'contact_information_type', 2, 'Contact information type created. <br/><br/>Contact Information Type Name: test2', 2, '2024-07-03 11:58:06', '2024-07-03 11:58:06'),
(2824, 'contact_information_type', 2, 'Contact Information Type Name: test2 -> test23<br/>', 2, '2024-07-03 11:58:08', '2024-07-03 11:58:08'),
(2825, 'contact_information_type', 3, 'Contact information type created. <br/><br/>Contact Information Type Name: test4', 2, '2024-07-03 11:58:11', '2024-07-03 11:58:11'),
(2826, 'contact_information_type', 1, 'Contact information type created. <br/><br/>Contact Information Type Name: Personal', 2, '2024-07-03 11:59:46', '2024-07-03 11:59:46'),
(2827, 'contact_information_type', 2, 'Contact information type created. <br/><br/>Contact Information Type Name: Work', 2, '2024-07-03 11:59:50', '2024-07-03 11:59:50'),
(2828, 'language_proficiency', 1, 'Language proficiency created. <br/><br/>Language Proficiency Name: test<br/>Language Proficiency Description: test', 2, '2024-07-03 12:53:31', '2024-07-03 12:53:31'),
(2829, 'language_proficiency', 1, 'Language Proficiency Name: test -> test2<br/>Language Proficiency Description: test -> test2<br/>', 2, '2024-07-03 12:53:35', '2024-07-03 12:53:35'),
(2830, 'language_proficiency', 1, 'Language Proficiency Name: test2 -> test23<br/>Language Proficiency Description: test2 -> test23<br/>', 2, '2024-07-03 13:19:03', '2024-07-03 13:19:03'),
(2831, 'language_proficiency', 2, 'Language proficiency created. <br/><br/>Language Proficiency Name: test<br/>Language Proficiency Description: test', 2, '2024-07-03 13:19:06', '2024-07-03 13:19:06'),
(2832, 'language_proficiency', 3, 'Language proficiency created. <br/><br/>Language Proficiency Name: test3<br/>Language Proficiency Description: tres3', 2, '2024-07-03 13:19:13', '2024-07-03 13:19:13'),
(2833, 'language_proficiency', 1, 'Language proficiency created. <br/><br/>Language Proficiency Name: Basic<br/>Language Proficiency Description: Only able to communicate in this language through written communication.', 2, '2024-07-03 13:20:14', '2024-07-03 13:20:14'),
(2834, 'language_proficiency', 2, 'Language proficiency created. <br/><br/>Language Proficiency Name: Advanced<br/>Language Proficiency Description: Proficient in this language, can handle complex discussions and tasks.', 2, '2024-07-03 13:20:23', '2024-07-03 13:20:23'),
(2835, 'language_proficiency', 3, 'Language proficiency created. <br/><br/>Language Proficiency Name: Conversational<br/>Language Proficiency Description: Know this language well enough to verbally discuss basic topics.', 2, '2024-07-03 13:20:30', '2024-07-03 13:20:30'),
(2836, 'language_proficiency', 4, 'Language proficiency created. <br/><br/>Language Proficiency Name: Fluent<br/>Language Proficiency Description: Mastery level, can speak and understand this language at a native level.', 2, '2024-07-03 13:20:38', '2024-07-03 13:20:38'),
(2837, 'language_proficiency', 5, 'Language proficiency created. <br/><br/>Language Proficiency Name: Intermediate<br/>Language Proficiency Description: Can comfortably converse in this language on a variety of topics.', 2, '2024-07-03 13:20:49', '2024-07-03 13:20:49'),
(2838, 'bank', 1, 'Bank created. <br/><br/>Bank Name: test<br/>Bank Identifier Code: test', 2, '2024-07-03 13:49:11', '2024-07-03 13:49:11'),
(2839, 'bank', 1, 'Bank Name: test -> test2<br/>Bank Identifier Code: test -> test2<br/>', 2, '2024-07-03 13:50:34', '2024-07-03 13:50:34'),
(2840, 'bank', 1, 'Bank Name: test2 -> test22<br/>Bank Identifier Code: test2 -> test22<br/>', 2, '2024-07-03 13:50:38', '2024-07-03 13:50:38'),
(2841, 'bank', 2, 'Bank created. <br/><br/>Bank Name: test<br/>Bank Identifier Code: test', 2, '2024-07-03 13:50:43', '2024-07-03 13:50:43'),
(2842, 'bank', 3, 'Bank created. <br/><br/>Bank Name: test<br/>Bank Identifier Code: test', 2, '2024-07-03 13:50:46', '2024-07-03 13:50:46'),
(2843, 'bank', 1, 'Bank created. <br/><br/>Bank Name: Banco de Oro (BDO)<br/>Bank Identifier Code: 010530667', 2, '2024-07-03 13:54:41', '2024-07-03 13:54:41'),
(2844, 'bank', 2, 'Bank created. <br/><br/>Bank Name: Metrobank<br/>Bank Identifier Code: 010269996', 2, '2024-07-03 13:54:52', '2024-07-03 13:54:52'),
(2845, 'bank', 3, 'Bank created. <br/><br/>Bank Name: Land Bank of the Philippines<br/>Bank Identifier Code: 010350025', 2, '2024-07-03 13:55:00', '2024-07-03 13:55:00'),
(2846, 'bank', 4, 'Bank created. <br/><br/>Bank Name: Bank of the Philippine Islands (BPI)<br/>Bank Identifier Code: 010040018', 2, '2024-07-03 13:55:07', '2024-07-03 13:55:07'),
(2847, 'bank', 5, 'Bank created. <br/><br/>Bank Name: Philippine National Bank (PNB)<br/>Bank Identifier Code: 010080010', 2, '2024-07-03 13:55:19', '2024-07-03 13:55:19'),
(2848, 'bank', 6, 'Bank created. <br/><br/>Bank Name: Security Bank<br/>Bank Identifier Code: 010140015', 2, '2024-07-03 13:55:27', '2024-07-03 13:55:27'),
(2849, 'bank', 7, 'Bank created. <br/><br/>Bank Name: UnionBank of the Philippines<br/>Bank Identifier Code: 010419995', 2, '2024-07-03 13:55:36', '2024-07-03 13:55:36'),
(2850, 'bank', 8, 'Bank created. <br/><br/>Bank Name: Development Bank of the Philippines (DBP)<br/>Bank Identifier Code: 010590018', 2, '2024-07-03 13:55:44', '2024-07-03 13:55:44'),
(2851, 'bank', 9, 'Bank created. <br/><br/>Bank Name: EastWest Bank<br/>Bank Identifier Code: 010620014', 2, '2024-07-03 13:55:52', '2024-07-03 13:55:52'),
(2852, 'bank', 10, 'Bank created. <br/><br/>Bank Name: China Banking Corporation (Chinabank)<br/>Bank Identifier Code: 010100013', 2, '2024-07-03 13:56:00', '2024-07-03 13:56:00'),
(2853, 'bank', 11, 'Bank created. <br/><br/>Bank Name: RCBC (Rizal Commercial Banking Corporation)<br/>Bank Identifier Code: 010280014', 2, '2024-07-03 13:56:12', '2024-07-03 13:56:12'),
(2854, 'bank', 12, 'Bank created. <br/><br/>Bank Name: Maybank Philippines<br/>Bank Identifier Code: 010220016', 2, '2024-07-03 13:56:19', '2024-07-03 13:56:19'),
(2855, 'department', 1, 'Department created. <br/><br/>Department Name: test', 2, '2024-07-03 15:58:20', '2024-07-03 15:58:20'),
(2856, 'department', 2, 'Department created. <br/><br/>Department Name: testing', 2, '2024-07-03 15:58:32', '2024-07-03 15:58:32'),
(2857, 'department', 2, 'Parent Department Name: test -> <br/>', 2, '2024-07-03 16:02:39', '2024-07-03 16:02:39'),
(2858, 'department', 3, 'Department created. <br/><br/>Department Name: test', 2, '2024-07-03 16:03:52', '2024-07-03 16:03:52'),
(2859, 'department', 3, 'Parent Department Name:  -> testing<br/>', 2, '2024-07-03 16:05:51', '2024-07-03 16:05:51'),
(2860, 'department', 3, 'Parent Department Name: testing -> testings<br/>', 2, '2024-07-03 16:06:26', '2024-07-03 16:06:26'),
(2861, 'department', 2, 'Department Name: testing -> testings<br/>', 2, '2024-07-03 16:06:26', '2024-07-03 16:06:26'),
(2862, 'menu_item', 24, 'Menu Group Name: Employee Configuration -> Employee Configurations<br/>', 2, '2024-07-03 16:59:00', '2024-07-03 16:59:00'),
(2863, 'menu_item', 25, 'Menu Group Name: Employee Configuration -> Employee Configurations<br/>', 2, '2024-07-03 16:59:00', '2024-07-03 16:59:00'),
(2864, 'menu_item', 26, 'Menu Group Name: Employee Configuration -> Employee Configurations<br/>', 2, '2024-07-03 16:59:00', '2024-07-03 16:59:00'),
(2865, 'menu_item', 27, 'Menu Group Name: Employee Configuration -> Employee Configurations<br/>', 2, '2024-07-03 16:59:00', '2024-07-03 16:59:00'),
(2866, 'menu_item', 28, 'Menu Group Name: Employee Configuration -> Employee Configurations<br/>', 2, '2024-07-03 16:59:00', '2024-07-03 16:59:00'),
(2867, 'menu_item', 29, 'Menu Group Name: Employee Configuration -> Employee Configurations<br/>', 2, '2024-07-03 16:59:00', '2024-07-03 16:59:00'),
(2868, 'menu_item', 30, 'Menu Group Name: Employee Configuration -> Employee Configurations<br/>', 2, '2024-07-03 16:59:00', '2024-07-03 16:59:00'),
(2869, 'menu_item', 31, 'Menu Group Name: Employee Configuration -> Employee Configurations<br/>', 2, '2024-07-03 16:59:00', '2024-07-03 16:59:00'),
(2870, 'menu_group', 6, 'Menu Group Name: Employee Configuration -> Employee Configurations<br/>', 2, '2024-07-03 16:59:00', '2024-07-03 16:59:00');

-- --------------------------------------------------------

--
-- Table structure for table `bank`
--

DROP TABLE IF EXISTS `bank`;
CREATE TABLE `bank` (
  `bank_id` int(10) UNSIGNED NOT NULL,
  `bank_name` varchar(100) NOT NULL,
  `bank_identifier_code` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bank`
--

INSERT INTO `bank` (`bank_id`, `bank_name`, `bank_identifier_code`, `created_date`, `last_log_by`) VALUES
(1, 'Banco de Oro (BDO)', '010530667', '2024-07-03 13:54:41', 2),
(2, 'Metrobank', '010269996', '2024-07-03 13:54:52', 2),
(3, 'Land Bank of the Philippines', '010350025', '2024-07-03 13:55:00', 2),
(4, 'Bank of the Philippine Islands (BPI)', '010040018', '2024-07-03 13:55:07', 2),
(5, 'Philippine National Bank (PNB)', '010080010', '2024-07-03 13:55:19', 2),
(6, 'Security Bank', '010140015', '2024-07-03 13:55:27', 2),
(7, 'UnionBank of the Philippines', '010419995', '2024-07-03 13:55:36', 2),
(8, 'Development Bank of the Philippines (DBP)', '010590018', '2024-07-03 13:55:44', 2),
(9, 'EastWest Bank', '010620014', '2024-07-03 13:55:52', 2),
(10, 'China Banking Corporation (Chinabank)', '010100013', '2024-07-03 13:56:00', 2),
(11, 'RCBC (Rizal Commercial Banking Corporation)', '010280014', '2024-07-03 13:56:12', 2),
(12, 'Maybank Philippines', '010220016', '2024-07-03 13:56:19', 2);

--
-- Triggers `bank`
--
DROP TRIGGER IF EXISTS `bank_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `bank_trigger_insert` AFTER INSERT ON `bank` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Bank created. <br/>';

    IF NEW.bank_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Bank Name: ", NEW.bank_name);
    END IF;

    IF NEW.bank_identifier_code <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Bank Identifier Code: ", NEW.bank_identifier_code);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('bank', NEW.bank_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `bank_trigger_update`;
DELIMITER $$
CREATE TRIGGER `bank_trigger_update` AFTER UPDATE ON `bank` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.bank_name <> OLD.bank_name THEN
        SET audit_log = CONCAT(audit_log, "Bank Name: ", OLD.bank_name, " -> ", NEW.bank_name, "<br/>");
    END IF;

    IF NEW.bank_identifier_code <> OLD.bank_identifier_code THEN
        SET audit_log = CONCAT(audit_log, "Bank Identifier Code: ", OLD.bank_identifier_code, " -> ", NEW.bank_identifier_code, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('bank', NEW.bank_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `bank_account_type`
--

DROP TABLE IF EXISTS `bank_account_type`;
CREATE TABLE `bank_account_type` (
  `bank_account_type_id` int(10) UNSIGNED NOT NULL,
  `bank_account_type_name` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `bank_account_type`
--

INSERT INTO `bank_account_type` (`bank_account_type_id`, `bank_account_type_name`, `created_date`, `last_log_by`) VALUES
(1, 'Checking Account', '2024-07-03 11:42:43', 2),
(2, 'Savings Account', '2024-07-03 11:42:56', 2);

--
-- Triggers `bank_account_type`
--
DROP TRIGGER IF EXISTS `bank_account_type_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `bank_account_type_trigger_insert` AFTER INSERT ON `bank_account_type` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Bank account type created. <br/>';

    IF NEW.bank_account_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Bank Account Type Name: ", NEW.bank_account_type_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('bank_account_type', NEW.bank_account_type_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `bank_account_type_trigger_update`;
DELIMITER $$
CREATE TRIGGER `bank_account_type_trigger_update` AFTER UPDATE ON `bank_account_type` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.bank_account_type_name <> OLD.bank_account_type_name THEN
        SET audit_log = CONCAT(audit_log, "Bank Account Type Name: ", OLD.bank_account_type_name, " -> ", NEW.bank_account_type_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('bank_account_type', NEW.bank_account_type_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `blood_type`
--

DROP TABLE IF EXISTS `blood_type`;
CREATE TABLE `blood_type` (
  `blood_type_id` int(10) UNSIGNED NOT NULL,
  `blood_type_name` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `blood_type`
--

INSERT INTO `blood_type` (`blood_type_id`, `blood_type_name`, `created_date`, `last_log_by`) VALUES
(1, 'A+', '2024-07-03 09:55:30', 2),
(2, 'A-', '2024-07-03 09:55:36', 2),
(3, 'AB+', '2024-07-03 09:55:41', 2),
(4, 'AB-', '2024-07-03 09:55:46', 2),
(5, 'B+', '2024-07-03 09:55:51', 2),
(6, 'B-', '2024-07-03 09:55:56', 2),
(7, 'O+', '2024-07-03 09:56:01', 2),
(8, 'O-', '2024-07-03 09:56:07', 2);

--
-- Triggers `blood_type`
--
DROP TRIGGER IF EXISTS `blood_type_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `blood_type_trigger_insert` AFTER INSERT ON `blood_type` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Blood type created. <br/>';

    IF NEW.blood_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Blood Type Name: ", NEW.blood_type_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('blood_type', NEW.blood_type_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `blood_type_trigger_update`;
DELIMITER $$
CREATE TRIGGER `blood_type_trigger_update` AFTER UPDATE ON `blood_type` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.blood_type_name <> OLD.blood_type_name THEN
        SET audit_log = CONCAT(audit_log, "Blood Type Name: ", OLD.blood_type_name, " -> ", NEW.blood_type_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('blood_type', NEW.blood_type_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

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
(1, 'Adams', 2, 'Ilocos Norte', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(2, 'Bacarra', 2, 'Ilocos Norte', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(3, 'Badoc', 2, 'Ilocos Norte', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(4, 'Bangui', 2, 'Ilocos Norte', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(5, 'City of Batac', 2, 'Ilocos Norte', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(6, 'Burgos', 2, 'Ilocos Norte', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(7, 'Carasi', 2, 'Ilocos Norte', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(8, 'Currimao', 2, 'Ilocos Norte', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(9, 'Dingras', 2, 'Ilocos Norte', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(10, 'Dumalneg', 2, 'Ilocos Norte', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(11, 'Banna', 2, 'Ilocos Norte', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(12, 'City of Laoag', 2, 'Ilocos Norte', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(13, 'Marcos', 2, 'Ilocos Norte', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(14, 'Nueva Era', 2, 'Ilocos Norte', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(15, 'Pagudpud', 2, 'Ilocos Norte', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(16, 'Paoay', 2, 'Ilocos Norte', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(17, 'Pasuquin', 2, 'Ilocos Norte', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(18, 'Piddig', 2, 'Ilocos Norte', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(19, 'Pinili', 2, 'Ilocos Norte', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(20, 'San Nicolas', 2, 'Ilocos Norte', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(21, 'Sarrat', 2, 'Ilocos Norte', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(22, 'Solsona', 2, 'Ilocos Norte', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(23, 'Vintar', 2, 'Ilocos Norte', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(24, 'Alilem', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(25, 'Banayoyo', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(26, 'Bantay', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(27, 'Burgos', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(28, 'Cabugao', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(29, 'City of Candon', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(30, 'Caoayan', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(31, 'Cervantes', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(32, 'Galimuyod', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(33, 'Gregorio del Pilar', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(34, 'Lidlidda', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(35, 'Magsingal', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(36, 'Nagbukel', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(37, 'Narvacan', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(38, 'Quirino', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(39, 'Salcedo', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(40, 'San Emilio', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(41, 'San Esteban', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(42, 'San Ildefonso', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(43, 'San Juan', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(44, 'San Vicente', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(45, 'Santa', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(46, 'Santa Catalina', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(47, 'Santa Cruz', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(48, 'Santa Lucia', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(49, 'Santa Maria', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(50, 'Santiago', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(51, 'Santo Domingo', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(52, 'Sigay', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(53, 'Sinait', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(54, 'Sugpon', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(55, 'Suyo', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(56, 'Tagudin', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(57, 'City of Vigan', 3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(58, 'Agoo', 4, 'La Union', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(59, 'Aringay', 4, 'La Union', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(60, 'Bacnotan', 4, 'La Union', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(61, 'Bagulin', 4, 'La Union', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(62, 'Balaoan', 4, 'La Union', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(63, 'Bangar', 4, 'La Union', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(64, 'Bauang', 4, 'La Union', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(65, 'Burgos', 4, 'La Union', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(66, 'Caba', 4, 'La Union', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(67, 'Luna', 4, 'La Union', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(68, 'Naguilian', 4, 'La Union', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(69, 'Pugo', 4, 'La Union', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(70, 'Rosario', 4, 'La Union', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(71, 'City of San Fernando', 4, 'La Union', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(72, 'San Gabriel', 4, 'La Union', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(73, 'San Juan', 4, 'La Union', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(74, 'Santo Tomas', 4, 'La Union', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(75, 'Santol', 4, 'La Union', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(76, 'Sudipen', 4, 'La Union', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(77, 'Tubao', 4, 'La Union', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(78, 'Agno', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(79, 'Aguilar', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(80, 'City of Alaminos', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(81, 'Alcala', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(82, 'Anda', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(83, 'Asingan', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(84, 'Balungao', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(85, 'Bani', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(86, 'Basista', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(87, 'Bautista', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(88, 'Bayambang', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(89, 'Binalonan', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(90, 'Binmaley', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(91, 'Bolinao', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(92, 'Bugallon', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(93, 'Burgos', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(94, 'Calasiao', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(95, 'City of Dagupan', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(96, 'Dasol', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(97, 'Infanta', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(98, 'Labrador', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(99, 'Lingayen', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(100, 'Mabini', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(101, 'Malasiqui', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(102, 'Manaoag', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(103, 'Mangaldan', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(104, 'Mangatarem', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(105, 'Mapandan', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(106, 'Natividad', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(107, 'Pozorrubio', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(108, 'Rosales', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(109, 'City of San Carlos', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(110, 'San Fabian', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(111, 'San Jacinto', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(112, 'San Manuel', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(113, 'San Nicolas', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:13', 1),
(114, 'San Quintin', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(115, 'Santa Barbara', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(116, 'Santa Maria', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(117, 'Santo Tomas', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(118, 'Sison', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(119, 'Sual', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(120, 'Tayug', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(121, 'Umingan', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(122, 'Urbiztondo', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(123, 'City of Urdaneta', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(124, 'Villasis', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(125, 'Laoac', 5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(126, 'Basco', 6, 'Batanes', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(127, 'Itbayat', 6, 'Batanes', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(128, 'Ivana', 6, 'Batanes', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(129, 'Mahatao', 6, 'Batanes', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(130, 'Sabtang', 6, 'Batanes', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(131, 'Uyugan', 6, 'Batanes', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(132, 'Abulug', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(133, 'Alcala', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(134, 'Allacapan', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(135, 'Amulung', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(136, 'Aparri', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(137, 'Baggao', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(138, 'Ballesteros', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(139, 'Buguey', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(140, 'Calayan', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(141, 'Camalaniugan', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(142, 'Claveria', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(143, 'Enrile', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(144, 'Gattaran', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(145, 'Gonzaga', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(146, 'Iguig', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(147, 'Lal-Lo', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(148, 'Lasam', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(149, 'Pamplona', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(150, 'Peñablanca', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(151, 'Piat', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(152, 'Rizal', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(153, 'Sanchez-Mira', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(154, 'Santa Ana', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(155, 'Santa Praxedes', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(156, 'Santa Teresita', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(157, 'Santo Niño', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(158, 'Solana', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(159, 'Tuao', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(160, 'Tuguegarao City', 7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(161, 'Alicia', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(162, 'Angadanan', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(163, 'Aurora', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(164, 'Benito Soliven', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(165, 'Burgos', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(166, 'Cabagan', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(167, 'Cabatuan', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(168, 'City of Cauayan', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(169, 'Cordon', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(170, 'Dinapigue', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(171, 'Divilacan', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(172, 'Echague', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(173, 'Gamu', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(174, 'City of Ilagan', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(175, 'Jones', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(176, 'Luna', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(177, 'Maconacon', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(178, 'Delfin Albano', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(179, 'Mallig', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(180, 'Naguilian', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(181, 'Palanan', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(182, 'Quezon', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(183, 'Quirino', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(184, 'Ramon', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(185, 'Reina Mercedes', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(186, 'Roxas', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(187, 'San Agustin', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(188, 'San Guillermo', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(189, 'San Isidro', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(190, 'San Manuel', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(191, 'San Mariano', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(192, 'San Mateo', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(193, 'San Pablo', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(194, 'Santa Maria', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(195, 'City of Santiago', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(196, 'Santo Tomas', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(197, 'Tumauini', 8, 'Isabela', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(198, 'Ambaguio', 9, 'Nueva Vizcaya', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(199, 'Aritao', 9, 'Nueva Vizcaya', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(200, 'Bagabag', 9, 'Nueva Vizcaya', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(201, 'Bambang', 9, 'Nueva Vizcaya', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(202, 'Bayombong', 9, 'Nueva Vizcaya', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(203, 'Diadi', 9, 'Nueva Vizcaya', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(204, 'Dupax del Norte', 9, 'Nueva Vizcaya', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(205, 'Dupax del Sur', 9, 'Nueva Vizcaya', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(206, 'Kasibu', 9, 'Nueva Vizcaya', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(207, 'Kayapa', 9, 'Nueva Vizcaya', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(208, 'Quezon', 9, 'Nueva Vizcaya', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(209, 'Santa Fe', 9, 'Nueva Vizcaya', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(210, 'Solano', 9, 'Nueva Vizcaya', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(211, 'Villaverde', 9, 'Nueva Vizcaya', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(212, 'Alfonso Castaneda', 9, 'Nueva Vizcaya', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(213, 'Aglipay', 10, 'Quirino', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(214, 'Cabarroguis', 10, 'Quirino', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(215, 'Diffun', 10, 'Quirino', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(216, 'Maddela', 10, 'Quirino', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(217, 'Saguday', 10, 'Quirino', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(218, 'Nagtipunan', 10, 'Quirino', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(219, 'Abucay', 11, 'Bataan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(220, 'Bagac', 11, 'Bataan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(221, 'City of Balanga', 11, 'Bataan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(222, 'Dinalupihan', 11, 'Bataan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(223, 'Hermosa', 11, 'Bataan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(224, 'Limay', 11, 'Bataan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(225, 'Mariveles', 11, 'Bataan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(226, 'Morong', 11, 'Bataan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(227, 'Orani', 11, 'Bataan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(228, 'Orion', 11, 'Bataan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(229, 'Pilar', 11, 'Bataan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(230, 'Samal', 11, 'Bataan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(231, 'Angat', 12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(232, 'Balagtas', 12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(233, 'Baliuag', 12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(234, 'Bocaue', 12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(235, 'Bulacan', 12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(236, 'Bustos', 12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(237, 'Calumpit', 12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(238, 'Guiguinto', 12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(239, 'Hagonoy', 12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(240, 'City of Malolos', 12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(241, 'Marilao', 12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(242, 'City of Meycauayan', 12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(243, 'Norzagaray', 12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(244, 'Obando', 12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(245, 'Pandi', 12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(246, 'Paombong', 12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(247, 'Plaridel', 12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(248, 'Pulilan', 12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(249, 'San Ildefonso', 12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(250, 'City of San Jose Del Monte', 12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(251, 'San Miguel', 12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(252, 'San Rafael', 12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(253, 'Santa Maria', 12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(254, 'Doña Remedios Trinidad', 12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(255, 'Aliaga', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(256, 'Bongabon', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(257, 'City of Cabanatuan', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(258, 'Cabiao', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(259, 'Carranglan', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(260, 'Cuyapo', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(261, 'Gabaldon', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(262, 'City of Gapan', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(263, 'General Mamerto Natividad', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(264, 'General Tinio', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(265, 'Guimba', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(266, 'Jaen', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(267, 'Laur', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(268, 'Licab', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(269, 'Llanera', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(270, 'Lupao', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(271, 'Science City of Muñoz', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(272, 'Nampicuan', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(273, 'City of Palayan', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(274, 'Pantabangan', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(275, 'Peñaranda', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(276, 'Quezon', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(277, 'Rizal', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(278, 'San Antonio', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(279, 'San Isidro', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(280, 'San Jose City', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(281, 'San Leonardo', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(282, 'Santa Rosa', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(283, 'Santo Domingo', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(284, 'Talavera', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(285, 'Talugtug', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(286, 'Zaragoza', 13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(287, 'City of Angeles', 14, 'Pampanga', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(288, 'Apalit', 14, 'Pampanga', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(289, 'Arayat', 14, 'Pampanga', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(290, 'Bacolor', 14, 'Pampanga', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(291, 'Candaba', 14, 'Pampanga', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(292, 'Floridablanca', 14, 'Pampanga', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(293, 'Guagua', 14, 'Pampanga', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(294, 'Lubao', 14, 'Pampanga', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(295, 'Mabalacat City', 14, 'Pampanga', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(296, 'Macabebe', 14, 'Pampanga', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(297, 'Magalang', 14, 'Pampanga', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(298, 'Masantol', 14, 'Pampanga', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(299, 'Mexico', 14, 'Pampanga', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(300, 'Minalin', 14, 'Pampanga', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(301, 'Porac', 14, 'Pampanga', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(302, 'City of San Fernando', 14, 'Pampanga', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(303, 'San Luis', 14, 'Pampanga', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(304, 'San Simon', 14, 'Pampanga', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(305, 'Santa Ana', 14, 'Pampanga', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(306, 'Santa Rita', 14, 'Pampanga', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(307, 'Santo Tomas', 14, 'Pampanga', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(308, 'Sasmuan', 14, 'Pampanga', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(309, 'Anao', 15, 'Tarlac', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(310, 'Bamban', 15, 'Tarlac', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(311, 'Camiling', 15, 'Tarlac', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(312, 'Capas', 15, 'Tarlac', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(313, 'Concepcion', 15, 'Tarlac', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(314, 'Gerona', 15, 'Tarlac', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(315, 'La Paz', 15, 'Tarlac', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(316, 'Mayantoc', 15, 'Tarlac', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(317, 'Moncada', 15, 'Tarlac', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(318, 'Paniqui', 15, 'Tarlac', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(319, 'Pura', 15, 'Tarlac', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(320, 'Ramos', 15, 'Tarlac', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(321, 'San Clemente', 15, 'Tarlac', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(322, 'San Manuel', 15, 'Tarlac', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(323, 'Santa Ignacia', 15, 'Tarlac', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(324, 'City of Tarlac', 15, 'Tarlac', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(325, 'Victoria', 15, 'Tarlac', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(326, 'San Jose', 15, 'Tarlac', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(327, 'Botolan', 16, 'Zambales', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(328, 'Cabangan', 16, 'Zambales', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(329, 'Candelaria', 16, 'Zambales', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(330, 'Castillejos', 16, 'Zambales', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(331, 'Iba', 16, 'Zambales', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(332, 'Masinloc', 16, 'Zambales', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(333, 'City of Olongapo', 16, 'Zambales', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(334, 'Palauig', 16, 'Zambales', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(335, 'San Antonio', 16, 'Zambales', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(336, 'San Felipe', 16, 'Zambales', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(337, 'San Marcelino', 16, 'Zambales', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(338, 'San Narciso', 16, 'Zambales', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(339, 'Santa Cruz', 16, 'Zambales', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(340, 'Subic', 16, 'Zambales', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(341, 'Baler', 17, 'Aurora', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(342, 'Casiguran', 17, 'Aurora', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(343, 'Dilasag', 17, 'Aurora', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(344, 'Dinalungan', 17, 'Aurora', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(345, 'Dingalan', 17, 'Aurora', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(346, 'Dipaculao', 17, 'Aurora', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(347, 'Maria Aurora', 17, 'Aurora', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(348, 'San Luis', 17, 'Aurora', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(349, 'Agoncillo', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(350, 'Alitagtag', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(351, 'Balayan', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(352, 'Balete', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(353, 'Batangas City', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(354, 'Bauan', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(355, 'Calaca', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(356, 'Calatagan', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(357, 'Cuenca', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(358, 'Ibaan', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(359, 'Laurel', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(360, 'Lemery', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(361, 'Lian', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(362, 'City of Lipa', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(363, 'Lobo', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(364, 'Mabini', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(365, 'Malvar', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(366, 'Mataasnakahoy', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(367, 'Nasugbu', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(368, 'Padre Garcia', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(369, 'Rosario', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(370, 'San Jose', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(371, 'San Juan', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(372, 'San Luis', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(373, 'San Nicolas', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(374, 'San Pascual', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(375, 'Santa Teresita', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(376, 'City of Sto. Tomas', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(377, 'Taal', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(378, 'Talisay', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(379, 'City of Tanauan', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(380, 'Taysan', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(381, 'Tingloy', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(382, 'Tuy', 18, 'Batangas', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(383, 'Alfonso', 19, 'Cavite', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(384, 'Amadeo', 19, 'Cavite', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(385, 'City of Bacoor', 19, 'Cavite', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(386, 'Carmona', 19, 'Cavite', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(387, 'City of Cavite', 19, 'Cavite', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(388, 'City of Dasmariñas', 19, 'Cavite', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(389, 'General Emilio Aguinaldo', 19, 'Cavite', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(390, 'City of General Trias', 19, 'Cavite', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(391, 'City of Imus', 19, 'Cavite', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(392, 'Indang', 19, 'Cavite', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(393, 'Kawit', 19, 'Cavite', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(394, 'Magallanes', 19, 'Cavite', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(395, 'Maragondon', 19, 'Cavite', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(396, 'Mendez', 19, 'Cavite', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(397, 'Naic', 19, 'Cavite', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(398, 'Noveleta', 19, 'Cavite', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(399, 'Rosario', 19, 'Cavite', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(400, 'Silang', 19, 'Cavite', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(401, 'City of Tagaytay', 19, 'Cavite', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(402, 'Tanza', 19, 'Cavite', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(403, 'Ternate', 19, 'Cavite', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(404, 'City of Trece Martires', 19, 'Cavite', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(405, 'Gen. Mariano Alvarez', 19, 'Cavite', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(406, 'Alaminos', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(407, 'Bay', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(408, 'City of Biñan', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(409, 'City of Cabuyao', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(410, 'City of Calamba', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(411, 'Calauan', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(412, 'Cavinti', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(413, 'Famy', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(414, 'Kalayaan', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(415, 'Liliw', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(416, 'Los Baños', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(417, 'Luisiana', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(418, 'Lumban', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(419, 'Mabitac', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(420, 'Magdalena', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(421, 'Majayjay', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(422, 'Nagcarlan', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(423, 'Paete', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(424, 'Pagsanjan', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(425, 'Pakil', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(426, 'Pangil', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:14', 1),
(427, 'Pila', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(428, 'Rizal', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(429, 'City of San Pablo', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(430, 'City of San Pedro', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(431, 'Santa Cruz', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(432, 'Santa Maria', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(433, 'City of Santa Rosa', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(434, 'Siniloan', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(435, 'Victoria', 20, 'Laguna', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(436, 'Agdangan', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(437, 'Alabat', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(438, 'Atimonan', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(439, 'Buenavista', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(440, 'Burdeos', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(441, 'Calauag', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(442, 'Candelaria', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(443, 'Catanauan', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(444, 'Dolores', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(445, 'General Luna', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(446, 'General Nakar', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(447, 'Guinayangan', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(448, 'Gumaca', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(449, 'Infanta', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(450, 'Jomalig', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(451, 'Lopez', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(452, 'Lucban', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(453, 'City of Lucena', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(454, 'Macalelon', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(455, 'Mauban', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(456, 'Mulanay', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(457, 'Padre Burgos', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(458, 'Pagbilao', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(459, 'Panukulan', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(460, 'Patnanungan', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(461, 'Perez', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(462, 'Pitogo', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(463, 'Plaridel', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(464, 'Polillo', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(465, 'Quezon', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(466, 'Real', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(467, 'Sampaloc', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(468, 'San Andres', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(469, 'San Antonio', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(470, 'San Francisco', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(471, 'San Narciso', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(472, 'Sariaya', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(473, 'Tagkawayan', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(474, 'City of Tayabas', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(475, 'Tiaong', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(476, 'Unisan', 21, 'Quezon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(477, 'Angono', 22, 'Rizal', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(478, 'City of Antipolo', 22, 'Rizal', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(479, 'Baras', 22, 'Rizal', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(480, 'Binangonan', 22, 'Rizal', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(481, 'Cainta', 22, 'Rizal', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(482, 'Cardona', 22, 'Rizal', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(483, 'Jala-Jala', 22, 'Rizal', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(484, 'Rodriguez', 22, 'Rizal', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(485, 'Morong', 22, 'Rizal', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(486, 'Pililla', 22, 'Rizal', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(487, 'San Mateo', 22, 'Rizal', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(488, 'Tanay', 22, 'Rizal', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(489, 'Taytay', 22, 'Rizal', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(490, 'Teresa', 22, 'Rizal', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(491, 'Boac', 23, 'Marinduque', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(492, 'Buenavista', 23, 'Marinduque', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(493, 'Gasan', 23, 'Marinduque', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(494, 'Mogpog', 23, 'Marinduque', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(495, 'Santa Cruz', 23, 'Marinduque', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(496, 'Torrijos', 23, 'Marinduque', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(497, 'Abra De Ilog', 24, 'Occidental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(498, 'Calintaan', 24, 'Occidental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(499, 'Looc', 24, 'Occidental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(500, 'Lubang', 24, 'Occidental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(501, 'Magsaysay', 24, 'Occidental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(502, 'Mamburao', 24, 'Occidental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(503, 'Paluan', 24, 'Occidental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(504, 'Rizal', 24, 'Occidental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(505, 'Sablayan', 24, 'Occidental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(506, 'San Jose', 24, 'Occidental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(507, 'Santa Cruz', 24, 'Occidental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(508, 'Baco', 25, 'Oriental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(509, 'Bansud', 25, 'Oriental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(510, 'Bongabong', 25, 'Oriental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(511, 'Bulalacao', 25, 'Oriental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(512, 'City of Calapan', 25, 'Oriental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(513, 'Gloria', 25, 'Oriental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(514, 'Mansalay', 25, 'Oriental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(515, 'Naujan', 25, 'Oriental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(516, 'Pinamalayan', 25, 'Oriental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(517, 'Pola', 25, 'Oriental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(518, 'Puerto Galera', 25, 'Oriental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(519, 'Roxas', 25, 'Oriental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(520, 'San Teodoro', 25, 'Oriental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(521, 'Socorro', 25, 'Oriental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(522, 'Victoria', 25, 'Oriental Mindoro', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(523, 'Aborlan', 26, 'Palawan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(524, 'Agutaya', 26, 'Palawan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(525, 'Araceli', 26, 'Palawan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(526, 'Balabac', 26, 'Palawan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(527, 'Bataraza', 26, 'Palawan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(528, 'Brooke S Point', 26, 'Palawan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(529, 'Busuanga', 26, 'Palawan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(530, 'Cagayancillo', 26, 'Palawan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(531, 'Coron', 26, 'Palawan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(532, 'Cuyo', 26, 'Palawan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(533, 'Dumaran', 26, 'Palawan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(534, 'El Nido', 26, 'Palawan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(535, 'Linapacan', 26, 'Palawan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(536, 'Magsaysay', 26, 'Palawan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(537, 'Narra', 26, 'Palawan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(538, 'City of Puerto Princesa', 26, 'Palawan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(539, 'Quezon', 26, 'Palawan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(540, 'Roxas', 26, 'Palawan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(541, 'San Vicente', 26, 'Palawan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(542, 'Taytay', 26, 'Palawan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(543, 'Kalayaan', 26, 'Palawan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(544, 'Culion', 26, 'Palawan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(545, 'Rizal', 26, 'Palawan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(546, 'Sofronio Española', 26, 'Palawan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(547, 'Alcantara', 27, 'Romblon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(548, 'Banton', 27, 'Romblon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(549, 'Cajidiocan', 27, 'Romblon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(550, 'Calatrava', 27, 'Romblon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(551, 'Concepcion', 27, 'Romblon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(552, 'Corcuera', 27, 'Romblon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(553, 'Looc', 27, 'Romblon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(554, 'Magdiwang', 27, 'Romblon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(555, 'Odiongan', 27, 'Romblon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(556, 'Romblon', 27, 'Romblon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(557, 'San Agustin', 27, 'Romblon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(558, 'San Andres', 27, 'Romblon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(559, 'San Fernando', 27, 'Romblon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(560, 'San Jose', 27, 'Romblon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(561, 'Santa Fe', 27, 'Romblon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(562, 'Ferrol', 27, 'Romblon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(563, 'Santa Maria', 27, 'Romblon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(564, 'Bacacay', 28, 'Albay', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(565, 'Camalig', 28, 'Albay', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(566, 'Daraga', 28, 'Albay', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(567, 'Guinobatan', 28, 'Albay', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(568, 'Jovellar', 28, 'Albay', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(569, 'City of Legazpi', 28, 'Albay', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(570, 'Libon', 28, 'Albay', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(571, 'City of Ligao', 28, 'Albay', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(572, 'Malilipot', 28, 'Albay', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(573, 'Malinao', 28, 'Albay', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(574, 'Manito', 28, 'Albay', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(575, 'Oas', 28, 'Albay', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(576, 'Pio Duran', 28, 'Albay', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(577, 'Polangui', 28, 'Albay', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(578, 'Rapu-Rapu', 28, 'Albay', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(579, 'Santo Domingo', 28, 'Albay', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(580, 'City of Tabaco', 28, 'Albay', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(581, 'Tiwi', 28, 'Albay', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(582, 'Basud', 29, 'Camarines Norte', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(583, 'Capalonga', 29, 'Camarines Norte', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(584, 'Daet', 29, 'Camarines Norte', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(585, 'San Lorenzo Ruiz', 29, 'Camarines Norte', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(586, 'Jose Panganiban', 29, 'Camarines Norte', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(587, 'Labo', 29, 'Camarines Norte', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(588, 'Mercedes', 29, 'Camarines Norte', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(589, 'Paracale', 29, 'Camarines Norte', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(590, 'San Vicente', 29, 'Camarines Norte', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(591, 'Santa Elena', 29, 'Camarines Norte', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(592, 'Talisay', 29, 'Camarines Norte', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(593, 'Vinzons', 29, 'Camarines Norte', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(594, 'Baao', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(595, 'Balatan', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(596, 'Bato', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(597, 'Bombon', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(598, 'Buhi', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(599, 'Bula', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(600, 'Cabusao', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(601, 'Calabanga', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(602, 'Camaligan', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(603, 'Canaman', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(604, 'Caramoan', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(605, 'Del Gallego', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(606, 'Gainza', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(607, 'Garchitorena', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(608, 'Goa', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(609, 'City of Iriga', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(610, 'Lagonoy', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(611, 'Libmanan', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(612, 'Lupi', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(613, 'Magarao', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(614, 'Milaor', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(615, 'Minalabac', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(616, 'Nabua', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(617, 'City of Naga', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(618, 'Ocampo', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(619, 'Pamplona', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(620, 'Pasacao', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(621, 'Pili', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(622, 'Presentacion', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(623, 'Ragay', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(624, 'Sagñay', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(625, 'San Fernando', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(626, 'San Jose', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1);
INSERT INTO `city` (`city_id`, `city_name`, `state_id`, `state_name`, `country_id`, `country_name`, `created_date`, `last_log_by`) VALUES
(627, 'Sipocot', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(628, 'Siruma', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(629, 'Tigaon', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(630, 'Tinambac', 30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(631, 'Bagamanoc', 31, 'Catanduanes', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(632, 'Baras', 31, 'Catanduanes', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(633, 'Bato', 31, 'Catanduanes', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(634, 'Caramoran', 31, 'Catanduanes', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(635, 'Gigmoto', 31, 'Catanduanes', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(636, 'Pandan', 31, 'Catanduanes', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(637, 'Panganiban', 31, 'Catanduanes', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(638, 'San Andres', 31, 'Catanduanes', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(639, 'San Miguel', 31, 'Catanduanes', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(640, 'Viga', 31, 'Catanduanes', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(641, 'Virac', 31, 'Catanduanes', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(642, 'Aroroy', 32, 'Masbate', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(643, 'Baleno', 32, 'Masbate', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(644, 'Balud', 32, 'Masbate', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(645, 'Batuan', 32, 'Masbate', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(646, 'Cataingan', 32, 'Masbate', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(647, 'Cawayan', 32, 'Masbate', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(648, 'Claveria', 32, 'Masbate', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(649, 'Dimasalang', 32, 'Masbate', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(650, 'Esperanza', 32, 'Masbate', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(651, 'Mandaon', 32, 'Masbate', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(652, 'City of Masbate', 32, 'Masbate', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(653, 'Milagros', 32, 'Masbate', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(654, 'Mobo', 32, 'Masbate', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(655, 'Monreal', 32, 'Masbate', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(656, 'Palanas', 32, 'Masbate', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(657, 'Pio V. Corpuz', 32, 'Masbate', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(658, 'Placer', 32, 'Masbate', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(659, 'San Fernando', 32, 'Masbate', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(660, 'San Jacinto', 32, 'Masbate', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(661, 'San Pascual', 32, 'Masbate', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(662, 'Uson', 32, 'Masbate', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(663, 'Barcelona', 33, 'Sorsogon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(664, 'Bulan', 33, 'Sorsogon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(665, 'Bulusan', 33, 'Sorsogon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(666, 'Casiguran', 33, 'Sorsogon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(667, 'Castilla', 33, 'Sorsogon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(668, 'Donsol', 33, 'Sorsogon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(669, 'Gubat', 33, 'Sorsogon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(670, 'Irosin', 33, 'Sorsogon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(671, 'Juban', 33, 'Sorsogon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(672, 'Magallanes', 33, 'Sorsogon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(673, 'Matnog', 33, 'Sorsogon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(674, 'Pilar', 33, 'Sorsogon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(675, 'Prieto Diaz', 33, 'Sorsogon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(676, 'Santa Magdalena', 33, 'Sorsogon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(677, 'City of Sorsogon', 33, 'Sorsogon', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(678, 'Altavas', 34, 'Aklan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(679, 'Balete', 34, 'Aklan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(680, 'Banga', 34, 'Aklan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(681, 'Batan', 34, 'Aklan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(682, 'Buruanga', 34, 'Aklan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(683, 'Ibajay', 34, 'Aklan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(684, 'Kalibo', 34, 'Aklan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(685, 'Lezo', 34, 'Aklan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(686, 'Libacao', 34, 'Aklan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(687, 'Madalag', 34, 'Aklan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(688, 'Makato', 34, 'Aklan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(689, 'Malay', 34, 'Aklan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(690, 'Malinao', 34, 'Aklan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(691, 'Nabas', 34, 'Aklan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(692, 'New Washington', 34, 'Aklan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(693, 'Numancia', 34, 'Aklan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(694, 'Tangalan', 34, 'Aklan', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(695, 'Anini-Y', 35, 'Antique', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(696, 'Barbaza', 35, 'Antique', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(697, 'Belison', 35, 'Antique', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(698, 'Bugasong', 35, 'Antique', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(699, 'Caluya', 35, 'Antique', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(700, 'Culasi', 35, 'Antique', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(701, 'Tobias Fornier', 35, 'Antique', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(702, 'Hamtic', 35, 'Antique', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(703, 'Laua-An', 35, 'Antique', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(704, 'Libertad', 35, 'Antique', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(705, 'Pandan', 35, 'Antique', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(706, 'Patnongon', 35, 'Antique', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(707, 'San Jose', 35, 'Antique', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(708, 'San Remigio', 35, 'Antique', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(709, 'Sebaste', 35, 'Antique', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(710, 'Sibalom', 35, 'Antique', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(711, 'Tibiao', 35, 'Antique', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(712, 'Valderrama', 35, 'Antique', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(713, 'Cuartero', 36, 'Capiz', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(714, 'Dao', 36, 'Capiz', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(715, 'Dumalag', 36, 'Capiz', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(716, 'Dumarao', 36, 'Capiz', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(717, 'Ivisan', 36, 'Capiz', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(718, 'Jamindan', 36, 'Capiz', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(719, 'Ma-Ayon', 36, 'Capiz', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(720, 'Mambusao', 36, 'Capiz', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(721, 'Panay', 36, 'Capiz', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(722, 'Panitan', 36, 'Capiz', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(723, 'Pilar', 36, 'Capiz', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(724, 'Pontevedra', 36, 'Capiz', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(725, 'President Roxas', 36, 'Capiz', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(726, 'City of Roxas', 36, 'Capiz', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(727, 'Sapi-An', 36, 'Capiz', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(728, 'Sigma', 36, 'Capiz', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(729, 'Tapaz', 36, 'Capiz', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(730, 'Ajuy', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(731, 'Alimodian', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(732, 'Anilao', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(733, 'Badiangan', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(734, 'Balasan', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:15', 1),
(735, 'Banate', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(736, 'Barotac Nuevo', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(737, 'Barotac Viejo', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(738, 'Batad', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(739, 'Bingawan', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(740, 'Cabatuan', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(741, 'Calinog', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(742, 'Carles', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(743, 'Concepcion', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(744, 'Dingle', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(745, 'Dueñas', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(746, 'Dumangas', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(747, 'Estancia', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(748, 'Guimbal', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(749, 'Igbaras', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(750, 'City of Iloilo', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(751, 'Janiuay', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(752, 'Lambunao', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(753, 'Leganes', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(754, 'Lemery', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(755, 'Leon', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(756, 'Maasin', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(757, 'Miagao', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(758, 'Mina', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(759, 'New Lucena', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(760, 'Oton', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(761, 'City of Passi', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(762, 'Pavia', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(763, 'Pototan', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(764, 'San Dionisio', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(765, 'San Enrique', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(766, 'San Joaquin', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(767, 'San Miguel', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(768, 'San Rafael', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(769, 'Santa Barbara', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(770, 'Sara', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(771, 'Tigbauan', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(772, 'Tubungan', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(773, 'Zarraga', 37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(774, 'City of Bacolod', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(775, 'City of Bago', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(776, 'Binalbagan', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(777, 'City of Cadiz', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(778, 'Calatrava', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(779, 'Candoni', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(780, 'Cauayan', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(781, 'Enrique B. Magalona', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(782, 'City of Escalante', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(783, 'City of Himamaylan', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(784, 'Hinigaran', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(785, 'Hinoba-an', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(786, 'Ilog', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(787, 'Isabela', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(788, 'City of Kabankalan', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(789, 'City of La Carlota', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(790, 'La Castellana', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(791, 'Manapla', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(792, 'Moises Padilla', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(793, 'Murcia', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(794, 'Pontevedra', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(795, 'Pulupandan', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(796, 'City of Sagay', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(797, 'City of San Carlos', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(798, 'San Enrique', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(799, 'City of Silay', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(800, 'City of Sipalay', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(801, 'City of Talisay', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(802, 'Toboso', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(803, 'Valladolid', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(804, 'City of Victorias', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(805, 'Salvador Benedicto', 38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(806, 'Buenavista', 39, 'Guimaras', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(807, 'Jordan', 39, 'Guimaras', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(808, 'Nueva Valencia', 39, 'Guimaras', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(809, 'San Lorenzo', 39, 'Guimaras', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(810, 'Sibunag', 39, 'Guimaras', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(811, 'Alburquerque', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(812, 'Alicia', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(813, 'Anda', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(814, 'Antequera', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(815, 'Baclayon', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(816, 'Balilihan', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(817, 'Batuan', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(818, 'Bilar', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(819, 'Buenavista', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(820, 'Calape', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(821, 'Candijay', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(822, 'Carmen', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(823, 'Catigbian', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(824, 'Clarin', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(825, 'Corella', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(826, 'Cortes', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(827, 'Dagohoy', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(828, 'Danao', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(829, 'Dauis', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(830, 'Dimiao', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(831, 'Duero', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(832, 'Garcia Hernandez', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(833, 'Guindulman', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(834, 'Inabanga', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(835, 'Jagna', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(836, 'Getafe', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(837, 'Lila', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(838, 'Loay', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(839, 'Loboc', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(840, 'Loon', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(841, 'Mabini', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(842, 'Maribojoc', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(843, 'Panglao', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(844, 'Pilar', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(845, 'Pres. Carlos P. Garcia', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(846, 'Sagbayan', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(847, 'San Isidro', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(848, 'San Miguel', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(849, 'Sevilla', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(850, 'Sierra Bullones', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(851, 'Sikatuna', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(852, 'City of Tagbilaran', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(853, 'Talibon', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(854, 'Trinidad', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(855, 'Tubigon', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(856, 'Ubay', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(857, 'Valencia', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(858, 'Bien Unido', 40, 'Bohol', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(859, 'Alcantara', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(860, 'Alcoy', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(861, 'Alegria', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(862, 'Aloguinsan', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(863, 'Argao', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(864, 'Asturias', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(865, 'Badian', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(866, 'Balamban', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(867, 'Bantayan', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(868, 'Barili', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(869, 'City of Bogo', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(870, 'Boljoon', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(871, 'Borbon', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(872, 'City of Carcar', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(873, 'Carmen', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(874, 'Catmon', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(875, 'City of Cebu', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(876, 'Compostela', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(877, 'Consolacion', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(878, 'Cordova', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(879, 'Daanbantayan', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(880, 'Dalaguete', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(881, 'Danao City', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(882, 'Dumanjug', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(883, 'Ginatilan', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(884, 'City of Lapu-Lapu', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(885, 'Liloan', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(886, 'Madridejos', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(887, 'Malabuyoc', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(888, 'City of Mandaue', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(889, 'Medellin', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(890, 'Minglanilla', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(891, 'Moalboal', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(892, 'City of Naga', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(893, 'Oslob', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(894, 'Pilar', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(895, 'Pinamungajan', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(896, 'Poro', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(897, 'Ronda', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(898, 'Samboan', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(899, 'San Fernando', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(900, 'San Francisco', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(901, 'San Remigio', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(902, 'Santa Fe', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(903, 'Santander', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(904, 'Sibonga', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(905, 'Sogod', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(906, 'Tabogon', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(907, 'Tabuelan', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(908, 'City of Talisay', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(909, 'City of Toledo', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(910, 'Tuburan', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(911, 'Tudela', 41, 'Cebu', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(912, 'Amlan', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(913, 'Ayungon', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(914, 'Bacong', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(915, 'City of Bais', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(916, 'Basay', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(917, 'City of Bayawan', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(918, 'Bindoy', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(919, 'City of Canlaon', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(920, 'Dauin', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(921, 'City of Dumaguete', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(922, 'City of Guihulngan', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(923, 'Jimalalud', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(924, 'La Libertad', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(925, 'Mabinay', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(926, 'Manjuyod', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(927, 'Pamplona', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(928, 'San Jose', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(929, 'Santa Catalina', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(930, 'Siaton', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(931, 'Sibulan', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(932, 'City of Tanjay', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(933, 'Tayasan', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(934, 'Valencia', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(935, 'Vallehermoso', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(936, 'Zamboanguita', 42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(937, 'Enrique Villanueva', 43, 'Siquijor', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(938, 'Larena', 43, 'Siquijor', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(939, 'Lazi', 43, 'Siquijor', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(940, 'Maria', 43, 'Siquijor', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(941, 'San Juan', 43, 'Siquijor', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(942, 'Siquijor', 43, 'Siquijor', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(943, 'Arteche', 44, 'Eastern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(944, 'Balangiga', 44, 'Eastern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(945, 'Balangkayan', 44, 'Eastern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(946, 'City of Borongan', 44, 'Eastern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(947, 'Can-Avid', 44, 'Eastern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(948, 'Dolores', 44, 'Eastern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(949, 'General Macarthur', 44, 'Eastern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(950, 'Giporlos', 44, 'Eastern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(951, 'Guiuan', 44, 'Eastern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(952, 'Hernani', 44, 'Eastern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(953, 'Jipapad', 44, 'Eastern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(954, 'Lawaan', 44, 'Eastern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(955, 'Llorente', 44, 'Eastern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(956, 'Maslog', 44, 'Eastern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(957, 'Maydolong', 44, 'Eastern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(958, 'Mercedes', 44, 'Eastern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(959, 'Oras', 44, 'Eastern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(960, 'Quinapondan', 44, 'Eastern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(961, 'Salcedo', 44, 'Eastern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(962, 'San Julian', 44, 'Eastern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(963, 'San Policarpo', 44, 'Eastern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(964, 'Sulat', 44, 'Eastern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(965, 'Taft', 44, 'Eastern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(966, 'Abuyog', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(967, 'Alangalang', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(968, 'Albuera', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(969, 'Babatngon', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(970, 'Barugo', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(971, 'Bato', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(972, 'City of Baybay', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(973, 'Burauen', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(974, 'Calubian', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(975, 'Capoocan', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(976, 'Carigara', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(977, 'Dagami', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(978, 'Dulag', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(979, 'Hilongos', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(980, 'Hindang', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(981, 'Inopacan', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(982, 'Isabel', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(983, 'Jaro', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(984, 'Javier', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(985, 'Julita', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(986, 'Kananga', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(987, 'La Paz', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(988, 'Leyte', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(989, 'Macarthur', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(990, 'Mahaplag', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(991, 'Matag-Ob', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(992, 'Matalom', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(993, 'Mayorga', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(994, 'Merida', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(995, 'Ormoc City', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(996, 'Palo', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(997, 'Palompon', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(998, 'Pastrana', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(999, 'San Isidro', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1000, 'San Miguel', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1001, 'Santa Fe', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1002, 'Tabango', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1003, 'Tabontabon', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1004, 'City of Tacloban', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1005, 'Tanauan', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1006, 'Tolosa', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1007, 'Tunga', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1008, 'Villaba', 45, 'Leyte', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1009, 'Allen', 46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1010, 'Biri', 46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1011, 'Bobon', 46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1012, 'Capul', 46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1013, 'Catarman', 46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1014, 'Catubig', 46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1015, 'Gamay', 46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1016, 'Laoang', 46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1017, 'Lapinig', 46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1018, 'Las Navas', 46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1019, 'Lavezares', 46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1020, 'Mapanas', 46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1021, 'Mondragon', 46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1022, 'Palapag', 46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1023, 'Pambujan', 46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1024, 'Rosario', 46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1025, 'San Antonio', 46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1026, 'San Isidro', 46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1027, 'San Jose', 46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1028, 'San Roque', 46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1029, 'San Vicente', 46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1030, 'Silvino Lobos', 46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1031, 'Victoria', 46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1032, 'Lope De Vega', 46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1033, 'Almagro', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1034, 'Basey', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1035, 'City of Calbayog', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1036, 'Calbiga', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1037, 'City of Catbalogan', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1038, 'Daram', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1039, 'Gandara', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1040, 'Hinabangan', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1041, 'Jiabong', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1042, 'Marabut', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1043, 'Matuguinao', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1044, 'Motiong', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1045, 'Pinabacdao', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:16', 1),
(1046, 'San Jose De Buan', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1047, 'San Sebastian', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1048, 'Santa Margarita', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1049, 'Santa Rita', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1050, 'Santo Niño', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1051, 'Talalora', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1052, 'Tarangnan', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1053, 'Villareal', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1054, 'Paranas', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1055, 'Zumarraga', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1056, 'Tagapul-An', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1057, 'San Jorge', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1058, 'Pagsanghan', 47, 'Samar', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1059, 'Anahawan', 48, 'Southern Leyte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1060, 'Bontoc', 48, 'Southern Leyte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1061, 'Hinunangan', 48, 'Southern Leyte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1062, 'Hinundayan', 48, 'Southern Leyte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1063, 'Libagon', 48, 'Southern Leyte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1064, 'Liloan', 48, 'Southern Leyte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1065, 'City of Maasin', 48, 'Southern Leyte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1066, 'Macrohon', 48, 'Southern Leyte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1067, 'Malitbog', 48, 'Southern Leyte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1068, 'Padre Burgos', 48, 'Southern Leyte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1069, 'Pintuyan', 48, 'Southern Leyte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1070, 'Saint Bernard', 48, 'Southern Leyte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1071, 'San Francisco', 48, 'Southern Leyte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1072, 'San Juan', 48, 'Southern Leyte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1073, 'San Ricardo', 48, 'Southern Leyte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1074, 'Silago', 48, 'Southern Leyte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1075, 'Sogod', 48, 'Southern Leyte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1076, 'Tomas Oppus', 48, 'Southern Leyte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1077, 'Limasawa', 48, 'Southern Leyte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1078, 'Almeria', 49, 'Biliran', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1079, 'Biliran', 49, 'Biliran', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1080, 'Cabucgayan', 49, 'Biliran', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1081, 'Caibiran', 49, 'Biliran', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1082, 'Culaba', 49, 'Biliran', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1083, 'Kawayan', 49, 'Biliran', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1084, 'Maripipi', 49, 'Biliran', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1085, 'Naval', 49, 'Biliran', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1086, 'City of Dapitan', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1087, 'City of Dipolog', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1088, 'Katipunan', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1089, 'La Libertad', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1090, 'Labason', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1091, 'Liloy', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1092, 'Manukan', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1093, 'Mutia', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1094, 'Piñan', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1095, 'Polanco', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1096, 'Pres. Manuel A. Roxas', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1097, 'Rizal', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1098, 'Salug', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1099, 'Sergio Osmeña Sr.', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1100, 'Siayan', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1101, 'Sibuco', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1102, 'Sibutad', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1103, 'Sindangan', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1104, 'Siocon', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1105, 'Sirawai', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1106, 'Tampilisan', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1107, 'Jose Dalman', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1108, 'Gutalac', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1109, 'Baliguian', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1110, 'Godod', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1111, 'Bacungan', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1112, 'Kalawit', 50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1113, 'Aurora', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1114, 'Bayog', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1115, 'Dimataling', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1116, 'Dinas', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1117, 'Dumalinao', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1118, 'Dumingag', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1119, 'Kumalarang', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1120, 'Labangan', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1121, 'Lapuyan', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1122, 'Mahayag', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1123, 'Margosatubig', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1124, 'Midsalip', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1125, 'Molave', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1126, 'City of Pagadian', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1127, 'Ramon Magsaysay', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1128, 'San Miguel', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1129, 'San Pablo', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1130, 'Tabina', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1131, 'Tambulig', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1132, 'Tukuran', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1133, 'City of Zamboanga', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1134, 'Lakewood', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1135, 'Josefina', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1136, 'Pitogo', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1137, 'Sominot', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1138, 'Vincenzo A. Sagun', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1139, 'Guipos', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1140, 'Tigbao', 51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1141, 'Alicia', 52, 'Zamboanga Sibugay', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1142, 'Buug', 52, 'Zamboanga Sibugay', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1143, 'Diplahan', 52, 'Zamboanga Sibugay', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1144, 'Imelda', 52, 'Zamboanga Sibugay', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1145, 'Ipil', 52, 'Zamboanga Sibugay', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1146, 'Kabasalan', 52, 'Zamboanga Sibugay', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1147, 'Mabuhay', 52, 'Zamboanga Sibugay', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1148, 'Malangas', 52, 'Zamboanga Sibugay', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1149, 'Naga', 52, 'Zamboanga Sibugay', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1150, 'Olutanga', 52, 'Zamboanga Sibugay', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1151, 'Payao', 52, 'Zamboanga Sibugay', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1152, 'Roseller Lim', 52, 'Zamboanga Sibugay', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1153, 'Siay', 52, 'Zamboanga Sibugay', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1154, 'Talusan', 52, 'Zamboanga Sibugay', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1155, 'Titay', 52, 'Zamboanga Sibugay', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1156, 'Tungawan', 52, 'Zamboanga Sibugay', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1157, 'City of Isabela', 52, 'Zamboanga Sibugay', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1158, 'Baungon', 53, 'Bukidnon', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1159, 'Damulog', 53, 'Bukidnon', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1160, 'Dangcagan', 53, 'Bukidnon', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1161, 'Don Carlos', 53, 'Bukidnon', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1162, 'Impasug-ong', 53, 'Bukidnon', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1163, 'Kadingilan', 53, 'Bukidnon', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1164, 'Kalilangan', 53, 'Bukidnon', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1165, 'Kibawe', 53, 'Bukidnon', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1166, 'Kitaotao', 53, 'Bukidnon', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1167, 'Lantapan', 53, 'Bukidnon', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1168, 'Libona', 53, 'Bukidnon', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1169, 'City of Malaybalay', 53, 'Bukidnon', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1170, 'Malitbog', 53, 'Bukidnon', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1171, 'Manolo Fortich', 53, 'Bukidnon', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1172, 'Maramag', 53, 'Bukidnon', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1173, 'Pangantucan', 53, 'Bukidnon', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1174, 'Quezon', 53, 'Bukidnon', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1175, 'San Fernando', 53, 'Bukidnon', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1176, 'Sumilao', 53, 'Bukidnon', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1177, 'Talakag', 53, 'Bukidnon', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1178, 'City of Valencia', 53, 'Bukidnon', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1179, 'Cabanglasan', 53, 'Bukidnon', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1180, 'Catarman', 54, 'Camiguin', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1181, 'Guinsiliban', 54, 'Camiguin', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1182, 'Mahinog', 54, 'Camiguin', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1183, 'Mambajao', 54, 'Camiguin', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1184, 'Sagay', 54, 'Camiguin', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1185, 'Bacolod', 55, 'Lanao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1186, 'Baloi', 55, 'Lanao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1187, 'Baroy', 55, 'Lanao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1188, 'City of Iligan', 55, 'Lanao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1189, 'Kapatagan', 55, 'Lanao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1190, 'Sultan Naga Dimaporo', 55, 'Lanao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1191, 'Kauswagan', 55, 'Lanao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1192, 'Kolambugan', 55, 'Lanao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1193, 'Lala', 55, 'Lanao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1194, 'Linamon', 55, 'Lanao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1195, 'Magsaysay', 55, 'Lanao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1196, 'Maigo', 55, 'Lanao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1197, 'Matungao', 55, 'Lanao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1198, 'Munai', 55, 'Lanao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1199, 'Nunungan', 55, 'Lanao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1200, 'Pantao Ragat', 55, 'Lanao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1201, 'Poona Piagapo', 55, 'Lanao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1202, 'Salvador', 55, 'Lanao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1203, 'Sapad', 55, 'Lanao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1204, 'Tagoloan', 55, 'Lanao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1205, 'Tangcal', 55, 'Lanao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1206, 'Tubod', 55, 'Lanao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1207, 'Pantar', 55, 'Lanao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1208, 'Aloran', 56, 'Misamis Occidental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1209, 'Baliangao', 56, 'Misamis Occidental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1210, 'Bonifacio', 56, 'Misamis Occidental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1211, 'Calamba', 56, 'Misamis Occidental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1212, 'Clarin', 56, 'Misamis Occidental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1213, 'Concepcion', 56, 'Misamis Occidental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1214, 'Jimenez', 56, 'Misamis Occidental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1215, 'Lopez Jaena', 56, 'Misamis Occidental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1216, 'City of Oroquieta', 56, 'Misamis Occidental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1217, 'City of Ozamiz', 56, 'Misamis Occidental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1218, 'Panaon', 56, 'Misamis Occidental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1219, 'Plaridel', 56, 'Misamis Occidental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1220, 'Sapang Dalaga', 56, 'Misamis Occidental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1221, 'Sinacaban', 56, 'Misamis Occidental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1222, 'City of Tangub', 56, 'Misamis Occidental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1223, 'Tudela', 56, 'Misamis Occidental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1224, 'Don Victoriano Chiongbian', 56, 'Misamis Occidental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1225, 'Alubijid', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1226, 'Balingasag', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1227, 'Balingoan', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1228, 'Binuangan', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1229, 'City of Cagayan De Oro', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1230, 'Claveria', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1231, 'City of El Salvador', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1232, 'City of Gingoog', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1233, 'Gitagum', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1234, 'Initao', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1);
INSERT INTO `city` (`city_id`, `city_name`, `state_id`, `state_name`, `country_id`, `country_name`, `created_date`, `last_log_by`) VALUES
(1235, 'Jasaan', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1236, 'Kinoguitan', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1237, 'Lagonglong', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1238, 'Laguindingan', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1239, 'Libertad', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1240, 'Lugait', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1241, 'Magsaysay', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1242, 'Manticao', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1243, 'Medina', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1244, 'Naawan', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1245, 'Opol', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1246, 'Salay', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1247, 'Sugbongcogon', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1248, 'Tagoloan', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1249, 'Talisayan', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1250, 'Villanueva', 57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1251, 'Asuncion', 58, 'Davao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1252, 'Carmen', 58, 'Davao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1253, 'Kapalong', 58, 'Davao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1254, 'New Corella', 58, 'Davao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1255, 'City of Panabo', 58, 'Davao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1256, 'Island Garden City of Samal', 58, 'Davao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1257, 'Santo Tomas', 58, 'Davao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1258, 'City of Tagum', 58, 'Davao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1259, 'Talaingod', 58, 'Davao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1260, 'Braulio E. Dujali', 58, 'Davao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1261, 'San Isidro', 58, 'Davao del Norte', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1262, 'Bansalan', 59, 'Davao del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1263, 'City of Davao', 59, 'Davao del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1264, 'City of Digos', 59, 'Davao del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1265, 'Hagonoy', 59, 'Davao del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1266, 'Kiblawan', 59, 'Davao del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1267, 'Magsaysay', 59, 'Davao del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1268, 'Malalag', 59, 'Davao del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1269, 'Matanao', 59, 'Davao del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1270, 'Padada', 59, 'Davao del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1271, 'Santa Cruz', 59, 'Davao del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1272, 'Sulop', 59, 'Davao del Sur', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1273, 'Baganga', 60, 'Davao Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1274, 'Banaybanay', 60, 'Davao Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1275, 'Boston', 60, 'Davao Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1276, 'Caraga', 60, 'Davao Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1277, 'Cateel', 60, 'Davao Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1278, 'Governor Generoso', 60, 'Davao Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1279, 'Lupon', 60, 'Davao Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1280, 'Manay', 60, 'Davao Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1281, 'City of Mati', 60, 'Davao Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1282, 'San Isidro', 60, 'Davao Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1283, 'Tarragona', 60, 'Davao Oriental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1284, 'Compostela', 61, 'Davao de Oro', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1285, 'Laak', 61, 'Davao de Oro', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1286, 'Mabini', 61, 'Davao de Oro', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1287, 'Maco', 61, 'Davao de Oro', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1288, 'Maragusan', 61, 'Davao de Oro', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1289, 'Mawab', 61, 'Davao de Oro', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1290, 'Monkayo', 61, 'Davao de Oro', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1291, 'Montevista', 61, 'Davao de Oro', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1292, 'Nabunturan', 61, 'Davao de Oro', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1293, 'New Bataan', 61, 'Davao de Oro', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1294, 'Pantukan', 61, 'Davao de Oro', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1295, 'Don Marcelino', 62, 'Davao Occidental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1296, 'Jose Abad Santos', 62, 'Davao Occidental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1297, 'Malita', 62, 'Davao Occidental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1298, 'Santa Maria', 62, 'Davao Occidental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1299, 'Sarangani', 62, 'Davao Occidental', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1300, 'Alamada', 63, 'Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1301, 'Carmen', 63, 'Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1302, 'Kabacan', 63, 'Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1303, 'City of Kidapawan', 63, 'Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1304, 'Libungan', 63, 'Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1305, 'Magpet', 63, 'Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1306, 'Makilala', 63, 'Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1307, 'Matalam', 63, 'Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1308, 'Midsayap', 63, 'Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1309, 'M Lang', 63, 'Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1310, 'Pigkawayan', 63, 'Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1311, 'Pikit', 63, 'Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1312, 'President Roxas', 63, 'Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1313, 'Tulunan', 63, 'Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1314, 'Antipas', 63, 'Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1315, 'Banisilan', 63, 'Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1316, 'Aleosan', 63, 'Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1317, 'Arakan', 63, 'Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1318, 'Banga', 64, 'South Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1319, 'City of General Santos', 64, 'South Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1320, 'City of Koronadal', 64, 'South Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1321, 'Norala', 64, 'South Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1322, 'Polomolok', 64, 'South Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1323, 'Surallah', 64, 'South Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1324, 'Tampakan', 64, 'South Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1325, 'Tantangan', 64, 'South Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1326, 'T Boli', 64, 'South Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1327, 'Tupi', 64, 'South Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1328, 'Santo Niño', 64, 'South Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1329, 'Lake Sebu', 64, 'South Cotabato', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1330, 'Bagumbayan', 65, 'Sultan Kudarat', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1331, 'Columbio', 65, 'Sultan Kudarat', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1332, 'Esperanza', 65, 'Sultan Kudarat', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1333, 'Isulan', 65, 'Sultan Kudarat', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1334, 'Kalamansig', 65, 'Sultan Kudarat', 174, 'Philippines', '2024-06-26 15:48:17', 1),
(1335, 'Lebak', 65, 'Sultan Kudarat', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1336, 'Lutayan', 65, 'Sultan Kudarat', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1337, 'Lambayong', 65, 'Sultan Kudarat', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1338, 'Palimbang', 65, 'Sultan Kudarat', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1339, 'President Quirino', 65, 'Sultan Kudarat', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1340, 'City of Tacurong', 65, 'Sultan Kudarat', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1341, 'Sen. Ninoy Aquino', 65, 'Sultan Kudarat', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1342, 'Alabel', 66, 'Sarangani', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1343, 'Glan', 66, 'Sarangani', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1344, 'Kiamba', 66, 'Sarangani', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1345, 'Maasim', 66, 'Sarangani', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1346, 'Maitum', 66, 'Sarangani', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1347, 'Malapatan', 66, 'Sarangani', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1348, 'Malungon', 66, 'Sarangani', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1349, 'Cotabato City', 66, 'Sarangani', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1350, 'Manila', 1, 'Metro Manila', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1351, 'Mandaluyong City', 1, 'Metro Manila', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1352, 'Marikina City', 1, 'Metro Manila', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1353, 'Pasig City', 1, 'Metro Manila', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1354, 'Quezon City', 1, 'Metro Manila', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1355, 'San Juan City', 1, 'Metro Manila', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1356, 'Caloocan City', 1, 'Metro Manila', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1357, 'Malabon City', 1, 'Metro Manila', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1358, 'Navotas City', 1, 'Metro Manila', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1359, 'Valenzuela City', 1, 'Metro Manila', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1360, 'Las Piñas City', 1, 'Metro Manila', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1361, 'Makati City', 1, 'Metro Manila', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1362, 'Muntinlupa City', 1, 'Metro Manila', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1363, 'Parañaque City', 1, 'Metro Manila', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1364, 'Pasay City', 1, 'Metro Manila', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1365, 'Pateros', 1, 'Metro Manila', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1366, 'Taguig City', 1, 'Metro Manila', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1367, 'Bangued', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1368, 'Boliney', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1369, 'Bucay', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1370, 'Bucloc', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1371, 'Daguioman', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1372, 'Danglas', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1373, 'Dolores', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1374, 'La Paz', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1375, 'Lacub', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1376, 'Lagangilang', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1377, 'Lagayan', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1378, 'Langiden', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1379, 'Licuan-Baay', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1380, 'Luba', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1381, 'Malibcong', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1382, 'Manabo', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1383, 'Peñarrubia', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1384, 'Pidigan', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1385, 'Pilar', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1386, 'Sallapadan', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1387, 'San Isidro', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1388, 'San Juan', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1389, 'San Quintin', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1390, 'Tayum', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1391, 'Tineg', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1392, 'Tubo', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1393, 'Villaviciosa', 67, 'Abra', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1394, 'Atok', 68, 'Benguet', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1395, 'City of Baguio', 68, 'Benguet', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1396, 'Bakun', 68, 'Benguet', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1397, 'Bokod', 68, 'Benguet', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1398, 'Buguias', 68, 'Benguet', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1399, 'Itogon', 68, 'Benguet', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1400, 'Kabayan', 68, 'Benguet', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1401, 'Kapangan', 68, 'Benguet', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1402, 'Kibungan', 68, 'Benguet', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1403, 'La Trinidad', 68, 'Benguet', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1404, 'Mankayan', 68, 'Benguet', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1405, 'Sablan', 68, 'Benguet', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1406, 'Tuba', 68, 'Benguet', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1407, 'Tublay', 68, 'Benguet', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1408, 'Banaue', 69, 'Ifugao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1409, 'Hungduan', 69, 'Ifugao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1410, 'Kiangan', 69, 'Ifugao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1411, 'Lagawe', 69, 'Ifugao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1412, 'Lamut', 69, 'Ifugao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1413, 'Mayoyao', 69, 'Ifugao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1414, 'Alfonso Lista', 69, 'Ifugao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1415, 'Aguinaldo', 69, 'Ifugao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1416, 'Hingyon', 69, 'Ifugao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1417, 'Tinoc', 69, 'Ifugao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1418, 'Asipulo', 69, 'Ifugao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1419, 'Balbalan', 70, 'Kalinga', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1420, 'Lubuagan', 70, 'Kalinga', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1421, 'Pasil', 70, 'Kalinga', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1422, 'Pinukpuk', 70, 'Kalinga', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1423, 'Rizal', 70, 'Kalinga', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1424, 'City of Tabuk', 70, 'Kalinga', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1425, 'Tanudan', 70, 'Kalinga', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1426, 'Tinglayan', 70, 'Kalinga', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1427, 'Barlig', 71, 'Mountain Province', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1428, 'Bauko', 71, 'Mountain Province', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1429, 'Besao', 71, 'Mountain Province', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1430, 'Bontoc', 71, 'Mountain Province', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1431, 'Natonin', 71, 'Mountain Province', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1432, 'Paracelis', 71, 'Mountain Province', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1433, 'Sabangan', 71, 'Mountain Province', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1434, 'Sadanga', 71, 'Mountain Province', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1435, 'Sagada', 71, 'Mountain Province', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1436, 'Tadian', 71, 'Mountain Province', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1437, 'Calanasan', 72, 'Apayao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1438, 'Conner', 72, 'Apayao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1439, 'Flora', 72, 'Apayao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1440, 'Kabugao', 72, 'Apayao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1441, 'Luna', 72, 'Apayao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1442, 'Pudtol', 72, 'Apayao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1443, 'Santa Marcela', 72, 'Apayao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1444, 'City of Lamitan', 73, 'Basilan', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1445, 'Lantawan', 73, 'Basilan', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1446, 'Maluso', 73, 'Basilan', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1447, 'Sumisip', 73, 'Basilan', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1448, 'Tipo-Tipo', 73, 'Basilan', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1449, 'Tuburan', 73, 'Basilan', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1450, 'Akbar', 73, 'Basilan', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1451, 'Al-Barka', 73, 'Basilan', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1452, 'Hadji Mohammad Ajul', 73, 'Basilan', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1453, 'Ungkaya Pukan', 73, 'Basilan', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1454, 'Hadji Muhtamad', 73, 'Basilan', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1455, 'Tabuan-Lasa', 73, 'Basilan', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1456, 'Bacolod-Kalawi', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1457, 'Balabagan', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1458, 'Balindong', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1459, 'Bayang', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1460, 'Binidayan', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1461, 'Bubong', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1462, 'Butig', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1463, 'Ganassi', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1464, 'Kapai', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1465, 'Lumba-Bayabao', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1466, 'Lumbatan', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1467, 'Madalum', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1468, 'Madamba', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1469, 'Malabang', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1470, 'Marantao', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1471, 'City of Marawi', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1472, 'Masiu', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1473, 'Mulondo', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1474, 'Pagayawan', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1475, 'Piagapo', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1476, 'Poona Bayabao', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1477, 'Pualas', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1478, 'Ditsaan-Ramain', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1479, 'Saguiaran', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1480, 'Tamparan', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1481, 'Taraka', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1482, 'Tubaran', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1483, 'Tugaya', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1484, 'Wao', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1485, 'Marogong', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1486, 'Calanogas', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1487, 'Buadiposo-Buntong', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1488, 'Maguing', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1489, 'Picong', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1490, 'Lumbayanague', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1491, 'Amai Manabilang', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1492, 'Tagoloan Ii', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1493, 'Kapatagan', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1494, 'Sultan Dumalondong', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1495, 'Lumbaca-Unayan', 74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1496, 'Ampatuan', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1497, 'Buldon', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1498, 'Buluan', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1499, 'Datu Paglas', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1500, 'Datu Piang', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1501, 'Datu Odin Sinsuat', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1502, 'Shariff Aguak', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1503, 'Matanog', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1504, 'Pagalungan', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1505, 'Parang', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1506, 'Sultan Kudarat', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1507, 'Sultan Sa Barongis', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1508, 'Kabuntalan', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1509, 'Upi', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1510, 'Talayan', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1511, 'South Upi', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1512, 'Barira', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1513, 'Gen. S.K. Pendatun', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1514, 'Mamasapano', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1515, 'Talitay', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1516, 'Pagagawan', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1517, 'Paglat', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1518, 'Sultan Mastura', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1519, 'Guindulungan', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1520, 'Datu Saudi-Ampatuan', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1521, 'Datu Unsay', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1522, 'Datu Abdullah Sangki', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1523, 'Rajah Buayan', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1524, 'Datu Blah T. Sinsuat', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1525, 'Datu Anggal Midtimbang', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1526, 'Mangudadatu', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1527, 'Pandag', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1528, 'Northern Kabuntalan', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1529, 'Datu Hoffer Ampatuan', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1530, 'Datu Salibo', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1531, 'Shariff Saydona Mustapha', 75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1532, 'Indanan', 76, 'Sulu', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1533, 'Jolo', 76, 'Sulu', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1534, 'Kalingalan Caluang', 76, 'Sulu', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1535, 'Luuk', 76, 'Sulu', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1536, 'Maimbung', 76, 'Sulu', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1537, 'Hadji Panglima Tahil', 76, 'Sulu', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1538, 'Old Panamao', 76, 'Sulu', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1539, 'Pangutaran', 76, 'Sulu', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1540, 'Parang', 76, 'Sulu', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1541, 'Pata', 76, 'Sulu', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1542, 'Patikul', 76, 'Sulu', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1543, 'Siasi', 76, 'Sulu', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1544, 'Talipao', 76, 'Sulu', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1545, 'Tapul', 76, 'Sulu', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1546, 'Tongkil', 76, 'Sulu', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1547, 'Panglima Estino', 76, 'Sulu', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1548, 'Lugus', 76, 'Sulu', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1549, 'Pandami', 76, 'Sulu', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1550, 'Omar', 76, 'Sulu', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1551, 'Panglima Sugala', 77, 'Tawi-Tawi', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1552, 'Bongao (Capital)', 77, 'Tawi-Tawi', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1553, 'Mapun', 77, 'Tawi-Tawi', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1554, 'Simunul', 77, 'Tawi-Tawi', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1555, 'Sitangkai', 77, 'Tawi-Tawi', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1556, 'South Ubian', 77, 'Tawi-Tawi', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1557, 'Tandubas', 77, 'Tawi-Tawi', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1558, 'Turtle Islands', 77, 'Tawi-Tawi', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1559, 'Languyan', 77, 'Tawi-Tawi', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1560, 'Sapa-Sapa', 77, 'Tawi-Tawi', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1561, 'Sibutu', 77, 'Tawi-Tawi', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1562, 'Buenavista', 78, 'Agusan del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1563, 'City of Butuan', 78, 'Agusan del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1564, 'City of Cabadbaran', 78, 'Agusan del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1565, 'Carmen', 78, 'Agusan del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1566, 'Jabonga', 78, 'Agusan del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1567, 'Kitcharao', 78, 'Agusan del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1568, 'Las Nieves', 78, 'Agusan del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1569, 'Magallanes', 78, 'Agusan del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1570, 'Nasipit', 78, 'Agusan del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1571, 'Santiago', 78, 'Agusan del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1572, 'Tubay', 78, 'Agusan del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1573, 'Remedios T. Romualdez', 78, 'Agusan del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1574, 'City of Bayugan', 79, 'Agusan del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1575, 'Bunawan', 79, 'Agusan del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1576, 'Esperanza', 79, 'Agusan del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1577, 'La Paz', 79, 'Agusan del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1578, 'Loreto', 79, 'Agusan del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1579, 'Prosperidad', 79, 'Agusan del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1580, 'Rosario', 79, 'Agusan del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1581, 'San Francisco', 79, 'Agusan del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1582, 'San Luis', 79, 'Agusan del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1583, 'Santa Josefa', 79, 'Agusan del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1584, 'Talacogon', 79, 'Agusan del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1585, 'Trento', 79, 'Agusan del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1586, 'Veruela', 79, 'Agusan del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1587, 'Sibagat', 79, 'Agusan del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1588, 'Alegria', 80, 'Surigao del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1589, 'Bacuag', 80, 'Surigao del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1590, 'Burgos', 80, 'Surigao del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1591, 'Claver', 80, 'Surigao del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1592, 'Dapa', 80, 'Surigao del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1593, 'Del Carmen', 80, 'Surigao del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1594, 'General Luna', 80, 'Surigao del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1595, 'Gigaquit', 80, 'Surigao del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1596, 'Mainit', 80, 'Surigao del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1597, 'Malimono', 80, 'Surigao del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1598, 'Pilar', 80, 'Surigao del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1599, 'Placer', 80, 'Surigao del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1600, 'San Benito', 80, 'Surigao del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1601, 'San Francisco', 80, 'Surigao del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1602, 'San Isidro', 80, 'Surigao del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1603, 'Santa Monica', 80, 'Surigao del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1604, 'Sison', 80, 'Surigao del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1605, 'Socorro', 80, 'Surigao del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1606, 'City of Surigao', 80, 'Surigao del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1607, 'Tagana-An', 80, 'Surigao del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1608, 'Tubod', 80, 'Surigao del Norte', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1609, 'Barobo', 81, 'Surigao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1610, 'Bayabas', 81, 'Surigao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1611, 'City of Bislig', 81, 'Surigao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1612, 'Cagwait', 81, 'Surigao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1613, 'Cantilan', 81, 'Surigao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1614, 'Carmen', 81, 'Surigao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1615, 'Carrascal', 81, 'Surigao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1616, 'Cortes', 81, 'Surigao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1617, 'Hinatuan', 81, 'Surigao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1618, 'Lanuza', 81, 'Surigao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1619, 'Lianga', 81, 'Surigao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1620, 'Lingig', 81, 'Surigao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1621, 'Madrid', 81, 'Surigao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1622, 'Marihatag', 81, 'Surigao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1623, 'San Agustin', 81, 'Surigao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1624, 'San Miguel', 81, 'Surigao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1625, 'Tagbina', 81, 'Surigao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1626, 'Tago', 81, 'Surigao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1627, 'City of Tandag', 81, 'Surigao del Sur', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1628, 'Basilisa', 82, 'Dinagat Islands', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1629, 'Cagdianao', 82, 'Dinagat Islands', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1630, 'Dinagat', 82, 'Dinagat Islands', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1631, 'Libjo', 82, 'Dinagat Islands', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1632, 'Loreto', 82, 'Dinagat Islands', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1633, 'San Jose', 82, 'Dinagat Islands', 174, 'Philippines', '2024-06-26 15:48:18', 1),
(1634, 'Tubajon', 82, 'Dinagat Islands', 174, 'Philippines', '2024-06-26 15:48:18', 1);

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
-- Table structure for table `civil_status`
--

DROP TABLE IF EXISTS `civil_status`;
CREATE TABLE `civil_status` (
  `civil_status_id` int(10) UNSIGNED NOT NULL,
  `civil_status_name` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `civil_status`
--

INSERT INTO `civil_status` (`civil_status_id`, `civil_status_name`, `created_date`, `last_log_by`) VALUES
(1, 'Divorced', '2024-07-03 10:12:10', 2),
(2, 'Engaged', '2024-07-03 10:12:19', 2),
(3, 'In a Relationship', '2024-07-03 10:12:24', 2),
(4, 'Married', '2024-07-03 10:12:28', 2),
(5, 'Separated', '2024-07-03 10:12:32', 2),
(6, 'Single', '2024-07-03 10:12:37', 2),
(7, 'Widowed', '2024-07-03 10:12:42', 2);

--
-- Triggers `civil_status`
--
DROP TRIGGER IF EXISTS `civil_status_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `civil_status_trigger_insert` AFTER INSERT ON `civil_status` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Civil status created. <br/>';

    IF NEW.civil_status_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Civil Status Name: ", NEW.civil_status_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('civil_status', NEW.civil_status_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `civil_status_trigger_update`;
DELIMITER $$
CREATE TRIGGER `civil_status_trigger_update` AFTER UPDATE ON `civil_status` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.civil_status_name <> OLD.civil_status_name THEN
        SET audit_log = CONCAT(audit_log, "Civil Status Name: ", OLD.civil_status_name, " -> ", NEW.civil_status_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('civil_status', NEW.civil_status_id, audit_log, NEW.last_log_by, NOW());
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
-- Table structure for table `contact_information_type`
--

DROP TABLE IF EXISTS `contact_information_type`;
CREATE TABLE `contact_information_type` (
  `contact_information_type_id` int(10) UNSIGNED NOT NULL,
  `contact_information_type_name` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `contact_information_type`
--

INSERT INTO `contact_information_type` (`contact_information_type_id`, `contact_information_type_name`, `created_date`, `last_log_by`) VALUES
(1, 'Personal', '2024-07-03 11:59:46', 2),
(2, 'Work', '2024-07-03 11:59:50', 2);

--
-- Triggers `contact_information_type`
--
DROP TRIGGER IF EXISTS `contact_information_type_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `contact_information_type_trigger_insert` AFTER INSERT ON `contact_information_type` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Contact information type created. <br/>';

    IF NEW.contact_information_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Contact Information Type Name: ", NEW.contact_information_type_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('contact_information_type', NEW.contact_information_type_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `contact_information_type_trigger_update`;
DELIMITER $$
CREATE TRIGGER `contact_information_type_trigger_update` AFTER UPDATE ON `contact_information_type` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.contact_information_type_name <> OLD.contact_information_type_name THEN
        SET audit_log = CONCAT(audit_log, "Contact Information Type Name: ", OLD.contact_information_type_name, " -> ", NEW.contact_information_type_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('contact_information_type', NEW.contact_information_type_id, audit_log, NEW.last_log_by, NOW());
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
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `country`
--

INSERT INTO `country` (`country_id`, `country_name`, `created_date`, `last_log_by`) VALUES
(1, 'Afghanistan', '2024-06-26 15:33:55', 1),
(2, 'Aland Islands', '2024-06-26 15:33:55', 1),
(3, 'Albania', '2024-06-26 15:33:55', 1),
(4, 'Algeria', '2024-06-26 15:33:55', 1),
(5, 'American Samoa', '2024-06-26 15:33:55', 1),
(6, 'Andorra', '2024-06-26 15:33:55', 1),
(7, 'Angola', '2024-06-26 15:33:55', 1),
(8, 'Anguilla', '2024-06-26 15:33:55', 1),
(9, 'Antarctica', '2024-06-26 15:33:55', 1),
(10, 'Antigua And Barbuda', '2024-06-26 15:33:55', 1),
(11, 'Argentina', '2024-06-26 15:33:55', 1),
(12, 'Armenia', '2024-06-26 15:33:55', 1),
(13, 'Aruba', '2024-06-26 15:33:55', 1),
(14, 'Australia', '2024-06-26 15:33:55', 1),
(15, 'Austria', '2024-06-26 15:33:55', 1),
(16, 'Azerbaijan', '2024-06-26 15:33:55', 1),
(17, 'Bahrain', '2024-06-26 15:33:55', 1),
(18, 'Bangladesh', '2024-06-26 15:33:55', 1),
(19, 'Barbados', '2024-06-26 15:33:55', 1),
(20, 'Belarus', '2024-06-26 15:33:55', 1),
(21, 'Belgium', '2024-06-26 15:33:55', 1),
(22, 'Belize', '2024-06-26 15:33:55', 1),
(23, 'Benin', '2024-06-26 15:33:55', 1),
(24, 'Bermuda', '2024-06-26 15:33:55', 1),
(25, 'Bhutan', '2024-06-26 15:33:55', 1),
(26, 'Bolivia', '2024-06-26 15:33:55', 1),
(27, 'Bonaire, Sint Eustatius and Saba', '2024-06-26 15:33:55', 1),
(28, 'Bosnia and Herzegovina', '2024-06-26 15:33:55', 1),
(29, 'Botswana', '2024-06-26 15:33:55', 1),
(30, 'Bouvet Island', '2024-06-26 15:33:55', 1),
(31, 'Brazil', '2024-06-26 15:33:55', 1),
(32, 'British Indian Ocean Territory', '2024-06-26 15:33:55', 1),
(33, 'Brunei', '2024-06-26 15:33:55', 1),
(34, 'Bulgaria', '2024-06-26 15:33:55', 1),
(35, 'Burkina Faso', '2024-06-26 15:33:55', 1),
(36, 'Burundi', '2024-06-26 15:33:55', 1),
(37, 'Cambodia', '2024-06-26 15:33:55', 1),
(38, 'Cameroon', '2024-06-26 15:33:55', 1),
(39, 'Canada', '2024-06-26 15:33:55', 1),
(40, 'Cape Verde', '2024-06-26 15:33:55', 1),
(41, 'Cayman Islands', '2024-06-26 15:33:55', 1),
(42, 'Central African Republic', '2024-06-26 15:33:55', 1),
(43, 'Chad', '2024-06-26 15:33:55', 1),
(44, 'Chile', '2024-06-26 15:33:55', 1),
(45, 'China', '2024-06-26 15:33:55', 1),
(46, 'Christmas Island', '2024-06-26 15:33:55', 1),
(47, 'Cocos (Keeling) Islands', '2024-06-26 15:33:55', 1),
(48, 'Colombia', '2024-06-26 15:33:55', 1),
(49, 'Comoros', '2024-06-26 15:33:55', 1),
(50, 'Congo', '2024-06-26 15:33:55', 1),
(51, 'Cook Islands', '2024-06-26 15:33:55', 1),
(52, 'Costa Rica', '2024-06-26 15:33:55', 1),
(53, 'Cote D Ivoire (Ivory Coast)', '2024-06-26 15:33:55', 1),
(54, 'Croatia', '2024-06-26 15:33:55', 1),
(55, 'Cuba', '2024-06-26 15:33:55', 1),
(56, 'CuraÃ§ao', '2024-06-26 15:33:55', 1),
(57, 'Cyprus', '2024-06-26 15:33:55', 1),
(58, 'Czech Republic', '2024-06-26 15:33:55', 1),
(59, 'Democratic Republic of the Congo', '2024-06-26 15:33:55', 1),
(60, 'Denmark', '2024-06-26 15:33:55', 1),
(61, 'Djibouti', '2024-06-26 15:33:55', 1),
(62, 'Dominica', '2024-06-26 15:33:55', 1),
(63, 'Dominican Republic', '2024-06-26 15:33:55', 1),
(64, 'East Timor', '2024-06-26 15:33:55', 1),
(65, 'Ecuador', '2024-06-26 15:33:55', 1),
(66, 'Egypt', '2024-06-26 15:33:55', 1),
(67, 'El Salvador', '2024-06-26 15:33:55', 1),
(68, 'Equatorial Guinea', '2024-06-26 15:33:55', 1),
(69, 'Eritrea', '2024-06-26 15:33:55', 1),
(70, 'Estonia', '2024-06-26 15:33:55', 1),
(71, 'Ethiopia', '2024-06-26 15:33:55', 1),
(72, 'Falkland Islands', '2024-06-26 15:33:55', 1),
(73, 'Faroe Islands', '2024-06-26 15:33:55', 1),
(74, 'Fiji Islands', '2024-06-26 15:33:55', 1),
(75, 'Finland', '2024-06-26 15:33:55', 1),
(76, 'France', '2024-06-26 15:33:55', 1),
(77, 'French Guiana', '2024-06-26 15:33:55', 1),
(78, 'French Polynesia', '2024-06-26 15:33:55', 1),
(79, 'French Southern Territories', '2024-06-26 15:33:55', 1),
(80, 'Gabon', '2024-06-26 15:33:55', 1),
(81, 'Gambia The', '2024-06-26 15:33:55', 1),
(82, 'Georgia', '2024-06-26 15:33:55', 1),
(83, 'Germany', '2024-06-26 15:33:55', 1),
(84, 'Ghana', '2024-06-26 15:33:55', 1),
(85, 'Gibraltar', '2024-06-26 15:33:55', 1),
(86, 'Greece', '2024-06-26 15:33:55', 1),
(87, 'Greenland', '2024-06-26 15:33:55', 1),
(88, 'Grenada', '2024-06-26 15:33:55', 1),
(89, 'Guadeloupe', '2024-06-26 15:33:55', 1),
(90, 'Guam', '2024-06-26 15:33:55', 1),
(91, 'Guatemala', '2024-06-26 15:33:55', 1),
(92, 'Guernsey and Alderney', '2024-06-26 15:33:55', 1),
(93, 'Guinea', '2024-06-26 15:33:55', 1),
(94, 'Guinea-Bissau', '2024-06-26 15:33:55', 1),
(95, 'Guyana', '2024-06-26 15:33:55', 1),
(96, 'Haiti', '2024-06-26 15:33:55', 1),
(97, 'Heard Island and McDonald Islands', '2024-06-26 15:33:56', 1),
(98, 'Honduras', '2024-06-26 15:33:56', 1),
(99, 'Hong Kong S.A.R.', '2024-06-26 15:33:56', 1),
(100, 'Hungary', '2024-06-26 15:33:56', 1),
(101, 'Iceland', '2024-06-26 15:33:56', 1),
(102, 'India', '2024-06-26 15:33:56', 1),
(103, 'Indonesia', '2024-06-26 15:33:56', 1),
(104, 'Iran', '2024-06-26 15:33:56', 1),
(105, 'Iraq', '2024-06-26 15:33:56', 1),
(106, 'Ireland', '2024-06-26 15:33:56', 1),
(107, 'Israel', '2024-06-26 15:33:56', 1),
(108, 'Italy', '2024-06-26 15:33:56', 1),
(109, 'Jamaica', '2024-06-26 15:33:56', 1),
(110, 'Japan', '2024-06-26 15:33:56', 1),
(111, 'Jersey', '2024-06-26 15:33:56', 1),
(112, 'Jordan', '2024-06-26 15:33:56', 1),
(113, 'Kazakhstan', '2024-06-26 15:33:56', 1),
(114, 'Kenya', '2024-06-26 15:33:56', 1),
(115, 'Kiribati', '2024-06-26 15:33:56', 1),
(116, 'Kosovo', '2024-06-26 15:33:56', 1),
(117, 'Kuwait', '2024-06-26 15:33:56', 1),
(118, 'Kyrgyzstan', '2024-06-26 15:33:56', 1),
(119, 'Laos', '2024-06-26 15:33:56', 1),
(120, 'Latvia', '2024-06-26 15:33:56', 1),
(121, 'Lebanon', '2024-06-26 15:33:56', 1),
(122, 'Lesotho', '2024-06-26 15:33:56', 1),
(123, 'Liberia', '2024-06-26 15:33:56', 1),
(124, 'Libya', '2024-06-26 15:33:56', 1),
(125, 'Liechtenstein', '2024-06-26 15:33:56', 1),
(126, 'Lithuania', '2024-06-26 15:33:56', 1),
(127, 'Luxembourg', '2024-06-26 15:33:56', 1),
(128, 'Macau S.A.R.', '2024-06-26 15:33:56', 1),
(129, 'Madagascar', '2024-06-26 15:33:56', 1),
(130, 'Malawi', '2024-06-26 15:33:56', 1),
(131, 'Malaysia', '2024-06-26 15:33:56', 1),
(132, 'Maldives', '2024-06-26 15:33:56', 1),
(133, 'Mali', '2024-06-26 15:33:56', 1),
(134, 'Malta', '2024-06-26 15:33:56', 1),
(135, 'Man (Isle of)', '2024-06-26 15:33:56', 1),
(136, 'Marshall Islands', '2024-06-26 15:33:56', 1),
(137, 'Martinique', '2024-06-26 15:33:56', 1),
(138, 'Mauritania', '2024-06-26 15:33:56', 1),
(139, 'Mauritius', '2024-06-26 15:33:56', 1),
(140, 'Mayotte', '2024-06-26 15:33:56', 1),
(141, 'Mexico', '2024-06-26 15:33:56', 1),
(142, 'Micronesia', '2024-06-26 15:33:56', 1),
(143, 'Moldova', '2024-06-26 15:33:56', 1),
(144, 'Monaco', '2024-06-26 15:33:56', 1),
(145, 'Mongolia', '2024-06-26 15:33:56', 1),
(146, 'Montenegro', '2024-06-26 15:33:56', 1),
(147, 'Montserrat', '2024-06-26 15:33:56', 1),
(148, 'Morocco', '2024-06-26 15:33:56', 1),
(149, 'Mozambique', '2024-06-26 15:33:56', 1),
(150, 'Myanmar', '2024-06-26 15:33:56', 1),
(151, 'Namibia', '2024-06-26 15:33:56', 1),
(152, 'Nauru', '2024-06-26 15:33:56', 1),
(153, 'Nepal', '2024-06-26 15:33:56', 1),
(154, 'Netherlands', '2024-06-26 15:33:56', 1),
(155, 'New Caledonia', '2024-06-26 15:33:56', 1),
(156, 'New Zealand', '2024-06-26 15:33:56', 1),
(157, 'Nicaragua', '2024-06-26 15:33:56', 1),
(158, 'Niger', '2024-06-26 15:33:56', 1),
(159, 'Nigeria', '2024-06-26 15:33:56', 1),
(160, 'Niue', '2024-06-26 15:33:56', 1),
(161, 'Norfolk Island', '2024-06-26 15:33:56', 1),
(162, 'North Korea', '2024-06-26 15:33:56', 1),
(163, 'North Macedonia', '2024-06-26 15:33:56', 1),
(164, 'Northern Mariana Islands', '2024-06-26 15:33:56', 1),
(165, 'Norway', '2024-06-26 15:33:56', 1),
(166, 'Oman', '2024-06-26 15:33:56', 1),
(167, 'Pakistan', '2024-06-26 15:33:56', 1),
(168, 'Palau', '2024-06-26 15:33:56', 1),
(169, 'Palestinian Territory Occupied', '2024-06-26 15:33:56', 1),
(170, 'Panama', '2024-06-26 15:33:56', 1),
(171, 'Papua new Guinea', '2024-06-26 15:33:56', 1),
(172, 'Paraguay', '2024-06-26 15:33:56', 1),
(173, 'Peru', '2024-06-26 15:33:56', 1),
(174, 'Philippines', '2024-06-26 15:33:56', 1),
(175, 'Pitcairn Island', '2024-06-26 15:33:56', 1),
(176, 'Poland', '2024-06-26 15:33:56', 1),
(177, 'Portugal', '2024-06-26 15:33:56', 1),
(178, 'Puerto Rico', '2024-06-26 15:33:56', 1),
(179, 'Qatar', '2024-06-26 15:33:56', 1),
(180, 'Reunion', '2024-06-26 15:33:56', 1),
(181, 'Romania', '2024-06-26 15:33:56', 1),
(182, 'Russia', '2024-06-26 15:33:56', 1),
(183, 'Rwanda', '2024-06-26 15:33:56', 1),
(184, 'Saint Helena', '2024-06-26 15:33:56', 1),
(185, 'Saint Kitts And Nevis', '2024-06-26 15:33:56', 1),
(186, 'Saint Lucia', '2024-06-26 15:33:56', 1),
(187, 'Saint Pierre and Miquelon', '2024-06-26 15:33:56', 1),
(188, 'Saint Vincent And The Grenadines', '2024-06-26 15:33:56', 1),
(189, 'Saint-Barthelemy', '2024-06-26 15:33:56', 1),
(190, 'Saint-Martin (French part)', '2024-06-26 15:33:56', 1),
(191, 'Samoa', '2024-06-26 15:33:56', 1),
(192, 'San Marino', '2024-06-26 15:33:56', 1),
(193, 'Sao Tome and Principe', '2024-06-26 15:33:56', 1),
(194, 'Saudi Arabia', '2024-06-26 15:33:56', 1),
(195, 'Senegal', '2024-06-26 15:33:56', 1),
(196, 'Serbia', '2024-06-26 15:33:56', 1),
(197, 'Seychelles', '2024-06-26 15:33:56', 1),
(198, 'Sierra Leone', '2024-06-26 15:33:56', 1),
(199, 'Singapore', '2024-06-26 15:33:56', 1),
(200, 'Sint Maarten (Dutch part)', '2024-06-26 15:33:56', 1),
(201, 'Slovakia', '2024-06-26 15:33:56', 1),
(202, 'Slovenia', '2024-06-26 15:33:56', 1),
(203, 'Solomon Islands', '2024-06-26 15:33:56', 1),
(204, 'Somalia', '2024-06-26 15:33:56', 1),
(205, 'South Africa', '2024-06-26 15:33:56', 1),
(206, 'South Georgia', '2024-06-26 15:33:56', 1),
(207, 'South Korea', '2024-06-26 15:33:56', 1),
(208, 'South Sudan', '2024-06-26 15:33:56', 1),
(209, 'Spain', '2024-06-26 15:33:56', 1),
(210, 'Sri Lanka', '2024-06-26 15:33:56', 1),
(211, 'Sudan', '2024-06-26 15:33:56', 1),
(212, 'Suriname', '2024-06-26 15:33:56', 1),
(213, 'Svalbard And Jan Mayen Islands', '2024-06-26 15:33:56', 1),
(214, 'Swaziland', '2024-06-26 15:33:56', 1),
(215, 'Sweden', '2024-06-26 15:33:56', 1),
(216, 'Switzerland', '2024-06-26 15:33:56', 1),
(217, 'Syria', '2024-06-26 15:33:56', 1),
(218, 'Taiwan', '2024-06-26 15:33:56', 1),
(219, 'Tajikistan', '2024-06-26 15:33:56', 1),
(220, 'Tanzania', '2024-06-26 15:33:56', 1),
(221, 'Thailand', '2024-06-26 15:33:56', 1),
(222, 'The Bahamas', '2024-06-26 15:33:56', 1),
(223, 'Togo', '2024-06-26 15:33:56', 1),
(224, 'Tokelau', '2024-06-26 15:33:56', 1),
(225, 'Tonga', '2024-06-26 15:33:56', 1),
(226, 'Trinidad And Tobago', '2024-06-26 15:33:56', 1),
(227, 'Tunisia', '2024-06-26 15:33:56', 1),
(228, 'Turkey', '2024-06-26 15:33:56', 1),
(229, 'Turkmenistan', '2024-06-26 15:33:56', 1),
(230, 'Turks And Caicos Islands', '2024-06-26 15:33:56', 1),
(231, 'Tuvalu', '2024-06-26 15:33:56', 1),
(232, 'Uganda', '2024-06-26 15:33:56', 1),
(233, 'Ukraine', '2024-06-26 15:33:56', 1),
(234, 'United Arab Emirates', '2024-06-26 15:33:56', 1),
(235, 'United Kingdom', '2024-06-26 15:33:56', 1),
(236, 'United States', '2024-06-26 15:33:56', 1),
(237, 'United States Minor Outlying Islands', '2024-06-26 15:33:56', 1),
(238, 'Uruguay', '2024-06-26 15:33:56', 1),
(239, 'Uzbekistan', '2024-06-26 15:33:56', 1),
(240, 'Vanuatu', '2024-06-26 15:33:56', 1),
(241, 'Vatican City State (Holy See)', '2024-06-26 15:33:56', 1),
(242, 'Venezuela', '2024-06-26 15:33:56', 1),
(243, 'Vietnam', '2024-06-26 15:33:56', 1),
(244, 'Virgin Islands (British)', '2024-06-26 15:33:56', 1),
(245, 'Virgin Islands (US)', '2024-06-26 15:33:56', 1),
(246, 'Wallis And Futuna Islands', '2024-06-26 15:33:56', 1),
(247, 'Western Sahara', '2024-06-26 15:33:56', 1),
(248, 'Yemen', '2024-06-26 15:33:56', 1),
(249, 'Zambia', '2024-06-26 15:33:56', 1),
(250, 'Zimbabwe', '2024-06-26 15:33:56', 1);

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
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
-- Table structure for table `department`
--

DROP TABLE IF EXISTS `department`;
CREATE TABLE `department` (
  `department_id` int(10) UNSIGNED NOT NULL,
  `department_name` varchar(100) NOT NULL,
  `parent_department_id` int(11) DEFAULT NULL,
  `parent_department_name` varchar(100) DEFAULT NULL,
  `manager_id` int(11) DEFAULT NULL,
  `manager_name` varchar(100) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `department`
--
DROP TRIGGER IF EXISTS `department_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `department_trigger_insert` AFTER INSERT ON `department` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Department created. <br/>';

    IF NEW.department_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Department Name: ", NEW.department_name);
    END IF;

    IF NEW.parent_department_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Parent Department Name: ", NEW.parent_department_name);
    END IF;

    IF NEW.manager_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Manager Name: ", NEW.manager_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('department', NEW.department_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `department_trigger_update`;
DELIMITER $$
CREATE TRIGGER `department_trigger_update` AFTER UPDATE ON `department` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.department_name <> OLD.department_name THEN
        SET audit_log = CONCAT(audit_log, "Department Name: ", OLD.department_name, " -> ", NEW.department_name, "<br/>");
    END IF;

    IF NEW.parent_department_name <> OLD.parent_department_name THEN
        SET audit_log = CONCAT(audit_log, "Parent Department Name: ", OLD.parent_department_name, " -> ", NEW.parent_department_name, "<br/>");
    END IF;

    IF NEW.manager_name <> OLD.manager_name THEN
        SET audit_log = CONCAT(audit_log, "Manager Name: ", OLD.manager_name, " -> ", NEW.manager_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('department', NEW.department_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `departure_reason`
--

DROP TABLE IF EXISTS `departure_reason`;
CREATE TABLE `departure_reason` (
  `departure_reason_id` int(10) UNSIGNED NOT NULL,
  `departure_reason_name` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `departure_reason`
--
DROP TRIGGER IF EXISTS `departure_reason_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `departure_reason_trigger_insert` AFTER INSERT ON `departure_reason` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Departure reason created. <br/>';

    IF NEW.departure_reason_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Departure Reason Name: ", NEW.departure_reason_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('departure_reason', NEW.departure_reason_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `departure_reason_trigger_update`;
DELIMITER $$
CREATE TRIGGER `departure_reason_trigger_update` AFTER UPDATE ON `departure_reason` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.departure_reason_name <> OLD.departure_reason_name THEN
        SET audit_log = CONCAT(audit_log, "Departure Reason Name: ", OLD.departure_reason_name, " -> ", NEW.departure_reason_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('departure_reason', NEW.departure_reason_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `educational_stage`
--

DROP TABLE IF EXISTS `educational_stage`;
CREATE TABLE `educational_stage` (
  `educational_stage_id` int(10) UNSIGNED NOT NULL,
  `educational_stage_name` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `educational_stage`
--

INSERT INTO `educational_stage` (`educational_stage_id`, `educational_stage_name`, `created_date`, `last_log_by`) VALUES
(1, 'College', '2024-07-03 10:30:05', 2),
(2, 'Junior High School', '2024-07-03 10:30:10', 2),
(3, 'Postgraduate', '2024-07-03 10:30:13', 2),
(4, 'Preschool', '2024-07-03 10:30:17', 2),
(5, 'Primary School', '2024-07-03 10:30:21', 2),
(6, 'Senior High School', '2024-07-03 10:30:25', 2);

--
-- Triggers `educational_stage`
--
DROP TRIGGER IF EXISTS `educational_stage_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `educational_stage_trigger_insert` AFTER INSERT ON `educational_stage` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Educational stage created. <br/>';

    IF NEW.educational_stage_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Educational Stage Name: ", NEW.educational_stage_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('educational_stage', NEW.educational_stage_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `educational_stage_trigger_update`;
DELIMITER $$
CREATE TRIGGER `educational_stage_trigger_update` AFTER UPDATE ON `educational_stage` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.educational_stage_name <> OLD.educational_stage_name THEN
        SET audit_log = CONCAT(audit_log, "Educational Stage Name: ", OLD.educational_stage_name, " -> ", NEW.educational_stage_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('educational_stage', NEW.educational_stage_id, audit_log, NEW.last_log_by, NOW());
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
(1, 'Security Email Setting', '\r\nEmail setting for security emails.', 'smtp.hostinger.com', '465', 1, 0, 'cgmi-noreply@christianmotors.ph', 'UsDpF0dYRC6M9v0tT3MHq%2BlrRJu01%2Fb95Dq%2BAeCfu2Y%3D', 'ssl', 'cgmi-noreply@christianmotors.ph', 'cgmi-noreply@christianmotors.ph', '2024-06-26 16:43:58', 1);

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
-- Table structure for table `employee`
--

DROP TABLE IF EXISTS `employee`;
CREATE TABLE `employee` (
  `employee_id` int(10) UNSIGNED NOT NULL,
  `employee_image` varchar(500) DEFAULT NULL,
  `employee_digital_signature` varchar(500) DEFAULT NULL,
  `file_as` varchar(1000) NOT NULL,
  `first_name` varchar(300) NOT NULL,
  `middle_name` varchar(300) DEFAULT NULL,
  `last_name` varchar(300) NOT NULL,
  `suffix` varchar(10) DEFAULT NULL,
  `nickname` varchar(100) DEFAULT NULL,
  `bio` varchar(1000) DEFAULT NULL,
  `civil_status_id` int(10) UNSIGNED DEFAULT NULL,
  `civil_status_name` varchar(100) DEFAULT NULL,
  `gender_id` int(10) UNSIGNED DEFAULT NULL,
  `gender_name` varchar(100) DEFAULT NULL,
  `religion_id` int(10) UNSIGNED DEFAULT NULL,
  `religion_name` varchar(100) DEFAULT NULL,
  `blood_type_id` int(10) UNSIGNED DEFAULT NULL,
  `blood_type_name` varchar(100) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `birth_place` varchar(1000) DEFAULT NULL,
  `height` float DEFAULT NULL,
  `weight` float DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `employment_type`
--

DROP TABLE IF EXISTS `employment_type`;
CREATE TABLE `employment_type` (
  `employment_type_id` int(10) UNSIGNED NOT NULL,
  `employment_type_name` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `employment_type`
--
DROP TRIGGER IF EXISTS `employment_type_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `employment_type_trigger_insert` AFTER INSERT ON `employment_type` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Employment type created. <br/>';

    IF NEW.employment_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Employment Type Name: ", NEW.employment_type_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('employment_type', NEW.employment_type_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `employment_type_trigger_update`;
DELIMITER $$
CREATE TRIGGER `employment_type_trigger_update` AFTER UPDATE ON `employment_type` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.employment_type_name <> OLD.employment_type_name THEN
        SET audit_log = CONCAT(audit_log, "Employment Type Name: ", OLD.employment_type_name, " -> ", NEW.employment_type_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('employment_type', NEW.employment_type_id, audit_log, NEW.last_log_by, NOW());
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
  `file_type_id` int(11) UNSIGNED NOT NULL,
  `file_type_name` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `file_extension`
--

INSERT INTO `file_extension` (`file_extension_id`, `file_extension_name`, `file_extension`, `file_type_id`, `file_type_name`, `created_date`, `last_log_by`) VALUES
(1, 'AIF', 'aif', 1, 'Audio', '2024-06-26 16:21:36', 1),
(2, 'CDA', 'cda', 1, 'Audio', '2024-06-26 16:21:36', 1),
(3, 'MID', 'mid', 1, 'Audio', '2024-06-26 16:21:36', 1),
(4, 'MIDI', 'midi', 1, 'Audio', '2024-06-26 16:21:36', 1),
(5, 'MP3', 'mp3', 1, 'Audio', '2024-06-26 16:21:36', 1),
(6, 'MPA', 'mpa', 1, 'Audio', '2024-06-26 16:21:36', 1),
(7, 'OGG', 'ogg', 1, 'Audio', '2024-06-26 16:21:36', 1),
(8, 'WAV', 'wav', 1, 'Audio', '2024-06-26 16:21:36', 1),
(9, 'WMA', 'wma', 1, 'Audio', '2024-06-26 16:21:36', 1),
(10, 'WPL', 'wpl', 1, 'Audio', '2024-06-26 16:21:36', 1),
(11, '7Z', '7z', 2, 'Compressed', '2024-06-26 16:21:36', 1),
(12, 'ARJ', 'arj', 2, 'Compressed', '2024-06-26 16:21:36', 1),
(13, 'DEB', 'deb', 2, 'Compressed', '2024-06-26 16:21:36', 1),
(14, 'PKG', 'pkg', 2, 'Compressed', '2024-06-26 16:21:36', 1),
(15, 'RAR', 'rar', 2, 'Compressed', '2024-06-26 16:21:36', 1),
(16, 'RPM', 'rpm', 2, 'Compressed', '2024-06-26 16:21:36', 1),
(17, 'TAR.GZ', 'tar.gz', 2, 'Compressed', '2024-06-26 16:21:36', 1),
(18, 'Z', 'z', 2, 'Compressed', '2024-06-26 16:21:36', 1),
(19, 'ZIP', 'zip', 2, 'Compressed', '2024-06-26 16:21:36', 1),
(20, 'BIN', 'bin', 3, 'Disk and Media', '2024-06-26 16:21:36', 1),
(21, 'DMG', 'dmg', 3, 'Disk and Media', '2024-06-26 16:21:36', 1),
(22, 'ISO', 'iso', 3, 'Disk and Media', '2024-06-26 16:21:36', 1),
(23, 'TOAST', 'toast', 3, 'Disk and Media', '2024-06-26 16:21:36', 1),
(24, 'VCD', 'vcd', 3, 'Disk and Media', '2024-06-26 16:21:36', 1),
(25, 'CSV', 'csv', 4, 'Data and Database', '2024-06-26 16:21:36', 1),
(26, 'DAT', 'dat', 4, 'Data and Database', '2024-06-26 16:21:36', 1),
(27, 'DB', 'db', 4, 'Data and Database', '2024-06-26 16:21:36', 1),
(28, 'DBF', 'dbf', 4, 'Data and Database', '2024-06-26 16:21:37', 1),
(29, 'LOG', 'log', 4, 'Data and Database', '2024-06-26 16:21:37', 1),
(30, 'MDB', 'mdb', 4, 'Data and Database', '2024-06-26 16:21:37', 1),
(31, 'SAV', 'sav', 4, 'Data and Database', '2024-06-26 16:21:37', 1),
(32, 'SQL', 'sql', 4, 'Data and Database', '2024-06-26 16:21:37', 1),
(33, 'TAR', 'tar', 4, 'Data and Database', '2024-06-26 16:21:37', 1),
(34, 'XML', 'xml', 4, 'Data and Database', '2024-06-26 16:21:37', 1),
(35, 'EMAIL', 'email', 5, 'Email', '2024-06-26 16:21:37', 1),
(36, 'EML', 'eml', 5, 'Email', '2024-06-26 16:21:37', 1),
(37, 'EMLX', 'emlx', 5, 'Email', '2024-06-26 16:21:37', 1),
(38, 'MSG', 'msg', 5, 'Email', '2024-06-26 16:21:37', 1),
(39, 'OFT', 'oft', 5, 'Email', '2024-06-26 16:21:37', 1),
(40, 'OST', 'ost', 5, 'Email', '2024-06-26 16:21:37', 1),
(41, 'PST', 'pst', 5, 'Email', '2024-06-26 16:21:37', 1),
(42, 'VCF', 'vcf', 5, 'Email', '2024-06-26 16:21:37', 1),
(43, 'APK', 'apk', 6, 'Executable', '2024-06-26 16:21:37', 1),
(44, 'BAT', 'bat', 6, 'Executable', '2024-06-26 16:21:37', 1),
(45, 'BIN', 'bin', 6, 'Executable', '2024-06-26 16:21:37', 1),
(46, 'CGI', 'cgi', 6, 'Executable', '2024-06-26 16:21:37', 1),
(47, 'PL', 'pl', 6, 'Executable', '2024-06-26 16:21:37', 1),
(48, 'COM', 'com', 6, 'Executable', '2024-06-26 16:21:37', 1),
(49, 'EXE', 'exe', 6, 'Executable', '2024-06-26 16:21:37', 1),
(50, 'GADGET', 'gadget', 6, 'Executable', '2024-06-26 16:21:37', 1),
(51, 'JAR', 'jar', 6, 'Executable', '2024-06-26 16:21:37', 1),
(52, 'WSF', 'wsf', 6, 'Executable', '2024-06-26 16:21:37', 1),
(53, 'FNT', 'fnt', 7, 'Font', '2024-06-26 16:21:37', 1),
(54, 'FON', 'fon', 7, 'Font', '2024-06-26 16:21:37', 1),
(55, 'OTF', 'otf', 7, 'Font', '2024-06-26 16:21:37', 1),
(56, 'TTF', 'ttf', 7, 'Font', '2024-06-26 16:21:37', 1),
(57, 'AI', 'ai', 8, 'Image', '2024-06-26 16:21:37', 1),
(58, 'BMP', 'bmp', 8, 'Image', '2024-06-26 16:21:37', 1),
(59, 'GIF', 'gif', 8, 'Image', '2024-06-26 16:21:37', 1),
(60, 'ICO', 'ico', 8, 'Image', '2024-06-26 16:21:37', 1),
(61, 'JPG', 'jpg', 8, 'Image', '2024-06-26 16:21:37', 1),
(62, 'JPEG', 'jpeg', 8, 'Image', '2024-06-26 16:21:37', 1),
(63, 'PNG', 'png', 8, 'Image', '2024-06-26 16:21:37', 1),
(64, 'PS', 'ps', 8, 'Image', '2024-06-26 16:21:37', 1),
(65, 'PSD', 'psd', 8, 'Image', '2024-06-26 16:21:37', 1),
(66, 'SVG', 'svg', 8, 'Image', '2024-06-26 16:21:37', 1),
(67, 'TIF', 'tif', 8, 'Image', '2024-06-26 16:21:37', 1),
(68, 'TIFF', 'tiff', 8, 'Image', '2024-06-26 16:21:37', 1),
(69, 'WEBP', 'webp', 8, 'Image', '2024-06-26 16:21:37', 1),
(70, 'ASP', 'asp', 9, 'Internet Related', '2024-06-26 16:21:37', 1),
(71, 'ASPX', 'aspx', 9, 'Internet Related', '2024-06-26 16:21:37', 1),
(72, 'CER', 'cer', 9, 'Internet Related', '2024-06-26 16:21:37', 1),
(73, 'CFM', 'cfm', 9, 'Internet Related', '2024-06-26 16:21:37', 1),
(74, 'CGI', 'cgi', 9, 'Internet Related', '2024-06-26 16:21:37', 1),
(75, 'PL', 'pl', 9, 'Internet Related', '2024-06-26 16:21:37', 1),
(76, 'CSS', 'css', 9, 'Internet Related', '2024-06-26 16:21:37', 1),
(77, 'HTM', 'htm', 9, 'Internet Related', '2024-06-26 16:21:37', 1),
(78, 'HTML', 'html', 9, 'Internet Related', '2024-06-26 16:21:37', 1),
(79, 'JS', 'js', 9, 'Internet Related', '2024-06-26 16:21:37', 1),
(80, 'JSP', 'jsp', 9, 'Internet Related', '2024-06-26 16:21:37', 1),
(81, 'PART', 'part', 9, 'Internet Related', '2024-06-26 16:21:37', 1),
(82, 'PHP', 'php', 9, 'Internet Related', '2024-06-26 16:21:37', 1),
(83, 'PY', 'py', 9, 'Internet Related', '2024-06-26 16:21:37', 1),
(84, 'RSS', 'rss', 9, 'Internet Related', '2024-06-26 16:21:37', 1),
(85, 'XHTML', 'xhtml', 9, 'Internet Related', '2024-06-26 16:21:37', 1),
(86, 'KEY', 'key', 10, 'Presentation', '2024-06-26 16:21:37', 1),
(87, 'ODP', 'odp', 10, 'Presentation', '2024-06-26 16:21:37', 1),
(88, 'PPS', 'pps', 10, 'Presentation', '2024-06-26 16:21:37', 1),
(89, 'PPT', 'ppt', 10, 'Presentation', '2024-06-26 16:21:37', 1),
(90, 'PPTX', 'pptx', 10, 'Presentation', '2024-06-26 16:21:37', 1),
(91, 'ODS', 'ods', 11, 'Spreadsheet', '2024-06-26 16:21:37', 1),
(92, 'XLS', 'xls', 11, 'Spreadsheet', '2024-06-26 16:21:37', 1),
(93, 'XLSM', 'xlsm', 11, 'Spreadsheet', '2024-06-26 16:21:37', 1),
(94, 'XLSX', 'xlsx', 11, 'Spreadsheet', '2024-06-26 16:21:37', 1),
(95, 'BAK', 'bak', 12, 'System Related', '2024-06-26 16:21:37', 1),
(96, 'CAB', 'cab', 12, 'System Related', '2024-06-26 16:21:37', 1),
(97, 'CFG', 'cfg', 12, 'System Related', '2024-06-26 16:21:37', 1),
(98, 'CPL', 'cpl', 12, 'System Related', '2024-06-26 16:21:37', 1),
(99, 'CUR', 'cur', 12, 'System Related', '2024-06-26 16:21:37', 1),
(100, 'DLL', 'dll', 12, 'System Related', '2024-06-26 16:21:37', 1),
(101, 'DMP', 'dmp', 12, 'System Related', '2024-06-26 16:21:37', 1),
(102, 'DRV', 'drv', 12, 'System Related', '2024-06-26 16:21:37', 1),
(103, 'ICNS', 'icns', 12, 'System Related', '2024-06-26 16:21:37', 1),
(104, 'INI', 'ini', 12, 'System Related', '2024-06-26 16:21:37', 1),
(105, 'LNK', 'lnk', 12, 'System Related', '2024-06-26 16:21:37', 1),
(106, 'MSI', 'msi', 12, 'System Related', '2024-06-26 16:21:37', 1),
(107, 'SYS', 'sys', 12, 'System Related', '2024-06-26 16:21:37', 1),
(108, 'TMP', 'tmp', 12, 'System Related', '2024-06-26 16:21:37', 1),
(109, '3G2', '3g2', 13, 'Video', '2024-06-26 16:21:37', 1),
(110, '3GP', '3gp', 13, 'Video', '2024-06-26 16:21:37', 1),
(111, 'AVI', 'avi', 13, 'Video', '2024-06-26 16:21:37', 1),
(112, 'FLV', 'flv', 13, 'Video', '2024-06-26 16:21:37', 1),
(113, 'H264', 'h264', 13, 'Video', '2024-06-26 16:21:37', 1),
(114, 'M4V', 'm4v', 13, 'Video', '2024-06-26 16:21:37', 1),
(115, 'MKV', 'mkv', 13, 'Video', '2024-06-26 16:21:37', 1),
(116, 'MOV', 'mov', 13, 'Video', '2024-06-26 16:21:37', 1),
(117, 'MP4', 'mp4', 13, 'Video', '2024-06-26 16:21:37', 1),
(118, 'MPG', 'mpg', 13, 'Video', '2024-06-26 16:21:37', 1),
(119, 'MPEG', 'mpeg', 13, 'Video', '2024-06-26 16:21:37', 1),
(120, 'RM', 'rm', 13, 'Video', '2024-06-26 16:21:37', 1),
(121, 'SWF', 'swf', 13, 'Video', '2024-06-26 16:21:37', 1),
(122, 'VOB', 'vob', 13, 'Video', '2024-06-26 16:21:37', 1),
(123, 'WEBM', 'webm', 13, 'Video', '2024-06-26 16:21:37', 1),
(124, 'WMV', 'wmv', 13, 'Video', '2024-06-26 16:21:37', 1),
(125, 'DOC', 'doc', 14, 'Word Processor', '2024-06-26 16:21:37', 1),
(126, 'DOCX', 'docx', 14, 'Word Processor', '2024-06-26 16:21:37', 1),
(127, 'PDF', 'pdf', 14, 'Word Processor', '2024-06-26 16:21:37', 1),
(128, 'RTF', 'rtf', 14, 'Word Processor', '2024-06-26 16:21:37', 1),
(129, 'TEX', 'tex', 14, 'Word Processor', '2024-06-26 16:21:37', 1),
(130, 'TXT', 'txt', 14, 'Word Processor', '2024-06-26 16:21:37', 1),
(131, 'WPD', 'wpd', 14, 'Word Processor', '2024-06-26 16:21:37', 1);

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
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `file_type`
--

INSERT INTO `file_type` (`file_type_id`, `file_type_name`, `created_date`, `last_log_by`) VALUES
(1, 'Audio', '2024-06-26 16:17:47', 1),
(2, 'Compressed', '2024-06-26 16:17:47', 1),
(3, 'Disk and Media', '2024-06-26 16:17:47', 1),
(4, 'Data and Database', '2024-06-26 16:17:47', 1),
(5, 'Email', '2024-06-26 16:17:47', 1),
(6, 'Executable', '2024-06-26 16:17:47', 1),
(7, 'Font', '2024-06-26 16:17:47', 1),
(8, 'Image', '2024-06-26 16:17:47', 1),
(9, 'Internet Related', '2024-06-26 16:17:47', 1),
(10, 'Presentation', '2024-06-26 16:17:47', 1),
(11, 'Spreadsheet', '2024-06-26 16:17:47', 1),
(12, 'System Related', '2024-06-26 16:17:47', 1),
(13, 'Video', '2024-06-26 16:17:47', 1),
(14, 'Word Processor', '2024-06-26 16:17:47', 1);

-- --------------------------------------------------------

--
-- Table structure for table `gender`
--

DROP TABLE IF EXISTS `gender`;
CREATE TABLE `gender` (
  `gender_id` int(10) UNSIGNED NOT NULL,
  `gender_name` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `gender`
--

INSERT INTO `gender` (`gender_id`, `gender_name`, `created_date`, `last_log_by`) VALUES
(1, 'Male', '2024-07-03 10:52:37', 2),
(2, 'Female', '2024-07-03 10:52:42', 2);

--
-- Triggers `gender`
--
DROP TRIGGER IF EXISTS `gender_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `gender_trigger_insert` AFTER INSERT ON `gender` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Gender created. <br/>';

    IF NEW.gender_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Gender Name: ", NEW.gender_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('gender', NEW.gender_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `gender_trigger_update`;
DELIMITER $$
CREATE TRIGGER `gender_trigger_update` AFTER UPDATE ON `gender` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.gender_name <> OLD.gender_name THEN
        SET audit_log = CONCAT(audit_log, "Gender Name: ", OLD.gender_name, " -> ", NEW.gender_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('gender', NEW.gender_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `id_type`
--

DROP TABLE IF EXISTS `id_type`;
CREATE TABLE `id_type` (
  `id_type_id` int(10) UNSIGNED NOT NULL,
  `id_type_name` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `id_type`
--

INSERT INTO `id_type` (`id_type_id`, `id_type_name`, `created_date`, `last_log_by`) VALUES
(1, 'Barangay ID', '2024-07-03 10:38:07', 2),
(2, 'Company ID', '2024-07-03 10:38:14', 2),
(3, 'Driver\'s License', '2024-07-03 10:38:18', 2),
(4, 'Government Service Insurance System (GSIS) ID', '2024-07-03 10:38:23', 2),
(5, 'Home Development Mutual Fund (Pag-IBIG) ID', '2024-07-03 10:38:27', 2),
(6, 'National Bureau of Investigation (NBI) Clearance', '2024-07-03 10:38:32', 2),
(7, 'National ID', '2024-07-03 10:38:35', 2),
(8, 'PhilHealth ID', '2024-07-03 10:38:39', 2),
(9, 'Philippine Passport', '2024-07-03 10:39:42', 2),
(10, 'Police Clearance', '2024-07-03 10:39:46', 2),
(11, 'Postal ID', '2024-07-03 10:39:52', 2),
(12, 'Professional Regulation Commission (PRC) ID', '2024-07-03 10:39:59', 2),
(13, 'Senior Citizen ID', '2024-07-03 10:40:05', 2),
(14, 'Social Security System (SSS) ID', '2024-07-03 10:40:10', 2),
(15, 'Student ID', '2024-07-03 10:40:16', 2),
(16, 'Taxpayer Identification Number (TIN) ID', '2024-07-03 10:40:21', 2),
(17, 'Unified Multi-Purpose ID (UMID)', '2024-07-03 10:40:31', 2),
(18, 'Voter\'s ID', '2024-07-03 10:40:37', 2);

--
-- Triggers `id_type`
--
DROP TRIGGER IF EXISTS `id_type_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `id_type_trigger_insert` AFTER INSERT ON `id_type` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'ID type created. <br/>';

    IF NEW.id_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>ID Type Name: ", NEW.id_type_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('id_type', NEW.id_type_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `id_type_trigger_update`;
DELIMITER $$
CREATE TRIGGER `id_type_trigger_update` AFTER UPDATE ON `id_type` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.id_type_name <> OLD.id_type_name THEN
        SET audit_log = CONCAT(audit_log, "ID Type Name: ", OLD.id_type_name, " -> ", NEW.id_type_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('id_type', NEW.id_type_id, audit_log, NEW.last_log_by, NOW());
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
  `internal_note_date` datetime NOT NULL DEFAULT current_timestamp(),
  `created_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

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
  `attachment_path_file` varchar(500) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `job_position`
--

DROP TABLE IF EXISTS `job_position`;
CREATE TABLE `job_position` (
  `job_position_id` int(10) UNSIGNED NOT NULL,
  `job_position_name` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `job_position`
--
DROP TRIGGER IF EXISTS `job_position_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `job_position_trigger_insert` AFTER INSERT ON `job_position` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Job position created. <br/>';

    IF NEW.job_position_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Job Position Name: ", NEW.job_position_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('job_position', NEW.job_position_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `job_position_trigger_update`;
DELIMITER $$
CREATE TRIGGER `job_position_trigger_update` AFTER UPDATE ON `job_position` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.job_position_name <> OLD.job_position_name THEN
        SET audit_log = CONCAT(audit_log, "Job Position Name: ", OLD.job_position_name, " -> ", NEW.job_position_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('job_position', NEW.job_position_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `language`
--

DROP TABLE IF EXISTS `language`;
CREATE TABLE `language` (
  `language_id` int(10) UNSIGNED NOT NULL,
  `language_name` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `language`
--

INSERT INTO `language` (`language_id`, `language_name`, `created_date`, `last_log_by`) VALUES
(1, 'Afrikaans', '2024-07-03 11:02:53', 1),
(2, 'Amharic', '2024-07-03 11:02:53', 1),
(3, 'Arabic', '2024-07-03 11:02:53', 1),
(4, 'Assamese', '2024-07-03 11:02:53', 1),
(5, 'Azerbaijani', '2024-07-03 11:02:53', 1),
(6, 'Belarusian', '2024-07-03 11:02:53', 1),
(7, 'Bulgarian', '2024-07-03 11:02:53', 1),
(8, 'Bhojpuri', '2024-07-03 11:02:53', 1),
(9, 'Bengali', '2024-07-03 11:02:53', 1),
(10, 'Bosnian', '2024-07-03 11:02:53', 1),
(11, 'Catalan, Valencian', '2024-07-03 11:02:53', 1),
(12, 'Cebuano', '2024-07-03 11:02:53', 1),
(13, 'Czech', '2024-07-03 11:02:53', 1),
(14, 'Danish', '2024-07-03 11:02:53', 1),
(15, 'German', '2024-07-03 11:02:53', 1),
(16, 'English', '2024-07-03 11:02:53', 1),
(17, 'Ewe', '2024-07-03 11:02:53', 1),
(18, 'Greek, Modern', '2024-07-03 11:02:53', 1),
(19, 'Spanish', '2024-07-03 11:02:53', 1),
(20, 'Estonian', '2024-07-03 11:02:53', 1),
(21, 'Basque', '2024-07-03 11:02:53', 1),
(22, 'Persian', '2024-07-03 11:02:53', 1),
(23, 'Fula', '2024-07-03 11:02:53', 1),
(24, 'Finnish', '2024-07-03 11:02:53', 1),
(25, 'French', '2024-07-03 11:02:53', 1),
(26, 'Irish', '2024-07-03 11:02:53', 1),
(27, 'Galician', '2024-07-03 11:02:53', 1),
(28, 'Guarani', '2024-07-03 11:02:53', 1),
(29, 'Gujarati', '2024-07-03 11:02:53', 1),
(30, 'Hausa', '2024-07-03 11:02:53', 1),
(31, 'Haitian Creole', '2024-07-03 11:02:53', 1),
(32, 'Hebrew (modern)', '2024-07-03 11:02:53', 1),
(33, 'Hindi', '2024-07-03 11:02:53', 1),
(34, 'Chhattisgarhi', '2024-07-03 11:02:53', 1),
(35, 'Croatian', '2024-07-03 11:02:53', 1),
(36, 'Hungarian', '2024-07-03 11:02:53', 1),
(37, 'Armenian', '2024-07-03 11:02:53', 1),
(38, 'Indonesian', '2024-07-03 11:02:53', 1),
(39, 'Igbo', '2024-07-03 11:02:53', 1),
(40, 'Icelandic', '2024-07-03 11:02:53', 1),
(41, 'Italian', '2024-07-03 11:02:53', 1),
(42, 'Japanese', '2024-07-03 11:02:53', 1),
(43, 'Syro-Palestinian Sign Language', '2024-07-03 11:02:53', 1),
(44, 'Javanese', '2024-07-03 11:02:53', 1),
(45, 'Georgian', '2024-07-03 11:02:53', 1),
(46, 'Kikuyu', '2024-07-03 11:02:53', 1),
(47, 'Kyrgyz', '2024-07-03 11:02:53', 1),
(48, 'Kuanyama', '2024-07-03 11:02:53', 1),
(49, 'Kazakh', '2024-07-03 11:02:53', 1),
(50, 'Khmer', '2024-07-03 11:02:53', 1),
(51, 'Kannada', '2024-07-03 11:02:53', 1),
(52, 'Korean', '2024-07-03 11:02:53', 1),
(53, 'Krio', '2024-07-03 11:02:53', 1),
(54, 'Kashmiri', '2024-07-03 11:02:53', 1),
(55, 'Kurdish', '2024-07-03 11:02:53', 1),
(56, 'Latin', '2024-07-03 11:02:53', 1),
(57, 'Lithuanian', '2024-07-03 11:02:53', 1),
(58, 'Luxembourgish', '2024-07-03 11:02:53', 1),
(59, 'Latvian', '2024-07-03 11:02:53', 1),
(60, 'Magahi', '2024-07-03 11:02:53', 1),
(61, 'Maithili', '2024-07-03 11:02:53', 1),
(62, 'Malagasy', '2024-07-03 11:02:53', 1),
(63, 'Macedonian', '2024-07-03 11:02:53', 1),
(64, 'Malayalam', '2024-07-03 11:02:53', 1),
(65, 'Mongolian', '2024-07-03 11:02:53', 1),
(66, 'Marathi (Marāṭhī)', '2024-07-03 11:02:53', 1),
(67, 'Malay', '2024-07-03 11:02:53', 1),
(68, 'Maltese', '2024-07-03 11:02:53', 1),
(69, 'Burmese', '2024-07-03 11:02:53', 1),
(70, 'Nepali', '2024-07-03 11:02:53', 1),
(71, 'Dutch', '2024-07-03 11:02:53', 1),
(72, 'Norwegian', '2024-07-03 11:02:53', 1),
(73, 'Oromo', '2024-07-03 11:02:53', 1),
(74, 'Odia', '2024-07-03 11:02:53', 1),
(75, 'Oromo', '2024-07-03 11:02:53', 1),
(76, 'Panjabi, Punjabi', '2024-07-03 11:02:53', 1),
(77, 'Polish', '2024-07-03 11:02:53', 1),
(78, 'Pashto', '2024-07-03 11:02:53', 1),
(79, 'Portuguese', '2024-07-03 11:02:53', 1),
(80, 'Rundi', '2024-07-03 11:02:53', 1),
(81, 'Romanian, Moldavian, Moldovan', '2024-07-03 11:02:53', 1),
(82, 'Russian', '2024-07-03 11:02:53', 1),
(83, 'Kinyarwanda', '2024-07-03 11:02:53', 1),
(84, 'Sindhi', '2024-07-03 11:02:53', 1),
(85, 'Argentine Sign Language', '2024-07-03 11:02:53', 1),
(86, 'Brazilian Sign Language', '2024-07-03 11:02:53', 1),
(87, 'Chinese Sign Language', '2024-07-03 11:02:53', 1),
(88, 'Colombian Sign Language', '2024-07-03 11:02:53', 1),
(89, 'German Sign Language', '2024-07-03 11:02:53', 1),
(90, 'Algerian Sign Language', '2024-07-03 11:02:53', 1),
(91, 'Ecuadorian Sign Language', '2024-07-03 11:02:53', 1),
(92, 'Spanish Sign Language', '2024-07-03 11:02:53', 1),
(93, 'Ethiopian Sign Language', '2024-07-03 11:02:53', 1),
(94, 'French Sign Language', '2024-07-03 11:02:53', 1),
(95, 'British Sign Language', '2024-07-03 11:02:53', 1),
(96, 'Ghanaian Sign Language', '2024-07-03 11:02:53', 1),
(97, 'Irish Sign Language', '2024-07-03 11:02:53', 1),
(98, 'Indopakistani Sign Language', '2024-07-03 11:02:53', 1),
(99, 'Persian Sign Language', '2024-07-03 11:02:53', 1),
(100, 'Italian Sign Language', '2024-07-03 11:02:53', 1),
(101, 'Japanese Sign Language', '2024-07-03 11:02:53', 1),
(102, 'Kenyan Sign Language', '2024-07-03 11:02:53', 1),
(103, 'Korean Sign Language', '2024-07-03 11:02:53', 1),
(104, 'Moroccan Sign Language', '2024-07-03 11:02:53', 1),
(105, 'Mexican Sign Language', '2024-07-03 11:02:53', 1),
(106, 'Malaysian Sign Language', '2024-07-03 11:02:53', 1),
(107, 'Philippine Sign Language', '2024-07-03 11:02:53', 1),
(108, 'Polish Sign Language', '2024-07-03 11:02:53', 1),
(109, 'Portuguese Sign Language', '2024-07-03 11:02:53', 1),
(110, 'Russian Sign Language', '2024-07-03 11:02:53', 1),
(111, 'Saudi Arabian Sign Language', '2024-07-03 11:02:53', 1),
(112, 'El Salvadoran Sign Language', '2024-07-03 11:02:53', 1),
(113, 'Turkish Sign Language', '2024-07-03 11:02:53', 1),
(114, 'Tanzanian Sign Language', '2024-07-03 11:02:53', 1),
(115, 'Ukrainian Sign Language', '2024-07-03 11:02:53', 1),
(116, 'American Sign Language', '2024-07-03 11:02:53', 1),
(117, 'South African Sign Language', '2024-07-03 11:02:53', 1),
(118, 'Zimbabwe Sign Language', '2024-07-03 11:02:53', 1),
(119, 'Sinhala, Sinhalese', '2024-07-03 11:02:53', 1),
(120, 'Slovak', '2024-07-03 11:02:53', 1),
(121, 'Saraiki', '2024-07-03 11:02:53', 1),
(122, 'Slovene', '2024-07-03 11:02:53', 1),
(123, 'Shona', '2024-07-03 11:02:53', 1),
(124, 'Somali', '2024-07-03 11:02:53', 1),
(125, 'Albanian', '2024-07-03 11:02:53', 1),
(126, 'Serbian', '2024-07-03 11:02:53', 1),
(127, 'Swati', '2024-07-03 11:02:53', 1),
(128, 'Sunda', '2024-07-03 11:02:53', 1),
(129, 'Swedish', '2024-07-03 11:02:53', 1),
(130, 'Swahili', '2024-07-03 11:02:53', 1),
(131, 'Sylheti', '2024-07-03 11:02:53', 1),
(132, 'Tagalog', '2024-07-03 11:02:53', 1),
(133, 'Tamil', '2024-07-03 11:02:53', 1),
(134, 'Telugu', '2024-07-03 11:02:53', 1),
(135, 'Thai', '2024-07-03 11:02:53', 1),
(136, 'Tibetan', '2024-07-03 11:02:53', 1),
(137, 'Tigrinya', '2024-07-03 11:02:53', 1),
(138, 'Turkmen', '2024-07-03 11:02:53', 1),
(139, 'Tswana', '2024-07-03 11:02:53', 1),
(140, 'Turkish', '2024-07-03 11:02:53', 1),
(141, 'Uyghur', '2024-07-03 11:02:53', 1),
(142, 'Ukrainian', '2024-07-03 11:02:53', 1),
(143, 'Urdu', '2024-07-03 11:02:53', 1),
(144, 'Uzbek', '2024-07-03 11:02:53', 1),
(145, 'Vietnamese', '2024-07-03 11:02:53', 1),
(146, 'Xhosa', '2024-07-03 11:02:53', 1),
(147, 'Yiddish', '2024-07-03 11:02:53', 1),
(148, 'Yoruba', '2024-07-03 11:02:53', 1),
(149, 'Cantonese', '2024-07-03 11:02:53', 1),
(150, 'Chinese', '2024-07-03 11:02:53', 1),
(151, 'Zulu', '2024-07-03 11:02:53', 1);

--
-- Triggers `language`
--
DROP TRIGGER IF EXISTS `language_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `language_trigger_insert` AFTER INSERT ON `language` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Language created. <br/>';

    IF NEW.language_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Language Name: ", NEW.language_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('language', NEW.language_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `language_trigger_update`;
DELIMITER $$
CREATE TRIGGER `language_trigger_update` AFTER UPDATE ON `language` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.language_name <> OLD.language_name THEN
        SET audit_log = CONCAT(audit_log, "Language Name: ", OLD.language_name, " -> ", NEW.language_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('language', NEW.language_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `language_proficiency`
--

DROP TABLE IF EXISTS `language_proficiency`;
CREATE TABLE `language_proficiency` (
  `language_proficiency_id` int(10) UNSIGNED NOT NULL,
  `language_proficiency_name` varchar(100) NOT NULL,
  `language_proficiency_description` varchar(200) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `language_proficiency`
--

INSERT INTO `language_proficiency` (`language_proficiency_id`, `language_proficiency_name`, `language_proficiency_description`, `created_date`, `last_log_by`) VALUES
(1, 'Basic', 'Only able to communicate in this language through written communication.', '2024-07-03 13:20:14', 2),
(2, 'Advanced', 'Proficient in this language, can handle complex discussions and tasks.', '2024-07-03 13:20:23', 2),
(3, 'Conversational', 'Know this language well enough to verbally discuss basic topics.', '2024-07-03 13:20:30', 2),
(4, 'Fluent', 'Mastery level, can speak and understand this language at a native level.', '2024-07-03 13:20:38', 2),
(5, 'Intermediate', 'Can comfortably converse in this language on a variety of topics.', '2024-07-03 13:20:49', 2);

--
-- Triggers `language_proficiency`
--
DROP TRIGGER IF EXISTS `language_proficiency_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `language_proficiency_trigger_insert` AFTER INSERT ON `language_proficiency` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Language proficiency created. <br/>';

    IF NEW.language_proficiency_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Language Proficiency Name: ", NEW.language_proficiency_name);
    END IF;

    IF NEW.language_proficiency_description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Language Proficiency Description: ", NEW.language_proficiency_description);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('language_proficiency', NEW.language_proficiency_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `language_proficiency_trigger_update`;
DELIMITER $$
CREATE TRIGGER `language_proficiency_trigger_update` AFTER UPDATE ON `language_proficiency` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.language_proficiency_name <> OLD.language_proficiency_name THEN
        SET audit_log = CONCAT(audit_log, "Language Proficiency Name: ", OLD.language_proficiency_name, " -> ", NEW.language_proficiency_name, "<br/>");
    END IF;

    IF NEW.language_proficiency_description <> OLD.language_proficiency_description THEN
        SET audit_log = CONCAT(audit_log, "Language Proficiency Description: ", OLD.language_proficiency_description, " -> ", NEW.language_proficiency_description, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('language_proficiency', NEW.language_proficiency_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

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
(1, 'Technical', 1, 'Settings', 100, '2024-06-26 14:28:45', 2),
(2, 'Administration', 1, 'Settings', 5, '2024-06-26 14:28:45', 2),
(3, 'Configurations', 1, 'Settings', 50, '2024-06-26 14:28:45', 2),
(4, 'Profile', 1, 'Settings', 1, '2024-06-27 14:49:24', 2),
(5, 'Employees', 2, 'Employees', 1, '2024-06-27 15:29:15', 2),
(6, 'Employee Configurations', 2, 'Employees', 23, '2024-06-27 17:17:10', 2);

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
(1, 'App Module', 'app-module.php', 'ti ti-box', 1, 'Technical', 1, 'Settings', 0, '', 1, '2024-06-26 15:17:26', 2),
(2, 'General Settings', 'general-settings.php', 'ti ti-settings', 1, 'Technical', 1, 'Settings', 0, '', 7, '2024-06-26 15:17:26', 2),
(3, 'Users & Companies', '', 'ti ti-users', 2, 'Administration', 1, 'Settings', 0, '', 21, '2024-06-26 15:17:26', 2),
(4, 'User Account', 'user-account.php', '', 2, 'Administration', 1, 'Settings', 3, 'Users & Companies', 21, '2024-06-26 15:17:26', 2),
(5, 'Company', 'company.php', '', 2, 'Administration', 1, 'Settings', 3, 'Users & Companies', 3, '2024-06-26 15:17:26', 2),
(6, 'Role', 'role.php', 'ti ti-sitemap', 2, 'Administration', 1, 'Settings', NULL, NULL, 3, '2024-06-26 15:17:26', 2),
(7, 'User Interface', '', 'ti ti-layout-sidebar', 1, 'Technical', 1, 'Settings', NULL, NULL, 16, '2024-06-26 15:17:26', 2),
(8, 'Menu Group', 'menu-group.php', '', 1, 'Technical', 1, 'Settings', 7, 'User Interface', 1, '2024-06-26 15:17:26', 2),
(9, 'Menu Item', 'menu-item.php', '', 1, 'Technical', 1, 'Settings', 7, 'User Interface', 2, '2024-06-26 15:17:26', 2),
(10, 'System Action', 'system-action.php', '', 1, 'Technical', 1, 'Settings', 7, 'User Interface', 2, '2024-06-26 15:17:26', 2),
(11, 'Localization', '', 'ti ti-map-pin', 1, 'Technical', 1, 'Settings', 0, '', 12, '2024-06-26 15:17:26', 2),
(12, 'City', 'city.php', '', 1, 'Technical', 1, 'Settings', 11, 'Localization', 12, '2024-06-26 15:17:26', 2),
(13, 'Country', 'country.php', '', 1, 'Technical', 1, 'Settings', 11, 'Localization', 13, '2024-06-26 15:17:26', 2),
(14, 'State', 'state.php', '', 1, 'Technical', 1, 'Settings', 11, 'Localization', 19, '2024-06-26 15:17:26', 2),
(15, 'Currency', 'currency.php', '', 1, 'Technical', 1, 'Settings', 11, 'Localization', 14, '2024-06-26 15:17:26', 2),
(16, 'File Configuration', '', 'ti ti-file-symlink', 1, 'Technical', 1, 'Settings', 0, '', 6, '2024-06-26 15:17:26', 2),
(17, 'Upload Setting', 'upload-setting.php', '', 1, 'Technical', 1, 'Settings', 16, 'File Configuration', 21, '2024-06-26 15:17:26', 2),
(18, 'File Type', 'file-type.php', '', 1, 'Technical', 1, 'Settings', 16, 'File Configuration', 6, '2024-06-26 15:17:26', 2),
(19, 'File Extension', 'file-extension.php', '', 1, 'Technical', 1, 'Settings', 16, 'File Configuration', 7, '2024-06-26 15:17:26', 2),
(20, 'Email Setting', 'email-setting.php', 'ti ti-mail-forward', 1, 'Technical', 1, 'Settings', 0, '', 5, '2024-06-26 15:17:26', 2),
(21, 'Notification Setting', 'notification-setting.php', 'ti ti-bell', 1, 'Technical', 1, 'Settings', 0, '', 14, '2024-06-26 15:17:26', 2),
(22, 'Account Setting', 'account-setting.php', 'ti ti-tool', 4, 'Profile', 1, 'Settings', 0, NULL, 1, '2024-06-27 14:52:08', 2),
(23, 'Employee', 'employee.php', 'ti ti-users', 5, 'Employees', 2, 'Employees', NULL, NULL, 1, '2024-06-27 15:30:10', 2),
(24, 'Department', 'department.php', 'ti ti-hierarchy-2', 6, 'Employee Configurations', 2, 'Employees', NULL, NULL, 4, '2024-06-27 17:18:42', 2),
(25, 'Work Location', 'work-location.php', 'ti ti-map-pin', 6, 'Employee Configurations', 2, 'Employees', 0, NULL, 23, '2024-06-28 10:38:12', 2),
(26, 'Work Schedule', 'work-schedule.php', '', 6, 'Employee Configurations', 2, 'Employees', 31, 'Scheduling', 1, '2024-06-28 10:43:21', 2),
(27, 'Employment Type', 'employment-type.php', 'ti ti-briefcase', 6, 'Employee Configurations', 2, 'Employees', NULL, NULL, 5, '2024-06-28 10:45:01', 2),
(28, 'Departure Reason', 'departure-reason.php', 'ti ti-user-minus', 6, 'Employee Configurations', 2, 'Employees', NULL, NULL, 5, '2024-06-28 10:46:48', 2),
(29, 'Job Position', 'job-position.php', 'ti ti-id', 6, 'Employee Configurations', 2, 'Employees', NULL, NULL, 10, '2024-06-28 10:56:17', 2),
(30, 'Schedule Type', 'schedule-type.php', '', 6, 'Employee Configurations', 2, 'Employees', 31, 'Scheduling', 2, '2024-07-01 14:52:27', 2),
(31, 'Scheduling', '', 'ti ti-calendar-time', 6, 'Employee Configurations', 2, 'Employees', 0, NULL, 24, '2024-07-01 14:59:44', 2),
(32, 'Contact Information Type', 'contact-information-type.php', 'ti ti-device-mobile', 3, 'Configurations', 1, 'Settings', 0, NULL, 3, '2024-07-02 17:02:55', 2),
(33, 'ID Type', 'id-type.php', 'ti ti-id', 3, 'Configurations', 1, 'Settings', 0, NULL, 9, '2024-07-02 17:05:17', 2),
(34, 'Bank', 'bank.php', 'ti ti-building-bank', 3, 'Configurations', 1, 'Settings', 0, NULL, 2, '2024-07-02 17:06:13', 2),
(35, 'Bank Account Type', 'bank-account-type.php', 'ti ti-building-community', 3, 'Configurations', 1, 'Settings', NULL, NULL, 2, '2024-07-02 17:07:16', 2),
(36, 'Relation', 'relation.php', 'ti ti-social', 3, 'Configurations', 1, 'Settings', NULL, NULL, 18, '2024-07-02 17:09:40', 2),
(37, 'Educational Stage', 'educational-stage.php', 'ti ti-school', 3, 'Configurations', 1, 'Settings', 0, NULL, 5, '2024-07-02 17:11:54', 2),
(38, 'Language', 'language.php', 'ti ti-language', 3, 'Configurations', 1, 'Settings', 0, NULL, 12, '2024-07-02 17:21:10', 2),
(39, 'Language Proficiency', 'language-proficiency.php', 'ti ti-messages', 3, 'Configurations', 1, 'Settings', 0, NULL, 12, '2024-07-02 17:23:14', 2),
(40, 'Civil Status', 'civil-status.php', 'ti ti-chart-circles', 3, 'Configurations', 1, 'Settings', 0, NULL, 3, '2024-07-02 17:26:17', 2),
(41, 'Gender', 'gender.php', 'ti ti-friends', 3, 'Configurations', 1, 'Settings', 0, NULL, 7, '2024-07-02 17:27:18', 2),
(42, 'Blood Type', 'blood-type.php', 'ti ti-droplet-filled', 3, 'Configurations', 1, 'Settings', 0, NULL, 2, '2024-07-02 17:28:23', 2),
(43, 'Religion', 'religion.php', 'ti ti-building-church', 3, 'Configurations', 1, 'Settings', 0, NULL, 18, '2024-07-02 17:29:10', 2),
(44, 'Address Type', 'address-type.php', 'ti ti-map-2', 3, 'Configurations', 1, 'Settings', 0, NULL, 1, '2024-07-02 17:30:03', 2);

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
(1, 'Login OTP', 'Notification setting for Login OTP received by the users.', 0, 1, 0, '2024-06-27 14:59:41', 2),
(2, 'Forgot Password', 'Notification setting when the user initiates forgot password.', 0, 1, 0, '2024-06-27 15:03:26', 2);

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
(1, 1, 'Login OTP - Secure Access to Your Account', '<p>To ensure the security of your account, we have generated a unique One-Time Password (OTP) for you to use during the login process. Please use the following OTP to access your account:</p>\n<p><br>OTP:&nbsp;<strong>{OTP_CODE}</strong></p>\n<p><br>Please note that this OTP is valid for &nbsp;<strong>#{OTP_CODE_VALIDITY}</strong>. Once you have logged in successfully, we recommend enabling two-factor authentication for an added layer of security.<br>If you did not initiate this login or believe it was sent to you in error, please disregard this email and delete it immediately. Your account\'s security remains our utmost priority.</p>\n<p>Note: This is an automatically generated email. Please do not reply to this address.</p>', '2024-06-27 15:02:58', 2),
(2, 2, 'Password Reset Request - Action Required', '<p>We received a request to reset your password. To proceed with the password reset, please follow the steps below:</p>\n<ol>\n<li>\n<p>Click on the following link to reset your password:&nbsp; <strong><a href=\"#{RESET_LINK}\">Password Reset Link</a></strong></p>\n</li>\n<li>\n<p>If you did not request this password reset, please ignore this email. Your account remains secure.</p>\n</li>\n</ol>\n<p>Please note that this link is time-sensitive and will expire after <strong>#{RESET_LINK_VALIDITY}</strong>. If you do not reset your password within this timeframe, you may need to request another password reset.</p>\n<p><br>If you did not initiate this password reset request or believe it was sent to you in error, please disregard this email and delete it immediately. Your account\'s security remains our utmost priority.<br><br>Note: This is an automatically generated email. Please do not reply to this address.</p>', '2024-06-27 15:13:04', 2);

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
  `password` varchar(255) NOT NULL,
  `password_change_date` datetime DEFAULT current_timestamp(),
  `created_date` datetime NOT NULL DEFAULT current_timestamp()
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `relation`
--

DROP TABLE IF EXISTS `relation`;
CREATE TABLE `relation` (
  `relation_id` int(10) UNSIGNED NOT NULL,
  `relation_name` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `relation`
--

INSERT INTO `relation` (`relation_id`, `relation_name`, `created_date`, `last_log_by`) VALUES
(1, 'Aunt', '2024-07-03 11:13:01', 2),
(2, 'Brother', '2024-07-03 11:13:06', 2),
(3, 'Cousin', '2024-07-03 11:13:11', 2),
(4, 'Daughter', '2024-07-03 11:13:14', 2),
(5, 'Father', '2024-07-03 11:13:18', 2),
(6, 'Friend', '2024-07-03 11:13:24', 2),
(7, 'Grandchild', '2024-07-03 11:13:29', 2),
(8, 'Grandparent', '2024-07-03 11:13:32', 2),
(9, 'Mother', '2024-07-03 11:13:36', 2),
(10, 'Partner', '2024-07-03 11:13:39', 2),
(11, 'Roommate', '2024-07-03 11:13:44', 2),
(12, 'Sister', '2024-07-03 11:13:50', 2),
(13, 'Son', '2024-07-03 11:13:54', 2),
(14, 'Spouse', '2024-07-03 11:13:58', 2),
(15, 'Uncle', '2024-07-03 11:14:02', 2);

--
-- Triggers `relation`
--
DROP TRIGGER IF EXISTS `relation_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `relation_trigger_insert` AFTER INSERT ON `relation` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Relation created. <br/>';

    IF NEW.relation_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Relation Name: ", NEW.relation_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('relation', NEW.relation_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `relation_trigger_update`;
DELIMITER $$
CREATE TRIGGER `relation_trigger_update` AFTER UPDATE ON `relation` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.relation_name <> OLD.relation_name THEN
        SET audit_log = CONCAT(audit_log, "Relation Name: ", OLD.relation_name, " -> ", NEW.relation_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('relation', NEW.relation_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `religion`
--

DROP TABLE IF EXISTS `religion`;
CREATE TABLE `religion` (
  `religion_id` int(10) UNSIGNED NOT NULL,
  `religion_name` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `religion`
--

INSERT INTO `religion` (`religion_id`, `religion_name`, `created_date`, `last_log_by`) VALUES
(1, 'Aglipayan Church', '2024-07-03 11:16:35', 2),
(2, 'Atheist', '2024-07-03 11:16:39', 2),
(3, 'Baptists', '2024-07-03 11:16:43', 2),
(4, 'Buddhism', '2024-07-03 11:16:49', 2),
(5, 'Hinduism', '2024-07-03 11:16:53', 2),
(6, 'Iglesia ni Cristo', '2024-07-03 11:16:57', 2),
(7, 'Indigenous Beliefs', '2024-07-03 11:17:00', 2),
(8, 'Islam', '2024-07-03 11:17:04', 2),
(9, 'Members Church of God International', '2024-07-03 11:17:08', 2),
(10, 'Methodists', '2024-07-03 11:17:12', 2),
(11, 'Pentecostals', '2024-07-03 11:17:17', 2),
(12, 'Roman Catholic', '2024-07-03 11:17:21', 2);

--
-- Triggers `religion`
--
DROP TRIGGER IF EXISTS `religion_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `religion_trigger_insert` AFTER INSERT ON `religion` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Religion created. <br/>';

    IF NEW.religion_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Religion Name: ", NEW.religion_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('religion', NEW.religion_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `religion_trigger_update`;
DELIMITER $$
CREATE TRIGGER `religion_trigger_update` AFTER UPDATE ON `religion` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.religion_name <> OLD.religion_name THEN
        SET audit_log = CONCAT(audit_log, "Religion Name: ", OLD.religion_name, " -> ", NEW.religion_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('religion', NEW.religion_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

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
(1, 'Administrator', 'Full access to all features and data within the system. This role have similar access levels to the Admin but is not as powerful as the Super Admin.', '2024-06-26 14:31:00', 1);

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
(2, 1, 'Administrator', 1, 'App Module', 1, 1, 1, 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26', 1),
(3, 1, 'Administrator', 2, 'General Settings', 1, 1, 1, 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26', 1),
(4, 1, 'Administrator', 3, 'Users & Companies', 1, 0, 0, 0, '2024-06-26 15:17:26', '2024-06-26 15:17:26', 1),
(5, 1, 'Administrator', 4, 'User Account', 1, 1, 1, 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26', 1),
(6, 1, 'Administrator', 5, 'Company', 1, 1, 1, 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26', 1),
(7, 1, 'Administrator', 6, 'Role', 1, 1, 1, 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26', 2),
(8, 1, 'Administrator', 7, 'User Interface', 1, 0, 0, 0, '2024-06-26 15:17:26', '2024-06-26 15:17:26', 2),
(9, 1, 'Administrator', 8, 'Menu Group', 1, 1, 1, 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26', 1),
(10, 1, 'Administrator', 9, 'Menu Item', 1, 1, 1, 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26', 1),
(11, 1, 'Administrator', 10, 'System Action', 1, 1, 1, 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26', 1),
(12, 1, 'Administrator', 11, 'Localization', 1, 0, 0, 0, '2024-06-26 15:17:26', '2024-06-26 15:17:26', 1),
(13, 1, 'Administrator', 12, 'City', 1, 1, 1, 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26', 1),
(14, 1, 'Administrator', 13, 'Country', 1, 1, 1, 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26', 1),
(15, 1, 'Administrator', 14, 'State', 1, 1, 1, 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26', 1),
(16, 1, 'Administrator', 15, 'Currency', 1, 1, 1, 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26', 1),
(17, 1, 'Administrator', 16, 'File Configuration', 1, 0, 0, 0, '2024-06-26 15:17:26', '2024-06-26 15:17:26', 1),
(18, 1, 'Administrator', 17, 'Upload Setting', 1, 1, 1, 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26', 1),
(19, 1, 'Administrator', 18, 'File Type', 1, 1, 1, 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26', 1),
(20, 1, 'Administrator', 19, 'File Extension', 1, 1, 1, 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26', 1),
(21, 1, 'Administrator', 20, 'Email Setting', 1, 1, 1, 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26', 1),
(22, 1, 'Administrator', 21, 'Notification Setting', 1, 1, 1, 1, '2024-06-26 15:17:26', '2024-06-26 15:17:26', 1),
(23, 1, 'Administrator', 22, 'Account Setting', 1, 1, 0, 0, '2024-06-27 14:52:13', '2024-06-27 14:52:13', 2),
(24, 1, 'Administrator', 23, 'Employee', 1, 1, 1, 1, '2024-06-27 15:31:42', '2024-06-27 15:31:42', 2),
(25, 1, 'Administrator', 24, 'Department', 1, 1, 1, 1, '2024-06-27 17:18:46', '2024-06-27 17:18:46', 2),
(26, 1, 'Administrator', 25, 'Work Location', 1, 1, 1, 1, '2024-06-28 10:38:17', '2024-06-28 10:38:17', 2),
(27, 1, 'Administrator', 26, 'Work Schedule', 1, 1, 1, 1, '2024-06-28 10:43:25', '2024-06-28 10:43:25', 2),
(28, 1, 'Administrator', 27, 'Employment Type', 1, 1, 1, 1, '2024-06-28 10:45:05', '2024-06-28 10:45:05', 2),
(29, 1, 'Administrator', 28, 'Departure Reason', 1, 1, 1, 1, '2024-06-28 10:50:01', '2024-06-28 10:50:01', 2),
(30, 1, 'Administrator', 29, 'Job Position', 1, 1, 1, 1, '2024-06-28 10:56:21', '2024-06-28 10:56:21', 2),
(31, 1, 'Administrator', 30, 'Schedule Type', 1, 1, 1, 1, '2024-07-01 14:52:33', '2024-07-01 14:52:33', 2),
(32, 1, 'Administrator', 31, 'Scheduling', 1, 0, 0, 0, '2024-07-01 14:59:48', '2024-07-01 14:59:48', 2),
(33, 1, 'Administrator', 32, 'Contact Information Type', 1, 1, 1, 1, '2024-07-02 17:02:59', '2024-07-02 17:02:59', 2),
(34, 1, 'Administrator', 33, 'ID Type', 1, 1, 1, 1, '2024-07-02 17:05:20', '2024-07-02 17:05:20', 2),
(35, 1, 'Administrator', 34, 'Bank', 1, 1, 1, 1, '2024-07-02 17:06:16', '2024-07-02 17:06:16', 2),
(36, 1, 'Administrator', 35, 'Bank Account Type', 1, 1, 1, 1, '2024-07-02 17:07:21', '2024-07-02 17:07:21', 2),
(37, 1, 'Administrator', 36, 'Relation', 1, 1, 1, 1, '2024-07-02 17:10:43', '2024-07-02 17:10:43', 2),
(38, 1, 'Administrator', 37, 'Educational Stage', 1, 1, 1, 1, '2024-07-02 17:11:57', '2024-07-02 17:11:57', 2),
(39, 1, 'Administrator', 38, 'Language', 1, 1, 1, 1, '2024-07-02 17:21:16', '2024-07-02 17:21:16', 2),
(40, 1, 'Administrator', 39, 'Language Proficiency', 1, 1, 1, 1, '2024-07-02 17:23:19', '2024-07-02 17:23:19', 2),
(41, 1, 'Administrator', 40, 'Civil Status', 1, 1, 1, 1, '2024-07-02 17:26:21', '2024-07-02 17:26:21', 2),
(42, 1, 'Administrator', 41, 'Gender', 1, 1, 1, 1, '2024-07-02 17:27:22', '2024-07-02 17:27:22', 2),
(43, 1, 'Administrator', 42, 'Blood Type', 1, 1, 1, 1, '2024-07-02 17:28:26', '2024-07-02 17:28:26', 2),
(44, 1, 'Administrator', 43, 'Religion', 1, 1, 1, 1, '2024-07-02 17:29:14', '2024-07-02 17:29:14', 2),
(45, 1, 'Administrator', 44, 'Address Type', 1, 1, 1, 1, '2024-07-02 17:30:07', '2024-07-02 17:30:07', 2);

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
(1, 1, 'Administrator', 1, 'Update System Settings', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29', 1),
(2, 1, 'Administrator', 2, 'Update Security Settings', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29', 1),
(3, 1, 'Administrator', 3, 'Activate User Account', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29', 1),
(4, 1, 'Administrator', 4, 'Deactivate User Account', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29', 1),
(5, 1, 'Administrator', 5, 'Lock User Account', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29', 1),
(6, 1, 'Administrator', 6, 'Unlock User Account', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29', 1),
(7, 1, 'Administrator', 7, 'Add Role User Account', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29', 1),
(8, 1, 'Administrator', 8, 'Delete Role User Account', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29', 1),
(9, 1, 'Administrator', 9, 'Add Role Access', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29', 1),
(10, 1, 'Administrator', 10, 'Update Role Access', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29', 1),
(11, 1, 'Administrator', 11, 'Delete Role Access', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29', 1),
(12, 1, 'Administrator', 12, 'Add Role System Action Access', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29', 1),
(13, 1, 'Administrator', 13, 'Update Role System Action Access', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29', 1),
(14, 1, 'Administrator', 14, 'Delete Role System Action Access', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29', 1),
(15, 1, 'Administrator', 15, 'Add File Extension Access', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29', 1),
(16, 1, 'Administrator', 16, 'Delete File Extension Access', 1, '2024-06-26 15:18:29', '2024-06-26 15:18:29', 1),
(17, 1, 'Administrator', 17, 'Add Work Hours', 1, '2024-07-02 10:23:41', '2024-07-02 10:23:41', 2),
(18, 1, 'Administrator', 18, 'Update Work Hours', 1, '2024-07-02 10:24:05', '2024-07-02 10:24:05', 2),
(19, 1, 'Administrator', 19, 'Delete Work Hours', 1, '2024-07-02 10:24:23', '2024-07-02 10:24:23', 2);

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
(1, 1, 'Administrator', 2, 'Administrator', '2024-06-26 15:18:35', '2024-06-26 15:18:35', 1);

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
-- Table structure for table `schedule_type`
--

DROP TABLE IF EXISTS `schedule_type`;
CREATE TABLE `schedule_type` (
  `schedule_type_id` int(10) UNSIGNED NOT NULL,
  `schedule_type_name` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `schedule_type`
--

INSERT INTO `schedule_type` (`schedule_type_id`, `schedule_type_name`, `created_date`, `last_log_by`) VALUES
(1, 'Fixed', '2024-07-01 15:48:39', 2),
(2, 'Flexible', '2024-07-02 09:49:09', 2),
(3, 'Shifting', '2024-07-02 09:49:26', 2);

--
-- Triggers `schedule_type`
--
DROP TRIGGER IF EXISTS `schedule_type_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `schedule_type_trigger_insert` AFTER INSERT ON `schedule_type` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Schedule type created. <br/>';

    IF NEW.schedule_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Schedule Type Name: ", NEW.schedule_type_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('schedule_type', NEW.schedule_type_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `schedule_type_trigger_update`;
DELIMITER $$
CREATE TRIGGER `schedule_type_trigger_update` AFTER UPDATE ON `schedule_type` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.schedule_type_name <> OLD.schedule_type_name THEN
        SET audit_log = CONCAT(audit_log, "Schedule Type Name: ", OLD.schedule_type_name, " -> ", NEW.schedule_type_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('schedule_type', NEW.schedule_type_id, audit_log, NEW.last_log_by, NOW());
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
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `state`
--

INSERT INTO `state` (`state_id`, `state_name`, `country_id`, `country_name`, `created_date`, `last_log_by`) VALUES
(1, 'Metro Manila', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(2, 'Ilocos Norte', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(3, 'Ilocos Sur', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(4, 'La Union', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(5, 'Pangasinan', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(6, 'Batanes', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(7, 'Cagayan', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(8, 'Isabela', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(9, 'Nueva Vizcaya', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(10, 'Quirino', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(11, 'Bataan', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(12, 'Bulacan', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(13, 'Nueva Ecija', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(14, 'Pampanga', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(15, 'Tarlac', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(16, 'Zambales', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(17, 'Aurora', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(18, 'Batangas', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(19, 'Cavite', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(20, 'Laguna', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(21, 'Quezon', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(22, 'Rizal', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(23, 'Marinduque', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(24, 'Occidental Mindoro', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(25, 'Oriental Mindoro', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(26, 'Palawan', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(27, 'Romblon', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(28, 'Albay', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(29, 'Camarines Norte', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(30, 'Camarines Sur', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(31, 'Catanduanes', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(32, 'Masbate', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(33, 'Sorsogon', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(34, 'Aklan', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(35, 'Antique', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(36, 'Capiz', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(37, 'Iloilo', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(38, 'Negros Occidental', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(39, 'Guimaras', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(40, 'Bohol', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(41, 'Cebu', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(42, 'Negros Oriental', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(43, 'Siquijor', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(44, 'Eastern Samar', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(45, 'Leyte', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(46, 'Northern Samar', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(47, 'Samar', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(48, 'Southern Leyte', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(49, 'Biliran', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(50, 'Zamboanga del Norte', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(51, 'Zamboanga del Sur', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(52, 'Zamboanga Sibugay', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(53, 'Bukidnon', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(54, 'Camiguin', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(55, 'Lanao del Norte', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(56, 'Misamis Occidental', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(57, 'Misamis Oriental', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(58, 'Davao del Norte', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(59, 'Davao del Sur', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(60, 'Davao Oriental', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(61, 'Davao de Oro', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(62, 'Davao Occidental', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(63, 'Cotabato', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(64, 'South Cotabato', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(65, 'Sultan Kudarat', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(66, 'Sarangani', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(67, 'Abra', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(68, 'Benguet', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(69, 'Ifugao', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(70, 'Kalinga', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(71, 'Mountain Province', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(72, 'Apayao', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(73, 'Basilan', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(74, 'Lanao del Sur', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(75, 'Maguindanao', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(76, 'Sulu', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(77, 'Tawi-Tawi', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(78, 'Agusan del Norte', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(79, 'Agusan del Sur', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(80, 'Surigao del Norte', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(81, 'Surigao del Sur', 174, 'Philippines', '2024-06-26 15:40:48', 1),
(82, 'Dinagat Islands', 174, 'Philippines', '2024-06-26 15:40:48', 1);

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
(1, 'Update System Settings', 'Access to update the system settings.', '2024-06-26 15:18:24', 1),
(2, 'Update Security Settings', 'Access to update the security settings.', '2024-06-26 15:18:24', 1),
(3, 'Activate User Account', 'Access to activate the user account.', '2024-06-26 15:18:24', 1),
(4, 'Deactivate User Account', 'Access to deactivate the user account.', '2024-06-26 15:18:24', 1),
(5, 'Lock User Account', 'Access to lock the user account.', '2024-06-26 15:18:24', 1),
(6, 'Unlock User Account', 'Access to unlock the user account.', '2024-06-26 15:18:24', 1),
(7, 'Add Role User Account', 'Access to assign roles to user account.', '2024-06-26 15:18:24', 1),
(8, 'Delete Role User Account', 'Access to delete roles to user account.', '2024-06-26 15:18:24', 1),
(9, 'Add Role Access', 'Access to add role access.', '2024-06-26 15:18:24', 1),
(10, 'Update Role Access', 'Access to update role access.', '2024-06-26 15:18:24', 1),
(11, 'Delete Role Access', 'Access to delete role access.', '2024-06-26 15:18:24', 1),
(12, 'Add Role System Action Access', 'Access to add the role system action access.', '2024-06-26 15:18:24', 1),
(13, 'Update Role System Action Access', 'Access to update the role system action access.', '2024-06-26 15:18:24', 1),
(14, 'Delete Role System Action Access', 'Access to delete the role system action access.', '2024-06-26 15:18:24', 1),
(15, 'Add File Extension Access', 'Access to assign the file extension to the upload setting.', '2024-06-26 15:18:24', 1),
(16, 'Delete File Extension Access', 'Access to delete the file extension to the upload setting.', '2024-06-26 15:18:24', 1),
(17, 'Add Work Hours', 'Access to add the work hours.', '2024-07-02 10:23:36', 2),
(18, 'Update Work Hours', 'Access to update the work hours.', '2024-07-02 10:23:59', 2),
(19, 'Delete Work Hours', 'Access to delete the work hours.', '2024-07-02 10:24:19', 2);

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
-- Table structure for table `system_setting`
--

DROP TABLE IF EXISTS `system_setting`;
CREATE TABLE `system_setting` (
  `system_setting_id` int(10) UNSIGNED NOT NULL,
  `system_setting_name` varchar(100) NOT NULL,
  `system_setting_description` varchar(200) NOT NULL,
  `value` varchar(1000) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `ui_customization_setting`
--

DROP TABLE IF EXISTS `ui_customization_setting`;
CREATE TABLE `ui_customization_setting` (
  `ui_customization_setting_id` int(10) UNSIGNED NOT NULL,
  `user_account_id` int(10) UNSIGNED NOT NULL,
  `sidebar_type` varchar(20) NOT NULL DEFAULT 'full',
  `boxed_layout` tinyint(1) NOT NULL DEFAULT 0,
  `theme` varchar(10) NOT NULL DEFAULT 'light',
  `color_theme` varchar(20) NOT NULL DEFAULT 'Blue_Theme',
  `card_border` tinyint(1) NOT NULL DEFAULT 0,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `ui_customization_setting`
--

INSERT INTO `ui_customization_setting` (`ui_customization_setting_id`, `user_account_id`, `sidebar_type`, `boxed_layout`, `theme`, `color_theme`, `card_border`, `created_date`, `last_log_by`) VALUES
(1, 2, 'full', 0, 'light', 'Orange_Theme', 0, '2024-06-26 20:28:22', 2);

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
(1, 'App Logo', 'Sets the upload setting when uploading app logo.', 800, '2024-06-26 16:34:32', 1),
(2, 'Internal Notes Attachment', 'Sets the upload setting when uploading internal notes attachement.', 800, '2024-06-26 16:34:32', 1);

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
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `upload_setting_file_extension`
--

INSERT INTO `upload_setting_file_extension` (`upload_setting_file_extension_id`, `upload_setting_id`, `upload_setting_name`, `file_extension_id`, `file_extension_name`, `file_extension`, `date_assigned`, `created_date`, `last_log_by`) VALUES
(1, 1, 'App Logo', 63, 'PNG', 'png', '2024-06-26 16:38:37', '2024-06-26 16:38:37', 1),
(2, 1, 'App Logo', 61, 'JPG', 'jpg', '2024-06-26 16:38:37', '2024-06-26 16:38:37', 1),
(3, 1, 'App Logo', 62, 'JPEG', 'jpeg', '2024-06-26 16:38:37', '2024-06-26 16:38:37', 1),
(4, 2, 'Internal Notes Attachment', 63, 'PNG', 'png', '2024-06-26 16:38:37', '2024-06-26 16:38:37', 1),
(5, 2, 'Internal Notes Attachment', 61, 'JPG', 'jpg', '2024-06-26 16:38:37', '2024-06-26 16:38:37', 1),
(6, 2, 'Internal Notes Attachment', 62, 'JPEG', 'jpeg', '2024-06-26 16:38:37', '2024-06-26 16:38:37', 1),
(7, 2, 'Internal Notes Attachment', 127, 'PDF', 'pdf', '2024-06-26 16:38:37', '2024-06-26 16:38:37', 1),
(8, 2, 'Internal Notes Attachment', 125, 'DOC', 'doc', '2024-06-26 16:38:37', '2024-06-26 16:38:37', 1),
(9, 2, 'Internal Notes Attachment', 125, 'DOCX', 'docx', '2024-06-26 16:38:37', '2024-06-26 16:38:37', 1),
(10, 2, 'Internal Notes Attachment', 130, 'TXT', 'txt', '2024-06-26 16:38:37', '2024-06-26 16:38:37', 1),
(11, 2, 'Internal Notes Attachment', 92, 'XLS', 'xls', '2024-06-26 16:38:37', '2024-06-26 16:38:37', 1),
(12, 2, 'Internal Notes Attachment', 94, 'XLSX', 'xlsx', '2024-06-26 16:38:37', '2024-06-26 16:38:37', 1),
(13, 2, 'Internal Notes Attachment', 89, 'PPT', 'ppt', '2024-06-26 16:38:37', '2024-06-26 16:38:37', 1),
(14, 2, 'Internal Notes Attachment', 90, 'PPTX', 'pptx', '2024-06-26 16:38:37', '2024-06-26 16:38:37', 1);

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
  `email` varchar(255) DEFAULT NULL,
  `username` varchar(100) NOT NULL,
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

INSERT INTO `user_account` (`user_account_id`, `file_as`, `email`, `username`, `password`, `profile_picture`, `locked`, `active`, `last_failed_login_attempt`, `failed_login_attempts`, `last_connection_date`, `password_expiry_date`, `reset_token`, `reset_token_expiry_date`, `receive_notification`, `two_factor_auth`, `otp`, `otp_expiry_date`, `failed_otp_attempts`, `last_password_change`, `account_lock_duration`, `last_password_reset`, `multiple_session`, `session_token`, `created_date`, `last_log_by`) VALUES
(1, 'CGMI Bot', 'cgmibot.317@gmail.com', 'cgmibot', 'RYHObc8sNwIxdPDNJwCsO8bXKZJXYx7RjTgEWMC17FY%3D', NULL, 'No', 'Yes', NULL, 0, NULL, '2025-12-30', NULL, NULL, 'Yes', 'No', NULL, NULL, 0, NULL, 0, NULL, 'Yes', NULL, '2024-06-26 13:25:46', 1),
(2, 'Administrator', 'lawrenceagulto.317@gmail.com', 'ldagulto', 'RYHObc8sNwIxdPDNJwCsO8bXKZJXYx7RjTgEWMC17FY%3D', NULL, 'No', 'Yes', NULL, 0, '2024-07-02 19:52:31', '2025-12-30', NULL, NULL, 'Yes', 'No', NULL, NULL, 0, NULL, 0, NULL, 'Yes', '2C0vX7SHW62Zu2gx%2Fc2kveYbZoaWsoZI8%2BNCHd9r%2F6c%3D', '2024-06-26 13:25:47', 1);

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

    IF NEW.username <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Username: ", NEW.username);
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

    IF NEW.username <> OLD.username THEN
        SET audit_log = CONCAT(audit_log, "Username: ", OLD.username, " -> ", NEW.username, "<br/>");
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

-- --------------------------------------------------------

--
-- Table structure for table `work_hours`
--

DROP TABLE IF EXISTS `work_hours`;
CREATE TABLE `work_hours` (
  `work_hours_id` int(10) UNSIGNED NOT NULL,
  `work_schedule_id` int(10) UNSIGNED NOT NULL,
  `day_of_week` varchar(20) DEFAULT NULL,
  `day_period` varchar(20) DEFAULT NULL,
  `start_time` time NOT NULL,
  `end_time` time NOT NULL,
  `notes` varchar(500) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `work_hours`
--
DROP TRIGGER IF EXISTS `work_hours_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `work_hours_trigger_insert` AFTER INSERT ON `work_hours` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Work hours created. <br/>';

    IF NEW.day_of_week <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Day of Week: ", NEW.day_of_week);
    END IF;

    IF NEW.day_period <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Day Period: ", NEW.day_period);
    END IF;

    IF NEW.start_time <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Start Time: ", NEW.start_time);
    END IF;

    IF NEW.end_time <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>End Time: ", NEW.end_time);
    END IF;

    IF NEW.notes <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Notes: ", NEW.notes);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('work_hours', NEW.work_hours_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `work_hours_trigger_update`;
DELIMITER $$
CREATE TRIGGER `work_hours_trigger_update` AFTER UPDATE ON `work_hours` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.day_of_week <> OLD.day_of_week THEN
        SET audit_log = CONCAT(audit_log, "Day of Week: ", OLD.day_of_week, " -> ", NEW.day_of_week, "<br/>");
    END IF;

    IF NEW.day_period <> OLD.day_period THEN
        SET audit_log = CONCAT(audit_log, "Day Period: ", OLD.day_period, " -> ", NEW.day_period, "<br/>");
    END IF;

    IF NEW.start_time <> OLD.start_time THEN
        SET audit_log = CONCAT(audit_log, "Start Time: ", OLD.start_time, " -> ", NEW.start_time, "<br/>");
    END IF;

    IF NEW.end_time <> OLD.end_time THEN
        SET audit_log = CONCAT(audit_log, "End Time: ", OLD.end_time, " -> ", NEW.end_time, "<br/>");
    END IF;

    IF NEW.notes <> OLD.notes THEN
        SET audit_log = CONCAT(audit_log, "Notes: ", OLD.notes, " -> ", NEW.notes, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('work_hours', NEW.work_hours_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `work_information`
--

DROP TABLE IF EXISTS `work_information`;
CREATE TABLE `work_information` (
  `work_information_id` int(10) UNSIGNED NOT NULL,
  `employee_id` int(10) UNSIGNED NOT NULL,
  `badge_id` varchar(200) DEFAULT NULL,
  `company_id` int(10) UNSIGNED DEFAULT NULL,
  `company_name` varchar(100) DEFAULT NULL,
  `employment_type_id` int(10) UNSIGNED DEFAULT NULL,
  `employment_type_name` varchar(100) DEFAULT NULL,
  `department_id` int(10) UNSIGNED DEFAULT NULL,
  `department_name` varchar(100) DEFAULT NULL,
  `job_position_id` int(10) UNSIGNED DEFAULT NULL,
  `job_position_name` varchar(100) DEFAULT NULL,
  `manager_id` int(10) UNSIGNED DEFAULT NULL,
  `manager_name` varchar(100) DEFAULT NULL,
  `work_schedule_id` int(10) UNSIGNED DEFAULT NULL,
  `work_schedule_name` varchar(100) DEFAULT NULL,
  `employment_status` varchar(50) NOT NULL DEFAULT 'Active',
  `pin_code` varchar(500) DEFAULT NULL,
  `biometrics_id` varchar(500) DEFAULT NULL,
  `home_work_distance` double DEFAULT NULL,
  `number_of_dependents` int(11) DEFAULT NULL,
  `visa_number` varchar(50) DEFAULT NULL,
  `work_permit_number` varchar(50) DEFAULT NULL,
  `visa_expiration_date` date DEFAULT NULL,
  `work_permit_expiration_date` date DEFAULT NULL,
  `work_permit` varchar(500) DEFAULT NULL,
  `onboard_date` date DEFAULT NULL,
  `offboard_date` date DEFAULT NULL,
  `departure_reason_id` int(10) UNSIGNED DEFAULT NULL,
  `departure_reason_name` varchar(100) DEFAULT NULL,
  `detailed_departure_reason` varchar(5000) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

-- --------------------------------------------------------

--
-- Table structure for table `work_location`
--

DROP TABLE IF EXISTS `work_location`;
CREATE TABLE `work_location` (
  `work_location_id` int(10) UNSIGNED NOT NULL,
  `work_location_name` varchar(100) NOT NULL,
  `address` varchar(500) NOT NULL,
  `city_id` int(10) UNSIGNED NOT NULL,
  `city_name` varchar(100) NOT NULL,
  `state_id` int(10) UNSIGNED NOT NULL,
  `state_name` varchar(100) NOT NULL,
  `country_id` int(10) UNSIGNED NOT NULL,
  `country_name` varchar(100) NOT NULL,
  `phone` varchar(50) DEFAULT NULL,
  `mobile` varchar(50) DEFAULT NULL,
  `email` varchar(500) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `work_location`
--
DROP TRIGGER IF EXISTS `work_location_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `work_location_trigger_insert` AFTER INSERT ON `work_location` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Work location created. <br/>';

    IF NEW.work_location_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Work Location Name: ", NEW.work_location_name);
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

    IF NEW.phone <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Phone: ", NEW.phone);
    END IF;

    IF NEW.mobile <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Mobile: ", NEW.mobile);
    END IF;

    IF NEW.email <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Email: ", NEW.email);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('work_location', NEW.work_location_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `work_location_trigger_update`;
DELIMITER $$
CREATE TRIGGER `work_location_trigger_update` AFTER UPDATE ON `work_location` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.work_location_name <> OLD.work_location_name THEN
        SET audit_log = CONCAT(audit_log, "Work Location Name: ", OLD.work_location_name, " -> ", NEW.work_location_name, "<br/>");
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

    IF NEW.phone <> OLD.phone THEN
        SET audit_log = CONCAT(audit_log, "Phone: ", OLD.phone, " -> ", NEW.phone, "<br/>");
    END IF;

    IF NEW.mobile <> OLD.mobile THEN
        SET audit_log = CONCAT(audit_log, "Mobile: ", OLD.mobile, " -> ", NEW.mobile, "<br/>");
    END IF;

    IF NEW.email <> OLD.email THEN
        SET audit_log = CONCAT(audit_log, "Email: ", OLD.email, " -> ", NEW.email, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('work_location', NEW.work_location_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `work_schedule`
--

DROP TABLE IF EXISTS `work_schedule`;
CREATE TABLE `work_schedule` (
  `work_schedule_id` int(10) UNSIGNED NOT NULL,
  `work_schedule_name` varchar(100) NOT NULL,
  `schedule_type_id` int(10) UNSIGNED NOT NULL,
  `schedule_type_name` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `work_schedule`
--
DROP TRIGGER IF EXISTS `work_schedule_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `work_schedule_trigger_insert` AFTER INSERT ON `work_schedule` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Work schedule created. <br/>';

    IF NEW.work_schedule_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Work Schedule Name: ", NEW.work_schedule_name);
    END IF;

    IF NEW.schedule_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Schedule Type Name: ", NEW.schedule_type_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('work_schedule', NEW.work_schedule_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `work_schedule_trigger_update`;
DELIMITER $$
CREATE TRIGGER `work_schedule_trigger_update` AFTER UPDATE ON `work_schedule` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.work_schedule_name <> OLD.work_schedule_name THEN
        SET audit_log = CONCAT(audit_log, "Work Schedule Name: ", OLD.work_schedule_name, " -> ", NEW.work_schedule_name, "<br/>");
    END IF;

    IF NEW.schedule_type_name <> OLD.schedule_type_name THEN
        SET audit_log = CONCAT(audit_log, "Schedule Type Name: ", OLD.schedule_type_name, " -> ", NEW.schedule_type_name, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('work_schedule', NEW.work_schedule_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

--
-- Indexes for dumped tables
--

--
-- Indexes for table `address_type`
--
ALTER TABLE `address_type`
  ADD PRIMARY KEY (`address_type_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `address_type_index_address_type_id` (`address_type_id`);

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
-- Indexes for table `bank`
--
ALTER TABLE `bank`
  ADD PRIMARY KEY (`bank_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `bank_index_bank_id` (`bank_id`);

--
-- Indexes for table `bank_account_type`
--
ALTER TABLE `bank_account_type`
  ADD PRIMARY KEY (`bank_account_type_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `bank_account_type_index_bank_account_type_id` (`bank_account_type_id`);

--
-- Indexes for table `blood_type`
--
ALTER TABLE `blood_type`
  ADD PRIMARY KEY (`blood_type_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `blood_type_index_blood_type_id` (`blood_type_id`);

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
-- Indexes for table `civil_status`
--
ALTER TABLE `civil_status`
  ADD PRIMARY KEY (`civil_status_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `civil_status_index_civil_status_id` (`civil_status_id`);

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
-- Indexes for table `contact_information_type`
--
ALTER TABLE `contact_information_type`
  ADD PRIMARY KEY (`contact_information_type_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `contact_information_type_index_contact_information_type_id` (`contact_information_type_id`);

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
-- Indexes for table `department`
--
ALTER TABLE `department`
  ADD PRIMARY KEY (`department_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `department_index_department_id` (`department_id`),
  ADD KEY `department_index_parent_department_id` (`parent_department_id`),
  ADD KEY `department_index_manager_id` (`manager_id`);

--
-- Indexes for table `departure_reason`
--
ALTER TABLE `departure_reason`
  ADD PRIMARY KEY (`departure_reason_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `departure_reason_index_departure_reason_id` (`departure_reason_id`);

--
-- Indexes for table `educational_stage`
--
ALTER TABLE `educational_stage`
  ADD PRIMARY KEY (`educational_stage_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `educational_stage_index_educational_stage_id` (`educational_stage_id`);

--
-- Indexes for table `email_setting`
--
ALTER TABLE `email_setting`
  ADD PRIMARY KEY (`email_setting_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `email_setting_index_email_setting_id` (`email_setting_id`);

--
-- Indexes for table `employee`
--
ALTER TABLE `employee`
  ADD PRIMARY KEY (`employee_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `employee_index_employee_id` (`employee_id`),
  ADD KEY `employee_index_civil_status_id` (`civil_status_id`),
  ADD KEY `employee_index_gender_id` (`gender_id`),
  ADD KEY `employee_index_religion_id` (`religion_id`),
  ADD KEY `employee_index_blood_type_id` (`blood_type_id`);

--
-- Indexes for table `employment_type`
--
ALTER TABLE `employment_type`
  ADD PRIMARY KEY (`employment_type_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `employment_type_index_employment_type_id` (`employment_type_id`);

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
-- Indexes for table `gender`
--
ALTER TABLE `gender`
  ADD PRIMARY KEY (`gender_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `gender_index_gender_id` (`gender_id`);

--
-- Indexes for table `id_type`
--
ALTER TABLE `id_type`
  ADD PRIMARY KEY (`id_type_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `id_type_index_id_type_id` (`id_type_id`);

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
-- Indexes for table `job_position`
--
ALTER TABLE `job_position`
  ADD PRIMARY KEY (`job_position_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `job_position_index_job_position_id` (`job_position_id`);

--
-- Indexes for table `language`
--
ALTER TABLE `language`
  ADD PRIMARY KEY (`language_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `language_index_language_id` (`language_id`);

--
-- Indexes for table `language_proficiency`
--
ALTER TABLE `language_proficiency`
  ADD PRIMARY KEY (`language_proficiency_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `language_proficiency_index_language_proficiency_id` (`language_proficiency_id`);

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
  ADD KEY `password_history_index_user_account_id` (`user_account_id`);

--
-- Indexes for table `relation`
--
ALTER TABLE `relation`
  ADD PRIMARY KEY (`relation_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `relation_index_relation_id` (`relation_id`);

--
-- Indexes for table `religion`
--
ALTER TABLE `religion`
  ADD PRIMARY KEY (`religion_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `religion_index_religion_id` (`religion_id`);

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
-- Indexes for table `schedule_type`
--
ALTER TABLE `schedule_type`
  ADD PRIMARY KEY (`schedule_type_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `schedule_type_index_schedule_type_id` (`schedule_type_id`);

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
-- Indexes for table `system_setting`
--
ALTER TABLE `system_setting`
  ADD PRIMARY KEY (`system_setting_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `system_setting_index_system_setting_id` (`system_setting_id`);

--
-- Indexes for table `ui_customization_setting`
--
ALTER TABLE `ui_customization_setting`
  ADD PRIMARY KEY (`ui_customization_setting_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `ui_setting_index_ui_customization_setting_id` (`ui_customization_setting_id`),
  ADD KEY `ui_setting_index_user_account_id` (`user_account_id`);

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
-- Indexes for table `work_hours`
--
ALTER TABLE `work_hours`
  ADD PRIMARY KEY (`work_hours_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `work_schedule_id` (`work_schedule_id`),
  ADD KEY `work_hours_index_work_hours_id` (`work_hours_id`);

--
-- Indexes for table `work_information`
--
ALTER TABLE `work_information`
  ADD PRIMARY KEY (`work_information_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `work_information_index_employee_id` (`employee_id`),
  ADD KEY `work_information_index_employment_type_id` (`employment_type_id`),
  ADD KEY `work_information_index_department_id` (`department_id`),
  ADD KEY `work_information_index_job_position_id` (`job_position_id`),
  ADD KEY `work_information_index_manager_id` (`manager_id`),
  ADD KEY `work_information_index_work_schedule_id` (`work_schedule_id`),
  ADD KEY `work_information_index_departure_reason_id` (`departure_reason_id`),
  ADD KEY `work_information_index_employment_status` (`employment_status`);

--
-- Indexes for table `work_location`
--
ALTER TABLE `work_location`
  ADD PRIMARY KEY (`work_location_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `work_location_index_work_location_id` (`work_location_id`),
  ADD KEY `work_location_index_city_id` (`city_id`),
  ADD KEY `work_location_index_state_id` (`state_id`),
  ADD KEY `work_location_index_country_id` (`country_id`);

--
-- Indexes for table `work_schedule`
--
ALTER TABLE `work_schedule`
  ADD PRIMARY KEY (`work_schedule_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `schedule_type_id` (`schedule_type_id`),
  ADD KEY `work_schedule_index_work_schedule_id` (`work_schedule_id`);

--
-- AUTO_INCREMENT for dumped tables
--

--
-- AUTO_INCREMENT for table `address_type`
--
ALTER TABLE `address_type`
  MODIFY `address_type_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `app_module`
--
ALTER TABLE `app_module`
  MODIFY `app_module_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `audit_log`
--
ALTER TABLE `audit_log`
  MODIFY `audit_log_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2871;

--
-- AUTO_INCREMENT for table `bank`
--
ALTER TABLE `bank`
  MODIFY `bank_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `bank_account_type`
--
ALTER TABLE `bank_account_type`
  MODIFY `bank_account_type_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `blood_type`
--
ALTER TABLE `blood_type`
  MODIFY `blood_type_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `city`
--
ALTER TABLE `city`
  MODIFY `city_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=1635;

--
-- AUTO_INCREMENT for table `civil_status`
--
ALTER TABLE `civil_status`
  MODIFY `civil_status_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `company`
--
ALTER TABLE `company`
  MODIFY `company_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `contact_information_type`
--
ALTER TABLE `contact_information_type`
  MODIFY `contact_information_type_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `country`
--
ALTER TABLE `country`
  MODIFY `country_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=251;

--
-- AUTO_INCREMENT for table `currency`
--
ALTER TABLE `currency`
  MODIFY `currency_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `department`
--
ALTER TABLE `department`
  MODIFY `department_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `departure_reason`
--
ALTER TABLE `departure_reason`
  MODIFY `departure_reason_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `educational_stage`
--
ALTER TABLE `educational_stage`
  MODIFY `educational_stage_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `email_setting`
--
ALTER TABLE `email_setting`
  MODIFY `email_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `employee`
--
ALTER TABLE `employee`
  MODIFY `employee_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `employment_type`
--
ALTER TABLE `employment_type`
  MODIFY `employment_type_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `file_extension`
--
ALTER TABLE `file_extension`
  MODIFY `file_extension_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=132;

--
-- AUTO_INCREMENT for table `file_type`
--
ALTER TABLE `file_type`
  MODIFY `file_type_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `gender`
--
ALTER TABLE `gender`
  MODIFY `gender_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `id_type`
--
ALTER TABLE `id_type`
  MODIFY `id_type_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `internal_notes`
--
ALTER TABLE `internal_notes`
  MODIFY `internal_notes_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `internal_notes_attachment`
--
ALTER TABLE `internal_notes_attachment`
  MODIFY `internal_notes_attachment_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `job_position`
--
ALTER TABLE `job_position`
  MODIFY `job_position_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `language`
--
ALTER TABLE `language`
  MODIFY `language_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=152;

--
-- AUTO_INCREMENT for table `language_proficiency`
--
ALTER TABLE `language_proficiency`
  MODIFY `language_proficiency_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `menu_group`
--
ALTER TABLE `menu_group`
  MODIFY `menu_group_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=7;

--
-- AUTO_INCREMENT for table `menu_item`
--
ALTER TABLE `menu_item`
  MODIFY `menu_item_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=45;

--
-- AUTO_INCREMENT for table `notification_setting`
--
ALTER TABLE `notification_setting`
  MODIFY `notification_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `notification_setting_email_template`
--
ALTER TABLE `notification_setting_email_template`
  MODIFY `notification_setting_email_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `notification_setting_sms_template`
--
ALTER TABLE `notification_setting_sms_template`
  MODIFY `notification_setting_sms_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `notification_setting_system_template`
--
ALTER TABLE `notification_setting_system_template`
  MODIFY `notification_setting_system_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `password_history`
--
ALTER TABLE `password_history`
  MODIFY `password_history_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `relation`
--
ALTER TABLE `relation`
  MODIFY `relation_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `religion`
--
ALTER TABLE `religion`
  MODIFY `religion_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `role`
--
ALTER TABLE `role`
  MODIFY `role_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `role_permission`
--
ALTER TABLE `role_permission`
  MODIFY `role_permission_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=46;

--
-- AUTO_INCREMENT for table `role_system_action_permission`
--
ALTER TABLE `role_system_action_permission`
  MODIFY `role_system_action_permission_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `role_user_account`
--
ALTER TABLE `role_user_account`
  MODIFY `role_user_account_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `schedule_type`
--
ALTER TABLE `schedule_type`
  MODIFY `schedule_type_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `security_setting`
--
ALTER TABLE `security_setting`
  MODIFY `security_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `state`
--
ALTER TABLE `state`
  MODIFY `state_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;

--
-- AUTO_INCREMENT for table `system_action`
--
ALTER TABLE `system_action`
  MODIFY `system_action_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=20;

--
-- AUTO_INCREMENT for table `system_setting`
--
ALTER TABLE `system_setting`
  MODIFY `system_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `ui_customization_setting`
--
ALTER TABLE `ui_customization_setting`
  MODIFY `ui_customization_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `upload_setting`
--
ALTER TABLE `upload_setting`
  MODIFY `upload_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `upload_setting_file_extension`
--
ALTER TABLE `upload_setting_file_extension`
  MODIFY `upload_setting_file_extension_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

--
-- AUTO_INCREMENT for table `user_account`
--
ALTER TABLE `user_account`
  MODIFY `user_account_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `work_hours`
--
ALTER TABLE `work_hours`
  MODIFY `work_hours_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `work_information`
--
ALTER TABLE `work_information`
  MODIFY `work_information_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `work_location`
--
ALTER TABLE `work_location`
  MODIFY `work_location_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `work_schedule`
--
ALTER TABLE `work_schedule`
  MODIFY `work_schedule_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `address_type`
--
ALTER TABLE `address_type`
  ADD CONSTRAINT `address_type_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

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
-- Constraints for table `bank`
--
ALTER TABLE `bank`
  ADD CONSTRAINT `bank_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `bank_account_type`
--
ALTER TABLE `bank_account_type`
  ADD CONSTRAINT `bank_account_type_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `blood_type`
--
ALTER TABLE `blood_type`
  ADD CONSTRAINT `blood_type_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `city`
--
ALTER TABLE `city`
  ADD CONSTRAINT `city_ibfk_1` FOREIGN KEY (`country_id`) REFERENCES `country` (`country_id`),
  ADD CONSTRAINT `city_ibfk_2` FOREIGN KEY (`state_id`) REFERENCES `state` (`state_id`),
  ADD CONSTRAINT `city_ibfk_3` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `civil_status`
--
ALTER TABLE `civil_status`
  ADD CONSTRAINT `civil_status_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `company`
--
ALTER TABLE `company`
  ADD CONSTRAINT `company_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `contact_information_type`
--
ALTER TABLE `contact_information_type`
  ADD CONSTRAINT `contact_information_type_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

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
-- Constraints for table `department`
--
ALTER TABLE `department`
  ADD CONSTRAINT `department_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `departure_reason`
--
ALTER TABLE `departure_reason`
  ADD CONSTRAINT `departure_reason_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `educational_stage`
--
ALTER TABLE `educational_stage`
  ADD CONSTRAINT `educational_stage_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `email_setting`
--
ALTER TABLE `email_setting`
  ADD CONSTRAINT `email_setting_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `employee`
--
ALTER TABLE `employee`
  ADD CONSTRAINT `employee_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `employment_type`
--
ALTER TABLE `employment_type`
  ADD CONSTRAINT `employment_type_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `file_extension`
--
ALTER TABLE `file_extension`
  ADD CONSTRAINT `file_extension_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`),
  ADD CONSTRAINT `file_extension_ibfk_2` FOREIGN KEY (`file_type_id`) REFERENCES `file_type` (`file_type_id`);

--
-- Constraints for table `file_type`
--
ALTER TABLE `file_type`
  ADD CONSTRAINT `file_type_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `gender`
--
ALTER TABLE `gender`
  ADD CONSTRAINT `gender_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `id_type`
--
ALTER TABLE `id_type`
  ADD CONSTRAINT `id_type_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

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
-- Constraints for table `job_position`
--
ALTER TABLE `job_position`
  ADD CONSTRAINT `job_position_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `language`
--
ALTER TABLE `language`
  ADD CONSTRAINT `language_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `language_proficiency`
--
ALTER TABLE `language_proficiency`
  ADD CONSTRAINT `language_proficiency_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

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
-- Constraints for table `relation`
--
ALTER TABLE `relation`
  ADD CONSTRAINT `relation_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `religion`
--
ALTER TABLE `religion`
  ADD CONSTRAINT `religion_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

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
-- Constraints for table `schedule_type`
--
ALTER TABLE `schedule_type`
  ADD CONSTRAINT `schedule_type_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

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
-- Constraints for table `system_setting`
--
ALTER TABLE `system_setting`
  ADD CONSTRAINT `system_setting_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `ui_customization_setting`
--
ALTER TABLE `ui_customization_setting`
  ADD CONSTRAINT `ui_customization_setting_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`),
  ADD CONSTRAINT `ui_customization_setting_ibfk_2` FOREIGN KEY (`user_account_id`) REFERENCES `user_account` (`user_account_id`);

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

--
-- Constraints for table `work_hours`
--
ALTER TABLE `work_hours`
  ADD CONSTRAINT `work_hours_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`),
  ADD CONSTRAINT `work_hours_ibfk_2` FOREIGN KEY (`work_schedule_id`) REFERENCES `work_schedule` (`work_schedule_id`);

--
-- Constraints for table `work_information`
--
ALTER TABLE `work_information`
  ADD CONSTRAINT `work_information_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`),
  ADD CONSTRAINT `work_information_ibfk_2` FOREIGN KEY (`employee_id`) REFERENCES `employee` (`employee_id`);

--
-- Constraints for table `work_location`
--
ALTER TABLE `work_location`
  ADD CONSTRAINT `work_location_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `work_schedule`
--
ALTER TABLE `work_schedule`
  ADD CONSTRAINT `work_schedule_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`),
  ADD CONSTRAINT `work_schedule_ibfk_2` FOREIGN KEY (`schedule_type_id`) REFERENCES `schedule_type` (`schedule_type_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
