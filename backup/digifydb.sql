-- phpMyAdmin SQL Dump
-- version 5.2.1
-- https://www.phpmyadmin.net/
--
-- Host: 127.0.0.1
-- Generation Time: Sep 12, 2024 at 03:19 PM
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

DROP PROCEDURE IF EXISTS `checkAccordionExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkAccordionExist` (IN `p_accordion_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM accordion
    WHERE accordion_id = p_accordion_id;
END$$

DROP PROCEDURE IF EXISTS `checkAccordionItemExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkAccordionItemExist` (IN `p_accordion_item_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM accordion_item
    WHERE accordion_item_id = p_accordion_item_id;
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

DROP PROCEDURE IF EXISTS `checkBlockContainerExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkBlockContainerExist` (IN `p_block_style_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM block_container
    WHERE block_style_id = p_block_style_id;
END$$

DROP PROCEDURE IF EXISTS `checkBlockItemExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkBlockItemExist` (IN `p_block_style_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM block_item
    WHERE block_style_id = p_block_style_id;
END$$

DROP PROCEDURE IF EXISTS `checkBlockStyleExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkBlockStyleExist` (IN `p_block_style_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM block_style
    WHERE block_style_id = p_block_style_id;
END$$

DROP PROCEDURE IF EXISTS `checkBlockTypeExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkBlockTypeExist` (IN `p_block_type_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM block_type
    WHERE block_type_id = p_block_type_id;
END$$

DROP PROCEDURE IF EXISTS `checkBloodTypeExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkBloodTypeExist` (IN `p_blood_type_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM blood_type
    WHERE blood_type_id = p_blood_type_id;
END$$

DROP PROCEDURE IF EXISTS `checkBookingExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkBookingExist` (IN `p_booking_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM booking
    WHERE booking_id = p_booking_id;
END$$

DROP PROCEDURE IF EXISTS `checkCallToActionExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkCallToActionExist` (IN `p_call_to_action_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM call_to_action
    WHERE call_to_action_id = p_call_to_action_id;
END$$

DROP PROCEDURE IF EXISTS `checkCarouselExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkCarouselExist` (IN `p_carousel_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM carousel
    WHERE carousel_id = p_carousel_id;
END$$

DROP PROCEDURE IF EXISTS `checkCarouselImageExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkCarouselImageExist` (IN `p_carousel_image_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM carousel_image
    WHERE carousel_image_id = p_carousel_image_id;
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

DROP PROCEDURE IF EXISTS `checkClientExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkClientExist` (IN `p_client_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM client
    WHERE client_id = p_client_id;
END$$

DROP PROCEDURE IF EXISTS `checkClientItemExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkClientItemExist` (IN `p_client_item_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM client_item
    WHERE client_item_id = p_client_item_id;
END$$

DROP PROCEDURE IF EXISTS `checkCompanyExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkCompanyExist` (IN `p_company_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM company
    WHERE company_id = p_company_id;
END$$

DROP PROCEDURE IF EXISTS `checkContactFormExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkContactFormExist` (IN `p_contact_form_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM contact_form
    WHERE contact_form_id = p_contact_form_id;
END$$

DROP PROCEDURE IF EXISTS `checkContactInformationTypeExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkContactInformationTypeExist` (IN `p_contact_information_type_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM contact_information_type
    WHERE contact_information_type_id = p_contact_information_type_id;
END$$

DROP PROCEDURE IF EXISTS `checkContentCarouselExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkContentCarouselExist` (IN `p_content_carousel_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM content_carousel
    WHERE content_carousel_id = p_content_carousel_id;
END$$

DROP PROCEDURE IF EXISTS `checkContentCarouselItemExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkContentCarouselItemExist` (IN `p_content_carousel_item_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM content_carousel_item
    WHERE content_carousel_item_id = p_content_carousel_item_id;
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

DROP PROCEDURE IF EXISTS `checkCustomerAddressExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkCustomerAddressExist` (IN `p_customer_address_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM customer_address
    WHERE customer_address_id = p_customer_address_id;
END$$

DROP PROCEDURE IF EXISTS `checkCustomerBankAccountExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkCustomerBankAccountExist` (IN `p_customer_bank_account_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM customer_bank_account
    WHERE customer_bank_account_id = p_customer_bank_account_id;
END$$

DROP PROCEDURE IF EXISTS `checkCustomerBankCardExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkCustomerBankCardExist` (IN `p_customer_bank_card_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM customer_bank_card
    WHERE customer_bank_card_id = p_customer_bank_card_id;
END$$

DROP PROCEDURE IF EXISTS `checkCustomerExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkCustomerExist` (IN `p_customer_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM customer
    WHERE customer_id = p_customer_id;
END$$

DROP PROCEDURE IF EXISTS `checkCustomerIDRecordExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkCustomerIDRecordExist` (IN `p_customer_id_record_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM customer_id_record
    WHERE customer_id_record_id = p_customer_id_record_id;
END$$

DROP PROCEDURE IF EXISTS `checkCustomerInquiryExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkCustomerInquiryExist` (IN `p_customer_inquiry_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM customer_inquiry
    WHERE customer_inquiry_id = p_customer_inquiry_id;
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

DROP PROCEDURE IF EXISTS `checkEmployeeAddressExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkEmployeeAddressExist` (IN `p_employee_address_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM employee_address
    WHERE employee_address_id = p_employee_address_id;
END$$

DROP PROCEDURE IF EXISTS `checkEmployeeBankAccountExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkEmployeeBankAccountExist` (IN `p_employee_bank_account_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM employee_bank_account
    WHERE employee_bank_account_id = p_employee_bank_account_id;
END$$

DROP PROCEDURE IF EXISTS `checkEmployeeEducationExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkEmployeeEducationExist` (IN `p_employee_education_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM employee_education
    WHERE employee_education_id = p_employee_education_id;
END$$

DROP PROCEDURE IF EXISTS `checkEmployeeEmergencyContactExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkEmployeeEmergencyContactExist` (IN `p_employee_emergency_contact_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM employee_emergency_contact
    WHERE employee_emergency_contact_id = p_employee_emergency_contact_id;
END$$

DROP PROCEDURE IF EXISTS `checkEmployeeExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkEmployeeExist` (IN `p_employee_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM employee
    WHERE employee_id = p_employee_id;
END$$

DROP PROCEDURE IF EXISTS `checkEmployeeExperienceExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkEmployeeExperienceExist` (IN `p_employee_experience_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM employee_experience
    WHERE employee_experience_id = p_employee_experience_id;
END$$

DROP PROCEDURE IF EXISTS `checkEmployeeIDRecordExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkEmployeeIDRecordExist` (IN `p_employee_id_record_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM employee_id_record
    WHERE employee_id_record_id = p_employee_id_record_id;
END$$

DROP PROCEDURE IF EXISTS `checkEmployeeLanguageExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkEmployeeLanguageExist` (IN `p_employee_language_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM employee_language
    WHERE employee_language_id = p_employee_language_id;
END$$

DROP PROCEDURE IF EXISTS `checkEmployeeLicenseExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkEmployeeLicenseExist` (IN `p_employee_license_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM employee_license
    WHERE employee_license_id = p_employee_license_id;
END$$

DROP PROCEDURE IF EXISTS `checkEmploymentLocationTypeExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkEmploymentLocationTypeExist` (IN `p_employment_location_type_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM employment_location_type
    WHERE employment_location_type_id = p_employment_location_type_id;
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

DROP PROCEDURE IF EXISTS `checkFooterExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkFooterExist` (IN `p_footer_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM footer
    WHERE footer_id = p_footer_id;
END$$

DROP PROCEDURE IF EXISTS `checkGenderExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkGenderExist` (IN `p_gender_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM gender
    WHERE gender_id = p_gender_id;
END$$

DROP PROCEDURE IF EXISTS `checkHeaderExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkHeaderExist` (IN `p_header_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM header
    WHERE header_id = p_header_id;
END$$

DROP PROCEDURE IF EXISTS `checkIDTypeExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkIDTypeExist` (IN `p_id_type_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM id_type
    WHERE id_type_id = p_id_type_id;
END$$

DROP PROCEDURE IF EXISTS `checkImageGalleryExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkImageGalleryExist` (IN `p_image_gallery_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM image_gallery
    WHERE image_gallery_id = p_image_gallery_id;
END$$

DROP PROCEDURE IF EXISTS `checkImageGalleryItemExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkImageGalleryItemExist` (IN `p_image_gallery_item_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM image_gallery_item
    WHERE image_gallery_item_id = p_image_gallery_item_id;
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

DROP PROCEDURE IF EXISTS `checkPageTitleExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkPageTitleExist` (IN `p_page_title_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM page_title
    WHERE page_title_id = p_page_title_id;
END$$

DROP PROCEDURE IF EXISTS `checkPricingTableExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkPricingTableExist` (IN `p_pricing_table_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM pricing_table
    WHERE pricing_table_id = p_pricing_table_id;
END$$

DROP PROCEDURE IF EXISTS `checkProcesStepExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkProcesStepExist` (IN `p_process_step_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM process_step
    WHERE process_step_id = p_process_step_id;
END$$

DROP PROCEDURE IF EXISTS `checkProcesStepItemExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkProcesStepItemExist` (IN `p_process_step_item_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM process_step_item
    WHERE process_step_item_id = p_process_step_item_id;
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

DROP PROCEDURE IF EXISTS `checkSectionsExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkSectionsExist` (IN `p_sections_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM sections
    WHERE sections_id = p_sections_id;
END$$

DROP PROCEDURE IF EXISTS `checkServicesBoxExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkServicesBoxExist` (IN `p_services_box_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM services_box
    WHERE services_box_id = p_services_box_id;
END$$

DROP PROCEDURE IF EXISTS `checkServicesBoxItemExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkServicesBoxItemExist` (IN `p_services_box_item_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM services_box_item
    WHERE services_box_item_id = p_services_box_item_id;
END$$

DROP PROCEDURE IF EXISTS `checkSliderExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkSliderExist` (IN `p_slider_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM slider
    WHERE slider_id = p_slider_id;
END$$

DROP PROCEDURE IF EXISTS `checkSliderItemExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkSliderItemExist` (IN `p_slider_item_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM slider_item
    WHERE slider_item_id = p_slider_item_id;
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

DROP PROCEDURE IF EXISTS `checkTestimonialExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkTestimonialExist` (IN `p_testimonial_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM testimonial
    WHERE testimonial_id = p_testimonial_id;
END$$

DROP PROCEDURE IF EXISTS `checkTestimonialItemExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkTestimonialItemExist` (IN `p_testimonial_item_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM testimonial_item
    WHERE testimonial_item_id = p_testimonial_item_id;
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

DROP PROCEDURE IF EXISTS `checkUserAccountUsernameExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkUserAccountUsernameExist` (IN `p_username` VARCHAR(100))   BEGIN
	SELECT COUNT(*) AS total
    FROM user_account
    WHERE username = p_username;
END$$

DROP PROCEDURE IF EXISTS `checkUserAccountUsernameUpdateExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkUserAccountUsernameUpdateExist` (IN `p_user_account_id` INT, IN `p_username` VARCHAR(100))   BEGIN
	SELECT COUNT(*) AS total
    FROM user_account
    WHERE username = p_username AND user_account_id != p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `checkVoucherCodeExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkVoucherCodeExist` (IN `p_voucher_code` VARCHAR(20))   BEGIN
	SELECT COUNT(*) AS total
    FROM voucher
    WHERE voucher_code = p_voucher_code;
END$$

DROP PROCEDURE IF EXISTS `checkVoucherCodeValidy`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkVoucherCodeValidy` (IN `p_voucher_code` VARCHAR(20))   BEGIN
	SELECT COUNT(*) AS total
    FROM voucher
    WHERE voucher_code = p_voucher_code AND voucher_usage_start_date <= NOW() AND voucher_usage_end_date >= NOW() AND available_voucher > 0;
END$$

DROP PROCEDURE IF EXISTS `checkVoucherExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkVoucherExist` (IN `p_voucher_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM voucher
    WHERE voucher_id = p_voucher_id;
END$$

DROP PROCEDURE IF EXISTS `checkWebsiteExist`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `checkWebsiteExist` (IN `p_website_id` INT)   BEGIN
	SELECT COUNT(*) AS total
    FROM website
    WHERE website_id = p_website_id;
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

DROP PROCEDURE IF EXISTS `deleteAccordion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteAccordion` (IN `p_accordion_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM accordion_item WHERE accordion_id = p_accordion_id;
    DELETE FROM accordion WHERE accordion_id = p_accordion_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteAccordionItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteAccordionItem` (IN `p_accordion_item_id` INT)   BEGIN
   DELETE FROM accordion_item WHERE accordion_item_id = p_accordion_item_id;
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

DROP PROCEDURE IF EXISTS `deleteBlockStyle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteBlockStyle` (IN `p_block_style_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM block_container WHERE block_style_id = p_block_style_id;
    DELETE FROM block_item WHERE block_style_id = p_block_style_id;
    DELETE FROM block_style WHERE block_style_id = p_block_style_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteBlockType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteBlockType` (IN `p_block_type_id` INT)   BEGIN
    DELETE FROM block_type WHERE block_type_id = p_block_type_id;
END$$

DROP PROCEDURE IF EXISTS `deleteBloodType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteBloodType` (IN `p_blood_type_id` INT)   BEGIN
    DELETE FROM blood_type WHERE blood_type_id = p_blood_type_id;
END$$

DROP PROCEDURE IF EXISTS `deleteBooking`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteBooking` (IN `p_booking_id` INT)   BEGIN
    DELETE FROM booking WHERE booking_id = p_booking_id;
END$$

DROP PROCEDURE IF EXISTS `deleteCallToAction`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCallToAction` (IN `p_call_to_action_id` INT)   BEGIN
   DELETE FROM call_to_action WHERE call_to_action_id = p_call_to_action_id;
END$$

DROP PROCEDURE IF EXISTS `deleteCarousel`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCarousel` (IN `p_carousel_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM carousel_image WHERE carousel_id = p_carousel_id;
    DELETE FROM carousel WHERE carousel_id = p_carousel_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteCarouselImage`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCarouselImage` (IN `p_carousel_image_id` INT)   BEGIN
   DELETE FROM carousel_image WHERE carousel_image_id = p_carousel_image_id;
END$$

DROP PROCEDURE IF EXISTS `deleteCity`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCity` (IN `p_city_id` INT)   BEGIN
    DELETE FROM city WHERE city_id = p_city_id;
END$$

DROP PROCEDURE IF EXISTS `deleteCivilStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCivilStatus` (IN `p_civil_status_id` INT)   BEGIN
    DELETE FROM civil_status WHERE civil_status_id = p_civil_status_id;
END$$

DROP PROCEDURE IF EXISTS `deleteClient`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteClient` (IN `p_client_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM client_item WHERE client_id = p_client_id;
    DELETE FROM client WHERE client_id = p_client_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteClientItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteClientItem` (IN `p_client_item_id` INT)   BEGIN
   DELETE FROM client_item WHERE client_item_id = p_client_item_id;
END$$

DROP PROCEDURE IF EXISTS `deleteCompany`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCompany` (IN `p_company_id` INT)   BEGIN
    DELETE FROM company WHERE company_id = p_company_id;
END$$

DROP PROCEDURE IF EXISTS `deleteContactForm`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteContactForm` (IN `p_contact_form_id` INT)   BEGIN
    DELETE FROM contact_form WHERE contact_form_id = p_contact_form_id;
END$$

DROP PROCEDURE IF EXISTS `deleteContactInformationType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteContactInformationType` (IN `p_contact_information_type_id` INT)   BEGIN
    DELETE FROM contact_information_type WHERE contact_information_type_id = p_contact_information_type_id;
END$$

DROP PROCEDURE IF EXISTS `deleteContentCarousel`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteContentCarousel` (IN `p_content_carousel_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM content_carousel_item WHERE content_carousel_id = p_content_carousel_id;
    DELETE FROM content_carousel WHERE content_carousel_id = p_content_carousel_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteContentCarouselItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteContentCarouselItem` (IN `p_content_carousel_item_id` INT)   BEGIN
   DELETE FROM content_carousel_item WHERE content_carousel_item_id = p_content_carousel_item_id;
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

DROP PROCEDURE IF EXISTS `deleteCustomer`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCustomer` (IN `p_customer_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM customer_address WHERE customer_id = p_customer_id;
    DELETE FROM customer_bank_card WHERE customer_id = p_customer_id;
    DELETE FROM customer_id_record WHERE customer_id = p_customer_id;
    DELETE FROM customer WHERE customer_id = p_customer_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteCustomerAddress`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCustomerAddress` (IN `p_customer_address_id` INT, IN `p_customer_id` INT)   BEGIN
    DECLARE existing_address_count INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    DELETE FROM customer_address
    WHERE customer_address_id = p_customer_address_id;

    SELECT COUNT(*) INTO existing_address_count
    FROM customer_address
    WHERE customer_id = p_customer_id AND default_address = 'Primary';

    IF existing_address_count = 0 THEN
        UPDATE customer_address
        SET default_address = 'Primary'
        WHERE customer_id = p_customer_id
        AND default_address = 'Alternate'
        LIMIT 1;
    END IF;   

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteCustomerBankAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCustomerBankAccount` (IN `p_customer_bank_account_id` INT)   BEGIN
   DELETE FROM customer_bank_account WHERE customer_bank_account_id = p_customer_bank_account_id;
END$$

DROP PROCEDURE IF EXISTS `deleteCustomerBankCard`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCustomerBankCard` (IN `p_customer_bank_card_id` INT)   BEGIN
    DECLARE existing_bank_card_count INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    DELETE FROM customer_bank_card
    WHERE customer_bank_card_id = p_customer_bank_card_id;

    SELECT COUNT(*) INTO existing_bank_card_count
    FROM customer_bank_card
    WHERE customer_id = p_customer_id AND default_address = 'Primary';

    IF existing_bank_card_count = 0 THEN
        UPDATE customer_bank_card
        SET default_address = 'Primary'
        WHERE customer_id = p_customer_id
        AND default_address = 'Alternate'
        LIMIT 1;
    END IF;   

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteCustomerIDRecord`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCustomerIDRecord` (IN `p_customer_id_record_id` INT)   BEGIN
   DELETE FROM customer_id_record WHERE customer_id_record_id = p_customer_id_record_id;
END$$

DROP PROCEDURE IF EXISTS `deleteCustomerInquiry`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteCustomerInquiry` (IN `p_customer_inquiry_id` INT)   BEGIN
    DELETE FROM customer_inquiry WHERE customer_inquiry_id = p_customer_inquiry_id;
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

DROP PROCEDURE IF EXISTS `deleteEmployeeAddress`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteEmployeeAddress` (IN `p_employee_address_id` INT, IN `p_employee_id` INT)   BEGIN

    DECLARE existing_address_count INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    DELETE FROM employee_address
    WHERE employee_address_id = p_employee_address_id;

    SELECT COUNT(*) INTO existing_address_count
    FROM employee_address
    WHERE employee_id = p_employee_id AND default_address = 'Primary';

    IF existing_address_count = 0 THEN
        UPDATE employee_address
        SET default_address = 'Primary'
        WHERE employee_id = p_employee_id
        AND default_address = 'Alternate'
        LIMIT 1;
    END IF;   

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteEmployeeBankAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteEmployeeBankAccount` (IN `p_employee_bank_account_id` INT)   BEGIN
   DELETE FROM employee_bank_account WHERE employee_bank_account_id = p_employee_bank_account_id;
END$$

DROP PROCEDURE IF EXISTS `deleteEmployeeEducation`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteEmployeeEducation` (IN `p_employee_education_id` INT)   BEGIN
   DELETE FROM employee_education WHERE employee_education_id = p_employee_education_id;
END$$

DROP PROCEDURE IF EXISTS `deleteEmployeeEmergencyContact`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteEmployeeEmergencyContact` (IN `p_employee_emergency_contact_id` INT)   BEGIN
   DELETE FROM employee_emergency_contact WHERE employee_emergency_contact_id = p_employee_emergency_contact_id;
END$$

DROP PROCEDURE IF EXISTS `deleteEmployeeExperience`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteEmployeeExperience` (IN `p_employee_experience_id` INT)   BEGIN
   DELETE FROM employee_experience WHERE employee_experience_id = p_employee_experience_id;
END$$

DROP PROCEDURE IF EXISTS `deleteEmployeeIDRecord`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteEmployeeIDRecord` (IN `p_employee_id_record_id` INT)   BEGIN
   DELETE FROM employee_id_record WHERE employee_id_record_id = p_employee_id_record_id;
END$$

DROP PROCEDURE IF EXISTS `deleteEmployeeLanguage`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteEmployeeLanguage` (IN `p_employee_language_id` INT)   BEGIN
   DELETE FROM employee_language WHERE employee_language_id = p_employee_language_id;
END$$

DROP PROCEDURE IF EXISTS `deleteEmployeeLicense`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteEmployeeLicense` (IN `p_employee_license_id` INT)   BEGIN
   DELETE FROM employee_license WHERE employee_license_id = p_employee_license_id;
END$$

DROP PROCEDURE IF EXISTS `deleteEmploymentLocationType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteEmploymentLocationType` (IN `p_employment_location_type_id` INT)   BEGIN
    DELETE FROM employment_location_type WHERE employment_location_type_id = p_employment_location_type_id;
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

DROP PROCEDURE IF EXISTS `deleteFooter`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteFooter` (IN `p_footer_id` INT)   BEGIN
    DELETE FROM footer WHERE footer_id = p_footer_id;
END$$

DROP PROCEDURE IF EXISTS `deleteGender`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteGender` (IN `p_gender_id` INT)   BEGIN
    DELETE FROM gender WHERE gender_id = p_gender_id;
END$$

DROP PROCEDURE IF EXISTS `deleteHeader`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteHeader` (IN `p_header_id` INT)   BEGIN
    DELETE FROM header WHERE header_id = p_header_id;
END$$

DROP PROCEDURE IF EXISTS `deleteIDType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteIDType` (IN `p_id_type_id` INT)   BEGIN
    DELETE FROM id_type WHERE id_type_id = p_id_type_id;
END$$

DROP PROCEDURE IF EXISTS `deleteImageGallery`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteImageGallery` (IN `p_image_gallery_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM image_gallery_item WHERE image_gallery_id = p_image_gallery_id;
    DELETE FROM image_gallery WHERE image_gallery_id = p_image_gallery_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteImageGalleryItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteImageGalleryItem` (IN `p_image_gallery_item_id` INT)   BEGIN
   DELETE FROM image_gallery_item WHERE image_gallery_item_id = p_image_gallery_item_id;
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

DROP PROCEDURE IF EXISTS `deletePageTitle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deletePageTitle` (IN `p_page_title_id` INT)   BEGIN
    DELETE FROM page_title WHERE page_title_id = p_page_title_id;
END$$

DROP PROCEDURE IF EXISTS `deletePricingTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deletePricingTable` (IN `p_pricing_table_id` INT)   BEGIN
    DELETE FROM pricing_table WHERE pricing_table_id = p_pricing_table_id;
END$$

DROP PROCEDURE IF EXISTS `deleteProcesStep`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteProcesStep` (IN `p_process_step_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM process_step_item WHERE process_step_id = p_process_step_id;
    DELETE FROM process_step WHERE process_step_id = p_process_step_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteProcesStepItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteProcesStepItem` (IN `p_process_step_item_id` INT)   BEGIN
   DELETE FROM process_step_item WHERE process_step_item_id = p_process_step_item_id;
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

DROP PROCEDURE IF EXISTS `deleteSections`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteSections` (IN `p_sections_id` INT)   BEGIN
    DELETE FROM sections WHERE sections_id = p_sections_id;
END$$

DROP PROCEDURE IF EXISTS `deleteServicesBox`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteServicesBox` (IN `p_services_box_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM services_box_item WHERE services_box_id = p_services_box_id;
    DELETE FROM services_box WHERE services_box_id = p_services_box_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteServicesBoxItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteServicesBoxItem` (IN `p_services_box_item_id` INT)   BEGIN
   DELETE FROM services_box_item WHERE services_box_item_id = p_services_box_item_id;
END$$

DROP PROCEDURE IF EXISTS `deleteSlider`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteSlider` (IN `p_slider_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM slider_item WHERE slider_id = p_slider_id;
    DELETE FROM slider WHERE slider_id = p_slider_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteSliderItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteSliderItem` (IN `p_slider_item_id` INT)   BEGIN
   DELETE FROM slider_item WHERE slider_item_id = p_slider_item_id;
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

DROP PROCEDURE IF EXISTS `deleteTestimonial`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteTestimonial` (IN `p_testimonial_id` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM testimonial_item WHERE testimonial_id = p_testimonial_id;
    DELETE FROM testimonial WHERE testimonial_id = p_testimonial_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `deleteTestimonialItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteTestimonialItem` (IN `p_testimonial_item_id` INT)   BEGIN
   DELETE FROM testimonial_item WHERE testimonial_item_id = p_testimonial_item_id;
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

DROP PROCEDURE IF EXISTS `deleteVoucher`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteVoucher` (IN `p_voucher_id` INT)   BEGIN
    DELETE FROM voucher WHERE voucher_id = p_voucher_id;
END$$

DROP PROCEDURE IF EXISTS `deleteWebsite`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `deleteWebsite` (IN `p_website_id` INT)   BEGIN
    DELETE FROM website WHERE website_id = p_website_id;
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

DROP PROCEDURE IF EXISTS `generateAccordionItemTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateAccordionItemTable` (IN `p_accordion_id` INT)   BEGIN
    SELECT accordion_item_id, accordion_header, accordion_body, order_sequence 
    FROM accordion_item
    WHERE accordion_id = p_accordion_id;
END$$

DROP PROCEDURE IF EXISTS `generateAccordionTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateAccordionTable` ()   BEGIN
    SELECT accordion_id, accordion_name, description, publish_status
    FROM accordion;
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

DROP PROCEDURE IF EXISTS `generateApprovedSalesProposalTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateApprovedSalesProposalTable` ()   BEGIN
   SELECT * FROM sales_proposal WHERE sales_proposal_status IN ('Proceed', 'On-Process', 'Ready For Release', 'For DR') AND product_type NOT IN ('Refinancing', 'Parts', 'Brand New');
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

DROP PROCEDURE IF EXISTS `generateBlockStyleOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateBlockStyleOptions` (IN `p_block_type_id` INT)   BEGIN
	SELECT block_style_id, block_style_name 
    FROM block_style
    WHERE block_type_id = p_block_type_id
    ORDER BY block_style_name;
END$$

DROP PROCEDURE IF EXISTS `generateBlockStyleTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateBlockStyleTable` ()   BEGIN
	SELECT block_style_id, block_style_name, description, block_type_name
    FROM block_style 
    ORDER BY block_style_id;
END$$

DROP PROCEDURE IF EXISTS `generateBlockTypeOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateBlockTypeOptions` ()   BEGIN
	SELECT block_type_id, block_type_name 
    FROM block_type 
    ORDER BY block_type_name;
END$$

DROP PROCEDURE IF EXISTS `generateBlockTypeTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateBlockTypeTable` ()   BEGIN
	SELECT block_type_id, block_type_name 
    FROM block_type 
    ORDER BY block_type_id;
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

DROP PROCEDURE IF EXISTS `generateBookingCancellationTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateBookingCancellationTable` (IN `p_service` VARCHAR(100), IN `p_payment_status` VARCHAR(100), IN `p_mode_of_payment` VARCHAR(500), IN `p_source_of_booking` VARCHAR(50), IN `p_booking_start_date` DATE, IN `p_booking_end_date` DATE, IN `p_payment_start_date` DATE, IN `p_payment_end_date` DATE, IN `p_transaction_start_date` DATE, IN `p_transaction_end_date` DATE)   BEGIN
     DECLARE query VARCHAR(5000);
    DECLARE conditionList VARCHAR(1000);

    SET query = 'SELECT * FROM booking';
    SET conditionList = ' WHERE booking_status = "For Cancellation"';

    IF p_service IS NOT NULL AND p_service <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND service = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_service));
    END IF;

    IF p_payment_status IS NOT NULL AND p_payment_status <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND payment_status = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_payment_status));
    END IF;

    IF p_mode_of_payment IS NOT NULL AND p_mode_of_payment <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND mode_of_payment = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_mode_of_payment));
    END IF;

    IF p_source_of_booking IS NOT NULL AND p_source_of_booking <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND source_of_booking = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_source_of_booking));
    END IF;
    
    IF p_booking_start_date IS NOT NULL AND p_booking_end_date IS NOT NULL THEN
        SET conditionList = CONCAT(conditionList, ' AND (booking_date BETWEEN ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_booking_start_date));
        SET conditionList = CONCAT(conditionList, ' AND ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_booking_end_date));
        SET conditionList = CONCAT(conditionList, ')');
    END IF;
    
    IF p_payment_start_date IS NOT NULL AND p_payment_end_date IS NOT NULL THEN
        SET conditionList = CONCAT(conditionList, ' AND (payment_date BETWEEN ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_payment_start_date));
        SET conditionList = CONCAT(conditionList, ' AND ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_payment_end_date));
        SET conditionList = CONCAT(conditionList, ')');
    END IF;
    
    IF p_transaction_start_date IS NOT NULL AND p_transaction_end_date IS NOT NULL THEN
        SET conditionList = CONCAT(conditionList, ' AND (transaction_date BETWEEN ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_transaction_start_date));
        SET conditionList = CONCAT(conditionList, ' AND ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_transaction_end_date));
        SET conditionList = CONCAT(conditionList, ')');
    END IF;

    SET query = CONCAT(query, conditionList);
    SET query = CONCAT(query, ' ORDER BY booking_date DESC;');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS `generateBookingRefundTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateBookingRefundTable` (IN `p_service` VARCHAR(100), IN `p_booking_status` VARCHAR(100), IN `p_mode_of_payment` VARCHAR(500), IN `p_source_of_booking` VARCHAR(50), IN `p_booking_start_date` DATE, IN `p_booking_end_date` DATE, IN `p_payment_start_date` DATE, IN `p_payment_end_date` DATE, IN `p_transaction_start_date` DATE, IN `p_transaction_end_date` DATE)   BEGIN
     DECLARE query VARCHAR(5000);
    DECLARE conditionList VARCHAR(1000);

    SET query = 'SELECT * FROM booking';
    SET conditionList = ' WHERE payment_status = "For Refund"';

    IF p_service IS NOT NULL AND p_service <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND service = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_service));
    END IF;

    IF p_booking_status IS NOT NULL AND p_booking_status <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND booking_status = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_booking_status));
    END IF;

    IF p_mode_of_payment IS NOT NULL AND p_mode_of_payment <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND mode_of_payment = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_mode_of_payment));
    END IF;

    IF p_source_of_booking IS NOT NULL AND p_source_of_booking <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND source_of_booking = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_source_of_booking));
    END IF;
    
    IF p_booking_start_date IS NOT NULL AND p_booking_end_date IS NOT NULL THEN
        SET conditionList = CONCAT(conditionList, ' AND (booking_date BETWEEN ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_booking_start_date));
        SET conditionList = CONCAT(conditionList, ' AND ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_booking_end_date));
        SET conditionList = CONCAT(conditionList, ')');
    END IF;
    
    IF p_payment_start_date IS NOT NULL AND p_payment_end_date IS NOT NULL THEN
        SET conditionList = CONCAT(conditionList, ' AND (payment_date BETWEEN ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_payment_start_date));
        SET conditionList = CONCAT(conditionList, ' AND ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_payment_end_date));
        SET conditionList = CONCAT(conditionList, ')');
    END IF;
    
    IF p_transaction_start_date IS NOT NULL AND p_transaction_end_date IS NOT NULL THEN
        SET conditionList = CONCAT(conditionList, ' AND (transaction_date BETWEEN ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_transaction_start_date));
        SET conditionList = CONCAT(conditionList, ' AND ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_transaction_end_date));
        SET conditionList = CONCAT(conditionList, ')');
    END IF;

    SET query = CONCAT(query, conditionList);
    SET query = CONCAT(query, ' ORDER BY booking_date DESC;');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS `generateBookingTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateBookingTable` (IN `p_service` VARCHAR(100), IN `p_booking_status` VARCHAR(100), IN `p_payment_status` VARCHAR(100), IN `p_mode_of_payment` VARCHAR(500), IN `p_source_of_booking` VARCHAR(50), IN `p_booking_start_date` DATE, IN `p_booking_end_date` DATE, IN `p_payment_start_date` DATE, IN `p_payment_end_date` DATE, IN `p_transaction_start_date` DATE, IN `p_transaction_end_date` DATE)   BEGIN
     DECLARE query VARCHAR(5000);
    DECLARE conditionList VARCHAR(1000);

    SET query = 'SELECT * FROM booking';
    SET conditionList = ' WHERE 1';

    IF p_service IS NOT NULL AND p_service <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND service = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_service));
    END IF;

    IF p_booking_status IS NOT NULL AND p_booking_status <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND booking_status = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_booking_status));
    END IF;

    IF p_payment_status IS NOT NULL AND p_payment_status <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND payment_status = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_payment_status));
    END IF;

    IF p_mode_of_payment IS NOT NULL AND p_mode_of_payment <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND mode_of_payment = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_mode_of_payment));
    END IF;

    IF p_source_of_booking IS NOT NULL AND p_source_of_booking <> '' THEN
        SET conditionList = CONCAT(conditionList, ' AND source_of_booking = ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_source_of_booking));
    END IF;
    
    IF p_booking_start_date IS NOT NULL AND p_booking_end_date IS NOT NULL THEN
        SET conditionList = CONCAT(conditionList, ' AND (booking_date BETWEEN ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_booking_start_date));
        SET conditionList = CONCAT(conditionList, ' AND ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_booking_end_date));
        SET conditionList = CONCAT(conditionList, ')');
    END IF;
    
    IF p_payment_start_date IS NOT NULL AND p_payment_end_date IS NOT NULL THEN
        SET conditionList = CONCAT(conditionList, ' AND (payment_date BETWEEN ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_payment_start_date));
        SET conditionList = CONCAT(conditionList, ' AND ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_payment_end_date));
        SET conditionList = CONCAT(conditionList, ')');
    END IF;
    
    IF p_transaction_start_date IS NOT NULL AND p_transaction_end_date IS NOT NULL THEN
        SET conditionList = CONCAT(conditionList, ' AND (transaction_date BETWEEN ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_transaction_start_date));
        SET conditionList = CONCAT(conditionList, ' AND ');
        SET conditionList = CONCAT(conditionList, QUOTE(p_transaction_end_date));
        SET conditionList = CONCAT(conditionList, ')');
    END IF;

    SET query = CONCAT(query, conditionList);
    SET query = CONCAT(query, ' ORDER BY booking_date DESC;');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS `generateCallToActionTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateCallToActionTable` ()   BEGIN
    SELECT call_to_action_id, call_to_action_name, description, publish_status
    FROM call_to_action;
END$$

DROP PROCEDURE IF EXISTS `generateCarouselImageTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateCarouselImageTable` (IN `p_carousel_id` INT)   BEGIN
    SELECT carousel_image_id, carousel_image, order_sequence 
    FROM carousel_image
    WHERE carousel_id = p_carousel_id;
END$$

DROP PROCEDURE IF EXISTS `generateCarouselTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateCarouselTable` ()   BEGIN
    SELECT carousel_id, carousel_name, description, publish_status
    FROM carousel;
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

DROP PROCEDURE IF EXISTS `generateClientItemTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateClientItemTable` (IN `p_client_id` INT)   BEGIN
    SELECT client_item_id, client_logo, client_url, order_sequence 
    FROM client_item
    WHERE client_id = p_client_id;
END$$

DROP PROCEDURE IF EXISTS `generateClientTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateClientTable` ()   BEGIN
    SELECT client_id, client_name, description, publish_status
    FROM client;
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

DROP PROCEDURE IF EXISTS `generateContactFormTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateContactFormTable` ()   BEGIN
    SELECT contact_form_id, contact_form_name, description, publish_status
    FROM contact_form;
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

DROP PROCEDURE IF EXISTS `generateContentCarouselItemTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateContentCarouselItemTable` (IN `p_content_carousel_id` INT)   BEGIN
    SELECT content_carousel_item_id, content_carousel_title, content_carousel_heading, content_carousel_paragraph, call_to_action_button_1_text, call_to_action_button_1_link, call_to_action_button_2_text, call_to_action_button_2_link, content_carousel_image, order_sequence 
    FROM content_carousel_item
    WHERE content_carousel_id = p_content_carousel_id;
END$$

DROP PROCEDURE IF EXISTS `generateContentCarouselTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateContentCarouselTable` ()   BEGIN
    SELECT content_carousel_id, content_carousel_name, description, publish_status
    FROM content_carousel;
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

DROP PROCEDURE IF EXISTS `generateCustomerAddress`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateCustomerAddress` (IN `p_customer_id` INT)   BEGIN
	SELECT * FROM customer_address
	WHERE customer_id = p_customer_id
    ORDER BY default_address DESC;
END$$

DROP PROCEDURE IF EXISTS `generateCustomerBankAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateCustomerBankAccount` (IN `p_customer_id` INT)   BEGIN
	SELECT * FROM customer_bank_account
	WHERE customer_id = p_customer_id;
END$$

DROP PROCEDURE IF EXISTS `generateCustomerBankCard`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateCustomerBankCard` (IN `p_customer_id` INT)   BEGIN
	SELECT * FROM customer_bank_card
	WHERE customer_id = p_customer_id;
END$$

DROP PROCEDURE IF EXISTS `generateCustomerCard`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateCustomerCard` (IN `p_search_value` TEXT, IN `p_filter_by_customer_status` VARCHAR(50), IN `p_filter_by_gender` INT, IN `p_filter_by_civil_status` INT, IN `p_limit` INT, IN `p_offset` INT)   BEGIN
    DECLARE query TEXT;

    SET query = '
        SELECT customer_id, full_name, customer_status, customer_image
        FROM customer 
        WHERE 1=1';

    IF p_search_value IS NOT NULL AND p_search_value <> '' THEN
        SET query = CONCAT(query, ' AND (
            first_name LIKE ? OR
            middle_name LIKE ? OR
            last_name LIKE ? OR
            customer_status LIKE ?
        )');
    END IF;

    IF p_filter_by_customer_status IS NOT NULL AND p_filter_by_customer_status <> '' THEN
        SET query = CONCAT(query, ' AND customer_status =', QUOTE(p_filter_by_customer_status));
    END IF;

    IF p_filter_by_gender IS NOT NULL AND p_filter_by_gender <> '' THEN
        SET query = CONCAT(query, ' AND gender_id =', p_filter_by_gender);
    END IF;

    IF p_filter_by_civil_status IS NOT NULL AND p_filter_by_civil_status <> '' THEN
        SET query = CONCAT(query, ' AND civil_status_id =', p_filter_by_civil_status);
    END IF;

    SET query = CONCAT(query, ' ORDER BY full_name LIMIT ?, ?;');

    PREPARE stmt FROM query;
    IF p_search_value IS NOT NULL AND p_search_value <> '' THEN
        EXECUTE stmt USING CONCAT("%", p_search_value, "%"), CONCAT("%", p_search_value, "%"), CONCAT("%", p_search_value, "%"), CONCAT("%", p_search_value, "%"), p_offset, p_limit;
    ELSE
        EXECUTE stmt USING p_offset, p_limit;
    END IF;

    DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS `generateCustomerIDRecord`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateCustomerIDRecord` (IN `p_customer_id` INT)   BEGIN
	SELECT * FROM customer_id_record
	WHERE customer_id = p_customer_id;
END$$

DROP PROCEDURE IF EXISTS `generateCustomerInquiryTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateCustomerInquiryTable` ()   BEGIN
    SELECT customer_inquiry_id, customer_name, email, phone, subject, message, inquiry_status, created_date
    FROM customer_inquiry;
END$$

DROP PROCEDURE IF EXISTS `generateCustomerOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateCustomerOptions` (IN `p_customer_id` INT, IN `p_generation_type` VARCHAR(100))   BEGIN
    IF p_customer_id IS NOT NULL AND p_customer_id != '' THEN
        IF p_generation_type = 'Active' THEN
            SELECT customer_id, full_name 
            FROM customer 
            WHERE customer_id != p_customer_id
            AND customer_status = 'Active'
            ORDER BY full_name;
        ELSEIF p_generation_type = 'Archived' THEN
            SELECT customer_id, full_name 
            FROM customer 
            WHERE customer_id != p_customer_id
            AND customer_status = 'Archived'
            ORDER BY full_name;
        ELSE
            SELECT customer_id, full_name 
            FROM customer 
            WHERE customer_id != p_customer_id
            ORDER BY full_name;
        END IF;
    ELSE
        IF p_generation_type = 'Active' THEN
            SELECT customer_id, full_name 
            FROM customer 
            WHERE customer_status = 'Active'
            ORDER BY full_name;
        ELSEIF p_generation_type = 'Archived' THEN
            SELECT customer_id, full_name 
            FROM customer 
            WHERE customer_status = 'Archived'
            ORDER BY full_name;
        ELSE
            SELECT customer_id, full_name 
            FROM customer 
            ORDER BY full_name;
        END IF;
    END IF;
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

DROP PROCEDURE IF EXISTS `generateEmployeeAddress`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateEmployeeAddress` (IN `p_employee_id` INT)   BEGIN
	SELECT * FROM employee_address
	WHERE employee_id = p_employee_id
    ORDER BY default_address DESC;
END$$

DROP PROCEDURE IF EXISTS `generateEmployeeBankAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateEmployeeBankAccount` (IN `p_employee_id` INT)   BEGIN
	SELECT * FROM employee_bank_account
	WHERE employee_id = p_employee_id;
END$$

DROP PROCEDURE IF EXISTS `generateEmployeeCard`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateEmployeeCard` (IN `p_search_value` TEXT, IN `p_filter_by_company` INT, IN `p_filter_by_department` INT, IN `p_filter_by_job_position` INT, IN `p_filter_by_employee_status` VARCHAR(50), IN `p_filter_by_employment_type` INT, IN `p_filter_by_gender` INT, IN `p_filter_by_civil_status` INT, IN `p_limit` INT, IN `p_offset` INT)   BEGIN
    DECLARE query TEXT;

    SET query = '
        SELECT employee_id, full_name, department_name, job_position_name, employment_status, employee_image
        FROM employee 
        WHERE 1=1';

    IF p_search_value IS NOT NULL AND p_search_value <> '' THEN
        SET query = CONCAT(query, ' AND (
            first_name LIKE ? OR
            middle_name LIKE ? OR
            last_name LIKE ? OR
            department_name LIKE ? OR
            job_position_name LIKE ? OR
            employment_status LIKE ?
        )');
    END IF;

    IF p_filter_by_company IS NOT NULL AND p_filter_by_company <> '' THEN
        SET query = CONCAT(query, ' AND company_id =', p_filter_by_company);
    END IF;

    IF p_filter_by_department IS NOT NULL AND p_filter_by_department <> '' THEN
        SET query = CONCAT(query, ' AND department_id =', p_filter_by_department);
    END IF;

    IF p_filter_by_job_position IS NOT NULL AND p_filter_by_job_position <> '' THEN
        SET query = CONCAT(query, ' AND job_position_id =', p_filter_by_job_position);
    END IF;

    IF p_filter_by_employee_status IS NOT NULL AND p_filter_by_employee_status <> '' THEN
        SET query = CONCAT(query, ' AND employment_status =', QUOTE(p_filter_by_employee_status));
    END IF;

    IF p_filter_by_employment_type IS NOT NULL AND p_filter_by_employment_type <> '' THEN
        SET query = CONCAT(query, ' AND employment_type_id =', p_filter_by_employment_type);
    END IF;

    IF p_filter_by_gender IS NOT NULL AND p_filter_by_gender <> '' THEN
        SET query = CONCAT(query, ' AND gender_id =', p_filter_by_gender);
    END IF;

    IF p_filter_by_civil_status IS NOT NULL AND p_filter_by_civil_status <> '' THEN
        SET query = CONCAT(query, ' AND civil_status_id =', p_filter_by_civil_status);
    END IF;

    SET query = CONCAT(query, ' ORDER BY full_name LIMIT ?, ?;');

    PREPARE stmt FROM query;
    IF p_search_value IS NOT NULL AND p_search_value <> '' THEN
        EXECUTE stmt USING CONCAT("%", p_search_value, "%"), CONCAT("%", p_search_value, "%"), CONCAT("%", p_search_value, "%"), CONCAT("%", p_search_value, "%"), CONCAT("%", p_search_value, "%"), CONCAT("%", p_search_value, "%"), p_offset, p_limit;
    ELSE
        EXECUTE stmt USING p_offset, p_limit;
    END IF;

    DEALLOCATE PREPARE stmt;
END$$

DROP PROCEDURE IF EXISTS `generateEmployeeEducation`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateEmployeeEducation` (IN `p_employee_id` INT)   BEGIN
	SELECT * FROM employee_education
	WHERE employee_id = p_employee_id;
END$$

DROP PROCEDURE IF EXISTS `generateEmployeeEmergencyContact`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateEmployeeEmergencyContact` (IN `p_employee_id` INT)   BEGIN
	SELECT * FROM employee_emergency_contact
	WHERE employee_id = p_employee_id;
END$$

DROP PROCEDURE IF EXISTS `generateEmployeeExperience`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateEmployeeExperience` (IN `p_employee_id` INT)   BEGIN
	SELECT * FROM employee_experience
	WHERE employee_id = p_employee_id;
END$$

DROP PROCEDURE IF EXISTS `generateEmployeeIDRecord`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateEmployeeIDRecord` (IN `p_employee_id` INT)   BEGIN
	SELECT * FROM employee_id_record
	WHERE employee_id = p_employee_id;
END$$

DROP PROCEDURE IF EXISTS `generateEmployeeLanguage`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateEmployeeLanguage` (IN `p_employee_id` INT)   BEGIN
	SELECT * FROM employee_language
	WHERE employee_id = p_employee_id;
END$$

DROP PROCEDURE IF EXISTS `generateEmployeeLicense`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateEmployeeLicense` (IN `p_employee_id` INT)   BEGIN
	SELECT * FROM employee_license
	WHERE employee_id = p_employee_id;
END$$

DROP PROCEDURE IF EXISTS `generateEmployeeOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateEmployeeOptions` (IN `p_employee_id` INT, IN `p_generation_type` VARCHAR(100))   BEGIN
    IF p_employee_id IS NOT NULL AND p_employee_id != '' THEN
        IF p_generation_type = 'Active' THEN
            SELECT employee_id, full_name 
            FROM employee 
            WHERE employee_id != p_employee_id
            AND employment_status = 'Active'
            ORDER BY full_name;
        ELSEIF p_generation_type = 'Archived' THEN
            SELECT employee_id, full_name 
            FROM employee 
            WHERE employee_id != p_employee_id
            AND employment_status = 'Archived'
            ORDER BY full_name;
        ELSE
            SELECT employee_id, full_name 
            FROM employee 
            WHERE employee_id != p_employee_id
            ORDER BY full_name;
        END IF;
    ELSE
        IF p_generation_type = 'Active' THEN
            SELECT employee_id, full_name 
            FROM employee 
            WHERE employment_status = 'Active'
            ORDER BY full_name;
        ELSEIF p_generation_type = 'Archived' THEN
            SELECT employee_id, full_name 
            FROM employee 
            WHERE employment_status = 'Archived'
            ORDER BY full_name;
        ELSE
            SELECT employee_id, full_name 
            FROM employee 
            ORDER BY full_name;
        END IF;
    END IF;
END$$

DROP PROCEDURE IF EXISTS `generateEmploymentLocationTypeOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateEmploymentLocationTypeOptions` ()   BEGIN
	SELECT employment_location_type_id, employment_location_type_name 
    FROM employment_location_type 
    ORDER BY employment_location_type_name;
END$$

DROP PROCEDURE IF EXISTS `generateEmploymentLocationTypeTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateEmploymentLocationTypeTable` ()   BEGIN
	SELECT employment_location_type_id, employment_location_type_name 
    FROM employment_location_type 
    ORDER BY employment_location_type_id;
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

DROP PROCEDURE IF EXISTS `generateFooterTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateFooterTable` ()   BEGIN
    SELECT footer_id, footer_name, description, publish_status
    FROM footer;
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

DROP PROCEDURE IF EXISTS `generateHeaderTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateHeaderTable` ()   BEGIN
    SELECT header_id, header_name, description, publish_status
    FROM header;
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

DROP PROCEDURE IF EXISTS `generateImageGalleryItemTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateImageGalleryItemTable` (IN `p_image_gallery_id` INT)   BEGIN
    SELECT image_gallery_item_id, image_gallery_title, image_gallery_image, order_sequence 
    FROM image_gallery_item
    WHERE image_gallery_id = p_image_gallery_id;
END$$

DROP PROCEDURE IF EXISTS `generateImageGalleryTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateImageGalleryTable` ()   BEGIN
    SELECT image_gallery_id, image_gallery_name, description, publish_status
    FROM image_gallery;
END$$

DROP PROCEDURE IF EXISTS `generateIncomingSalesProposalTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateIncomingSalesProposalTable` ()   BEGIN
   SELECT * FROM sales_proposal WHERE sales_proposal_status IN ('Draft', 'For Review', 'For Initial Approval', 'For Final Approval') AND product_type NOT IN ('Refinancing', 'Fuel', 'Parts', 'Brand New');
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
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateMenuItemOptions` (IN `p_menu_item_id` INT)   BEGIN
    IF p_menu_item_id IS NOT NULL AND p_menu_item_id != '' THEN
        SELECT menu_item_id, menu_item_name 
        FROM menu_item 
        WHERE menu_item_id != p_menu_item_id
        ORDER BY menu_item_name;
    ELSE
        SELECT menu_item_id, menu_item_name 
        FROM menu_item 
        ORDER BY menu_item_name;
    END IF;
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

DROP PROCEDURE IF EXISTS `generatePageTitleTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generatePageTitleTable` ()   BEGIN
    SELECT page_title_id, page_title_name, description, page_title, page_heading, page_title_image, publish_status
    FROM page_title;
END$$

DROP PROCEDURE IF EXISTS `generatePricingTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generatePricingTable` ()   BEGIN
    SELECT pricing_table_id, pricing_table_name, description, publish_status
    FROM pricing_table;
END$$

DROP PROCEDURE IF EXISTS `generateProcesStepItemTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateProcesStepItemTable` (IN `p_process_step_id` INT)   BEGIN
    SELECT process_step_item_id, process_step_title, process_step_heading, process_step_link, process_step_image, order_sequence 
    FROM process_step_item
    WHERE process_step_id = p_process_step_id;
END$$

DROP PROCEDURE IF EXISTS `generateProcesStepTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateProcesStepTable` ()   BEGIN
    SELECT process_step_id, process_step_name, description, publish_status
    FROM process_step;
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

DROP PROCEDURE IF EXISTS `generateReleasedSalesProposalTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateReleasedSalesProposalTable` ()   BEGIN
   SELECT * FROM sales_proposal WHERE sales_proposal_status IN ('Released') AND product_type NOT IN ('Refinancing', 'Parts', 'Brand New');
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

DROP PROCEDURE IF EXISTS `generateSectionsTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateSectionsTable` ()   BEGIN
    SELECT sections_id, sections_name, description, publish_status
    FROM sections;
END$$

DROP PROCEDURE IF EXISTS `generateServicesBoxItemTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateServicesBoxItemTable` (IN `p_services_box_id` INT)   BEGIN
    SELECT services_box_item_id, services_box_title, services_box_heading, services_box_paragraph, call_to_action_button_text, call_to_action_button_link, services_box_image, order_sequence 
    FROM services_box_item
    WHERE services_box_id = p_services_box_id;
END$$

DROP PROCEDURE IF EXISTS `generateServicesBoxTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateServicesBoxTable` ()   BEGIN
    SELECT services_box_id, services_box_name, description, publish_status
    FROM services_box;
END$$

DROP PROCEDURE IF EXISTS `generateSliderItemTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateSliderItemTable` (IN `p_slider_id` INT)   BEGIN
    SELECT slider_item_id, slider_title, slider_heading, slider_paragraph, call_to_action_button_1_text, call_to_action_button_1_link, call_to_action_button_2_text, call_to_action_button_2_link, slider_image, order_sequence 
    FROM slider_item
    WHERE slider_id = p_slider_id;
END$$

DROP PROCEDURE IF EXISTS `generateSliderTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateSliderTable` ()   BEGIN
    SELECT slider_id, slider_name, description, publish_status

    FROM slider;
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

DROP PROCEDURE IF EXISTS `generateTestimonialItemTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateTestimonialItemTable` (IN `p_testimonial_id` INT)   BEGIN
    SELECT testimonial_item_id, testimonial_client, testimonial_title, testimonial_paragraph, rating, testimonial_image, order_sequence 
    FROM testimonial_item
    WHERE testimonial_id = p_testimonial_id;
END$$

DROP PROCEDURE IF EXISTS `generateTestimonialTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateTestimonialTable` ()   BEGIN
    SELECT testimonial_id, testimonial_name, description, publish_status
    FROM testimonial;
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

DROP PROCEDURE IF EXISTS `generateUserAccountOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateUserAccountOptions` (IN `p_generation_type` VARCHAR(20))   BEGIN
	IF p_generation_type = 'Active' THEN
        SELECT user_account_id, file_as 
        FROM user_account 
        WHERE active = 'Yes'
        ORDER BY file_as;
    ELSEIF p_generation_type = 'Deactivated' THEN
       SELECT user_account_id, file_as 
        FROM user_account 
        WHERE active = 'No'
        ORDER BY file_as;
    ELSE
        SELECT user_account_id, file_as 
        FROM user_account
        ORDER BY file_as;
    END IF;
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

DROP PROCEDURE IF EXISTS `generateVoucherTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateVoucherTable` ()   BEGIN
    SELECT voucher_id, voucher_name, voucher_code, voucher_usage_start_date, voucher_usage_end_date, discount_type, discount_amount, minimum_booking_amount, voucher_quantity, available_voucher
    FROM voucher;
END$$

DROP PROCEDURE IF EXISTS `generateWebsiteOptions`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateWebsiteOptions` ()   BEGIN
	SELECT website_id, website_name 
    FROM website 
    ORDER BY website_name;
END$$

DROP PROCEDURE IF EXISTS `generateWebsiteTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `generateWebsiteTable` ()   BEGIN
	SELECT website_id, website_name, description, url
    FROM website 
    ORDER BY website_id;
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

DROP PROCEDURE IF EXISTS `getAccordion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAccordion` (IN `p_accordion_id` INT)   BEGIN
	SELECT * FROM accordion
	WHERE accordion_id = p_accordion_id;
END$$

DROP PROCEDURE IF EXISTS `getAccordionItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getAccordionItem` (IN `p_accordion_item_id` INT)   BEGIN
	SELECT * FROM accordion_item
	WHERE accordion_item_id = p_accordion_item_id;
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

DROP PROCEDURE IF EXISTS `getBlockContainer`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getBlockContainer` (IN `p_block_style_id` INT)   BEGIN
	SELECT * FROM block_container
	WHERE block_style_id = p_block_style_id;
END$$

DROP PROCEDURE IF EXISTS `getBlockItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getBlockItem` (IN `p_block_style_id` INT)   BEGIN
	SELECT * FROM block_item
	WHERE block_style_id = p_block_style_id;
END$$

DROP PROCEDURE IF EXISTS `getBlockStyle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getBlockStyle` (IN `p_block_style_id` INT)   BEGIN
	SELECT * FROM block_style
	WHERE block_style_id = p_block_style_id;
END$$

DROP PROCEDURE IF EXISTS `getBlockType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getBlockType` (IN `p_block_type_id` INT)   BEGIN
	SELECT * FROM block_type
	WHERE block_type_id = p_block_type_id;
END$$

DROP PROCEDURE IF EXISTS `getBloodType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getBloodType` (IN `p_blood_type_id` INT)   BEGIN
	SELECT * FROM blood_type
	WHERE blood_type_id = p_blood_type_id;
END$$

DROP PROCEDURE IF EXISTS `getBooking`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getBooking` (IN `p_booking_id` INT)   BEGIN
	SELECT * FROM booking
	WHERE booking_id = p_booking_id;
END$$

DROP PROCEDURE IF EXISTS `getCallToAction`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCallToAction` (IN `p_call_to_action_id` INT)   BEGIN
	SELECT * FROM call_to_action
	WHERE call_to_action_id = p_call_to_action_id;
END$$

DROP PROCEDURE IF EXISTS `getCarousel`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCarousel` (IN `p_carousel_id` INT)   BEGIN
	SELECT * FROM carousel
	WHERE carousel_id = p_carousel_id;
END$$

DROP PROCEDURE IF EXISTS `getCarouselImage`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCarouselImage` (IN `p_carousel_image_id` INT)   BEGIN
	SELECT * FROM carousel_image
	WHERE carousel_image_id = p_carousel_image_id;
END$$

DROP PROCEDURE IF EXISTS `getCarouselImageByCarouselID`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCarouselImageByCarouselID` (IN `p_carousel_id` INT)   BEGIN
	SELECT * FROM carousel_image
	WHERE carousel_id = p_carousel_id;
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

DROP PROCEDURE IF EXISTS `getClient`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getClient` (IN `p_client_id` INT)   BEGIN
	SELECT * FROM client
	WHERE client_id = p_client_id;
END$$

DROP PROCEDURE IF EXISTS `getClientItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getClientItem` (IN `p_client_item_id` INT)   BEGIN
	SELECT * FROM client_item
	WHERE client_item_id = p_client_item_id;
END$$

DROP PROCEDURE IF EXISTS `getClientItemByClientID`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getClientItemByClientID` (IN `p_client_id` INT)   BEGIN
	SELECT * FROM client_item
	WHERE client_id = p_client_id
    ORDER BY order_sequence;
END$$

DROP PROCEDURE IF EXISTS `getCompany`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCompany` (IN `p_company_id` INT)   BEGIN
	SELECT * FROM company
	WHERE company_id = p_company_id;
END$$

DROP PROCEDURE IF EXISTS `getContactForm`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getContactForm` (IN `p_contact_form_id` INT)   BEGIN
	SELECT * FROM contact_form
	WHERE contact_form_id = p_contact_form_id;
END$$

DROP PROCEDURE IF EXISTS `getContactInformationType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getContactInformationType` (IN `p_contact_information_type_id` INT)   BEGIN
	SELECT * FROM contact_information_type
	WHERE contact_information_type_id = p_contact_information_type_id;
END$$

DROP PROCEDURE IF EXISTS `getContentCarousel`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getContentCarousel` (IN `p_content_carousel_id` INT)   BEGIN
	SELECT * FROM content_carousel
	WHERE content_carousel_id = p_content_carousel_id;
END$$

DROP PROCEDURE IF EXISTS `getContentCarouselItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getContentCarouselItem` (IN `p_content_carousel_item_id` INT)   BEGIN
	SELECT * FROM content_carousel_item
	WHERE content_carousel_item_id = p_content_carousel_item_id;
END$$

DROP PROCEDURE IF EXISTS `getContentCarouselItemByContentCarouselID`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getContentCarouselItemByContentCarouselID` (IN `p_content_carousel_id` INT)   BEGIN
	SELECT * FROM content_carousel_item
	WHERE content_carousel_id = p_content_carousel_id;
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

DROP PROCEDURE IF EXISTS `getCustomer`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCustomer` (IN `p_customer_id` INT)   BEGIN
	SELECT * FROM customer
	WHERE customer_id = p_customer_id;
END$$

DROP PROCEDURE IF EXISTS `getCustomerAddress`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCustomerAddress` (IN `p_customer_address_id` INT)   BEGIN
	SELECT * FROM customer_address
	WHERE customer_address_id = p_customer_address_id;
END$$

DROP PROCEDURE IF EXISTS `getCustomerBankAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCustomerBankAccount` (IN `p_customer_bank_account_id` INT)   BEGIN
	SELECT * FROM customer_bank_account
	WHERE customer_bank_account_id = p_customer_bank_account_id;
END$$

DROP PROCEDURE IF EXISTS `getCustomerBankCard`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCustomerBankCard` (IN `p_customer_bank_card_id` INT)   BEGIN
	SELECT * FROM customer_bank_card
	WHERE customer_bank_card_id = p_customer_bank_card_id;
END$$

DROP PROCEDURE IF EXISTS `getCustomerIDRecord`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCustomerIDRecord` (IN `p_customer_id_record_id` INT)   BEGIN
	SELECT * FROM customer_id_record
	WHERE customer_id_record_id = p_customer_id_record_id;
END$$

DROP PROCEDURE IF EXISTS `getCustomerInquiry`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getCustomerInquiry` (IN `p_customer_inquiry_id` INT)   BEGIN
	SELECT * FROM customer_inquiry
	WHERE customer_inquiry_id = p_customer_inquiry_id;
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

DROP PROCEDURE IF EXISTS `getEmployee`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getEmployee` (IN `p_employee_id` INT)   BEGIN
	SELECT * FROM employee
	WHERE employee_id = p_employee_id;
END$$

DROP PROCEDURE IF EXISTS `getEmployeeAddress`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getEmployeeAddress` (IN `p_employee_address_id` INT)   BEGIN
	SELECT * FROM employee_address
	WHERE employee_address_id = p_employee_address_id;
END$$

DROP PROCEDURE IF EXISTS `getEmployeeBankAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getEmployeeBankAccount` (IN `p_employee_bank_account_id` INT)   BEGIN
	SELECT * FROM employee_bank_account
	WHERE employee_bank_account_id = p_employee_bank_account_id;
END$$

DROP PROCEDURE IF EXISTS `getEmployeeEducation`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getEmployeeEducation` (IN `p_employee_education_id` INT)   BEGIN
	SELECT * FROM employee_education
	WHERE employee_education_id = p_employee_education_id;
END$$

DROP PROCEDURE IF EXISTS `getEmployeeEmergencyContact`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getEmployeeEmergencyContact` (IN `p_employee_emergency_contact_id` INT)   BEGIN
	SELECT * FROM employee_emergency_contact
	WHERE employee_emergency_contact_id = p_employee_emergency_contact_id;
END$$

DROP PROCEDURE IF EXISTS `getEmployeeExperience`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getEmployeeExperience` (IN `p_employee_experience_id` INT)   BEGIN
	SELECT * FROM employee_experience
	WHERE employee_experience_id = p_employee_experience_id;
END$$

DROP PROCEDURE IF EXISTS `getEmployeeIDRecord`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getEmployeeIDRecord` (IN `p_employee_id_record_id` INT)   BEGIN
	SELECT * FROM employee_id_record
	WHERE employee_id_record_id = p_employee_id_record_id;
END$$

DROP PROCEDURE IF EXISTS `getEmployeeLanguage`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getEmployeeLanguage` (IN `p_employee_language_id` INT)   BEGIN
	SELECT * FROM employee_language
	WHERE employee_language_id = p_employee_language_id;
END$$

DROP PROCEDURE IF EXISTS `getEmployeeLicense`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getEmployeeLicense` (IN `p_employee_license_id` INT)   BEGIN
	SELECT * FROM employee_license
	WHERE employee_license_id = p_employee_license_id;
END$$

DROP PROCEDURE IF EXISTS `getEmploymentLocationType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getEmploymentLocationType` (IN `p_employment_location_type_id` INT)   BEGIN
	SELECT * FROM employment_location_type
	WHERE employment_location_type_id = p_employment_location_type_id;
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

DROP PROCEDURE IF EXISTS `getFooter`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getFooter` (IN `p_footer_id` INT)   BEGIN
	SELECT * FROM footer
	WHERE footer_id = p_footer_id;
END$$

DROP PROCEDURE IF EXISTS `getGender`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getGender` (IN `p_gender_id` INT)   BEGIN
	SELECT * FROM gender
	WHERE gender_id = p_gender_id;
END$$

DROP PROCEDURE IF EXISTS `getHeader`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getHeader` (IN `p_header_id` INT)   BEGIN
	SELECT * FROM header
	WHERE header_id = p_header_id;
END$$

DROP PROCEDURE IF EXISTS `getIDType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getIDType` (IN `p_id_type_id` INT)   BEGIN
	SELECT * FROM id_type
	WHERE id_type_id = p_id_type_id;
END$$

DROP PROCEDURE IF EXISTS `getImageGallery`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getImageGallery` (IN `p_image_gallery_id` INT)   BEGIN
	SELECT * FROM image_gallery
	WHERE image_gallery_id = p_image_gallery_id;
END$$

DROP PROCEDURE IF EXISTS `getImageGalleryItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getImageGalleryItem` (IN `p_image_gallery_item_id` INT)   BEGIN
	SELECT * FROM image_gallery_item
	WHERE image_gallery_item_id = p_image_gallery_item_id;
END$$

DROP PROCEDURE IF EXISTS `getImageGalleryItemByImageGalleryID`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getImageGalleryItemByImageGalleryID` (IN `p_image_gallery_id` INT)   BEGIN
	SELECT * FROM image_gallery_item
	WHERE image_gallery_id = p_image_gallery_id;
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

DROP PROCEDURE IF EXISTS `getPageTitle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getPageTitle` (IN `p_page_title_id` INT)   BEGIN
	SELECT * FROM page_title
	WHERE page_title_id = p_page_title_id;
END$$

DROP PROCEDURE IF EXISTS `getPasswordHistory`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getPasswordHistory` (IN `p_user_account_id` INT)   BEGIN
	SELECT * FROM password_history
	WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `getPricingTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getPricingTable` (IN `p_pricing_table_id` INT)   BEGIN
	SELECT * FROM pricing_table
	WHERE pricing_table_id = p_pricing_table_id;
END$$

DROP PROCEDURE IF EXISTS `getProcesStep`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getProcesStep` (IN `p_process_step_id` INT)   BEGIN
	SELECT * FROM process_step
	WHERE process_step_id = p_process_step_id;
END$$

DROP PROCEDURE IF EXISTS `getProcesStepItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getProcesStepItem` (IN `p_process_step_item_id` INT)   BEGIN
	SELECT * FROM process_step_item
	WHERE process_step_item_id = p_process_step_item_id;
END$$

DROP PROCEDURE IF EXISTS `getProcesStepItemByProcesStepID`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getProcesStepItemByProcesStepID` (IN `p_process_step_id` INT)   BEGIN
	SELECT * FROM process_step_item
	WHERE process_step_id = p_process_step_id;
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

DROP PROCEDURE IF EXISTS `getSections`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getSections` (IN `p_sections_id` INT)   BEGIN
	SELECT * FROM sections
	WHERE sections_id = p_sections_id;
END$$

DROP PROCEDURE IF EXISTS `getSecuritySetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getSecuritySetting` (IN `p_security_setting_id` INT)   BEGIN
	SELECT * FROM security_setting
	WHERE security_setting_id = p_security_setting_id;
END$$

DROP PROCEDURE IF EXISTS `getServicesBox`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getServicesBox` (IN `p_services_box_id` INT)   BEGIN
	SELECT * FROM services_box
	WHERE services_box_id = p_services_box_id;
END$$

DROP PROCEDURE IF EXISTS `getServicesBoxItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getServicesBoxItem` (IN `p_services_box_item_id` INT)   BEGIN
	SELECT * FROM services_box_item
	WHERE services_box_item_id = p_services_box_item_id;
END$$

DROP PROCEDURE IF EXISTS `getServicesBoxItemByServicesBoxID`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getServicesBoxItemByServicesBoxID` (IN `p_services_box_id` INT)   BEGIN
	SELECT * FROM services_box_item
	WHERE services_box_id = p_services_box_id
    ORDER BY order_sequence;
END$$

DROP PROCEDURE IF EXISTS `getSlider`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getSlider` (IN `p_slider_id` INT)   BEGIN
	SELECT * FROM slider
	WHERE slider_id = p_slider_id;
END$$

DROP PROCEDURE IF EXISTS `getSliderItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getSliderItem` (IN `p_slider_item_id` INT)   BEGIN
	SELECT * FROM slider_item
	WHERE slider_item_id = p_slider_item_id;
END$$

DROP PROCEDURE IF EXISTS `getSliderItemBySliderID`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getSliderItemBySliderID` (IN `p_slider_id` INT)   BEGIN
	SELECT * FROM slider_item
	WHERE slider_id = p_slider_id
    ORDER BY order_sequence;
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

DROP PROCEDURE IF EXISTS `getSystemSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getSystemSetting` (IN `p_system_setting_id` INT)   BEGIN
	SELECT * FROM system_setting
	WHERE system_setting_id = p_system_setting_id;
END$$

DROP PROCEDURE IF EXISTS `getTestimonial`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getTestimonial` (IN `p_testimonial_id` INT)   BEGIN
	SELECT * FROM testimonial
	WHERE testimonial_id = p_testimonial_id;
END$$

DROP PROCEDURE IF EXISTS `getTestimonialItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getTestimonialItem` (IN `p_testimonial_item_id` INT)   BEGIN
	SELECT * FROM testimonial_item
	WHERE testimonial_item_id = p_testimonial_item_id;

END$$

DROP PROCEDURE IF EXISTS `getTestimonialItemByTestimonialID`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getTestimonialItemByTestimonialID` (IN `p_testimonial_id` INT)   BEGIN
	SELECT * FROM testimonial_item
	WHERE testimonial_id = p_testimonial_id
    ORDER BY order_sequence;
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

DROP PROCEDURE IF EXISTS `getVoucher`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getVoucher` (IN `p_voucher_id` INT)   BEGIN
	SELECT * FROM voucher
	WHERE voucher_id = p_voucher_id;
END$$

DROP PROCEDURE IF EXISTS `getVoucherCode`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getVoucherCode` (IN `p_voucher_code` VARCHAR(20))   BEGIN
	SELECT * FROM voucher
	WHERE voucher_code = p_voucher_code;
END$$

DROP PROCEDURE IF EXISTS `getWebsite`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `getWebsite` (IN `p_website_id` INT)   BEGIN
	SELECT * FROM website
	WHERE website_id = p_website_id;
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

DROP PROCEDURE IF EXISTS `insertAccordion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertAccordion` (IN `p_accordion_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_accordion_id` INT)   BEGIN
    INSERT INTO accordion (accordion_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_accordion_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_accordion_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertAccordionItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertAccordionItem` (IN `p_accordion_id` INT, IN `p_accordion_header` VARCHAR(500), IN `p_accordion_body` LONGTEXT, IN `p_order_sequence` INT, IN `p_last_log_by` INT)   BEGIN
    INSERT INTO accordion_item (accordion_id, accordion_header, accordion_body, order_sequence, last_log_by) 
	VALUES(p_accordion_id, p_accordion_header, p_accordion_body, p_order_sequence, p_last_log_by);
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

DROP PROCEDURE IF EXISTS `insertBlockContainer`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertBlockContainer` (IN `p_block_style_id` INT, IN `p_block_container` LONGTEXT, IN `p_last_log_by` INT)   BEGIN
    INSERT INTO block_container (block_style_id, block_container, last_log_by) 
	VALUES(p_block_style_id, p_block_container, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertBlockItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertBlockItem` (IN `p_block_style_id` INT, IN `p_block_item` LONGTEXT, IN `p_last_log_by` INT)   BEGIN
    INSERT INTO block_item (block_style_id, block_item, last_log_by) 
	VALUES(p_block_style_id, p_block_item, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertBlockStyle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertBlockStyle` (IN `p_block_style_name` VARCHAR(100), IN `p_description` VARCHAR(500), IN `p_block_type_id` INT, IN `p_block_type_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_block_style_id` INT)   BEGIN
    INSERT INTO block_style (block_style_name, description, block_type_id, block_type_name, last_log_by) 
	VALUES(p_block_style_name, p_description, p_block_type_id, p_block_type_name, p_last_log_by);
	
    SET p_block_style_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertBlockType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertBlockType` (IN `p_block_type_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_block_type_id` INT)   BEGIN
    INSERT INTO block_type (block_type_name, last_log_by) 
	VALUES(p_block_type_name, p_last_log_by);
	
    SET p_block_type_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertBloodType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertBloodType` (IN `p_blood_type_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_blood_type_id` INT)   BEGIN
    INSERT INTO blood_type (blood_type_name, last_log_by) 
	VALUES(p_blood_type_name, p_last_log_by);
	
    SET p_blood_type_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertBooking`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertBooking` (IN `p_booking_reference_number` VARCHAR(100), IN `p_source_of_booking` VARCHAR(50), IN `p_service` VARCHAR(100), IN `p_frequency` VARCHAR(50), IN `p_duration` INT, IN `p_number_of_seats` INT, IN `p_meters` INT, IN `p_cleaning_materials` VARCHAR(10), IN `p_booking_date` DATE, IN `p_booking_time` VARCHAR(20), IN `p_number_of_professionals` INT, IN `p_number_of_hours` INT, IN `p_nationality` VARCHAR(50), IN `p_first_name` VARCHAR(500), IN `p_last_name` VARCHAR(500), IN `p_address` LONGTEXT, IN `p_phone` VARCHAR(50), IN `p_email_address` VARCHAR(500), IN `p_special_instructions` LONGTEXT, IN `p_mode_of_payment` VARCHAR(50), IN `p_discount_code` VARCHAR(50), IN `p_discount_type` VARCHAR(20), IN `p_discount_amount` DOUBLE, IN `p_total_discount_amount` DOUBLE, IN `p_booking_subtotal_amount` DOUBLE, IN `p_total_booking_amount` DOUBLE, IN `p_cancellation_window` DATETIME, IN `p_last_log_by` INT, OUT `p_booking_id` INT)   BEGIN
    INSERT INTO booking (booking_reference_number, source_of_booking, service, frequency, duration, number_of_seats, meters, cleaning_materials, booking_date, booking_time, number_of_professionals, number_of_hours, nationality, first_name, last_name, address, phone, email_address, special_instructions, mode_of_payment, discount_code, discount_type, discount_amount, total_discount_amount, booking_subtotal_amount, total_booking_amount, cancellation_window, last_log_by) 
	VALUES(p_booking_reference_number, p_source_of_booking, p_service, p_frequency, p_duration, p_number_of_seats, p_meters, p_cleaning_materials, p_booking_date, p_booking_time, p_number_of_professionals, p_number_of_hours, p_nationality, p_first_name, p_last_name, p_address, p_phone, p_email_address, p_special_instructions, p_mode_of_payment, p_discount_code, p_discount_type, p_discount_amount, p_total_discount_amount, p_booking_subtotal_amount, p_total_booking_amount, p_cancellation_window, p_last_log_by);

    SET p_booking_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertCallToAction`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertCallToAction` (IN `p_call_to_action_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_call_to_action_header` VARCHAR(500), IN `p_call_to_action_body` LONGTEXT, IN `p_last_log_by` INT, OUT `p_call_to_action_id` INT)   BEGIN
    INSERT INTO call_to_action (call_to_action_name, description, block_style_id, block_style_name, call_to_action_header, call_to_action_body, last_log_by) 
	VALUES(p_call_to_action_name, p_description, p_block_style_id, p_block_style_name, p_call_to_action_header, p_call_to_action_body, p_last_log_by);
	
    SET p_call_to_action_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertCarousel`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertCarousel` (IN `p_carousel_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_carousel_id` INT)   BEGIN
    INSERT INTO carousel (carousel_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_carousel_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_carousel_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertCarouselImage`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertCarouselImage` (IN `p_carousel_id` INT, IN `p_carousel_image` VARCHAR(500), IN `p_order_sequence` INT, IN `p_last_log_by` INT)   BEGIN
    INSERT INTO carousel_image (carousel_id, carousel_image, order_sequence, last_log_by) 
	VALUES(p_carousel_id, p_carousel_image, p_order_sequence, p_last_log_by);
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

DROP PROCEDURE IF EXISTS `insertClient`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertClient` (IN `p_client_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_client_id` INT)   BEGIN
    INSERT INTO client (client_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_client_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_client_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertClientItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertClientItem` (IN `p_client_id` INT, IN `p_client_logo` VARCHAR(500), IN `p_client_url` VARCHAR(500), IN `p_order_sequence` INT, IN `p_last_log_by` INT)   BEGIN
    INSERT INTO client_item (client_id, client_logo, client_url, order_sequence, last_log_by) 
	VALUES(p_client_id, p_client_logo, p_client_url, p_order_sequence, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertCompany`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertCompany` (IN `p_company_name` VARCHAR(100), IN `p_legal_name` VARCHAR(100), IN `p_address` VARCHAR(500), IN `p_city_id` INT, IN `p_city_name` VARCHAR(100), IN `p_state_id` INT, IN `p_state_name` VARCHAR(100), IN `p_country_id` INT, IN `p_country_name` VARCHAR(100), IN `p_currency_id` INT, IN `p_currency_name` VARCHAR(500), IN `p_currency_symbol` VARCHAR(10), IN `p_tax_id` VARCHAR(50), IN `p_phone` VARCHAR(50), IN `p_mobile` VARCHAR(50), IN `p_email` VARCHAR(500), IN `p_website` VARCHAR(500), IN `p_last_log_by` INT, OUT `p_company_id` INT)   BEGIN
    INSERT INTO company (company_name, legal_name, address, city_id, city_name, state_id, state_name, country_id, country_name, currency_id, currency_name, currency_symbol, tax_id, phone, mobile, email, website, last_log_by) 
	VALUES(p_company_name, p_legal_name, p_address, p_city_id, p_city_name, p_state_id, p_state_name, p_country_id, p_country_name, p_currency_id, p_currency_name, p_currency_symbol, p_tax_id, p_phone, p_mobile, p_email, p_website, p_last_log_by);
	
    SET p_company_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertContactForm`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertContactForm` (IN `p_contact_form_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_contact_form_id` INT)   BEGIN
    INSERT INTO contact_form (contact_form_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_contact_form_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_contact_form_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertContactInformationType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertContactInformationType` (IN `p_contact_information_type_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_contact_information_type_id` INT)   BEGIN
    INSERT INTO contact_information_type (contact_information_type_name, last_log_by) 
	VALUES(p_contact_information_type_name, p_last_log_by);
	
    SET p_contact_information_type_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertContentCarousel`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertContentCarousel` (IN `p_content_carousel_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_content_carousel_id` INT)   BEGIN
    INSERT INTO content_carousel (content_carousel_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_content_carousel_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_content_carousel_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertContentCarouselItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertContentCarouselItem` (IN `p_content_carousel_id` INT, IN `p_content_carousel_title` VARCHAR(500), IN `p_content_carousel_heading` VARCHAR(500), IN `p_content_carousel_paragraph` LONGTEXT, IN `p_call_to_action_button_1_text` VARCHAR(100), IN `p_call_to_action_button_1_link` VARCHAR(500), IN `p_call_to_action_button_2_text` VARCHAR(100), IN `p_call_to_action_button_2_link` VARCHAR(500), IN `p_content_carousel_image` VARCHAR(500), IN `p_order_sequence` INT, IN `p_last_log_by` INT)   BEGIN
    INSERT INTO content_carousel_item (content_carousel_id, content_carousel_title, content_carousel_heading, content_carousel_paragraph, call_to_action_button_1_text, call_to_action_button_1_link, call_to_action_button_2_text, call_to_action_button_2_link, content_carousel_image, order_sequence, last_log_by) 
	VALUES(p_content_carousel_id, p_content_carousel_title, p_content_carousel_heading, p_content_carousel_paragraph, p_call_to_action_button_1_text, p_call_to_action_button_1_link, p_call_to_action_button_2_text, p_call_to_action_button_2_link, p_content_carousel_image, p_order_sequence, p_last_log_by);
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

DROP PROCEDURE IF EXISTS `insertCustomer`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertCustomer` (IN `p_full_name` VARCHAR(1000), IN `p_first_name` VARCHAR(300), IN `p_middle_name` VARCHAR(300), IN `p_last_name` VARCHAR(300), IN `p_suffix` VARCHAR(10), IN `p_nickname` VARCHAR(100), IN `p_civil_status_id` INT, IN `p_civil_status_name` VARCHAR(100), IN `p_gender_id` INT, IN `p_gender_name` VARCHAR(100), IN `p_birthday` DATE, IN `p_birth_place` VARCHAR(1000), IN `p_last_log_by` INT, OUT `p_customer_id` INT)   BEGIN
    INSERT INTO customer (full_name, first_name, middle_name, last_name, suffix, nickname, civil_status_id, civil_status_name, gender_id, gender_name, birthday, birth_place, last_log_by) 
	VALUES(p_full_name, p_first_name, p_middle_name, p_last_name, p_suffix, p_nickname, p_civil_status_id, p_civil_status_name, p_gender_id, p_gender_name, p_birthday, p_birth_place, p_last_log_by);
	
    SET p_customer_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertCustomerAddress`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertCustomerAddress` (IN `p_customer_id` INT, IN `p_address_type_id` INT, IN `p_address_type_name` VARCHAR(100), IN `p_address` VARCHAR(1000), IN `p_city_id` INT, IN `p_city_name` VARCHAR(100), IN `p_state_id` INT, IN `p_state_name` VARCHAR(100), IN `p_country_id` INT, IN `p_country_name` VARCHAR(100), IN `p_telephone` VARCHAR(50), IN `p_mobile` VARCHAR(50), IN `p_email` VARCHAR(200), IN `p_last_log_by` INT)   BEGIN
    DECLARE existing_address_count INT;
    DECLARE p_default_address VARCHAR(10);

    SELECT COUNT(*) INTO existing_address_count
    FROM customer_address
    WHERE customer_id = p_customer_id AND default_address = 'Primary';

    IF existing_address_count = 0 THEN
        SET p_default_address = 'Primary';
    ELSE
        SET p_default_address = 'Alternate';
    END IF;

    INSERT INTO customer_address (customer_id, address_type_id, address_type_name, address, city_id, city_name, state_id, state_name, country_id, country_name, default_address, telephone, mobile, email, last_log_by) 
	VALUES(p_customer_id, p_address_type_id, p_address_type_name, p_address, p_city_id, p_city_name, p_state_id, p_state_name, p_country_id, p_country_name, p_default_address, p_telephone, p_mobile, p_email, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertCustomerBankAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertCustomerBankAccount` (IN `p_customer_id` INT, IN `p_bank_id` INT, IN `p_bank_name` VARCHAR(100), IN `p_bank_account_type_id` INT, IN `p_bank_account_type_name` VARCHAR(100), IN `p_account_number` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    INSERT INTO customer_bank_account (customer_id, bank_id, bank_name, bank_account_type_id,bank_account_type_name, account_number, last_log_by) 
	VALUES(p_customer_id, p_bank_id, p_bank_name, p_bank_account_type_id, p_bank_account_type_name, p_account_number, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertCustomerBankCard`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertCustomerBankCard` (IN `p_customer_id` INT, IN `p_name_on_card` VARCHAR(255), IN `p_card_number` VARCHAR(255), IN `p_expiry_date` VARCHAR(255), IN `p_cvv` VARCHAR(255), IN `p_last_log_by` INT)   BEGIN
    DECLARE existing_bank_card_count INT;
    DECLARE p_default_card VARCHAR(10);

    SELECT COUNT(*) INTO existing_bank_card_count
    FROM customer_bank_card
    WHERE customer_id = p_customer_id AND default_address = 'Primary';

    IF existing_bank_card_count = 0 THEN
        SET p_default_card = 'Primary';
    ELSE
        SET p_default_card = 'Alternate';
    END IF;

    INSERT INTO customer_bank_card (customer_id, name_on_card, card_number, expiry_date, cvv, default_card, last_log_by) 
	VALUES(p_customer_id, p_name_on_card, p_card_number, p_expiry_date, p_cvv, p_default_card, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertCustomerIDRecord`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertCustomerIDRecord` (IN `p_customer_id` INT, IN `p_id_type_id` INT, IN `p_id_type_name` VARCHAR(100), IN `p_id_number` VARCHAR(100), IN `p_issue_date` DATE, IN `p_expiration_date` DATE, IN `p_issuing_authority` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    INSERT INTO customer_id_record (customer_id, id_type_id, id_type_name, id_number, issue_date, expiration_date, issuing_authority, last_log_by) 
	VALUES(p_customer_id, p_id_type_id, p_id_type_name, p_id_number, p_issue_date, p_expiration_date, p_issuing_authority, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertCustomerInquiry`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertCustomerInquiry` (IN `p_customer_name` VARCHAR(500), IN `p_email` VARCHAR(500), IN `p_phone` VARCHAR(50), IN `p_subject` VARCHAR(500), IN `p_message` LONGTEXT, IN `p_last_log_by` INT, OUT `p_customer_inquiry_id` INT)   BEGIN
    INSERT INTO customer_inquiry (customer_name, email, phone, subject, message, last_log_by) 
	VALUES(p_customer_name, p_email, p_phone, p_subject, p_message, p_last_log_by);

     SET p_customer_inquiry_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertCustomerSignUp`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertCustomerSignUp` (IN `p_full_name` VARCHAR(1000), IN `p_first_name` VARCHAR(300), IN `p_middle_name` VARCHAR(300), IN `p_last_name` VARCHAR(300), IN `p_suffix` VARCHAR(10), IN `p_last_log_by` INT, OUT `p_customer_id` INT)   BEGIN
    INSERT INTO customer (full_name, first_name, middle_name, last_name, suffix, last_log_by) 
	VALUES(p_full_name, p_first_name, p_middle_name, p_last_name, p_suffix, p_last_log_by);
	
    SET p_customer_id = LAST_INSERT_ID();
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

DROP PROCEDURE IF EXISTS `insertEmployee`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertEmployee` (IN `p_full_name` VARCHAR(1000), IN `p_first_name` VARCHAR(300), IN `p_middle_name` VARCHAR(300), IN `p_last_name` VARCHAR(300), IN `p_suffix` VARCHAR(10), IN `p_nickname` VARCHAR(100), IN `p_civil_status_id` INT, IN `p_civil_status_name` VARCHAR(100), IN `p_gender_id` INT, IN `p_gender_name` VARCHAR(100), IN `p_religion_id` INT, IN `p_religion_name` VARCHAR(100), IN `p_blood_type_id` INT, IN `p_blood_type_name` VARCHAR(100), IN `p_birthday` DATE, IN `p_birth_place` VARCHAR(1000), IN `p_height` FLOAT, IN `p_weight` FLOAT, IN `p_badge_id` VARCHAR(200), IN `p_company_id` INT, IN `p_company_name` VARCHAR(100), IN `p_employment_type_id` INT, IN `p_employment_type_name` VARCHAR(100), IN `p_department_id` INT, IN `p_department_name` VARCHAR(100), IN `p_job_position_id` INT, IN `p_job_position_name` VARCHAR(100), IN `p_work_location_id` INT, IN `p_work_location_name` VARCHAR(100), IN `p_manager_id` INT, IN `p_manager_name` VARCHAR(100), IN `p_work_schedule_id` INT, IN `p_work_schedule_name` VARCHAR(100), IN `p_pin_code` VARCHAR(500), IN `p_home_work_distance` DOUBLE, IN `p_visa_number` VARCHAR(50), IN `p_work_permit_number` VARCHAR(50), IN `p_visa_expiration_date` DATE, IN `p_work_permit_expiration_date` DATE, IN `p_onboard_date` DATE, IN `p_time_off_approver_id` INT, IN `p_time_off_approver_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_employee_id` INT)   BEGIN
    INSERT INTO employee (full_name, first_name, middle_name, last_name, suffix, nickname, civil_status_id, civil_status_name, gender_id, gender_name, religion_id, religion_name, blood_type_id, blood_type_name, birthday, birth_place, height, weight, badge_id, company_id, company_name, employment_type_id, employment_type_name, department_id, department_name, job_position_id, job_position_name, work_location_id, work_location_name, manager_id, manager_name, work_schedule_id, work_schedule_name, pin_code, home_work_distance, visa_number, work_permit_number, visa_expiration_date, work_permit_expiration_date, onboard_date, time_off_approver_id, time_off_approver_name, last_log_by) 
	VALUES(p_full_name, p_first_name, p_middle_name, p_last_name, p_suffix, p_nickname, p_civil_status_id, p_civil_status_name, p_gender_id, p_gender_name, p_religion_id, p_religion_name, p_blood_type_id, p_blood_type_name, p_birthday, p_birth_place, p_height, p_weight, p_badge_id, p_company_id, p_company_name, p_employment_type_id, p_employment_type_name, p_department_id, p_department_name, p_job_position_id, p_job_position_name, p_work_location_id, p_work_location_name, p_manager_id, p_manager_name, p_work_schedule_id, p_work_schedule_name, p_pin_code, p_home_work_distance, p_visa_number, p_work_permit_number, p_visa_expiration_date, p_work_permit_expiration_date, p_onboard_date, p_time_off_approver_id, p_time_off_approver_name, p_last_log_by);
	
    SET p_employee_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertEmployeeAddress`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertEmployeeAddress` (IN `p_employee_id` INT, IN `p_address_type_id` INT, IN `p_address_type_name` VARCHAR(100), IN `p_address` VARCHAR(1000), IN `p_city_id` INT, IN `p_city_name` VARCHAR(100), IN `p_state_id` INT, IN `p_state_name` VARCHAR(100), IN `p_country_id` INT, IN `p_country_name` VARCHAR(100), IN `p_telephone` VARCHAR(50), IN `p_mobile` VARCHAR(50), IN `p_email` VARCHAR(200), IN `p_last_log_by` INT)   BEGIN
    DECLARE existing_address_count INT;
    DECLARE p_default_address VARCHAR(10);

    SELECT COUNT(*) INTO existing_address_count
    FROM employee_address
    WHERE employee_id = p_employee_id AND default_address = 'Primary';

    IF existing_address_count = 0 THEN
        SET p_default_address = 'Primary';
    ELSE
        SET p_default_address = 'Alternate';
    END IF;

    INSERT INTO employee_address (employee_id, address_type_id, address_type_name, address, city_id, city_name, state_id, state_name, country_id, country_name, default_address, telephone, mobile, email, last_log_by) 
	VALUES(p_employee_id, p_address_type_id, p_address_type_name, p_address, p_city_id, p_city_name, p_state_id, p_state_name, p_country_id, p_country_name, p_default_address, p_telephone, p_mobile, p_email, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertEmployeeBankAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertEmployeeBankAccount` (IN `p_employee_id` INT, IN `p_bank_id` INT, IN `p_bank_name` VARCHAR(100), IN `p_bank_account_type_id` INT, IN `p_bank_account_type_name` VARCHAR(100), IN `p_account_number` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    INSERT INTO employee_bank_account (employee_id, bank_id, bank_name, bank_account_type_id,bank_account_type_name, account_number, last_log_by) 
	VALUES(p_employee_id, p_bank_id, p_bank_name, p_bank_account_type_id, p_bank_account_type_name, p_account_number, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertEmployeeEducation`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertEmployeeEducation` (IN `p_employee_id` INT, IN `p_school` VARCHAR(100), IN `p_degree` VARCHAR(100), IN `p_field_of_study` VARCHAR(100), IN `p_start_month` VARCHAR(20), IN `p_start_year` VARCHAR(20), IN `p_end_month` VARCHAR(20), IN `p_end_year` VARCHAR(20), IN `p_activities_societies` VARCHAR(5000), IN `p_education_description` VARCHAR(5000), IN `p_last_log_by` INT)   BEGIN
    INSERT INTO employee_education (employee_id, school, degree, field_of_study, start_month, start_year, end_month, end_year, activities_societies, education_description, last_log_by) 
	VALUES(p_employee_id, p_school, p_degree, p_field_of_study, p_start_month, p_start_year, p_end_month, p_end_year, p_activities_societies, p_education_description, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertEmployeeEmergencyContact`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertEmployeeEmergencyContact` (IN `p_employee_id` INT, IN `p_emergency_contact_name` VARCHAR(500), IN `p_relation_id` INT, IN `p_relation_name` VARCHAR(100), IN `p_telephone` VARCHAR(50), IN `p_mobile` VARCHAR(50), IN `p_email` VARCHAR(200), IN `p_last_log_by` INT)   BEGIN
    INSERT INTO employee_emergency_contact (employee_id, emergency_contact_name, relation_id, relation_name, telephone, mobile, email, last_log_by) 
	VALUES(p_employee_id, p_emergency_contact_name, p_relation_id, p_relation_name, p_telephone, p_mobile, p_email, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertEmployeeExperience`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertEmployeeExperience` (IN `p_employee_id` INT, IN `p_job_title` VARCHAR(100), IN `p_employment_type_id` INT, IN `p_employment_type_name` VARCHAR(100), IN `p_company_name` VARCHAR(200), IN `p_location` VARCHAR(200), IN `p_employment_location_type_id` INT, IN `p_employment_location_type_name` VARCHAR(100), IN `p_start_month` VARCHAR(20), IN `p_start_year` VARCHAR(20), IN `p_end_month` VARCHAR(20), IN `p_end_year` VARCHAR(20), IN `p_job_description` VARCHAR(5000), IN `p_last_log_by` INT)   BEGIN
    INSERT INTO employee_experience (employee_id, job_title, employment_type_id, employment_type_name, company_name, location, employment_location_type_id, employment_location_type_name, start_month, start_year, end_month, end_year, job_description, last_log_by) 
	VALUES(p_employee_id, p_job_title, p_employment_type_id, p_employment_type_name, p_company_name, p_location, p_employment_location_type_id, p_employment_location_type_name, p_start_month, p_start_year, p_end_month, p_end_year, p_job_description, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertEmployeeIDRecord`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertEmployeeIDRecord` (IN `p_employee_id` INT, IN `p_id_type_id` INT, IN `p_id_type_name` VARCHAR(100), IN `p_id_number` VARCHAR(100), IN `p_issue_date` DATE, IN `p_expiration_date` DATE, IN `p_issuing_authority` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    INSERT INTO employee_id_record (employee_id, id_type_id, id_type_name, id_number, issue_date, expiration_date, issuing_authority, last_log_by) 
	VALUES(p_employee_id, p_id_type_id, p_id_type_name, p_id_number, p_issue_date, p_expiration_date, p_issuing_authority, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertEmployeeLanguage`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertEmployeeLanguage` (IN `p_employee_id` INT, IN `p_language_id` INT, IN `p_language_name` VARCHAR(100), IN `p_language_proficiency_id` INT, IN `p_language_proficiency_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    INSERT INTO employee_language (employee_id, language_id, language_name, language_proficiency_id, language_proficiency_name, last_log_by) 
	VALUES(p_employee_id, p_language_id, p_language_name, p_language_proficiency_id, p_language_proficiency_name, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertEmployeeLicense`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertEmployeeLicense` (IN `p_employee_id` INT, IN `p_licensed_profession` VARCHAR(200), IN `p_licensing_body` VARCHAR(200), IN `p_license_number` VARCHAR(200), IN `p_issue_date` DATE, IN `p_expiration_date` DATE, IN `p_last_log_by` INT)   BEGIN
    INSERT INTO employee_license (employee_id, licensed_profession, licensing_body, license_number, issue_date, expiration_date, last_log_by) 
	VALUES(p_employee_id, p_licensed_profession, p_licensing_body, p_license_number, p_issue_date, p_expiration_date, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertEmploymentLocationType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertEmploymentLocationType` (IN `p_employment_location_type_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_employment_location_type_id` INT)   BEGIN
    INSERT INTO employment_location_type (employment_location_type_name, last_log_by) 
	VALUES(p_employment_location_type_name, p_last_log_by);
	
    SET p_employment_location_type_id = LAST_INSERT_ID();
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

DROP PROCEDURE IF EXISTS `insertFooter`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertFooter` (IN `p_footer_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_footer_id` INT)   BEGIN
    INSERT INTO footer (footer_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_footer_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_footer_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertGender`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertGender` (IN `p_gender_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_gender_id` INT)   BEGIN
    INSERT INTO gender (gender_name, last_log_by) 
	VALUES(p_gender_name, p_last_log_by);
	
    SET p_gender_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertHeader`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertHeader` (IN `p_header_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_header_id` INT)   BEGIN
    INSERT INTO header (header_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_header_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_header_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertIDType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertIDType` (IN `p_id_type_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_id_type_id` INT)   BEGIN
    INSERT INTO id_type (id_type_name, last_log_by) 
	VALUES(p_id_type_name, p_last_log_by);
	
    SET p_id_type_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertImageGallery`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertImageGallery` (IN `p_image_gallery_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_image_gallery_id` INT)   BEGIN
    INSERT INTO image_gallery (image_gallery_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_image_gallery_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_image_gallery_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertImageGalleryItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertImageGalleryItem` (IN `p_image_gallery_id` INT, IN `p_image_gallery_title` VARCHAR(500), IN `p_image_gallery_image` VARCHAR(500), IN `p_order_sequence` INT, IN `p_last_log_by` INT)   BEGIN
    INSERT INTO image_gallery_item (image_gallery_id, image_gallery_title, image_gallery_image, order_sequence, last_log_by) 
	VALUES(p_image_gallery_id, p_image_gallery_title, p_image_gallery_image, p_order_sequence, p_last_log_by);
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

DROP PROCEDURE IF EXISTS `insertPageTitle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertPageTitle` (IN `p_page_title_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_page_title` VARCHAR(500), IN `p_page_heading` VARCHAR(500), IN `p_last_log_by` INT, OUT `p_page_title_id` INT)   BEGIN
    INSERT INTO page_title (page_title_name, description, block_style_id, block_style_name, page_title, page_heading, last_log_by) 
	VALUES(p_page_title_name, p_description, p_block_style_id, p_block_style_name, p_page_title, p_page_heading, p_last_log_by);
	
    SET p_page_title_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertPasswordHistory`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertPasswordHistory` (IN `p_user_account_id` INT, IN `p_password` VARCHAR(255))   BEGIN
    INSERT INTO password_history (user_account_id, password, password_change_date) 
    VALUES (p_user_account_id, p_password, NOW());
END$$

DROP PROCEDURE IF EXISTS `insertPricingTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertPricingTable` (IN `p_pricing_table_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_pricing_table_id` INT)   BEGIN
    INSERT INTO pricing_table (pricing_table_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_pricing_table_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_pricing_table_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertProcesStep`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertProcesStep` (IN `p_process_step_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_process_step_id` INT)   BEGIN
    INSERT INTO process_step (process_step_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_process_step_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_process_step_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertProcesStepItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertProcesStepItem` (IN `p_process_step_id` INT, IN `p_process_step_title` VARCHAR(500), IN `p_process_step_heading` VARCHAR(500), IN `p_process_step_link` VARCHAR(500), IN `p_process_step_image` VARCHAR(500), IN `p_order_sequence` INT, IN `p_last_log_by` INT)   BEGIN
    INSERT INTO process_step_item (process_step_id, process_step_title, process_step_heading, process_step_link, process_step_image, order_sequence, last_log_by) 
	VALUES(p_process_step_id, p_process_step_title, p_process_step_heading, p_process_step_link, p_process_step_image, p_order_sequence, p_last_log_by);
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

DROP PROCEDURE IF EXISTS `insertSections`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertSections` (IN `p_sections_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_sections_id` INT)   BEGIN
    INSERT INTO sections (sections_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_sections_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_sections_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertServicesBox`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertServicesBox` (IN `p_services_box_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_services_box_id` INT)   BEGIN
    INSERT INTO services_box (services_box_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_services_box_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_services_box_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertServicesBoxItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertServicesBoxItem` (IN `p_services_box_id` INT, IN `p_services_box_title` VARCHAR(500), IN `p_services_box_heading` VARCHAR(500), IN `p_services_box_paragraph` LONGTEXT, IN `p_call_to_action_button_text` VARCHAR(100), IN `p_call_to_action_button_link` VARCHAR(500), IN `p_services_box_image` VARCHAR(500), IN `p_order_sequence` INT, IN `p_last_log_by` INT)   BEGIN
    INSERT INTO services_box_item (services_box_id, services_box_title, services_box_heading, services_box_paragraph, call_to_action_button_text, call_to_action_button_link, services_box_image, order_sequence, last_log_by) 
	VALUES(p_services_box_id, p_services_box_title, p_services_box_heading, p_services_box_paragraph, p_call_to_action_button_text, p_call_to_action_button_link, p_services_box_image, p_order_sequence, p_last_log_by);
END$$

DROP PROCEDURE IF EXISTS `insertSlider`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertSlider` (IN `p_slider_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_slider_id` INT)   BEGIN
    INSERT INTO slider (slider_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_slider_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_slider_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertSliderItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertSliderItem` (IN `p_slider_id` INT, IN `p_slider_title` VARCHAR(500), IN `p_slider_heading` VARCHAR(500), IN `p_slider_paragraph` LONGTEXT, IN `p_call_to_action_button_1_text` VARCHAR(100), IN `p_call_to_action_button_1_link` VARCHAR(500), IN `p_call_to_action_button_2_text` VARCHAR(100), IN `p_call_to_action_button_2_link` VARCHAR(500), IN `p_slider_image` VARCHAR(500), IN `p_order_sequence` INT, IN `p_last_log_by` INT)   BEGIN
    INSERT INTO slider_item (slider_id, slider_title, slider_heading, slider_paragraph, call_to_action_button_1_text, call_to_action_button_1_link, call_to_action_button_2_text, call_to_action_button_2_link, slider_image, order_sequence, last_log_by) 
	VALUES(p_slider_id, p_slider_title, p_slider_heading, p_slider_paragraph, p_call_to_action_button_1_text, p_call_to_action_button_1_link, p_call_to_action_button_2_text, p_call_to_action_button_2_link, p_slider_image, p_order_sequence, p_last_log_by);
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

DROP PROCEDURE IF EXISTS `insertTestimonial`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertTestimonial` (IN `p_testimonial_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT, OUT `p_testimonial_id` INT)   BEGIN
    INSERT INTO testimonial (testimonial_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_testimonial_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_testimonial_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertTestimonialItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertTestimonialItem` (IN `p_testimonial_id` INT, IN `p_testimonial_client` VARCHAR(500), IN `p_testimonial_title` VARCHAR(500), IN `p_testimonial_paragraph` LONGTEXT, IN `p_rating` FLOAT, IN `p_testimonial_image` VARCHAR(500), IN `p_order_sequence` INT, IN `p_last_log_by` INT)   BEGIN
    INSERT INTO testimonial_item (testimonial_id, testimonial_client, testimonial_title, testimonial_paragraph, rating, testimonial_image, order_sequence, last_log_by) 
	VALUES(p_testimonial_id, p_testimonial_client, p_testimonial_title, p_testimonial_paragraph, p_rating, p_testimonial_image, p_order_sequence, p_last_log_by);
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

DROP PROCEDURE IF EXISTS `insertUserAccountSignUp`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertUserAccountSignUp` (IN `p_file_as` VARCHAR(300), IN `p_email` VARCHAR(255), IN `p_username` VARCHAR(100), IN `p_password` VARCHAR(255), IN `p_password_expiry_date` DATE, IN `p_last_password_change` DATETIME, IN `p_user_type` VARCHAR(20), IN `p_linked_id` INT, IN `p_registration_verification_token` VARCHAR(255), IN `p_registration_verification_token_expiry_date` DATETIME, IN `p_last_log_by` INT, OUT `p_user_account_id` INT)   BEGIN
    INSERT INTO user_account (file_as, email, username, password, password_expiry_date, last_password_change, user_type, linked_id, registration_date, registration_verification_token, registration_verification_token_expiry_date, last_log_by) 
	VALUES(p_file_as, p_email, p_username, p_password, p_password_expiry_date, p_last_password_change, p_user_type, p_linked_id, NOW(), p_registration_verification_token, p_registration_verification_token_expiry_date, p_last_log_by);
	
    SET p_user_account_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertVoucher`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertVoucher` (IN `p_voucher_name` VARCHAR(100), IN `p_voucher_code` VARCHAR(20), IN `p_voucher_usage_start_date` DATE, IN `p_voucher_usage_end_date` DATE, IN `p_discount_type` VARCHAR(20), IN `p_discount_amount` DOUBLE, IN `p_minimum_booking_amount` DOUBLE, IN `p_voucher_quantity` INT, IN `p_available_voucher` INT, IN `p_last_log_by` INT, OUT `p_voucher_id` INT)   BEGIN
    INSERT INTO voucher (voucher_name, voucher_code, voucher_usage_start_date, voucher_usage_end_date, discount_type, discount_amount, minimum_booking_amount, voucher_quantity, available_voucher, last_log_by) 
	VALUES(p_voucher_name, p_voucher_code, p_voucher_usage_start_date, p_voucher_usage_end_date, p_discount_type, p_discount_amount, p_minimum_booking_amount, p_voucher_quantity, p_available_voucher, p_last_log_by);
	
    SET p_voucher_id = LAST_INSERT_ID();
END$$

DROP PROCEDURE IF EXISTS `insertWebsite`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `insertWebsite` (IN `p_website_name` VARCHAR(100), IN `p_description` VARCHAR(500), IN `p_url` VARCHAR(255), IN `p_last_log_by` INT, OUT `p_website_id` INT)   BEGIN
    INSERT INTO website (website_name, description, url, last_log_by) 
	VALUES(p_website_name, p_description, p_url, p_last_log_by);
	
    SET p_website_id = LAST_INSERT_ID();
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

DROP PROCEDURE IF EXISTS `updateAccordion`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateAccordion` (IN `p_accordion_id` INT, IN `p_accordion_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE accordion
    SET accordion_name = p_accordion_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE accordion_id = p_accordion_id;
END$$

DROP PROCEDURE IF EXISTS `updateAccordionItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateAccordionItem` (IN `p_accordion_item_id` INT, IN `p_accordion_id` INT, IN `p_accordion_header` VARCHAR(500), IN `p_accordion_body` LONGTEXT, IN `p_order_sequence` INT, IN `p_last_log_by` INT)   BEGIN
    UPDATE accordion_item
    SET accordion_id = p_accordion_id,
        accordion_header = p_accordion_header,
        accordion_body = p_accordion_body,
        order_sequence = p_order_sequence,
        last_log_by = p_last_log_by
    WHERE accordion_item_id = p_accordion_item_id;
END$$

DROP PROCEDURE IF EXISTS `updateAccordionPublishStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateAccordionPublishStatus` (IN `p_accordion_id` INT, IN `p_publish_status` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE accordion
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE accordion_id = p_accordion_id;
END$$

DROP PROCEDURE IF EXISTS `updateAccountLock`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateAccountLock` (IN `p_user_account_id` INT, IN `p_locked` VARCHAR(5), IN `p_account_lock_duration` INT)   BEGIN
	UPDATE user_account 
    SET locked = p_locked, account_lock_duration = p_account_lock_duration 
    WHERE user_account_id = p_user_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateAddressType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateAddressType` (IN `p_address_type_id` INT, IN `p_address_type_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE employee_address
    SET address_type_name = p_address_type_name,
        last_log_by = p_last_log_by
    WHERE address_type_id = p_address_type_id;

    UPDATE address_type
    SET address_type_name = p_address_type_name,
        last_log_by = p_last_log_by
    WHERE address_type_id = p_address_type_id;

    COMMIT;
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
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE employee_bank_account
    SET bank_name = p_bank_name,
        last_log_by = p_last_log_by
    WHERE bank_id = p_bank_id;

    UPDATE bank
    SET bank_name = p_bank_name,
        bank_identifier_code = p_bank_identifier_code,
        last_log_by = p_last_log_by
    WHERE bank_id = p_bank_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateBankAccountType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateBankAccountType` (IN `p_bank_account_type_id` INT, IN `p_bank_account_type_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE employee_bank_account
    SET bank_account_type_name = p_bank_account_type_name,
        last_log_by = p_last_log_by
    WHERE bank_account_type_id = p_bank_account_type_id;

    UPDATE bank_account_type
    SET bank_account_type_name = p_bank_account_type_name,
        last_log_by = p_last_log_by
    WHERE bank_account_type_id = p_bank_account_type_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateBlockContainer`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateBlockContainer` (IN `p_block_style_id` INT, IN `p_block_container` LONGTEXT, IN `p_last_log_by` INT)   BEGIN
    UPDATE block_container
    SET block_container = p_block_container,
        last_log_by = p_last_log_by
    WHERE block_style_id = p_block_style_id;
END$$

DROP PROCEDURE IF EXISTS `updateBlockItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateBlockItem` (IN `p_block_style_id` INT, IN `p_block_item` LONGTEXT, IN `p_last_log_by` INT)   BEGIN
    UPDATE block_item
    SET block_item = p_block_item,
        last_log_by = p_last_log_by
    WHERE block_style_id = p_block_style_id;
END$$

DROP PROCEDURE IF EXISTS `updateBlockStyle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateBlockStyle` (IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_description` VARCHAR(500), IN `p_block_type_id` INT, IN `p_block_type_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE block_style
    SET block_style_name = p_block_style_name,
        description = p_description,
        block_type_id = p_block_type_id,
        block_type_name = p_block_type_name,
        last_log_by = p_last_log_by
    WHERE block_style_id = p_block_style_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateBlockType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateBlockType` (IN `p_block_type_id` INT, IN `p_block_type_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE block_style
    SET block_type_name = p_block_type_name,
        last_log_by = p_last_log_by
    WHERE block_type_id = p_block_type_id;

    UPDATE block_type
    SET block_type_name = p_block_type_name,
        last_log_by = p_last_log_by
    WHERE block_type_id = p_block_type_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateBloodType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateBloodType` (IN `p_blood_type_id` INT, IN `p_blood_type_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE employee
    SET blood_type_name = p_blood_type_name,
        last_log_by = p_last_log_by
    WHERE blood_type_id = p_blood_type_id;

    UPDATE blood_type
    SET blood_type_name = p_blood_type_name,
        last_log_by = p_last_log_by
    WHERE blood_type_id = p_blood_type_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateBooking`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateBooking` (IN `p_booking_id` INT, IN `p_source_of_booking` VARCHAR(50), IN `p_service` VARCHAR(100), IN `p_frequency` VARCHAR(50), IN `p_duration` INT, IN `p_number_of_seats` INT, IN `p_meters` INT, IN `p_cleaning_materials` VARCHAR(10), IN `p_booking_date` DATE, IN `p_booking_time` VARCHAR(20), IN `p_number_of_professionals` INT, IN `p_number_of_hours` INT, IN `p_nationality` VARCHAR(50), IN `p_first_name` VARCHAR(500), IN `p_last_name` VARCHAR(500), IN `p_address` LONGTEXT, IN `p_phone` VARCHAR(50), IN `p_email_address` VARCHAR(500), IN `p_special_instructions` LONGTEXT, IN `p_mode_of_payment` VARCHAR(50), IN `p_discount_code` VARCHAR(50), IN `p_discount_type` VARCHAR(20), IN `p_discount_amount` DOUBLE, IN `p_total_discount_amount` DOUBLE, IN `p_booking_subtotal_amount` DOUBLE, IN `p_total_booking_amount` DOUBLE, IN `p_last_log_by` INT)   BEGIN
    UPDATE booking
    SET source_of_booking = p_source_of_booking,
        service = p_service,
        frequency = p_frequency,
        duration = p_duration,
        number_of_seats = p_number_of_seats,
        meters = p_meters, 
        cleaning_materials = p_cleaning_materials, 
        booking_date = p_booking_date, 
        booking_time = p_booking_time, 
        number_of_professionals = p_number_of_professionals, 
        number_of_hours = p_number_of_hours, 
        nationality = p_nationality, 
        first_name = p_first_name, 
        last_name = p_last_name, 
        address = p_address, 
        phone = p_phone, 
        email_address = p_email_address, 
        special_instructions = p_special_instructions, 
        mode_of_payment = p_mode_of_payment, 
        discount_code = p_discount_code, 
        discount_type = p_discount_type, 
        discount_amount = p_discount_amount, 
        total_discount_amount = p_total_discount_amount, 
        booking_subtotal_amount = p_booking_subtotal_amount, 
        total_booking_amount = p_total_booking_amount,
        last_log_by = p_last_log_by
    WHERE booking_id = p_booking_id;
END$$

DROP PROCEDURE IF EXISTS `updateBookingPaymentStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateBookingPaymentStatus` (IN `p_booking_id` INT, IN `p_payment_status` VARCHAR(100), IN `p_payment_amount` DOUBLE, IN `p_payment_date` DATETIME, IN `p_payment_reference_number` VARCHAR(500), IN `p_refund_amount` DOUBLE, IN `p_remarks` LONGTEXT, IN `p_last_log_by` INT)   BEGIN    
    IF p_payment_status = 'Paid' THEN
        UPDATE booking
        SET payment_status = p_payment_status,
            payment_amount = p_payment_amount,
            payment_date = p_payment_date,
            payment_reference_number = p_payment_reference_number,
            last_log_by = p_last_log_by
        WHERE booking_id = p_booking_id;
    ELSEIF p_payment_status = 'For Refund' THEN
        UPDATE booking
        SET payment_status = p_payment_status,
            refund_amount = p_refund_amount,
            for_refund_date = NOW(),
            for_refund_reason = p_remarks,
            last_log_by = p_last_log_by
        WHERE booking_id = p_booking_id;
    ELSEIF p_payment_status = 'Rejected' THEN
        UPDATE booking
        SET payment_status = p_payment_status,
            for_refund_rejection_date = NOW(),
            for_refund_rejection_reason = p_remarks,
            last_log_by = p_last_log_by
        WHERE booking_id = p_booking_id;

        UPDATE booking
        SET payment_status = 'Paid',
            last_log_by = p_last_log_by
        WHERE booking_id = p_booking_id;
    ELSE
        UPDATE booking
        SET payment_status = p_payment_status,
            refund_date = NOW(),
            last_log_by = p_last_log_by
        WHERE booking_id = p_booking_id;
    END IF;
END$$

DROP PROCEDURE IF EXISTS `updateBookingStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateBookingStatus` (IN `p_booking_id` INT, IN `p_booking_status` VARCHAR(100), IN `p_remarks` LONGTEXT, IN `p_last_log_by` INT)   BEGIN    
    IF p_booking_status = 'In-Progress' THEN
        UPDATE booking
        SET booking_status = p_booking_status,
            in_progress_date = NOW(),
            last_log_by = p_last_log_by
        WHERE booking_id = p_booking_id;
    ELSEIF p_booking_status = 'Completed' THEN
        UPDATE booking
        SET booking_status = p_booking_status,
            completed_date = NOW(),
            last_log_by = p_last_log_by
        WHERE booking_id = p_booking_id;
    ELSEIF p_booking_status = 'For Cancellation' THEN
        UPDATE booking
        SET booking_status = p_booking_status,
            cancellation_request_date = NOW(),
            cancellation_reason = p_remarks,
            last_log_by = p_last_log_by
        WHERE booking_id = p_booking_id;
    ELSEIF p_booking_status = 'Rejected' THEN
        UPDATE booking
        SET booking_status = p_booking_status,
            booking_for_cancellation_rejection_date = NOW(),
            booking_for_cancellation_rejection_reason = p_remarks,
            last_log_by = p_last_log_by
        WHERE booking_id = p_booking_id;

        UPDATE booking
        SET booking_status = 'Pending',
            last_log_by = p_last_log_by
        WHERE booking_id = p_booking_id;
    ELSE
        UPDATE booking
        SET booking_status = p_booking_status,
            cancellation_date = NOW(),
            last_log_by = p_last_log_by
        WHERE booking_id = p_booking_id;
    END IF;
END$$

DROP PROCEDURE IF EXISTS `updateCallToAction`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCallToAction` (IN `p_call_to_action_id` INT, IN `p_call_to_action_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_call_to_action_header` VARCHAR(500), IN `p_call_to_action_body` LONGTEXT, IN `p_last_log_by` INT)   BEGIN
    UPDATE call_to_action
    SET call_to_action_name = p_call_to_action_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        call_to_action_header = p_call_to_action_header,
        call_to_action_body = p_call_to_action_body,
        last_log_by = p_last_log_by
    WHERE call_to_action_id = p_call_to_action_id;
END$$

DROP PROCEDURE IF EXISTS `updateCallToActionPublishStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCallToActionPublishStatus` (IN `p_call_to_action_id` INT, IN `p_publish_status` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE call_to_action
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE call_to_action_id = p_call_to_action_id;
END$$

DROP PROCEDURE IF EXISTS `updateCarousel`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCarousel` (IN `p_carousel_id` INT, IN `p_carousel_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE carousel
    SET carousel_name = p_carousel_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE carousel_id = p_carousel_id;
END$$

DROP PROCEDURE IF EXISTS `updateCarouselImage`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCarouselImage` (IN `p_carousel_image_id` INT, IN `p_carousel_id` INT, IN `p_carousel_image` VARCHAR(500), IN `p_order_sequence` INT, IN `p_last_log_by` INT)   BEGIN
    IF p_carousel_image IS NOT NULL AND p_carousel_image != '' THEN
        UPDATE carousel_image
        SET carousel_id = p_carousel_id,
            carousel_image = p_carousel_image,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE carousel_image_id = p_carousel_image_id;
    ELSE
        UPDATE carousel_image
        SET carousel_id = p_carousel_id,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE carousel_image_id = p_carousel_image_id;
    END IF;   
END$$

DROP PROCEDURE IF EXISTS `updateCarouselPublishStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCarouselPublishStatus` (IN `p_carousel_id` INT, IN `p_publish_status` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE carousel
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE carousel_id = p_carousel_id;
END$$

DROP PROCEDURE IF EXISTS `updateCity`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCity` (IN `p_city_id` INT, IN `p_city_name` VARCHAR(100), IN `p_state_id` INT, IN `p_state_name` VARCHAR(100), IN `p_country_id` INT, IN `p_country_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE employee_address
    SET city_name = p_city_name,
        state_id = p_state_id,
        state_name = p_state_name,
        country_id = p_country_id,
        country_name = p_country_name,
        last_log_by = p_last_log_by
    WHERE city_id = p_city_id;

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
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE employee
    SET civil_status_name = p_civil_status_name,
        last_log_by = p_last_log_by
    WHERE civil_status_id = p_civil_status_id;

    UPDATE civil_status
    SET civil_status_name = p_civil_status_name,
        last_log_by = p_last_log_by
    WHERE civil_status_id = p_civil_status_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateClient`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateClient` (IN `p_client_id` INT, IN `p_client_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE client
    SET client_name = p_client_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE client_id = p_client_id;
END$$

DROP PROCEDURE IF EXISTS `updateClientItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateClientItem` (IN `p_client_item_id` INT, IN `p_client_id` INT, IN `p_client_logo` VARCHAR(500), IN `p_client_url` VARCHAR(500), IN `p_order_sequence` INT, IN `p_last_log_by` INT)   BEGIN
    IF p_client_logo IS NOT NULL AND p_client_logo != '' THEN
        UPDATE client_item
        SET client_id = p_client_id,
            client_logo = p_client_logo,
            client_url = p_client_url,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE client_item_id = p_client_item_id;
    ELSE
        UPDATE client_item
        SET client_id = p_client_id,
            client_url = p_client_url,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE client_item_id = p_client_item_id;
    END IF;   
END$$

DROP PROCEDURE IF EXISTS `updateClientPublishStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateClientPublishStatus` (IN `p_client_id` INT, IN `p_publish_status` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE client
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE client_id = p_client_id;
END$$

DROP PROCEDURE IF EXISTS `updateCompany`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCompany` (IN `p_company_id` INT, IN `p_company_name` VARCHAR(100), IN `p_legal_name` VARCHAR(100), IN `p_address` VARCHAR(500), IN `p_city_id` INT, IN `p_city_name` VARCHAR(100), IN `p_state_id` INT, IN `p_state_name` VARCHAR(100), IN `p_country_id` INT, IN `p_country_name` VARCHAR(100), IN `p_currency_id` INT, IN `p_currency_name` VARCHAR(500), IN `p_currency_symbol` VARCHAR(10), IN `p_tax_id` VARCHAR(50), IN `p_phone` VARCHAR(50), IN `p_mobile` VARCHAR(50), IN `p_email` VARCHAR(500), IN `p_website` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE work_information
    SET company_name = p_company_name
    WHERE company_id = p_company_id;

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

DROP PROCEDURE IF EXISTS `updateContactForm`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateContactForm` (IN `p_contact_form_id` INT, IN `p_contact_form_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE contact_form
    SET contact_form_name = p_contact_form_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE contact_form_id = p_contact_form_id;
END$$

DROP PROCEDURE IF EXISTS `updateContactFormPublishStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateContactFormPublishStatus` (IN `p_contact_form_id` INT, IN `p_publish_status` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE contact_form
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE contact_form_id = p_contact_form_id;
END$$

DROP PROCEDURE IF EXISTS `updateContactInformationType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateContactInformationType` (IN `p_contact_information_type_id` INT, IN `p_contact_information_type_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE contact_information_type
    SET contact_information_type_name = p_contact_information_type_name,
        last_log_by = p_last_log_by
    WHERE contact_information_type_id = p_contact_information_type_id;
END$$

DROP PROCEDURE IF EXISTS `updateContentCarousel`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateContentCarousel` (IN `p_content_carousel_id` INT, IN `p_content_carousel_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE content_carousel
    SET content_carousel_name = p_content_carousel_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE content_carousel_id = p_content_carousel_id;
END$$

DROP PROCEDURE IF EXISTS `updateContentCarouselItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateContentCarouselItem` (IN `p_content_carousel_item_id` INT, IN `p_content_carousel_id` INT, IN `p_content_carousel_title` VARCHAR(500), IN `p_content_carousel_heading` VARCHAR(500), IN `p_content_carousel_paragraph` LONGTEXT, IN `p_call_to_action_button_1_text` VARCHAR(100), IN `p_call_to_action_button_1_link` VARCHAR(500), IN `p_call_to_action_button_2_text` VARCHAR(100), IN `p_call_to_action_button_2_link` VARCHAR(500), IN `p_content_carousel_image` VARCHAR(500), IN `p_order_sequence` INT, IN `p_last_log_by` INT)   BEGIN
    IF p_content_carousel_image IS NOT NULL AND p_content_carousel_image != '' THEN
        UPDATE content_carousel_item
        SET content_carousel_id = p_content_carousel_id,
            content_carousel_title = p_content_carousel_title,
            content_carousel_heading = p_content_carousel_heading,
            content_carousel_paragraph = p_content_carousel_paragraph,
            call_to_action_button_1_text = p_call_to_action_button_1_text,
            call_to_action_button_1_link = p_call_to_action_button_1_link,
            call_to_action_button_2_text = p_call_to_action_button_2_text,
            call_to_action_button_2_link = p_call_to_action_button_2_link,
            content_carousel_image = p_content_carousel_image,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE content_carousel_item_id = p_content_carousel_item_id;
    ELSE
        UPDATE content_carousel_item
        SET content_carousel_id = p_content_carousel_id,
            content_carousel_title = p_content_carousel_title,
            content_carousel_heading = p_content_carousel_heading,
            content_carousel_paragraph = p_content_carousel_paragraph,
            call_to_action_button_1_text = p_call_to_action_button_1_text,
            call_to_action_button_1_link = p_call_to_action_button_1_link,
            call_to_action_button_2_text = p_call_to_action_button_2_text,
            call_to_action_button_2_link = p_call_to_action_button_2_link,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE content_carousel_item_id = p_content_carousel_item_id;
    END IF;   
END$$

DROP PROCEDURE IF EXISTS `updateContentCarouselPublishStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateContentCarouselPublishStatus` (IN `p_content_carousel_id` INT, IN `p_publish_status` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE content_carousel
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE content_carousel_id = p_content_carousel_id;
END$$

DROP PROCEDURE IF EXISTS `updateCountry`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCountry` (IN `p_country_id` INT, IN `p_country_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE employee_address
    SET country_name = p_country_name,
        last_log_by = p_last_log_by
    WHERE country_id = p_country_id;

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

DROP PROCEDURE IF EXISTS `updateCustomerAbout`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCustomerAbout` (IN `p_customer_id` INT, IN `p_about` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    UPDATE customer
    SET about = p_about,
        last_log_by = p_last_log_by
    WHERE customer_id = p_customer_id;
END$$

DROP PROCEDURE IF EXISTS `updateCustomerAddress`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCustomerAddress` (IN `p_customer_address_id` INT, IN `p_customer_id` INT, IN `p_address_type_id` INT, IN `p_address_type_name` VARCHAR(100), IN `p_address` VARCHAR(1000), IN `p_city_id` INT, IN `p_city_name` VARCHAR(100), IN `p_state_id` INT, IN `p_state_name` VARCHAR(100), IN `p_country_id` INT, IN `p_country_name` VARCHAR(100), IN `p_telephone` VARCHAR(50), IN `p_mobile` VARCHAR(50), IN `p_email` VARCHAR(200), IN `p_last_log_by` INT)   BEGIN
    UPDATE customer_address
    SET customer_id = p_customer_id,
        address_type_id = p_address_type_id,
        address_type_name = p_address_type_name,
        address = p_address,
        city_id = p_city_id,
        city_name = p_city_name,
        state_id = p_state_id,
        state_name = p_state_name,
        country_id = p_country_id,
        country_name = p_country_name,
        telephone = p_telephone,
        mobile = p_mobile,
        email = p_email,
        last_log_by = p_last_log_by
    WHERE customer_address_id = p_customer_address_id;
END$$

DROP PROCEDURE IF EXISTS `updateCustomerAddressDefault`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCustomerAddressDefault` (IN `p_customer_address_id` INT, IN `p_customer_id` INT, IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE customer_address
    SET default_address = 'Alternate',
        last_log_by = p_last_log_by
    WHERE customer_id = p_customer_id AND default_address = 'Primary';

    UPDATE customer_address
    SET default_address = 'Primary',
        last_log_by = p_last_log_by
    WHERE customer_address_id = p_customer_address_id AND customer_id = p_customer_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateCustomerBankAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCustomerBankAccount` (IN `p_customer_bank_account_id` INT, IN `p_customer_id` INT, IN `p_bank_id` INT, IN `p_bank_name` VARCHAR(100), IN `p_bank_account_type_id` INT, IN `p_bank_account_type_name` VARCHAR(100), IN `p_account_number` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE customer_bank_account
    SET customer_id = p_customer_id,
        bank_id = p_bank_id,
        bank_name = p_bank_name,
        bank_account_type_id = p_bank_account_type_id,
        bank_account_type_name = p_bank_account_type_name,
        account_number = p_account_number,
        last_log_by = p_last_log_by
    WHERE customer_bank_account_id = p_customer_bank_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateCustomerBankCard`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCustomerBankCard` (IN `p_customer_bank_card_id` INT, IN `p_customer_id` INT, IN `p_name_on_card` VARCHAR(255), IN `p_card_number` VARCHAR(255), IN `p_expiry_date` VARCHAR(255), IN `p_cvv` VARCHAR(255), IN `p_last_log_by` INT)   BEGIN
    UPDATE customer_bank_card
    SET customer_id = p_customer_id,
        name_on_card = p_name_on_card,
        card_number = p_card_number,
        expiry_date = p_expiry_date,
        cvv = p_cvv,
        last_log_by = p_last_log_by
    WHERE customer_bank_card_id = p_customer_bank_card_id;
END$$

DROP PROCEDURE IF EXISTS `updateCustomerBankCardDefault`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCustomerBankCardDefault` (IN `p_customer_bank_card_id` INT, IN `p_customer_id` INT, IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE customer_bank_card
    SET default_card = 'Alternate',
        last_log_by = p_last_log_by
    WHERE customer_id = p_customer_id AND default_card = 'Primary';

    UPDATE customer_bank_card
    SET default_card = 'Primary',
        last_log_by = p_last_log_by
    WHERE customer_bank_card_id = p_customer_bank_card_id AND customer_id = p_customer_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateCustomerIDRecord`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCustomerIDRecord` (IN `p_customer_id_record_id` INT, IN `p_customer_id` INT, IN `p_id_type_id` INT, IN `p_id_type_name` VARCHAR(100), IN `p_id_number` VARCHAR(100), IN `p_issue_date` DATE, IN `p_expiration_date` DATE, IN `p_issuing_authority` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE customer_id_record
    SET customer_id = p_customer_id,
        id_type_id = p_id_type_id,
        id_type_name = p_id_type_name,
        id_number = p_id_number,
        issue_date = p_issue_date,
        expiration_date = p_expiration_date,
        issuing_authority = p_issuing_authority,
        last_log_by = p_last_log_by
    WHERE customer_id_record_id = p_customer_id_record_id;
END$$

DROP PROCEDURE IF EXISTS `updateCustomerIDRecordImage`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCustomerIDRecordImage` (IN `p_customer_id_record_id` INT, IN `p_id_image` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    UPDATE customer_id_record
    SET id_image = p_id_image,
        last_log_by = p_last_log_by
    WHERE customer_id_record_id = p_customer_id_record_id;
END$$

DROP PROCEDURE IF EXISTS `updateCustomerImage`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCustomerImage` (IN `p_customer_id` INT, IN `p_customer_image` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    UPDATE customer
    SET customer_image = p_customer_image,
        last_log_by = p_last_log_by
    WHERE customer_id = p_customer_id;
END$$

DROP PROCEDURE IF EXISTS `updateCustomerInquiry`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCustomerInquiry` (IN `p_customer_inquiry_id` INT, IN `p_customer_name` VARCHAR(500), IN `p_email` VARCHAR(500), IN `p_phone` VARCHAR(50), IN `p_subject` VARCHAR(500), IN `p_message` LONGTEXT, IN `p_last_log_by` INT)   BEGIN
    UPDATE customer_inquiry
    SET customer_name = p_customer_name,
        email = p_email,
        phone = p_phone,
        subject = p_subject,
        message = p_message,
        last_log_by = p_last_log_by
    WHERE customer_inquiry_id = p_customer_inquiry_id;
END$$

DROP PROCEDURE IF EXISTS `updateCustomerInquiryStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCustomerInquiryStatus` (IN `p_customer_inquiry_id` INT, IN `p_inquiry_status` VARCHAR(50), IN `p_last_log_by` INT)   BEGIN    
    IF p_inquiry_status = 'In-Progress' THEN
        UPDATE customer_inquiry
        SET inquiry_status = p_inquiry_status,
            in_progress_date = NOW(),
            in_progress_by = p_last_log_by,
            last_log_by = p_last_log_by
        WHERE customer_inquiry_id = p_customer_inquiry_id;
    ELSEIF p_inquiry_status = 'Resolved' THEN
        UPDATE customer_inquiry
        SET inquiry_status = p_inquiry_status,
            resolved_date = NOW(),
            resolved_by = p_last_log_by,
            last_log_by = p_last_log_by
        WHERE customer_inquiry_id = p_customer_inquiry_id;
    ELSE
        UPDATE customer_inquiry
        SET inquiry_status = p_inquiry_status,
            closed_date = NOW(),
            closed_by = p_last_log_by,
            last_log_by = p_last_log_by
        WHERE customer_inquiry_id = p_customer_inquiry_id;
    END IF;
END$$

DROP PROCEDURE IF EXISTS `updateCustomerPrivateInformation`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCustomerPrivateInformation` (IN `p_customer_id` INT, IN `p_full_name` VARCHAR(1000), IN `p_first_name` VARCHAR(300), IN `p_middle_name` VARCHAR(300), IN `p_last_name` VARCHAR(300), IN `p_suffix` VARCHAR(10), IN `p_nickname` VARCHAR(100), IN `p_civil_status_id` INT, IN `p_civil_status_name` VARCHAR(100), IN `p_gender_id` INT, IN `p_gender_name` VARCHAR(100), IN `p_birthday` DATE, IN `p_birth_place` VARCHAR(1000), IN `p_last_log_by` INT)   BEGIN
    UPDATE customer
    SET full_name = p_full_name,
        first_name = p_first_name,
        middle_name = p_middle_name,
        last_name = p_last_name,
        suffix = p_suffix,
        nickname = p_nickname,
        civil_status_id = p_civil_status_id,
        civil_status_name = p_civil_status_name,
        gender_id = p_gender_id,
        gender_name = p_gender_name,
        birthday = p_birthday,
        birth_place = p_birth_place,
        last_log_by = p_last_log_by
    WHERE customer_id = p_customer_id;
END$$

DROP PROCEDURE IF EXISTS `updateCustomerStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateCustomerStatus` (IN `p_customer_id` INT, IN `p_customer_status` VARCHAR(50), IN `p_last_log_by` INT)   BEGIN
    UPDATE customer
    SET customer_status = p_customer_status,
        archive_date = NOW(),
        last_log_by = p_last_log_by
    WHERE customer_id = p_customer_id;
END$$

DROP PROCEDURE IF EXISTS `updateDepartment`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateDepartment` (IN `p_department_id` INT, IN `p_department_name` VARCHAR(100), IN `p_parent_department_id` INT, IN `p_parent_department_name` VARCHAR(100), IN `p_manager_id` INT, IN `p_manager_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE employee
    SET department_name = p_department_name,
        last_log_by = p_last_log_by
    WHERE department_id = p_department_id;

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
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE employee
    SET departure_reason_name = p_departure_reason_name
    WHERE departure_reason_id = p_departure_reason_id;

    UPDATE departure_reason
    SET departure_reason_name = p_departure_reason_name,
        last_log_by = p_last_log_by
    WHERE departure_reason_id = p_departure_reason_id;

    COMMIT;
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

DROP PROCEDURE IF EXISTS `updateEmployee`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmployee` (IN `p_employee_id` INT, IN `p_full_name` VARCHAR(1000), IN `p_first_name` VARCHAR(300), IN `p_middle_name` VARCHAR(300), IN `p_last_name` VARCHAR(300), IN `p_suffix` VARCHAR(10), IN `p_nickname` VARCHAR(100), IN `p_civil_status_id` INT, IN `p_civil_status_name` VARCHAR(100), IN `p_gender_id` INT, IN `p_gender_name` VARCHAR(100), IN `p_religion_id` INT, IN `p_religion_name` VARCHAR(100), IN `p_blood_type_id` INT, IN `p_blood_type_name` VARCHAR(100), IN `p_birthday` DATE, IN `p_birth_place` VARCHAR(1000), IN `p_height` FLOAT, IN `p_weight` FLOAT, IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE work_information
    SET manager_name = p_full_name,
        last_log_by = p_last_log_by
    WHERE manager_id = p_employee_id;

    UPDATE employee
    SET full_name = p_full_name,
        first_name = p_first_name,
        middle_name = p_middle_name,
        last_name = p_last_name,
        suffix = p_suffix,
        nickname = p_nickname,
        civil_status_id = p_civil_status_id,
        civil_status_name = p_civil_status_name,
        gender_id = p_gender_id,
        gender_name = p_gender_name,
        religion_id = p_religion_id,
        religion_name = p_religion_name,
        blood_type_id = p_blood_type_id,
        blood_type_name = p_blood_type_name,
        birthday = p_birthday,
        birth_place = p_birth_place,
        height = p_height,
        weight = p_weight,
        last_log_by = p_last_log_by
    WHERE employee_id = p_employee_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateEmployeeAbout`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmployeeAbout` (IN `p_employee_id` INT, IN `p_about` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    UPDATE employee
    SET about = p_about,
        last_log_by = p_last_log_by
    WHERE employee_id = p_employee_id;
END$$

DROP PROCEDURE IF EXISTS `updateEmployeeAddress`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmployeeAddress` (IN `p_employee_address_id` INT, IN `p_employee_id` INT, IN `p_address_type_id` INT, IN `p_address_type_name` VARCHAR(100), IN `p_address` VARCHAR(1000), IN `p_city_id` INT, IN `p_city_name` VARCHAR(100), IN `p_state_id` INT, IN `p_state_name` VARCHAR(100), IN `p_country_id` INT, IN `p_country_name` VARCHAR(100), IN `p_telephone` VARCHAR(50), IN `p_mobile` VARCHAR(50), IN `p_email` VARCHAR(200), IN `p_last_log_by` INT)   BEGIN
    UPDATE employee_address
    SET employee_id = p_employee_id,
        address_type_id = p_address_type_id,
        address_type_name = p_address_type_name,
        address = p_address,
        city_id = p_city_id,
        city_name = p_city_name,
        state_id = p_state_id,
        state_name = p_state_name,
        country_id = p_country_id,
        country_name = p_country_name,
        telephone = p_telephone,
        mobile = p_mobile,
        email = p_email,
        last_log_by = p_last_log_by
    WHERE employee_address_id = p_employee_address_id;
END$$

DROP PROCEDURE IF EXISTS `updateEmployeeAddressDefault`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmployeeAddressDefault` (IN `p_employee_address_id` INT, IN `p_employee_id` INT, IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE employee_address
    SET default_address = 'Alternate',
        last_log_by = p_last_log_by
    WHERE employee_id = p_employee_id AND default_address = 'Primary';

    UPDATE employee_address
    SET default_address = 'Primary',
        last_log_by = p_last_log_by
    WHERE employee_address_id = p_employee_address_id AND employee_id = p_employee_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateEmployeeBankAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmployeeBankAccount` (IN `p_employee_bank_account_id` INT, IN `p_employee_id` INT, IN `p_bank_id` INT, IN `p_bank_name` VARCHAR(100), IN `p_bank_account_type_id` INT, IN `p_bank_account_type_name` VARCHAR(100), IN `p_account_number` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE employee_bank_account
    SET employee_id = p_employee_id,
        bank_id = p_bank_id,
        bank_name = p_bank_name,
        bank_account_type_id = p_bank_account_type_id,
        bank_account_type_name = p_bank_account_type_name,
        account_number = p_account_number,
        last_log_by = p_last_log_by
    WHERE employee_bank_account_id = p_employee_bank_account_id;
END$$

DROP PROCEDURE IF EXISTS `updateEmployeeEducation`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmployeeEducation` (IN `p_employee_education_id` INT, IN `p_employee_id` INT, IN `p_school` VARCHAR(100), IN `p_degree` VARCHAR(100), IN `p_field_of_study` VARCHAR(100), IN `p_start_month` VARCHAR(20), IN `p_start_year` VARCHAR(20), IN `p_end_month` VARCHAR(20), IN `p_end_year` VARCHAR(20), IN `p_activities_societies` VARCHAR(5000), IN `p_education_description` VARCHAR(5000), IN `p_last_log_by` INT)   BEGIN
    UPDATE employee_education
    SET employee_id = p_employee_id,
        school = p_school,
        degree = p_degree,
        field_of_study = p_field_of_study,
        start_month = p_start_month,
        start_year = p_start_year,
        end_month = p_end_month,
        end_year = p_end_year,
        activities_societies = p_activities_societies,
        education_description = p_education_description,
        last_log_by = p_last_log_by
    WHERE employee_education_id = p_employee_education_id;
END$$

DROP PROCEDURE IF EXISTS `updateEmployeeEmergencyContact`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmployeeEmergencyContact` (IN `p_employee_emergency_contact_id` INT, IN `p_employee_id` INT, IN `p_emergency_contact_name` VARCHAR(500), IN `p_relation_id` INT, IN `p_relation_name` VARCHAR(100), IN `p_telephone` VARCHAR(50), IN `p_mobile` VARCHAR(50), IN `p_email` VARCHAR(200), IN `p_last_log_by` INT)   BEGIN
    UPDATE employee_emergency_contact
    SET employee_id = p_employee_id,
        emergency_contact_name = p_emergency_contact_name,
        relation_id = p_relation_id,
        relation_name = p_relation_name,
        telephone = p_telephone,
        mobile = p_mobile,
        email = p_email,
        last_log_by = p_last_log_by
    WHERE employee_emergency_contact_id = p_employee_emergency_contact_id;
END$$

DROP PROCEDURE IF EXISTS `updateEmployeeEmploymentStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmployeeEmploymentStatus` (IN `p_employee_id` INT, IN `p_employment_status` VARCHAR(50), IN `p_offboard_date` DATE, IN `p_departure_reason_id` INT, IN `p_departure_reason_name` VARCHAR(100), IN `p_detailed_departure_reason` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    UPDATE employee
    SET employment_status = p_employment_status,
        offboard_date = p_offboard_date,
        departure_reason_id = p_departure_reason_id,
        departure_reason_name = p_departure_reason_name,
        detailed_departure_reason = p_detailed_departure_reason,
        last_log_by = p_last_log_by
    WHERE employee_id = p_employee_id;
END$$

DROP PROCEDURE IF EXISTS `updateEmployeeExperience`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmployeeExperience` (IN `p_employee_experience_id` INT, IN `p_employee_id` INT, IN `p_job_title` VARCHAR(100), IN `p_employment_type_id` INT, IN `p_employment_type_name` VARCHAR(100), IN `p_company_name` VARCHAR(200), IN `p_location` VARCHAR(200), IN `p_employment_location_type_id` INT, IN `p_employment_location_type_name` VARCHAR(100), IN `p_start_month` VARCHAR(20), IN `p_start_year` VARCHAR(20), IN `p_end_month` VARCHAR(20), IN `p_end_year` VARCHAR(20), IN `p_job_description` VARCHAR(5000), IN `p_last_log_by` INT)   BEGIN
    UPDATE employee_experience
    SET employee_id = p_employee_id,
        job_title = p_job_title,
        employment_type_id = p_employment_type_id,
        employment_type_name = p_employment_type_name,
        company_name = p_company_name,
        location = p_location,
        employment_location_type_id = p_employment_location_type_id,
        employment_location_type_name = p_employment_location_type_name,
        start_month = p_start_month,
        start_year = p_start_year,
        end_month = p_end_month,
        end_year = p_end_year,
        job_description = p_job_description,
        last_log_by = p_last_log_by
    WHERE employee_experience_id = p_employee_experience_id;
END$$

DROP PROCEDURE IF EXISTS `updateEmployeeHRSettings`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmployeeHRSettings` (IN `p_employee_id` INT, IN `p_badge_id` VARCHAR(200), IN `p_employment_type_id` INT, IN `p_employment_type_name` VARCHAR(100), IN `p_pin_code` VARCHAR(500), IN `p_onboard_date` DATE, IN `p_last_log_by` INT)   BEGIN
    UPDATE employee
    SET badge_id = p_badge_id,
        employment_type_id = p_employment_type_id,
        employment_type_name = p_employment_type_name,
        pin_code = p_pin_code,
        onboard_date = p_onboard_date,
        last_log_by = p_last_log_by
    WHERE employee_id = p_employee_id;
END$$

DROP PROCEDURE IF EXISTS `updateEmployeeIDRecord`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmployeeIDRecord` (IN `p_employee_id_record_id` INT, IN `p_employee_id` INT, IN `p_id_type_id` INT, IN `p_id_type_name` VARCHAR(100), IN `p_id_number` VARCHAR(100), IN `p_issue_date` DATE, IN `p_expiration_date` DATE, IN `p_issuing_authority` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE employee_id_record
    SET employee_id = p_employee_id,
        id_type_id = p_id_type_id,
        id_type_name = p_id_type_name,
        id_number = p_id_number,
        issue_date = p_issue_date,
        expiration_date = p_expiration_date,
        issuing_authority = p_issuing_authority,
        last_log_by = p_last_log_by
    WHERE employee_id_record_id = p_employee_id_record_id;
END$$

DROP PROCEDURE IF EXISTS `updateEmployeeIDRecordImage`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmployeeIDRecordImage` (IN `p_employee_id_record_id` INT, IN `p_id_image` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    UPDATE employee_id_record
    SET id_image = p_id_image,
        last_log_by = p_last_log_by
    WHERE employee_id_record_id = p_employee_id_record_id;
END$$

DROP PROCEDURE IF EXISTS `updateEmployeeImage`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmployeeImage` (IN `p_employee_id` INT, IN `p_employee_image` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    UPDATE employee
    SET employee_image = p_employee_image,
        last_log_by = p_last_log_by
    WHERE employee_id = p_employee_id;
END$$

DROP PROCEDURE IF EXISTS `updateEmployeeLanguage`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmployeeLanguage` (IN `p_employee_language_id` INT, IN `p_employee_id` INT, IN `p_language_id` INT, IN `p_language_name` VARCHAR(100), IN `p_language_proficiency_id` INT, IN `p_language_proficiency_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE employee_language
    SET employee_id = p_employee_id,
        language_id = p_language_id,
        language_name = p_language_name,
        language_proficiency_id = p_language_proficiency_id,
        language_proficiency_name = p_language_proficiency_name,
        last_log_by = p_last_log_by
    WHERE employee_language_id = p_employee_language_id;
END$$

DROP PROCEDURE IF EXISTS `updateEmployeeLicense`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmployeeLicense` (IN `p_employee_license_id` INT, IN `p_employee_id` INT, IN `p_licensed_profession` VARCHAR(200), IN `p_licensing_body` VARCHAR(200), IN `p_license_number` VARCHAR(200), IN `p_issue_date` DATE, IN `p_expiration_date` DATE, IN `p_last_log_by` INT)   BEGIN
    UPDATE employee_license
    SET employee_id = p_employee_id,
        licensed_profession = p_licensed_profession,
        licensing_body = p_licensing_body,
        license_number = p_license_number,
        issue_date = p_issue_date,
        expiration_date = p_expiration_date,
        last_log_by = p_last_log_by
    WHERE employee_license_id = p_employee_license_id;
END$$

DROP PROCEDURE IF EXISTS `updateEmployeePrivateInformation`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmployeePrivateInformation` (IN `p_employee_id` INT, IN `p_full_name` VARCHAR(1000), IN `p_first_name` VARCHAR(300), IN `p_middle_name` VARCHAR(300), IN `p_last_name` VARCHAR(300), IN `p_suffix` VARCHAR(10), IN `p_nickname` VARCHAR(100), IN `p_civil_status_id` INT, IN `p_civil_status_name` VARCHAR(100), IN `p_gender_id` INT, IN `p_gender_name` VARCHAR(100), IN `p_religion_id` INT, IN `p_religion_name` VARCHAR(100), IN `p_blood_type_id` INT, IN `p_blood_type_name` VARCHAR(100), IN `p_birthday` DATE, IN `p_birth_place` VARCHAR(1000), IN `p_height` FLOAT, IN `p_weight` FLOAT, IN `p_last_log_by` INT)   BEGIN
    UPDATE employee
    SET full_name = p_full_name,
        first_name = p_first_name,
        middle_name = p_middle_name,
        last_name = p_last_name,
        suffix = p_suffix,
        nickname = p_nickname,
        civil_status_id = p_civil_status_id,
        civil_status_name = p_civil_status_name,
        gender_id = p_gender_id,
        gender_name = p_gender_name,
        religion_id = p_religion_id,
        religion_name = p_religion_name,
        blood_type_id = p_blood_type_id,
        blood_type_name = p_blood_type_name,
        birthday = p_birthday,
        birth_place = p_birth_place,
        height = p_height,
        weight = p_weight,
        last_log_by = p_last_log_by
    WHERE employee_id = p_employee_id;
END$$

DROP PROCEDURE IF EXISTS `updateEmployeeWorkInformation`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmployeeWorkInformation` (IN `p_employee_id` INT, IN `p_company_id` INT, IN `p_company_name` VARCHAR(100), IN `p_department_id` INT, IN `p_department_name` VARCHAR(100), IN `p_job_position_id` INT, IN `p_job_position_name` VARCHAR(100), IN `p_work_location_id` INT, IN `p_work_location_name` VARCHAR(100), IN `p_manager_id` INT, IN `p_manager_name` VARCHAR(100), IN `p_work_schedule_id` INT, IN `p_work_schedule_name` VARCHAR(100), IN `p_home_work_distance` DOUBLE, IN `p_time_off_approver_id` INT, IN `p_time_off_approver_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE employee
    SET company_id = p_company_id,
        company_name = p_company_name,
        department_id = p_department_id,
        department_name = p_department_name,
        job_position_id = p_job_position_id,
        job_position_name = p_job_position_name,
        work_location_id = p_work_location_id,
        work_location_name = p_work_location_name,
        manager_id = p_manager_id,
        manager_name = p_manager_name,
        work_schedule_id = p_work_schedule_id,
        work_schedule_name = p_work_schedule_name,
        home_work_distance = p_home_work_distance,
        time_off_approver_id = p_time_off_approver_id,
        time_off_approver_name = p_time_off_approver_name,
        last_log_by = p_last_log_by
    WHERE employee_id = p_employee_id;
END$$

DROP PROCEDURE IF EXISTS `updateEmployeeWorkPermit`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmployeeWorkPermit` (IN `p_employee_id` INT, IN `p_visa_number` VARCHAR(50), IN `p_work_permit_number` VARCHAR(50), IN `p_visa_expiration_date` DATE, IN `p_work_permit_expiration_date` DATE, IN `p_last_log_by` INT)   BEGIN
    UPDATE employee
    SET visa_number = p_visa_number,
        work_permit_number = p_work_permit_number,
        visa_expiration_date = p_visa_expiration_date,
        work_permit_expiration_date = p_work_permit_expiration_date,
        last_log_by = p_last_log_by
    WHERE employee_id = p_employee_id;
END$$

DROP PROCEDURE IF EXISTS `updateEmploymentLocationType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmploymentLocationType` (IN `p_employment_location_type_id` INT, IN `p_employment_location_type_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;

    END;

    START TRANSACTION;

    UPDATE employee_experience
    SET employment_location_type_name = p_employment_location_type_name,
        last_log_by = p_last_log_by
    WHERE employment_location_type_id = p_employment_location_type_id;

    UPDATE employment_location_type
    SET employment_location_type_name = p_employment_location_type_name,
        last_log_by = p_last_log_by
    WHERE employment_location_type_id = p_employment_location_type_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateEmploymentType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateEmploymentType` (IN `p_employment_type_id` INT, IN `p_employment_type_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE employee
    SET employment_type_name = p_employment_type_name,
        last_log_by = p_last_log_by
    WHERE employment_type_id = p_employment_type_id;

    UPDATE employee_experience
    SET employment_type_name = p_employment_type_name,
        last_log_by = p_last_log_by
    WHERE employment_type_id = p_employment_type_id;

    UPDATE employment_type
    SET employment_type_name = p_employment_type_name,
        last_log_by = p_last_log_by
    WHERE employment_type_id = p_employment_type_id;

    COMMIT;
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

DROP PROCEDURE IF EXISTS `updateFooter`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateFooter` (IN `p_footer_id` INT, IN `p_footer_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE footer
    SET footer_name = p_footer_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE footer_id = p_footer_id;
END$$

DROP PROCEDURE IF EXISTS `updateFooterPublishStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateFooterPublishStatus` (IN `p_footer_id` INT, IN `p_publish_status` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE footer
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE footer_id = p_footer_id;
END$$

DROP PROCEDURE IF EXISTS `updateGender`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateGender` (IN `p_gender_id` INT, IN `p_gender_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE employee
    SET gender_name = p_gender_name,
        last_log_by = p_last_log_by
    WHERE gender_id = p_gender_id;

    UPDATE gender
    SET gender_name = p_gender_name,
        last_log_by = p_last_log_by
    WHERE gender_id = p_gender_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateHeader`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateHeader` (IN `p_header_id` INT, IN `p_header_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE header
    SET header_name = p_header_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE header_id = p_header_id;
END$$

DROP PROCEDURE IF EXISTS `updateHeaderPublishStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateHeaderPublishStatus` (IN `p_header_id` INT, IN `p_publish_status` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE header
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE header_id = p_header_id;
END$$

DROP PROCEDURE IF EXISTS `updateIDType`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateIDType` (IN `p_id_type_id` INT, IN `p_id_type_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE id_type
    SET id_type_name = p_id_type_name,
        last_log_by = p_last_log_by
    WHERE id_type_id = p_id_type_id;
END$$

DROP PROCEDURE IF EXISTS `updateImageGallery`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateImageGallery` (IN `p_image_gallery_id` INT, IN `p_image_gallery_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE image_gallery
    SET image_gallery_name = p_image_gallery_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE image_gallery_id = p_image_gallery_id;
END$$

DROP PROCEDURE IF EXISTS `updateImageGalleryItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateImageGalleryItem` (IN `p_image_gallery_item_id` INT, IN `p_image_gallery_id` INT, IN `p_image_gallery_title` VARCHAR(500), IN `p_image_gallery_image` VARCHAR(500), IN `p_order_sequence` INT, IN `p_last_log_by` INT)   BEGIN
    IF p_image_gallery_image IS NOT NULL AND p_image_gallery_image != '' THEN
        UPDATE image_gallery_item
        SET image_gallery_id = p_image_gallery_id,
            image_gallery_title = p_image_gallery_title,
            image_gallery_image = p_image_gallery_image,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE image_gallery_item_id = p_image_gallery_item_id;
    ELSE
        UPDATE image_gallery_item
        SET image_gallery_id = p_image_gallery_id,
            image_gallery_title = p_image_gallery_title,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE image_gallery_item_id = p_image_gallery_item_id;
    END IF;   
END$$

DROP PROCEDURE IF EXISTS `updateImageGalleryPublishStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateImageGalleryPublishStatus` (IN `p_image_gallery_id` INT, IN `p_publish_status` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE image_gallery
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE image_gallery_id = p_image_gallery_id;
END$$

DROP PROCEDURE IF EXISTS `updateJobPosition`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateJobPosition` (IN `p_job_position_id` INT, IN `p_job_position_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE employee
    SET job_position_name = p_job_position_name,
        last_log_by = p_last_log_by
    WHERE job_position_id = p_job_position_id;

    UPDATE job_position
    SET job_position_name = p_job_position_name,
        last_log_by = p_last_log_by
    WHERE job_position_id = p_job_position_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateLanguage`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateLanguage` (IN `p_language_id` INT, IN `p_language_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE employee_language
    SET language_name = p_language_name,
        last_log_by = p_last_log_by
    WHERE language_id = p_language_id;

   UPDATE language
    SET language_name = p_language_name,
        last_log_by = p_last_log_by
    WHERE language_id = p_language_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateLanguageProficiency`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateLanguageProficiency` (IN `p_language_proficiency_id` INT, IN `p_language_proficiency_name` VARCHAR(100), IN `p_language_proficiency_description` VARCHAR(200), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE employee_language
    SET language_proficiency_name = p_language_proficiency_name,
        last_log_by = p_last_log_by
    WHERE language_proficiency_id = p_language_proficiency_id;

    UPDATE language_proficiency
    SET language_proficiency_name = p_language_proficiency_name,
        language_proficiency_description = p_language_proficiency_description,
        last_log_by = p_last_log_by
    WHERE language_proficiency_id = p_language_proficiency_id;

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

DROP PROCEDURE IF EXISTS `updatePageTitle`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updatePageTitle` (IN `p_page_title_id` INT, IN `p_page_title_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_page_title` VARCHAR(500), IN `p_page_heading` VARCHAR(500), IN `p_page_title_image` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    IF p_page_title_image IS NOT NULL AND p_page_title_image != '' THEN
        UPDATE page_title
        SET page_title_name = p_page_title_name,
            description = p_description,
            block_style_id = p_block_style_id,
            block_style_name = p_block_style_name,
            page_title = p_page_title,
            page_heading = p_page_heading,
            page_title_image = p_page_title_image,
            last_log_by = p_last_log_by
        WHERE page_title_id = p_page_title_id;
    ELSE
        UPDATE page_title
        SET page_title_name = p_page_title_name,
            description = p_description,
            block_style_id = p_block_style_id,
            block_style_name = p_block_style_name,
            page_title = p_page_title,
            page_heading = p_page_heading,
            last_log_by = p_last_log_by
        WHERE page_title_id = p_page_title_id;
    END IF;  
END$$

DROP PROCEDURE IF EXISTS `updatePageTitleImage`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updatePageTitleImage` (IN `p_page_title_id` INT, IN `p_page_title_image` VARCHAR(500), IN `p_last_log_by` INT)   BEGIN
    UPDATE page_title
    SET page_title_image = p_page_title_image,
        last_log_by = p_last_log_by
    WHERE page_title_id = p_page_title_id;
END$$

DROP PROCEDURE IF EXISTS `updatePageTitlePublishStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updatePageTitlePublishStatus` (IN `p_page_title_id` INT, IN `p_publish_status` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE page_title
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE page_title_id = p_page_title_id;
END$$

DROP PROCEDURE IF EXISTS `updatePricingTable`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updatePricingTable` (IN `p_pricing_table_id` INT, IN `p_pricing_table_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE pricing_table
    SET pricing_table_name = p_pricing_table_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE pricing_table_id = p_pricing_table_id;
END$$

DROP PROCEDURE IF EXISTS `updatePricingTablePublishStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updatePricingTablePublishStatus` (IN `p_pricing_table_id` INT, IN `p_publish_status` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE pricing_table
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE pricing_table_id = p_pricing_table_id;
END$$

DROP PROCEDURE IF EXISTS `updateProcesStep`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateProcesStep` (IN `p_process_step_id` INT, IN `p_process_step_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE process_step
    SET process_step_name = p_process_step_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE process_step_id = p_process_step_id;
END$$

DROP PROCEDURE IF EXISTS `updateProcesStepItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateProcesStepItem` (IN `p_process_step_item_id` INT, IN `p_process_step_id` INT, IN `p_process_step_title` VARCHAR(500), IN `p_process_step_heading` VARCHAR(500), IN `p_process_step_link` VARCHAR(500), IN `p_process_step_image` VARCHAR(500), IN `p_order_sequence` INT, IN `p_last_log_by` INT)   BEGIN
    IF p_process_step_image IS NOT NULL AND p_process_step_image != '' THEN
        UPDATE process_step_item
        SET process_step_id = p_process_step_id,
            process_step_title = p_process_step_title,
            process_step_heading = p_process_step_heading,
            process_step_link = p_process_step_link,
            process_step_image = p_process_step_image,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE process_step_item_id = p_process_step_item_id;
    ELSE
        UPDATE process_step_item
        SET process_step_id = p_process_step_id,
            process_step_title = p_process_step_title,
            process_step_heading = p_process_step_heading,
            process_step_link = p_process_step_link,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE process_step_item_id = p_process_step_item_id;
    END IF;   
END$$

DROP PROCEDURE IF EXISTS `updateProcesStepPublishStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateProcesStepPublishStatus` (IN `p_process_step_id` INT, IN `p_publish_status` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE process_step
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE process_step_id = p_process_step_id;
END$$

DROP PROCEDURE IF EXISTS `updateRegistrationVerification`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateRegistrationVerification` (IN `p_user_account_id` INT, IN `p_registration_verification_token` VARCHAR(255), IN `p_registration_verification_token_expiry_date` DATETIME, IN `p_last_log_by` INT)   BEGIN
    UPDATE user_account
    SET registration_verification_token = p_registration_verification_token,
        registration_verification_token_expiry_date = p_registration_verification_token_expiry_date,
        last_log_by = p_last_log_by
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
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE employee
    SET religion_name = p_religion_name,
        last_log_by = p_last_log_by
    WHERE religion_id = p_religion_id;

    UPDATE religion
    SET religion_name = p_religion_name,
        last_log_by = p_last_log_by
    WHERE religion_id = p_religion_id;

    COMMIT;
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

DROP PROCEDURE IF EXISTS `updateSections`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSections` (IN `p_sections_id` INT, IN `p_sections_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE sections
    SET sections_name = p_sections_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE sections_id = p_sections_id;
END$$

DROP PROCEDURE IF EXISTS `updateSectionsPublishStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSectionsPublishStatus` (IN `p_sections_id` INT, IN `p_publish_status` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE sections
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE sections_id = p_sections_id;
END$$

DROP PROCEDURE IF EXISTS `updateSecuritySetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSecuritySetting` (IN `p_max_failed_login` INT, IN `p_max_failed_otp_attempt` INT, IN `p_password_expiry_duration` INT, IN `p_otp_duration` INT, IN `p_reset_password_token_duration` INT, IN `p_session_inactivity_limit` INT, IN `p_password_recovery_link` VARCHAR(1000), IN `p_registration_verification_token_duration` INT, IN `p_last_log_by` INT)   BEGIN
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

    UPDATE security_setting
    SET value = p_registration_verification_token_duration,
        last_log_by = p_last_log_by
    WHERE security_setting_id = 8;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateServicesBox`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateServicesBox` (IN `p_services_box_id` INT, IN `p_services_box_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE services_box
    SET services_box_name = p_services_box_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE services_box_id = p_services_box_id;
END$$

DROP PROCEDURE IF EXISTS `updateServicesBoxItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateServicesBoxItem` (IN `p_services_box_item_id` INT, IN `p_services_box_id` INT, IN `p_services_box_title` VARCHAR(500), IN `p_services_box_heading` VARCHAR(500), IN `p_services_box_paragraph` LONGTEXT, IN `p_call_to_action_button_text` VARCHAR(100), IN `p_call_to_action_button_link` VARCHAR(500), IN `p_services_box_image` VARCHAR(500), IN `p_order_sequence` INT, IN `p_last_log_by` INT)   BEGIN
    IF p_services_box_image IS NOT NULL AND p_services_box_image != '' THEN
        UPDATE services_box_item
        SET services_box_id = p_services_box_id,
            services_box_title = p_services_box_title,
            services_box_heading = p_services_box_heading,
            services_box_paragraph = p_services_box_paragraph,
            call_to_action_button_text = p_call_to_action_button_text,
            call_to_action_button_link = p_call_to_action_button_link,
            services_box_image = p_services_box_image,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE services_box_item_id = p_services_box_item_id;
    ELSE
        UPDATE services_box_item
        SET services_box_id = p_services_box_id,
            services_box_title = p_services_box_title,
            services_box_heading = p_services_box_heading,
            services_box_paragraph = p_services_box_paragraph,
            call_to_action_button_text = p_call_to_action_button_text,
            call_to_action_button_link = p_call_to_action_button_link,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE services_box_item_id = p_services_box_item_id;
    END IF;   
END$$

DROP PROCEDURE IF EXISTS `updateServicesBoxPublishStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateServicesBoxPublishStatus` (IN `p_services_box_id` INT, IN `p_publish_status` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE services_box
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE services_box_id = p_services_box_id;
END$$

DROP PROCEDURE IF EXISTS `updateSlider`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSlider` (IN `p_slider_id` INT, IN `p_slider_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE slider
    SET slider_name = p_slider_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE slider_id = p_slider_id;
END$$

DROP PROCEDURE IF EXISTS `updateSliderItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSliderItem` (IN `p_slider_item_id` INT, IN `p_slider_id` INT, IN `p_slider_title` VARCHAR(500), IN `p_slider_heading` VARCHAR(500), IN `p_slider_paragraph` LONGTEXT, IN `p_call_to_action_button_1_text` VARCHAR(100), IN `p_call_to_action_button_1_link` VARCHAR(500), IN `p_call_to_action_button_2_text` VARCHAR(100), IN `p_call_to_action_button_2_link` VARCHAR(500), IN `p_slider_image` VARCHAR(500), IN `p_order_sequence` INT, IN `p_last_log_by` INT)   BEGIN
    IF p_slider_image IS NOT NULL AND p_slider_image != '' THEN
        UPDATE slider_item
        SET slider_id = p_slider_id,
            slider_title = p_slider_title,
            slider_heading = p_slider_heading,
            slider_paragraph = p_slider_paragraph,
            call_to_action_button_1_text = p_call_to_action_button_1_text,
            call_to_action_button_1_link = p_call_to_action_button_1_link,
            call_to_action_button_2_text = p_call_to_action_button_2_text,
            call_to_action_button_2_link = p_call_to_action_button_2_link,
            slider_image = p_slider_image,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE slider_item_id = p_slider_item_id;
    ELSE
        UPDATE slider_item
        SET slider_id = p_slider_id,
            slider_title = p_slider_title,
            slider_heading = p_slider_heading,
            slider_paragraph = p_slider_paragraph,
            call_to_action_button_1_text = p_call_to_action_button_1_text,
            call_to_action_button_1_link = p_call_to_action_button_1_link,
            call_to_action_button_2_text = p_call_to_action_button_2_text,
            call_to_action_button_2_link = p_call_to_action_button_2_link,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE slider_item_id = p_slider_item_id;
    END IF;   
END$$

DROP PROCEDURE IF EXISTS `updateSliderPublishStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSliderPublishStatus` (IN `p_slider_id` INT, IN `p_publish_status` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE slider
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE slider_id = p_slider_id;
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

    UPDATE employee_address
    SET state_name = p_state_name,
        country_id = p_country_id,
        country_name = p_country_name,
        last_log_by = p_last_log_by
    WHERE state_id = p_state_id;

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

DROP PROCEDURE IF EXISTS `updateSystemSetting`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateSystemSetting` (IN `p_allow_registration` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE system_setting
    SET value = p_allow_registration,
        last_log_by = p_last_log_by
    WHERE system_setting_id = 1;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `updateTestimonial`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateTestimonial` (IN `p_testimonial_id` INT, IN `p_testimonial_name` VARCHAR(100), IN `p_description` VARCHAR(100), IN `p_block_style_id` INT, IN `p_block_style_name` VARCHAR(100), IN `p_last_log_by` INT)   BEGIN
    UPDATE testimonial
    SET testimonial_name = p_testimonial_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE testimonial_id = p_testimonial_id;
END$$

DROP PROCEDURE IF EXISTS `updateTestimonialItem`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateTestimonialItem` (IN `p_testimonial_item_id` INT, IN `p_testimonial_id` INT, IN `p_testimonial_client` VARCHAR(500), IN `p_testimonial_title` VARCHAR(500), IN `p_testimonial_paragraph` LONGTEXT, IN `p_rating` FLOAT, IN `p_testimonial_image` VARCHAR(500), IN `p_order_sequence` INT, IN `p_last_log_by` INT)   BEGIN
    IF p_testimonial_image IS NOT NULL AND p_testimonial_image != '' THEN
        UPDATE testimonial_item
        SET testimonial_id = p_testimonial_id,
            testimonial_client = p_testimonial_client,
            testimonial_title = p_testimonial_title,
            testimonial_paragraph = p_testimonial_paragraph,
            rating = p_rating,
            testimonial_image = p_testimonial_image,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE testimonial_item_id = p_testimonial_item_id;
    ELSE
        UPDATE testimonial_item
        SET testimonial_id = p_testimonial_id,
            testimonial_client = p_testimonial_client,
            testimonial_title = p_testimonial_title,
            testimonial_paragraph = p_testimonial_paragraph,
            rating = p_rating,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE testimonial_item_id = p_testimonial_item_id;
    END IF;   
END$$

DROP PROCEDURE IF EXISTS `updateTestimonialPublishStatus`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateTestimonialPublishStatus` (IN `p_testimonial_id` INT, IN `p_publish_status` VARCHAR(5), IN `p_last_log_by` INT)   BEGIN
    UPDATE testimonial
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE testimonial_id = p_testimonial_id;
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

    UPDATE work_information
    SET time_off_approver_name = p_file_as,
        last_log_by = p_last_log_by
    WHERE time_off_approver_id = p_user_account_id;

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

DROP PROCEDURE IF EXISTS `updateUserAccountLinkedAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateUserAccountLinkedAccount` (IN `p_user_account_id` INT, IN `p_user_type` VARCHAR(20), IN `p_linked_id` INT, IN `p_last_log_by` INT)   BEGIN
    UPDATE user_account
    SET user_type = p_user_type,
        linked_id = p_linked_id,
        last_log_by = p_last_log_by
    WHERE user_account_id = p_user_account_id;
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

DROP PROCEDURE IF EXISTS `updateVoucher`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateVoucher` (IN `p_voucher_id` INT, IN `p_voucher_name` VARCHAR(100), IN `p_voucher_code` VARCHAR(20), IN `p_voucher_usage_start_date` DATE, IN `p_voucher_usage_end_date` DATE, IN `p_discount_type` VARCHAR(20), IN `p_discount_amount` DOUBLE, IN `p_minimum_booking_amount` DOUBLE, IN `p_voucher_quantity` INT, IN `p_available_voucher` INT, IN `p_last_log_by` INT)   BEGIN
    UPDATE voucher
    SET voucher_name = p_voucher_name,
        voucher_code = p_voucher_code,
        voucher_usage_start_date = p_voucher_usage_start_date,
        voucher_usage_end_date = p_voucher_usage_end_date,
        discount_type = p_discount_type,
        discount_amount = p_discount_amount,
        minimum_booking_amount = p_minimum_booking_amount,
        voucher_quantity = p_voucher_quantity,
        available_voucher = p_available_voucher,
        last_log_by = p_last_log_by
    WHERE voucher_id = p_voucher_id;
END$$

DROP PROCEDURE IF EXISTS `updateWebsite`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `updateWebsite` (IN `p_website_id` INT, IN `p_website_name` VARCHAR(100), IN `p_description` VARCHAR(500), IN `p_url` VARCHAR(255), IN `p_last_log_by` INT)   BEGIN
    UPDATE website
    SET website_name = p_website_name,
        description = p_description,
        url = p_url,
        last_log_by = p_last_log_by
    WHERE website_id = p_website_id;
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

    UPDATE employee
    SET work_location_name = p_work_location_name,
        last_log_by = p_last_log_by
    WHERE work_location_id = p_work_location_id;

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
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE employee
    SET work_schedule_name = p_work_schedule_name,
        last_log_by = p_last_log_by
    WHERE work_schedule_id = p_work_schedule_id;

    UPDATE work_schedule
    SET work_schedule_name = p_work_schedule_name,
        schedule_type_id = p_schedule_type_id,
        schedule_type_name = p_schedule_type_name,
        last_log_by = p_last_log_by
    WHERE work_schedule_id = p_work_schedule_id;

    COMMIT;
END$$

DROP PROCEDURE IF EXISTS `verifyUserAccount`$$
CREATE DEFINER=`root`@`localhost` PROCEDURE `verifyUserAccount` (IN `p_user_account_id` INT, IN `p_registration_verification_token_expiry_date` DATETIME, IN `p_last_log_by` INT)   BEGIN

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    INSERT INTO role_user_account (role_id, role_name, user_account_id, file_as, last_log_by) 
	VALUES(2, 'Customer', p_user_account_id, (SELECT file_as FROM user_account WHERE user_account_id = p_user_account_id), p_last_log_by);

    UPDATE user_account 
    SET user_verified = 'Yes',
        active = 'Yes',
        registration_verification_token_expiry_date = p_registration_verification_token_expiry_date,
        registration_verification_date = NOW(),
        last_log_by = p_last_log_by
    WHERE user_account_id = p_user_account_id;

    COMMIT;
END$$

DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `accordion`
--

DROP TABLE IF EXISTS `accordion`;
CREATE TABLE `accordion` (
  `accordion_id` int(10) UNSIGNED NOT NULL,
  `accordion_name` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `block_style_id` int(10) UNSIGNED NOT NULL,
  `block_style_name` varchar(100) NOT NULL,
  `publish_status` varchar(5) NOT NULL DEFAULT 'No',
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `accordion`
--
DROP TRIGGER IF EXISTS `accordion_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `accordion_trigger_insert` AFTER INSERT ON `accordion` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Accordion created. <br/>';

    IF NEW.accordion_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Accordion Name: ", NEW.accordion_name);
    END IF;

    IF NEW.description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.description);
    END IF;

    IF NEW.block_style_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Style Name: ", NEW.block_style_name);
    END IF;

    IF NEW.publish_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Publish Status: ", NEW.publish_status);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('accordion', NEW.accordion_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `accordion_trigger_update`;
DELIMITER $$
CREATE TRIGGER `accordion_trigger_update` AFTER UPDATE ON `accordion` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.accordion_name <> OLD.accordion_name THEN
        SET audit_log = CONCAT(audit_log, "Accordion Name: ", OLD.accordion_name, " -> ", NEW.accordion_name, "<br/>");
    END IF;

    IF NEW.description <> OLD.description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.description, " -> ", NEW.description, "<br/>");
    END IF;

    IF NEW.block_style_name <> OLD.block_style_name THEN
        SET audit_log = CONCAT(audit_log, "Block Style Name: ", OLD.block_style_name, " -> ", NEW.block_style_name, "<br/>");
    END IF;

    IF NEW.publish_status <> OLD.publish_status THEN
        SET audit_log = CONCAT(audit_log, "Publish Status: ", OLD.publish_status, " -> ", NEW.publish_status, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('accordion', NEW.accordion_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `accordion_item`
--

DROP TABLE IF EXISTS `accordion_item`;
CREATE TABLE `accordion_item` (
  `accordion_item_id` int(10) UNSIGNED NOT NULL,
  `accordion_id` int(10) UNSIGNED NOT NULL,
  `accordion_header` varchar(500) NOT NULL,
  `accordion_body` longtext NOT NULL,
  `order_sequence` int(11) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `accordion_item`
--
DROP TRIGGER IF EXISTS `accordion_item_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `accordion_item_trigger_insert` AFTER INSERT ON `accordion_item` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Accordion item created. <br/>';


    IF NEW.accordion_header <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Accordion Header: ", NEW.accordion_header);
    END IF;

    IF NEW.accordion_body <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Accordion Body: ", NEW.accordion_body);
    END IF;

    IF NEW.order_sequence <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Order Sequence: ", NEW.order_sequence);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('accordion_item', NEW.accordion_item_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `accordion_item_trigger_update`;
DELIMITER $$
CREATE TRIGGER `accordion_item_trigger_update` AFTER UPDATE ON `accordion_item` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.accordion_header <> OLD.accordion_header THEN
        SET audit_log = CONCAT(audit_log, "Accordion Header: ", OLD.accordion_header, " -> ", NEW.accordion_header, "<br/>");
    END IF;

    IF NEW.accordion_body <> OLD.accordion_body THEN
        SET audit_log = CONCAT(audit_log, "Accordion Body: ", OLD.accordion_body, " -> ", NEW.accordion_body, "<br/>");
    END IF;
    
    IF NEW.order_sequence <> OLD.order_sequence THEN
        SET audit_log = CONCAT(audit_log, "Order Sequence: ", OLD.order_sequence, " -> ", NEW.order_sequence, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('accordion_item', NEW.accordion_item_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
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
(2, 'Employees', 'Centralize employee information', './components/app-module/image/logo/2/kwDc.png', '1.0.0', 23, 'Inventory Overview', 1, '2024-06-27 15:30:44', 2),
(3, 'Customer', 'Bring all your customer information into one easy-to-access location', './components/app-module/image/logo/3/rL4r.png', '1.0.0', 50, 'Customer', 3, '2024-08-19 10:28:21', 2),
(4, 'Website Studio', 'Create and customize your website', './components/app-module/image/logo/4/TnX0.png', '1.0.0', 54, 'Websites', 1, '2024-08-22 20:54:37', 2),
(5, 'CRM', 'Track leads and close opportunities', './components/app-module/image/logo/5/CxLn.png', '1.0.0', 73, 'My Bookings', 3, '2024-09-02 14:17:04', 2);

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
(1, 'block_container', 1, 'Block Container: <!-- start header -->\n<header class=\"header-with-topbar\">\n    <div class=\"header-top-bar top-bar-dark bg-dark\">\n        <div class=\"container-fluid\">\n            <div class=\"row h-45px align-items-center m-0\">\n                <div class=\"col-12 col-lg-8 fw-500 justify-content-lg-start justify-content-center\">\n                    <span class=\"me-25px fs-15 md-m-0\">\n                        <i class=\"feather icon-feather-map-pin text-base-color me-10px\"></i>\n                        <span class=\"text-light-gray\"><a href=\"https://maps.app.goo.gl/gmJzsR5mFDXLMiQT9\" class=\"widget text-light-gray text-white-hover\" target=\"blank\">Al Rashidiya 2, Al Kaabi Building, Ajman</a></span>\n                    </span>\n                    <span class=\"me-25px fs-15 md-m-0\">\n                        <i class=\"feather icon-feather-phone-call text-base-color me-10px\"></i><span class=\"text-light-gray\"><a href=\"tel:+971543379025\" class=\"widget text-light-gray text-white-hover\">+971 5 4337 9025</a></span>\n                    </span>\n                    <span class=\"d-xl-inline-block d-none fs-15 not-translate\">\n                        <i class=\"feather icon-feather-mail text-base-color me-10px\"></i><a href=\"mailto:contact@althabitah.com\" class=\"widget text-light-gray text-white-hover\">contact@althabitah.com</a>\n                    </span>\n                </div>\n                <div class=\"col-md-4 text-end header-icon d-none d-lg-flex fs-15\">\n                    <div class=\"header-social-icon icon elements-social\">\n                        <a class=\"facebook\" href=\"https://www.facebook.com/profile.php?id=100095104812245&mibextid=LQQJ4d\" target=\"_blank\"><i class=\"fa-brands fa-facebook-f fs-15\"></i></a>\n                        <a class=\"youtube\" href=\"https://www.youtube.com/channel/UCbzw6RiqwngeeruQwGi58-A\" target=\"_blank\"><i class=\"fa-brands fa-youtube fs-15\"></i></a>\n                        <a class=\"instagram\" href=\"https://www.instagram.com/althabitah.cleaningservices/\" target=\"_blank\"><i class=\"fa-brands fa-instagram gray fs-15\"></i></a>\n                        <a class=\"tiktok\" href=\"https://www.tiktok.com/@althabitahcleaningservic?_t=8ohEkhilfXA&_r=1\" target=\"_blank\"><i class=\"fa-brands fa-tiktok fs-15\"></i></a>\n                        <a class=\"whatsapp\" href=\"https://wa.me/971561652741\" target=\"_blank\"><i class=\"fa-brands fa-whatsapp fs-15\"></i></a>\n                    </div>\n                    <div class=\"header-language-icon ms-5 widget fs-13 alt-font fw-600\">\n                        <div class=\"header-language dropdown\">\n                            <a href=\"javascript:void(0);\" class=\"text-dark-gray\"><i class=\"feather icon-feather-globe\"></i><span id=\"current-language-text\">English</span></a>\n                            <ul class=\"language-dropdown alt-font not-translate\">\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ar\" data-title=\"Arabic\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/saudi-arabia.png\" alt=\"Arabic\" data-no-retina=\"\" /></span>Arabic\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"en\" data-title=\"English\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/uk.png\" alt=\"English\" data-no-retina=\"\" /></span>English\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"zh-CN\" data-title=\"Chinese\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/china.png\" alt=\"Chinese\" data-no-retina=\"\" /></span>Chinese\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"fr\" data-title=\"French\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/france.png\" alt=\"French\" data-no-retina=\"\" /></span>French\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"de\" data-title=\"German\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/germany.png\" alt=\"German\" data-no-retina=\"\" /></span>German\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"hi\" data-title=\"Hindi\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/india.png\" alt=\"Hindi\" data-no-retina=\"\" /></span>Hindi\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"it\" data-title=\"Italian\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/italy.png\" alt=\"Italian\" data-no-retina=\"\" /></span>Italian\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ja\" data-title=\"Japanese\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/japan.png\" alt=\"Japanese\" data-no-retina=\"\" /></span>Japanese\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ko\" data-title=\"Korean\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/south-korea.png\" alt=\"Korean\" data-no-retina=\"\" /></span>Korean\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ms\" data-title=\"Malay\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/malaysia.png\" alt=\"Malay\" data-no-retina=\"\" /></span>Malay\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"pt\" data-title=\"Portuguese\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/portugal.png\" alt=\"Portuguese\" data-no-retina=\"\" /></span>Portuguese\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ru\" data-title=\"Russian\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/russian.png\" alt=\"Russian\" data-no-retina=\"\" /></span>Russian\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"es\" data-title=\"Spanish\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/spain.png\" alt=\"Spanish\" data-no-retina=\"\" /></span>Spanish\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ur\" data-title=\"Urdu\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/pakistan.png\" alt=\"Urdu\" data-no-retina=\"\" /></span>Urdu\n                                    </a>\n                                </li>\n                            </ul>\n                        </div>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </div>\n    <!-- start navigation -->\n    <nav class=\"navbar navbar-expand-lg header-light bg-white header-reverse\" data-header-hover=\"light\">\n        <div class=\"container-fluid\">\n            <div class=\"col-auto\">\n                <a class=\"navbar-brand\" href=\"althabitah.php\">\n                    <img src=\"./components/al-thabitah/assets/images/logo.png\" data-at2x=\"./components/al-thabitah/assets/images/logo.png\" alt=\"Al Thabitah Logo\" class=\"default-logo\" />\n                    <img src=\"./components/al-thabitah/assets/images/logo.png\" data-at2x=\"./components/al-thabitah/assets/images/logo.png\" alt=\"Al Thabitah Logo\" class=\"alt-logo\" />\n                    <img src=\"./components/al-thabitah/assets/images/logo.png\" data-at2x=\"./components/al-thabitah/assets/images/logo.png\" alt=\"Al Thabitah Logo\" class=\"mobile-logo\" />\n                </a>\n            </div>\n            <div class=\"col-auto menu-order left-nav\">\n                <button class=\"navbar-toggler float-start\" type=\"button\" data-bs-toggle=\"collapse\" data-bs-target=\"#navbarNav\" aria-controls=\"navbarNav\" aria-label=\"Toggle navigation\">\n                    <span class=\"navbar-toggler-line\"></span>\n                    <span class=\"navbar-toggler-line\"></span>\n                    <span class=\"navbar-toggler-line\"></span>\n                    <span class=\"navbar-toggler-line\"></span>\n                </button>\n                <div class=\"collapse navbar-collapse justify-content-center\" id=\"navbarNav\">\n                    <ul class=\"navbar-nav\">\n                        <li class=\"nav-item\"><a href=\"althabitah.php\" class=\"nav-link\">Home</a></li>\n                        <li class=\"nav-item\"><a href=\"althabitah.php?page=about_us\" class=\"nav-link\">About us</a></li>\n                        <li class=\"nav-item dropdown dropdown-with-icon-style02\">\n                            <a href=\"althabitah.php?page=our_services\" class=\"nav-link\">Our services</a>\n                            <i class=\"fa-solid fa-angle-down dropdown-toggle\" id=\"navbarDropdownMenuLink\" role=\"button\" data-bs-toggle=\"dropdown\" aria-expanded=\"false\"></i>\n                            <ul class=\"dropdown-menu translatable\" aria-labelledby=\"navbarDropdownMenuLink\">\n                                <li>\n                                    <a href=\"althabitah.php?page=house_cleaning\"><i class=\"line-icon-Home align-middle text-base-color\"></i>House Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=office_cleaning\"><i class=\"line-icon-Building align-middle text-base-color\"></i>Office Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=kitchen_cleaning\"><i class=\"line-icon-Suitcase align-middle text-base-color\"></i>Kitchen Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=water_tank_cleaning\"><i class=\"line-icon-Drop align-middle text-base-color\"></i>Water Tank Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=window_cleaning\"><i class=\"line-icon-Window align-middle text-base-color\"></i>Window Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=sofa_cleaning\"><i class=\"line-icon-Chair align-middle text-base-color\"></i>Sofa Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=carpet_cleaning\"><i class=\"line-icon-Cookies align-middle text-base-color\"></i>Carpet Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=mattress_cleaning\"><i class=\"line-icon-Sexual align-middle text-base-color\"></i>Mattress Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"calthabitah.php?page=urtain_cleaning\"><i class=\"line-icon-Dress align-middle text-base-color\"></i>Curtain Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=plumbing_service\"><i class=\"line-icon-Pipe align-middle text-base-color\"></i>Plumbing Service</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=pest_control_service\"><i class=\"line-icon-Bug align-middle text-base-color\"></i>Pest Control Service</a>\n                                </li>\n                            </ul>\n                        </li>\n                        <li class=\"nav-item\"><a href=\"althabitah.php?page=booking\" class=\"nav-link\">Book Now</a></li>\n                        <li class=\"nav-item\"><a href=\"althabitah.php?page=contact_us\" class=\"nav-link\">Contact us</a></li>\n                    </ul>\n                </div>\n            </div>\n            <div class=\"col-auto ms-auto ps-lg-0 d-none d-sm-flex\">\n                <div class=\"header-icon\">\n                    <div class=\"header-button me-25px\">\n                        <a href=\"althabitah.php?page=booking\" class=\"btn btn-small btn-base-color btn-hover-animation-switch btn-round-edge btn-box-shadow fw-700 ls-0px btn-icon-left\">\n                            <span>\n                                <span class=\"btn-text\">Book Now</span>\n                                <span class=\"btn-icon\"><i class=\"feather icon-feather-calendar\"></i></span>\n                                <span class=\"btn-icon\"><i class=\"feather icon-feather-calendar\"></i></span>\n                            </span>\n                        </a>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </nav>\n    <!-- end navigation -->\n</header>\n<!-- end header --> -> <!-- start header -->\n<header class=\"header-with-topbar\">\n    <div class=\"header-top-bar top-bar-dark bg-dark\">\n        <div class=\"container-fluid\">\n            <div class=\"row h-45px align-items-center m-0\">\n                <div class=\"col-12 col-lg-8 fw-500 justify-content-lg-start justify-content-center\">\n                    <span class=\"me-25px fs-15 md-m-0\">\n                        <i class=\"feather icon-feather-map-pin text-base-color me-10px\"></i>\n                        <span class=\"text-light-gray\"><a href=\"https://maps.app.goo.gl/gmJzsR5mFDXLMiQT9\" class=\"widget text-light-gray text-white-hover\" target=\"blank\">Al Rashidiya 2, Al Kaabi Building, Ajman</a></span>\n                    </span>\n                    <span class=\"me-25px fs-15 md-m-0\">\n                        <i class=\"feather icon-feather-phone-call text-base-color me-10px\"></i><span class=\"text-light-gray\"><a href=\"tel:+971543379025\" class=\"widget text-light-gray text-white-hover\">+971 5 4337 9025</a></span>\n                    </span>\n                    <span class=\"d-xl-inline-block d-none fs-15 not-translate\">\n                        <i class=\"feather icon-feather-mail text-base-color me-10px\"></i><a href=\"mailto:contact@page.com\" class=\"widget text-light-gray text-white-hover\">contact@page.com</a>\n                    </span>\n                </div>\n                <div class=\"col-md-4 text-end header-icon d-none d-lg-flex fs-15\">\n                    <div class=\"header-social-icon icon elements-social\">\n                        <a class=\"facebook\" href=\"https://www.facebook.com/profile.php?id=100095104812245&mibextid=LQQJ4d\" target=\"_blank\"><i class=\"fa-brands fa-facebook-f fs-15\"></i></a>\n                        <a class=\"youtube\" href=\"https://www.youtube.com/channel/UCbzw6RiqwngeeruQwGi58-A\" target=\"_blank\"><i class=\"fa-brands fa-youtube fs-15\"></i></a>\n                        <a class=\"instagram\" href=\"https://www.instagram.com/page.cleaningservices/\" target=\"_blank\"><i class=\"fa-brands fa-instagram gray fs-15\"></i></a>\n                        <a class=\"tiktok\" href=\"https://www.tiktok.com/@pagecleaningservic?_t=8ohEkhilfXA&_r=1\" target=\"_blank\"><i class=\"fa-brands fa-tiktok fs-15\"></i></a>\n                        <a class=\"whatsapp\" href=\"https://wa.me/971561652741\" target=\"_blank\"><i class=\"fa-brands fa-whatsapp fs-15\"></i></a>\n                    </div>\n                    <div class=\"header-language-icon ms-5 widget fs-13 alt-font fw-600\">\n                        <div class=\"header-language dropdown\">\n                            <a href=\"javascript:void(0);\" class=\"text-dark-gray\"><i class=\"feather icon-feather-globe\"></i><span id=\"current-language-text\">English</span></a>\n                            <ul class=\"language-dropdown alt-font not-translate\">\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ar\" data-title=\"Arabic\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/saudi-arabia.png\" alt=\"Arabic\" data-no-retina=\"\" /></span>Arabic\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"en\" data-title=\"English\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/uk.png\" alt=\"English\" data-no-retina=\"\" /></span>English\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"zh-CN\" data-title=\"Chinese\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/china.png\" alt=\"Chinese\" data-no-retina=\"\" /></span>Chinese\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"fr\" data-title=\"French\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/france.png\" alt=\"French\" data-no-retina=\"\" /></span>French\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"de\" data-title=\"German\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/germany.png\" alt=\"German\" data-no-retina=\"\" /></span>German\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"hi\" data-title=\"Hindi\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/india.png\" alt=\"Hindi\" data-no-retina=\"\" /></span>Hindi\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"it\" data-title=\"Italian\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/italy.png\" alt=\"Italian\" data-no-retina=\"\" /></span>Italian\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ja\" data-title=\"Japanese\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/japan.png\" alt=\"Japanese\" data-no-retina=\"\" /></span>Japanese\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ko\" data-title=\"Korean\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/south-korea.png\" alt=\"Korean\" data-no-retina=\"\" /></span>Korean\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ms\" data-title=\"Malay\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/malaysia.png\" alt=\"Malay\" data-no-retina=\"\" /></span>Malay\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"pt\" data-title=\"Portuguese\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/portugal.png\" alt=\"Portuguese\" data-no-retina=\"\" /></span>Portuguese\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ru\" data-title=\"Russian\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/russian.png\" alt=\"Russian\" data-no-retina=\"\" /></span>Russian\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"es\" data-title=\"Spanish\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/spain.png\" alt=\"Spanish\" data-no-retina=\"\" /></span>Spanish\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ur\" data-title=\"Urdu\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/pakistan.png\" alt=\"Urdu\" data-no-retina=\"\" /></span>Urdu\n                                    </a>\n                                </li>\n                            </ul>\n                        </div>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </div>\n    <!-- start navigation -->\n    <nav class=\"navbar navbar-expand-lg header-light bg-white header-reverse\" data-header-hover=\"light\">\n        <div class=\"container-fluid\">\n            <div class=\"col-auto\">\n                <a class=\"navbar-brand\" href=\"page.php\">\n                    <img src=\"./components/al-thabitah/assets/images/logo.png\" data-at2x=\"./components/al-thabitah/assets/images/logo.png\" alt=\"Al Thabitah Logo\" class=\"default-logo\" />\n                    <img src=\"./components/al-thabitah/assets/images/logo.png\" data-at2x=\"./components/al-thabitah/assets/images/logo.png\" alt=\"Al Thabitah Logo\" class=\"alt-logo\" />\n                    <img src=\"./components/al-thabitah/assets/images/logo.png\" data-at2x=\"./components/al-thabitah/assets/images/logo.png\" alt=\"Al Thabitah Logo\" class=\"mobile-logo\" />\n                </a>\n            </div>\n            <div class=\"col-auto menu-order left-nav\">\n                <button class=\"navbar-toggler float-start\" type=\"button\" data-bs-toggle=\"collapse\" data-bs-target=\"#navbarNav\" aria-controls=\"navbarNav\" aria-label=\"Toggle navigation\">\n                    <span class=\"navbar-toggler-line\"></span>\n                    <span class=\"navbar-toggler-line\"></span>\n                    <span class=\"navbar-toggler-line\"></span>\n                    <span class=\"navbar-toggler-line\"></span>\n                </button>\n                <div class=\"collapse navbar-collapse justify-content-center\" id=\"navbarNav\">\n                    <ul class=\"navbar-nav\">\n                        <li class=\"nav-item\"><a href=\"page.php\" class=\"nav-link\">Home</a></li>\n                        <li class=\"nav-item\"><a href=\"page.php?page=about_us\" class=\"nav-link\">About us</a></li>\n                        <li class=\"nav-item dropdown dropdown-with-icon-style02\">\n                            <a href=\"page.php?page=our_services\" class=\"nav-link\">Our services</a>\n                            <i class=\"fa-solid fa-angle-down dropdown-toggle\" id=\"navbarDropdownMenuLink\" role=\"button\" data-bs-toggle=\"dropdown\" aria-expanded=\"false\"></i>\n                            <ul class=\"dropdown-menu translatable\" aria-labelledby=\"navbarDropdownMenuLink\">\n                                <li>\n                                    <a href=\"page.php?page=house_cleaning\"><i class=\"line-icon-Home align-middle text-base-color\"></i>House Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"page.php?page=office_cleaning\"><i class=\"line-icon-Building align-middle text-base-color\"></i>Office Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"page.php?page=kitchen_cleaning\"><i class=\"line-icon-Suitcase align-middle text-base-color\"></i>Kitchen Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"page.php?page=water_tank_cleaning\"><i class=\"line-icon-Drop align-middle text-base-color\"></i>Water Tank Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"page.php?page=window_cleaning\"><i class=\"line-icon-Window align-middle text-base-color\"></i>Window Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"page.php?page=sofa_cleaning\"><i class=\"line-icon-Chair align-middle text-base-color\"></i>Sofa Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"page.php?page=carpet_cleaning\"><i class=\"line-icon-Cookies align-middle text-base-color\"></i>Carpet Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"page.php?page=mattress_cleaning\"><i class=\"line-icon-Sexual align-middle text-base-color\"></i>Mattress Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"page.php?page=urtain_cleaning\"><i class=\"line-icon-Dress align-middle text-base-color\"></i>Curtain Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"page.php?page=plumbing_service\"><i class=\"line-icon-Pipe align-middle text-base-color\"></i>Plumbing Service</a>\n                                </li>\n                                <li>\n                                    <a href=\"page.php?page=pest_control_service\"><i class=\"line-icon-Bug align-middle text-base-color\"></i>Pest Control Service</a>\n                                </li>\n                            </ul>\n                        </li>\n                        <li class=\"nav-item\"><a href=\"page.php?page=booking\" class=\"nav-link\">Book Now</a></li>\n                        <li class=\"nav-item\"><a href=\"page.php?page=contact_us\" class=\"nav-link\">Contact us</a></li>\n                    </ul>\n                </div>\n            </div>\n            <div class=\"col-auto ms-auto ps-lg-0 d-none d-sm-flex\">\n                <div class=\"header-icon\">\n                    <div class=\"header-button me-25px\">\n                        <a href=\"page.php?page=booking\" class=\"btn btn-small btn-base-color btn-hover-animation-switch btn-round-edge btn-box-shadow fw-700 ls-0px btn-icon-left\">\n                            <span>\n                                <span class=\"btn-text\">Book Now</span>\n                                <span class=\"btn-icon\"><i class=\"feather icon-feather-calendar\"></i></span>\n                                <span class=\"btn-icon\"><i class=\"feather icon-feather-calendar\"></i></span>\n                            </span>\n                        </a>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </nav>\n    <!-- end navigation -->\n</header>\n<!-- end header --><br/>', 2, '2024-09-12 21:11:48', '2024-09-12 21:11:48');
INSERT INTO `audit_log` (`audit_log_id`, `table_name`, `reference_id`, `log`, `changed_by`, `changed_at`, `created_date`) VALUES
(2, 'block_container', 1, 'Block Container: <!-- start header -->\n<header class=\"header-with-topbar\">\n    <div class=\"header-top-bar top-bar-dark bg-dark\">\n        <div class=\"container-fluid\">\n            <div class=\"row h-45px align-items-center m-0\">\n                <div class=\"col-12 col-lg-8 fw-500 justify-content-lg-start justify-content-center\">\n                    <span class=\"me-25px fs-15 md-m-0\">\n                        <i class=\"feather icon-feather-map-pin text-base-color me-10px\"></i>\n                        <span class=\"text-light-gray\"><a href=\"https://maps.app.goo.gl/gmJzsR5mFDXLMiQT9\" class=\"widget text-light-gray text-white-hover\" target=\"blank\">Al Rashidiya 2, Al Kaabi Building, Ajman</a></span>\n                    </span>\n                    <span class=\"me-25px fs-15 md-m-0\">\n                        <i class=\"feather icon-feather-phone-call text-base-color me-10px\"></i><span class=\"text-light-gray\"><a href=\"tel:+971543379025\" class=\"widget text-light-gray text-white-hover\">+971 5 4337 9025</a></span>\n                    </span>\n                    <span class=\"d-xl-inline-block d-none fs-15 not-translate\">\n                        <i class=\"feather icon-feather-mail text-base-color me-10px\"></i><a href=\"mailto:contact@page.com\" class=\"widget text-light-gray text-white-hover\">contact@page.com</a>\n                    </span>\n                </div>\n                <div class=\"col-md-4 text-end header-icon d-none d-lg-flex fs-15\">\n                    <div class=\"header-social-icon icon elements-social\">\n                        <a class=\"facebook\" href=\"https://www.facebook.com/profile.php?id=100095104812245&mibextid=LQQJ4d\" target=\"_blank\"><i class=\"fa-brands fa-facebook-f fs-15\"></i></a>\n                        <a class=\"youtube\" href=\"https://www.youtube.com/channel/UCbzw6RiqwngeeruQwGi58-A\" target=\"_blank\"><i class=\"fa-brands fa-youtube fs-15\"></i></a>\n                        <a class=\"instagram\" href=\"https://www.instagram.com/page.cleaningservices/\" target=\"_blank\"><i class=\"fa-brands fa-instagram gray fs-15\"></i></a>\n                        <a class=\"tiktok\" href=\"https://www.tiktok.com/@pagecleaningservic?_t=8ohEkhilfXA&_r=1\" target=\"_blank\"><i class=\"fa-brands fa-tiktok fs-15\"></i></a>\n                        <a class=\"whatsapp\" href=\"https://wa.me/971561652741\" target=\"_blank\"><i class=\"fa-brands fa-whatsapp fs-15\"></i></a>\n                    </div>\n                    <div class=\"header-language-icon ms-5 widget fs-13 alt-font fw-600\">\n                        <div class=\"header-language dropdown\">\n                            <a href=\"javascript:void(0);\" class=\"text-dark-gray\"><i class=\"feather icon-feather-globe\"></i><span id=\"current-language-text\">English</span></a>\n                            <ul class=\"language-dropdown alt-font not-translate\">\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ar\" data-title=\"Arabic\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/saudi-arabia.png\" alt=\"Arabic\" data-no-retina=\"\" /></span>Arabic\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"en\" data-title=\"English\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/uk.png\" alt=\"English\" data-no-retina=\"\" /></span>English\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"zh-CN\" data-title=\"Chinese\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/china.png\" alt=\"Chinese\" data-no-retina=\"\" /></span>Chinese\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"fr\" data-title=\"French\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/france.png\" alt=\"French\" data-no-retina=\"\" /></span>French\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"de\" data-title=\"German\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/germany.png\" alt=\"German\" data-no-retina=\"\" /></span>German\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"hi\" data-title=\"Hindi\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/india.png\" alt=\"Hindi\" data-no-retina=\"\" /></span>Hindi\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"it\" data-title=\"Italian\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/italy.png\" alt=\"Italian\" data-no-retina=\"\" /></span>Italian\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ja\" data-title=\"Japanese\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/japan.png\" alt=\"Japanese\" data-no-retina=\"\" /></span>Japanese\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ko\" data-title=\"Korean\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/south-korea.png\" alt=\"Korean\" data-no-retina=\"\" /></span>Korean\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ms\" data-title=\"Malay\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/malaysia.png\" alt=\"Malay\" data-no-retina=\"\" /></span>Malay\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"pt\" data-title=\"Portuguese\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/portugal.png\" alt=\"Portuguese\" data-no-retina=\"\" /></span>Portuguese\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ru\" data-title=\"Russian\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/russian.png\" alt=\"Russian\" data-no-retina=\"\" /></span>Russian\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"es\" data-title=\"Spanish\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/spain.png\" alt=\"Spanish\" data-no-retina=\"\" /></span>Spanish\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ur\" data-title=\"Urdu\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/pakistan.png\" alt=\"Urdu\" data-no-retina=\"\" /></span>Urdu\n                                    </a>\n                                </li>\n                            </ul>\n                        </div>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </div>\n    <!-- start navigation -->\n    <nav class=\"navbar navbar-expand-lg header-light bg-white header-reverse\" data-header-hover=\"light\">\n        <div class=\"container-fluid\">\n            <div class=\"col-auto\">\n                <a class=\"navbar-brand\" href=\"page.php\">\n                    <img src=\"./components/al-thabitah/assets/images/logo.png\" data-at2x=\"./components/al-thabitah/assets/images/logo.png\" alt=\"Al Thabitah Logo\" class=\"default-logo\" />\n                    <img src=\"./components/al-thabitah/assets/images/logo.png\" data-at2x=\"./components/al-thabitah/assets/images/logo.png\" alt=\"Al Thabitah Logo\" class=\"alt-logo\" />\n                    <img src=\"./components/al-thabitah/assets/images/logo.png\" data-at2x=\"./components/al-thabitah/assets/images/logo.png\" alt=\"Al Thabitah Logo\" class=\"mobile-logo\" />\n                </a>\n            </div>\n            <div class=\"col-auto menu-order left-nav\">\n                <button class=\"navbar-toggler float-start\" type=\"button\" data-bs-toggle=\"collapse\" data-bs-target=\"#navbarNav\" aria-controls=\"navbarNav\" aria-label=\"Toggle navigation\">\n                    <span class=\"navbar-toggler-line\"></span>\n                    <span class=\"navbar-toggler-line\"></span>\n                    <span class=\"navbar-toggler-line\"></span>\n                    <span class=\"navbar-toggler-line\"></span>\n                </button>\n                <div class=\"collapse navbar-collapse justify-content-center\" id=\"navbarNav\">\n                    <ul class=\"navbar-nav\">\n                        <li class=\"nav-item\"><a href=\"page.php\" class=\"nav-link\">Home</a></li>\n                        <li class=\"nav-item\"><a href=\"page.php?page=about_us\" class=\"nav-link\">About us</a></li>\n                        <li class=\"nav-item dropdown dropdown-with-icon-style02\">\n                            <a href=\"page.php?page=our_services\" class=\"nav-link\">Our services</a>\n                            <i class=\"fa-solid fa-angle-down dropdown-toggle\" id=\"navbarDropdownMenuLink\" role=\"button\" data-bs-toggle=\"dropdown\" aria-expanded=\"false\"></i>\n                            <ul class=\"dropdown-menu translatable\" aria-labelledby=\"navbarDropdownMenuLink\">\n                                <li>\n                                    <a href=\"page.php?page=house_cleaning\"><i class=\"line-icon-Home align-middle text-base-color\"></i>House Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"page.php?page=office_cleaning\"><i class=\"line-icon-Building align-middle text-base-color\"></i>Office Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"page.php?page=kitchen_cleaning\"><i class=\"line-icon-Suitcase align-middle text-base-color\"></i>Kitchen Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"page.php?page=water_tank_cleaning\"><i class=\"line-icon-Drop align-middle text-base-color\"></i>Water Tank Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"page.php?page=window_cleaning\"><i class=\"line-icon-Window align-middle text-base-color\"></i>Window Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"page.php?page=sofa_cleaning\"><i class=\"line-icon-Chair align-middle text-base-color\"></i>Sofa Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"page.php?page=carpet_cleaning\"><i class=\"line-icon-Cookies align-middle text-base-color\"></i>Carpet Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"page.php?page=mattress_cleaning\"><i class=\"line-icon-Sexual align-middle text-base-color\"></i>Mattress Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"page.php?page=urtain_cleaning\"><i class=\"line-icon-Dress align-middle text-base-color\"></i>Curtain Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"page.php?page=plumbing_service\"><i class=\"line-icon-Pipe align-middle text-base-color\"></i>Plumbing Service</a>\n                                </li>\n                                <li>\n                                    <a href=\"page.php?page=pest_control_service\"><i class=\"line-icon-Bug align-middle text-base-color\"></i>Pest Control Service</a>\n                                </li>\n                            </ul>\n                        </li>\n                        <li class=\"nav-item\"><a href=\"page.php?page=booking\" class=\"nav-link\">Book Now</a></li>\n                        <li class=\"nav-item\"><a href=\"page.php?page=contact_us\" class=\"nav-link\">Contact us</a></li>\n                    </ul>\n                </div>\n            </div>\n            <div class=\"col-auto ms-auto ps-lg-0 d-none d-sm-flex\">\n                <div class=\"header-icon\">\n                    <div class=\"header-button me-25px\">\n                        <a href=\"page.php?page=booking\" class=\"btn btn-small btn-base-color btn-hover-animation-switch btn-round-edge btn-box-shadow fw-700 ls-0px btn-icon-left\">\n                            <span>\n                                <span class=\"btn-text\">Book Now</span>\n                                <span class=\"btn-icon\"><i class=\"feather icon-feather-calendar\"></i></span>\n                                <span class=\"btn-icon\"><i class=\"feather icon-feather-calendar\"></i></span>\n                            </span>\n                        </a>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </nav>\n    <!-- end navigation -->\n</header>\n<!-- end header --> -> <!-- start header -->\n<header class=\"header-with-topbar\">\n    <div class=\"header-top-bar top-bar-dark bg-dark\">\n        <div class=\"container-fluid\">\n            <div class=\"row h-45px align-items-center m-0\">\n                <div class=\"col-12 col-lg-8 fw-500 justify-content-lg-start justify-content-center\">\n                    <span class=\"me-25px fs-15 md-m-0\">\n                        <i class=\"feather icon-feather-map-pin text-base-color me-10px\"></i>\n                        <span class=\"text-light-gray\"><a href=\"https://maps.app.goo.gl/gmJzsR5mFDXLMiQT9\" class=\"widget text-light-gray text-white-hover\" target=\"blank\">Al Rashidiya 2, Al Kaabi Building, Ajman</a></span>\n                    </span>\n                    <span class=\"me-25px fs-15 md-m-0\">\n                        <i class=\"feather icon-feather-phone-call text-base-color me-10px\"></i><span class=\"text-light-gray\"><a href=\"tel:+971543379025\" class=\"widget text-light-gray text-white-hover\">+971 5 4337 9025</a></span>\n                    </span>\n                    <span class=\"d-xl-inline-block d-none fs-15 not-translate\">\n                        <i class=\"feather icon-feather-mail text-base-color me-10px\"></i><a href=\"mailto:contact@althabitah.com\" class=\"widget text-light-gray text-white-hover\">contact@althabitah.com</a>\n                    </span>\n                </div>\n                <div class=\"col-md-4 text-end header-icon d-none d-lg-flex fs-15\">\n                    <div class=\"header-social-icon icon elements-social\">\n                        <a class=\"facebook\" href=\"https://www.facebook.com/profile.php?id=100095104812245&mibextid=LQQJ4d\" target=\"_blank\"><i class=\"fa-brands fa-facebook-f fs-15\"></i></a>\n                        <a class=\"youtube\" href=\"https://www.youtube.com/channel/UCbzw6RiqwngeeruQwGi58-A\" target=\"_blank\"><i class=\"fa-brands fa-youtube fs-15\"></i></a>\n                        <a class=\"instagram\" href=\"https://www.instagram.com/althabitah.cleaningservices/\" target=\"_blank\"><i class=\"fa-brands fa-instagram gray fs-15\"></i></a>\n                        <a class=\"tiktok\" href=\"https://www.tiktok.com/@althabitahcleaningservic?_t=8ohEkhilfXA&_r=1\" target=\"_blank\"><i class=\"fa-brands fa-tiktok fs-15\"></i></a>\n                        <a class=\"whatsapp\" href=\"https://wa.me/971561652741\" target=\"_blank\"><i class=\"fa-brands fa-whatsapp fs-15\"></i></a>\n                    </div>\n                    <div class=\"header-language-icon ms-5 widget fs-13 alt-font fw-600\">\n                        <div class=\"header-language dropdown\">\n                            <a href=\"javascript:void(0);\" class=\"text-dark-gray\"><i class=\"feather icon-feather-globe\"></i><span id=\"current-language-text\">English</span></a>\n                            <ul class=\"language-dropdown alt-font not-translate\">\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ar\" data-title=\"Arabic\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/saudi-arabia.png\" alt=\"Arabic\" data-no-retina=\"\" /></span>Arabic\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"en\" data-title=\"English\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/uk.png\" alt=\"English\" data-no-retina=\"\" /></span>English\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"zh-CN\" data-title=\"Chinese\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/china.png\" alt=\"Chinese\" data-no-retina=\"\" /></span>Chinese\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"fr\" data-title=\"French\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/france.png\" alt=\"French\" data-no-retina=\"\" /></span>French\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"de\" data-title=\"German\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/germany.png\" alt=\"German\" data-no-retina=\"\" /></span>German\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"hi\" data-title=\"Hindi\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/india.png\" alt=\"Hindi\" data-no-retina=\"\" /></span>Hindi\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"it\" data-title=\"Italian\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/italy.png\" alt=\"Italian\" data-no-retina=\"\" /></span>Italian\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ja\" data-title=\"Japanese\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/japan.png\" alt=\"Japanese\" data-no-retina=\"\" /></span>Japanese\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ko\" data-title=\"Korean\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/south-korea.png\" alt=\"Korean\" data-no-retina=\"\" /></span>Korean\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ms\" data-title=\"Malay\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/malaysia.png\" alt=\"Malay\" data-no-retina=\"\" /></span>Malay\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"pt\" data-title=\"Portuguese\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/portugal.png\" alt=\"Portuguese\" data-no-retina=\"\" /></span>Portuguese\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ru\" data-title=\"Russian\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/russian.png\" alt=\"Russian\" data-no-retina=\"\" /></span>Russian\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"es\" data-title=\"Spanish\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/spain.png\" alt=\"Spanish\" data-no-retina=\"\" /></span>Spanish\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ur\" data-title=\"Urdu\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/pakistan.png\" alt=\"Urdu\" data-no-retina=\"\" /></span>Urdu\n                                    </a>\n                                </li>\n                            </ul>\n                        </div>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </div>\n    <!-- start navigation -->\n    <nav class=\"navbar navbar-expand-lg header-light bg-white header-reverse\" data-header-hover=\"light\">\n        <div class=\"container-fluid\">\n            <div class=\"col-auto\">\n                <a class=\"navbar-brand\" href=\"althabitah.php\">\n                    <img src=\"./components/al-thabitah/assets/images/logo.png\" data-at2x=\"./components/al-thabitah/assets/images/logo.png\" alt=\"Al Thabitah Logo\" class=\"default-logo\" />\n                    <img src=\"./components/al-thabitah/assets/images/logo.png\" data-at2x=\"./components/al-thabitah/assets/images/logo.png\" alt=\"Al Thabitah Logo\" class=\"alt-logo\" />\n                    <img src=\"./components/al-thabitah/assets/images/logo.png\" data-at2x=\"./components/al-thabitah/assets/images/logo.png\" alt=\"Al Thabitah Logo\" class=\"mobile-logo\" />\n                </a>\n            </div>\n            <div class=\"col-auto menu-order left-nav\">\n                <button class=\"navbar-toggler float-start\" type=\"button\" data-bs-toggle=\"collapse\" data-bs-target=\"#navbarNav\" aria-controls=\"navbarNav\" aria-label=\"Toggle navigation\">\n                    <span class=\"navbar-toggler-line\"></span>\n                    <span class=\"navbar-toggler-line\"></span>\n                    <span class=\"navbar-toggler-line\"></span>\n                    <span class=\"navbar-toggler-line\"></span>\n                </button>\n                <div class=\"collapse navbar-collapse justify-content-center\" id=\"navbarNav\">\n                    <ul class=\"navbar-nav\">\n                        <li class=\"nav-item\"><a href=\"althabitah.php\" class=\"nav-link\">Home</a></li>\n                        <li class=\"nav-item\"><a href=\"althabitah.php?page=about_us\" class=\"nav-link\">About us</a></li>\n                        <li class=\"nav-item dropdown dropdown-with-icon-style02\">\n                            <a href=\"althabitah.php?page=our_services\" class=\"nav-link\">Our services</a>\n                            <i class=\"fa-solid fa-angle-down dropdown-toggle\" id=\"navbarDropdownMenuLink\" role=\"button\" data-bs-toggle=\"dropdown\" aria-expanded=\"false\"></i>\n                            <ul class=\"dropdown-menu translatable\" aria-labelledby=\"navbarDropdownMenuLink\">\n                                <li>\n                                    <a href=\"althabitah.php?page=house_cleaning\"><i class=\"line-icon-Home align-middle text-base-color\"></i>House Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=office_cleaning\"><i class=\"line-icon-Building align-middle text-base-color\"></i>Office Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=kitchen_cleaning\"><i class=\"line-icon-Suitcase align-middle text-base-color\"></i>Kitchen Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=water_tank_cleaning\"><i class=\"line-icon-Drop align-middle text-base-color\"></i>Water Tank Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=window_cleaning\"><i class=\"line-icon-Window align-middle text-base-color\"></i>Window Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=sofa_cleaning\"><i class=\"line-icon-Chair align-middle text-base-color\"></i>Sofa Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=carpet_cleaning\"><i class=\"line-icon-Cookies align-middle text-base-color\"></i>Carpet Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=mattress_cleaning\"><i class=\"line-icon-Sexual align-middle text-base-color\"></i>Mattress Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=urtain_cleaning\"><i class=\"line-icon-Dress align-middle text-base-color\"></i>Curtain Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=plumbing_service\"><i class=\"line-icon-Pipe align-middle text-base-color\"></i>Plumbing Service</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=pest_control_service\"><i class=\"line-icon-Bug align-middle text-base-color\"></i>Pest Control Service</a>\n                                </li>\n                            </ul>\n                        </li>\n                        <li class=\"nav-item\"><a href=\"althabitah.php?page=booking\" class=\"nav-link\">Book Now</a></li>\n                        <li class=\"nav-item\"><a href=\"althabitah.php?page=contact_us\" class=\"nav-link\">Contact us</a></li>\n                    </ul>\n                </div>\n            </div>\n            <div class=\"col-auto ms-auto ps-lg-0 d-none d-sm-flex\">\n                <div class=\"header-icon\">\n                    <div class=\"header-button me-25px\">\n                        <a href=\"althabitah.php?page=booking\" class=\"btn btn-small btn-base-color btn-hover-animation-switch btn-round-edge btn-box-shadow fw-700 ls-0px btn-icon-left\">\n                            <span>\n                                <span class=\"btn-text\">Book Now</span>\n                                <span class=\"btn-icon\"><i class=\"feather icon-feather-calendar\"></i></span>\n                                <span class=\"btn-icon\"><i class=\"feather icon-feather-calendar\"></i></span>\n                            </span>\n                        </a>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </nav>\n    <!-- end navigation -->\n</header>\n<!-- end header --><br/>', 2, '2024-09-12 21:14:22', '2024-09-12 21:14:22');

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
-- Table structure for table `block_container`
--

DROP TABLE IF EXISTS `block_container`;
CREATE TABLE `block_container` (
  `block_container_id` int(10) UNSIGNED NOT NULL,
  `block_style_id` int(10) UNSIGNED NOT NULL,
  `block_container` longtext NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `block_container`
--

INSERT INTO `block_container` (`block_container_id`, `block_style_id`, `block_container`, `created_date`, `last_log_by`) VALUES
(1, 1, '<!-- start header -->\n<header class=\"header-with-topbar\">\n    <div class=\"header-top-bar top-bar-dark bg-dark\">\n        <div class=\"container-fluid\">\n            <div class=\"row h-45px align-items-center m-0\">\n                <div class=\"col-12 col-lg-8 fw-500 justify-content-lg-start justify-content-center\">\n                    <span class=\"me-25px fs-15 md-m-0\">\n                        <i class=\"feather icon-feather-map-pin text-base-color me-10px\"></i>\n                        <span class=\"text-light-gray\"><a href=\"https://maps.app.goo.gl/gmJzsR5mFDXLMiQT9\" class=\"widget text-light-gray text-white-hover\" target=\"blank\">Al Rashidiya 2, Al Kaabi Building, Ajman</a></span>\n                    </span>\n                    <span class=\"me-25px fs-15 md-m-0\">\n                        <i class=\"feather icon-feather-phone-call text-base-color me-10px\"></i><span class=\"text-light-gray\"><a href=\"tel:+971543379025\" class=\"widget text-light-gray text-white-hover\">+971 5 4337 9025</a></span>\n                    </span>\n                    <span class=\"d-xl-inline-block d-none fs-15 not-translate\">\n                        <i class=\"feather icon-feather-mail text-base-color me-10px\"></i><a href=\"mailto:contact@althabitah.com\" class=\"widget text-light-gray text-white-hover\">contact@althabitah.com</a>\n                    </span>\n                </div>\n                <div class=\"col-md-4 text-end header-icon d-none d-lg-flex fs-15\">\n                    <div class=\"header-social-icon icon elements-social\">\n                        <a class=\"facebook\" href=\"https://www.facebook.com/profile.php?id=100095104812245&mibextid=LQQJ4d\" target=\"_blank\"><i class=\"fa-brands fa-facebook-f fs-15\"></i></a>\n                        <a class=\"youtube\" href=\"https://www.youtube.com/channel/UCbzw6RiqwngeeruQwGi58-A\" target=\"_blank\"><i class=\"fa-brands fa-youtube fs-15\"></i></a>\n                        <a class=\"instagram\" href=\"https://www.instagram.com/althabitah.cleaningservices/\" target=\"_blank\"><i class=\"fa-brands fa-instagram gray fs-15\"></i></a>\n                        <a class=\"tiktok\" href=\"https://www.tiktok.com/@althabitahcleaningservic?_t=8ohEkhilfXA&_r=1\" target=\"_blank\"><i class=\"fa-brands fa-tiktok fs-15\"></i></a>\n                        <a class=\"whatsapp\" href=\"https://wa.me/971561652741\" target=\"_blank\"><i class=\"fa-brands fa-whatsapp fs-15\"></i></a>\n                    </div>\n                    <div class=\"header-language-icon ms-5 widget fs-13 alt-font fw-600\">\n                        <div class=\"header-language dropdown\">\n                            <a href=\"javascript:void(0);\" class=\"text-dark-gray\"><i class=\"feather icon-feather-globe\"></i><span id=\"current-language-text\">English</span></a>\n                            <ul class=\"language-dropdown alt-font not-translate\">\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ar\" data-title=\"Arabic\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/saudi-arabia.png\" alt=\"Arabic\" data-no-retina=\"\" /></span>Arabic\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"en\" data-title=\"English\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/uk.png\" alt=\"English\" data-no-retina=\"\" /></span>English\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"zh-CN\" data-title=\"Chinese\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/china.png\" alt=\"Chinese\" data-no-retina=\"\" /></span>Chinese\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"fr\" data-title=\"French\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/france.png\" alt=\"French\" data-no-retina=\"\" /></span>French\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"de\" data-title=\"German\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/germany.png\" alt=\"German\" data-no-retina=\"\" /></span>German\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"hi\" data-title=\"Hindi\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/india.png\" alt=\"Hindi\" data-no-retina=\"\" /></span>Hindi\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"it\" data-title=\"Italian\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/italy.png\" alt=\"Italian\" data-no-retina=\"\" /></span>Italian\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ja\" data-title=\"Japanese\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/japan.png\" alt=\"Japanese\" data-no-retina=\"\" /></span>Japanese\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ko\" data-title=\"Korean\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/south-korea.png\" alt=\"Korean\" data-no-retina=\"\" /></span>Korean\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ms\" data-title=\"Malay\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/malaysia.png\" alt=\"Malay\" data-no-retina=\"\" /></span>Malay\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"pt\" data-title=\"Portuguese\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/portugal.png\" alt=\"Portuguese\" data-no-retina=\"\" /></span>Portuguese\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ru\" data-title=\"Russian\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/russian.png\" alt=\"Russian\" data-no-retina=\"\" /></span>Russian\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"es\" data-title=\"Spanish\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/spain.png\" alt=\"Spanish\" data-no-retina=\"\" /></span>Spanish\n                                    </a>\n                                </li>\n                                <li>\n                                    <a href=\"javascript:void(0);\" class=\"language-selector\" data-language=\"ur\" data-title=\"Urdu\">\n                                        <span class=\"icon-country\"><img src=\"./components/al-thabitah/assets/images/flags/pakistan.png\" alt=\"Urdu\" data-no-retina=\"\" /></span>Urdu\n                                    </a>\n                                </li>\n                            </ul>\n                        </div>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </div>\n    <!-- start navigation -->\n    <nav class=\"navbar navbar-expand-lg header-light bg-white header-reverse\" data-header-hover=\"light\">\n        <div class=\"container-fluid\">\n            <div class=\"col-auto\">\n                <a class=\"navbar-brand\" href=\"althabitah.php\">\n                    <img src=\"./components/al-thabitah/assets/images/logo.png\" data-at2x=\"./components/al-thabitah/assets/images/logo.png\" alt=\"Al Thabitah Logo\" class=\"default-logo\" />\n                    <img src=\"./components/al-thabitah/assets/images/logo.png\" data-at2x=\"./components/al-thabitah/assets/images/logo.png\" alt=\"Al Thabitah Logo\" class=\"alt-logo\" />\n                    <img src=\"./components/al-thabitah/assets/images/logo.png\" data-at2x=\"./components/al-thabitah/assets/images/logo.png\" alt=\"Al Thabitah Logo\" class=\"mobile-logo\" />\n                </a>\n            </div>\n            <div class=\"col-auto menu-order left-nav\">\n                <button class=\"navbar-toggler float-start\" type=\"button\" data-bs-toggle=\"collapse\" data-bs-target=\"#navbarNav\" aria-controls=\"navbarNav\" aria-label=\"Toggle navigation\">\n                    <span class=\"navbar-toggler-line\"></span>\n                    <span class=\"navbar-toggler-line\"></span>\n                    <span class=\"navbar-toggler-line\"></span>\n                    <span class=\"navbar-toggler-line\"></span>\n                </button>\n                <div class=\"collapse navbar-collapse justify-content-center\" id=\"navbarNav\">\n                    <ul class=\"navbar-nav\">\n                        <li class=\"nav-item\"><a href=\"althabitah.php\" class=\"nav-link\">Home</a></li>\n                        <li class=\"nav-item\"><a href=\"althabitah.php?page=about_us\" class=\"nav-link\">About us</a></li>\n                        <li class=\"nav-item dropdown dropdown-with-icon-style02\">\n                            <a href=\"althabitah.php?page=our_services\" class=\"nav-link\">Our services</a>\n                            <i class=\"fa-solid fa-angle-down dropdown-toggle\" id=\"navbarDropdownMenuLink\" role=\"button\" data-bs-toggle=\"dropdown\" aria-expanded=\"false\"></i>\n                            <ul class=\"dropdown-menu translatable\" aria-labelledby=\"navbarDropdownMenuLink\">\n                                <li>\n                                    <a href=\"althabitah.php?page=house_cleaning\"><i class=\"line-icon-Home align-middle text-base-color\"></i>House Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=office_cleaning\"><i class=\"line-icon-Building align-middle text-base-color\"></i>Office Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=kitchen_cleaning\"><i class=\"line-icon-Suitcase align-middle text-base-color\"></i>Kitchen Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=water_tank_cleaning\"><i class=\"line-icon-Drop align-middle text-base-color\"></i>Water Tank Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=window_cleaning\"><i class=\"line-icon-Window align-middle text-base-color\"></i>Window Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=sofa_cleaning\"><i class=\"line-icon-Chair align-middle text-base-color\"></i>Sofa Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=carpet_cleaning\"><i class=\"line-icon-Cookies align-middle text-base-color\"></i>Carpet Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=mattress_cleaning\"><i class=\"line-icon-Sexual align-middle text-base-color\"></i>Mattress Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=urtain_cleaning\"><i class=\"line-icon-Dress align-middle text-base-color\"></i>Curtain Cleaning</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=plumbing_service\"><i class=\"line-icon-Pipe align-middle text-base-color\"></i>Plumbing Service</a>\n                                </li>\n                                <li>\n                                    <a href=\"althabitah.php?page=pest_control_service\"><i class=\"line-icon-Bug align-middle text-base-color\"></i>Pest Control Service</a>\n                                </li>\n                            </ul>\n                        </li>\n                        <li class=\"nav-item\"><a href=\"althabitah.php?page=booking\" class=\"nav-link\">Book Now</a></li>\n                        <li class=\"nav-item\"><a href=\"althabitah.php?page=contact_us\" class=\"nav-link\">Contact us</a></li>\n                    </ul>\n                </div>\n            </div>\n            <div class=\"col-auto ms-auto ps-lg-0 d-none d-sm-flex\">\n                <div class=\"header-icon\">\n                    <div class=\"header-button me-25px\">\n                        <a href=\"althabitah.php?page=booking\" class=\"btn btn-small btn-base-color btn-hover-animation-switch btn-round-edge btn-box-shadow fw-700 ls-0px btn-icon-left\">\n                            <span>\n                                <span class=\"btn-text\">Book Now</span>\n                                <span class=\"btn-icon\"><i class=\"feather icon-feather-calendar\"></i></span>\n                                <span class=\"btn-icon\"><i class=\"feather icon-feather-calendar\"></i></span>\n                            </span>\n                        </a>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </nav>\n    <!-- end navigation -->\n</header>\n<!-- end header -->', '2024-09-06 20:27:19', 2),
(2, 2, '<!-- start footer -->\n<footer class=\"bg-dark-gray background-position-center-top pb-2\" style=\"background-image: url(\'./components/al-thabitah/assets/images/footer-dot.svg\');\">\n    <div class=\"container overlap-section\">\n        <div class=\"row g-0 justify-content-center align-items-center bg-base-color border-radius-6px ps-7 pe-7 pt-4 pb-4 lg-p-30px sm-p-20px mb-7\">\n            <div class=\"col-lg-4 text-center text-lg-start md-mb-20px\">\n                <h4 class=\"text-white fw-600 mb-0 ls-minus-1px\">Let’s talk about how we can refresh your space!</h4>\n            </div>\n            <div class=\"col-auto icon-with-text-style-08 offset-lg-1\">\n                <div class=\"feature-box feature-box-left-icon-middle overflow-hidden\">\n                    <div class=\"feature-box-icon feature-box-icon-rounded w-80px h-80px rounded-circle bg-dark-gray-transparent-light me-25px lg-me-20px\">\n                        <i class=\"bi bi-envelope icon-very-medium text-white\"></i>\n                    </div>\n                    <div class=\"feature-box-content last-paragraph-no-margin\">\n                        <span class=\"text-white fs-18 lh-22 mb-5px d-block\">Interested in working?</span>\n                        <h6 class=\"d-inline-block fw-600 mb-0\"><a href=\"mailto:contact@althabitah.com\" class=\"text-dark-gray text-decoration-line-bottom-medium text-white-hover not-translate\">contact@althabitah.com</a></h6>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </div>\n    <div class=\"container footer-dark text-center text-sm-start\">\n        <div class=\"row mb-5 sm-mb-30px\">\n            <!-- start footer column -->\n            <div class=\"col-lg-3 col-md-4 col-sm-6 d-flex flex-column last-paragraph-no-margin md-mb-35px\">\n                <a href=\"althabitah.php\" class=\"footer-logo mb-25px xs-mb-20px d-inline-block\">\n                    <img src=\"./components/al-thabitah/assets/images/logo.png\" data-at2x=\"./components/al-thabitah/assets/images/logo.png\" alt=\"Al Thabitah Logo\" />\n                </a>\n                <p class=\"lh-30 w-90 xl-w-100 mx-lg-auto mx-xl-0\">Transforming your space with innovative cleaning solutions.</p>\n                <div class=\"elements-social social-icon-style-02 mt-20px xs-mt-15px\">\n                    <ul class=\"medium-icon light\">\n                        <li class=\"my-0\">\n                            <a class=\"facebook\" href=\"https://www.facebook.com/profile.php?id=100095104812245&mibextid=LQQJ4d\" target=\"_blank\"><i class=\"fa-brands fa-facebook-f\"></i></a>\n                        </li>\n                        <li class=\"my-0\">\n                            <a class=\"youtube\" href=\"https://www.youtube.com/channel/UCbzw6RiqwngeeruQwGi58-A\" target=\"_blank\"><i class=\"fa-brands fa-youtube\"></i></a>\n                        </li>\n                        <li class=\"my-0\">\n                            <a class=\"instagram\" href=\"https://www.instagram.com/althabitah.cleaningservices/\" target=\"_blank\"><i class=\"fa-brands fa-instagram\"></i></a>\n                        </li>\n                        <li class=\"my-0\">\n                            <a class=\"tiktok\" href=\"https://www.tiktok.com/@althabitahcleaningservic?_t=8ohEkhilfXA&_r=1\" target=\"_blank\"><i class=\"fa-brands fa-tiktok\"></i></a>\n                        </li>\n                        <li class=\"my-0\">\n                            <a class=\"whatsapp\" href=\"https://wa.me/971561652741\" target=\"_blank\"><i class=\"fa-brands fa-whatsapp\"></i></a>\n                        </li>\n                    </ul>\n                </div>\n            </div>\n            <!-- end footer column -->\n            <!-- start footer column -->\n            <div class=\"col-lg-3 col-md-4 col-sm-6 last-paragraph-no-margin md-mb-35px\">\n                <span class=\"fs-16 fw-500 d-block text-white mb-5px\">Address</span>\n                <ul>\n                    <li><i class=\"feather icon-feather-map-pin me-10px text-white align-middle\"></i><a href=\"https://maps.app.goo.gl/gmJzsR5mFDXLMiQT9\" target=\"_blank\">Al Rashidiya 2, Al Kaabi Building, Ajman</a></li>\n                    <li><i class=\"feather icon-feather-phone-call me-10px text-white align-middle\"></i><a href=\"tel:+971543379025\">+971 5 4337 9025</a></li>\n                    <li><i class=\"feather icon-feather-mail me-10px text-white align-middle\"></i><a href=\"mailto:contact@althabitah.com\" class=\"not-translate\">contact@althabitah.com</a></li>\n                </ul>\n            </div>\n            <!-- end footer column -->\n            <!-- start footer column -->\n            <div class=\"col-lg-3 col-md-4 col-sm-6 last-paragraph-no-margin md-mb-35px\">\n                <span class=\"fs-17 fw-500 d-block text-white mb-5px\">Our Services</span>\n                <ul>\n                    <li><a href=\"althabitah.php?page=house_cleaning\">House Cleaning</a></li>\n                    <li><a href=\"althabitah.php?page=office_cleaning\">Office Cleaning</a></li>\n                    <li><a href=\"althabitah.php?page=kitchen_cleaning\">Kitchen Cleaning</a></li>\n                    <li><a href=\"althabitah.php?page=water_tank_cleaning\">Water Tank Cleaning</a></li>\n                    <li><a href=\"althabitah.php?page=window_cleaning\">Window Cleaning</a></li>\n                    <li><a href=\"althabitah.php?page=sofa_cleaning\">Sofa Cleaning</a></li>\n                </ul>\n            </div>\n            <!-- end footer column -->\n            <!-- start footer column -->\n            <div class=\"col-lg-3 col-md-4 col-sm-6 last-paragraph-no-margin md-mb-35px\">\n                <span class=\"fs-17 fw-500 d-block text-white mb-5px\">Other Services</span>\n                <ul>\n                    <li><a href=\"althabitah.php?page=carpet_cleaning\">Carpet Cleaning</a></li>\n                    <li><a href=\"althabitah.php?page=mattress_cleaning\">Mattress Cleaning</a></li>\n                    <li><a href=\"althabitah.php?page=curtain_cleaning\">Curtain Cleaning</a></li>\n                    <li><a href=\"althabitah.php?page=plumbing_service\">Plumbing Service</a></li>\n                    <li><a href=\"althabitah.php?page=pest_control_service\">Pest Control Service</a></li>\n                </ul>\n            </div>\n            <!-- end footer column -->\n        </div>\n        <div class=\"row align-items-center footer-bottom border-top border-color-transparent-white-light pt-30px g-0\">\n            <!-- start footer menu -->\n            <div class=\"col-lg-7 ps-0 text-center text-lg-start md-mb-10px\">\n                <ul class=\"footer-navbar fs-15 lh-normal\">\n                    <li class=\"nav-item active\"><a href=\"althabitah.php\" class=\"nav-link ps-0\">Home</a></li>\n                    <li class=\"nav-item\"><a href=\"althabitah.php?page=about_us\" class=\"nav-link\">About Us</a></li>\n                    <li class=\"nav-item\"><a href=\"althabitah.php?page=our_services\" class=\"nav-link\">Our Services</a></li>\n                    <li class=\"nav-item\"><a href=\"althabitah.php?page=booking\" class=\"nav-link\">Book Now</a></li>\n                    <li class=\"nav-item\"><a href=\"althabitah.php?page=contact_us\" class=\"nav-link\">Contact Us</a></li>\n                </ul>\n            </div>\n            <!-- end footer menu -->\n            <!-- start copyright -->\n            <div class=\"col-lg-5 last-paragraph-no-margin text-center text-lg-end\">\n                <p class=\"fs-15\">&copy; 2024 Al Thabitah Cleaning Services And Building Maintenance</p>\n            </div>\n            <!-- start copyright -->\n        </div>\n    </div>\n</footer>\n<!-- end footer -->', '2024-09-06 21:26:51', 2),
(3, 3, '<!-- start slider -->\n<section class=\"p-0 top-space-margin full-screen md-h-600px sm-h-650px\">\n    <div class=\"swiper h-100 magic-cursor swiper-light-pagination\" data-slider-options=\'{ \"slidesPerView\": 1, \"loop\": true, \"pagination\": { \"el\": \".swiper-pagination-bullets\", \"clickable\": true }, \"navigation\": { \"nextEl\": \".slider-one-slide-next-1\", \"prevEl\": \".slider-one-slide-prev-1\" }, \"autoplay\": { \"delay\": 5000, \"disableOnInteraction\": false },  \"keyboard\": { \"enabled\": true, \"onlyInViewport\": true }, \"effect\": \"slide\" }\'>\n        <div class=\"swiper-wrapper\">\n            #{SLIDER_ITEM}\n        </div>\n        <!-- start slider pagination -->\n        <div class=\"swiper-pagination swiper-pagination-clickable swiper-pagination-bullets d-block d-md-none\"></div>\n        <!-- end slider pagination -->\n        <!-- start slider navigation -->\n        <div class=\"slider-one-slide-prev-1 icon-very-medium text-white swiper-button-prev slider-navigation-style-06 bg-black-transparent-medium h-60px w-60px d-none d-sm-flex border-radius-100\"><i class=\"bi bi-arrow-left-short\"></i></div>\n        <div class=\"slider-one-slide-next-1 icon-very-medium text-white swiper-button-next slider-navigation-style-06 bg-black-transparent-medium h-60px w-60px d-none d-sm-flex border-radius-100\"><i class=\"bi bi-arrow-right-short\"></i></div>\n        <!-- end slider navigation -->\n    </div>\n</section>\n<!-- end slider -->', '2024-09-06 22:37:38', 2),
(4, 4, '<!-- start section -->\n<section class=\"p-0 lg-pt-8 xs-pt-50px\">\n    <div class=\"container\">\n        #{CALL_TO_ACTION_ITEM}\n    </div>\n</section>\n<!-- end section -->', '2024-09-06 23:10:17', 2),
(5, 5, '<!-- start section -->\n<section class=\"position-relative\">\n    <div class=\"container\">\n        #{CALL_TO_ACTION_ITEM}\n    </div>\n</section>\n<!-- end section -->', '2024-09-06 23:26:52', 2),
(6, 6, '<!-- start section -->\n<section class=\"half-section\" data-anime=\'{ \"translate\": [0, 0], \"opacity\": [0,1], \"duration\": 600, \"delay\":100, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n    <div class=\"container\">\n        <div class=\"row position-relative clients-style-08\">\n            <div class=\"col swiper text-center feather-shadow\" data-slider-options=\'{ \"slidesPerView\": 3, \"spaceBetween\":0, \"speed\": 3000, \"loop\": true, \"pagination\": { \"el\": \".slider-four-slide-pagination-2\", \"clickable\": false }, \"allowTouchMove\": false, \"autoplay\": { \"delay\":0, \"disableOnInteraction\": false, \"pauseOnMouseEnter\": false}, \"navigation\": { \"nextEl\": \".slider-four-slide-next-2\", \"prevEl\": \".slider-four-slide-prev-2\" }, \"keyboard\": { \"enabled\": true, \"onlyInViewport\": true }, \"breakpoints\": { \"1200\": { \"slidesPerView\": 3 }, \"992\": { \"slidesPerView\": 3 }, \"768\": { \"slidesPerView\": 3 }, \"576\": { \"slidesPerView\": 3 } }, \"effect\": \"slide\" }\'>\n                <div class=\"swiper-wrapper marquee-slide\">\n                    #{CLIENT_ITEM}\n                </div>\n            </div>\n        </div>\n    </div>\n</section>\n<!-- end section -->', '2024-09-06 23:33:52', 2),
(7, 7, '<!-- start section -->\n<section class=\"overflow-hidden bg-gradient-very-light-gray\">\n    <div class=\"container\">\n        <div class=\"row align-items-center\">\n            <div class=\"col-xl-4 col-lg-5 md-mb-50px sm-mb-35px\">\n                <span class=\"fs-20 d-inline-block mb-15px text-base-color\">PROFESSIONAL SERVICES</span>\n                <h3 class=\"alt-font fw-500 text-dark-gray ls-minus-1px w-90 xl-w-100 shadow-none\" data-shadow-animation=\"true\" data-animation-delay=\"700\">Expert <span class=\"fw-700 text-highlight d-inline-block\">cleaning solutions<span class=\"bg-base-color h-10px bottom-1px opacity-3 separator-animation\"></span></span>\n                </h3>\n                <p class=\"mb-30px w-90 md-w-100\">We offer a wide range of cleaning options tailored to suit your space and needs.</p>\n                <div class=\"d-flex\">\n                    <!-- start slider navigation -->\n                    <div class=\"slider-one-slide-prev-1 swiper-button-prev slider-navigation-style-04 bg-white box-shadow-large\"><i class=\"fa-solid fa-arrow-left icon-small text-dark-gray\"></i></div>\n                    <div class=\"slider-one-slide-next-1 swiper-button-next slider-navigation-style-04 bg-white box-shadow-large\"><i class=\"fa-solid fa-arrow-right icon-small text-dark-gray\"></i></div>\n                    <!-- end slider navigation -->\n                </div>\n            </div>\n            <div class=\"col-xl-8 col-lg-7\">\n                <div class=\"outside-box-right-20 sm-outside-box-right-0\" data-anime=\'{ \"translateY\": [0, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n                    <div class=\"swiper magic-cursor slider-one-slide\" data-slider-options=\'{ \"slidesPerView\": 1, \"spaceBetween\": 30, \"loop\": true, \"pagination\": { \"el\": \".slider-three-slide-pagination\", \"clickable\": true, \"dynamicBullets\": true }, \"navigation\": { \"nextEl\": \".slider-one-slide-next-1\", \"prevEl\": \".slider-one-slide-prev-1\" }, \"keyboard\": { \"enabled\": true, \"onlyInViewport\": true }, \"breakpoints\": { \"1200\": { \"slidesPerView\": 3 }, \"768\": { \"slidesPerView\": 2 }, \"320\": { \"slidesPerView\": 1 } }, \"effect\": \"slide\" }\'>\n                        <div class=\"swiper-wrapper\">\n                           #{SERVICES_BOX_ITEM}\n                        </div>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </div>\n</section>\n<!-- end section -->', '2024-09-06 23:55:42', 2),
(8, 8, '<!-- start section -->\n<section class=\"p-0 bg-base-color\">\n    <div class=\"container\">\n       #{CALL_TO_ACTION_ITEM}\n    </div>\n</section>\n<!-- end section -->', '2024-09-07 00:17:55', 2),
(9, 9, '<!-- start section -->\n<section class=\"mb-2\">\n    <div class=\"container\">\n		#{CALL_TO_ACTION_ITEM}\n    </div>\n</section>\n<!-- end section -->', '2024-09-07 00:22:04', 2),
(10, 10, '<!-- start page title -->\n<section class=\"top-space-margin page-title-big-typography cover-background magic-cursor round-cursor\" style=\"background-image: url(#{PAGE_TITLE_IMAGE})\">\n    <div class=\"container\">\n        #{PAGE_TITLE_ITEM}\n    </div>\n</section>\n<!-- end page title -->', '2024-09-07 00:40:23', 2),
(11, 11, '<!-- start section -->\n<section class=\"border-bottom border-color-extra-medium-gray\">\n    <div class=\"container\">\n        <div class=\"row align-items-center justify-content-center\">\n            <div class=\"col-xl-7 col-lg-6 md-mb-9 sm-mb-50px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 600, \"delay\": 0, \"staggervalue\": 100, \"easing\": \"easeOutQuad\" }\'>\n                <span class=\"fs-18 lh-22 fw-700 mb-15px d-inline-block text-uppercase text-dark-gray border-bottom border-2 border-color-base-color\" style=\"\">About Us</span>\n                <h1 class=\"alt-font fw-600 text-dark-gray ls-minus-2px mb-35px shadow-none\" data-shadow-animation=\"true\" data-animation-delay=\"700\">\n                    Our services are <span class=\"text-highlight\">unparalleled<span class=\"bg-base-color h-10px sm-h-8px bottom-20px md-bottom-17px opacity-5 separator-animation\"></span></span>\n                </h1>\n                <div class=\"row\">\n                    <div class=\"col-lg-12 col-md-6 mb-25px last-paragraph-no-margin\">\n                        <p class=\"w-85 md-w-95 sm-w-100\">\n                            At Al Thabitah, we are here for you before, during, and after the service. Our goal is to meet and exceed your expectations. You can rely on us and trust Al Thabitah with all your home service needs. If you are\n                            not satisfied with a service, we will make it right.\n                        </p>\n                    </div>\n                    <div class=\"col-lg-12 col-md-6 mb-25px last-paragraph-no-margin\">\n                        <p class=\"w-85 md-w-95 sm-w-100\">You can schedule your service anytime, wherever you are. Simply enter your information, and we will respond with availability on the same day.</p>\n                    </div>\n                    <div class=\"col-lg-12 col-md-6 mb-25px last-paragraph-no-margin\">\n                        <p class=\"w-85 md-w-95 sm-w-100\">\n                            The name \'Al Thabitah\' means \'steadfast\' in the face of difficulties, reflecting the challenges of the pandemic. We aim to provide the highest quality service to ensure your satisfaction. Our services stand out,\n                            and our priority is your satisfaction.\n                        </p>\n                    </div>\n                </div>\n                <a href=\"althabitah.php?page=our_services\" class=\"btn btn-large btn-dark-gray btn-box-shadow fw-400 btn-round-edge mt-10px md-mt-0\">Our services</a>\n            </div>\n            <div class=\"col-xl-4 offset-xl-1 col-lg-6 position-relative md-mb-6 sm-mb-50px\">\n                <div class=\"overflow-hidden text-end w-80 ms-auto animation-float\" data-anime=\'{ \"effect\": \"slide\", \"direction\": \"lr\", \"color\": \"#bc8947\", \"duration\": 1000, \"delay\": 0 }\'>\n                    <img src=\"./components/al-thabitah/assets/images/about/about-bg-01.jpg\" alt=\"Al Thabitah About Us\" class=\"w-100 border-radius-5px\" />\n                </div>\n                <div\n                    class=\"position-absolute bottom-minus-50px w-60 atropos\"\n                    data-atropos\n                    data-bottom-top=\"transform: translateY(50px)\"\n                    data-top-bottom=\"transform: translateY(-50px)\"\n                    data-anime=\'{ \"effect\": \"slide\", \"direction\": \"lr\", \"color\": \"#bc8947\", \"duration\": 1000, \"delay\": 500 }\'\n                >\n                    <div class=\"atropos-scale\">\n                        <div class=\"atropos-rotate\">\n                            <div class=\"atropos-inner text-center\">\n                                <img class=\"w-100 border-radius-5px\" data-atropos-offset=\"3\" src=\"./components/al-thabitah/assets/images/about/about-bg-02.jpg\" alt=\"Al Thabitah About Us\" />\n                            </div>\n                        </div>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </div>\n</section>\n<!-- end section -->', '2024-09-07 10:42:22', 2),
(12, 12, '<!-- start section -->\n<section class=\"border-bottom border-color-extra-medium-gray\">\n    <div class=\"container\">\n        <div class=\"row align-items-center justify-content-center\">\n            <div class=\"col-xxl-4 col-xl-5 col-lg-6 col-md-10 text-center text-lg-start\" data-anime=\'{ \"translateY\": [0, 0], \"opacity\": [0,1], \"duration\": 600, \"delay\": 200, \"staggervalue\": 300, \"easing\": \"easeOutQuad\" }\'>\n                <div\n                    class=\"swiper slider-one-slide md-mb-50px sm-mb-40px text-slider-style-01\"\n                    data-slider-options=\'{ \"slidesPerView\": 1, \"loop\": true, \"pagination\": { \"el\": \".slider-one-slide-pagination\", \"clickable\": true }, \"autoplay\": { \"delay\": 4000, \"disableOnInteraction\": false }, \"navigation\": { \"nextEl\": \".slider-one-slide-next-1\", \"prevEl\": \".slider-one-slide-prev-1\" }, \"keyboard\": { \"enabled\": true, \"onlyInViewport\": true }, \"effect\": \"slide\" }\'\n                >\n                    <div class=\"swiper-wrapper mb-30px\">\n                        <!-- start text slider item -->\n                        <div class=\"swiper-slide\">\n                            <div class=\"alt-font text-uppercase text-base-color fw-600 mb-15px d-inline-block ls-1px\">Our mission</div>\n                            <span class=\"d-inline-block w-95 md-w-100\">\n                                Provide our customers a level of service unequalled in the cleaning industry. Develop an organization that will encourage all people to prosper and grow to their full potential. Protect the health and safety\n                                of all our people.\n                            </span>\n                        </div>\n                        <!-- end text slider item -->\n                        <!-- start text slider item -->\n                        <div class=\"swiper-slide\">\n                            <div class=\"alt-font text-uppercase text-base-color fw-600 mb-15px d-inline-block ls-1px\">Our Vision</div>\n                            <span class=\"d-inline-block w-95 md-w-100\">\n                                We strive to become the leading cleaning service provider in the industry. We aim to become the supplier of choice for all our clients. We aim to offer true value for money on all our services offered.\n                            </span>\n                        </div>\n                        <!-- end text slider item -->\n                        <!-- start text slider item -->\n                        <div class=\"swiper-slide\">\n                            <div class=\"alt-font text-uppercase text-base-color fw-600 mb-15px d-inline-block ls-1px\">Our Commitment</div>\n                            <span class=\"d-inline-block w-95 md-w-100\">\n                                The company was given the name (AL THABITAH) in line with the pandemic that the world has experienced, which means steadfastness in the face of ifficulties, and our goal is your satisfaction. We provide the\n                                best services with quality standards, and our suitability is not the best, but we are distinguished, and our goal is your satisfaction.\n                            </span>\n                        </div>\n                        <!-- end text slider item -->\n                    </div>\n                    <div class=\"d-flex justify-content-center justify-content-lg-start\">\n                        <!-- start slider navigation -->\n                        <div class=\"slider-one-slide-prev-1 text-dark-gray swiper-button-prev slider-navigation-style-04 border border-1 border-color-extra-medium-gray bg-white\"><i class=\"fa-solid fa-arrow-left\"></i></div>\n                        <div class=\"slider-one-slide-next-1 text-dark-gray swiper-button-next slider-navigation-style-04 border border-1 border-color-extra-medium-gray bg-white\"><i class=\"fa-solid fa-arrow-right\"></i></div>\n                        <!-- end slider navigation -->\n                    </div>\n                </div>\n            </div>\n            <div class=\"col-xl-6 col-lg-6 offset-xl-1 position-relative text-end md-mb-6 sm-mb-10 xs-mb-12\">\n                <div class=\"text-end w-80 md-w-75 ms-auto\" data-animation-delay=\"100\" data-shadow-animation=\"true\" data-bottom-top=\"transform: translateY(50px)\" data-top-bottom=\"transform: translateY(-50px)\">\n                    <img src=\"./components/al-thabitah/assets/images/title/title-our-services.jpg\" alt=\"About Us Vision Mision Core Values\" class=\"border-radius-5px\" />\n                </div>\n                <div\n                    class=\"w-60 md-w-50 xs-w-55 overflow-hidden position-absolute left-15px bottom-minus-50px\"\n                    data-shadow-animation=\"true\"\n                    data-animation-delay=\"200\"\n                    data-bottom-top=\"transform: translateY(-50px)\"\n                    data-top-bottom=\"transform: translateY(50px)\"\n                >\n                    <img src=\"./components/al-thabitah/assets/images/title/title-contact-us-02.jpg\" alt=\"About Us Vision Mision Core Values\" class=\"border-radius-5px\" />\n                </div>\n            </div>\n        </div>\n    </div>\n</section>\n<!-- end section -->\n', '2024-09-07 11:00:38', 2),
(13, 13, '<!-- start section -->\n<section class=\"position-relative overflow-hidden overlap-height pb-0 mb-10\">\n    <img\n        src=\"./components/al-thabitah/assets/images/icons/about-icon-01.png\"\n        class=\"position-absolute left-150px top-50px z-index-minus-1\"\n        alt=\"About Us Testimonial\"\n        data-bottom-top=\"transform: translate3d(80px, 0px, 0px);\"\n        data-top-bottom=\"transform: translate3d(-380px, 0px, 0px);\"\n    />\n    <img\n        src=\"./components/al-thabitah/assets/images/icons/about-icon-02.png\"\n        class=\"position-absolute right-100px top-50px z-index-minus-1\"\n        alt=\"About Us Testimonial\"\n        data-bottom-top=\"transform:scale(1.4, 1.4) translate3d(0px, 0px, 0px);\"\n        data-top-bottom=\"transform:scale(1, 1) translate3d(-300px, 0px, 0px);\"\n    />\n    <div class=\"container overlap-gap-section\">\n        <div class=\"row align-items-center justify-content-lg-start justify-content-center text-lg-start text-center\">\n            <div class=\"col-lg-6 col-md-10 md-mb-50px\">\n                <figure class=\"position-relative m-0 md-w-95 xs-w-90\">\n                    <img src=\"./components/al-thabitah/assets/images/title/title-booking.jpg\" class=\"w-90 border-radius-8px\" alt=\"About Us Testimonial\" />\n                    <figcaption\n                        class=\"position-absolute bg-dark-gray border-radius-10px box-shadow-quadruple-large bottom-100px xs-bottom-minus-10px right-minus-30px w-240px xs-w-200px text-center last-paragraph-no-margin animation-float\"\n                    ></figcaption>\n                </figure>\n            </div>\n            <div class=\"col-lg-5 col-md-10 offset-lg-1\" data-anime=\'{ \"translateY\": [0, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n                <span class=\"fs-16 lh-22 fw-700 mb-15px d-inline-block text-uppercase text-dark-gray border-bottom border-2 border-color-base-color\">A few good reasons</span>\n                <h2 class=\"fw-700 text-dark-gray ls-minus-1px\">Here is what our clients have to say.</h2>\n                <div\n                    class=\"swiper position-relative\"\n                    data-slider-options=\'{ \"autoHeight\": true, \"loop\": true, \"allowTouchMove\": true, \"autoplay\": { \"delay\": 4000, \"disableOnInteraction\": false }, \"navigation\": { \"nextEl\": \".swiper-button-next\", \"prevEl\": \".swiper-button-prev\" }, \"effect\": \"fade\" }\'\n                >\n                    <div class=\"swiper-wrapper mb-40px\">\n                        #{TESTIMONIAL_ITEM}\n                    </div>\n                    <div class=\"d-flex justify-content-lg-start justify-content-center\">\n                        <!-- start slider navigation -->\n                        <div class=\"slider-one-slide-prev-1 swiper-button-prev slider-navigation-style-04 border border-color-extra-medium-gray\"><i class=\"fa-solid fa-arrow-left text-dark-gray icon-small\"></i></div>\n                        <div class=\"slider-one-slide-next-1 swiper-button-next slider-navigation-style-04 border border-color-extra-medium-gray\"><i class=\"fa-solid fa-arrow-right text-dark-gray icon-small\"></i></div>\n                        <!-- end slider navigation -->\n                    </div>\n                </div>\n            </div>\n        </div>\n    </div>\n</section>\n<!-- end section -->', '2024-09-07 11:07:51', 2),
(14, 14, '<!-- start section -->\n<section class=\"bg-very-light-gray pb-8\">\n    <div class=\"container\">\n        <div\n            class=\"row row-cols-1 row-cols-lg-3 row-cols-md-2 justify-content-center mb-70px md-mb-50px\"\n            data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'\n        >\n            #{SERVICES_BOX_ITEM}            \n        </div>\n        <div class=\"row\">\n            <div class=\"col d-flex justify-content-center align-items-center\">\n                <i class=\"bi bi-patch-check-fill text-base-color icon-very-medium me-10px\"></i>\n                <span class=\"fs-22 fw-500 text-dark-gray\">We are committed to providing <span class=\"text-decoration-line-bottom text-dark-gray fw-700\">cost-effective solutions</span> to all of our clients.</span>\n            </div>\n        </div>\n    </div>\n</section>\n<!-- end section -->', '2024-09-07 11:42:54', 2),
(15, 15, '<!-- start section -->\n<section class=\"mb-2\">\n    <div class=\"container\">\n        <div class=\"row\">\n            <div class=\"col-lg-4 pe-5 order-2 order-lg-1 lg-pe-3 md-pe-15px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n                #{SERVICES_SHORTCUT}\n            </div>\n            <div class=\"col-lg-8 order-1 order-lg-2 md-mb-50px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n                <h4 class=\"text-dark-gray fw-700 ls-minus-1px mb-20px d-block\">House Cleaning</h4>\n                <p>\n                    Welcome to AL THABITAH\'s House Cleaning Service, where we turn your house into a spotless sanctuary. Our expert team specializes in providing comprehensive cleaning solutions tailored to meet your unique needs. From\n                    routine maintenance to deep cleaning, we handle it all with meticulous attention to detail and professionalism. Using advanced equipment and eco-friendly products, we ensure a thorough clean that leaves every corner of\n                    your home sparkling. Sit back, relax, and let us take care of the dirty work, so you can enjoy a clean and comfortable living space. Experience the difference with AL THABITAH\'s House Cleaning Service today.\n                </p>\n                <div\n                    class=\"cover-background p-7 border-radius-6px mb-60px md-mb-40px d-flex justify-content-end align-items-end sm-h-500px\"\n                    style=\"background-image: url(./components/al-thabitah/assets/images/services/house-cleaning-02.jpg);\"\n                >\n                    <div class=\"bg-white box-shadow-quadruple-large border-radius-4px w-50 lg-w-55 sm-w-100 overflow-hidden\">\n                        <div class=\"p-40px lg-p-25px last-paragraph-no-margin\">\n                            <span class=\"fs-22 text-dark-gray fw-700 mb-10px d-block\">Professional Cleaning</span>\n                            <p>Tailored solutions to meet your cleaning needs, ensuring spotless results every time.</p>\n                        </div>\n                        <div class=\"bg-base-color p-15px text-center\">\n                            <a href=\"althabitah.php?page=contact_us\" class=\"text-dark-gray text-dark-gray-hover fw-600\"><i class=\"feather icon-feather-mail me-10px\"></i>Talk with our team</a>\n                        </div>\n                    </div>\n                </div>\n                <h4 class=\"text-dark-gray fw-700 mb-40px lg-mb-30px d-block\">Benefits of working with us</h4>\n                <div class=\"border border-color-extra-medium-gray border-radius-6px mb-40px xs-mb-30px overflow-hidden\">\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Spotless Living: </span>Experience a fresh and clean home with meticulous attention to detail.</p>\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Time-Saving: </span>Let us handle the cleaning while you focus on what matters most.</p>\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Healthier Home: </span>Remove dust, allergens, and germs for a healthier living environment.</p>\n                    <p class=\"p-30px mb-0\"><span class=\"fw-600 text-dark-gray\">Professional Care: </span>Rest easy knowing experts are taking care of your space.</p>\n                </div>\n                <div class=\"row align-items-center g-0\">\n                    <div class=\"col-auto d-block d-sm-flex align-items-center text-center text-sm-start\">\n                        <div class=\"fw-500 last-paragraph-no-margin text-dark-gray ps-15px xs-ps-0 xs-mt-15px\">\n                            <p>Save your time and effort spent for finding a solution. <a href=\"althabitah.php?page=contact_us\" class=\"text-decoration-line-bottom fw-700 text-dark-gray\">Contact us now</a></p>\n                        </div>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </div>\n</section>\n<!-- end section -->\n', '2024-09-07 12:31:37', 2);
INSERT INTO `block_container` (`block_container_id`, `block_style_id`, `block_container`, `created_date`, `last_log_by`) VALUES
(16, 16, '<!-- start section -->\n<section class=\"mb-2\">\n    <div class=\"container\">\n        <div class=\"row\">\n            <div class=\"col-lg-4 pe-5 order-2 order-lg-1 lg-pe-3 md-pe-15px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n                #{SERVICES_SHORTCUT}\n            </div>\n            <div class=\"col-lg-8 order-1 order-lg-2 md-mb-50px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n                <h4 class=\"text-dark-gray fw-700 ls-minus-1px mb-20px d-block\">Office Cleaning</h4>\n                <p>\n                    Transform your workplace into a shining beacon of professionalism with AL THABITAH\'s Office Cleaning Service. Our dedicated team understands the importance of a clean and orderly workspace for productivity and employee\n                    well-being. With our meticulous attention to detail and efficient cleaning techniques, we ensure every corner of your office is spotless and inviting. From disinfecting high-touch surfaces to vacuuming carpets and\n                    polishing surfaces, we handle it all with expertise and care. Experience the difference with AL THABITAH\'s Office Cleaning Service and enjoy a cleaner, healthier, and more productive work environment.\n                </p>\n                <div class=\"cover-background p-7 border-radius-6px mb-60px md-mb-40px d-flex justify-content-end align-items-end sm-h-500px\" style=\"background-image: url(./components/al-thabitah/assets/images/services/office-cleaning-02.jpg);\">\n                    <div class=\"bg-white box-shadow-quadruple-large border-radius-4px w-50 lg-w-55 sm-w-100 overflow-hidden\">\n                        <div class=\"p-40px lg-p-25px last-paragraph-no-margin\">\n                            <span class=\"fs-22 text-dark-gray fw-700 mb-10px d-block\">Professional Cleaning</span>\n                            <p>Tailored solutions to meet your cleaning needs, ensuring spotless results every time.</p>\n                        </div>\n                        <div class=\"bg-base-color p-15px text-center\">\n                            <a href=\"althabitah.php?page=contact_us\" class=\"text-dark-gray text-dark-gray-hover fw-600\"><i class=\"feather icon-feather-mail me-10px\"></i>Talk with our team</a>\n                        </div>\n                    </div>\n                </div>\n                <h4 class=\"text-dark-gray fw-700 mb-40px lg-mb-30px d-block\">Benefits of working with us</h4>\n                <div class=\"border border-color-extra-medium-gray border-radius-6px mb-40px xs-mb-30px overflow-hidden\">\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Productivity Boost: </span>A clean office promotes a focused and efficient work environment.</p>\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Impress Clients: </span>Maintain a professional image with a consistently clean workspace.</p>\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Custom Schedules: </span>Flexible cleaning plans tailored to fit your business needs.</p>\n                    <p class=\"p-30px mb-0\"><span class=\"fw-600 text-dark-gray\">Hygienic Solutions: </span>Ensure a safe and sanitary environment for your employees.</p>\n                </div>\n                <div class=\"row align-items-center g-0\">\n                    <div class=\"col-auto d-block d-sm-flex align-items-center text-center text-sm-start\">\n                        <div class=\"fw-500 last-paragraph-no-margin text-dark-gray ps-15px xs-ps-0 xs-mt-15px\">\n                            <p>Save your time and effort spent for finding a solution. <a href=\"althabitah.php?page=contact_us\" class=\"text-decoration-line-bottom fw-700 text-dark-gray\">Contact us now</a></p>\n                        </div>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </div>\n</section>\n<!-- end section -->', '2024-09-07 12:42:35', 2),
(17, 17, '<!-- start section -->\n<section class=\"mb-2\">\n    <div class=\"container\">\n        <div class=\"row\">\n            <div class=\"col-lg-4 pe-5 order-2 order-lg-1 lg-pe-3 md-pe-15px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n                #{SERVICES_SHORTCUT}\n            </div>\n            <div class=\"col-lg-8 order-1 order-lg-2 md-mb-50px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n                <h4 class=\"text-dark-gray fw-700 ls-minus-1px mb-20px d-block\">Kitchen Cleaning</h4>\n                <p>\n                    Elevate your kitchen to a gleaming showcase of hygiene and functionality with AL THABITAH\'s Kitchen Cleaning Service. Our skilled team specializes in tackling grease, grime, and dirt buildup, leaving your kitchen\n                    surfaces sparkling and sanitized. From countertops to appliances and floors, we meticulously clean every surface with eco-friendly products, ensuring a safe and healthy cooking environment. Say goodbye to stubborn stains\n                    and odors, and hello to a fresh and inviting kitchen space. Experience the transformative power of AL THABITAH\'s Kitchen Cleaning Service and enjoy cooking in a pristine environment.\n                </p>\n                <div\n                    class=\"cover-background p-7 border-radius-6px mb-60px md-mb-40px d-flex justify-content-end align-items-end sm-h-500px\"\n                    style=\"background-image: url(./components/al-thabitah/assets/images/services/kitchen-cleaning-02.jpg);\"\n                >\n                    <div class=\"bg-white box-shadow-quadruple-large border-radius-4px w-50 lg-w-55 sm-w-100 overflow-hidden\">\n                        <div class=\"p-40px lg-p-25px last-paragraph-no-margin\">\n                            <span class=\"fs-22 text-dark-gray fw-700 mb-10px d-block\">Professional Cleaning</span>\n                            <p>Tailored solutions to meet your cleaning needs, ensuring spotless results every time.</p>\n                        </div>\n                        <div class=\"bg-base-color p-15px text-center\">\n                            <a href=\"althabitah.php?page=contact_us\" class=\"text-dark-gray text-dark-gray-hover fw-600\"><i class=\"feather icon-feather-mail me-10px\"></i>Talk with our team</a>\n                        </div>\n                    </div>\n                </div>\n                <h4 class=\"text-dark-gray fw-700 mb-40px lg-mb-30px d-block\">Benefits of working with us</h4>\n                <div class=\"border border-color-extra-medium-gray border-radius-6px mb-40px xs-mb-30px overflow-hidden\">\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Hygienic Kitchen: </span>Deep cleaning for a germ-free and spotless kitchen.</p>\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Food Safety: </span>Maintain cleanliness standards to support a safe cooking space.</p>\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Odor Removal: </span>Eliminate lingering food odors with thorough cleaning.</p>\n                    <p class=\"p-30px mb-0\"><span class=\"fw-600 text-dark-gray\">Expert Care: </span>Leave hard-to-clean areas like grease buildup to the professionals.</p>\n                </div>\n                <div class=\"row align-items-center g-0\">\n                    <div class=\"col-auto d-block d-sm-flex align-items-center text-center text-sm-start\">\n                        <div class=\"fw-500 last-paragraph-no-margin text-dark-gray ps-15px xs-ps-0 xs-mt-15px\">\n                            <p>Save your time and effort spent for finding a solution. <a href=\"althabitah.php?page=contact_us\" class=\"text-decoration-line-bottom fw-700 text-dark-gray\">Contact us now</a></p>\n                        </div>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </div>\n</section>\n<!-- end section -->\n', '2024-09-07 12:48:40', 2),
(18, 18, '<!-- start section -->\n<section class=\"mb-2\">\n    <div class=\"container\">\n        <div class=\"row\">\n            <div class=\"col-lg-4 pe-5 order-2 order-lg-1 lg-pe-3 md-pe-15px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n                #{SERVICES_SHORTCUT}\n            </div>\n            <div class=\"col-lg-8 order-1 order-lg-2 md-mb-50px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n                <h4 class=\"text-dark-gray fw-700 ls-minus-1px mb-20px d-block\">Water Tank Cleaning</h4>\n                <p>\n                    Ensure clean and safe water storage with AL THABITAH\'s Water Tank Cleaning Service. Our expert team specializes in removing sludge, contaminants, and impurities from your tanks, delivering a thorough cleaning that\n                    guarantees fresh, healthy water. We use advanced techniques and eco-friendly products to sanitize every corner, leaving your water tank spotless and hygienic. Protect your family from waterborne diseases and enjoy peace\n                    of mind with AL THABITAH’s reliable and professional service. Experience the difference of a well-maintained water tank and keep your water supply safe and pure.\n                </p>\n                <div\n                    class=\"cover-background p-7 border-radius-6px mb-60px md-mb-40px d-flex justify-content-end align-items-end sm-h-500px\"\n                    style=\"background-image: url(./components/al-thabitah/assets/images/services/water-tank-cleaning-02.jpg);\"\n                >\n                    <div class=\"bg-white box-shadow-quadruple-large border-radius-4px w-50 lg-w-55 sm-w-100 overflow-hidden\">\n                        <div class=\"p-40px lg-p-25px last-paragraph-no-margin\">\n                            <span class=\"fs-22 text-dark-gray fw-700 mb-10px d-block\">Professional Cleaning</span>\n                            <p>Tailored solutions to meet your cleaning needs, ensuring spotless results every time.</p>\n                        </div>\n                        <div class=\"bg-base-color p-15px text-center\">\n                            <a href=\"althabitah.php?page=contact_us\" class=\"text-dark-gray text-dark-gray-hover fw-600\"><i class=\"feather icon-feather-mail me-10px\"></i>Talk with our team</a>\n                        </div>\n                    </div>\n                </div>\n                <h4 class=\"text-dark-gray fw-700 mb-40px lg-mb-30px d-block\">Benefits of working with us</h4>\n                <div class=\"border border-color-extra-medium-gray border-radius-6px mb-40px xs-mb-30px overflow-hidden\">\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Safe Water Storage: </span>Protect your family’s health with clean and sanitized water tanks.</p>\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Prevent Contamination: </span>Regular cleaning ensures safe and contamination-free water.</p>\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Thorough Service: </span>We clean every corner, removing sludge and impurities.</p>\n                    <p class=\"p-30px mb-0\"><span class=\"fw-600 text-dark-gray\">Reliable Results: </span>Professional service that meets hygiene standards.</p>\n                </div>\n                <div class=\"row align-items-center g-0\">\n                    <div class=\"col-auto d-block d-sm-flex align-items-center text-center text-sm-start\">\n                        <div class=\"fw-500 last-paragraph-no-margin text-dark-gray ps-15px xs-ps-0 xs-mt-15px\">\n                            <p>Save your time and effort spent for finding a solution. <a href=\"althabitah.php?page=contact_us\" class=\"text-decoration-line-bottom fw-700 text-dark-gray\">Contact us now</a></p>\n                        </div>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </div>\n</section>\n<!-- end section -->\n', '2024-09-07 12:58:04', 2),
(19, 19, '<!-- start section -->\n<section class=\"mb-2\">\n    <div class=\"container\">\n        <div class=\"row\">\n            <div class=\"col-lg-4 pe-5 order-2 order-lg-1 lg-pe-3 md-pe-15px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n                #{SERVICES_SHORTCUT}\n            </div>\n            <div class=\"col-lg-8 order-1 order-lg-2 md-mb-50px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n                <h4 class=\"text-dark-gray fw-700 ls-minus-1px mb-20px d-block\">Window Cleaning</h4>\n                <p>\n                    Let the sunshine in with AL THABITAH\'s Window Cleaning Service. Our expert team is dedicated to making your windows sparkle, enhancing the beauty and brightness of your space. Using professional-grade equipment and\n                    techniques, we ensure streak-free results for a flawless finish. From high-rise buildings to residential homes, no window is too big or too small for our thorough cleaning approach. Say goodbye to dirt, dust, and grime,\n                    and hello to crystal-clear views. Experience the clarity and cleanliness with AL THABITAH\'s Window Cleaning Service today.\n                </p>\n                <div\n                    class=\"cover-background p-7 border-radius-6px mb-60px md-mb-40px d-flex justify-content-end align-items-end sm-h-500px\"\n                    style=\"background-image: url(./components/al-thabitah/assets/images/services/window-cleaning-02.jpg);\"\n                >\n                    <div class=\"bg-white box-shadow-quadruple-large border-radius-4px w-50 lg-w-55 sm-w-100 overflow-hidden\">\n                        <div class=\"p-40px lg-p-25px last-paragraph-no-margin\">\n                            <span class=\"fs-22 text-dark-gray fw-700 mb-10px d-block\">Professional Cleaning</span>\n                            <p>Tailored solutions to meet your cleaning needs, ensuring spotless results every time.</p>\n                        </div>\n                        <div class=\"bg-base-color p-15px text-center\">\n                            <a href=\"althabitah.php?page=contact_us\" class=\"text-dark-gray text-dark-gray-hover fw-600\"><i class=\"feather icon-feather-mail me-10px\"></i>Talk with our team</a>\n                        </div>\n                    </div>\n                </div>\n                <h4 class=\"text-dark-gray fw-700 mb-40px lg-mb-30px d-block\">Benefits of working with us</h4>\n                <div class=\"border border-color-extra-medium-gray border-radius-6px mb-40px xs-mb-30px overflow-hidden\">\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Clear Views: </span>Enjoy streak-free, sparkling windows for a brighter space.</p>\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Enhanced Curb Appeal: </span>Make a great impression with spotless windows.</p>\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Safe Cleaning: </span>We handle hard-to-reach windows safely and effectively.</p>\n                    <p class=\"p-30px mb-0\"><span class=\"fw-600 text-dark-gray\">Long-Lasting Shine: </span>Professional cleaning extends the life of your windows.</p>\n                </div>\n                <div class=\"row align-items-center g-0\">\n                    <div class=\"col-auto d-block d-sm-flex align-items-center text-center text-sm-start\">\n                        <div class=\"fw-500 last-paragraph-no-margin text-dark-gray ps-15px xs-ps-0 xs-mt-15px\">\n                            <p>Save your time and effort spent for finding a solution. <a href=\"althabitah.php?page=contact_us\" class=\"text-decoration-line-bottom fw-700 text-dark-gray\">Contact us now</a></p>\n                        </div>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </div>\n</section>\n<!-- end section -->\n', '2024-09-07 16:17:16', 2),
(20, 20, '<!-- start section -->\n<section class=\"mb-2\">\n    <div class=\"container\">\n        <div class=\"row\">\n            <div class=\"col-lg-4 pe-5 order-2 order-lg-1 lg-pe-3 md-pe-15px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n                #{SERVICES_SHORTCUT}\n            </div>\n            <div class=\"col-lg-8 order-1 order-lg-2 md-mb-50px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n                <h4 class=\"text-dark-gray fw-700 ls-minus-1px mb-20px d-block\">Sofa Cleaning</h4>\n                <p>\n                    Refresh your living space with AL THABITAH\'s Sofa Cleaning Service. Our skilled team removes dirt, stains, and allergens from deep within the fabric, restoring your sofa\'s comfort and appearance. Using safe,\n                    professional-grade products and techniques, we ensure thorough cleaning without damaging delicate materials. Whether it’s fabric or leather, we treat your sofa with care, leaving it fresh, clean, and ready for you to\n                    relax. Experience a renewed level of comfort with AL THABITAH’s Sofa Cleaning Service today.\n                </p>\n                <div\n                    class=\"cover-background p-7 border-radius-6px mb-60px md-mb-40px d-flex justify-content-end align-items-end sm-h-500px\"\n                    style=\"background-image: url(./components/al-thabitah/assets/images/services/sofa-cleaning-02.jpg);\"\n                >\n                    <div class=\"bg-white box-shadow-quadruple-large border-radius-4px w-50 lg-w-55 sm-w-100 overflow-hidden\">\n                        <div class=\"p-40px lg-p-25px last-paragraph-no-margin\">\n                            <span class=\"fs-22 text-dark-gray fw-700 mb-10px d-block\">Professional Cleaning</span>\n                            <p>Tailored solutions to meet your cleaning needs, ensuring spotless results every time.</p>\n                        </div>\n                        <div class=\"bg-base-color p-15px text-center\">\n                            <a href=\"althabitah.php?page=contact_us\" class=\"text-dark-gray text-dark-gray-hover fw-600\"><i class=\"feather icon-feather-mail me-10px\"></i>Talk with our team</a>\n                        </div>\n                    </div>\n                </div>\n                <h4 class=\"text-dark-gray fw-700 mb-40px lg-mb-30px d-block\">Benefits of working with us</h4>\n                <div class=\"border border-color-extra-medium-gray border-radius-6px mb-40px xs-mb-30px overflow-hidden\">\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Restored Comfort: </span>Enjoy a fresh, clean sofa that feels like new.</p>\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Stain Removal: </span>Get rid of stubborn stains without damaging your furniture.</p>\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Deep Cleaning: </span>Eliminate embedded dirt and allergens for a healthier environment.</p>\n                    <p class=\"p-30px mb-0\"><span class=\"fw-600 text-dark-gray\">Fabric Protection: </span>Gentle cleaning preserves the quality of your upholstery.</p>\n                </div>\n                <div class=\"row align-items-center g-0\">\n                    <div class=\"col-auto d-block d-sm-flex align-items-center text-center text-sm-start\">\n                        <div class=\"fw-500 last-paragraph-no-margin text-dark-gray ps-15px xs-ps-0 xs-mt-15px\">\n                            <p>Save your time and effort spent for finding a solution. <a href=\"althabitah.php?page=contact_us\" class=\"text-decoration-line-bottom fw-700 text-dark-gray\">Contact us now</a></p>\n                        </div>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </div>\n</section>\n<!-- end section -->\n', '2024-09-07 16:26:14', 2),
(21, 21, '<!-- start section -->\n<section class=\"mb-2\">\n    <div class=\"container\">\n        <div class=\"row\">\n            <div class=\"col-lg-4 pe-5 order-2 order-lg-1 lg-pe-3 md-pe-15px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n                #{SERVICES_SHORTCUT}\n            </div>\n            <div class=\"col-lg-8 order-1 order-lg-2 md-mb-50px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n                <h4 class=\"text-dark-gray fw-700 ls-minus-1px mb-20px d-block\">Carpet Cleaning</h4>\n                <p>\n                    Revive your carpets with AL THABITAH’s Carpet Cleaning Service. Our expert team uses powerful equipment to remove dirt, stains, and odors, leaving your carpets fresh and vibrant. We specialize in deep cleaning that not\n                    only restores the appearance of your carpets but also prolongs their lifespan. From high-traffic areas to delicate rugs, our tailored approach ensures thorough cleaning for every type of carpet. Trust AL THABITAH to\n                    bring new life to your carpets with exceptional results.\n                </p>\n                <div\n                    class=\"cover-background p-7 border-radius-6px mb-60px md-mb-40px d-flex justify-content-end align-items-end sm-h-500px\"\n                    style=\"background-image: url(./components/al-thabitah/assets/images/services/carpet-cleaning-02.jpg);\"\n                >\n                    <div class=\"bg-white box-shadow-quadruple-large border-radius-4px w-50 lg-w-55 sm-w-100 overflow-hidden\">\n                        <div class=\"p-40px lg-p-25px last-paragraph-no-margin\">\n                            <span class=\"fs-22 text-dark-gray fw-700 mb-10px d-block\">Professional Cleaning</span>\n                            <p>Tailored solutions to meet your cleaning needs, ensuring spotless results every time.</p>\n                        </div>\n                        <div class=\"bg-base-color p-15px text-center\">\n                            <a href=\"althabitah.php?page=contact_us\" class=\"text-dark-gray text-dark-gray-hover fw-600\"><i class=\"feather icon-feather-mail me-10px\"></i>Talk with our team</a>\n                        </div>\n                    </div>\n                </div>\n                <h4 class=\"text-dark-gray fw-700 mb-40px lg-mb-30px d-block\">Benefits of working with us</h4>\n                <div class=\"border border-color-extra-medium-gray border-radius-6px mb-40px xs-mb-30px overflow-hidden\">\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Vibrant Appearance: </span>Restore the colors and texture of your carpets.</p>\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Deep Stain Removal: </span>Effective solutions for even the toughest stains.</p>\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Odor Elimination: </span>Freshen up your space with odor-free carpets.</p>\n                    <p class=\"p-30px mb-0\"><span class=\"fw-600 text-dark-gray\">Extended Lifespan: </span>Regular cleaning preserves the quality and durability of your carpets.</p>\n                </div>\n                <div class=\"row align-items-center g-0\">\n                    <div class=\"col-auto d-block d-sm-flex align-items-center text-center text-sm-start\">\n                        <div class=\"fw-500 last-paragraph-no-margin text-dark-gray ps-15px xs-ps-0 xs-mt-15px\">\n                            <p>Save your time and effort spent for finding a solution. <a href=\"althabitah.php?page=contact_us\" class=\"text-decoration-line-bottom fw-700 text-dark-gray\">Contact us now</a></p>\n                        </div>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </div>\n</section>\n<!-- end section -->\n', '2024-09-07 16:29:15', 2),
(22, 22, '<!-- start section -->\n<section class=\"mb-2\">\n    <div class=\"container\">\n        <div class=\"row\">\n            <div class=\"col-lg-4 pe-5 order-2 order-lg-1 lg-pe-3 md-pe-15px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n                #{SERVICES_SHORTCUT}\n            </div>\n            <div class=\"col-lg-8 order-1 order-lg-2 md-mb-50px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n                <h4 class=\"text-dark-gray fw-700 ls-minus-1px mb-20px d-block\">Mattress Cleaning</h4>\n                <p>\n                    Sleep better with AL THABITAH’s Mattress Cleaning Service. Our specialized cleaning process targets dust mites, allergens, and stains that accumulate over time, ensuring a healthier and more comfortable sleep\n                    environment. Using eco-friendly products and deep-cleaning techniques, we eliminate hidden contaminants while protecting the integrity of your mattress. Say goodbye to allergens and hello to a fresher, cleaner mattress\n                    with AL THABITAH’s professional service.\n                </p>\n                <div\n                    class=\"cover-background p-7 border-radius-6px mb-60px md-mb-40px d-flex justify-content-end align-items-end sm-h-500px\"\n                    style=\"background-image: url(./components/al-thabitah/assets/images/services/mattress-cleaning-02.jpg);\"\n                >\n                    <div class=\"bg-white box-shadow-quadruple-large border-radius-4px w-50 lg-w-55 sm-w-100 overflow-hidden\">\n                        <div class=\"p-40px lg-p-25px last-paragraph-no-margin\">\n                            <span class=\"fs-22 text-dark-gray fw-700 mb-10px d-block\">Professional Cleaning</span>\n                            <p>Tailored solutions to meet your cleaning needs, ensuring spotless results every time.</p>\n                        </div>\n                        <div class=\"bg-base-color p-15px text-center\">\n                            <a href=\"althabitah.php?page=contact_us\" class=\"text-dark-gray text-dark-gray-hover fw-600\"><i class=\"feather icon-feather-mail me-10px\"></i>Talk with our team</a>\n                        </div>\n                    </div>\n                </div>\n                <h4 class=\"text-dark-gray fw-700 mb-40px lg-mb-30px d-block\">Benefits of working with us</h4>\n                <div class=\"border border-color-extra-medium-gray border-radius-6px mb-40px xs-mb-30px overflow-hidden\">\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Healthier Sleep: </span>Remove dust mites and allergens for a cleaner mattress.</p>\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Stain Removal: </span>Tackle tough stains without compromising mattress quality.</p>\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Odor Control: </span>Freshen your mattress for a more inviting sleep space.</p>\n                    <p class=\"p-30px mb-0\"><span class=\"fw-600 text-dark-gray\">Extended Mattress Life: </span>Proper care enhances the longevity of your mattress.</p>\n                </div>\n                <div class=\"row align-items-center g-0\">\n                    <div class=\"col-auto d-block d-sm-flex align-items-center text-center text-sm-start\">\n                        <div class=\"fw-500 last-paragraph-no-margin text-dark-gray ps-15px xs-ps-0 xs-mt-15px\">\n                            <p>Save your time and effort spent for finding a solution. <a href=\"althabitah.php?page=contact_us\" class=\"text-decoration-line-bottom fw-700 text-dark-gray\">Contact us now</a></p>\n                        </div>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </div>\n</section>\n<!-- end section -->\n', '2024-09-07 16:34:06', 2),
(23, 23, '<!-- start section -->\n<section class=\"mb-2\">\n    <div class=\"container\">\n        <div class=\"row\">\n            <div class=\"col-lg-4 pe-5 order-2 order-lg-1 lg-pe-3 md-pe-15px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n                #{SERVICES_SHORTCUT}\n            </div>\n            <div class=\"col-lg-8 order-1 order-lg-2 md-mb-50px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n                <h4 class=\"text-dark-gray fw-700 ls-minus-1px mb-20px d-block\">Curtain Cleaning</h4>\n                <p>\n                    Bring elegance back to your windows with AL THABITAH’s Curtain Cleaning Service. Our team carefully cleans and revitalizes your curtains, removing dust, stains, and allergens while preserving fabric quality. We use\n                    gentle yet effective methods that are safe for all curtain types, leaving them looking fresh and well-maintained. Whether it’s light sheers or heavy drapes, trust AL THABITAH to keep your curtains in perfect condition,\n                    enhancing the beauty of your space.\n                </p>\n                <div\n                    class=\"cover-background p-7 border-radius-6px mb-60px md-mb-40px d-flex justify-content-end align-items-end sm-h-500px\"\n                    style=\"background-image: url(./components/al-thabitah/assets/images/services/curtain-cleaning-02.jpg);\"\n                >\n                    <div class=\"bg-white box-shadow-quadruple-large border-radius-4px w-50 lg-w-55 sm-w-100 overflow-hidden\">\n                        <div class=\"p-40px lg-p-25px last-paragraph-no-margin\">\n                            <span class=\"fs-22 text-dark-gray fw-700 mb-10px d-block\">Professional Cleaning</span>\n                            <p>Tailored solutions to meet your cleaning needs, ensuring spotless results every time.</p>\n                        </div>\n                        <div class=\"bg-base-color p-15px text-center\">\n                            <a href=\"althabitah.php?page=contact_us\" class=\"text-dark-gray text-dark-gray-hover fw-600\"><i class=\"feather icon-feather-mail me-10px\"></i>Talk with our team</a>\n                        </div>\n                    </div>\n                </div>\n                <h4 class=\"text-dark-gray fw-700 mb-40px lg-mb-30px d-block\">Benefits of working with us</h4>\n                <div class=\"border border-color-extra-medium-gray border-radius-6px mb-40px xs-mb-30px overflow-hidden\">\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Revived Appearance: </span>Refresh your curtains and bring back their original beauty.</p>\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Dust and Allergen Removal: </span>Breathe easier with cleaner, allergen-free curtains.</p>\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Fabric Care: </span>Gentle cleaning techniques protect delicate fabrics.</p>\n                    <p class=\"p-30px mb-0\"><span class=\"fw-600 text-dark-gray\">Long-Lasting Freshness: </span>Enjoy crisp, clean curtains that elevate your space.</p>\n                </div>\n                <div class=\"row align-items-center g-0\">\n                    <div class=\"col-auto d-block d-sm-flex align-items-center text-center text-sm-start\">\n                        <div class=\"fw-500 last-paragraph-no-margin text-dark-gray ps-15px xs-ps-0 xs-mt-15px\">\n                            <p>Save your time and effort spent for finding a solution. <a href=\"althabitah.php?page=contact_us\" class=\"text-decoration-line-bottom fw-700 text-dark-gray\">Contact us now</a></p>\n                        </div>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </div>\n</section>\n<!-- end section -->\n', '2024-09-07 16:37:47', 2),
(24, 24, '<!-- start section -->\n<section class=\"mb-2\">\n    <div class=\"container\">\n        <div class=\"row\">\n            <div class=\"col-lg-4 pe-5 order-2 order-lg-1 lg-pe-3 md-pe-15px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n                #{SERVICES_SHORTCUT}\n            </div>\n            <div class=\"col-lg-8 order-1 order-lg-2 md-mb-50px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n                <h4 class=\"text-dark-gray fw-700 ls-minus-1px mb-20px d-block\">Plumbing Service</h4>\n                <p>\n                    Restore peace of mind to your home with AL THABITAH\'s Plumbing Service. From leaky faucets to clogged drains, our experienced team is equipped to handle all your plumbing needs efficiently and effectively. With prompt\n                    response times and expert troubleshooting, we\'ll diagnose and resolve any issue with precision. We prioritize quality workmanship and use only the highest quality materials, ensuring long-lasting solutions. Don\'t let\n                    plumbing problems disrupt your daily routine – trust AL THABITAH to keep your pipes flowing smoothly. Experience reliable service and lasting results with AL THABITAH\'s Plumbing Service.\n                </p>\n                <div\n                    class=\"cover-background p-7 border-radius-6px mb-60px md-mb-40px d-flex justify-content-end align-items-end sm-h-500px\"\n                    style=\"background-image: url(./components/al-thabitah/assets/images/services/plumbing-service-02.jpg);\"\n                >\n                    <div class=\"bg-white box-shadow-quadruple-large border-radius-4px w-50 lg-w-55 sm-w-100 overflow-hidden\">\n                        <div class=\"p-40px lg-p-25px last-paragraph-no-margin\">\n                            <span class=\"fs-22 text-dark-gray fw-700 mb-10px d-block\">Professional Cleaning</span>\n                            <p>Tailored solutions to meet your cleaning needs, ensuring spotless results every time.</p>\n                        </div>\n                        <div class=\"bg-base-color p-15px text-center\">\n                            <a href=\"althabitah.php?page=contact_us\" class=\"text-dark-gray text-dark-gray-hover fw-600\"><i class=\"feather icon-feather-mail me-10px\"></i>Talk with our team</a>\n                        </div>\n                    </div>\n                </div>\n                <h4 class=\"text-dark-gray fw-700 mb-40px lg-mb-30px d-block\">Benefits of working with us</h4>\n                <div class=\"border border-color-extra-medium-gray border-radius-6px mb-40px xs-mb-30px overflow-hidden\">\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Quick Fixes: </span>Fast and reliable plumbing solutions for any issue.</p>\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Prevent Damage: </span>Timely repairs prevent costly water damage in your home or office.</p>\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Expert Technicians: </span>Skilled professionals with years of experience.</p>\n                    <p class=\"p-30px mb-0\"><span class=\"fw-600 text-dark-gray\">Affordable Solutions: </span>Quality service at a price that won’t break the bank.</p>\n                </div>\n                <div class=\"row align-items-center g-0\">\n                    <div class=\"col-auto d-block d-sm-flex align-items-center text-center text-sm-start\">\n                        <div class=\"fw-500 last-paragraph-no-margin text-dark-gray ps-15px xs-ps-0 xs-mt-15px\">\n                            <p>Save your time and effort spent for finding a solution. <a href=\"althabitah.php?page=contact_us\" class=\"text-decoration-line-bottom fw-700 text-dark-gray\">Contact us now</a></p>\n                        </div>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </div>\n</section>\n<!-- end section -->\n', '2024-09-07 16:43:56', 2),
(25, 25, '<!-- start section -->\n<section class=\"mb-2\">\n    <div class=\"container\">\n        <div class=\"row\">\n            <div class=\"col-lg-4 pe-5 order-2 order-lg-1 lg-pe-3 md-pe-15px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n                #{SERVICES_SHORTCUT}\n            </div>\n            <div class=\"col-lg-8 order-1 order-lg-2 md-mb-50px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n                <h4 class=\"text-dark-gray fw-700 ls-minus-1px mb-20px d-block\">Pest Control Service</h4>\n                <p>\n                    Protect your home from unwanted invaders with AL THABITAH\'s Pest Control Service. Our experienced team targets and eliminates pests swiftly and effectively, ensuring a safe and pest-free environment. Whether it’s ants,\n                    cockroaches, rodents, or termites, we use advanced techniques and eco-friendly solutions to safeguard your space. With prompt service and thorough inspections, we identify and resolve infestations at the source. Say\n                    goodbye to pests and enjoy peace of mind knowing your home is in expert hands. Trust AL THABITAH for reliable, lasting protection against pests\n                </p>\n                <div\n                    class=\"cover-background p-7 border-radius-6px mb-60px md-mb-40px d-flex justify-content-end align-items-end sm-h-500px\"\n                    style=\"background-image: url(./components/al-thabitah/assets/images/services/pest-control-02.jpg);\"\n                >\n                    <div class=\"bg-white box-shadow-quadruple-large border-radius-4px w-50 lg-w-55 sm-w-100 overflow-hidden\">\n                        <div class=\"p-40px lg-p-25px last-paragraph-no-margin\">\n                            <span class=\"fs-22 text-dark-gray fw-700 mb-10px d-block\">Professional Cleaning</span>\n                            <p>Tailored solutions to meet your cleaning needs, ensuring spotless results every time.</p>\n                        </div>\n                        <div class=\"bg-base-color p-15px text-center\">\n                            <a href=\"althabitah.php?page=contact_us\" class=\"text-dark-gray text-dark-gray-hover fw-600\"><i class=\"feather icon-feather-mail me-10px\"></i>Talk with our team</a>\n                        </div>\n                    </div>\n                </div>\n                <h4 class=\"text-dark-gray fw-700 mb-40px lg-mb-30px d-block\">Benefits of working with us</h4>\n                <div class=\"border border-color-extra-medium-gray border-radius-6px mb-40px xs-mb-30px overflow-hidden\">\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Quick Effective Treatment: </span>Eliminate pests with targeted and safe solutions.</p>\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Peace of Mind: </span>Keep your home or office pest-free all year round.</p>\n                    <p class=\"p-30px border-bottom border-1 border-color-extra-medium-gray mb-0\"><span class=\"fw-600 text-dark-gray\">Health Protection: </span>Safeguard your environment from pest-related health risks.</p>\n                    <p class=\"p-30px mb-0\"><span class=\"fw-600 text-dark-gray\">Lasting Results: </span>Our treatments ensure long-term protection from infestations.</p>\n                </div>\n                <div class=\"row align-items-center g-0\">\n                    <div class=\"col-auto d-block d-sm-flex align-items-center text-center text-sm-start\">\n                        <div class=\"fw-500 last-paragraph-no-margin text-dark-gray ps-15px xs-ps-0 xs-mt-15px\">\n                            <p>Save your time and effort spent for finding a solution. <a href=\"althabitah.php?page=contact_us\" class=\"text-decoration-line-bottom fw-700 text-dark-gray\">Contact us now</a></p>\n                        </div>\n                    </div>\n                </div>\n            </div>\n        </div>\n    </div>\n</section>\n<!-- end section -->\n', '2024-09-07 16:52:31', 2),
(26, 26, '<!-- start section -->\n<section id=\"down-section\">\n    <div class=\"container\">\n        <div class=\"row align-items-end justify-content-center mb-6 text-center text-lg-start sm-mb-8\">\n            <div class=\"col-xl-5 col-lg-7 col-md-10 md-mb-25px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [30, 0], \"opacity\": [0,1], \"duration\": 600, \"delay\":0, \"staggervalue\": 300, \"easing\": \"easeOutQuad\" }\'>\n                <span class=\"pe-25px mb-20px text-uppercase text-base-color fs-14 lh-42px fw-700 border-radius-100px bg-gradient-very-light-gray-transparent d-inline-block\">How can we help you?</span>\n                <h3 class=\"text-dark-gray fw-700 ls-minus-1px mb-0\">Need cleaning solutions? Get in touch with us!</h3>\n            </div>\n            <div class=\"col-xl-6 offset-xl-1 col-lg-5 col-md-10 last-paragraph-no-margin\">\n                <p class=\"w-90 lg-w-100\" data-anime=\'{ \"el\": \"lines\", \"translateY\": [30, 0], \"opacity\": [0,1], \"duration\": 600, \"delay\":0, \"staggervalue\": 300, \"easing\": \"easeOutQuad\" }\'>\n                    We are available to assist with any questions you may have and look forward to connecting with you. Please feel free to contact us or visit our office.\n                </p>\n            </div>\n        </div>\n        <div\n            class=\"row row-cols-1 row-cols-xl-4 row-cols-lg-4 row-cols-md-2 row-cols-sm-2 mb-6 sm-mb-8\"\n            data-anime=\'{ \"el\": \"childs\", \"translateY\": [30, 0], \"opacity\": [0,1], \"duration\": 600, \"delay\":0, \"staggervalue\": 300, \"easing\": \"easeOutQuad\" }\'\n        >\n            <div class=\"col md-mb-30px text-center text-sm-start\">\n                <span class=\"alt-font fs-18 fw-700 d-block w-90 text-dark-gray border-bottom border-2 border-color-dark-gray pb-15px mb-15px xs-w-100\">\n                    <i class=\"feather icon-feather-map-pin d-inline-block icon-small me-10px\"></i>Office location\n                </span>\n                <div class=\"last-paragraph-no-margin\">\n                    <a href=\"https://maps.app.goo.gl/gmJzsR5mFDXLMiQT9\" class=\"text-primary-hover\" target=\"_blank\">\n                        <p>\n                            Al Rashidiya 2, <br />\n                            Al Kaabi Building, Ajman\n                        </p>\n                    </a>\n                </div>\n            </div>\n            <div class=\"col md-mb-30px text-center text-sm-start\">\n                <span class=\"alt-font fs-18 fw-700 d-block w-90 text-dark-gray border-bottom border-2 border-color-dark-gray pb-15px mb-15px xs-w-100\">\n                    <i class=\"feather icon-feather-mail d-inline-block icon-small me-10px\"></i>Send a message\n                </span>\n                <a href=\"mailto:contact@althabitah.com\" class=\"text-primary-hover not-translate\">contact@althabitah.com</a><br />\n            </div>\n            <div class=\"col xs-mb-30px text-center text-sm-start\">\n                <span class=\"alt-font fs-18 fw-700 d-block w-90 text-dark-gray border-bottom border-2 border-color-dark-gray pb-15px mb-15px xs-w-100\">\n                    <i class=\"feather icon-feather-phone d-inline-block icon-small me-10px\"></i>Call us directly\n                </span>\n                <a href=\"tel:+971543379025\" class=\"text-primary-hover\">+971 5 4337 9025</a><br />\n            </div>\n            <div class=\"col text-center text-sm-start\">\n                <span class=\"alt-font fs-18 fw-700 d-block w-90 text-dark-gray border-bottom border-2 border-color-dark-gray pb-15px mb-15px xs-w-100\">\n                    <i class=\"feather icon-feather-users d-inline-block icon-small me-10px\"></i>Join our team\n                </span>\n                <a href=\"mailto:hr@althabitah.com\" class=\"text-primary-hover not-translate\">careers@althabitah.com</a><br />\n            </div>\n        </div>\n    </div>\n</section>\n<!-- end section -->', '2024-09-07 17:59:02', 2),
(27, 27, '<!-- start section -->\n<section class=\"p-0 h-500px sm-h-350px overlap-height\" id=\"location\">\n    <div class=\"container-fluid h-100 overlap-gap-section\">\n        <div class=\"row justify-content-center h-100\">\n            <div class=\"col-12 p-0\">\n                <iframe\n                    class=\"map w-100\"\n                    src=\"https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3604.1573681644527!2d55.44695751074672!3d25.399542423382023!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x3e5f582d74e738b9%3A0x4fa51615f1eb3993!2sAl%20Kaabi%20Building!5e0!3m2!1sen!2sph!4v1723798303294!5m2!1sen!2sph\"\n                    height=\"550\"\n                    style=\"border: 0;\"\n                    allowfullscreen=\"\"\n                    loading=\"lazy\"\n                    referrerpolicy=\"no-referrer-when-downgrade\"\n                ></iframe>\n            </div>\n        </div>\n    </div>\n</section>\n<!-- end section -->', '2024-09-07 18:10:26', 2);
INSERT INTO `block_container` (`block_container_id`, `block_style_id`, `block_container`, `created_date`, `last_log_by`) VALUES
(28, 28, '<!-- start section -->\n<section class=\"mb-3\">\n    <div class=\"container overlap-section overlap-section-three-fourth\" data-anime=\'{\"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 800, \"delay\": 500, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n        <div class=\"row row-cols-md-1 justify-content-center\">\n            <div class=\"col-xl-10\">\n                <div class=\"bg-white p-8 border-radius-6px box-shadow-double-large\">\n                    <div class=\"row\">\n                        <div class=\"col-9\">\n                            <h3 class=\"alt-font text-dark-gray fw-700 ls-minus-2px mb-50px xs-mb-35px\">How we can help you?</h3>\n                        </div>\n                        <div class=\"col-3 text-end\" data-anime=\'{ \"translateY\": [30, 0], \"translateX\": [-30, 0], \"opacity\": [0,1], \"duration\": 600, \"delay\": 300, \"staggervalue\": 300, \"easing\": \"easeOutQuad\" }\'>\n                            <i class=\"bi bi-send icon-large text-dark-gray animation-zoom\"></i>\n                        </div>\n                    </div>\n                    <!-- start contact form -->\n                    <form id=\"contact-us-form\" method=\"post\" action=\"#\" class=\"row contact-form-style-02\">\n                        <div class=\"col-md-6 mb-30px\">\n                            <input class=\"input-name form-control\" type=\"text\" name=\"customer_name\" placeholder=\"Your name*\" autocomplete=\"off\" />\n                        </div>\n                        <div class=\"col-md-6 mb-30px\">\n                            <input class=\"form-control\" type=\"email\" name=\"email\" placeholder=\"Your email address*\" autocomplete=\"off\"/>\n                        </div>\n                        <div class=\"col-md-6 mb-30px\">\n                            <input class=\"form-control\" type=\"tel\" name=\"phone\" placeholder=\"Your phone*\" autocomplete=\"off\"/>\n                        </div>\n                        <div class=\"col-md-6 mb-30px\">\n                            <input class=\"form-control\" type=\"text\" name=\"subject\" placeholder=\"Your subject*\" autocomplete=\"off\"/>\n                        </div>\n                        <div class=\"col-md-12 mb-30px\">\n                            <textarea class=\"form-control\" cols=\"40\" rows=\"4\" name=\"message\" placeholder=\"Your message*\"></textarea>\n                        </div>\n                        <div class=\"col-xl-7 col-md-7 last-paragraph-no-margin\">\n                            <p class=\"text-center text-md-start fs-15 lh-26\">We are committed to protecting your privacy. We will never collect information about you without your explicit consent.</p>\n                        </div>\n                        <div class=\"col-xl-5 col-md-5 text-center text-md-end sm-mt-20px\">\n                            <button class=\"btn btn-base-color btn-medium btn-rounded btn-box-shadow\" id=\"submit-customer-inquiry\" type=\"submit\">Send message</button>\n                        </div>\n                    </form>\n                    <!-- end contact form -->\n                </div>\n            </div>\n            <div class=\"row align-items-center justify-content-center mt-8\">\n                <div class=\"col-md-auto text-center text-md-end sm-mb-20px\">\n                    <h6 class=\"text-dark-gray fw-600 mb-0 ls-minus-1px\">Connect with social media</h6>\n                </div>\n                <div class=\"col-2 d-none d-lg-inline-block\">\n                    <span class=\"w-100 h-1px bg-dark-gray opacity-2 d-flex mx-auto\"></span>\n                </div>\n                <!-- start social icon -->\n                <div class=\"col-md-auto elements-social social-icon-style-04 text-center text-md-start ps-lg-0\">\n                    <ul class=\"large-icon dark\">\n                        <li class=\"m-0\">\n                            <a class=\"facebook\" href=\"https://www.facebook.com/profile.php?id=100095104812245&mibextid=LQQJ4d\" target=\"_blank\"><i class=\"fa-brands fa-facebook-f\"></i><span></span></a>\n                        </li>\n                        <li class=\"m-0\">\n                            <a class=\"youtube\" href=\"https://www.youtube.com/channel/UCbzw6RiqwngeeruQwGi58-A\" target=\"_blank\"><i class=\"fa-brands fa-youtube\"></i><span></span></a>\n                        </li>\n                        <li class=\"m-0\">\n                            <a class=\"instagram\" href=\"https://www.instagram.com/althabitah.cleaningservices/\" target=\"_blank\"><i class=\"fa-brands fa-instagram\"></i><span></span></a>\n                        </li>\n                        <li class=\"m-0\">\n                            <a class=\"tiktok\" href=\"https://www.tiktok.com/@althabitahcleaningservic?_t=8ohEkhilfXA&_r=1\" target=\"_blank\"><i class=\"fa-brands fa-tiktok\"></i><span></span></a>\n                        </li>\n                        <li class=\"m-0\">\n                            <a class=\"whatsapp\" href=\"https://wa.me/971561652741\" target=\"_blank\"><i class=\"fa-brands fa-whatsapp\"></i><span></span></a>\n                        </li>\n                    </ul>\n                </div>\n                <!-- end social icon -->\n            </div>\n        </div>\n    </div>\n</section>\n<!-- end section -->\n', '2024-09-07 18:30:12', 2),
(29, 29, '<!-- start section -->\n<section class=\"mb-3\">\n    <div class=\"container\">\n        <div class=\"row align-items-start\">\n            <div class=\"col-lg-7 pe-50px md-pe-15px md-mb-50px xs-mb-35px\">\n                <span class=\"fs-26 alt-font fw-600 text-dark-gray mb-20px d-block\">Booking details</span>\n                <form id=\"booking-form\" method=\"post\" action=\"#\">\n                    <div class=\"row\">\n                        <div class=\"col-12 mb-20px\">\n                            <label class=\"mb-10px\" for=\"service\">Service <span class=\"text-red\">*</span></label>\n                            <select name=\"service\" id=\"service\" class=\"form-select border-radius-4px\">\n                                <option value=\"\"></option>\n                                <option value=\"Deep Cleaning\">Deep Cleaning</option>\n                                <option value=\"Regular Cleaning\">Regular Cleaning</option>\n                                <option value=\"Office Cleaning\">Office Cleaning</option>\n                                <option value=\"Flat Cleaning\">Flat Cleaning</option>\n                                <option value=\"Hospital Cleaning\">Hospital Cleaning</option>\n                                <option value=\"Sofa Cleaning\">Sofa Cleaning</option>\n                                <option value=\"Mattress Cleaning\">Mattress Cleaning</option>\n                                <option value=\"Curtain Cleaning\">Curtain Cleaning</option>\n                                <option value=\"Carpet Cleaning\">Carpet Cleaning</option>\n                            </select>\n                        </div>\n                        <div class=\"col-6 mb-20px d-none\" id=\"frequency_field\">\n                            <label class=\"mb-10px\" for=\"frequency\">Frequency <span class=\"text-red\">*</span></label>\n                            <select name=\"frequency\" id=\"frequency\" class=\"form-select border-radius-4px\">\n                                <option value=\"\"></option>\n                                <option value=\"One Time\">One Time</option>\n                                <option value=\"Weekly\">Weekly</option>\n                                <option value=\"Monthly\">Monthly</option>\n                                <option value=\"Yearly\">Yearly</option>\n                                <option value=\"Every Other Week\">Every Other Week</option>\n                                <option value=\"Every 4 Weeks\">Every 4 Weeks</option>\n                            </select>\n                        </div>\n                        <div class=\"col-6 mb-20px d-none\" id=\"duration_field\">\n                            <label class=\"mb-10px\" for=\"duration\">Duration <span class=\"text-red\">*</span></label>\n                            <select name=\"duration\" id=\"duration\" class=\"form-select border-radius-4px\">\n                                <option value=\"\"></option>\n                                <option value=\"1\">1 Hour</option>\n                                <option value=\"2\">2 Hours</option>\n                                <option value=\"3\">3 Hours</option>\n                                <option value=\"4\">4 Hours</option>\n                                <option value=\"5\">5 Hours</option>\n                                <option value=\"6\">6 Hours</option>\n                                <option value=\"7\">7 Hours</option>\n                                <option value=\"8\">8 Hours</option>\n                            </select>\n                        </div>\n                        <div class=\"col-md-12 mb-20px d-none\" id=\"number_of_seats_field\">\n                            <label class=\"mb-10px\" for=\"number_of_seats\">Number of seats <span class=\"text-red\">*</span></label>\n                            <input class=\"border-radius-4px\" name=\"number_of_seats\" id=\"number_of_seats\" type=\"number\" min=\"1\" step=\"1\" aria-label=\"number\" />\n                        </div>\n                        <div class=\"col-md-12 mb-20px d-none\" id=\"meters_field\">\n                            <label class=\"mb-10px\" for=\"meters\">Meters <span class=\"text-red\">*</span></label>\n                            <input class=\"border-radius-4px\" name=\"meters\" id=\"meters\" type=\"number\" min=\"1\" step=\"1\" aria-label=\"number\" />\n                        </div>\n                        <div class=\"col-12 mb-20px\">\n                            <label class=\"mb-10px\" for=\"cleaning_materials\">Need cleaning materials? <span class=\"text-red\">*</span></label>\n                            <select name=\"cleaning_materials\" id=\"cleaning_materials\" class=\"form-select border-radius-4px\">\n                                <option value=\"No\">No, I have them</option>\n                                <option value=\"Yes\">Yes Please!</option>\n                            </select>\n                        </div>\n                        <div class=\"col-6 mb-20px\">\n                            <label class=\"mb-10px\" for=\"booking_date\">Date <span class=\"text-red\">*</span></label>\n                            <input class=\"form-control\" type=\"date\" id=\"booking_date\" name=\"booking_date\" min=\"<?php echo date(\'Y-m-d\'); ?>\" max=\"2099-12-31\" aria-label=\"date\" />\n                        </div>\n                        <div class=\"col-6 mb-20px\">\n                            <label class=\"mb-10px\" for=\"booking_time\">Time <span class=\"text-red\">*</span></label>\n                            <select class=\"form-control\" id=\"booking_time\" name=\"booking_time\">\n                                <option value=\"\">--</option>\n                                <option value=\"9:00 AM\">9:00 AM</option>\n                                <option value=\"10:00 AM\">10:00 AM</option>\n                                <option value=\"12:00 PM\">12:00 PM</option>\n                                <option value=\"1:00 PM\">1:00 PM</option>\n                                <option value=\"2:00 PM\">2:00 PM</option>\n                                <option value=\"3:00 PM\">3:00 PM</option>\n                                <option value=\"4:00 PM\">4:00 PM</option>\n                                <option value=\"5:00 PM\">5:00 PM</option>\n                                <option value=\"6:00 PM\">6:00 PM</option>\n                            </select>\n                        </div>\n                        <div class=\"col-12 mb-20px\">\n                            <label class=\"mb-10px\" for=\"number_of_professionals\">How many professionals do you need? <span class=\"text-red\">*</span></label>\n                            <select class=\"form-control\" id=\"number_of_professionals\" name=\"number_of_professionals\">\n                                <option value=\"\">--</option>\n                                <option value=\"1\">1</option>\n                                <option value=\"2\">2</option>\n                                <option value=\"3\">3</option>\n                                <option value=\"4\">4</option>\n                                <option value=\"5\">5</option>\n                                <option value=\"6\">6</option>\n                                <option value=\"7\">7</option>\n                                <option value=\"8\">8</option>\n                                <option value=\"9\">9</option>\n                                <option value=\"10\">10</option>\n                                <option value=\"11\">11</option>\n                                <option value=\"12\">12</option>\n                                <option value=\"13\">13</option>\n                                <option value=\"14\">14</option>\n                                <option value=\"15\">15</option>\n                                <option value=\"16\">16</option>\n                                <option value=\"17\">17</option>\n                                <option value=\"18\">18</option>\n                                <option value=\"19\">19</option>\n                                <option value=\"20\">20</option>\n                            </select>\n                        </div>\n                        <div class=\"col-12 mb-20px\">\n                            <label class=\"mb-10px\" for=\"number_of_hours\">How many hours should they stay? <span class=\"text-red\">*</span></label>\n                            <select class=\"form-control\" id=\"number_of_hours\" name=\"number_of_hours\">\n                                <option value=\"\">--</option>\n                                <option value=\"1\">1 Hour</option>\n                                <option value=\"2\">2 Hours</option>\n                                <option value=\"3\">3 Hours</option>\n                                <option value=\"4\">4 Hours</option>\n                                <option value=\"5\">5 Hours</option>\n                                <option value=\"6\">6 Hours</option>\n                                <option value=\"7\">7 Hours</option>\n                                <option value=\"8\">8 Hours</option>\n                            </select>\n                        </div>\n                        <div class=\"col-12 mb-20px\">\n                            <label class=\"mb-10px\" for=\"nationality\">Choose your professional nationality <span class=\"text-red\">*</span></label>\n                            <select class=\"form-control\" id=\"nationality\" name=\"nationality\">\n                                <option value=\"\">--</option>\n                                <option value=\"African\">African</option>\n                                <option value=\"Filipino\">Filipino</option>\n                                <option value=\"Nepali\">Nepali</option>\n                            </select>\n                        </div>\n                        <div class=\"col-md-6 mb-20px\">\n                            <label class=\"mb-10px\" for=\"first_name\">First name <span class=\"text-red\">*</span></label>\n                            <input class=\"border-radius-4px\" id=\"first_name\" name=\"first_name\" type=\"text\" aria-label=\"text\" autocomplete=\"off\" />\n                        </div>\n                        <div class=\"col-md-6 mb-20px\">\n                            <label class=\"mb-10px\" for=\"last_name\">Last name <span class=\"text-red\">*</span></label>\n                            <input class=\"border-radius-4px\" id=\"last_name\" name=\"last_name\" type=\"text\" aria-label=\"text\" autocomplete=\"off\" />\n                        </div>\n                        <div class=\"col-md-12 mb-20px\">\n                            <label class=\"mb-10px\" for=\"address\">Address <span class=\"text-red\">*</span></label>\n                            <input class=\"border-radius-4px\" id=\"address\" name=\"address\" type=\"text\" aria-label=\"text\" autocomplete=\"off\" />\n                        </div>\n                        <div class=\"col-6 mb-20px\">\n                            <label class=\"mb-10px\" for=\"phone\">Phone <span class=\"text-red\">*</span></label>\n                            <input class=\"border-radius-4px\" id=\"phone\" name=\"phone\" type=\"text\" autocomplete=\"off\" />\n                        </div>\n                        <div class=\"col-6 mb-20px\">\n                            <label class=\"mb-10px\" for=\"email_address\">Email address <span class=\"text-red\">*</span></label>\n                            <input class=\"border-radius-4px\" id=\"email_address\" name=\"email_address\" type=\"email\" autocomplete=\"off\" />\n                        </div>\n                        <div class=\"col-12\">\n                            <label class=\"mb-10px\" for=\"special_instructions\">Do you have any special instructions?</label>\n                            <textarea class=\"border-radius-4px\" rows=\"5\" cols=\"5\" id=\"special_instructions\" name=\"special_instructions\" placeholder=\"Notes about your booking, e.g. special notes for the professionals.\"></textarea>\n                        </div>\n                    </div>\n                </form>\n            </div>\n            <div class=\"col-lg-5\">\n                <div class=\"bg-very-light-gray border-radius-6px p-50px lg-p-25px your-order-box\">\n                    <span class=\"fs-26 alt-font fw-600 text-dark-gray mb-5px d-block\">Your booking</span>\n                    <table class=\"w-100 total-price-table your-order-table mb-8\">\n                        <tbody>\n                            <tr>\n                                <th class=\"w-60 lg-w-55 xs-w-50 fw-600 text-dark-gray alt-font\">Service</th>\n                                <td class=\"fw-600 text-dark-gray alt-font\">Total</td>\n                            </tr>\n                            <tr id=\"service-summary\" class=\"product\"></tr>\n                            <tr>\n                                <th class=\"w-60 lg-w-55 xs-w-50 fw-600 text-dark-gray alt-font\">Add-On</th>\n                                <td class=\"fw-600 text-dark-gray alt-font\">Total</td>\n                            </tr>\n                            <tr id=\"cleaning-materials-summary\" class=\"product\"></tr>\n                        </tbody>\n                    </table>\n                    <span class=\"fs-26 alt-font fw-600 text-dark-gray mb-5px d-block\">Payment Details</span>\n                    <table class=\"w-100 total-price-table your-order-table mb-4\">\n                        <tbody>\n                            <tr>\n                                <th class=\"w-60 fw-600 text-dark-gray alt-font\">Booking Subtotal</th>\n                                <td class=\"text-dark-gray fw-600\" id=\"booking-subtotal-payment-details\">AED 0.00</td>\n                            </tr>\n                            <tr>\n                                <th class=\"w-60 fw-600 text-dark-gray alt-font\">Discount Subtotal</th>\n                                <input type=\"hidden\" id=\"discount-rate\" />\n                                <input type=\"hidden\" id=\"discount-type\" />\n                                <input type=\"hidden\" id=\"discount-amount\" />\n                                <td class=\"text-dark-gray fw-600\" id=\"discount-subtotal\">AED 0.00</td>\n                            </tr>\n                            <tr class=\"total-amount\">\n                                <th class=\"fw-600 text-dark-gray alt-font\">Total</th>\n                                <td data-title=\"Total\">\n                                    <h6 class=\"d-block fw-700 mb-0 text-dark-gray alt-font\" id=\"total-booking-amount\">AED 0.00</h6>\n                                </td>\n                            </tr>\n                        </tbody>\n                    </table>\n                    <span class=\"fs-26 alt-font fw-600 text-dark-gray mb-5px d-block\">Discount</span>\n                    <div class=\"row mt-20px mb-8\">\n                        <div class=\"col-xl-8\">\n                            <div class=\"coupon-code-panel\">\n                                <input type=\"text\" class=\"bg-white border-radius-4px\" id=\"discount_code\" name=\"discount_code\" placeholder=\"Discount code\" />\n                                <a href=\"javascript:void(0);\" id=\"apply-discount\" class=\"btn apply-coupon-btn fs-13 fw-600 text-uppercase\">Apply</a>\n                            </div>\n                        </div>\n                        <div class=\"col-xl-4 text-end sm-mt-15px\">\n                            <a href=\"javasctript:void(0);\" id=\"reset-discount\" class=\"btn btn-small border-1 btn-round-edge btn-transparent-light-gray text-transform-none\">Reset</a>\n                        </div>\n                    </div>\n                    <span class=\"fs-26 alt-font fw-600 text-dark-gray mb-5px d-block\">Payment Method</span>\n                    <div class=\"p-40px lg-p-25px bg-white border-radius-6px box-shadow-large mt-10px mb-8 checkout-accordion\">\n                        <div class=\"w-100\" id=\"accordion-style-05\">\n                            <!-- start tab content -->\n                            <div class=\"heading active-accordion\">\n                                <label class=\"mb-5px\">\n                                    <input class=\"d-inline w-auto me-5px mb-0 p-0\" type=\"radio\" name=\"mode_of_payment\" value=\"Stripe\" checked=\"checked\" />\n                                    <span class=\"d-inline-block text-dark-gray fw-500\">Stripe Online Payment</span>\n                                    <a class=\"accordion-toggle\" data-bs-toggle=\"collapse\" data-bs-parent=\"#accordion-style-05\" href=\"#style-5-collapse-1\"></a>\n                                </label>\n                            </div>\n                            <div id=\"style-5-collapse-1\" class=\"collapse show\" data-bs-parent=\"#accordion-style-05\">\n                                <div class=\"p-25px bg-very-light-gray mt-20px mb-20px fs-14 lh-24\">Make your payment securely online via Stripe.</div>\n                            </div>\n                            <!-- end tab content -->\n                            <!-- start tab content -->\n                            <div class=\"heading active-accordion\">\n                                <label class=\"mb-5px\">\n                                    <input class=\"d-inline w-auto me-5px mb-0 p-0\" type=\"radio\" name=\"mode_of_payment\" value=\"Cash\" />\n                                    <span class=\"d-inline-block text-dark-gray fw-500\">Cash</span>\n                                    <a class=\"accordion-toggle\" data-bs-toggle=\"collapse\" data-bs-parent=\"#accordion-style-05\" href=\"#style-5-collapse-3\"></a>\n                                </label>\n                            </div>\n                            <div id=\"style-5-collapse-3\" class=\"collapse\" data-bs-parent=\"#accordion-style-05\">\n                                <div class=\"p-25px bg-very-light-gray mt-20px mb-20px fs-14 lh-24\">Pay in cash upon the arrival of our team.</div>\n                            </div>\n                            <!-- end tab content -->\n                        </div>\n                    </div>\n                    <p class=\"fs-14 lh-26\">\n                        Your personal data will be used to process your order, support your experience throughout this website, and for other purposes described in our\n                        <a class=\"text-decoration-line-bottom text-dark-gray fw-500\" href=\"#\">privacy policy.</a>\n                    </p>\n                    <div class=\"position-relative terms-condition-box text-start d-flex align-items-center\">\n                        <label>\n                            <input type=\"checkbox\" name=\"terms_condition\" id=\"terms_condition3\" value=\"1\" class=\"terms-condition check-box align-middle\" />\n                            <span class=\"box fs-14 lh-24\">I have agree to the website <a href=\"#\" class=\"text-decoration-line-bottom text-dark-gray fw-500\">terms and conditions.</a></span>\n                        </label>\n                    </div>\n                    <button type=\"submit\" form=\"booking-form\" class=\"btn btn-base-color btn-extra-large btn-switch-text btn-round-edge btn-box-shadow w-100 text-transform-none mt-30px\" id=\"submit-booking\">\n                        <span>\n                            <span class=\"btn-double-text\" id=\"proceed-text\">Proceed to payment</span>\n                        </span>\n                    </button>\n                </div>\n            </div>\n        </div>\n    </div>\n</section>\n<!-- end section -->', '2024-09-12 20:28:28', 2);

--
-- Triggers `block_container`
--
DROP TRIGGER IF EXISTS `block_container_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `block_container_trigger_insert` AFTER INSERT ON `block_container` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Block container created. <br/>';

    IF NEW.block_container <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Container: ", NEW.block_container);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('block_container', NEW.block_container_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `block_container_trigger_update`;
DELIMITER $$
CREATE TRIGGER `block_container_trigger_update` AFTER UPDATE ON `block_container` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.block_container <> OLD.block_container THEN
        SET audit_log = CONCAT(audit_log, "Block Container: ", OLD.block_container, " -> ", NEW.block_container, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('block_container', NEW.block_container_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `block_item`
--

DROP TABLE IF EXISTS `block_item`;
CREATE TABLE `block_item` (
  `block_item_id` int(10) UNSIGNED NOT NULL,
  `block_style_id` int(10) UNSIGNED NOT NULL,
  `block_item` longtext NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `block_item`
--

INSERT INTO `block_item` (`block_item_id`, `block_style_id`, `block_item`, `created_date`, `last_log_by`) VALUES
(1, 3, '<!-- start slider item -->\n<div class=\"swiper-slide cover-background\" style=\"background-image:url(\'#{SLIDER_IMAGE}\');\">\n    <div class=\"container h-100\">\n        <div class=\"row align-items-center h-100 xl-ps-10 sm-ps-0\">\n            <div class=\"col-xxl-7 col-xl-10 text-white\">\n                <h1 class=\"fw-600\">#{HEADING}</h1>\n                <div class=\"fs-20 opacity-6 mb-40px sm-mb-30px\">#{PARAGRAPH}</div>\n                <div class=\"lg-mb-8 md-mb-0\">\n                    <a href=\"#{CALL_TO_ACTION_BUTTON_1_LINK}\" class=\"btn btn-white btn-extra-large btn-round-edge fw-700 btn-box-shadow me-35px\">#{CALL_TO_ACTION_BUTTON_1_TEXT}</a>\n                    <a href=\"#{CALL_TO_ACTION_BUTTON_2_LINK}\" class=\"btn btn-transparent-white-light btn-extra-large btn-round-edge fw-700 btn-box-shadow me-35px\">#{CALL_TO_ACTION_BUTTON_2_TEXT}</a>\n                </div>\n            </div>\n        </div>\n    </div>\n</div>\n<!-- end slider item -->', '2024-09-06 22:40:26', 2),
(2, 4, '<div class=\"row justify-content-end\">\n    <div class=\"col-xl-5 outside-box-top-205px lg-mt-0 position-relative z-index-1\">\n        <div class=\"border-radius-10px overflow-hidden\">\n            <div class=\"bg-base-color p-50px xs-p-30px position-relative\">\n                <span class=\"text-dark-gray opacity-8 fw-500 d-block mb-5px\">#{HEADER}</span>\n                <h5 class=\"mb-0 fw-700 text-dark-gray\">#{BODY}</h5>\n                <div class=\"position-absolute top-0 end-0\">\n                    <img src=\"./components/al-thabitah/assets/images/diagonal-line-01.svg\" alt=\"Al Thabitah\" height=\"100\" width=\"100\">\n                </div>\n            </div>\n            <div class=\"bg-dark-gray ps-50px pe-50px pt-20px pb-20px sm-ps-30px sm-pe-30px\">\n                <a href=\"althabitah.php?page=contact_us\" class=\"fs-19 fw-500 text-white d-flex w-100 align-items-center\">Get a free quote now<i class=\"feather icon-feather-plus ms-auto icon-extra-medium\"></i></a>\n            </div>\n        </div>\n    </div>\n</div>', '2024-09-06 23:12:32', 2),
(3, 5, '<img src=\"./components/al-thabitah/assets/images/homepage/home-bg-01.jpg\" class=\"position-absolute bottom-10px right-0px z-index-minus-1\" data-bottom-top=\"transform: translateY(150px)\" data-top-bottom=\"transform: translateY(-150px)\" alt=\"Al Thabitah\" />\n<div class=\"row align-items-center justify-content-center\">\n    <div class=\"col-lg-6 col-md-10 md-mb-50px\" data-anime=\'{ \"translate\": [0, 0], \"opacity\": [0,1], \"duration\": 600, \"delay\": 0, \"staggervalue\": 300, \"easing\": \"easeOutQuad\" }\'>\n        <img src=\"./components/al-thabitah/assets/images/homepage/home-01.jpg\" class=\"w-100\" data-bottom-top=\"transform: translateY(-50px)\" data-top-bottom=\"transform: translateY(50px)\" alt=\"Al Thabitah\">\n    </div>\n    <div class=\"col-xl-5 col-lg-6 col-md-10 offset-xl-1\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [30, 0], \"opacity\": [0,1], \"duration\": 600, \"delay\": 0, \"staggervalue\": 300, \"easing\": \"easeOutQuad\" }\'>\n        <h2 class=\"fw-700 ls-minus-1px text-dark-gray mb-20px\">#{HEADER}</h2>\n        <p class=\"w-90 lg-w-100\">#{BODY}</p>\n        <div class=\"icon-with-text-style-08 mb-10px\">\n            <div class=\"feature-box feature-box-left-icon-middle overflow-hidden\">\n                <div class=\"feature-box-icon feature-box-icon-rounded w-40px h-40px bg-light-medium-gray rounded-circle me-15px\">\n                    <i class=\"fa-solid fa-check fs-14 text-dark-gray\"></i>\n                </div>\n                <div class=\"feature-box-content\">\n                    <span class=\"text-dark-gray fw-500\">Our values drive us.</span>\n                </div>\n            </div>\n        </div>\n        <div class=\"icon-with-text-style-08 mb-10px\">\n            <div class=\"feature-box feature-box-left-icon-middle overflow-hidden\">\n                <div class=\"feature-box-icon feature-box-icon-rounded w-40px h-40px bg-light-medium-gray rounded-circle me-15px\">\n                    <i class=\"fa-solid fa-check fs-14 text-dark-gray\"></i>\n                </div>\n                <div class=\"feature-box-content\">\n                    <span class=\"text-dark-gray fw-500\">We are committed to quality, reliability, and sustainable practices.</span>\n                </div>\n            </div>\n        </div>\n        <div class=\"mt-35px d-flex flex-wrap\">\n            <a href=\"althabitah.php?page=our_services\" class=\"btn btn-large btn-dark-gray btn-hover-animation-switch btn-round-edge btn-box-shadow me-15px\">\n                                <span> \n                                    <span class=\"btn-text\">Our services</span>\n                                    <span class=\"btn-icon\"><i class=\"feather icon-feather-arrow-right\"></i></span>\n                                    <span class=\"btn-icon\"><i class=\"feather icon-feather-arrow-right\"></i></span>\n                                </span>\n                            </a>\n            <div class=\"feature-box feature-box-left-icon-middle xs-mt-20px\">\n                <div class=\"feature-box-icon feature-box-icon-rounded bg-base-color w-60px h-60px rounded-circle me-15px\">\n                    <i class=\"feather icon-feather-phone-call align-middle icon-extra-medium text-dark-gray\"></i>\n                </div>\n                <div class=\"feature-box-content\">\n                    <span class=\"d-block fw-500\">Get in touch</span>\n                    <a href=\"tel:1800222000\" class=\"d-block text-dark-gray fw-700\">1 800 222 000</a>\n                </div>\n            </div>\n        </div>\n    </div>\n</div>', '2024-09-06 23:27:02', 2),
(4, 6, '<!-- start client item -->\n<div class=\"swiper-slide\">\n    <a href=\"#{CLIENT_URL}\"><img src=\"#{CLIENT_LOGO}\" style=\"filter: grayscale(100%);\" alt=\"Certification\" width=\"200\" height=\"200\" /></a>\n</div>\n<!-- end client item -->', '2024-09-06 23:35:15', 2),
(5, 7, '<!-- start slider item -->\n<div class=\"swiper-slide\">\n    <!-- start interactive banner item -->\n    <div class=\"col interactive-banner-style-05\">\n        <figure class=\"m-0 hover-box overflow-hidden position-relative border-radius-6px\">\n            <a href=\"#{CALL_TO_ACTION_BUTTON_LINK}\">\n                <img src=\"#{SERVICES_BOX_IMAGE}\" class=\"w-100 border-radius-6px\" alt=\"#{SERVICES_BOX_TITLE}\" />\n                <div class=\"position-absolute top-0px left-0px w-100 h-100 bg-gradient-gray-light-dark-transparent\"></div>\n            </a>\n            <figcaption class=\"d-flex flex-column align-items-start justify-content-center position-absolute left-0px top-0px w-100 h-100 z-index-1 p-50px xl-p-40px sm-p-30px last-paragraph-no-margin\">\n                <a href=\"#{CALL_TO_ACTION_BUTTON_LINK}\" class=\"text-white alt-font fw-600 fs-26\">#{SERVICES_BOX_HEADING}</a>\n                <span class=\"opacity-7 text-white\">#{SERVICES_BOX_PARAGRAPH}</span>\n                <a href=\"#{CALL_TO_ACTION_BUTTON_LINK}\" class=\"btn btn-light-base-color btn-small btn-round-edge btn-box-shadow mt-20px\">#{CALL_TO_ACTION_BUTTON_TEXT}<i class=\"feather icon-feather-arrow-right icon-very-small\"></i></a>\n            </figcaption>\n        </figure>\n    </div>\n    <!-- end interactive banner item -->\n</div>\n<!-- end slider item -->', '2024-09-06 23:59:29', 2),
(6, 8, '<div class=\"row align-items-center justify-content-center g-0\">\n    <div class=\"col-auto d-flex align-items-center\" data-anime=\'{ \"translateY\": [0, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n        <div class=\"fs-22 last-paragraph-no-margin fw-500 text-dark-gray pt-15px pb-15px\">\n            <p>#{BODY} <a href=\"althabitah.php?page=contact_us\" class=\"text-decoration-line-bottom fw-700 text-dark-gray text-white-hover\">Contact us now</a></p>\n        </div>\n    </div>\n</div>', '2024-09-07 00:18:30', 2),
(7, 9, '<div class=\"row align-items-center mb-8 sm-mb-50px justify-content-md-center\">\n    <div class=\"col-xl-5 col-lg-6 col-md-12 md-mb-50px\" data-anime=\'{ \"el\": \"childs\", \"translateY\": [50, 0], \"opacity\": [0,1], \"duration\": 1200, \"delay\": 0, \"staggervalue\": 150, \"easing\": \"easeOutQuad\" }\'>\n        <span class=\"fs-16 lh-22 fw-700 mb-10px d-inline-block text-uppercase text-dark-gray border-bottom border-2 border-color-base-color\">#{HEADER}</span>\n        <h2 class=\"text-dark-gray fw-700 mb-20px ls-minus-1px\">#{BODY}</h2>\n        <div class=\"row justify-content-center mb-25px\">\n            <div class=\"col-12\">\n                <div class=\"accordion accordion-style-02\" id=\"accordion-style-02\" data-active-icon=\"icon-feather-minus\" data-inactive-icon=\"icon-feather-plus\">\n                    <!-- start accordion item -->\n                    <div class=\"accordion-item active-accordion\">\n                        <div class=\"accordion-header border-bottom\">\n                            <a href=\"#\" data-bs-toggle=\"collapse\" data-bs-target=\"#accordion-style-02-01\" aria-expanded=\"true\" data-bs-parent=\"#accordion-style-02\">\n                                <div class=\"accordion-title text-dark-gray sm-pe-0\">\n                                    <span class=\"fw-600 fs-20\">Affordable Pricing</span>\n                                </div>\n                            </a>\n                        </div>\n                        <div id=\"accordion-style-02-01\" class=\"accordion-collapse collapse show\" data-bs-parent=\"#accordion-style-02\">\n                            <div class=\"accordion-body last-paragraph-no-margin border-bottom sm-pe-0\">\n                                <p>Quality cleaning solutions at rates that suit your budget.</p>\n                            </div>\n                        </div>\n                    </div>\n                    <!-- end accordion item -->\n                    <!-- start accordion item -->\n                    <div class=\"accordion-item\">\n                        <div class=\"accordion-header\">\n                            <a href=\"#\" data-bs-toggle=\"collapse\" data-bs-target=\"#accordion-style-02-02\" aria-expanded=\"true\" data-bs-parent=\"#accordion-style-02\">\n                                <div class=\"accordion-title text-dark-gray sm-pe-0\">\n                                    <span class=\"fw-600 fs-20\">Customized Solutions</span>\n                                </div>\n                            </a>\n                        </div>\n                        <div id=\"accordion-style-02-02\" class=\"accordion-collapse collapse\" data-bs-parent=\"#accordion-style-02\">\n                            <div class=\"accordion-body last-paragraph-no-margin border-bottom sm-pe-0\">\n                                <p>Tailored cleaning plans to meet your specific requirements.</p>\n                            </div>\n                        </div>\n                    </div>\n                    <!-- end accordion item -->\n                    <!-- start accordion item -->\n                    <div class=\"accordion-item\">\n                        <div class=\"accordion-header\">\n                            <a href=\"#\" data-bs-toggle=\"collapse\" data-bs-target=\"#accordion-style-02-03\" aria-expanded=\"false\" data-bs-parent=\"#accordion-style-02\">\n                                <div class=\"accordion-title text-dark-gray sm-pe-0\">\n                                    <span class=\"fw-600 fs-20\">Quality Assurance</span>\n                                </div>\n                            </a>\n                        </div>\n                        <div id=\"accordion-style-02-03\" class=\"accordion-collapse collapse\" data-bs-parent=\"#accordion-style-02\">\n                            <div class=\"accordion-body last-paragraph-no-margin sm-pe-0\">\n                                <p>Detailed inspections ensure spotless results.</p>\n                            </div>\n                        </div>\n                    </div>\n                    <!-- end accordion item -->\n                </div>\n            </div>\n        </div>\n        <div>\n            <a href=\"althabitah.php?page=our_services\" class=\"btn btn-large btn-dark-gray btn-hover-animation-switch btn-round-edge btn-box-shadow me-15px\">\n                                <span> \n                                    <span class=\"btn-text\">Explore more</span>\n                                    <span class=\"btn-icon\"><i class=\"feather icon-feather-arrow-right\"></i></span>\n                                    <span class=\"btn-icon\"><i class=\"feather icon-feather-arrow-right\"></i></span>\n                                </span>\n                            </a>\n            <a href=\"althabitah.php?page=booking\" class=\"btn btn-large btn-transparent-light-gray btn-hover-animation-switch btn-round-edge sm-mb-15px sm-mt-15px\">\n                                <span> \n                                    <span class=\"btn-text\">Book now</span>\n                                    <span class=\"btn-icon\"><i class=\"feather icon-feather-arrow-right\"></i></span>\n                                    <span class=\"btn-icon\"><i class=\"feather icon-feather-arrow-right\"></i></span>\n                                </span>\n                            </a>\n        </div>\n    </div>\n    <div class=\"col-xl-6 col-lg-6 offset-xl-1 position-relative\">\n        <div class=\"w-80 ms-auto\" data-animation-delay=\"500\" data-shadow-animation=\"true\" data-bottom-top=\"transform: translateY(50px)\" data-top-bottom=\"transform: translateY(-50px)\">\n            <img src=\"./components/al-thabitah/assets/images/homepage/home-02.png\" alt=\"Al Thabitah\" class=\"border-radius-10px w-100\">\n        </div>\n        <div class=\"w-60 overflow-hidden position-absolute left-15px bottom-20px\" data-shadow-animation=\"true\" data-animation-delay=\"500\" data-bottom-top=\"transform: translateY(-20px)\" data-top-bottom=\"transform: translateY(50px)\">\n            <img src=\"./components/al-thabitah/assets/images/homepage/home-03.jpg\" alt=\"Al Thabitah\" class=\"border-radius-10px box-shadow-quadruple-large\" />\n        </div>\n    </div>\n</div>', '2024-09-07 00:22:56', 2),
(8, 10, '<div class=\"row extra-very-small-screen align-items-center\">\n    <div class=\"col-lg-7 col-sm-8 position-relative page-title-extra-small\" data-anime=\'{ \"el\": \"childs\", \"opacity\": [0, 1], \"translateX\": [-30, 0], \"duration\": 800, \"delay\": 0, \"staggervalue\": 300, \"easing\": \"easeOutQuad\" }\'>\n        <h1 class=\"mb-20px xs-mb-20px text-white text-shadow-medium\"><span class=\"w-30px h-2px bg-yellow d-inline-block align-middle position-relative top-minus-2px me-10px\"></span>#{PAGE_TITLE}</h1>\n        <h2 class=\"text-white text-shadow-medium fw-500 ls-minus-2px mb-0\">#{PAGE_HEADING}</h2>\n    </div>\n</div>', '2024-09-07 00:42:07', 2),
(9, 13, '<!-- start text slider item -->\n<div class=\"swiper-slide review-style-08\">\n    <p class=\"w-80 lg-w-100\">\n        #{TESTIMONIAL_PARAGRAPH}\n    </p>\n    <div class=\"mt-20px\">\n        <img class=\"w-110px me-15px\" src=\"#{TESTIMONIAL_IMAGE}\" alt=\"#{CLIENT_NAME}\" />\n        <div class=\"d-inline-block align-middle text-start\">\n            <div class=\"text-dark-gray fw-600 fs-20\">#{CLIENT_NAME}</div>\n            <div class=\"review-star-icon fs-18\">#{RATING}</div>\n        </div>\n    </div>\n</div>\n<!-- end text slider item -->', '2024-09-07 11:10:00', 2),
(10, 14, '<div class=\"col mb-30px\">\n    <!-- start services box style -->\n    <div class=\"border-radius-8px overflow-hidden box-shadow-quadruple-large services-box-style-03 last-paragraph-no-margin\">\n        <div class=\"position-relative\">\n            <a href=\"#{CALL_TO_ACTION_BUTTON_LINK}\"><img src=\"#{SERVICES_BOX_IMAGE}\" alt=\"#{SERVICES_BOX_TITLE}\" /></a>\n        </div>\n        <div>\n            <div class=\"p-30px w-80 xl-w-100 mx-auto text-center\">\n                <a href=\"#{CALL_TO_ACTION_BUTTON_LINK}\" class=\"d-inline-block fs-20 fw-600 text-dark-gray mb-5px\">#{SERVICES_BOX_HEADING}</a>\n                <p>#{SERVICES_BOX_PARAGRAPH}</p>\n            </div>\n            <div class=\"d-flex justify-content-center border-top border-color-extra-medium-gray pt-20px pb-20px ps-50px pe-50px position-relative text-center\">\n                <a href=\"#{CALL_TO_ACTION_BUTTON_LINK}\" class=\"btn btn-link btn-hover-animation-switch fw-700 btn-small text-dark-gray text-uppercase\">\n                    <span>\n                        <span class=\"btn-text\">Explore services</span>\n                        <span class=\"btn-icon\"><i class=\"fa-solid fa-arrow-right\"></i></span>\n                        <span class=\"btn-icon\"><i class=\"fa-solid fa-arrow-right\"></i></span>\n                    </span>\n                </a>\n            </div>\n        </div>\n    </div>\n    <!-- end services box style -->\n</div>', '2024-09-07 11:42:55', 2);

--
-- Triggers `block_item`
--
DROP TRIGGER IF EXISTS `block_item_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `block_item_trigger_insert` AFTER INSERT ON `block_item` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Block item created. <br/>';

    IF NEW.block_item <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Item: ", NEW.block_item);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('block_item', NEW.block_item_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `block_item_trigger_update`;
DELIMITER $$
CREATE TRIGGER `block_item_trigger_update` AFTER UPDATE ON `block_item` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.block_item <> OLD.block_item THEN
        SET audit_log = CONCAT(audit_log, "Block Item: ", OLD.block_item, " -> ", NEW.block_item, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('block_item', NEW.block_item_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `block_style`
--

DROP TABLE IF EXISTS `block_style`;
CREATE TABLE `block_style` (
  `block_style_id` int(10) UNSIGNED NOT NULL,
  `block_style_name` varchar(100) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `block_type_id` int(10) UNSIGNED NOT NULL,
  `block_type_name` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `block_style`
--

INSERT INTO `block_style` (`block_style_id`, `block_style_name`, `description`, `block_type_id`, `block_type_name`, `created_date`, `last_log_by`) VALUES
(1, 'Header Navigation', 'Design for the top bar and navigation of the website.', 8, 'Header', '2024-09-06 20:26:29', 2),
(2, 'Footer', 'Design for the footer of the website.', 7, 'Footer', '2024-09-06 20:54:33', 2),
(3, 'Home Page Slider', 'Design for the slider on the home page of the website.', 14, 'Slider', '2024-09-06 22:36:46', 2),
(4, 'Home Page Call To Action 1', 'Design for the home page call to action 1.', 2, 'Call To Action', '2024-09-06 23:09:28', 2),
(5, 'Home Page Call To Action 2', 'Design for the home page call to action 2.', 2, 'Call To Action', '2024-09-06 23:23:55', 2),
(6, 'Certifications', 'Design for the company certifications.', 4, 'Client', '2024-09-06 23:32:36', 2),
(7, 'Home Services Box', 'Design for the services box on the home page.', 13, 'Services Box', '2024-09-06 23:55:23', 2),
(8, 'Home Page Call To Action 3', 'Design for the home page call to action 3.', 2, 'Call To Action', '2024-09-07 00:17:25', 2),
(9, 'Home Page Call To Action 4', 'Design for the home page call to action 4.', 2, 'Call To Action', '2024-09-07 00:20:27', 2),
(10, 'Global Page Title', 'Design of the global page title.', 10, 'Page Title', '2024-09-07 00:36:22', 2),
(11, 'About Us Section', 'Design of the about us.', 16, 'Sections', '2024-09-07 10:41:50', 2),
(12, 'About Us Vision Mission Core Values Section', 'Design for the about us vision, mission and core values section.', 16, 'Sections', '2024-09-07 11:00:25', 2),
(13, 'About Us Testimonial', 'Design for the about us testimonials.', 15, 'Testimonial', '2024-09-07 11:06:24', 2),
(14, 'Our Services Services Box', 'Design for our services services box.', 13, 'Services Box', '2024-09-07 11:40:45', 2),
(15, 'House Cleaning Section', 'Design for house cleaning section.', 16, 'Sections', '2024-09-07 12:30:25', 2),
(16, 'Office Cleaning Section', 'Design for the office cleaning section.', 16, 'Sections', '2024-09-07 12:41:05', 2),
(17, 'Kitchen Cleaning Section', 'Design for kitchen cleaning section.', 16, 'Sections', '2024-09-07 12:48:36', 2),
(18, 'Water Tank Cleaning Section', 'Design for water tank cleaning section', 16, 'Sections', '2024-09-07 12:57:39', 2),
(19, 'Window Cleaning Section', 'Design for window cleaning section.', 16, 'Sections', '2024-09-07 16:17:11', 2),
(20, 'Sofa Cleaning Section', 'Design for sofa cleaning section.', 16, 'Sections', '2024-09-07 16:25:54', 2),
(21, 'Carpet Cleaning Section', 'Design for carpet cleaning section.', 16, 'Sections', '2024-09-07 16:29:12', 2),
(22, 'Mattress Cleaning Section', 'Design for mattress cleaning section.', 16, 'Sections', '2024-09-07 16:34:03', 2),
(23, 'Curtain Cleaning Section', 'Design for curtain cleaning section.', 16, 'Sections', '2024-09-07 16:37:45', 2),
(24, 'Plumbing Service Section', 'Design for plumbing service section.', 16, 'Sections', '2024-09-07 16:43:40', 2),
(25, 'Pest Control Service Section', 'Design for pest control service section.', 16, 'Sections', '2024-09-07 16:52:12', 2),
(26, 'Contact Us  Section', 'Design for contact us section.', 16, 'Sections', '2024-09-07 17:58:55', 2),
(27, 'Contact Us Map Section', 'Design for contact us map section.', 16, 'Sections', '2024-09-07 18:10:23', 2),
(28, 'Contact Us Contact Form', 'Design for contact us contact form.', 5, 'Contact Form', '2024-09-07 18:29:10', 2),
(29, 'Booking Form Section', 'Design for booking form section.', 16, 'Sections', '2024-09-12 20:28:12', 2);

--
-- Triggers `block_style`
--
DROP TRIGGER IF EXISTS `block_style_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `block_style_trigger_insert` AFTER INSERT ON `block_style` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Block style created. <br/>';

    IF NEW.block_style_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Style Name: ", NEW.block_style_name);
    END IF;

    IF NEW.description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.description);
    END IF;

    IF NEW.block_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Type Name: ", NEW.block_type_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('block_style', NEW.block_style_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `block_style_trigger_update`;
DELIMITER $$
CREATE TRIGGER `block_style_trigger_update` AFTER UPDATE ON `block_style` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.block_style_name <> OLD.block_style_name THEN
        SET audit_log = CONCAT(audit_log, "Block Style Name: ", OLD.block_style_name, " -> ", NEW.block_style_name, "<br/>");
    END IF;

    IF NEW.description <> OLD.description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.description, " -> ", NEW.description, "<br/>");
    END IF;

    IF NEW.block_type_name <> OLD.block_type_name THEN
        SET audit_log = CONCAT(audit_log, "Block Type Name: ", OLD.block_type_name, " -> ", NEW.block_type_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('block_style', NEW.block_style_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `block_type`
--

DROP TABLE IF EXISTS `block_type`;
CREATE TABLE `block_type` (
  `block_type_id` int(10) UNSIGNED NOT NULL,
  `block_type_name` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `block_type`
--

INSERT INTO `block_type` (`block_type_id`, `block_type_name`, `created_date`, `last_log_by`) VALUES
(1, 'Accordion', '2024-08-26 21:40:20', 1),
(2, 'Call To Action', '2024-08-26 21:40:20', 1),
(3, 'Carousel', '2024-08-26 21:40:20', 1),
(4, 'Client', '2024-08-26 21:40:20', 1),
(5, 'Contact Form', '2024-08-26 21:40:20', 1),
(6, 'Content Carousel', '2024-08-26 21:40:20', 1),
(7, 'Footer', '2024-08-26 21:40:20', 1),
(8, 'Header', '2024-08-26 21:40:20', 1),
(9, 'Image Gallery', '2024-08-26 21:40:20', 1),
(10, 'Page Title', '2024-08-26 21:40:20', 1),
(11, 'Pricing Table', '2024-08-26 21:40:20', 1),
(12, 'Process Step', '2024-08-26 21:40:20', 1),
(13, 'Services Box', '2024-08-26 21:40:20', 1),
(14, 'Slider', '2024-08-26 21:40:20', 1),
(15, 'Testimonial', '2024-08-26 21:40:20', 1),
(16, 'Sections', '2024-09-02 13:50:24', 2);

--
-- Triggers `block_type`
--
DROP TRIGGER IF EXISTS `block_type_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `block_type_trigger_insert` AFTER INSERT ON `block_type` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Block type created. <br/>';

    IF NEW.block_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Type Name: ", NEW.block_type_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('block_type', NEW.block_type_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `block_type_trigger_update`;
DELIMITER $$
CREATE TRIGGER `block_type_trigger_update` AFTER UPDATE ON `block_type` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.block_type_name <> OLD.block_type_name THEN
        SET audit_log = CONCAT(audit_log, "Block Type Name: ", OLD.block_type_name, " -> ", NEW.block_type_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('block_type', NEW.block_type_id, audit_log, NEW.last_log_by, NOW());
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
-- Table structure for table `booking`
--

DROP TABLE IF EXISTS `booking`;
CREATE TABLE `booking` (
  `booking_id` int(10) UNSIGNED NOT NULL,
  `booking_reference_number` varchar(100) NOT NULL,
  `source_of_booking` varchar(50) NOT NULL DEFAULT 'Website',
  `service` varchar(100) NOT NULL,
  `frequency` varchar(50) DEFAULT NULL,
  `duration` int(11) DEFAULT NULL,
  `number_of_seats` int(11) DEFAULT NULL,
  `meters` int(11) DEFAULT NULL,
  `cleaning_materials` varchar(10) NOT NULL,
  `booking_date` date NOT NULL,
  `booking_time` varchar(20) NOT NULL,
  `number_of_professionals` int(11) NOT NULL,
  `number_of_hours` int(11) NOT NULL,
  `nationality` varchar(50) NOT NULL,
  `first_name` varchar(500) NOT NULL,
  `last_name` varchar(500) NOT NULL,
  `address` longtext NOT NULL,
  `phone` varchar(50) NOT NULL,
  `email_address` varchar(500) NOT NULL,
  `special_instructions` longtext DEFAULT NULL,
  `mode_of_payment` varchar(50) DEFAULT NULL,
  `discount_code` varchar(50) DEFAULT NULL,
  `discount_type` varchar(20) DEFAULT NULL,
  `discount_amount` double DEFAULT NULL,
  `total_discount_amount` double DEFAULT NULL,
  `booking_subtotal_amount` double DEFAULT NULL,
  `total_booking_amount` double DEFAULT NULL,
  `payment_amount` double DEFAULT NULL,
  `refund_amount` double DEFAULT NULL,
  `payment_status` varchar(100) NOT NULL DEFAULT 'Pending',
  `booking_status` varchar(100) NOT NULL DEFAULT 'Pending',
  `cancellation_request_date` datetime DEFAULT NULL,
  `cancellation_window` datetime DEFAULT NULL,
  `cancellation_reason` longtext DEFAULT NULL,
  `payment_reference_number` varchar(500) DEFAULT NULL,
  `payment_date` datetime DEFAULT NULL,
  `booking_for_cancellation_rejection_date` datetime DEFAULT NULL,
  `booking_for_cancellation_rejection_reason` longtext DEFAULT NULL,
  `for_refund_date` datetime DEFAULT NULL,
  `for_refund_reason` longtext DEFAULT NULL,
  `for_refund_rejection_date` datetime DEFAULT NULL,
  `for_refund_rejection_reason` longtext DEFAULT NULL,
  `refund_date` datetime DEFAULT NULL,
  `in_progress_date` datetime DEFAULT NULL,
  `completed_date` datetime DEFAULT NULL,
  `cancellation_date` datetime DEFAULT NULL,
  `transaction_date` datetime NOT NULL DEFAULT current_timestamp(),
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `booking`
--

INSERT INTO `booking` (`booking_id`, `booking_reference_number`, `source_of_booking`, `service`, `frequency`, `duration`, `number_of_seats`, `meters`, `cleaning_materials`, `booking_date`, `booking_time`, `number_of_professionals`, `number_of_hours`, `nationality`, `first_name`, `last_name`, `address`, `phone`, `email_address`, `special_instructions`, `mode_of_payment`, `discount_code`, `discount_type`, `discount_amount`, `total_discount_amount`, `booking_subtotal_amount`, `total_booking_amount`, `payment_amount`, `refund_amount`, `payment_status`, `booking_status`, `cancellation_request_date`, `cancellation_window`, `cancellation_reason`, `payment_reference_number`, `payment_date`, `booking_for_cancellation_rejection_date`, `booking_for_cancellation_rejection_reason`, `for_refund_date`, `for_refund_reason`, `for_refund_rejection_date`, `for_refund_rejection_reason`, `refund_date`, `in_progress_date`, `completed_date`, `cancellation_date`, `transaction_date`, `created_date`, `last_log_by`) VALUES
(1, 'ALTH5YT649XZ', 'Website', 'Office Cleaning', 'Weekly', 2, 0, 0, 'No', '2024-09-19', '1:00 PM', 16, 6, 'Filipino', 'asd', 'asd', 'asd', 'asd', 'asd@gmail.com', 'asd', 'Online Banking', '', '', 0, 0, 50, 50, 123, 12, 'Rejected', 'Completed', NULL, '2024-09-18 13:00:00', NULL, '123123', '2024-09-12 00:00:00', NULL, NULL, '2024-09-12 12:33:42', 'asd', '2024-09-12 13:03:16', 'asdasd', NULL, '2024-09-12 13:12:54', '2024-09-12 13:12:58', NULL, '2024-09-12 12:31:34', '2024-09-12 12:31:34', 2),
(2, 'ALTH9R4LQC8J', 'Facebook', 'Flat Cleaning', 'Monthly', 5, 0, 0, 'Yes', '2024-09-19', '1:00 PM', 14, 1, 'Nepali', 'asd', 'asd', 'asd', 'asd', 'asd@gmail.com', 'as', 'Online Banking', '', '', 0, 0, 135, 135, 12, 123, 'Refunded', 'Completed', '2024-09-12 13:19:34', '2024-09-18 13:00:00', 'asd', '12', '2024-09-13 00:00:00', '2024-09-12 13:20:21', 'asd', '2024-09-12 13:16:52', '123', NULL, NULL, '2024-09-12 13:19:23', '2024-09-12 13:21:32', '2024-09-12 14:05:26', NULL, '2024-09-12 13:13:19', '2024-09-12 13:13:19', 2),
(3, 'ALTHAGFEMPJ7', 'Facebook', 'Office Cleaning', 'Monthly', 3, 0, 0, 'Yes', '2024-09-25', '6:00 PM', 17, 4, 'Nepali', 'asd', 'asd', 'asd', 'asd', 'asd@gmail.com', 'as', 'Stripe', '', '', 0, 0, 85, 85, 12, 12, 'Refunded', 'Cancelled', '2024-09-12 14:13:29', '2024-09-24 18:00:00', 'asds', '12', '2024-09-12 00:00:00', '2024-09-12 14:13:10', 'asdasd', '2024-09-12 14:22:38', '12', '2024-09-12 14:22:33', '12', '2024-09-12 14:22:41', NULL, NULL, '2024-09-12 14:13:39', '2024-09-12 14:12:52', '2024-09-12 14:12:52', 2),
(4, 'ALTHNUOHULT4', 'Youtube', 'Hospital Cleaning', 'Weekly', 3, 0, 0, 'No', '2024-09-26', '12:00 PM', 15, 6, 'African', 'asd', 'asd', 'ads', 'ad', 'asd@gmail.com', '', 'Online Banking', '', '', 0, 0, 75, 75, 123, 1231, 'Refunded', 'Pending', '2024-09-12 15:27:50', '2024-09-25 12:00:00', 'asd', '123', '2024-09-12 00:00:00', '2024-09-12 15:29:10', 'asd', '2024-09-12 15:28:43', 'asd', NULL, NULL, '2024-09-12 17:02:31', NULL, NULL, NULL, '2024-09-12 15:27:46', '2024-09-12 15:27:46', 2),
(5, 'ALTHF3TAFCVP', 'Website', 'Deep Cleaning', 'Weekly', 8, 0, 0, 'Yes', '2024-09-13', '10:00 AM', 14, 4, 'Filipino', 'ads', 'as', 'ad', 'ad', 'asd@gmail.com', '', 'Stripe', '', NULL, 0, 0, 210, 210, 2024, NULL, 'Paid', 'Pending', NULL, '2024-09-13 08:00:00', NULL, '', '0000-00-00 00:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-09-12 15:40:47', '2024-09-12 15:40:47', 1),
(6, 'ALTHKE6P2I3G', 'Website', 'Regular Cleaning', 'Monthly', 4, 0, 0, 'Yes', '2024-09-13', '1:00 PM', 5, 3, 'Filipino', 'asd', 'asd', 'asd', 'asd', 'asd@gmail.com', '', 'Stripe', '', NULL, 0, 0, 110, 110, 120, NULL, 'Paid', 'Pending', NULL, '2024-09-13 11:00:00', NULL, 'pi_3Py7vL011037BG0D0mJPSMzp', '2024-09-12 15:59:48', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-09-12 15:59:14', '2024-09-12 15:59:14', 1),
(7, 'ALTHS24WE3FM', 'Website', 'Regular Cleaning', 'One Time', 4, 0, 0, 'No', '2099-08-08', '2:00 PM', 15, 1, 'Filipino', 'asd', 'asd', 'asd', 'asd', 'asd@gmail.com', '', 'Stripe', '', NULL, 0, 0, 100, 100, 100, 80, 'Refunded', 'Pending', NULL, '2099-08-07 14:00:00', NULL, 'pi_3Py7xn011037BG0D0R3z1sJw', '2024-09-12 16:02:20', NULL, NULL, '2024-09-12 16:51:03', 'asdasd', NULL, NULL, '2024-09-12 16:51:16', NULL, NULL, NULL, '2024-09-12 16:01:56', '2024-09-12 16:01:56', 2),
(8, 'ALTHI8J0FMQW', 'Website', 'Regular Cleaning', 'Weekly', 4, 0, 0, 'Yes', '2099-12-31', '10:00 AM', 15, 2, 'Nepali', 'asd', 'asd', 'asd', 'asd', 'asd@gmail.com', 'asd', 'Stripe', '', NULL, 0, 0, 110, 110, 120, NULL, 'Paid', 'Pending', NULL, '2099-12-30 10:00:00', NULL, 'pi_3Py90W011037BG0D1RigBqGe', '2024-09-12 17:09:13', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-09-12 17:08:53', '2024-09-12 17:08:53', 1),
(9, 'ALTH2YDGIMAC', 'Website', 'Deep Cleaning', 'Yearly', 4, 0, 0, 'Yes', '2024-09-30', '1:00 PM', 18, 2, 'Nepali', 'as', 'dasd', 'asd', 'asd', 'asd@gmail.com', '', 'Stripe', '', NULL, 0, 0, 110, 110, NULL, NULL, 'Pending', 'Pending', NULL, '2024-09-29 13:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-09-12 17:20:24', '2024-09-12 17:20:24', 1),
(10, 'ALTHCTSYHCPC', 'Website', 'Deep Cleaning', 'One Time', 4, 0, 0, 'Yes', '2024-09-13', '10:00 AM', 5, 3, 'African', 'asd', 'asd', 'asd', 'asd', 'ads@gmail.com', '', 'Stripe', '', NULL, 0, 0, 110, 110, NULL, NULL, 'Pending', 'Pending', NULL, '2024-09-13 08:00:00', NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, NULL, '2024-09-12 17:22:22', '2024-09-12 17:22:22', 1);

--
-- Triggers `booking`
--
DROP TRIGGER IF EXISTS `booking_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `booking_trigger_insert` AFTER INSERT ON `booking` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Booking created. <br/>';

    IF NEW.booking_reference_number <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Booking Reference Number: ", NEW.booking_reference_number);
    END IF;

    IF NEW.source_of_booking <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Source of Booking: ", NEW.source_of_booking);
    END IF;

    IF NEW.service <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Service: ", NEW.service);
    END IF;

    IF NEW.frequency <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Frequency: ", NEW.frequency);
    END IF;

    IF NEW.duration <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Duration: ", NEW.duration);
    END IF;

    IF NEW.number_of_seats <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Number of Seats: ", NEW.number_of_seats);
    END IF;

    IF NEW.meters <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Meters: ", NEW.meters);
    END IF;

    IF NEW.cleaning_materials <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Cleaning Materials: ", NEW.cleaning_materials);
    END IF;

    IF NEW.booking_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Booking Date: ", NEW.booking_date);
    END IF;

    IF NEW.booking_time <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Booking Time: ", NEW.booking_time);
    END IF;

    IF NEW.number_of_professionals <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Number of Professionals: ", NEW.number_of_professionals);
    END IF;

    IF NEW.number_of_hours <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Number of Hours: ", NEW.number_of_hours);
    END IF;

    IF NEW.nationality <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Nationality: ", NEW.nationality);
    END IF;

    IF NEW.first_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>First Name: ", NEW.first_name);
    END IF;

    IF NEW.last_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Last Name: ", NEW.last_name);
    END IF;

    IF NEW.address <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Address: ", NEW.address);
    END IF;

    IF NEW.phone <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Phone: ", NEW.phone);
    END IF;

    IF NEW.email_address <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Email Address: ", NEW.email_address);
    END IF;

    IF NEW.special_instructions <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Special Instructions: ", NEW.special_instructions);
    END IF;

    IF NEW.mode_of_payment <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Mode of Payment: ", NEW.mode_of_payment);
    END IF;

    IF NEW.discount_code <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Discount Code: ", NEW.discount_code);
    END IF;

    IF NEW.discount_type <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Discount Type: ", NEW.discount_type);
    END IF;

    IF NEW.discount_amount <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Discount Amount: ", NEW.discount_amount);
    END IF;

    IF NEW.total_discount_amount <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Total Discount Amount: ", NEW.total_discount_amount);
    END IF;

    IF NEW.booking_subtotal_amount <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Booking Subtotal Amount: ", NEW.booking_subtotal_amount);
    END IF;

    IF NEW.total_booking_amount <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Total Booking Amount: ", NEW.total_booking_amount);
    END IF;

    IF NEW.payment_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Payment Status: ", NEW.payment_status);
    END IF;

    IF NEW.booking_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Booking Status: ", NEW.booking_status);
    END IF;

    IF NEW.cancellation_window <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Cancellation Window: ", NEW.cancellation_window);
    END IF;

    IF NEW.payment_reference_number <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Payment Reference Number: ", NEW.payment_reference_number);
    END IF;

    IF NEW.payment_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Payment Date: ", NEW.payment_date);
    END IF;

    IF NEW.transaction_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Transaction Date: ", NEW.transaction_date);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('booking', NEW.booking_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `booking_trigger_update`;
DELIMITER $$
CREATE TRIGGER `booking_trigger_update` AFTER UPDATE ON `booking` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.source_of_booking <> OLD.source_of_booking THEN
        SET audit_log = CONCAT(audit_log, "Source of Booking: ", OLD.source_of_booking, " -> ", NEW.source_of_booking, "<br/>");
    END IF;

    IF NEW.service <> OLD.service THEN
        SET audit_log = CONCAT(audit_log, "Service: ", OLD.service, " -> ", NEW.service, "<br/>");
    END IF;

    IF NEW.frequency <> OLD.frequency THEN
        SET audit_log = CONCAT(audit_log, "Frequency: ", OLD.frequency, " -> ", NEW.frequency, "<br/>");
    END IF;

    IF NEW.duration <> OLD.duration THEN
        SET audit_log = CONCAT(audit_log, "Duration: ", OLD.duration, " -> ", NEW.duration, "<br/>");
    END IF;

    IF NEW.number_of_seats <> OLD.number_of_seats THEN
        SET audit_log = CONCAT(audit_log, "Number of Seats: ", OLD.number_of_seats, " -> ", NEW.number_of_seats, "<br/>");
    END IF;

    IF NEW.meters <> OLD.meters THEN
        SET audit_log = CONCAT(audit_log, "Meters: ", OLD.meters, " -> ", NEW.meters, "<br/>");
    END IF;

    IF NEW.cleaning_materials <> OLD.cleaning_materials THEN
        SET audit_log = CONCAT(audit_log, "Cleaning Materials: ", OLD.cleaning_materials, " -> ", NEW.cleaning_materials, "<br/>");
    END IF;

    IF NEW.booking_date <> OLD.booking_date THEN
        SET audit_log = CONCAT(audit_log, "Booking Date: ", OLD.booking_date, " -> ", NEW.booking_date, "<br/>");
    END IF;

    IF NEW.booking_time <> OLD.booking_time THEN
        SET audit_log = CONCAT(audit_log, "Booking Time: ", OLD.booking_time, " -> ", NEW.booking_time, "<br/>");
    END IF;

    IF NEW.number_of_professionals <> OLD.number_of_professionals THEN
        SET audit_log = CONCAT(audit_log, "Number of Professionals: ", OLD.number_of_professionals, " -> ", NEW.number_of_professionals, "<br/>");
    END IF;

    IF NEW.number_of_hours <> OLD.number_of_hours THEN
        SET audit_log = CONCAT(audit_log, "Number of Hours: ", OLD.number_of_hours, " -> ", NEW.number_of_hours, "<br/>");
    END IF;

    IF NEW.nationality <> OLD.nationality THEN
        SET audit_log = CONCAT(audit_log, "Nationality: ", OLD.nationality, " -> ", NEW.nationality, "<br/>");
    END IF;

    IF NEW.first_name <> OLD.first_name THEN
        SET audit_log = CONCAT(audit_log, "First Name: ", OLD.first_name, " -> ", NEW.first_name, "<br/>");
    END IF;

    IF NEW.last_name <> OLD.last_name THEN
        SET audit_log = CONCAT(audit_log, "Last Name: ", OLD.last_name, " -> ", NEW.last_name, "<br/>");
    END IF;

    IF NEW.address <> OLD.address THEN
        SET audit_log = CONCAT(audit_log, "Address: ", OLD.address, " -> ", NEW.address, "<br/>");
    END IF;

    IF NEW.phone <> OLD.phone THEN
        SET audit_log = CONCAT(audit_log, "Phone: ", OLD.phone, " -> ", NEW.phone, "<br/>");
    END IF;

    IF NEW.email_address <> OLD.email_address THEN
        SET audit_log = CONCAT(audit_log, "Email Address: ", OLD.email_address, " -> ", NEW.email_address, "<br/>");
    END IF;

    IF NEW.special_instructions <> OLD.special_instructions THEN
        SET audit_log = CONCAT(audit_log, "Special Instructions: ", OLD.special_instructions, " -> ", NEW.special_instructions, "<br/>");
    END IF;

    IF NEW.mode_of_payment <> OLD.mode_of_payment THEN
        SET audit_log = CONCAT(audit_log, "Mode of Payment: ", OLD.mode_of_payment, " -> ", NEW.mode_of_payment, "<br/>");
    END IF;

    IF NEW.discount_code <> OLD.discount_code THEN
        SET audit_log = CONCAT(audit_log, "Discount Code: ", OLD.discount_code, " -> ", NEW.discount_code, "<br/>");
    END IF;

    IF NEW.discount_type <> OLD.discount_type THEN
        SET audit_log = CONCAT(audit_log, "Discount Type: ", OLD.discount_type, " -> ", NEW.discount_type, "<br/>");
    END IF;

    IF NEW.discount_amount <> OLD.discount_amount THEN
        SET audit_log = CONCAT(audit_log, "Discount Amount: ", OLD.discount_amount, " -> ", NEW.discount_amount, "<br/>");
    END IF;

    IF NEW.total_discount_amount <> OLD.total_discount_amount THEN
        SET audit_log = CONCAT(audit_log, "Total Discount Amount: ", OLD.total_discount_amount, " -> ", NEW.total_discount_amount, "<br/>");
    END IF;

    IF NEW.booking_subtotal_amount <> OLD.booking_subtotal_amount THEN
        SET audit_log = CONCAT(audit_log, "Booking Subtotal Amount: ", OLD.booking_subtotal_amount, " -> ", NEW.booking_subtotal_amount, "<br/>");
    END IF;

    IF NEW.total_booking_amount <> OLD.total_booking_amount THEN
        SET audit_log = CONCAT(audit_log, "Total Booking Amount: ", OLD.total_booking_amount, " -> ", NEW.total_booking_amount, "<br/>");
    END IF;

    IF NEW.payment_amount <> OLD.payment_amount THEN
        SET audit_log = CONCAT(audit_log, "Payment Amount: ", OLD.payment_amount, " -> ", NEW.payment_amount, "<br/>");
    END IF;

    IF NEW.refund_amount <> OLD.refund_amount THEN
        SET audit_log = CONCAT(audit_log, "Refund Amount: ", OLD.refund_amount, " -> ", NEW.refund_amount, "<br/>");
    END IF;

    IF NEW.payment_status <> OLD.payment_status THEN
        SET audit_log = CONCAT(audit_log, "Payment Status: ", OLD.payment_status, " -> ", NEW.payment_status, "<br/>");
    END IF;

    IF NEW.booking_status <> OLD.booking_status THEN
        SET audit_log = CONCAT(audit_log, "Booking Status: ", OLD.booking_status, " -> ", NEW.booking_status, "<br/>");
    END IF;

    IF NEW.cancellation_request_date <> OLD.cancellation_request_date THEN
        SET audit_log = CONCAT(audit_log, "Cancellation Request Date: ", OLD.cancellation_request_date, " -> ", NEW.cancellation_request_date, "<br/>");
    END IF;

    IF NEW.cancellation_window <> OLD.cancellation_window THEN
        SET audit_log = CONCAT(audit_log, "Cancellation Window: ", OLD.cancellation_window, " -> ", NEW.cancellation_window, "<br/>");
    END IF;

    IF NEW.cancellation_reason <> OLD.cancellation_reason THEN
        SET audit_log = CONCAT(audit_log, "Cancellation Reason: ", OLD.cancellation_reason, " -> ", NEW.cancellation_reason, "<br/>");
    END IF;

    IF NEW.payment_reference_number <> OLD.payment_reference_number THEN
        SET audit_log = CONCAT(audit_log, "Payment Reference Number: ", OLD.payment_reference_number, " -> ", NEW.payment_reference_number, "<br/>");
    END IF;

    IF NEW.payment_date <> OLD.payment_date THEN
        SET audit_log = CONCAT(audit_log, "Payment Date: ", OLD.payment_date, " -> ", NEW.payment_date, "<br/>");
    END IF;

    IF NEW.booking_for_cancellation_rejection_date <> OLD.booking_for_cancellation_rejection_date THEN
        SET audit_log = CONCAT(audit_log, "For Cancellation Rejection Date: ", OLD.booking_for_cancellation_rejection_date, " -> ", NEW.booking_for_cancellation_rejection_date, "<br/>");
    END IF;

    IF NEW.booking_for_cancellation_rejection_reason <> OLD.booking_for_cancellation_rejection_reason THEN
        SET audit_log = CONCAT(audit_log, "For Cancellation Rejection Reason: ", OLD.booking_for_cancellation_rejection_reason, " -> ", NEW.booking_for_cancellation_rejection_reason, "<br/>");
    END IF;

    IF NEW.for_refund_date <> OLD.for_refund_date THEN
        SET audit_log = CONCAT(audit_log, "For Refund Date: ", OLD.for_refund_date, " -> ", NEW.for_refund_date, "<br/>");
    END IF;

    IF NEW.for_refund_reason <> OLD.for_refund_reason THEN
        SET audit_log = CONCAT(audit_log, "For Refund Reason: ", OLD.for_refund_reason, " -> ", NEW.for_refund_reason, "<br/>");
    END IF;

    IF NEW.for_refund_rejection_date <> OLD.for_refund_rejection_date THEN
        SET audit_log = CONCAT(audit_log, "For Refund Rejection Date: ", OLD.for_refund_rejection_date, " -> ", NEW.for_refund_rejection_date, "<br/>");
    END IF;

    IF NEW.for_refund_rejection_reason <> OLD.for_refund_rejection_reason THEN
        SET audit_log = CONCAT(audit_log, "For Refund Rejection Reason: ", OLD.for_refund_rejection_reason, " -> ", NEW.for_refund_rejection_reason, "<br/>");
    END IF;

    IF NEW.refund_date <> OLD.refund_date THEN
        SET audit_log = CONCAT(audit_log, "Refund Date: ", OLD.refund_date, " -> ", NEW.refund_date, "<br/>");
    END IF;

    IF NEW.in_progress_date <> OLD.in_progress_date THEN
        SET audit_log = CONCAT(audit_log, "In-Progress Date: ", OLD.in_progress_date, " -> ", NEW.in_progress_date, "<br/>");
    END IF;

    IF NEW.completed_date <> OLD.completed_date THEN
        SET audit_log = CONCAT(audit_log, "Completed Date: ", OLD.completed_date, " -> ", NEW.completed_date, "<br/>");
    END IF;

    IF NEW.cancellation_date <> OLD.cancellation_date THEN
        SET audit_log = CONCAT(audit_log, "Cancellation Date: ", OLD.cancellation_date, " -> ", NEW.cancellation_date, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('booking', NEW.booking_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `call_to_action`
--

DROP TABLE IF EXISTS `call_to_action`;
CREATE TABLE `call_to_action` (
  `call_to_action_id` int(10) UNSIGNED NOT NULL,
  `call_to_action_name` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `block_style_id` int(10) UNSIGNED NOT NULL,
  `block_style_name` varchar(100) NOT NULL,
  `call_to_action_header` varchar(500) NOT NULL,
  `call_to_action_body` longtext NOT NULL,
  `publish_status` varchar(5) NOT NULL DEFAULT 'No',
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `call_to_action`
--

INSERT INTO `call_to_action` (`call_to_action_id`, `call_to_action_name`, `description`, `block_style_id`, `block_style_name`, `call_to_action_header`, `call_to_action_body`, `publish_status`, `created_date`, `last_log_by`) VALUES
(1, 'Home Page Call To Action 1', 'Design for the call to action 1 on the home page of the website.', 4, 'Home Page Call To Action 1', 'Trusted Cleaning Partners', 'Reliable cleaning for any space, big or small', 'No', '2024-09-06 23:11:47', 2),
(2, 'Home Page Call To Action 2', 'Design for the call to action 2 on the home page of the website.', 5, 'Home Page Call To Action 2', 'Top Cleaning Solutions for Every Space', 'We provide comprehensive cleaning services, ensuring spotless results for homes and businesses of all sizes', 'No', '2024-09-06 23:28:30', 2),
(3, 'Home Page Call To Action 3', 'Design for the call to action 3 on the home page of the website.', 8, 'Home Page Call To Action 3', 'N/A', 'Save your precious time and effort spent for finding a solution.', 'No', '2024-09-07 00:19:52', 2),
(4, 'Home Page Call To Action 4', 'Design for the call to action 4 on the home page of the website.', 9, 'Home Page Call To Action 4', 'Why choose us?', 'Outstanding cleaning features for your peace of mind.', 'No', '2024-09-07 00:24:03', 2);

--
-- Triggers `call_to_action`
--
DROP TRIGGER IF EXISTS `call_to_action_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `call_to_action_trigger_insert` AFTER INSERT ON `call_to_action` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Call to Action created. <br/>';

    IF NEW.call_to_action_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Call to Action Name: ", NEW.call_to_action_name);
    END IF;

    IF NEW.description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.description);
    END IF;

    IF NEW.block_style_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Style Name: ", NEW.block_style_name);
    END IF;

    IF NEW.call_to_action_header <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Call to Action Header: ", NEW.call_to_action_header);
    END IF;

    IF NEW.call_to_action_body <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Call to Action Body: ", NEW.call_to_action_body);
    END IF;

    IF NEW.publish_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Publish Status: ", NEW.publish_status);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('call_to_action', NEW.call_to_action_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `call_to_action_trigger_update`;
DELIMITER $$
CREATE TRIGGER `call_to_action_trigger_update` AFTER UPDATE ON `call_to_action` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.call_to_action_name <> OLD.call_to_action_name THEN
        SET audit_log = CONCAT(audit_log, "Call to Action Name: ", OLD.call_to_action_name, " -> ", NEW.call_to_action_name, "<br/>");
    END IF;

    IF NEW.description <> OLD.description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.description, " -> ", NEW.description, "<br/>");
    END IF;

    IF NEW.block_style_name <> OLD.block_style_name THEN
        SET audit_log = CONCAT(audit_log, "Block Style Name: ", OLD.block_style_name, " -> ", NEW.block_style_name, "<br/>");
    END IF;

    IF NEW.call_to_action_header <> OLD.call_to_action_header THEN
        SET audit_log = CONCAT(audit_log, "Call to Action Header: ", OLD.call_to_action_header, " -> ", NEW.call_to_action_header, "<br/>");
    END IF;

    IF NEW.call_to_action_body <> OLD.call_to_action_body THEN
        SET audit_log = CONCAT(audit_log, "Call to Action Body: ", OLD.call_to_action_body, " -> ", NEW.call_to_action_body, "<br/>");
    END IF;

    IF NEW.publish_status <> OLD.publish_status THEN
        SET audit_log = CONCAT(audit_log, "Publish Status: ", OLD.publish_status, " -> ", NEW.publish_status, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('call_to_action', NEW.call_to_action_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `carousel`
--

DROP TABLE IF EXISTS `carousel`;
CREATE TABLE `carousel` (
  `carousel_id` int(10) UNSIGNED NOT NULL,
  `carousel_name` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `block_style_id` int(10) UNSIGNED NOT NULL,
  `block_style_name` varchar(100) NOT NULL,
  `publish_status` varchar(5) NOT NULL DEFAULT 'No',
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `carousel`
--
DROP TRIGGER IF EXISTS `carousel_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `carousel_trigger_insert` AFTER INSERT ON `carousel` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Carousel created. <br/>';

    IF NEW.carousel_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Carousel Name: ", NEW.carousel_name);
    END IF;

    IF NEW.description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.description);
    END IF;

    IF NEW.block_style_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Style Name: ", NEW.block_style_name);
    END IF;

    IF NEW.publish_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Publish Status: ", NEW.publish_status);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('carousel', NEW.carousel_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `carousel_trigger_update`;
DELIMITER $$
CREATE TRIGGER `carousel_trigger_update` AFTER UPDATE ON `carousel` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.carousel_name <> OLD.carousel_name THEN
        SET audit_log = CONCAT(audit_log, "Carousel Name: ", OLD.carousel_name, " -> ", NEW.carousel_name, "<br/>");
    END IF;

    IF NEW.description <> OLD.description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.description, " -> ", NEW.description, "<br/>");
    END IF;

    IF NEW.block_style_name <> OLD.block_style_name THEN
        SET audit_log = CONCAT(audit_log, "Block Style Name: ", OLD.block_style_name, " -> ", NEW.block_style_name, "<br/>");
    END IF;

    IF NEW.publish_status <> OLD.publish_status THEN
        SET audit_log = CONCAT(audit_log, "Publish Status: ", OLD.publish_status, " -> ", NEW.publish_status, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('carousel', NEW.carousel_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `carousel_image`
--

DROP TABLE IF EXISTS `carousel_image`;
CREATE TABLE `carousel_image` (
  `carousel_image_id` int(10) UNSIGNED NOT NULL,
  `carousel_id` int(10) UNSIGNED NOT NULL,
  `carousel_image` varchar(500) NOT NULL,
  `order_sequence` int(11) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `carousel_image`
--
DROP TRIGGER IF EXISTS `carousel_image_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `carousel_image_trigger_insert` AFTER INSERT ON `carousel_image` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Carousel image created. <br/>';

    IF NEW.order_sequence <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Order Sequence: ", NEW.order_sequence);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('carousel_image', NEW.carousel_image_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `carousel_image_trigger_update`;
DELIMITER $$
CREATE TRIGGER `carousel_image_trigger_update` AFTER UPDATE ON `carousel_image` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';
    
    IF NEW.order_sequence <> OLD.order_sequence THEN
        SET audit_log = CONCAT(audit_log, "Order Sequence: ", OLD.order_sequence, " -> ", NEW.order_sequence, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('carousel_image', NEW.carousel_image_id, audit_log, NEW.last_log_by, NOW());
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
(1, 'Andorra la Vella', 488, 'Andorra la Vella', 6, 'Andorra', '2024-09-04 16:59:25', 1),
(2, 'Arinsal', 493, 'La Massana', 6, 'Andorra', '2024-09-04 16:59:25', 1),
(3, 'Canillo', 489, 'Canillo', 6, 'Andorra', '2024-09-04 16:59:25', 1),
(4, 'El Tarter', 489, 'Canillo', 6, 'Andorra', '2024-09-04 16:59:25', 1);

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
-- Table structure for table `client`
--

DROP TABLE IF EXISTS `client`;
CREATE TABLE `client` (
  `client_id` int(10) UNSIGNED NOT NULL,
  `client_name` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `block_style_id` int(10) UNSIGNED NOT NULL,
  `block_style_name` varchar(100) NOT NULL,
  `publish_status` varchar(5) NOT NULL DEFAULT 'No',
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `client`
--

INSERT INTO `client` (`client_id`, `client_name`, `description`, `block_style_id`, `block_style_name`, `publish_status`, `created_date`, `last_log_by`) VALUES
(1, 'Certifcations', 'Design for the company\'s certifications.', 6, 'Certifications', 'No', '2024-09-06 23:35:49', 2);

--
-- Triggers `client`
--
DROP TRIGGER IF EXISTS `client_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `client_trigger_insert` AFTER INSERT ON `client` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Client created. <br/>';

    IF NEW.client_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Client Name: ", NEW.client_name);
    END IF;

    IF NEW.description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.description);
    END IF;

    IF NEW.block_style_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Style Name: ", NEW.block_style_name);
    END IF;

    IF NEW.publish_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Publish Status: ", NEW.publish_status);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('client', NEW.client_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `client_trigger_update`;
DELIMITER $$
CREATE TRIGGER `client_trigger_update` AFTER UPDATE ON `client` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.client_name <> OLD.client_name THEN
        SET audit_log = CONCAT(audit_log, "Client Name: ", OLD.client_name, " -> ", NEW.client_name, "<br/>");
    END IF;

    IF NEW.description <> OLD.description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.description, " -> ", NEW.description, "<br/>");
    END IF;

    IF NEW.block_style_name <> OLD.block_style_name THEN
        SET audit_log = CONCAT(audit_log, "Block Style Name: ", OLD.block_style_name, " -> ", NEW.block_style_name, "<br/>");
    END IF;


    IF NEW.publish_status <> OLD.publish_status THEN
        SET audit_log = CONCAT(audit_log, "Publish Status: ", OLD.publish_status, " -> ", NEW.publish_status, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('client', NEW.client_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `client_item`
--

DROP TABLE IF EXISTS `client_item`;
CREATE TABLE `client_item` (
  `client_item_id` int(10) UNSIGNED NOT NULL,
  `client_id` int(10) UNSIGNED NOT NULL,
  `client_logo` varchar(500) NOT NULL,
  `client_url` varchar(500) DEFAULT NULL,
  `order_sequence` int(11) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `client_item`
--

INSERT INTO `client_item` (`client_item_id`, `client_id`, `client_logo`, `client_url`, `order_sequence`, `created_date`, `last_log_by`) VALUES
(1, 1, './components/client/logo/1/Woth.svg', 'javascript:void(0);', 1, '2024-09-06 23:37:22', 2),
(2, 1, './components/client/logo/1/9sCt.svg', 'javascript:void(0);', 2, '2024-09-06 23:37:44', 2),
(3, 1, './components/client/logo/1/jR4P.svg', 'javascript:void(0);', 3, '2024-09-06 23:37:55', 2),
(4, 1, './components/client/logo/1/nR9S.png', 'javascript:void(0);', 4, '2024-09-06 23:38:12', 2);

--
-- Triggers `client_item`
--
DROP TRIGGER IF EXISTS `client_item_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `client_item_trigger_insert` AFTER INSERT ON `client_item` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Client item created. <br/>';

    IF NEW.client_url <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Client URL: ", NEW.client_url);
    END IF;

    IF NEW.order_sequence <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Order Sequence: ", NEW.order_sequence);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('client_item', NEW.client_item_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `client_item_trigger_update`;
DELIMITER $$
CREATE TRIGGER `client_item_trigger_update` AFTER UPDATE ON `client_item` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';
    
    IF NEW.client_url <> OLD.client_url THEN
        SET audit_log = CONCAT(audit_log, "Client URL: ", OLD.client_url, " -> ", NEW.client_url, "<br/>");
    END IF;
    
    IF NEW.order_sequence <> OLD.order_sequence THEN
        SET audit_log = CONCAT(audit_log, "Order Sequence: ", OLD.order_sequence, " -> ", NEW.order_sequence, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('client_item', NEW.client_item_id, audit_log, NEW.last_log_by, NOW());
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
(1, 'Christian General Motors Inc.', 'Christian General Motors Inc.', 'Km 112', 257, 'City of Cabanatuan', 13, 'Nueva Ecija', 174, 'Philippines', 26, 'Philippine Peso', '₱', '', '', '', '', '', NULL, '2024-07-09 10:31:57', 2);

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
-- Table structure for table `contact_form`
--

DROP TABLE IF EXISTS `contact_form`;
CREATE TABLE `contact_form` (
  `contact_form_id` int(10) UNSIGNED NOT NULL,
  `contact_form_name` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `block_style_id` int(10) UNSIGNED NOT NULL,
  `block_style_name` varchar(100) NOT NULL,
  `publish_status` varchar(5) NOT NULL DEFAULT 'No',
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `contact_form`
--

INSERT INTO `contact_form` (`contact_form_id`, `contact_form_name`, `description`, `block_style_id`, `block_style_name`, `publish_status`, `created_date`, `last_log_by`) VALUES
(1, 'Contact Us Contact Form', 'Design for contact us contact form.', 28, 'Contact Us Contact Form', 'No', '2024-09-07 18:29:27', 2);

--
-- Triggers `contact_form`
--
DROP TRIGGER IF EXISTS `contact_form_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `contact_form_trigger_insert` AFTER INSERT ON `contact_form` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Contact form created. <br/>';

    IF NEW.contact_form_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Contact Form Name: ", NEW.contact_form_name);
    END IF;

    IF NEW.description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.description);
    END IF;

    IF NEW.block_style_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Style Name: ", NEW.block_style_name);
    END IF;

    IF NEW.publish_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Publish Status: ", NEW.publish_status);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('contact_form', NEW.contact_form_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `contact_form_trigger_update`;
DELIMITER $$
CREATE TRIGGER `contact_form_trigger_update` AFTER UPDATE ON `contact_form` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.contact_form_name <> OLD.contact_form_name THEN
        SET audit_log = CONCAT(audit_log, "Contact Form Name: ", OLD.contact_form_name, " -> ", NEW.contact_form_name, "<br/>");
    END IF;

    IF NEW.description <> OLD.description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.description, " -> ", NEW.description, "<br/>");
    END IF;

    IF NEW.block_style_name <> OLD.block_style_name THEN
        SET audit_log = CONCAT(audit_log, "Block Style Name: ", OLD.block_style_name, " -> ", NEW.block_style_name, "<br/>");
    END IF;

    IF NEW.publish_status <> OLD.publish_status THEN
        SET audit_log = CONCAT(audit_log, "Publish Status: ", OLD.publish_status, " -> ", NEW.publish_status, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('contact_form', NEW.contact_form_id, audit_log, NEW.last_log_by, NOW());
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
-- Table structure for table `content_carousel`
--

DROP TABLE IF EXISTS `content_carousel`;
CREATE TABLE `content_carousel` (
  `content_carousel_id` int(10) UNSIGNED NOT NULL,
  `content_carousel_name` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `block_style_id` int(10) UNSIGNED NOT NULL,
  `block_style_name` varchar(100) NOT NULL,
  `publish_status` varchar(5) NOT NULL DEFAULT 'No',
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `content_carousel`
--
DROP TRIGGER IF EXISTS `content_carousel_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `content_carousel_trigger_insert` AFTER INSERT ON `content_carousel` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Content carousel created. <br/>';

    IF NEW.content_carousel_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Content Carousel Name: ", NEW.content_carousel_name);
    END IF;

    IF NEW.description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.description);
    END IF;

    IF NEW.block_style_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Style Name: ", NEW.block_style_name);
    END IF;

    IF NEW.publish_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Publish Status: ", NEW.publish_status);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('content_carousel', NEW.content_carousel_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `content_carousel_trigger_update`;
DELIMITER $$
CREATE TRIGGER `content_carousel_trigger_update` AFTER UPDATE ON `content_carousel` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.content_carousel_name <> OLD.content_carousel_name THEN
        SET audit_log = CONCAT(audit_log, "Content Carousel Name: ", OLD.content_carousel_name, " -> ", NEW.content_carousel_name, "<br/>");
    END IF;

    IF NEW.description <> OLD.description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.description, " -> ", NEW.description, "<br/>");
    END IF;

    IF NEW.block_style_name <> OLD.block_style_name THEN
        SET audit_log = CONCAT(audit_log, "Block Style Name: ", OLD.block_style_name, " -> ", NEW.block_style_name, "<br/>");
    END IF;

    IF NEW.publish_status <> OLD.publish_status THEN
        SET audit_log = CONCAT(audit_log, "Publish Status: ", OLD.publish_status, " -> ", NEW.publish_status, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('content_carousel', NEW.content_carousel_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `content_carousel_item`
--

DROP TABLE IF EXISTS `content_carousel_item`;
CREATE TABLE `content_carousel_item` (
  `content_carousel_item_id` int(10) UNSIGNED NOT NULL,
  `content_carousel_id` int(10) UNSIGNED NOT NULL,
  `content_carousel_title` varchar(500) NOT NULL,
  `content_carousel_heading` varchar(500) NOT NULL,
  `content_carousel_paragraph` longtext NOT NULL,
  `call_to_action_button_1_text` varchar(100) DEFAULT NULL,
  `call_to_action_button_1_link` varchar(500) DEFAULT NULL,
  `call_to_action_button_2_text` varchar(100) DEFAULT NULL,
  `call_to_action_button_2_link` varchar(500) DEFAULT NULL,
  `content_carousel_image` varchar(500) NOT NULL,
  `order_sequence` int(11) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `content_carousel_item`
--
DROP TRIGGER IF EXISTS `content_carousel_item_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `content_carousel_item_trigger_insert` AFTER INSERT ON `content_carousel_item` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Content carousel item created. <br/>';

    IF NEW.content_carousel_title <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Content Carousel Title: ", NEW.content_carousel_title);
    END IF;

    IF NEW.content_carousel_heading <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Content Carousel Heading: ", NEW.content_carousel_heading);
    END IF;

    IF NEW.content_carousel_paragraph <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Content Carousel Paragraph: ", NEW.content_carousel_paragraph);
    END IF;

    IF NEW.call_to_action_button_1_text <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Call-to-Action Button 1 Text: ", NEW.call_to_action_button_1_text);
    END IF;

    IF NEW.call_to_action_button_1_link <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Call-to-Action Button 1 Link: ", NEW.call_to_action_button_1_link);
    END IF;

    IF NEW.call_to_action_button_2_text <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Call-to-Action Button 2 Text: ", NEW.call_to_action_button_2_text);
    END IF;

    IF NEW.call_to_action_button_2_link <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Call-to-Action Button 2 Link: ", NEW.call_to_action_button_2_link);
    END IF;

    IF NEW.order_sequence <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Order Sequence: ", NEW.order_sequence);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('content_carousel_item', NEW.content_carousel_item_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `content_carousel_item_trigger_update`;
DELIMITER $$
CREATE TRIGGER `content_carousel_item_trigger_update` AFTER UPDATE ON `content_carousel_item` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';
    
    IF NEW.content_carousel_title <> OLD.content_carousel_title THEN
        SET audit_log = CONCAT(audit_log, "Content Carousel Title: ", OLD.content_carousel_title, " -> ", NEW.content_carousel_title, "<br/>");
    END IF;
    
    IF NEW.content_carousel_heading <> OLD.content_carousel_heading THEN
        SET audit_log = CONCAT(audit_log, "Content Carousel Heading: ", OLD.content_carousel_heading, " -> ", NEW.content_carousel_heading, "<br/>");
    END IF;
    
    IF NEW.content_carousel_paragraph <> OLD.content_carousel_paragraph THEN
        SET audit_log = CONCAT(audit_log, "Content Carousel Paragraph: ", OLD.content_carousel_paragraph, " -> ", NEW.content_carousel_paragraph, "<br/>");
    END IF;
    
    IF NEW.call_to_action_button_1_text <> OLD.call_to_action_button_1_text THEN
        SET audit_log = CONCAT(audit_log, "Call-to-Action Button 1 Text: ", OLD.call_to_action_button_1_text, " -> ", NEW.call_to_action_button_1_text, "<br/>");
    END IF;

    IF NEW.call_to_action_button_1_link <> OLD.call_to_action_button_1_link THEN
        SET audit_log = CONCAT(audit_log, "Call-to-Action Button 1 Link: ", OLD.call_to_action_button_1_link, " -> ", NEW.call_to_action_button_1_link, "<br/>");
    END IF;
    
    IF NEW.call_to_action_button_2_text <> OLD.call_to_action_button_2_text THEN
        SET audit_log = CONCAT(audit_log, "Call-to-Action Button 2 Text: ", OLD.call_to_action_button_2_text, " -> ", NEW.call_to_action_button_2_text, "<br/>");
    END IF;

    IF NEW.call_to_action_button_2_link <> OLD.call_to_action_button_2_link THEN
        SET audit_log = CONCAT(audit_log, "Call-to-Action Button 2 Link: ", OLD.call_to_action_button_2_link, " -> ", NEW.call_to_action_button_2_link, "<br/>");
    END IF;
    
    IF NEW.order_sequence <> OLD.order_sequence THEN
        SET audit_log = CONCAT(audit_log, "Order Sequence: ", OLD.order_sequence, " -> ", NEW.order_sequence, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('content_carousel_item', NEW.content_carousel_item_id, audit_log, NEW.last_log_by, NOW());
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
(1, 'Afghanistan', '2024-09-04 16:41:42', 1),
(2, 'Aland Islands', '2024-09-04 16:41:42', 1),
(3, 'Albania', '2024-09-04 16:41:42', 1),
(4, 'Algeria', '2024-09-04 16:41:42', 1),
(5, 'American Samoa', '2024-09-04 16:41:42', 1),
(6, 'Andorra', '2024-09-04 16:41:42', 1),
(7, 'Angola', '2024-09-04 16:41:42', 1),
(8, 'Anguilla', '2024-09-04 16:41:42', 1),
(9, 'Antarctica', '2024-09-04 16:41:42', 1),
(10, 'Antigua and Barbuda', '2024-09-04 16:41:42', 1),
(11, 'Argentina', '2024-09-04 16:41:42', 1),
(12, 'Armenia', '2024-09-04 16:41:42', 1),
(13, 'Aruba', '2024-09-04 16:41:42', 1),
(14, 'Australia', '2024-09-04 16:41:42', 1),
(15, 'Austria', '2024-09-04 16:41:42', 1),
(16, 'Azerbaijan', '2024-09-04 16:41:42', 1),
(17, 'The Bahamas', '2024-09-04 16:41:42', 1),
(18, 'Bahrain', '2024-09-04 16:41:42', 1),
(19, 'Bangladesh', '2024-09-04 16:41:42', 1),
(20, 'Barbados', '2024-09-04 16:41:42', 1),
(21, 'Belarus', '2024-09-04 16:41:42', 1),
(22, 'Belgium', '2024-09-04 16:41:42', 1),
(23, 'Belize', '2024-09-04 16:41:42', 1),
(24, 'Benin', '2024-09-04 16:41:42', 1),
(25, 'Bermuda', '2024-09-04 16:41:42', 1),
(26, 'Bhutan', '2024-09-04 16:41:42', 1),
(27, 'Bolivia', '2024-09-04 16:41:42', 1),
(28, 'Bosnia and Herzegovina', '2024-09-04 16:41:42', 1),
(29, 'Botswana', '2024-09-04 16:41:42', 1),
(30, 'Bouvet Island', '2024-09-04 16:41:42', 1),
(31, 'Brazil', '2024-09-04 16:41:42', 1),
(32, 'British Indian Ocean Territory', '2024-09-04 16:41:42', 1),
(33, 'Brunei', '2024-09-04 16:41:42', 1),
(34, 'Bulgaria', '2024-09-04 16:41:42', 1),
(35, 'Burkina Faso', '2024-09-04 16:41:42', 1),
(36, 'Burundi', '2024-09-04 16:41:42', 1),
(37, 'Cambodia', '2024-09-04 16:41:42', 1),
(38, 'Cameroon', '2024-09-04 16:41:42', 1),
(39, 'Canada', '2024-09-04 16:41:42', 1),
(40, 'Cape Verde', '2024-09-04 16:41:42', 1),
(41, 'Cayman Islands', '2024-09-04 16:41:42', 1),
(42, 'Central African Republic', '2024-09-04 16:41:42', 1),
(43, 'Chad', '2024-09-04 16:41:42', 1),
(44, 'Chile', '2024-09-04 16:41:42', 1),
(45, 'China', '2024-09-04 16:41:42', 1),
(46, 'Christmas Island', '2024-09-04 16:41:42', 1),
(47, 'Cocos (Keeling) Islands', '2024-09-04 16:41:42', 1),
(48, 'Colombia', '2024-09-04 16:41:42', 1),
(49, 'Comoros', '2024-09-04 16:41:42', 1),
(50, 'Congo', '2024-09-04 16:41:42', 1),
(51, 'Democratic Republic of the Congo', '2024-09-04 16:41:42', 1),
(52, 'Cook Islands', '2024-09-04 16:41:42', 1),
(53, 'Costa Rica', '2024-09-04 16:41:42', 1),
(54, 'Cote D Ivoire (Ivory Coast)', '2024-09-04 16:41:42', 1),
(55, 'Croatia', '2024-09-04 16:41:42', 1),
(56, 'Cuba', '2024-09-04 16:41:42', 1),
(57, 'Cyprus', '2024-09-04 16:41:42', 1),
(58, 'Czech Republic', '2024-09-04 16:41:42', 1),
(59, 'Denmark', '2024-09-04 16:41:42', 1),
(60, 'Djibouti', '2024-09-04 16:41:42', 1),
(61, 'Dominica', '2024-09-04 16:41:42', 1),
(62, 'Dominican Republic', '2024-09-04 16:41:42', 1),
(63, 'Timor-Leste', '2024-09-04 16:41:42', 1),
(64, 'Ecuador', '2024-09-04 16:41:42', 1),
(65, 'Egypt', '2024-09-04 16:41:42', 1),
(66, 'El Salvador', '2024-09-04 16:41:42', 1),
(67, 'Equatorial Guinea', '2024-09-04 16:41:42', 1),
(68, 'Eritrea', '2024-09-04 16:41:42', 1),
(69, 'Estonia', '2024-09-04 16:41:42', 1),
(70, 'Ethiopia', '2024-09-04 16:41:42', 1),
(71, 'Falkland Islands', '2024-09-04 16:41:42', 1),
(72, 'Faroe Islands', '2024-09-04 16:41:42', 1),
(73, 'Fiji Islands', '2024-09-04 16:41:42', 1),
(74, 'Finland', '2024-09-04 16:41:42', 1),
(75, 'France', '2024-09-04 16:41:42', 1),
(76, 'French Guiana', '2024-09-04 16:41:42', 1),
(77, 'French Polynesia', '2024-09-04 16:41:42', 1),
(78, 'French Southern Territories', '2024-09-04 16:41:42', 1),
(79, 'Gabon', '2024-09-04 16:41:42', 1),
(80, 'Gambia The', '2024-09-04 16:41:42', 1),
(81, 'Georgia', '2024-09-04 16:41:42', 1),
(82, 'Germany', '2024-09-04 16:41:42', 1),
(83, 'Ghana', '2024-09-04 16:41:42', 1),
(84, 'Gibraltar', '2024-09-04 16:41:42', 1),
(85, 'Greece', '2024-09-04 16:41:42', 1),
(86, 'Greenland', '2024-09-04 16:41:42', 1),
(87, 'Grenada', '2024-09-04 16:41:42', 1),
(88, 'Guadeloupe', '2024-09-04 16:41:42', 1),
(89, 'Guam', '2024-09-04 16:41:42', 1),
(90, 'Guatemala', '2024-09-04 16:41:42', 1),
(91, 'Guernsey and Alderney', '2024-09-04 16:41:42', 1),
(92, 'Guinea', '2024-09-04 16:41:42', 1),
(93, 'Guinea-Bissau', '2024-09-04 16:41:42', 1),
(94, 'Guyana', '2024-09-04 16:41:42', 1),
(95, 'Haiti', '2024-09-04 16:41:42', 1),
(96, 'Heard Island and McDonald Islands', '2024-09-04 16:41:42', 1),
(97, 'Honduras', '2024-09-04 16:41:42', 1),
(98, 'Hong Kong S.A.R.', '2024-09-04 16:41:42', 1),
(99, 'Hungary', '2024-09-04 16:41:42', 1),
(100, 'Iceland', '2024-09-04 16:41:42', 1),
(101, 'India', '2024-09-04 16:41:42', 1),
(102, 'Indonesia', '2024-09-04 16:41:42', 1),
(103, 'Iran', '2024-09-04 16:41:42', 1),
(104, 'Iraq', '2024-09-04 16:41:42', 1),
(105, 'Ireland', '2024-09-04 16:41:42', 1),
(106, 'Israel', '2024-09-04 16:41:42', 1),
(107, 'Italy', '2024-09-04 16:41:42', 1),
(108, 'Jamaica', '2024-09-04 16:41:42', 1),
(109, 'Japan', '2024-09-04 16:41:42', 1),
(110, 'Jersey', '2024-09-04 16:41:42', 1),
(111, 'Jordan', '2024-09-04 16:41:42', 1),
(112, 'Kazakhstan', '2024-09-04 16:41:42', 1),
(113, 'Kenya', '2024-09-04 16:41:42', 1),
(114, 'Kiribati', '2024-09-04 16:41:42', 1),
(115, 'North Korea', '2024-09-04 16:41:42', 1),
(116, 'South Korea', '2024-09-04 16:41:42', 1),
(117, 'Kuwait', '2024-09-04 16:41:42', 1),
(118, 'Kyrgyzstan', '2024-09-04 16:41:42', 1),
(119, 'Laos', '2024-09-04 16:41:42', 1),
(120, 'Latvia', '2024-09-04 16:41:42', 1),
(121, 'Lebanon', '2024-09-04 16:41:42', 1),
(122, 'Lesotho', '2024-09-04 16:41:42', 1),
(123, 'Liberia', '2024-09-04 16:41:42', 1),
(124, 'Libya', '2024-09-04 16:41:42', 1),
(125, 'Liechtenstein', '2024-09-04 16:41:42', 1),
(126, 'Lithuania', '2024-09-04 16:41:42', 1),
(127, 'Luxembourg', '2024-09-04 16:41:42', 1),
(128, 'Macau S.A.R.', '2024-09-04 16:41:42', 1),
(129, 'North Macedonia', '2024-09-04 16:41:42', 1),
(130, 'Madagascar', '2024-09-04 16:41:42', 1),
(131, 'Malawi', '2024-09-04 16:41:42', 1),
(132, 'Malaysia', '2024-09-04 16:41:42', 1),
(133, 'Maldives', '2024-09-04 16:41:42', 1),
(134, 'Mali', '2024-09-04 16:41:42', 1),
(135, 'Malta', '2024-09-04 16:41:42', 1),
(136, 'Man (Isle of)', '2024-09-04 16:41:42', 1),
(137, 'Marshall Islands', '2024-09-04 16:41:42', 1),
(138, 'Martinique', '2024-09-04 16:41:42', 1),
(139, 'Mauritania', '2024-09-04 16:41:42', 1),
(140, 'Mauritius', '2024-09-04 16:41:42', 1),
(141, 'Mayotte', '2024-09-04 16:41:42', 1),
(142, 'Mexico', '2024-09-04 16:41:42', 1),
(143, 'Micronesia', '2024-09-04 16:41:42', 1),
(144, 'Moldova', '2024-09-04 16:41:42', 1),
(145, 'Monaco', '2024-09-04 16:41:42', 1),
(146, 'Mongolia', '2024-09-04 16:41:42', 1),
(147, 'Montenegro', '2024-09-04 16:41:42', 1),
(148, 'Montserrat', '2024-09-04 16:41:42', 1),
(149, 'Morocco', '2024-09-04 16:41:42', 1),
(150, 'Mozambique', '2024-09-04 16:41:42', 1),
(151, 'Myanmar', '2024-09-04 16:41:42', 1),
(152, 'Namibia', '2024-09-04 16:41:42', 1),
(153, 'Nauru', '2024-09-04 16:41:42', 1),
(154, 'Nepal', '2024-09-04 16:41:42', 1),
(155, 'Bonaire, Sint Eustatius and Saba', '2024-09-04 16:41:42', 1),
(156, 'Netherlands', '2024-09-04 16:41:42', 1),
(157, 'New Caledonia', '2024-09-04 16:41:42', 1),
(158, 'New Zealand', '2024-09-04 16:41:42', 1),
(159, 'Nicaragua', '2024-09-04 16:41:42', 1),
(160, 'Niger', '2024-09-04 16:41:42', 1),
(161, 'Nigeria', '2024-09-04 16:41:42', 1),
(162, 'Niue', '2024-09-04 16:41:42', 1),
(163, 'Norfolk Island', '2024-09-04 16:41:42', 1),
(164, 'Northern Mariana Islands', '2024-09-04 16:41:42', 1),
(165, 'Norway', '2024-09-04 16:41:42', 1),
(166, 'Oman', '2024-09-04 16:41:42', 1),
(167, 'Pakistan', '2024-09-04 16:41:42', 1),
(168, 'Palau', '2024-09-04 16:41:42', 1),
(169, 'Palestinian Territory Occupied', '2024-09-04 16:41:42', 1),
(170, 'Panama', '2024-09-04 16:41:42', 1),
(171, 'Papua New Guinea', '2024-09-04 16:41:42', 1),
(172, 'Paraguay', '2024-09-04 16:41:42', 1),
(173, 'Peru', '2024-09-04 16:41:42', 1),
(174, 'Philippines', '2024-09-04 16:41:42', 1),
(175, 'Pitcairn Island', '2024-09-04 16:41:42', 1),
(176, 'Poland', '2024-09-04 16:41:42', 1),
(177, 'Portugal', '2024-09-04 16:41:42', 1),
(178, 'Puerto Rico', '2024-09-04 16:41:42', 1),
(179, 'Qatar', '2024-09-04 16:41:42', 1),
(180, 'Reunion', '2024-09-04 16:41:42', 1),
(181, 'Romania', '2024-09-04 16:41:42', 1),
(182, 'Russia', '2024-09-04 16:41:42', 1),
(183, 'Rwanda', '2024-09-04 16:41:42', 1),
(184, 'Saint Helena', '2024-09-04 16:41:42', 1),
(185, 'Saint Kitts and Nevis', '2024-09-04 16:41:42', 1),
(186, 'Saint Lucia', '2024-09-04 16:41:42', 1),
(187, 'Saint Pierre and Miquelon', '2024-09-04 16:41:42', 1),
(188, 'Saint Vincent and the Grenadines', '2024-09-04 16:41:42', 1),
(189, 'Saint-Barthelemy', '2024-09-04 16:41:42', 1),
(190, 'Saint-Martin (French part)', '2024-09-04 16:41:42', 1),
(191, 'Samoa', '2024-09-04 16:41:42', 1),
(192, 'San Marino', '2024-09-04 16:41:42', 1),
(193, 'Sao Tome and Principe', '2024-09-04 16:41:42', 1),
(194, 'Saudi Arabia', '2024-09-04 16:41:42', 1),
(195, 'Senegal', '2024-09-04 16:41:42', 1),
(196, 'Serbia', '2024-09-04 16:41:42', 1),
(197, 'Seychelles', '2024-09-04 16:41:42', 1),
(198, 'Sierra Leone', '2024-09-04 16:41:42', 1),
(199, 'Singapore', '2024-09-04 16:41:42', 1),
(200, 'Slovakia', '2024-09-04 16:41:42', 1),
(201, 'Slovenia', '2024-09-04 16:41:42', 1),
(202, 'Solomon Islands', '2024-09-04 16:41:42', 1),
(203, 'Somalia', '2024-09-04 16:41:42', 1),
(204, 'South Africa', '2024-09-04 16:41:42', 1),
(205, 'South Georgia', '2024-09-04 16:41:42', 1),
(206, 'South Sudan', '2024-09-04 16:41:42', 1),
(207, 'Spain', '2024-09-04 16:41:42', 1),
(208, 'Sri Lanka', '2024-09-04 16:41:42', 1),
(209, 'Sudan', '2024-09-04 16:41:42', 1),
(210, 'Suriname', '2024-09-04 16:41:42', 1),
(211, 'Svalbard and Jan Mayen Islands', '2024-09-04 16:41:42', 1),
(212, 'Eswatini', '2024-09-04 16:41:42', 1),
(213, 'Sweden', '2024-09-04 16:41:42', 1),
(214, 'Switzerland', '2024-09-04 16:41:42', 1),
(215, 'Syria', '2024-09-04 16:41:42', 1),
(216, 'Taiwan', '2024-09-04 16:41:42', 1),
(217, 'Tajikistan', '2024-09-04 16:41:42', 1),
(218, 'Tanzania', '2024-09-04 16:41:42', 1),
(219, 'Thailand', '2024-09-04 16:41:42', 1),
(220, 'Togo', '2024-09-04 16:41:42', 1),
(221, 'Tokelau', '2024-09-04 16:41:42', 1),
(222, 'Tonga', '2024-09-04 16:41:42', 1),
(223, 'Trinidad and Tobago', '2024-09-04 16:41:42', 1),
(224, 'Tunisia', '2024-09-04 16:41:42', 1),
(225, 'Turkey', '2024-09-04 16:41:42', 1),
(226, 'Turkmenistan', '2024-09-04 16:41:42', 1),
(227, 'Turks and Caicos Islands', '2024-09-04 16:41:42', 1),
(228, 'Tuvalu', '2024-09-04 16:41:42', 1),
(229, 'Uganda', '2024-09-04 16:41:42', 1),
(230, 'Ukraine', '2024-09-04 16:41:42', 1),
(231, 'United Arab Emirates', '2024-09-04 16:41:42', 1),
(232, 'United Kingdom', '2024-09-04 16:41:42', 1),
(233, 'United States', '2024-09-04 16:41:42', 1),
(234, 'United States Minor Outlying Islands', '2024-09-04 16:41:42', 1),
(235, 'Uruguay', '2024-09-04 16:41:42', 1),
(236, 'Uzbekistan', '2024-09-04 16:41:42', 1),
(237, 'Vanuatu', '2024-09-04 16:41:42', 1),
(238, 'Vatican City State (Holy See)', '2024-09-04 16:41:42', 1),
(239, 'Venezuela', '2024-09-04 16:41:42', 1),
(240, 'Vietnam', '2024-09-04 16:41:42', 1),
(241, 'Virgin Islands (British)', '2024-09-04 16:41:42', 1),
(242, 'Virgin Islands (US)', '2024-09-04 16:41:42', 1),
(243, 'Wallis and Futuna Islands', '2024-09-04 16:41:42', 1),
(244, 'Western Sahara', '2024-09-04 16:41:42', 1),
(245, 'Yemen', '2024-09-04 16:41:42', 1),
(246, 'Zambia', '2024-09-04 16:41:42', 1),
(247, 'Zimbabwe', '2024-09-04 16:41:42', 1),
(248, 'Kosovo', '2024-09-04 16:41:42', 1),
(249, 'CuraÃ§ao', '2024-09-04 16:41:42', 1),
(250, 'Sint Maarten (Dutch part)', '2024-09-04 16:41:42', 1);

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
  `currency_code` varchar(10) NOT NULL,
  `currency_symbol` varchar(10) NOT NULL,
  `exchange_rate` double NOT NULL DEFAULT 0,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `currency`
--

INSERT INTO `currency` (`currency_id`, `currency_name`, `currency_code`, `currency_symbol`, `exchange_rate`, `created_date`, `last_log_by`) VALUES
(1, 'United States Dollar', 'USD', '$', 0, '2024-07-09 10:31:21', 1),
(2, 'Euro', 'EUR', '€', 0, '2024-07-09 10:31:21', 1),
(3, 'British Pound', 'GBP', '£', 0, '2024-07-09 10:31:21', 1),
(4, 'Japanese Yen', 'JPY', '¥', 0, '2024-07-09 10:31:21', 1),
(5, 'Australian Dollar', 'AUD', '$', 0, '2024-07-09 10:31:21', 1),
(6, 'Canadian Dollar', 'CAD', '$', 0, '2024-07-09 10:31:21', 1),
(7, 'Swiss Franc', 'CHF', 'CHF', 0, '2024-07-09 10:31:21', 1),
(8, 'Chinese Yuan', 'CNY', '¥', 0, '2024-07-09 10:31:21', 1),
(9, 'Indian Rupee', 'INR', '₹', 0, '2024-07-09 10:31:21', 1),
(10, 'Mexican Peso', 'MXN', '$', 0, '2024-07-09 10:31:21', 1),
(11, 'Brazilian Real', 'BRL', 'R$', 0, '2024-07-09 10:31:21', 1),
(12, 'South African Rand', 'ZAR', 'R', 0, '2024-07-09 10:31:21', 1),
(13, 'Russian Ruble', 'RUB', '₽', 0, '2024-07-09 10:31:21', 1),
(14, 'South Korean Won', 'KRW', '₩', 0, '2024-07-09 10:31:21', 1),
(15, 'Turkish Lira', 'TRY', '₺', 0, '2024-07-09 10:31:21', 1),
(16, 'Singapore Dollar', 'SGD', '$', 0, '2024-07-09 10:31:21', 1),
(17, 'Malaysian Ringgit', 'MYR', 'RM', 0, '2024-07-09 10:31:21', 1),
(18, 'Hong Kong Dollar', 'HKD', '$', 0, '2024-07-09 10:31:21', 1),
(19, 'New Zealand Dollar', 'NZD', '$', 0, '2024-07-09 10:31:21', 1),
(20, 'Norwegian Krone', 'NOK', 'kr', 0, '2024-07-09 10:31:21', 1),
(21, 'Swedish Krona', 'SEK', 'kr', 0, '2024-07-09 10:31:21', 1),
(22, 'Danish Krone', 'DKK', 'kr', 0, '2024-07-09 10:31:21', 1),
(23, 'Polish Zloty', 'PLN', 'zł', 0, '2024-07-09 10:31:21', 1),
(24, 'Thai Baht', 'THB', '฿', 0, '2024-07-09 10:31:21', 1),
(25, 'Indonesian Rupiah', 'IDR', 'Rp', 0, '2024-07-09 10:31:21', 1),
(26, 'Philippine Peso', 'PHP', '₱', 0, '2024-07-09 10:31:21', 1),
(27, 'Czech Koruna', 'CZK', 'Kč', 0, '2024-07-09 10:31:21', 1),
(28, 'Hungarian Forint', 'HUF', 'ft', 0, '2024-07-09 10:31:21', 1),
(29, 'Israeli Shekel', 'ILS', '₪', 0, '2024-07-09 10:31:21', 1),
(30, 'Chilean Peso', 'CLP', '$', 0, '2024-07-09 10:31:21', 1),
(31, 'Pakistani Rupee', 'PKR', '₨', 0, '2024-07-09 10:31:21', 1),
(32, 'Saudi Riyal', 'SAR', '﷼', 0, '2024-07-09 10:31:21', 1),
(33, 'United Arab Emirates Dirham', 'AED', 'د.إ', 0, '2024-07-09 10:31:21', 1),
(34, 'Egyptian Pound', 'EGP', '£', 0, '2024-07-09 10:31:21', 1),
(35, 'Vietnamese Dong', 'VND', '₫', 0, '2024-07-09 10:31:21', 1),
(36, 'Bangladeshi Taka', 'BDT', '৳', 0, '2024-07-09 10:31:21', 1),
(37, 'Argentine Peso', 'ARS', '$', 0, '2024-07-09 10:31:21', 1),
(38, 'Colombian Peso', 'COP', '$', 0, '2024-07-09 10:31:21', 1),
(39, 'Peruvian Sol', 'PEN', 'S/', 0, '2024-07-09 10:31:21', 1),
(40, 'Qatari Riyal', 'QAR', '﷼', 0, '2024-07-09 10:31:21', 1),
(41, 'Kuwaiti Dinar', 'KWD', 'د.ك', 0, '2024-07-09 10:31:21', 1),
(42, 'Bahraini Dinar', 'BHD', '.د.ب', 0, '2024-07-09 10:31:21', 1),
(43, 'Omani Rial', 'OMR', '﷼', 0, '2024-07-09 10:31:21', 1),
(44, 'Jordanian Dinar', 'JOD', 'د.أ', 0, '2024-07-09 10:31:21', 1),
(45, 'Moroccan Dirham', 'MAD', 'د.م', 0, '2024-07-09 10:31:21', 1),
(46, 'Nigerian Naira', 'NGN', '₦', 0, '2024-07-09 10:31:21', 1),
(47, 'Ghanaian Cedi', 'GHS', '₵', 0, '2024-07-09 10:31:21', 1),
(48, 'Ethiopian Birr', 'ETB', 'Br', 0, '2024-07-09 10:31:21', 1),
(49, 'Tanzanian Shilling', 'TZS', 'Sh', 0, '2024-07-09 10:31:21', 1),
(50, 'Kenyan Shilling', 'KES', 'Sh', 0, '2024-07-09 10:31:21', 1),
(51, 'Ugandan Shilling', 'UGX', 'Sh', 0, '2024-07-09 10:31:21', 1),
(52, 'Sri Lankan Rupee', 'LKR', 'Rs', 0, '2024-07-09 10:31:21', 1),
(53, 'Myanmar Kyat', 'MMK', 'K', 0, '2024-07-09 10:31:21', 1),
(54, 'Mauritian Rupee', 'MUR', '₨', 0, '2024-07-09 10:31:21', 1),
(55, 'Trinidad and Tobago Dollar', 'TTD', '$', 0, '2024-07-09 10:31:21', 1),
(56, 'Barbadian Dollar', 'BBD', '$', 0, '2024-07-09 10:31:21', 1),
(57, 'Fijian Dollar', 'FJD', '$', 0, '2024-07-09 10:31:21', 1);

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

    IF NEW.currency_code <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Currency Code: ", NEW.currency_code);
    END IF;

    IF NEW.currency_symbol <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Currency Symbol: ", NEW.currency_symbol);
    END IF;

    IF NEW.exchange_rate <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Exchange Rate: ", NEW.exchange_rate);
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

    IF NEW.currency_code <> OLD.currency_code THEN
        SET audit_log = CONCAT(audit_log, "Currency Code: ", OLD.currency_code, " -> ", NEW.currency_code, "<br/>");
    END IF;

    IF NEW.currency_symbol <> OLD.currency_symbol THEN
        SET audit_log = CONCAT(audit_log, "Currency Symbol: ", OLD.currency_symbol, " -> ", NEW.currency_symbol, "<br/>");
    END IF;

    IF NEW.exchange_rate <> OLD.exchange_rate THEN
        SET audit_log = CONCAT(audit_log, "Exchange Rate: ", OLD.exchange_rate, " -> ", NEW.exchange_rate, "<br/>");
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
-- Table structure for table `customer`
--

DROP TABLE IF EXISTS `customer`;
CREATE TABLE `customer` (
  `customer_id` int(10) UNSIGNED NOT NULL,
  `customer_image` varchar(500) DEFAULT NULL,
  `customer_digital_signature` varchar(500) DEFAULT NULL,
  `full_name` varchar(1000) NOT NULL,
  `first_name` varchar(300) NOT NULL,
  `middle_name` varchar(300) DEFAULT NULL,
  `last_name` varchar(300) NOT NULL,
  `suffix` varchar(10) DEFAULT NULL,
  `about` varchar(500) DEFAULT 'No about found.',
  `nickname` varchar(100) DEFAULT NULL,
  `civil_status_id` int(10) UNSIGNED DEFAULT NULL,
  `civil_status_name` varchar(100) DEFAULT NULL,
  `gender_id` int(10) UNSIGNED DEFAULT NULL,
  `gender_name` varchar(100) DEFAULT NULL,
  `birthday` date DEFAULT NULL,
  `birth_place` varchar(1000) DEFAULT NULL,
  `customer_status` varchar(50) NOT NULL DEFAULT 'Active',
  `archive_date` date DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer`
--

INSERT INTO `customer` (`customer_id`, `customer_image`, `customer_digital_signature`, `full_name`, `first_name`, `middle_name`, `last_name`, `suffix`, `about`, `nickname`, `civil_status_id`, `civil_status_name`, `gender_id`, `gender_name`, `birthday`, `birth_place`, `customer_status`, `archive_date`, `created_date`, `last_log_by`) VALUES
(1, './components/customer/image/1/profile/V3Xn.png', NULL, 'Lawrence Agulto', 'Lawrence', '', 'Agulto', '', 'No about found.', 'nickname', 2, 'Engaged', 1, 'Male', '2024-08-20', 'test', 'Active', '2024-08-20', '2024-08-20 13:36:10', 2),
(9, NULL, NULL, 'lawrence agulto', 'lawrence', '', 'agulto', '', 'No about found.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', NULL, '2024-08-21 10:18:07', 1),
(10, NULL, NULL, 'maricris agulto', 'maricris', '', 'agulto', '', 'No about found.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', NULL, '2024-08-21 14:34:24', 1),
(11, NULL, NULL, 'Asd Asd', 'Asd', '', 'Asd', '', 'No about found.', NULL, NULL, NULL, NULL, NULL, NULL, NULL, 'Active', NULL, '2024-08-22 10:49:09', 1);

--
-- Triggers `customer`
--
DROP TRIGGER IF EXISTS `customer_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `customer_trigger_insert` AFTER INSERT ON `customer` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Customer created. <br/>';

    IF NEW.full_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Full Name: ", NEW.full_name);
    END IF;

    IF NEW.first_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>First Name: ", NEW.first_name);
    END IF;

    IF NEW.middle_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Middle Name: ", NEW.middle_name);
    END IF;

    IF NEW.last_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Last Name: ", NEW.last_name);
    END IF;

    IF NEW.suffix <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Suffix: ", NEW.suffix);
    END IF;

    IF NEW.about <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>About: ", NEW.about);
    END IF;

    IF NEW.nickname <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Nickname: ", NEW.nickname);
    END IF;

    IF NEW.civil_status_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Civil Status Name: ", NEW.civil_status_name);
    END IF;

    IF NEW.gender_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Gender Name: ", NEW.gender_name);
    END IF;

    IF NEW.birthday <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Date of Birth: ", NEW.birthday);
    END IF;

    IF NEW.birth_place <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Birth Place: ", NEW.birth_place);
    END IF;

    IF NEW.customer_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Customer Status: ", NEW.customer_status);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('customer', NEW.customer_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `customer_trigger_update`;
DELIMITER $$
CREATE TRIGGER `customer_trigger_update` AFTER UPDATE ON `customer` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.full_name <> OLD.full_name THEN
        SET audit_log = CONCAT(audit_log, "Full Name: ", OLD.full_name, " -> ", NEW.full_name, "<br/>");
    END IF;

    IF NEW.first_name <> OLD.first_name THEN
        SET audit_log = CONCAT(audit_log, "First Name: ", OLD.first_name, " -> ", NEW.first_name, "<br/>");
    END IF;

    IF NEW.middle_name <> OLD.middle_name THEN
        SET audit_log = CONCAT(audit_log, "Middle Name: ", OLD.middle_name, " -> ", NEW.middle_name, "<br/>");
    END IF;

    IF NEW.last_name <> OLD.last_name THEN
        SET audit_log = CONCAT(audit_log, "Last Name: ", OLD.last_name, " -> ", NEW.last_name, "<br/>");
    END IF;

    IF NEW.suffix <> OLD.suffix THEN
        SET audit_log = CONCAT(audit_log, "Suffix: ", OLD.suffix, " -> ", NEW.suffix, "<br/>");
    END IF;

    IF NEW.about <> OLD.about THEN
        SET audit_log = CONCAT(audit_log, "About: ", OLD.about, " -> ", NEW.about, "<br/>");
    END IF;

    IF NEW.nickname <> OLD.nickname THEN
        SET audit_log = CONCAT(audit_log, "Nickname: ", OLD.nickname, " -> ", NEW.nickname, "<br/>");
    END IF;

    IF NEW.civil_status_name <> OLD.civil_status_name THEN
        SET audit_log = CONCAT(audit_log, "Civil Status Name: ", OLD.civil_status_name, " -> ", NEW.civil_status_name, "<br/>");
    END IF;

    IF NEW.gender_name <> OLD.gender_name THEN
        SET audit_log = CONCAT(audit_log, "Gender Name: ", OLD.gender_name, " -> ", NEW.gender_name, "<br/>");
    END IF;

    IF NEW.birthday <> OLD.birthday THEN
        SET audit_log = CONCAT(audit_log, "Date of Birth: ", OLD.birthday, " -> ", NEW.birthday, "<br/>");
    END IF;

    IF NEW.birth_place <> OLD.birth_place THEN
        SET audit_log = CONCAT(audit_log, "Birth Place: ", OLD.birth_place, " -> ", NEW.birth_place, "<br/>");
    END IF;

    IF NEW.customer_status <> OLD.customer_status THEN
        SET audit_log = CONCAT(audit_log, "Customer Status: ", OLD.customer_status, " -> ", NEW.customer_status, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('customer', NEW.customer_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customer_address`
--

DROP TABLE IF EXISTS `customer_address`;
CREATE TABLE `customer_address` (
  `customer_address_id` int(10) UNSIGNED NOT NULL,
  `customer_id` int(10) UNSIGNED NOT NULL,
  `address_type_id` int(10) UNSIGNED NOT NULL,
  `address_type_name` varchar(100) NOT NULL,
  `address` varchar(1000) DEFAULT NULL,
  `city_id` int(10) UNSIGNED NOT NULL,
  `city_name` varchar(100) NOT NULL,
  `state_id` int(10) UNSIGNED NOT NULL,
  `state_name` varchar(100) NOT NULL,
  `country_id` int(10) UNSIGNED NOT NULL,
  `country_name` varchar(100) NOT NULL,
  `telephone` varchar(50) DEFAULT NULL,
  `mobile` varchar(50) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `default_address` varchar(10) NOT NULL DEFAULT 'Primary',
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer_address`
--

INSERT INTO `customer_address` (`customer_address_id`, `customer_id`, `address_type_id`, `address_type_name`, `address`, `city_id`, `city_name`, `state_id`, `state_name`, `country_id`, `country_name`, `telephone`, `mobile`, `email`, `default_address`, `created_date`, `last_log_by`) VALUES
(1, 1, 2, 'Billing Address', 'asdasd', 523, 'Aborlan', 26, 'Palawan', 174, 'Philippines', '', '123123123', '', 'Alternate', '2024-08-20 16:42:42', 2),
(2, 1, 2, 'Billing Address', 'asdas', 497, 'Abra De Ilog', 24, 'Occidental Mindoro', 174, 'Philippines', '123123123', '123123123', '123123@gmail.com', 'Primary', '2024-08-22 16:57:36', 2);

--
-- Triggers `customer_address`
--
DROP TRIGGER IF EXISTS `customer_address_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `customer_address_trigger_insert` AFTER INSERT ON `customer_address` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Customer address created. <br/>';

    IF NEW.address_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Address Type Name: ", NEW.address_type_name);
    END IF;

    IF NEW.address <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Address: ", NEW.address);
    END IF;

    IF NEW.city_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>City Name: ", NEW.city_name);
    END IF;

    IF NEW.state_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>State Name: ", NEW.state_name);
    END IF;

    IF NEW.country_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Country Name: ", NEW.country_name);
    END IF;

    IF NEW.telephone <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Telephone: ", NEW.telephone);
    END IF;

    IF NEW.mobile <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Mobile: ", NEW.mobile);
    END IF;

    IF NEW.email <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Email: ", NEW.email);
    END IF;

    IF NEW.default_address <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Default Address: ", NEW.default_address);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('customer_address', NEW.customer_address_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `customer_address_trigger_update`;
DELIMITER $$
CREATE TRIGGER `customer_address_trigger_update` AFTER UPDATE ON `customer_address` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.address_type_name <> OLD.address_type_name THEN
        SET audit_log = CONCAT(audit_log, "Address Type Name: ", OLD.address_type_name, " -> ", NEW.address_type_name, "<br/>");
    END IF;

    IF NEW.address <> OLD.address THEN
        SET audit_log = CONCAT(audit_log, "Address: ", OLD.address, " -> ", NEW.address, "<br/>");
    END IF;

    IF NEW.city_name <> OLD.city_name THEN
        SET audit_log = CONCAT(audit_log, "City Name: ", OLD.city_name, " -> ", NEW.city_name, "<br/>");
    END IF;

    IF NEW.state_name <> OLD.state_name THEN
        SET audit_log = CONCAT(audit_log, "State Name: ", OLD.state_name, " -> ", NEW.state_name, "<br/>");
    END IF;

    IF NEW.country_name <> OLD.country_name THEN
        SET audit_log = CONCAT(audit_log, "Country Name: ", OLD.country_name, " -> ", NEW.country_name, "<br/>");
    END IF;

    IF NEW.telephone <> OLD.telephone THEN
        SET audit_log = CONCAT(audit_log, "Telephone: ", OLD.telephone, " -> ", NEW.telephone, "<br/>");
    END IF;

    IF NEW.mobile <> OLD.mobile THEN
        SET audit_log = CONCAT(audit_log, "Mobile: ", OLD.mobile, " -> ", NEW.mobile, "<br/>");
    END IF;

    IF NEW.email <> OLD.email THEN
        SET audit_log = CONCAT(audit_log, "Email: ", OLD.email, " -> ", NEW.email, "<br/>");
    END IF;

    IF NEW.default_address <> OLD.default_address THEN
        SET audit_log = CONCAT(audit_log, "Default Address: ", OLD.default_address, " -> ", NEW.default_address, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('customer_address', NEW.customer_address_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customer_bank_account`
--

DROP TABLE IF EXISTS `customer_bank_account`;
CREATE TABLE `customer_bank_account` (
  `customer_bank_account_id` int(10) UNSIGNED NOT NULL,
  `customer_id` int(10) UNSIGNED NOT NULL,
  `bank_id` int(10) UNSIGNED NOT NULL,
  `bank_name` varchar(100) NOT NULL,
  `bank_account_type_id` int(10) UNSIGNED NOT NULL,
  `bank_account_type_name` varchar(100) NOT NULL,
  `account_number` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer_bank_account`
--

INSERT INTO `customer_bank_account` (`customer_bank_account_id`, `customer_id`, `bank_id`, `bank_name`, `bank_account_type_id`, `bank_account_type_name`, `account_number`, `created_date`, `last_log_by`) VALUES
(3, 1, 1, 'Banco de Oro (BDO)', 1, 'Checking Account', '123123123123', '2024-08-22 20:06:34', 2),
(4, 1, 1, 'Banco de Oro (BDO)', 1, 'Checking Account', '12312312542643', '2024-08-22 20:21:03', 2);

--
-- Triggers `customer_bank_account`
--
DROP TRIGGER IF EXISTS `customer_bank_account_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `customer_bank_account_trigger_insert` AFTER INSERT ON `customer_bank_account` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Employee bank created. <br/>';

    IF NEW.bank_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Bank Name: ", NEW.bank_name);
    END IF;

    IF NEW.bank_account_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Bank Account Type Name: ", NEW.bank_account_type_name);
    END IF;

    IF NEW.account_number <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Account Number: ", NEW.account_number);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('customer_bank_account', NEW.customer_bank_account_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `customer_bank_account_trigger_update`;
DELIMITER $$
CREATE TRIGGER `customer_bank_account_trigger_update` AFTER UPDATE ON `customer_bank_account` FOR EACH ROW BEGIN

    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.bank_name <> OLD.bank_name THEN
        SET audit_log = CONCAT(audit_log, "Bank Name: ", OLD.bank_name, " -> ", NEW.bank_name, "<br/>");
    END IF;

    IF NEW.bank_account_type_name <> OLD.bank_account_type_name THEN
        SET audit_log = CONCAT(audit_log, "Bank Account Type Name: ", OLD.bank_account_type_name, " -> ", NEW.bank_account_type_name, "<br/>");
    END IF;

    IF NEW.account_number <> OLD.account_number THEN
        SET audit_log = CONCAT(audit_log, "Account Number: ", OLD.account_number, " -> ", NEW.account_number, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('customer_bank_account', NEW.customer_bank_account_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customer_bank_card`
--

DROP TABLE IF EXISTS `customer_bank_card`;
CREATE TABLE `customer_bank_card` (
  `customer_bank_card_id` int(10) UNSIGNED NOT NULL,
  `customer_id` int(10) UNSIGNED NOT NULL,
  `name_on_card` varchar(255) NOT NULL,
  `card_number` varchar(255) NOT NULL,
  `expiry_date` varchar(255) NOT NULL,
  `cvv` varchar(255) NOT NULL,
  `default_card` varchar(10) NOT NULL DEFAULT 'Primary',
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer_bank_card`
--

INSERT INTO `customer_bank_card` (`customer_bank_card_id`, `customer_id`, `name_on_card`, `card_number`, `expiry_date`, `cvv`, `default_card`, `created_date`, `last_log_by`) VALUES
(5, 1, 'SITKq7mkEJbNvkBq0k6tUh%2B%2B5NTPk2fWCBjvNn2OQOY%3D', 'htwoXrEuTh%2F1%2FJU0C6mHphTeZZeCIHZjFDdGt63ATZPxsCIQEdezQaJE9ENvUaBq', 'k%2BLsoLe4kx6UCIknMHkAEXcn%2F50IYaQUFCf2II%2Fk%2Fho%3D', 'r%2BfJZaIF295%2BJ8XMq5U8JEYb4XF76cuRr9b9XG2ES7k%3D', 'Primary', '2024-08-22 20:06:27', 2),
(7, 1, 'sr%2BHMBkoA3HffKADq5wACHNkmZ7LX1vNobS0KQeA1Y4%3D', 'KNO%2BO8iMPO%2FDwsEd28H0OZwk%2BUURcfqChb2HPQ8JHuTFqOycPPm%2B9sJkaCvyKCvg', 'xscOOYTpZTwMyqu%2Fow%2BRncqTlji2zJ1DSu5jhI54ZO8%3D', '5x7ot%2B0j%2FQEYaQ1xCk%2BnZYLYO2pxlWb%2BmpSLZT8M%2B8w%3D', 'Alternate', '2024-08-22 20:24:41', 2);

-- --------------------------------------------------------

--
-- Table structure for table `customer_id_record`
--

DROP TABLE IF EXISTS `customer_id_record`;
CREATE TABLE `customer_id_record` (
  `customer_id_record_id` int(10) UNSIGNED NOT NULL,
  `customer_id` int(10) UNSIGNED NOT NULL,
  `id_type_id` int(10) UNSIGNED NOT NULL,
  `id_type_name` varchar(100) NOT NULL,
  `id_number` varchar(100) NOT NULL,
  `issue_date` date NOT NULL,
  `expiration_date` date DEFAULT NULL,
  `issuing_authority` varchar(100) DEFAULT NULL,
  `id_image` varchar(500) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer_id_record`
--

INSERT INTO `customer_id_record` (`customer_id_record_id`, `customer_id`, `id_type_id`, `id_type_name`, `id_number`, `issue_date`, `expiration_date`, `issuing_authority`, `id_image`, `created_date`, `last_log_by`) VALUES
(1, 1, 1, 'Barangay ID', '123123', '2024-08-20', NULL, '', './components/customer/image/1/id-record/OO7i.jpg', '2024-08-20 16:44:11', 2);

--
-- Triggers `customer_id_record`
--
DROP TRIGGER IF EXISTS `customer_id_record_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `customer_id_record_trigger_insert` AFTER INSERT ON `customer_id_record` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Customer ID record created. <br/>';

    IF NEW.id_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>ID Type Name: ", NEW.id_type_name);
    END IF;

    IF NEW.id_number <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>ID Number: ", NEW.id_number);
    END IF;

    IF NEW.issue_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Issue Date: ", NEW.issue_date);
    END IF;

    IF NEW.expiration_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Expiration Date: ", NEW.expiration_date);
    END IF;

    IF NEW.issuing_authority <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Issuing Authority: ", NEW.issuing_authority);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('customer_id_record', NEW.customer_id_record_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `customer_id_record_trigger_update`;
DELIMITER $$
CREATE TRIGGER `customer_id_record_trigger_update` AFTER UPDATE ON `customer_id_record` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.id_type_name <> OLD.id_type_name THEN
        SET audit_log = CONCAT(audit_log, "ID Type Name: ", OLD.id_type_name, " -> ", NEW.id_type_name, "<br/>");
    END IF;

    IF NEW.id_number <> OLD.id_number THEN
        SET audit_log = CONCAT(audit_log, "ID Number: ", OLD.id_number, " -> ", NEW.id_number, "<br/>");
    END IF;

    IF NEW.issue_date <> OLD.issue_date THEN
        SET audit_log = CONCAT(audit_log, "Issue Date: ", OLD.issue_date, " -> ", NEW.issue_date, "<br/>");
    END IF;

    IF NEW.expiration_date <> OLD.expiration_date THEN
        SET audit_log = CONCAT(audit_log, "Expiration Date: ", OLD.expiration_date, " -> ", NEW.expiration_date, "<br/>");
    END IF;

    IF NEW.issuing_authority <> OLD.issuing_authority THEN
        SET audit_log = CONCAT(audit_log, "Issuing Authority: ", OLD.issuing_authority, " -> ", NEW.issuing_authority, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('customer_id_record', NEW.customer_id_record_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `customer_inquiry`
--

DROP TABLE IF EXISTS `customer_inquiry`;
CREATE TABLE `customer_inquiry` (
  `customer_inquiry_id` int(10) UNSIGNED NOT NULL,
  `customer_name` varchar(500) NOT NULL,
  `email` varchar(500) NOT NULL,
  `phone` varchar(50) NOT NULL,
  `subject` varchar(500) NOT NULL,
  `message` longtext NOT NULL,
  `inquiry_status` varchar(50) NOT NULL DEFAULT 'Pending',
  `in_progress_date` datetime DEFAULT NULL,
  `in_progress_by` int(10) UNSIGNED DEFAULT NULL,
  `resolved_date` datetime DEFAULT NULL,
  `resolved_by` int(10) UNSIGNED DEFAULT NULL,
  `closed_date` datetime DEFAULT NULL,
  `closed_by` int(10) UNSIGNED DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `customer_inquiry`
--

INSERT INTO `customer_inquiry` (`customer_inquiry_id`, `customer_name`, `email`, `phone`, `subject`, `message`, `inquiry_status`, `in_progress_date`, `in_progress_by`, `resolved_date`, `resolved_by`, `closed_date`, `closed_by`, `created_date`, `last_log_by`) VALUES
(4, 'asdas', 'cgmidc@gmail.com', 'asd', 'asd', 'asd', 'Pending', NULL, NULL, NULL, NULL, NULL, NULL, '2024-09-09 14:13:33', 2),
(5, 'asd', 'cgmidc@gmail.com', 'asd', 'asd', 'asd', 'Pending', NULL, NULL, NULL, NULL, NULL, NULL, '2024-09-09 14:14:12', 2),
(6, 'asd', 'cgmidc@gmail.com', 'asd', 'asd', 'asd', 'Pending', NULL, NULL, NULL, NULL, NULL, NULL, '2024-09-09 14:14:18', 2),
(7, 'asd', 'cgmidc@gmail.com', 'asd', 'asd', 'asd', 'Pending', NULL, NULL, NULL, NULL, NULL, NULL, '2024-09-09 14:18:01', 2),
(8, 'asd', 'asd@gmail.com', 'sd', 'aasd', 'asd', 'Pending', NULL, NULL, NULL, NULL, NULL, NULL, '2024-09-09 14:25:44', 2),
(9, 'asd', 'asd@gmail.com', 'sd', 'aasd', 'asd', 'Pending', NULL, NULL, NULL, NULL, NULL, NULL, '2024-09-09 14:26:13', 2),
(10, 'asd', 'asd@gmail.com', 'sd', 'aasd', 'asd', 'Pending', NULL, NULL, NULL, NULL, NULL, NULL, '2024-09-09 14:27:21', 2),
(11, 'asd', 'asd@gmail.com', 'sd', 'aasd', 'asd', 'Pending', NULL, NULL, NULL, NULL, NULL, NULL, '2024-09-09 14:31:54', 2),
(12, 'ad', 'asd@gmail.com', 'asd', 'asd', 'asd', 'Pending', NULL, NULL, NULL, NULL, NULL, NULL, '2024-09-09 14:36:29', 2),
(13, 'asd', 'cgmidc@gmail.com', 'asd', 'asd', 'asd', 'Pending', NULL, NULL, NULL, NULL, NULL, NULL, '2024-09-09 14:42:05', 2),
(14, 'asd', 'cgmidc@gmail.com', 'asd', 'asd', 'asd', 'Pending', NULL, NULL, NULL, NULL, NULL, NULL, '2024-09-09 14:42:46', 2),
(15, 'asd', 'cgmidc@gmail.com', 'asd', 'asd', 'asd', 'Pending', NULL, NULL, NULL, NULL, NULL, NULL, '2024-09-09 14:44:41', 2);

--
-- Triggers `customer_inquiry`
--
DROP TRIGGER IF EXISTS `customer_inquiry_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `customer_inquiry_trigger_insert` AFTER INSERT ON `customer_inquiry` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Customer inquiry created. <br/>';

    IF NEW.customer_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Customer Inquiry Name: ", NEW.customer_name);
    END IF;

    IF NEW.email <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Email: ", NEW.email);
    END IF;

    IF NEW.phone <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Phone: ", NEW.phone);
    END IF;

    IF NEW.subject <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Subject: ", NEW.subject);
    END IF;

    IF NEW.message <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Message: ", NEW.message);
    END IF;

    IF NEW.inquiry_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Inquiry Status: ", NEW.inquiry_status);
    END IF;

    IF NEW.in_progress_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>In-Progress Date: ", NEW.in_progress_date);
    END IF;

    IF NEW.resolved_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Resolved Date: ", NEW.resolved_date);
    END IF;

    IF NEW.closed_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Closed Date: ", NEW.closed_date);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('customer_inquiry', NEW.customer_inquiry_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `customer_inquiry_trigger_update`;
DELIMITER $$
CREATE TRIGGER `customer_inquiry_trigger_update` AFTER UPDATE ON `customer_inquiry` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.customer_name <> OLD.customer_name THEN
        SET audit_log = CONCAT(audit_log, "Customer Name: ", OLD.customer_name, " -> ", NEW.customer_name, "<br/>");
    END IF;

    IF NEW.email <> OLD.email THEN
        SET audit_log = CONCAT(audit_log, "Email: ", OLD.email, " -> ", NEW.email, "<br/>");
    END IF;

    IF NEW.phone <> OLD.phone THEN
        SET audit_log = CONCAT(audit_log, "Phone: ", OLD.phone, " -> ", NEW.phone, "<br/>");
    END IF;

    IF NEW.subject <> OLD.subject THEN
        SET audit_log = CONCAT(audit_log, "Subject: ", OLD.subject, " -> ", NEW.subject, "<br/>");
    END IF;

    IF NEW.message <> OLD.message THEN
        SET audit_log = CONCAT(audit_log, "Message: ", OLD.message, " -> ", NEW.message, "<br/>");
    END IF;

    IF NEW.inquiry_status <> OLD.inquiry_status THEN
        SET audit_log = CONCAT(audit_log, "Inquiry Status: ", OLD.inquiry_status, " -> ", NEW.inquiry_status, "<br/>");
    END IF;

    IF NEW.in_progress_date <> OLD.in_progress_date THEN
        SET audit_log = CONCAT(audit_log, "In-Progress Date: ", OLD.in_progress_date, " -> ", NEW.in_progress_date, "<br/>");
    END IF;

    IF NEW.resolved_date <> OLD.resolved_date THEN
        SET audit_log = CONCAT(audit_log, "Resolved Date: ", OLD.resolved_date, " -> ", NEW.resolved_date, "<br/>");
    END IF;

    IF NEW.closed_date <> OLD.closed_date THEN
        SET audit_log = CONCAT(audit_log, "Closed Date: ", OLD.closed_date, " -> ", NEW.closed_date, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('customer_inquiry', NEW.customer_inquiry_id, audit_log, NEW.last_log_by, NOW());
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
-- Dumping data for table `department`
--

INSERT INTO `department` (`department_id`, `department_name`, `parent_department_id`, `parent_department_name`, `manager_id`, `manager_name`, `created_date`, `last_log_by`) VALUES
(1, 'Data Center', 0, '', 0, '', '2024-07-09 11:20:27', 2),
(2, 'Accounting ', 0, '', 0, '', '2024-09-08 19:42:21', 2),
(3, 'Customer Service', 0, '', 0, '', '2024-09-08 19:44:37', 2);

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
-- Dumping data for table `departure_reason`
--

INSERT INTO `departure_reason` (`departure_reason_id`, `departure_reason_name`, `created_date`, `last_log_by`) VALUES
(1, 'Resignation', '2024-07-31 10:20:23', 2),
(2, 'Retirement', '2024-07-31 10:20:31', 2),
(3, 'Termination for Cause', '2024-07-31 10:20:38', 2),
(4, 'Layoff', '2024-07-31 10:20:43', 2),
(5, 'End of Contract', '2024-07-31 10:20:51', 2),
(6, 'Personal Reasons', '2024-07-31 10:20:57', 2),
(7, 'Relocation', '2024-07-31 10:21:04', 2),
(8, 'Career Change', '2024-07-31 10:21:10', 2),
(9, 'Health Issues', '2024-07-31 10:21:16', 2),
(10, 'Family Reasons', '2024-07-31 10:21:22', 2),
(11, 'Better Opportunity', '2024-07-31 10:21:26', 2),
(12, 'Education Pursuit', '2024-07-31 10:21:31', 2),
(13, 'Company Restructuring', '2024-07-31 10:21:36', 2),
(14, 'Voluntary Severance', '2024-07-31 10:21:41', 2),
(15, 'Death', '2024-07-31 10:21:45', 2);

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
  `full_name` varchar(1000) NOT NULL,
  `first_name` varchar(300) NOT NULL,
  `middle_name` varchar(300) DEFAULT NULL,
  `last_name` varchar(300) NOT NULL,
  `suffix` varchar(10) DEFAULT NULL,
  `about` varchar(500) DEFAULT 'No about found.',
  `nickname` varchar(100) DEFAULT NULL,
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
  `badge_id` varchar(200) DEFAULT NULL,
  `company_id` int(10) UNSIGNED DEFAULT NULL,
  `company_name` varchar(100) DEFAULT NULL,
  `employment_type_id` int(10) UNSIGNED DEFAULT NULL,
  `employment_type_name` varchar(100) DEFAULT NULL,
  `department_id` int(10) UNSIGNED DEFAULT NULL,
  `department_name` varchar(100) DEFAULT NULL,
  `job_position_id` int(10) UNSIGNED DEFAULT NULL,
  `job_position_name` varchar(100) DEFAULT NULL,
  `work_location_id` int(10) UNSIGNED DEFAULT NULL,
  `work_location_name` varchar(100) DEFAULT NULL,
  `manager_id` int(10) UNSIGNED DEFAULT NULL,
  `manager_name` varchar(300) DEFAULT NULL,
  `work_schedule_id` int(10) UNSIGNED DEFAULT NULL,
  `work_schedule_name` varchar(100) DEFAULT NULL,
  `employment_status` varchar(50) NOT NULL DEFAULT 'Active',
  `pin_code` varchar(500) DEFAULT NULL,
  `home_work_distance` double DEFAULT NULL,
  `visa_number` varchar(50) DEFAULT NULL,
  `work_permit_number` varchar(50) DEFAULT NULL,
  `visa_expiration_date` date DEFAULT NULL,
  `work_permit_expiration_date` date DEFAULT NULL,
  `work_permit` varchar(500) DEFAULT NULL,
  `onboard_date` date DEFAULT NULL,
  `offboard_date` date DEFAULT NULL,
  `time_off_approver_id` int(10) UNSIGNED DEFAULT NULL,
  `time_off_approver_name` varchar(300) DEFAULT NULL,
  `departure_reason_id` int(10) UNSIGNED DEFAULT NULL,
  `departure_reason_name` varchar(100) DEFAULT NULL,
  `detailed_departure_reason` varchar(5000) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee`
--

INSERT INTO `employee` (`employee_id`, `employee_image`, `employee_digital_signature`, `full_name`, `first_name`, `middle_name`, `last_name`, `suffix`, `about`, `nickname`, `civil_status_id`, `civil_status_name`, `gender_id`, `gender_name`, `religion_id`, `religion_name`, `blood_type_id`, `blood_type_name`, `birthday`, `birth_place`, `height`, `weight`, `badge_id`, `company_id`, `company_name`, `employment_type_id`, `employment_type_name`, `department_id`, `department_name`, `job_position_id`, `job_position_name`, `work_location_id`, `work_location_name`, `manager_id`, `manager_name`, `work_schedule_id`, `work_schedule_name`, `employment_status`, `pin_code`, `home_work_distance`, `visa_number`, `work_permit_number`, `visa_expiration_date`, `work_permit_expiration_date`, `work_permit`, `onboard_date`, `offboard_date`, `time_off_approver_id`, `time_off_approver_name`, `departure_reason_id`, `departure_reason_name`, `detailed_departure_reason`, `created_date`, `last_log_by`) VALUES
(1, NULL, NULL, 'Lawrence De Vera Agulto, Suffix', 'Lawrence', 'De Vera', 'Agulto', 'Suffix', NULL, 'nickname', 2, 'Engaged', 2, 'Female', 1, 'Aglipayan Church', 1, 'A+', '2024-07-28', 'place of birth', 1, 2, 'badge id', 1, 'Christian General Motors Inc.', 10, 'Apprentice', 1, 'Data Center', 1, 'Data Center Staff', 1, 'CGMI', 0, '', 1, 'Regular', 'Active', 'pincode', 20, 'visa no', 'work permit no', '2024-07-29', '2024-07-30', NULL, '2024-07-31', NULL, 2, 'Administrator', NULL, NULL, NULL, '2024-07-28 20:03:54', 2),
(2, './components/employee/image/2/profile/uHPq.png', NULL, 'Lennard De Vera Agulto, Suffix', 'Lennard', 'De Vera', 'Agulto', 'Suffix', 'No about found.', '--', 4, 'Married', 1, 'Male', 12, 'Roman Catholic', 2, 'A-', '2024-07-30', 'Cabanatuan city, Nueva Ecija', 0, 0, 'Badge IDs', 1, 'Christian General Motors Inc.', 11, 'Probationary', 1, 'Data Center', 1, 'Data Center Staff', 1, 'CGMI', 0, '', 1, 'Regular', 'Active', 'Pin Codes', 0, 'Visa Nos', 'Work Permit Nos', '2024-07-31', '2024-08-30', NULL, '2024-08-21', NULL, 0, '', 0, '', '', '2024-07-28 20:40:04', 2);

--
-- Triggers `employee`
--
DROP TRIGGER IF EXISTS `employee_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `employee_trigger_insert` AFTER INSERT ON `employee` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Employee created. <br/>';

    IF NEW.full_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Full Name: ", NEW.full_name);
    END IF;

    IF NEW.first_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>First Name: ", NEW.first_name);
    END IF;

    IF NEW.middle_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Middle Name: ", NEW.middle_name);
    END IF;

    IF NEW.last_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Last Name: ", NEW.last_name);
    END IF;

    IF NEW.suffix <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Suffix: ", NEW.suffix);
    END IF;

    IF NEW.about <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>About: ", NEW.about);
    END IF;

    IF NEW.nickname <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Nickname: ", NEW.nickname);
    END IF;

    IF NEW.civil_status_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Civil Status Name: ", NEW.civil_status_name);
    END IF;

    IF NEW.gender_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Gender Name: ", NEW.gender_name);
    END IF;

    IF NEW.religion_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Religion Name: ", NEW.religion_name);
    END IF;

    IF NEW.blood_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Blood Type Name: ", NEW.blood_type_name);
    END IF;

    IF NEW.birthday <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Date of Birth: ", NEW.birthday);
    END IF;

    IF NEW.birth_place <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Birth Place: ", NEW.birth_place);
    END IF;

    IF NEW.height <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Height: ", NEW.height);
    END IF;

    IF NEW.weight <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Weight: ", NEW.weight);
    END IF;

    IF NEW.badge_id <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Badge ID: ", NEW.badge_id);
    END IF;

    IF NEW.company_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Company Name: ", NEW.company_name);
    END IF;

    IF NEW.employment_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Employment Type Name: ", NEW.employment_type_name);
    END IF;

    IF NEW.department_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Department Name: ", NEW.department_name);
    END IF;

    IF NEW.job_position_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Job Position Name: ", NEW.job_position_name);
    END IF;

    IF NEW.manager_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Manager Name: ", NEW.manager_name);
    END IF;

    IF NEW.work_schedule_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Work Schedule Name: ", NEW.work_schedule_name);
    END IF;

    IF NEW.employment_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Employment Status: ", NEW.employment_status);
    END IF;

    IF NEW.pin_code <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>PIN Code: ", NEW.pin_code);
    END IF;

    IF NEW.home_work_distance <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Home Work Distance: ", NEW.home_work_distance);
    END IF;

    IF NEW.visa_number <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Visa Number: ", NEW.visa_number);
    END IF;

    IF NEW.work_permit_number <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Work Permit Number: ", NEW.work_permit_number);
    END IF;

    IF NEW.visa_expiration_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Visa Expiration Date: ", NEW.visa_expiration_date);
    END IF;

    IF NEW.work_permit_expiration_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Work Permit Expiration Date: ", NEW.work_permit_expiration_date);
    END IF;

    IF NEW.onboard_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>On-Board Date: ", NEW.onboard_date);
    END IF;

    IF NEW.offboard_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Off-Board Date: ", NEW.offboard_date);
    END IF;

    IF NEW.time_off_approver_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Time Off Approver Name: ", NEW.time_off_approver_name);
    END IF;

    IF NEW.departure_reason_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Departure Reason Name: ", NEW.departure_reason_name);
    END IF;

    IF NEW.detailed_departure_reason <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Detailed Departure Reason: ", NEW.detailed_departure_reason);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('employee', NEW.employee_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `employee_trigger_update`;
DELIMITER $$
CREATE TRIGGER `employee_trigger_update` AFTER UPDATE ON `employee` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.full_name <> OLD.full_name THEN
        SET audit_log = CONCAT(audit_log, "Full Name: ", OLD.full_name, " -> ", NEW.full_name, "<br/>");
    END IF;

    IF NEW.first_name <> OLD.first_name THEN
        SET audit_log = CONCAT(audit_log, "First Name: ", OLD.first_name, " -> ", NEW.first_name, "<br/>");
    END IF;

    IF NEW.middle_name <> OLD.middle_name THEN
        SET audit_log = CONCAT(audit_log, "Middle Name: ", OLD.middle_name, " -> ", NEW.middle_name, "<br/>");
    END IF;

    IF NEW.last_name <> OLD.last_name THEN
        SET audit_log = CONCAT(audit_log, "Last Name: ", OLD.last_name, " -> ", NEW.last_name, "<br/>");
    END IF;

    IF NEW.suffix <> OLD.suffix THEN
        SET audit_log = CONCAT(audit_log, "Suffix: ", OLD.suffix, " -> ", NEW.suffix, "<br/>");
    END IF;

    IF NEW.about <> OLD.about THEN
        SET audit_log = CONCAT(audit_log, "About: ", OLD.about, " -> ", NEW.about, "<br/>");
    END IF;

    IF NEW.nickname <> OLD.nickname THEN
        SET audit_log = CONCAT(audit_log, "Nickname: ", OLD.nickname, " -> ", NEW.nickname, "<br/>");
    END IF;

    IF NEW.civil_status_name <> OLD.civil_status_name THEN
        SET audit_log = CONCAT(audit_log, "Civil Status Name: ", OLD.civil_status_name, " -> ", NEW.civil_status_name, "<br/>");
    END IF;

    IF NEW.gender_name <> OLD.gender_name THEN
        SET audit_log = CONCAT(audit_log, "Gender Name: ", OLD.gender_name, " -> ", NEW.gender_name, "<br/>");
    END IF;

    IF NEW.religion_name <> OLD.religion_name THEN
        SET audit_log = CONCAT(audit_log, "Religion Name: ", OLD.religion_name, " -> ", NEW.religion_name, "<br/>");
    END IF;

    IF NEW.blood_type_name <> OLD.blood_type_name THEN
        SET audit_log = CONCAT(audit_log, "Blood Type Name: ", OLD.blood_type_name, " -> ", NEW.blood_type_name, "<br/>");
    END IF;

    IF NEW.birthday <> OLD.birthday THEN
        SET audit_log = CONCAT(audit_log, "Date of Birth: ", OLD.birthday, " -> ", NEW.birthday, "<br/>");
    END IF;

    IF NEW.birth_place <> OLD.birth_place THEN
        SET audit_log = CONCAT(audit_log, "Birth Place: ", OLD.birth_place, " -> ", NEW.birth_place, "<br/>");
    END IF;

    IF NEW.height <> OLD.height THEN
        SET audit_log = CONCAT(audit_log, "Height: ", OLD.height, " -> ", NEW.height, "<br/>");
    END IF;

    IF NEW.weight <> OLD.weight THEN
        SET audit_log = CONCAT(audit_log, "Weight: ", OLD.weight, " -> ", NEW.weight, "<br/>");
    END IF;

    IF NEW.badge_id <> OLD.badge_id THEN
        SET audit_log = CONCAT(audit_log, "Badge ID: ", OLD.badge_id, " -> ", NEW.badge_id, "<br/>");
    END IF;

    IF NEW.company_name <> OLD.company_name THEN
        SET audit_log = CONCAT(audit_log, "Company Name: ", OLD.company_name, " -> ", NEW.company_name, "<br/>");
    END IF;

    IF NEW.employment_type_name <> OLD.employment_type_name THEN
        SET audit_log = CONCAT(audit_log, "Employment Type Name: ", OLD.employment_type_name, " -> ", NEW.employment_type_name, "<br/>");
    END IF;

    IF NEW.department_name <> OLD.department_name THEN
        SET audit_log = CONCAT(audit_log, "Department Name: ", OLD.department_name, " -> ", NEW.department_name, "<br/>");
    END IF;

    IF NEW.job_position_name <> OLD.job_position_name THEN
        SET audit_log = CONCAT(audit_log, "Job Position Name: ", OLD.job_position_name, " -> ", NEW.job_position_name, "<br/>");
    END IF;

    IF NEW.manager_name <> OLD.manager_name THEN

        SET audit_log = CONCAT(audit_log, "Manager Name: ", OLD.manager_name, " -> ", NEW.manager_name, "<br/>");
    END IF;

    IF NEW.work_schedule_name <> OLD.work_schedule_name THEN
        SET audit_log = CONCAT(audit_log, "Work Schedule Name: ", OLD.work_schedule_name, " -> ", NEW.work_schedule_name, "<br/>");
    END IF;

    IF NEW.employment_status <> OLD.employment_status THEN
        SET audit_log = CONCAT(audit_log, "Employment Status: ", OLD.employment_status, " -> ", NEW.employment_status, "<br/>");
    END IF;

    IF NEW.pin_code <> OLD.pin_code THEN
        SET audit_log = CONCAT(audit_log, "PIN Code: ", OLD.pin_code, " -> ", NEW.pin_code, "<br/>");
    END IF;

    IF NEW.home_work_distance <> OLD.home_work_distance THEN
        SET audit_log = CONCAT(audit_log, "Home Work Distance: ", OLD.home_work_distance, " -> ", NEW.home_work_distance, "<br/>");
    END IF;

    IF NEW.visa_number <> OLD.visa_number THEN
        SET audit_log = CONCAT(audit_log, "Visa Number: ", OLD.visa_number, " -> ", NEW.visa_number, "<br/>");
    END IF;

    IF NEW.work_permit_number <> OLD.work_permit_number THEN
        SET audit_log = CONCAT(audit_log, "Work Permit Number: ", OLD.work_permit_number, " -> ", NEW.work_permit_number, "<br/>");
    END IF;

    IF NEW.visa_expiration_date <> OLD.visa_expiration_date THEN
        SET audit_log = CONCAT(audit_log, "Visa Expiration Date: ", OLD.visa_expiration_date, " -> ", NEW.visa_expiration_date, "<br/>");
    END IF;

    IF NEW.work_permit_expiration_date <> OLD.work_permit_expiration_date THEN
        SET audit_log = CONCAT(audit_log, "Work Permit Expiration Date: ", OLD.work_permit_expiration_date, " -> ", NEW.work_permit_expiration_date, "<br/>");
    END IF;

    IF NEW.onboard_date <> OLD.onboard_date THEN
        SET audit_log = CONCAT(audit_log, "On-Board Date: ", OLD.onboard_date, " -> ", NEW.onboard_date, "<br/>");
    END IF;

    IF NEW.offboard_date <> OLD.offboard_date THEN
        SET audit_log = CONCAT(audit_log, "Off-Board Date: ", OLD.offboard_date, " -> ", NEW.offboard_date, "<br/>");
    END IF;

    IF NEW.time_off_approver_name <> OLD.time_off_approver_name THEN
        SET audit_log = CONCAT(audit_log, "Time Off Approver Name: ", OLD.time_off_approver_name, " -> ", NEW.time_off_approver_name, "<br/>");
    END IF;

    IF NEW.departure_reason_name <> OLD.departure_reason_name THEN
        SET audit_log = CONCAT(audit_log, "Departure Reason Name: ", OLD.departure_reason_name, " -> ", NEW.departure_reason_name, "<br/>");
    END IF;

    IF NEW.detailed_departure_reason <> OLD.detailed_departure_reason THEN
        SET audit_log = CONCAT(audit_log, "Detailed Departure Reason: ", OLD.detailed_departure_reason, " -> ", NEW.detailed_departure_reason, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('employee', NEW.employee_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `employee_address`
--

DROP TABLE IF EXISTS `employee_address`;
CREATE TABLE `employee_address` (
  `employee_address_id` int(10) UNSIGNED NOT NULL,
  `employee_id` int(10) UNSIGNED NOT NULL,
  `address_type_id` int(10) UNSIGNED NOT NULL,
  `address_type_name` varchar(100) NOT NULL,
  `address` varchar(1000) DEFAULT NULL,
  `city_id` int(10) UNSIGNED NOT NULL,
  `city_name` varchar(100) NOT NULL,
  `state_id` int(10) UNSIGNED NOT NULL,
  `state_name` varchar(100) NOT NULL,
  `country_id` int(10) UNSIGNED NOT NULL,
  `country_name` varchar(100) NOT NULL,
  `telephone` varchar(50) DEFAULT NULL,
  `mobile` varchar(50) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `default_address` varchar(10) NOT NULL DEFAULT 'Primary',
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_address`
--

INSERT INTO `employee_address` (`employee_address_id`, `employee_id`, `address_type_id`, `address_type_name`, `address`, `city_id`, `city_name`, `state_id`, `state_name`, `country_id`, `country_name`, `telephone`, `mobile`, `email`, `default_address`, `created_date`, `last_log_by`) VALUES
(2, 2, 1, 'Home Address', '1654 jnuinoknasd', 523, 'Aborlan', 26, 'Palawan', 174, 'Philippines', '16516521', '08615891516', '1@gmail.com', 'Alternate', '2024-08-12 16:14:58', 2),
(3, 2, 2, 'Billing Address', '237 San Juan Accfa', 523, 'Aborlan', 26, 'Palawan', 174, 'Philippines', '1516498', '09181654986', '', 'Primary', '2024-08-12 16:19:24', 2);

--
-- Triggers `employee_address`
--
DROP TRIGGER IF EXISTS `employee_address_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `employee_address_trigger_insert` AFTER INSERT ON `employee_address` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Employee address created. <br/>';

    IF NEW.address_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Address Type Name: ", NEW.address_type_name);
    END IF;

    IF NEW.address <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Address: ", NEW.address);
    END IF;

    IF NEW.city_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>City Name: ", NEW.city_name);
    END IF;

    IF NEW.state_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>State Name: ", NEW.state_name);
    END IF;

    IF NEW.country_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Country Name: ", NEW.country_name);
    END IF;

    IF NEW.telephone <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Telephone: ", NEW.telephone);
    END IF;

    IF NEW.mobile <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Mobile: ", NEW.mobile);
    END IF;

    IF NEW.email <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Email: ", NEW.email);
    END IF;

    IF NEW.default_address <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Default Address: ", NEW.default_address);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('employee_address', NEW.employee_address_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `employee_address_trigger_update`;
DELIMITER $$
CREATE TRIGGER `employee_address_trigger_update` AFTER UPDATE ON `employee_address` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.address_type_name <> OLD.address_type_name THEN
        SET audit_log = CONCAT(audit_log, "Address Type Name: ", OLD.address_type_name, " -> ", NEW.address_type_name, "<br/>");
    END IF;

    IF NEW.address <> OLD.address THEN
        SET audit_log = CONCAT(audit_log, "Address: ", OLD.address, " -> ", NEW.address, "<br/>");
    END IF;

    IF NEW.city_name <> OLD.city_name THEN
        SET audit_log = CONCAT(audit_log, "City Name: ", OLD.city_name, " -> ", NEW.city_name, "<br/>");
    END IF;

    IF NEW.state_name <> OLD.state_name THEN
        SET audit_log = CONCAT(audit_log, "State Name: ", OLD.state_name, " -> ", NEW.state_name, "<br/>");
    END IF;

    IF NEW.country_name <> OLD.country_name THEN
        SET audit_log = CONCAT(audit_log, "Country Name: ", OLD.country_name, " -> ", NEW.country_name, "<br/>");
    END IF;

    IF NEW.telephone <> OLD.telephone THEN
        SET audit_log = CONCAT(audit_log, "Telephone: ", OLD.telephone, " -> ", NEW.telephone, "<br/>");
    END IF;

    IF NEW.mobile <> OLD.mobile THEN
        SET audit_log = CONCAT(audit_log, "Mobile: ", OLD.mobile, " -> ", NEW.mobile, "<br/>");
    END IF;

    IF NEW.email <> OLD.email THEN
        SET audit_log = CONCAT(audit_log, "Email: ", OLD.email, " -> ", NEW.email, "<br/>");
    END IF;

    IF NEW.default_address <> OLD.default_address THEN
        SET audit_log = CONCAT(audit_log, "Default Address: ", OLD.default_address, " -> ", NEW.default_address, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('employee_address', NEW.employee_address_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `employee_bank_account`
--

DROP TABLE IF EXISTS `employee_bank_account`;
CREATE TABLE `employee_bank_account` (
  `employee_bank_account_id` int(10) UNSIGNED NOT NULL,
  `employee_id` int(10) UNSIGNED NOT NULL,
  `bank_id` int(10) UNSIGNED NOT NULL,
  `bank_name` varchar(100) NOT NULL,
  `bank_account_type_id` int(10) UNSIGNED NOT NULL,
  `bank_account_type_name` varchar(100) NOT NULL,
  `account_number` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_bank_account`
--

INSERT INTO `employee_bank_account` (`employee_bank_account_id`, `employee_id`, `bank_id`, `bank_name`, `bank_account_type_id`, `bank_account_type_name`, `account_number`, `created_date`, `last_log_by`) VALUES
(5, 2, 8, 'Development Bank of the Philippines (DBP)', 1, 'Checking Account', '1245623', '2024-08-12 11:59:27', 2);

--
-- Triggers `employee_bank_account`
--
DROP TRIGGER IF EXISTS `employee_bank_account_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `employee_bank_account_trigger_insert` AFTER INSERT ON `employee_bank_account` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Employee bank created. <br/>';

    IF NEW.bank_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Bank Name: ", NEW.bank_name);
    END IF;

    IF NEW.bank_account_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Bank Account Type Name: ", NEW.bank_account_type_name);
    END IF;

    IF NEW.account_number <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Account Number: ", NEW.account_number);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('employee_bank_account', NEW.employee_bank_account_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `employee_bank_account_trigger_update`;
DELIMITER $$
CREATE TRIGGER `employee_bank_account_trigger_update` AFTER UPDATE ON `employee_bank_account` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.bank_name <> OLD.bank_name THEN
        SET audit_log = CONCAT(audit_log, "Bank Name: ", OLD.bank_name, " -> ", NEW.bank_name, "<br/>");
    END IF;

    IF NEW.bank_account_type_name <> OLD.bank_account_type_name THEN
        SET audit_log = CONCAT(audit_log, "Bank Account Type Name: ", OLD.bank_account_type_name, " -> ", NEW.bank_account_type_name, "<br/>");
    END IF;

    IF NEW.account_number <> OLD.account_number THEN
        SET audit_log = CONCAT(audit_log, "Account Number: ", OLD.account_number, " -> ", NEW.account_number, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('employee_bank_account', NEW.employee_bank_account_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `employee_education`
--

DROP TABLE IF EXISTS `employee_education`;
CREATE TABLE `employee_education` (
  `employee_education_id` int(10) UNSIGNED NOT NULL,
  `employee_id` int(10) UNSIGNED NOT NULL,
  `school` varchar(100) NOT NULL,
  `degree` varchar(100) DEFAULT NULL,
  `field_of_study` varchar(100) DEFAULT NULL,
  `start_month` varchar(20) DEFAULT NULL,
  `start_year` varchar(20) DEFAULT NULL,
  `end_month` varchar(20) DEFAULT NULL,
  `end_year` varchar(20) DEFAULT NULL,
  `activities_societies` varchar(5000) DEFAULT NULL,
  `education_description` varchar(5000) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_education`
--

INSERT INTO `employee_education` (`employee_education_id`, `employee_id`, `school`, `degree`, `field_of_study`, `start_month`, `start_year`, `end_month`, `end_year`, `activities_societies`, `education_description`, `created_date`, `last_log_by`) VALUES
(2, 2, 'CIC', 'asd', 'asd', '2', '2008', '', '', 'asdasd', 'asdasdasdasdasdasd', '2024-08-12 16:59:39', 2),
(3, 2, 'asdasd', 'asdas', 'dasdas', '5', '2007', '11', '2009', 'asdasd', 'asdasdasd', '2024-08-12 17:03:07', 2);

--
-- Triggers `employee_education`
--
DROP TRIGGER IF EXISTS `employee_education_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `employee_education_trigger_insert` AFTER INSERT ON `employee_education` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Employee education created. <br/>';

    IF NEW.school <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>School: ", NEW.school);
    END IF;

    IF NEW.degree <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Degree: ", NEW.degree);
    END IF;

    IF NEW.field_of_study <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Field of Study: ", NEW.field_of_study);
    END IF;

    IF NEW.start_month <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Start Month: ", NEW.start_month);
    END IF;

    IF NEW.start_year <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Start Year: ", NEW.start_year);
    END IF;

    IF NEW.end_month <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>End Month: ", NEW.end_month);
    END IF;

    IF NEW.end_year <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>End Year: ", NEW.end_year);
    END IF;

    IF NEW.activities_societies <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Activities and Societies: ", NEW.activities_societies);
    END IF;

    IF NEW.education_description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.education_description);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('employee_education', NEW.employee_education_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `employee_education_trigger_update`;
DELIMITER $$
CREATE TRIGGER `employee_education_trigger_update` AFTER UPDATE ON `employee_education` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.school <> OLD.school THEN
        SET audit_log = CONCAT(audit_log, "School: ", OLD.school, " -> ", NEW.school, "<br/>");
    END IF;

    IF NEW.degree <> OLD.degree THEN
        SET audit_log = CONCAT(audit_log, "Degree: ", OLD.degree, " -> ", NEW.degree, "<br/>");
    END IF;

    IF NEW.field_of_study <> OLD.field_of_study THEN
        SET audit_log = CONCAT(audit_log, "Field of Study: ", OLD.field_of_study, " -> ", NEW.field_of_study, "<br/>");
    END IF;

    IF NEW.start_month <> OLD.start_month THEN
        SET audit_log = CONCAT(audit_log, "Start Month: ", OLD.start_month, " -> ", NEW.start_month, "<br/>");
    END IF;

    IF NEW.start_year <> OLD.start_year THEN
        SET audit_log = CONCAT(audit_log, "Start Year: ", OLD.start_year, " -> ", NEW.start_year, "<br/>");
    END IF;

    IF NEW.end_month <> OLD.end_month THEN
        SET audit_log = CONCAT(audit_log, "End Month: ", OLD.end_month, " -> ", NEW.end_month, "<br/>");
    END IF;

    IF NEW.end_year <> OLD.end_year THEN
        SET audit_log = CONCAT(audit_log, "End Year: ", OLD.end_year, " -> ", NEW.end_year, "<br/>");
    END IF;

    IF NEW.activities_societies <> OLD.activities_societies THEN
        SET audit_log = CONCAT(audit_log, "Activities and Societies: ", OLD.activities_societies, " -> ", NEW.activities_societies, "<br/>");
    END IF;

    IF NEW.education_description <> OLD.education_description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.education_description, " -> ", NEW.education_description, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('employee_education', NEW.employee_education_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `employee_emergency_contact`
--

DROP TABLE IF EXISTS `employee_emergency_contact`;
CREATE TABLE `employee_emergency_contact` (
  `employee_emergency_contact_id` int(10) UNSIGNED NOT NULL,
  `employee_id` int(10) UNSIGNED NOT NULL,
  `emergency_contact_name` varchar(500) NOT NULL,
  `relation_id` int(11) NOT NULL,
  `relation_name` varchar(100) NOT NULL,
  `telephone` varchar(50) DEFAULT NULL,
  `mobile` varchar(50) DEFAULT NULL,
  `email` varchar(200) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_emergency_contact`
--

INSERT INTO `employee_emergency_contact` (`employee_emergency_contact_id`, `employee_id`, `emergency_contact_name`, `relation_id`, `relation_name`, `telephone`, `mobile`, `email`, `created_date`, `last_log_by`) VALUES
(2, 2, 'asdasd', 1, 'Aunt', 'asdasd', 'asdadasd', 'asdasd@gmail.com', '2024-08-14 08:42:44', 2);

--
-- Triggers `employee_emergency_contact`
--
DROP TRIGGER IF EXISTS `employee_emergency_contact_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `employee_emergency_contact_trigger_insert` AFTER INSERT ON `employee_emergency_contact` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Employee emergency contact created. <br/>';

    IF NEW.emergency_contact_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Emergency Contact Name: ", NEW.emergency_contact_name);
    END IF;

    IF NEW.relation_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Relation Name: ", NEW.relation_name);
    END IF;

    IF NEW.telephone <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Telephone: ", NEW.telephone);
    END IF;

    IF NEW.mobile <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Mobile: ", NEW.mobile);
    END IF;

    IF NEW.email <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Email : ", NEW.email);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('employee_emergency_contact', NEW.employee_emergency_contact_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `employee_emergency_contact_trigger_update`;
DELIMITER $$
CREATE TRIGGER `employee_emergency_contact_trigger_update` AFTER UPDATE ON `employee_emergency_contact` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.emergency_contact_name <> OLD.emergency_contact_name THEN
        SET audit_log = CONCAT(audit_log, "Emergency Contact Name: ", OLD.emergency_contact_name, " -> ", NEW.emergency_contact_name, "<br/>");
    END IF;

    IF NEW.relation_name <> OLD.relation_name THEN
        SET audit_log = CONCAT(audit_log, "Relation Name: ", OLD.relation_name, " -> ", NEW.relation_name, "<br/>");
    END IF;

    IF NEW.telephone <> OLD.telephone THEN
        SET audit_log = CONCAT(audit_log, "Telephone: ", OLD.telephone, " -> ", NEW.telephone, "<br/>");
    END IF;

    IF NEW.mobile <> OLD.mobile THEN
        SET audit_log = CONCAT(audit_log, "Mobile: ", OLD.mobile, " -> ", NEW.mobile, "<br/>");
    END IF;

    IF NEW.email <> OLD.email THEN
        SET audit_log = CONCAT(audit_log, "Email: ", OLD.email, " -> ", NEW.email, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('employee_emergency_contact', NEW.employee_emergency_contact_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `employee_experience`
--

DROP TABLE IF EXISTS `employee_experience`;
CREATE TABLE `employee_experience` (
  `employee_experience_id` int(10) UNSIGNED NOT NULL,
  `employee_id` int(10) UNSIGNED NOT NULL,
  `job_title` varchar(100) NOT NULL,
  `employment_type_id` int(10) UNSIGNED DEFAULT NULL,
  `employment_type_name` varchar(100) DEFAULT NULL,
  `company_name` varchar(200) NOT NULL,
  `location` varchar(200) DEFAULT NULL,
  `employment_location_type_id` int(10) UNSIGNED DEFAULT NULL,
  `employment_location_type_name` varchar(100) DEFAULT NULL,
  `start_month` varchar(20) DEFAULT NULL,
  `start_year` varchar(20) DEFAULT NULL,
  `end_month` varchar(20) DEFAULT NULL,
  `end_year` varchar(20) DEFAULT NULL,
  `job_description` varchar(5000) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_experience`
--

INSERT INTO `employee_experience` (`employee_experience_id`, `employee_id`, `job_title`, `employment_type_id`, `employment_type_name`, `company_name`, `location`, `employment_location_type_id`, `employment_location_type_name`, `start_month`, `start_year`, `end_month`, `end_year`, `job_description`, `created_date`, `last_log_by`) VALUES
(11, 2, 'asd', 10, 'Apprentice', 'asdasdasd', 'asdas', 2, 'Hybrid', '10', '2007', '', '', 'asdasdasd', '2024-08-12 13:26:52', 2),
(12, 2, 'asdasd', 9, 'Consultant', 'asdas', 'dasdasd', 2, 'Hybrid', '6', '2007', '', '', 'asdasdsad', '2024-08-12 17:00:27', 2);

--
-- Triggers `employee_experience`
--
DROP TRIGGER IF EXISTS `employee_experience_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `employee_experience_trigger_insert` AFTER INSERT ON `employee_experience` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Employee experience created. <br/>';

    IF NEW.job_title <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Job Title: ", NEW.job_title);
    END IF;

    IF NEW.employment_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Employment Type Name: ", NEW.employment_type_name);
    END IF;

    IF NEW.company_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Company Name: ", NEW.company_name);
    END IF;

    IF NEW.location <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Location: ", NEW.location);
    END IF;

    IF NEW.employment_location_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Employment Location Type Name: ", NEW.employment_location_type_name);
    END IF;

    IF NEW.start_month <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Start Month: ", NEW.start_month);
    END IF;

    IF NEW.start_year <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Start Year: ", NEW.start_year);
    END IF;

    IF NEW.end_month <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>End Month: ", NEW.end_month);
    END IF;

    IF NEW.end_year <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>End Year: ", NEW.end_year);
    END IF;

    IF NEW.job_description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Job Description: ", NEW.job_description);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('employee_experience', NEW.employee_experience_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `employee_experience_trigger_update`;
DELIMITER $$
CREATE TRIGGER `employee_experience_trigger_update` AFTER UPDATE ON `employee_experience` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.job_title <> OLD.job_title THEN
        SET audit_log = CONCAT(audit_log, "Job Title: ", OLD.job_title, " -> ", NEW.job_title, "<br/>");
    END IF;

    IF NEW.employment_type_name <> OLD.employment_type_name THEN
        SET audit_log = CONCAT(audit_log, "Employment Type Name: ", OLD.employment_type_name, " -> ", NEW.employment_type_name, "<br/>");
    END IF;

    IF NEW.company_name <> OLD.company_name THEN
        SET audit_log = CONCAT(audit_log, "Company Name: ", OLD.company_name, " -> ", NEW.company_name, "<br/>");
    END IF;

    IF NEW.location <> OLD.location THEN
        SET audit_log = CONCAT(audit_log, "Location: ", OLD.location, " -> ", NEW.location, "<br/>");
    END IF;

    IF NEW.employment_location_type_name <> OLD.employment_location_type_name THEN
        SET audit_log = CONCAT(audit_log, "Employment Location Type Name: ", OLD.employment_location_type_name, " -> ", NEW.employment_location_type_name, "<br/>");
    END IF;

    IF NEW.start_month <> OLD.start_month THEN
        SET audit_log = CONCAT(audit_log, "Start Month: ", OLD.start_month, " -> ", NEW.start_month, "<br/>");
    END IF;

    IF NEW.start_year <> OLD.start_year THEN
        SET audit_log = CONCAT(audit_log, "Start Year: ", OLD.start_year, " -> ", NEW.start_year, "<br/>");
    END IF;

    IF NEW.end_month <> OLD.end_month THEN
        SET audit_log = CONCAT(audit_log, "End Month: ", OLD.end_month, " -> ", NEW.end_month, "<br/>");
    END IF;

    IF NEW.end_year <> OLD.end_year THEN
        SET audit_log = CONCAT(audit_log, "End Year: ", OLD.end_year, " -> ", NEW.end_year, "<br/>");
    END IF;

    IF NEW.job_description <> OLD.job_description THEN
        SET audit_log = CONCAT(audit_log, "Job Description: ", OLD.job_description, " -> ", NEW.job_description, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('employee_experience', NEW.employee_experience_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `employee_id_record`
--

DROP TABLE IF EXISTS `employee_id_record`;
CREATE TABLE `employee_id_record` (
  `employee_id_record_id` int(10) UNSIGNED NOT NULL,
  `employee_id` int(10) UNSIGNED NOT NULL,
  `id_type_id` int(10) UNSIGNED NOT NULL,
  `id_type_name` varchar(100) NOT NULL,
  `id_number` varchar(100) NOT NULL,
  `issue_date` date NOT NULL,
  `expiration_date` date DEFAULT NULL,
  `issuing_authority` varchar(100) DEFAULT NULL,
  `id_image` varchar(500) DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_id_record`
--

INSERT INTO `employee_id_record` (`employee_id_record_id`, `employee_id`, `id_type_id`, `id_type_name`, `id_number`, `issue_date`, `expiration_date`, `issuing_authority`, `id_image`, `created_date`, `last_log_by`) VALUES
(4, 2, 1, 'Barangay ID', '1656', '2024-08-14', '2024-08-20', 'asdasdas dasdasdasd', './components/employee/image/2/id-record/DdNT.jpg', '2024-08-13 16:16:52', 2);

--
-- Triggers `employee_id_record`
--
DROP TRIGGER IF EXISTS `employee_id_record_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `employee_id_record_trigger_insert` AFTER INSERT ON `employee_id_record` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Employee ID record created. <br/>';

    IF NEW.id_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>ID Type Name: ", NEW.id_type_name);
    END IF;

    IF NEW.id_number <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>ID Number: ", NEW.id_number);
    END IF;

    IF NEW.issue_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Issue Date: ", NEW.issue_date);
    END IF;

    IF NEW.expiration_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Expiration Date: ", NEW.expiration_date);
    END IF;

    IF NEW.issuing_authority <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Issuing Authority: ", NEW.issuing_authority);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('employee_id_record', NEW.employee_id_record_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `employee_id_record_trigger_update`;
DELIMITER $$
CREATE TRIGGER `employee_id_record_trigger_update` AFTER UPDATE ON `employee_id_record` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.id_type_name <> OLD.id_type_name THEN
        SET audit_log = CONCAT(audit_log, "ID Type Name: ", OLD.id_type_name, " -> ", NEW.id_type_name, "<br/>");
    END IF;

    IF NEW.id_number <> OLD.id_number THEN
        SET audit_log = CONCAT(audit_log, "ID Number: ", OLD.id_number, " -> ", NEW.id_number, "<br/>");
    END IF;

    IF NEW.issue_date <> OLD.issue_date THEN
        SET audit_log = CONCAT(audit_log, "Issue Date: ", OLD.issue_date, " -> ", NEW.issue_date, "<br/>");
    END IF;

    IF NEW.expiration_date <> OLD.expiration_date THEN
        SET audit_log = CONCAT(audit_log, "Expiration Date: ", OLD.expiration_date, " -> ", NEW.expiration_date, "<br/>");
    END IF;

    IF NEW.issuing_authority <> OLD.issuing_authority THEN
        SET audit_log = CONCAT(audit_log, "Issuing Authority: ", OLD.issuing_authority, " -> ", NEW.issuing_authority, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('employee_id_record', NEW.employee_id_record_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `employee_language`
--

DROP TABLE IF EXISTS `employee_language`;
CREATE TABLE `employee_language` (
  `employee_language_id` int(10) UNSIGNED NOT NULL,
  `employee_id` int(10) UNSIGNED NOT NULL,
  `language_id` int(11) NOT NULL,
  `language_name` varchar(100) NOT NULL,
  `language_proficiency_id` int(11) NOT NULL,
  `language_proficiency_name` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_language`
--

INSERT INTO `employee_language` (`employee_language_id`, `employee_id`, `language_id`, `language_name`, `language_proficiency_id`, `language_proficiency_name`, `created_date`, `last_log_by`) VALUES
(2, 2, 43, 'Syro-Palestinian Sign Language', 3, 'Conversational', '2024-08-14 09:03:13', 2);

--
-- Triggers `employee_language`
--
DROP TRIGGER IF EXISTS `employee_language_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `employee_language_trigger_insert` AFTER INSERT ON `employee_language` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Employee language created. <br/>';

    IF NEW.language_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Language Name: ", NEW.language_name);
    END IF;

    IF NEW.language_proficiency_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Language Proficiency Name: ", NEW.language_proficiency_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('employee_language', NEW.employee_language_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `employee_language_trigger_update`;
DELIMITER $$
CREATE TRIGGER `employee_language_trigger_update` AFTER UPDATE ON `employee_language` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.language_name <> OLD.language_name THEN
        SET audit_log = CONCAT(audit_log, "Language Name: ", OLD.language_name, " -> ", NEW.language_name, "<br/>");
    END IF;

    IF NEW.language_proficiency_name <> OLD.language_proficiency_name THEN
        SET audit_log = CONCAT(audit_log, "Language Proficiency Name: ", OLD.language_proficiency_name, " -> ", NEW.language_proficiency_name, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('employee_language', NEW.employee_language_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `employee_license`
--

DROP TABLE IF EXISTS `employee_license`;
CREATE TABLE `employee_license` (
  `employee_license_id` int(10) UNSIGNED NOT NULL,
  `employee_id` int(10) UNSIGNED NOT NULL,
  `licensed_profession` varchar(200) NOT NULL,
  `licensing_body` varchar(200) NOT NULL,
  `license_number` varchar(200) NOT NULL,
  `issue_date` date NOT NULL,
  `expiration_date` date DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employee_license`
--

INSERT INTO `employee_license` (`employee_license_id`, `employee_id`, `licensed_profession`, `licensing_body`, `license_number`, `issue_date`, `expiration_date`, `created_date`, `last_log_by`) VALUES
(2, 2, 'asdasd', 'asdasd', 'asdasd', '2024-08-22', '2024-08-28', '2024-08-14 09:02:27', 2);

--
-- Triggers `employee_license`
--
DROP TRIGGER IF EXISTS `employee_license_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `employee_license_trigger_insert` AFTER INSERT ON `employee_license` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Employee license created. <br/>';

    IF NEW.licensed_profession <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Licensed Profession: ", NEW.licensed_profession);
    END IF;

    IF NEW.licensing_body <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Licensing Body: ", NEW.licensing_body);
    END IF;

    IF NEW.license_number <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>License Number: ", NEW.license_number);
    END IF;

    IF NEW.issue_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Issue Date: ", NEW.issue_date);
    END IF;

    IF NEW.expiration_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Expiration Date: ", NEW.expiration_date);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('employee_license', NEW.employee_license_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `employee_license_trigger_update`;
DELIMITER $$
CREATE TRIGGER `employee_license_trigger_update` AFTER UPDATE ON `employee_license` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.licensed_profession <> OLD.licensed_profession THEN
        SET audit_log = CONCAT(audit_log, "Licensed Profession: ", OLD.licensed_profession, " -> ", NEW.licensed_profession, "<br/>");
    END IF;

    IF NEW.licensing_body <> OLD.licensing_body THEN
        SET audit_log = CONCAT(audit_log, "Licensing Body: ", OLD.licensing_body, " -> ", NEW.licensing_body, "<br/>");
    END IF;

    IF NEW.license_number <> OLD.license_number THEN
        SET audit_log = CONCAT(audit_log, "License Number: ", OLD.license_number, " -> ", NEW.license_number, "<br/>");
    END IF;

    IF NEW.issue_date <> OLD.issue_date THEN
        SET audit_log = CONCAT(audit_log, "Issue Date: ", OLD.issue_date, " -> ", NEW.issue_date, "<br/>");
    END IF;

    IF NEW.expiration_date <> OLD.expiration_date THEN
        SET audit_log = CONCAT(audit_log, "Expiration Date: ", OLD.expiration_date, " -> ", NEW.expiration_date, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('employee_license', NEW.employee_license_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `employment_location_type`
--

DROP TABLE IF EXISTS `employment_location_type`;
CREATE TABLE `employment_location_type` (
  `employment_location_type_id` int(10) UNSIGNED NOT NULL,
  `employment_location_type_name` varchar(100) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `employment_location_type`
--

INSERT INTO `employment_location_type` (`employment_location_type_id`, `employment_location_type_name`, `created_date`, `last_log_by`) VALUES
(1, 'On-site', '2024-07-31 09:30:18', 2),
(2, 'Hybrid', '2024-07-31 09:30:30', 2),
(3, 'Remote', '2024-07-31 09:30:39', 2);

--
-- Triggers `employment_location_type`
--
DROP TRIGGER IF EXISTS `employment_location_type_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `employment_location_type_trigger_insert` AFTER INSERT ON `employment_location_type` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Employment location type created. <br/>';

    IF NEW.employment_location_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Employment Location Type Name: ", NEW.employment_location_type_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('employment_location_type', NEW.employment_location_type_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `employment_location_type_trigger_update`;
DELIMITER $$
CREATE TRIGGER `employment_location_type_trigger_update` AFTER UPDATE ON `employment_location_type` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.employment_location_type_name <> OLD.employment_location_type_name THEN
        SET audit_log = CONCAT(audit_log, "Employment Location Type Name: ", OLD.employment_location_type_name, " -> ", NEW.employment_location_type_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('employment_location_type', NEW.employment_location_type_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

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
-- Dumping data for table `employment_type`
--

INSERT INTO `employment_type` (`employment_type_id`, `employment_type_name`, `created_date`, `last_log_by`) VALUES
(1, 'Full-time', '2024-07-09 11:22:08', 2),
(2, 'Part-time', '2024-07-09 11:22:21', 2),
(3, 'Temporary', '2024-07-09 11:23:35', 2),
(4, 'Contract', '2024-07-09 11:23:44', 2),
(5, 'Freelance', '2024-07-09 11:23:51', 2),
(6, 'Internship', '2024-07-09 11:23:56', 2),
(7, 'Seasonal', '2024-07-09 11:24:01', 2),
(8, 'Casual', '2024-07-09 11:24:06', 2),
(9, 'Consultant', '2024-07-09 11:24:13', 2),
(10, 'Apprentice', '2024-07-09 11:24:17', 2),
(11, 'Probationary', '2024-07-09 11:24:22', 2),
(12, 'Volunteer', '2024-07-09 11:24:28', 2),
(13, 'Remote', '2024-07-09 11:24:32', 2),
(14, 'On-call', '2024-07-09 11:24:39', 2);

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
-- Table structure for table `footer`
--

DROP TABLE IF EXISTS `footer`;
CREATE TABLE `footer` (
  `footer_id` int(10) UNSIGNED NOT NULL,
  `footer_name` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `block_style_id` int(10) UNSIGNED NOT NULL,
  `block_style_name` varchar(100) NOT NULL,
  `publish_status` varchar(5) NOT NULL DEFAULT 'No',
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `footer`
--

INSERT INTO `footer` (`footer_id`, `footer_name`, `description`, `block_style_id`, `block_style_name`, `publish_status`, `created_date`, `last_log_by`) VALUES
(1, 'Footer', 'This will be the footer of the website.', 2, 'Footer', 'Yes', '2024-09-06 21:27:19', 2);

--
-- Triggers `footer`
--
DROP TRIGGER IF EXISTS `footer_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `footer_trigger_insert` AFTER INSERT ON `footer` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Footer created. <br/>';

    IF NEW.footer_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Footer Name: ", NEW.footer_name);
    END IF;

    IF NEW.description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.description);
    END IF;

    IF NEW.block_style_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Style Name: ", NEW.block_style_name);
    END IF;

    IF NEW.publish_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Publish Status: ", NEW.publish_status);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('footer', NEW.footer_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `footer_trigger_update`;
DELIMITER $$
CREATE TRIGGER `footer_trigger_update` AFTER UPDATE ON `footer` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.footer_name <> OLD.footer_name THEN
        SET audit_log = CONCAT(audit_log, "Footer Name: ", OLD.footer_name, " -> ", NEW.footer_name, "<br/>");
    END IF;

    IF NEW.description <> OLD.description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.description, " -> ", NEW.description, "<br/>");
    END IF;

    IF NEW.block_style_name <> OLD.block_style_name THEN
        SET audit_log = CONCAT(audit_log, "Block Style Name: ", OLD.block_style_name, " -> ", NEW.block_style_name, "<br/>");
    END IF;

    IF NEW.publish_status <> OLD.publish_status THEN
        SET audit_log = CONCAT(audit_log, "Publish Status: ", OLD.publish_status, " -> ", NEW.publish_status, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('footer', NEW.footer_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

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
-- Table structure for table `header`
--

DROP TABLE IF EXISTS `header`;
CREATE TABLE `header` (
  `header_id` int(10) UNSIGNED NOT NULL,
  `header_name` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `block_style_id` int(10) UNSIGNED NOT NULL,
  `block_style_name` varchar(100) NOT NULL,
  `publish_status` varchar(5) NOT NULL DEFAULT 'No',
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `header`
--

INSERT INTO `header` (`header_id`, `header_name`, `description`, `block_style_id`, `block_style_name`, `publish_status`, `created_date`, `last_log_by`) VALUES
(1, 'Header Navigation', 'This will be the header navigation of the website.', 1, 'Header Navigation', 'Yes', '2024-09-06 20:27:51', 2);

--
-- Triggers `header`
--
DROP TRIGGER IF EXISTS `header_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `header_trigger_insert` AFTER INSERT ON `header` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Header created. <br/>';

    IF NEW.header_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Header Name: ", NEW.header_name);
    END IF;

    IF NEW.description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.description);
    END IF;

    IF NEW.block_style_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Style Name: ", NEW.block_style_name);
    END IF;

    IF NEW.publish_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Publish Status: ", NEW.publish_status);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('header', NEW.header_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `header_trigger_update`;
DELIMITER $$
CREATE TRIGGER `header_trigger_update` AFTER UPDATE ON `header` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.header_name <> OLD.header_name THEN
        SET audit_log = CONCAT(audit_log, "Header Name: ", OLD.header_name, " -> ", NEW.header_name, "<br/>");
    END IF;

    IF NEW.description <> OLD.description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.description, " -> ", NEW.description, "<br/>");
    END IF;

    IF NEW.block_style_name <> OLD.block_style_name THEN
        SET audit_log = CONCAT(audit_log, "Block Style Name: ", OLD.block_style_name, " -> ", NEW.block_style_name, "<br/>");
    END IF;

    IF NEW.publish_status <> OLD.publish_status THEN
        SET audit_log = CONCAT(audit_log, "Publish Status: ", OLD.publish_status, " -> ", NEW.publish_status, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('header', NEW.header_id, audit_log, NEW.last_log_by, NOW());
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
(1, 'Emirates ID', '2024-07-03 10:38:07', 2),
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
-- Table structure for table `image_gallery`
--

DROP TABLE IF EXISTS `image_gallery`;
CREATE TABLE `image_gallery` (
  `image_gallery_id` int(10) UNSIGNED NOT NULL,
  `image_gallery_name` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `block_style_id` int(10) UNSIGNED NOT NULL,
  `block_style_name` varchar(100) NOT NULL,
  `publish_status` varchar(5) NOT NULL DEFAULT 'No',
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `image_gallery`
--
DROP TRIGGER IF EXISTS `image_gallery_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `image_gallery_trigger_insert` AFTER INSERT ON `image_gallery` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Image gallery created. <br/>';

    IF NEW.image_gallery_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Image Gallery Name: ", NEW.image_gallery_name);
    END IF;

    IF NEW.description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.description);
    END IF;

    IF NEW.block_style_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Style Name: ", NEW.block_style_name);
    END IF;

    IF NEW.publish_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Publish Status: ", NEW.publish_status);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('image_gallery', NEW.image_gallery_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `image_gallery_trigger_update`;
DELIMITER $$
CREATE TRIGGER `image_gallery_trigger_update` AFTER UPDATE ON `image_gallery` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.image_gallery_name <> OLD.image_gallery_name THEN
        SET audit_log = CONCAT(audit_log, "Image Gallery Name: ", OLD.image_gallery_name, " -> ", NEW.image_gallery_name, "<br/>");
    END IF;

    IF NEW.description <> OLD.description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.description, " -> ", NEW.description, "<br/>");
    END IF;

    IF NEW.block_style_name <> OLD.block_style_name THEN
        SET audit_log = CONCAT(audit_log, "Block Style Name: ", OLD.block_style_name, " -> ", NEW.block_style_name, "<br/>");
    END IF;

    IF NEW.publish_status <> OLD.publish_status THEN
        SET audit_log = CONCAT(audit_log, "Publish Status: ", OLD.publish_status, " -> ", NEW.publish_status, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('image_gallery', NEW.image_gallery_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `image_gallery_item`
--

DROP TABLE IF EXISTS `image_gallery_item`;
CREATE TABLE `image_gallery_item` (
  `image_gallery_item_id` int(10) UNSIGNED NOT NULL,
  `image_gallery_id` int(10) UNSIGNED NOT NULL,
  `image_gallery_title` varchar(500) NOT NULL,
  `image_gallery_image` varchar(500) NOT NULL,
  `order_sequence` int(11) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `image_gallery_item`
--
DROP TRIGGER IF EXISTS `image_gallery_item_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `image_gallery_item_trigger_insert` AFTER INSERT ON `image_gallery_item` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Image gallery item created. <br/>';

    IF NEW.image_gallery_title <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Image Gallery Title: ", NEW.image_gallery_title);
    END IF;

    IF NEW.order_sequence <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Order Sequence: ", NEW.order_sequence);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('image_gallery_item', NEW.image_gallery_item_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `image_gallery_item_trigger_update`;
DELIMITER $$
CREATE TRIGGER `image_gallery_item_trigger_update` AFTER UPDATE ON `image_gallery_item` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';
    
    IF NEW.image_gallery_title <> OLD.image_gallery_title THEN
        SET audit_log = CONCAT(audit_log, "Image Gallery Title: ", OLD.image_gallery_title, " -> ", NEW.image_gallery_title, "<br/>");
    END IF;
    
    IF NEW.order_sequence <> OLD.order_sequence THEN
        SET audit_log = CONCAT(audit_log, "Order Sequence: ", OLD.order_sequence, " -> ", NEW.order_sequence, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('image_gallery_item', NEW.image_gallery_item_id, audit_log, NEW.last_log_by, NOW());
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
-- Dumping data for table `job_position`
--

INSERT INTO `job_position` (`job_position_id`, `job_position_name`, `created_date`, `last_log_by`) VALUES
(1, 'Data Center Staff', '2024-07-09 11:20:54', 2);

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
(6, 'Employee Configurations', 2, 'Employees', 23, '2024-06-27 17:17:10', 2),
(7, 'Customers', 3, 'Customer', 3, '2024-08-19 10:29:11', 2),
(8, 'Websites', 4, 'Website Studio', 1, '2024-08-23 14:36:06', 2),
(9, 'Website Configurations', 4, 'Website Studio', 90, '2024-08-23 16:25:19', 2),
(10, 'Website Elements', 4, 'Website Studio', 2, '2024-08-26 11:59:34', 2),
(11, 'Booking', 5, 'CRM', 1, '2024-09-02 22:30:28', 2),
(12, 'Customer Service', 5, 'CRM', 3, '2024-09-03 15:33:11', 2),
(13, 'Marketing Centre', 5, 'CRM', 13, '2024-09-03 15:38:59', 2);

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
(32, 'Contact Info Type', 'contact-information-type.php', 'ti ti-device-mobile', 3, 'Configurations', 1, 'Settings', 46, 'Contact Information', 3, '2024-07-02 17:02:55', 2),
(33, 'ID Type', 'id-type.php', 'ti ti-id', 3, 'Configurations', 1, 'Settings', 45, 'User Identity', 9, '2024-07-02 17:05:17', 2),
(34, 'Bank', 'bank.php', 'ti ti-building-bank', 3, 'Configurations', 1, 'Settings', 48, 'Banking Configuration', 2, '2024-07-02 17:06:13', 2),
(35, 'Bank Account Type', 'bank-account-type.php', 'ti ti-building-community', 3, 'Configurations', 1, 'Settings', 48, 'Banking Configuration', 2, '2024-07-02 17:07:16', 2),
(36, 'Relation', 'relation.php', 'ti ti-social', 3, 'Configurations', 1, 'Settings', 45, 'User Identity', 18, '2024-07-02 17:09:40', 2),
(37, 'Educational Stage', 'educational-stage.php', 'ti ti-school', 3, 'Configurations', 1, 'Settings', 45, 'User Identity', 5, '2024-07-02 17:11:54', 2),
(38, 'Language', 'language.php', 'ti ti-language', 3, 'Configurations', 1, 'Settings', 47, 'Language Configurations', 12, '2024-07-02 17:21:10', 2),
(39, 'Language Proficiency', 'language-proficiency.php', 'ti ti-messages', 3, 'Configurations', 1, 'Settings', 47, 'Language Settings', 12, '2024-07-02 17:23:14', 2),
(40, 'Civil Status', 'civil-status.php', 'ti ti-chart-circles', 3, 'Configurations', 1, 'Settings', 45, 'User Identity', 3, '2024-07-02 17:26:17', 2),
(41, 'Gender', 'gender.php', 'ti ti-friends', 3, 'Configurations', 1, 'Settings', 45, 'User Identity', 7, '2024-07-02 17:27:18', 2),
(42, 'Blood Type', 'blood-type.php', 'ti ti-droplet-filled', 3, 'Configurations', 1, 'Settings', 45, 'User Identity', 2, '2024-07-02 17:28:23', 2),
(43, 'Religion', 'religion.php', 'ti ti-building-church', 3, 'Configurations', 1, 'Settings', 45, 'User Identity', 18, '2024-07-02 17:29:10', 2),
(44, 'Address Type', 'address-type.php', 'ti ti-map-2', 3, 'Configurations', 1, 'Settings', 46, 'Contact Information', 1, '2024-07-02 17:30:03', 2),
(45, 'User Identity', '', 'ti ti-friends', 3, 'Configurations', 1, 'Settings', 0, NULL, 21, '2024-07-09 08:54:59', 2),
(46, 'Contact Information', '', 'ti ti-device-mobile', 3, 'Configurations', 1, 'Settings', 0, NULL, 3, '2024-07-09 08:59:29', 2),
(47, 'Language Settings', '', 'ti ti-messages', 3, 'Configurations', 1, 'Settings', NULL, NULL, 12, '2024-07-09 09:02:08', 2),
(48, 'Banking Configuration', '', ' ti ti-building-bank', 3, 'Configurations', 1, 'Settings', 0, NULL, 2, '2024-07-09 09:04:13', 2),
(49, 'Employment Location Type', 'employment-location-type.php', 'ti ti-map-2', 6, 'Employee Configurations', 2, 'Employees', 0, NULL, 5, '2024-07-31 09:01:33', 2),
(50, 'Customer', 'customer.php', ' ti ti-users', 7, 'Customers', 3, 'Customer', 0, NULL, 3, '2024-08-19 10:30:06', 2),
(51, 'My Addresses', 'customer-address.php', 'ti ti-map-pin', 4, 'Profile', 1, 'Settings', NULL, NULL, 13, '2024-08-20 17:00:09', 2),
(52, 'Employee Address', 'employee-address.php', ' ti ti-map-pin', 4, 'Profile', 1, 'Settings', 0, NULL, 5, '2024-08-20 17:06:28', 2),
(53, ' Banks & Cards', 'banks-and-cards.php', 'ti ti-credit-card', 4, 'Profile', 1, 'Settings', 0, NULL, 2, '2024-08-22 16:38:33', 2),
(54, 'Website', 'website.php', 'ti ti-world', 8, 'Websites', 4, 'Website Studio', NULL, NULL, 13, '2024-08-23 14:40:00', 2),
(55, 'Block Type', 'block-type.php', 'ti ti-puzzle', 9, 'Website Configurations', 4, 'Website Studio', 0, NULL, 2, '2024-08-23 16:29:33', 2),
(56, 'Block Style', 'block-style.php', 'ti ti-tools', 9, 'Website Configurations', 4, 'Website Studio', NULL, NULL, 2, '2024-08-24 19:41:28', 2),
(57, 'Accordion', 'accordion.php', 'ti ti-layout-navbar', 10, 'Website Elements', 4, 'Website Studio', NULL, NULL, 1, '2024-08-26 21:47:05', 2),
(58, 'Call to Action', 'call-to-action.php', 'ti ti-speakerphone', 10, 'Website Elements', 4, 'Website Studio', 0, NULL, 3, '2024-08-26 21:51:51', 2),
(59, 'Carousel', 'carousel.php', 'ti ti-layout-sidebar', 10, 'Website Elements', 4, 'Website Studio', 0, NULL, 3, '2024-08-26 22:02:00', 2),
(60, 'Client', 'client.php', 'ti ti-users', 10, 'Website Elements', 4, 'Website Studio', 0, NULL, 3, '2024-08-26 22:13:37', 2),
(61, 'Contact Form', 'contact-form.php', 'ti ti-forms', 10, 'Website Elements', 4, 'Website Studio', 0, NULL, 3, '2024-08-26 22:14:17', 2),
(62, 'Content Carousel', 'content-carousel.php', 'ti ti-layout-align-right', 10, 'Website Elements', 4, 'Website Studio', 0, NULL, 3, '2024-08-26 22:15:30', 2),
(63, 'Footer', 'footer.php', 'ti ti-layout-bottombar', 10, 'Website Elements', 4, 'Website Studio', 0, NULL, 6, '2024-08-26 22:16:21', 2),
(64, 'Header', 'header.php', 'ti ti-layout-navbar', 10, 'Website Elements', 4, 'Website Studio', 0, NULL, 8, '2024-08-26 22:17:09', 2),
(65, 'Image Gallery', 'image-gallery.php', 'ti ti-photo', 10, 'Website Elements', 4, 'Website Studio', 0, NULL, 9, '2024-08-26 22:18:52', 2),
(66, 'Page Title', 'page-title.php', 'ti ti-browser', 10, 'Website Elements', 4, 'Website Studio', 0, NULL, 16, '2024-08-26 22:22:31', 2),
(67, 'Pricing Table', 'pricing-table.php', 'ti ti-ad-2', 10, 'Website Elements', 4, 'Website Studio', 0, NULL, 16, '2024-08-26 22:23:37', 2),
(68, 'Process Step', 'process-step.php', 'ti ti-step-into', 10, 'Website Elements', 4, 'Website Studio', 0, NULL, 16, '2024-08-26 22:24:28', 2),
(69, 'Services Box', 'services-box.php', 'ti ti-subtask', 10, 'Website Elements', 4, 'Website Studio', 0, NULL, 19, '2024-08-26 22:26:40', 2),
(70, 'Slider', 'slider.php', 'ti ti-slideshow', 10, 'Website Elements', 4, 'Website Studio', 0, NULL, 19, '2024-08-26 22:27:17', 2),
(71, 'Testimonial', 'testimonial.php', 'ti ti-message-dots', 10, 'Website Elements', 4, 'Website Studio', 0, NULL, 20, '2024-08-26 22:29:36', 2),
(72, 'Sections', 'sections.php', 'ti ti-section', 10, 'Website Elements', 4, 'Website Studio', 0, NULL, 19, '2024-09-02 21:53:55', 2),
(73, 'My Bookings', 'my-bookings.php', 'ti ti-calendar-time', 11, 'Booking', 5, 'CRM', 0, NULL, 1, '2024-09-02 22:31:14', 2),
(74, 'Customer Inquiry', 'customer-inquiry.php', 'ti ti-messages', 12, 'Customer Service', 5, 'CRM', 0, NULL, 3, '2024-09-03 15:35:40', 2),
(75, 'Voucher', 'voucher.php', 'ti ti-discount-2', 13, 'Marketing Centre', 5, 'CRM', NULL, NULL, 22, '2024-09-03 15:39:55', 2),
(76, 'Cancellation Approval', 'cancellation-approval.php', 'ti ti-calendar-off', 11, 'Booking', 5, 'CRM', 0, NULL, 2, '2024-09-12 14:36:22', 2),
(77, 'Refund Approval', 'refund-approval.php', 'ti ti-arrow-back-up', 11, 'Booking', 5, 'CRM', 0, NULL, 3, '2024-09-12 14:36:58', 2);

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
(2, 'Forgot Password', 'Notification setting when the user initiates forgot password.', 0, 1, 0, '2024-06-27 15:03:26', 2),
(3, 'Registration Verification', 'Notification setting when the user sign-up for an account.', 0, 1, 0, '2024-08-20 22:46:12', 2);

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
(1, 1, 'Login OTP - Secure Access to Your Account', '<p>To ensure the security of your account, we have generated a unique One-Time Password (OTP) for you to use during the login process. Please use the following OTP to access your account:</p>\n<p><br>OTP: <strong>#{OTP_CODE}</strong></p>\n<p><br>Please note that this OTP is valid for &nbsp;<strong>#{OTP_CODE_VALIDITY}</strong>. Once you have logged in successfully, we recommend enabling two-factor authentication for an added layer of security.<br>If you did not initiate this login or believe it was sent to you in error, please disregard this email and delete it immediately. Your account\'s security remains our utmost priority.</p>\n<p>Note: This is an automatically generated email. Please do not reply to this address.</p>', '2024-06-27 15:02:58', 2),
(2, 2, 'Password Reset Request - Action Required', '<p>We received a request to reset your password. To proceed with the password reset, please follow the steps below:</p>\n<ol>\n<li>\n<p>Click on the following link to reset your password:&nbsp; <strong><a href=\"#{RESET_LINK}\">Password Reset Link</a></strong></p>\n</li>\n<li>\n<p>If you did not request this password reset, please ignore this email. Your account remains secure.</p>\n</li>\n</ol>\n<p>Please note that this link is time-sensitive and will expire after <strong>#{RESET_LINK_VALIDITY}</strong>. If you do not reset your password within this timeframe, you may need to request another password reset.</p>\n<p><br>If you did not initiate this password reset request or believe it was sent to you in error, please disregard this email and delete it immediately. Your account\'s security remains our utmost priority.<br><br>Note: This is an automatically generated email. Please do not reply to this address.</p>', '2024-06-27 15:13:04', 2),
(3, 3, 'Sign Up Verification - Action Required', '<p>Thank you for registering! To complete your registration, please verify your email address by clicking the link below:</p>\n<p><a href=\"#{REGISTRATION_VERIFICATION_LINK}\">Click to verify your account</a></p>\n<p>Important: This link is time-sensitive and will expire after #{REGISTRATION_VERIFICATION_VALIDITY}. If you do not verify your email within this timeframe, you may need to request another verification link.</p>\n<p>If you did not register for an account with us, please ignore this email. Your account will not be activated.</p>\n<p>Note: This is an automatically generated email. Please do not reply to this address.</p>', '2024-08-20 22:53:51', 2);

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
-- Table structure for table `page_title`
--

DROP TABLE IF EXISTS `page_title`;
CREATE TABLE `page_title` (
  `page_title_id` int(10) UNSIGNED NOT NULL,
  `page_title_name` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `block_style_id` int(10) UNSIGNED NOT NULL,
  `block_style_name` varchar(100) NOT NULL,
  `page_title` varchar(500) NOT NULL,
  `page_heading` varchar(500) NOT NULL,
  `page_title_image` varchar(500) NOT NULL,
  `publish_status` varchar(5) NOT NULL DEFAULT 'No',
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `page_title`
--

INSERT INTO `page_title` (`page_title_id`, `page_title_name`, `description`, `block_style_id`, `block_style_name`, `page_title`, `page_heading`, `page_title_image`, `publish_status`, `created_date`, `last_log_by`) VALUES
(1, 'About Us Page Title', 'Design for the about us page title.', 10, 'Global Page Title', 'About Us', 'Get to know us', './components/page-title/image/1/yCg8.jpg', 'No', '2024-09-07 00:44:22', 2),
(2, 'Our Services Page Title', 'Design for the our services page title.', 10, 'Global Page Title', 'Our Services', 'TRUSTED CLEANING SERVICES', './components/page-title/image/2/50h8.jpg', 'No', '2024-09-07 11:37:16', 2),
(3, 'House Cleaning Page Title', 'Design for the house cleaning page title.', 10, 'Global Page Title', 'House Cleaning', 'Keep your home spotless with thorough cleaning tailored to your needs', './components/page-title/image/3/1v4Q.jpg', 'No', '2024-09-07 12:26:41', 2),
(4, 'Office Cleaning Page Title', 'Design for the office cleaning page title.', 10, 'Global Page Title', 'Office Cleaning', 'Ensure a clean and productive workspace with our reliable office cleaning services', './components/page-title/image/4/dvjX.jpg', 'No', '2024-09-07 12:40:28', 2),
(5, 'Kitchen Cleaning Page Title', 'Design for kitchen cleaning page title.', 10, 'Global Page Title', 'Kitchen Cleaning', 'Deep cleaning for a hygienic and sparkling kitchen', './components/page-title/image/5/4S4E.jpg', 'No', '2024-09-07 12:47:46', 2),
(6, 'Water Tank Cleaning Page Title', 'Design for water tank page title.', 10, 'Global Page Title', 'Water Tank Cleaning', 'Maintain safe and clean water storage with professional tank cleaning', './components/page-title/image/6/qOXZ.jpg', 'No', '2024-09-07 12:57:01', 2),
(7, 'Window Cleaning Page Title', 'Design for window cleaning page title.', 10, 'Global Page Title', 'Window Cleaning', 'Crystal-clear windows with streak-free, expert cleaning', './components/page-title/image/7/OsuM.jpg', 'No', '2024-09-07 16:15:24', 2),
(8, 'Sofa Cleaning Page Title', 'Design for sofa cleaning page title.', 10, 'Global Page Title', 'Sofa Cleaning', 'Crystal-clear sofas with streak-free, expert cleaning', './components/page-title/image/8/XPrJ.jpg', 'No', '2024-09-07 16:24:25', 2),
(9, 'Carpet Cleaning Page Title', 'Design for carpet cleaning page.', 10, 'Global Page Title', 'Carpet Cleaning', 'Deep cleaning to revive your carpets and eliminate dust, stains, and trapped pollutants', './components/page-title/image/9/qwYz.jpg', 'No', '2024-09-07 16:28:30', 2),
(10, 'Mattress Cleaning Page Title', 'Design for mattress cleaning page title.', 10, 'Global Page Title', 'Mattress Cleaning', 'Comprehensive cleaning to ensure a healthier sleep by removing dust mites, stains, and odors', './components/page-title/image/10/iO1I.jpg', 'No', '2024-09-07 16:32:56', 2),
(11, 'Curtain Cleaning Page Title', 'Design for curtain cleaning page title.', 10, 'Global Page Title', 'Curtain Cleaning', 'Expert cleaning to freshen up your curtains, removing dust and maintaining fabric quality', './components/page-title/image/11/yagC.jpg', 'No', '2024-09-07 16:37:10', 2),
(12, 'Plumbing Service Page Title', 'Design for plumbing service page title.', 10, 'Global Page Title', 'Plumbing Service', 'Quick and efficient plumbing solutions for any issues in your home or office', './components/page-title/image/12/TYSh.jpg', 'No', '2024-09-07 16:43:11', 2),
(13, 'Pest Control Service Page Title', 'Design for pest control service page title.', 10, 'Global Page Title', 'Pest Control Service', 'Effective pest control to keep your space free from unwanted intruders', './components/page-title/image/13/FsTs.jpg', 'No', '2024-09-07 16:51:47', 2),
(14, 'Contact Us Page Title', 'Design  for contact us page title.', 10, 'Global Page Title', 'Contact Us', 'Let\'s work together', './components/page-title/image/14/7zFP.jpg', 'No', '2024-09-07 17:03:18', 2),
(15, 'Booking Page Title', 'Design for booking page title.', 10, 'Global Page Title', 'Booking', 'Dependable cleaning services for any space, large or small', './components/page-title/image/15/449V.jpg', 'No', '2024-09-07 18:40:02', 2);

--
-- Triggers `page_title`
--
DROP TRIGGER IF EXISTS `page_title_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `page_title_trigger_insert` AFTER INSERT ON `page_title` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Page title created. <br/>';

    IF NEW.page_title_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Page Title Name: ", NEW.page_title_name);
    END IF;

    IF NEW.description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.description);
    END IF;

    IF NEW.block_style_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Style Name: ", NEW.block_style_name);
    END IF;

    IF NEW.page_title <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Page Title: ", NEW.page_title);
    END IF;

    IF NEW.page_heading <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Page Heading: ", NEW.page_heading);
    END IF;

    IF NEW.publish_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Publish Status: ", NEW.publish_status);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('page_title', NEW.page_title_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `page_title_trigger_update`;
DELIMITER $$
CREATE TRIGGER `page_title_trigger_update` AFTER UPDATE ON `page_title` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.page_title_name <> OLD.page_title_name THEN
        SET audit_log = CONCAT(audit_log, "Page Title Name: ", OLD.page_title_name, " -> ", NEW.page_title_name, "<br/>");
    END IF;

    IF NEW.description <> OLD.description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.description, " -> ", NEW.description, "<br/>");
    END IF;

    IF NEW.block_style_name <> OLD.block_style_name THEN
        SET audit_log = CONCAT(audit_log, "Block Style Name: ", OLD.block_style_name, " -> ", NEW.block_style_name, "<br/>");
    END IF;

    IF NEW.page_title <> OLD.page_title THEN
        SET audit_log = CONCAT(audit_log, "Page Title: ", OLD.page_title, " -> ", NEW.page_title, "<br/>");
    END IF;

    IF NEW.page_heading <> OLD.page_heading THEN
        SET audit_log = CONCAT(audit_log, "Page Heading: ", OLD.page_heading, " -> ", NEW.page_heading, "<br/>");
    END IF;

    IF NEW.publish_status <> OLD.publish_status THEN
        SET audit_log = CONCAT(audit_log, "Publish Status: ", OLD.publish_status, " -> ", NEW.publish_status, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('page_title', NEW.page_title_id, audit_log, NEW.last_log_by, NOW());
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

--
-- Dumping data for table `password_history`
--

INSERT INTO `password_history` (`password_history_id`, `user_account_id`, `password`, `password_change_date`, `created_date`) VALUES
(1, 8, 'lOfoIcheblgd%2FFe%2FVcWDpKDn6pKmO8PtH4%2F8Jc%2FUxR8%3D', '2024-08-21 10:05:59', '2024-08-21 10:05:59'),
(2, 9, 'ZvLL2Oyok4HT%2BUDzKdB%2FgxZ15dVtJw7JuCzGgpajvZo%3D', '2024-08-21 10:18:07', '2024-08-21 10:18:07'),
(3, 10, 'f5z8%2FE1Kyk4ybslTTF5cAXGmU2qHu9jdPFROv69rtvI%3D', '2024-08-21 14:34:24', '2024-08-21 14:34:24'),
(4, 11, '1ocWXcUotbhscsy175q3TBr7XmZW2qVZFrLP2a6jnuM%3D', '2024-08-21 16:48:18', '2024-08-21 16:48:18'),
(5, 12, '8yxzquTHrvtqWG82aM98iU%2BCanoOa%2Fzu4bqCJyZ70qA%3D', '2024-08-22 10:49:09', '2024-08-22 10:49:09');

-- --------------------------------------------------------

--
-- Table structure for table `pricing_table`
--

DROP TABLE IF EXISTS `pricing_table`;
CREATE TABLE `pricing_table` (
  `pricing_table_id` int(10) UNSIGNED NOT NULL,
  `pricing_table_name` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `block_style_id` int(10) UNSIGNED NOT NULL,
  `block_style_name` varchar(100) NOT NULL,
  `publish_status` varchar(5) NOT NULL DEFAULT 'No',
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `pricing_table`
--
DROP TRIGGER IF EXISTS `pricing_table_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `pricing_table_trigger_insert` AFTER INSERT ON `pricing_table` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Pricing table created. <br/>';

    IF NEW.pricing_table_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Pricing Table Name: ", NEW.pricing_table_name);
    END IF;

    IF NEW.description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.description);
    END IF;

    IF NEW.block_style_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Style Name: ", NEW.block_style_name);
    END IF;

    IF NEW.publish_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Publish Status: ", NEW.publish_status);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('pricing_table', NEW.pricing_table_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `pricing_table_trigger_update`;
DELIMITER $$
CREATE TRIGGER `pricing_table_trigger_update` AFTER UPDATE ON `pricing_table` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.pricing_table_name <> OLD.pricing_table_name THEN
        SET audit_log = CONCAT(audit_log, "Pricing Table Name: ", OLD.pricing_table_name, " -> ", NEW.pricing_table_name, "<br/>");
    END IF;

    IF NEW.description <> OLD.description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.description, " -> ", NEW.description, "<br/>");
    END IF;

    IF NEW.block_style_name <> OLD.block_style_name THEN
        SET audit_log = CONCAT(audit_log, "Block Style Name: ", OLD.block_style_name, " -> ", NEW.block_style_name, "<br/>");
    END IF;

    IF NEW.publish_status <> OLD.publish_status THEN
        SET audit_log = CONCAT(audit_log, "Publish Status: ", OLD.publish_status, " -> ", NEW.publish_status, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('pricing_table', NEW.pricing_table_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `process_step`
--

DROP TABLE IF EXISTS `process_step`;
CREATE TABLE `process_step` (
  `process_step_id` int(10) UNSIGNED NOT NULL,
  `process_step_name` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `block_style_id` int(10) UNSIGNED NOT NULL,
  `block_style_name` varchar(100) NOT NULL,
  `publish_status` varchar(5) NOT NULL DEFAULT 'No',
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `process_step`
--
DROP TRIGGER IF EXISTS `process_step_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `process_step_trigger_insert` AFTER INSERT ON `process_step` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Process step created. <br/>';

    IF NEW.process_step_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Process Step Name: ", NEW.process_step_name);
    END IF;

    IF NEW.description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.description);
    END IF;

    IF NEW.block_style_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Style Name: ", NEW.block_style_name);
    END IF;

    IF NEW.publish_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Publish Status: ", NEW.publish_status);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('process_step', NEW.process_step_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `process_step_trigger_update`;
DELIMITER $$
CREATE TRIGGER `process_step_trigger_update` AFTER UPDATE ON `process_step` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.process_step_name <> OLD.process_step_name THEN
        SET audit_log = CONCAT(audit_log, "Process Step Name: ", OLD.process_step_name, " -> ", NEW.process_step_name, "<br/>");
    END IF;

    IF NEW.description <> OLD.description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.description, " -> ", NEW.description, "<br/>");
    END IF;

    IF NEW.block_style_name <> OLD.block_style_name THEN
        SET audit_log = CONCAT(audit_log, "Block Style Name: ", OLD.block_style_name, " -> ", NEW.block_style_name, "<br/>");
    END IF;

    IF NEW.publish_status <> OLD.publish_status THEN
        SET audit_log = CONCAT(audit_log, "Publish Status: ", OLD.publish_status, " -> ", NEW.publish_status, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('process_step', NEW.process_step_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `process_step_item`
--

DROP TABLE IF EXISTS `process_step_item`;
CREATE TABLE `process_step_item` (
  `process_step_item_id` int(10) UNSIGNED NOT NULL,
  `process_step_id` int(10) UNSIGNED NOT NULL,
  `process_step_title` varchar(500) NOT NULL,
  `process_step_heading` varchar(500) NOT NULL,
  `process_step_link` varchar(500) DEFAULT NULL,
  `process_step_image` varchar(500) NOT NULL,
  `order_sequence` int(11) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Triggers `process_step_item`
--
DROP TRIGGER IF EXISTS `process_step_item_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `process_step_item_trigger_insert` AFTER INSERT ON `process_step_item` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Process step item created. <br/>';

    IF NEW.process_step_title <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Process Step Title: ", NEW.process_step_title);
    END IF;

    IF NEW.process_step_heading <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Process Step Heading: ", NEW.process_step_heading);
    END IF;
    
    IF NEW.process_step_link <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Process Step Link: ", NEW.process_step_link);
    END IF;

    IF NEW.order_sequence <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Order Sequence: ", NEW.order_sequence);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('process_step_item', NEW.process_step_item_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `process_step_item_trigger_update`;
DELIMITER $$
CREATE TRIGGER `process_step_item_trigger_update` AFTER UPDATE ON `process_step_item` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';
    
    IF NEW.process_step_title <> OLD.process_step_title THEN
        SET audit_log = CONCAT(audit_log, "Process Step Title: ", OLD.process_step_title, " -> ", NEW.process_step_title, "<br/>");
    END IF;
    
    IF NEW.process_step_heading <> OLD.process_step_heading THEN
        SET audit_log = CONCAT(audit_log, "Process Step Heading: ", OLD.process_step_heading, " -> ", NEW.process_step_heading, "<br/>");
    END IF;
    
    IF NEW.process_step_link <> OLD.process_step_link THEN
        SET audit_log = CONCAT(audit_log, "Process Step Link: ", OLD.process_step_link, " -> ", NEW.process_step_link, "<br/>");
    END IF;
    
    IF NEW.order_sequence <> OLD.order_sequence THEN
        SET audit_log = CONCAT(audit_log, "Order Sequence: ", OLD.order_sequence, " -> ", NEW.order_sequence, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('process_step_item', NEW.process_step_item_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

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
(1, 'Administrator', 'Full access to all features and data within the system. This role have similar access levels to the Admin but is not as powerful as the Super Admin.', '2024-06-26 14:31:00', 1),
(2, 'Customer', 'Customized access to system features and data, designed to meet the unique requirements and privileges of the Customer role', '2024-08-22 11:14:34', 2);

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
(33, 1, 'Administrator', 32, 'Contact Info Type', 1, 1, 1, 1, '2024-07-02 17:02:59', '2024-07-02 17:02:59', 2),
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
(45, 1, 'Administrator', 44, 'Address Type', 1, 1, 1, 1, '2024-07-02 17:30:07', '2024-07-02 17:30:07', 2),
(46, 1, 'Administrator', 45, 'User Identity', 1, 0, 0, 0, '2024-07-09 08:55:04', '2024-07-09 08:55:04', 2),
(47, 1, 'Administrator', 46, 'Contact Information', 1, 0, 0, 0, '2024-07-09 08:59:33', '2024-07-09 08:59:33', 2),
(48, 1, 'Administrator', 47, 'Language Settings', 1, 0, 0, 0, '2024-07-09 09:02:12', '2024-07-09 09:02:12', 2),
(49, 1, 'Administrator', 48, 'Banking Configuration', 1, 0, 0, 0, '2024-07-09 09:04:17', '2024-07-09 09:04:17', 2),
(50, 1, 'Administrator', 49, 'Employment Location Type', 1, 1, 1, 1, '2024-07-31 09:01:37', '2024-07-31 09:01:37', 2),
(51, 1, 'Administrator', 50, 'Customer', 1, 1, 1, 1, '2024-08-19 10:32:57', '2024-08-19 10:32:57', 2),
(52, 1, 'Administrator', 51, 'My Addresses', 1, 1, 1, 1, '2024-08-20 17:00:14', '2024-08-20 17:00:14', 2),
(53, 1, 'Administrator', 52, 'Employee Address', 1, 1, 1, 1, '2024-08-20 17:06:32', '2024-08-20 17:06:32', 2),
(54, 2, 'Customer', 22, 'Account Setting', 1, 1, 1, 1, '2024-08-22 11:14:55', '2024-08-22 11:14:55', 2),
(55, 2, 'Customer', 51, 'My Addresses', 1, 1, 1, 1, '2024-08-22 11:14:55', '2024-08-22 11:14:55', 2),
(56, 2, 'Customer', 52, 'Employee Address', 1, 1, 1, 1, '2024-08-22 11:14:55', '2024-08-22 11:14:55', 2),
(57, 1, 'Administrator', 53, ' Banks & Cards', 1, 1, 1, 1, '2024-08-22 16:39:16', '2024-08-22 16:39:16', 2),
(58, 2, 'Customer', 53, ' Banks & Cards', 1, 1, 1, 1, '2024-08-22 16:39:16', '2024-08-22 16:39:16', 2),
(59, 1, 'Administrator', 54, 'Website', 1, 1, 1, 1, '2024-08-23 14:40:26', '2024-08-23 14:40:26', 2),
(60, 1, 'Administrator', 55, 'Block Type', 1, 1, 1, 1, '2024-08-23 16:29:39', '2024-08-23 16:29:39', 2),
(61, 1, 'Administrator', 56, 'Block Style', 1, 1, 1, 1, '2024-08-24 19:42:48', '2024-08-24 19:42:48', 2),
(62, 1, 'Administrator', 57, 'Accordion', 1, 1, 1, 1, '2024-08-24 19:52:52', '2024-08-24 19:52:52', 2),
(63, 1, 'Administrator', 58, 'Call to Action', 1, 1, 1, 1, '2024-08-24 20:09:51', '2024-08-24 20:09:51', 2),
(64, 1, 'Administrator', 59, 'Client Style', 1, 1, 1, 1, '2024-08-24 20:16:17', '2024-08-24 20:16:17', 2),
(65, 1, 'Administrator', 60, 'Client', 1, 1, 1, 1, '2024-08-24 21:41:04', '2024-08-24 21:41:04', 2),
(66, 1, 'Administrator', 61, 'Services Box Style', 1, 1, 1, 1, '2024-08-25 13:38:16', '2024-08-25 13:38:16', 2),
(67, 1, 'Administrator', 62, 'Pricing Table Style', 1, 1, 1, 1, '2024-08-26 06:17:35', '2024-08-26 06:17:35', 2),
(68, 1, 'Administrator', 64, 'Image Gallery Style', 1, 1, 1, 1, '2024-08-26 06:25:01', '2024-08-26 06:25:01', 2),
(69, 1, 'Administrator', 63, 'Contact Form Style', 1, 1, 1, 1, '2024-08-26 06:25:10', '2024-08-26 06:25:10', 2),
(70, 1, 'Administrator', 65, 'Process Step Style', 1, 1, 1, 1, '2024-08-26 06:31:40', '2024-08-26 06:31:40', 2),
(71, 1, 'Administrator', 66, 'Slider Style', 1, 1, 1, 1, '2024-08-26 06:32:18', '2024-08-26 06:32:18', 2),
(72, 1, 'Administrator', 67, 'Header Style', 1, 1, 1, 1, '2024-08-26 06:35:08', '2024-08-26 06:35:08', 2),
(73, 1, 'Administrator', 68, 'Footer Style', 1, 1, 1, 1, '2024-08-26 06:36:04', '2024-08-26 06:36:04', 2),
(74, 1, 'Administrator', 69, 'Page Title Style', 1, 1, 1, 1, '2024-08-26 06:37:34', '2024-08-26 06:37:34', 2),
(75, 1, 'Administrator', 70, 'Call To Action Style', 1, 1, 1, 1, '2024-08-26 11:31:00', '2024-08-26 11:31:00', 2),
(76, 1, 'Administrator', 71, 'Testimonial', 1, 1, 1, 1, '2024-08-26 22:29:42', '2024-08-26 22:29:42', 2),
(77, 1, 'Administrator', 72, 'Sections', 1, 1, 1, 1, '2024-09-02 21:54:07', '2024-09-02 21:54:07', 2),
(78, 1, 'Administrator', 73, 'My Bookings', 1, 1, 1, 1, '2024-09-02 22:31:18', '2024-09-02 22:31:18', 2),
(79, 1, 'Administrator', 74, 'Customer Inquiry', 1, 1, 1, 1, '2024-09-03 15:35:44', '2024-09-03 15:35:44', 2),
(80, 1, 'Administrator', 75, 'Voucher', 1, 1, 1, 1, '2024-09-03 15:39:59', '2024-09-03 15:39:59', 2),
(81, 1, 'Administrator', 76, 'Cancellation Approval', 1, 0, 0, 0, '2024-09-12 14:36:32', '2024-09-12 14:36:32', 2),
(82, 1, 'Administrator', 77, 'Refund Approval', 1, 0, 0, 0, '2024-09-12 14:43:44', '2024-09-12 14:43:44', 2);

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
(19, 1, 'Administrator', 19, 'Delete Work Hours', 1, '2024-07-02 10:24:23', '2024-07-02 10:24:23', 2),
(20, 1, 'Administrator', 20, 'Archive Employee', 1, '2024-08-14 09:59:07', '2024-08-14 09:59:07', 2),
(21, 1, 'Administrator', 21, 'Unarchive Employee', 1, '2024-08-14 09:59:29', '2024-08-14 09:59:29', 2),
(22, 1, 'Administrator', 22, 'Archive Customer', 1, '2024-08-20 13:39:05', '2024-08-20 13:39:05', 2),
(23, 1, 'Administrator', 23, 'Unarchive Customer', 1, '2024-08-20 13:39:39', '2024-08-20 13:39:39', 2),
(24, 1, 'Administrator', 24, 'Send Registration Verification Link', 1, '2024-08-21 15:07:43', '2024-08-21 15:07:43', 2),
(25, 1, 'Administrator', 25, 'Verify User Registration', 1, '2024-08-21 15:20:26', '2024-08-21 15:20:26', 2),
(26, 1, 'Administrator', 26, 'Link User Account', 1, '2024-08-21 16:50:05', '2024-08-21 16:50:05', 2),
(27, 1, 'Administrator', 27, 'Unlink User Account', 1, '2024-08-21 20:50:04', '2024-08-21 20:50:04', 2),
(28, 1, 'Administrator', 28, 'Publish Website Element', 1, '2024-08-27 22:04:16', '2024-08-27 22:04:16', 2),
(29, 1, 'Administrator', 29, 'Unpublish Website Element', 1, '2024-08-27 22:04:47', '2024-08-27 22:04:47', 2),
(30, 1, 'Administrator', 30, 'Tag Customer Inquiry As In-Progress', 1, '2024-09-04 11:56:31', '2024-09-04 11:56:31', 2),
(31, 1, 'Administrator', 32, 'Tag Customer Inquiry As Closed', 1, '2024-09-04 12:01:39', '2024-09-04 12:01:39', 2),
(32, 1, 'Administrator', 31, 'Tag Customer Inquiry As Resolved', 1, '2024-09-04 13:58:01', '2024-09-04 13:58:01', 2),
(33, 1, 'Administrator', 33, 'Tag Booking As In-Progress', 1, '2024-09-11 14:31:08', '2024-09-11 14:31:08', 2),
(34, 1, 'Administrator', 35, 'Tag Booking For Cancellation', 1, '2024-09-11 14:32:28', '2024-09-11 14:32:28', 2),
(35, 1, 'Administrator', 36, 'Tag Booking As Cancelled', 1, '2024-09-11 14:33:29', '2024-09-11 14:33:29', 2),
(36, 1, 'Administrator', 34, 'Tag Booking As Complete', 1, '2024-09-11 16:55:51', '2024-09-11 16:55:51', 2),
(37, 1, 'Administrator', 37, 'Tag Booking Payment As Paid', 1, '2024-09-11 21:52:14', '2024-09-11 21:52:14', 2),
(38, 1, 'Administrator', 38, 'Tag Booking Payment As Refunded', 1, '2024-09-11 21:52:36', '2024-09-11 21:52:36', 2),
(39, 1, 'Administrator', 39, 'Tag Booking For Cancellation As Rejected', 1, '2024-09-12 09:11:52', '2024-09-12 09:11:52', 2),
(40, 1, 'Administrator', 40, 'Tag Booking Payment For Refund', 1, '2024-09-12 09:12:27', '2024-09-12 09:12:27', 2),
(41, 1, 'Administrator', 41, 'Tag Booking Payment For Refund As Rejected', 1, '2024-09-12 09:17:07', '2024-09-12 09:17:07', 2);

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
(1, 1, 'Administrator', 2, 'Administrator', '2024-06-26 15:18:35', '2024-06-26 15:18:35', 2),
(2, 2, 'Customer', 10, 'maricris agulto', '2024-08-22 11:58:52', '2024-08-22 11:58:52', 2);

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
-- Table structure for table `sections`
--

DROP TABLE IF EXISTS `sections`;
CREATE TABLE `sections` (
  `sections_id` int(10) UNSIGNED NOT NULL,
  `sections_name` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `block_style_id` int(10) UNSIGNED NOT NULL,
  `block_style_name` varchar(100) NOT NULL,
  `publish_status` varchar(5) NOT NULL DEFAULT 'No',
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `sections`
--

INSERT INTO `sections` (`sections_id`, `sections_name`, `description`, `block_style_id`, `block_style_name`, `publish_status`, `created_date`, `last_log_by`) VALUES
(1, 'About Us Section', 'Design for the about us section.', 11, 'About Us Section', 'No', '2024-09-07 10:45:37', 2),
(2, 'About Us Vision, Mission and Core Values Section', 'Design for the about us vision, mission and core values section.', 12, 'About Us Vision Mission Core Values Section', 'No', '2024-09-07 11:01:17', 2),
(3, 'House Cleaning Section', 'Design for house cleaning section.', 15, 'House Cleaning Section', 'No', '2024-09-07 12:34:23', 2),
(4, 'Office Cleaning Section', 'Design for office cleaning section', 16, 'Office Cleaning Section', 'No', '2024-09-07 12:43:26', 2),
(5, 'Kitchen Cleaning Section', 'Design for kitchen cleaning section.', 17, 'Kitchen Cleaning Section', 'No', '2024-09-07 12:49:08', 2),
(6, 'Water Tank Cleaning Section', 'Design for water tank cleaning section.', 18, 'Water Tank Cleaning Section', 'No', '2024-09-07 12:59:16', 2),
(7, 'Window Cleaning Section', 'Design for window cleaning section.', 19, 'Window Cleaning Section', 'No', '2024-09-07 16:17:48', 2),
(8, 'Sofa Cleaning Section', 'Design for sofa cleaning secion.', 20, 'Sofa Cleaning Section', 'No', '2024-09-07 16:26:43', 2),
(9, 'Carpet Cleaning Section', 'Design for carpet cleaning section.', 21, 'Carpet Cleaning Section', 'No', '2024-09-07 16:29:29', 2),
(10, 'Mattress Cleaning Section', 'Design for mattress cleaning section.', 22, 'Mattress Cleaning Section', 'No', '2024-09-07 16:34:15', 2),
(11, 'Curtain Cleaning Section', 'Design for curtain cleaning section.', 23, 'Curtain Cleaning Section', 'No', '2024-09-07 16:37:56', 2),
(12, 'Plumbing Service Section', 'Design for plumbing service section.', 24, 'Plumbing Service Section', 'No', '2024-09-07 16:44:11', 2),
(13, 'Pest Control Service Section', 'Design for pest control service section.', 25, 'Pest Control Service Section', 'No', '2024-09-07 16:52:42', 2),
(14, 'Contact Us Section', 'Design for contact us section.', 26, 'Contact Us  Section', 'No', '2024-09-07 17:59:46', 2),
(15, 'Contact Us Map Section', 'Design for contact us map section.', 27, 'Contact Us Map Section', 'No', '2024-09-07 18:10:38', 2),
(16, 'Booking Form Section', 'Design for booking form section.', 29, 'Booking Form Section', 'No', '2024-09-12 20:28:53', 2);

--
-- Triggers `sections`
--
DROP TRIGGER IF EXISTS `sections_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `sections_trigger_insert` AFTER INSERT ON `sections` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Sections created. <br/>';

    IF NEW.sections_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Sections Name: ", NEW.sections_name);
    END IF;

    IF NEW.description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.description);
    END IF;

    IF NEW.block_style_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Style Name: ", NEW.block_style_name);
    END IF;

    IF NEW.publish_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Publish Status: ", NEW.publish_status);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('sections', NEW.sections_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `sections_trigger_update`;
DELIMITER $$
CREATE TRIGGER `sections_trigger_update` AFTER UPDATE ON `sections` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.sections_name <> OLD.sections_name THEN
        SET audit_log = CONCAT(audit_log, "Sections Name: ", OLD.sections_name, " -> ", NEW.sections_name, "<br/>");
    END IF;

    IF NEW.description <> OLD.description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.description, " -> ", NEW.description, "<br/>");
    END IF;

    IF NEW.block_style_name <> OLD.block_style_name THEN
        SET audit_log = CONCAT(audit_log, "Block Style Name: ", OLD.block_style_name, " -> ", NEW.block_style_name, "<br/>");
    END IF;

    IF NEW.publish_status <> OLD.publish_status THEN
        SET audit_log = CONCAT(audit_log, "Publish Status: ", OLD.publish_status, " -> ", NEW.publish_status, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('sections', NEW.sections_id, audit_log, NEW.last_log_by, NOW());
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
(1, 'Max Failed Login Attempt', '5', '2024-08-12 08:53:59', 2),
(2, 'Max Failed OTP Attempt', '5', '2024-08-12 08:53:59', 2),
(3, 'Default Forgot Password Link', 'http://localhost/digify2/password-reset.php?id=', '2024-08-12 08:53:59', 2),
(4, 'Password Expiry Duration', '180', '2024-08-12 08:53:59', 2),
(5, 'Session Timeout Duration', '240', '2024-08-12 08:53:59', 2),
(6, 'OTP Duration', '5', '2024-08-12 08:53:59', 2),
(7, 'Reset Password Token Duration', '10', '2024-08-12 08:53:59', 2),
(8, 'Registration Verification Token Duration', '180', '2024-08-20 19:51:46', 2);

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
-- Table structure for table `services_box`
--

DROP TABLE IF EXISTS `services_box`;
CREATE TABLE `services_box` (
  `services_box_id` int(10) UNSIGNED NOT NULL,
  `services_box_name` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `block_style_id` int(10) UNSIGNED NOT NULL,
  `block_style_name` varchar(100) NOT NULL,
  `publish_status` varchar(5) NOT NULL DEFAULT 'No',
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `services_box`
--

INSERT INTO `services_box` (`services_box_id`, `services_box_name`, `description`, `block_style_id`, `block_style_name`, `publish_status`, `created_date`, `last_log_by`) VALUES
(1, 'Home Services Box', 'Design for the services box on the home page.', 7, 'Home Services Box', 'No', '2024-09-06 23:59:59', 2),
(2, 'Our Services Services Box', 'Design for the our services services box.', 14, 'Our Services Services Box', 'No', '2024-09-07 11:43:18', 2);

--
-- Triggers `services_box`
--
DROP TRIGGER IF EXISTS `services_box_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `services_box_trigger_insert` AFTER INSERT ON `services_box` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Services box created. <br/>';

    IF NEW.services_box_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Services Box Name: ", NEW.services_box_name);
    END IF;

    IF NEW.description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.description);
    END IF;

    IF NEW.block_style_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Style Name: ", NEW.block_style_name);
    END IF;

    IF NEW.publish_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Publish Status: ", NEW.publish_status);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('services_box', NEW.services_box_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `services_box_trigger_update`;
DELIMITER $$
CREATE TRIGGER `services_box_trigger_update` AFTER UPDATE ON `services_box` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.services_box_name <> OLD.services_box_name THEN
        SET audit_log = CONCAT(audit_log, "Services Box Name: ", OLD.services_box_name, " -> ", NEW.services_box_name, "<br/>");
    END IF;

    IF NEW.description <> OLD.description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.description, " -> ", NEW.description, "<br/>");
    END IF;

    IF NEW.block_style_name <> OLD.block_style_name THEN
        SET audit_log = CONCAT(audit_log, "Block Style Name: ", OLD.block_style_name, " -> ", NEW.block_style_name, "<br/>");
    END IF;

    IF NEW.publish_status <> OLD.publish_status THEN
        SET audit_log = CONCAT(audit_log, "Publish Status: ", OLD.publish_status, " -> ", NEW.publish_status, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('services_box', NEW.services_box_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `services_box_item`
--

DROP TABLE IF EXISTS `services_box_item`;
CREATE TABLE `services_box_item` (
  `services_box_item_id` int(10) UNSIGNED NOT NULL,
  `services_box_id` int(10) UNSIGNED NOT NULL,
  `services_box_title` varchar(500) NOT NULL,
  `services_box_heading` varchar(500) NOT NULL,
  `services_box_paragraph` longtext NOT NULL,
  `call_to_action_button_text` varchar(100) DEFAULT NULL,
  `call_to_action_button_link` varchar(500) DEFAULT NULL,
  `services_box_image` varchar(500) NOT NULL,
  `order_sequence` int(11) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `services_box_item`
--

INSERT INTO `services_box_item` (`services_box_item_id`, `services_box_id`, `services_box_title`, `services_box_heading`, `services_box_paragraph`, `call_to_action_button_text`, `call_to_action_button_link`, `services_box_image`, `order_sequence`, `created_date`, `last_log_by`) VALUES
(1, 1, 'House Cleaning', 'House Cleaning', 'Keep your home spotless with thorough cleaning tailored to your needs', 'Learn more', 'althabitah.php?page=house_cleaning', './components/services-box/image/1/E0mF.jpg', 1, '2024-09-07 00:01:01', 2),
(2, 1, 'Office Cleaning', 'Office Cleaning', 'Ensure a clean and productive workspace with our reliable office cleaning services', 'Learn more', 'althabitah.php?page=office_cleaning', './components/services-box/image/1/emQ6.jpg', 2, '2024-09-07 00:02:59', 2),
(3, 1, 'Kitchen Cleaning', 'Kitchen Cleaning', 'Deep cleaning for a hygienic and sparkling kitchen', 'Learn more', 'althabitah.php?page=kitchen_cleaning', './components/services-box/image/1/NeqW.jpg', 3, '2024-09-07 00:03:32', 2),
(4, 1, 'Water Tank Cleaning', 'Water Tank Cleaning', 'Maintain safe and clean water storage with professional tank cleaning', 'Learn more', 'althabitah.php?page=water_tank_cleaning', './components/services-box/image/1/GNiQ.jpg', 4, '2024-09-07 00:04:05', 2),
(5, 1, 'Window Cleaning', 'Window Cleaning', 'Crystal-clear windows with streak-free, expert cleaning', 'Learn more', 'althabitah.php?page=window_cleaning', './components/services-box/image/1/zecm.jpg', 5, '2024-09-07 00:04:46', 2),
(6, 1, 'Sofa Cleaning', 'Sofa Cleaning', 'Thorough cleaning to refresh your sofa and remove embedded dirt, stains, and allergens', 'Learn more', 'althabitah.php?page=sofa_cleaning', './components/services-box/image/1/QRfh.jpg', 6, '2024-09-07 00:05:40', 2),
(7, 1, 'Carpet Cleaning', 'Carpet Cleaning', 'Deep cleaning to revive your carpets and eliminate dust, stains, and trapped pollutants', 'Learn more', 'althabitah.php?page=carpet_cleaning', './components/services-box/image/1/zrYG.jpg', 7, '2024-09-07 00:06:19', 2),
(8, 1, 'Mattress Cleaning', 'Mattress Cleaning', 'Comprehensive cleaning to ensure a healthier sleep by removing dust mites, stains, and odors', 'Learn more', 'althabitah.php?page=mattress_cleaning', './components/services-box/image/1/NAYF.jpg', 8, '2024-09-07 00:06:52', 2),
(9, 1, 'Curtain Cleaning', 'Curtain Cleaning', 'Expert cleaning to freshen up your curtains, removing dust and maintaining fabric quality', 'Learn more', 'althabitah.php?page=curtain_cleaning', './components/services-box/image/1/te5Z.jpg', 9, '2024-09-07 00:07:30', 2),
(10, 1, 'Plumbing Service', 'Plumbing Service', 'Quick and efficient plumbing solutions for any issues in your home or office', 'Learn more', 'althabitah.php?page=plumbing_service', './components/services-box/image/1/BDkv.jpg', 10, '2024-09-07 00:08:04', 2),
(11, 1, 'Pest Control Service', 'Pest Control Service', 'Effective pest control to keep your space free from unwanted intruders', 'Learn more', 'althabitah.php?page=pest_control_service', './components/services-box/image/1/sR0R.jpg', 11, '2024-09-07 00:08:38', 2),
(12, 2, 'House Cleaning', 'House Cleaning', 'Keep your home spotless with thorough cleaning tailored to your needs', 'Explore services', 'althabitah.php?page=house_cleaning', './components/services-box/image/2/e0o1.jpg', 1, '2024-09-07 11:44:05', 2),
(13, 2, 'Office Cleaning', 'Office Cleaning', 'Ensure a clean and productive workspace with our reliable office cleaning services', 'Explore services', 'althabitah.php?page=office_cleaning', './components/services-box/image/2/yq1n.jpg', 2, '2024-09-07 11:45:46', 2),
(14, 2, 'Kitchen Cleaning', 'Kitchen Cleaning', 'Deep cleaning for a hygienic and sparkling kitchen', 'Explore services', 'althabitah.php?page=kitchen_cleaning', './components/services-box/image/2/Uuf7.jpg', 3, '2024-09-07 11:46:13', 2),
(15, 2, 'Water Tank Cleaning', 'Water Tank Cleaning', 'Maintain safe and clean water storage with professional tank cleaning', 'Explore services', 'althabitah.php?page=water_tank_cleaning', './components/services-box/image/2/oedu.jpg', 4, '2024-09-07 11:46:35', 2),
(16, 2, 'Window Cleaning', 'Window Cleaning', 'Crystal-clear windows with streak-free, expert cleaning', 'Explore services', 'althabitah.php?page=window_cleaning', './components/services-box/image/2/DiNT.jpg', 5, '2024-09-07 11:47:41', 2),
(17, 2, 'Sofa Cleaning', 'Sofa Cleaning', 'Thorough cleaning to refresh your sofa and remove embedded dirt, stains, and allergens', 'Explore services', 'althabitah.php?page=sofa_cleaning', './components/services-box/image/2/f1MP.jpg', 6, '2024-09-07 11:48:10', 2),
(18, 2, 'Carpet Cleaning', 'Carpet Cleaning', 'Deep cleaning to revive your carpets and eliminate dust, stains, and trapped pollutants', 'Explore services', 'althabitah.php?page=carpet_cleaning', './components/services-box/image/2/eEkd.jpg', 7, '2024-09-07 11:48:32', 2),
(19, 2, 'Mattress Cleaning', 'Mattress Cleaning', 'Comprehensive cleaning to ensure a healthier sleep by removing dust mites, stains, and odors', 'Explore services', 'althabitah.php?page=mattress_cleaning', './components/services-box/image/2/b9AI.jpg', 8, '2024-09-07 11:48:58', 2),
(20, 2, 'Curtain Cleaning', 'Curtain Cleaning', 'Expert cleaning to freshen up your curtains, removing dust and maintaining fabric quality', 'Explore services', 'althabitah.php?page=curtain_cleaning', './components/services-box/image/2/iN7q.jpg', 9, '2024-09-07 11:49:20', 2),
(21, 2, 'Plumbing Service', 'Plumbing Service', 'Quick and efficient plumbing solutions for any issues in your home or office', 'Explore services', 'althabitah.php?page=plumbing_service.php', './components/services-box/image/2/TigZ.jpg', 10, '2024-09-07 11:49:49', 2),
(22, 2, 'Pest Control Service', 'Pest Control Service', 'Effective pest control to keep your space free from unwanted intruders', 'Explore services', 'althabitah.php?page=pest_control_service', './components/services-box/image/2/TjTj.jpg', 11, '2024-09-07 11:50:14', 2);

--
-- Triggers `services_box_item`
--
DROP TRIGGER IF EXISTS `services_box_item_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `services_box_item_trigger_insert` AFTER INSERT ON `services_box_item` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Services box item created. <br/>';

    IF NEW.services_box_title <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Services Box Title: ", NEW.services_box_title);
    END IF;

    IF NEW.services_box_heading <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Services Box Heading: ", NEW.services_box_heading);
    END IF;

    IF NEW.services_box_paragraph <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Services Box Paragraph: ", NEW.services_box_paragraph);
    END IF;

    IF NEW.call_to_action_button_text <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Call-to-Action Button Text: ", NEW.call_to_action_button_text);
    END IF;

    IF NEW.call_to_action_button_link <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Call-to-Action Button Link: ", NEW.call_to_action_button_link);
    END IF;

    IF NEW.order_sequence <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Order Sequence: ", NEW.order_sequence);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('services_box_item', NEW.services_box_item_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `services_box_item_trigger_update`;
DELIMITER $$
CREATE TRIGGER `services_box_item_trigger_update` AFTER UPDATE ON `services_box_item` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';
    
    IF NEW.services_box_title <> OLD.services_box_title THEN
        SET audit_log = CONCAT(audit_log, "Services Box Title: ", OLD.services_box_title, " -> ", NEW.services_box_title, "<br/>");
    END IF;
    
    IF NEW.services_box_heading <> OLD.services_box_heading THEN
        SET audit_log = CONCAT(audit_log, "Services Box Heading: ", OLD.services_box_heading, " -> ", NEW.services_box_heading, "<br/>");
    END IF;
    
    IF NEW.services_box_paragraph <> OLD.services_box_paragraph THEN
        SET audit_log = CONCAT(audit_log, "Services Box Paragraph: ", OLD.services_box_paragraph, " -> ", NEW.services_box_paragraph, "<br/>");
    END IF;
    
    IF NEW.call_to_action_button_text <> OLD.call_to_action_button_text THEN
        SET audit_log = CONCAT(audit_log, "Call-to-Action Button Text: ", OLD.call_to_action_button_text, " -> ", NEW.call_to_action_button_text, "<br/>");
    END IF;

    IF NEW.call_to_action_button_link <> OLD.call_to_action_button_link THEN
        SET audit_log = CONCAT(audit_log, "Call-to-Action Button Link: ", OLD.call_to_action_button_link, " -> ", NEW.call_to_action_button_link, "<br/>");
    END IF;
    
    IF NEW.order_sequence <> OLD.order_sequence THEN
        SET audit_log = CONCAT(audit_log, "Order Sequence: ", OLD.order_sequence, " -> ", NEW.order_sequence, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('services_box_item', NEW.services_box_item_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `slider`
--

DROP TABLE IF EXISTS `slider`;
CREATE TABLE `slider` (
  `slider_id` int(10) UNSIGNED NOT NULL,
  `slider_name` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `block_style_id` int(10) UNSIGNED NOT NULL,
  `block_style_name` varchar(100) NOT NULL,
  `publish_status` varchar(5) NOT NULL DEFAULT 'No',
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `slider`
--

INSERT INTO `slider` (`slider_id`, `slider_name`, `description`, `block_style_id`, `block_style_name`, `publish_status`, `created_date`, `last_log_by`) VALUES
(1, 'Home Page Slider', 'Design for the slider on the home page of the website.', 3, 'Home Page Slider', 'No', '2024-09-06 22:38:26', 2);

--
-- Triggers `slider`
--
DROP TRIGGER IF EXISTS `slider_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `slider_trigger_insert` AFTER INSERT ON `slider` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Slider created. <br/>';

    IF NEW.slider_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Slider Name: ", NEW.slider_name);
    END IF;

    IF NEW.description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.description);
    END IF;

    IF NEW.block_style_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Style Name: ", NEW.block_style_name);
    END IF;

    IF NEW.publish_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Publish Status: ", NEW.publish_status);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('slider', NEW.slider_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `slider_trigger_update`;
DELIMITER $$
CREATE TRIGGER `slider_trigger_update` AFTER UPDATE ON `slider` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.slider_name <> OLD.slider_name THEN
        SET audit_log = CONCAT(audit_log, "Slider Name: ", OLD.slider_name, " -> ", NEW.slider_name, "<br/>");
    END IF;

    IF NEW.description <> OLD.description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.description, " -> ", NEW.description, "<br/>");
    END IF;

    IF NEW.block_style_name <> OLD.block_style_name THEN
        SET audit_log = CONCAT(audit_log, "Block Style Name: ", OLD.block_style_name, " -> ", NEW.block_style_name, "<br/>");
    END IF;

    IF NEW.publish_status <> OLD.publish_status THEN
        SET audit_log = CONCAT(audit_log, "Publish Status: ", OLD.publish_status, " -> ", NEW.publish_status, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('slider', NEW.slider_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `slider_item`
--

DROP TABLE IF EXISTS `slider_item`;
CREATE TABLE `slider_item` (
  `slider_item_id` int(10) UNSIGNED NOT NULL,
  `slider_id` int(10) UNSIGNED NOT NULL,
  `slider_title` varchar(500) NOT NULL,
  `slider_heading` varchar(500) NOT NULL,
  `slider_paragraph` longtext NOT NULL,
  `call_to_action_button_1_text` varchar(100) DEFAULT NULL,
  `call_to_action_button_1_link` varchar(500) DEFAULT NULL,
  `call_to_action_button_2_text` varchar(100) DEFAULT NULL,
  `call_to_action_button_2_link` varchar(500) DEFAULT NULL,
  `slider_image` varchar(500) NOT NULL,
  `order_sequence` int(11) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `slider_item`
--

INSERT INTO `slider_item` (`slider_item_id`, `slider_id`, `slider_title`, `slider_heading`, `slider_paragraph`, `call_to_action_button_1_text`, `call_to_action_button_1_link`, `call_to_action_button_2_text`, `call_to_action_button_2_link`, `slider_image`, `order_sequence`, `created_date`, `last_log_by`) VALUES
(1, 1, 'N/A', 'Exceptional cleaning for your home or office', 'Delivering high-quality cleaning services that meet the unique needs of your home and office', 'Book now', 'althabitah.php?page=booking', 'Learn more', 'althabitah.php?page=our_services', './components/slider/image/1/rPsB.jpg', 1, '2024-09-06 22:42:21', 2),
(2, 1, 'N/A', 'Elevating Cleanliness Standards Across the Region', 'Specialized in creating pristine and welcoming spaces, from residences to businesses', 'Book now', 'althabitah.php?page=booking', 'Learn more', 'althabitah.php?page=our_services', './components/slider/image/1/pGAO.jpg', 2, '2024-09-06 22:43:08', 2),
(3, 1, 'N/A', 'Creating a Spotless Haven for Your Family', 'Trust our dedicated team for thorough, respectful, and efficient home cleaning', 'Book now', 'althabitah.php?page=booking', 'Learn more', 'althabitah.php?page=our_services', './components/slider/image/1/3jQP.jpg', 3, '2024-09-06 22:43:40', 2);

--
-- Triggers `slider_item`
--
DROP TRIGGER IF EXISTS `slider_item_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `slider_item_trigger_insert` AFTER INSERT ON `slider_item` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Slider item created. <br/>';

    IF NEW.slider_title <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Slider Title: ", NEW.slider_title);
    END IF;

    IF NEW.slider_heading <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Slider Heading: ", NEW.slider_heading);
    END IF;

    IF NEW.slider_paragraph <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Slider Paragraph: ", NEW.slider_paragraph);
    END IF;

    IF NEW.call_to_action_button_1_text <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Call-to-Action Button 1 Text: ", NEW.call_to_action_button_1_text);
    END IF;

    IF NEW.call_to_action_button_1_link <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Call-to-Action Button 1 Link: ", NEW.call_to_action_button_1_link);
    END IF;

    IF NEW.call_to_action_button_2_text <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Call-to-Action Button 2 Text: ", NEW.call_to_action_button_2_text);
    END IF;

    IF NEW.call_to_action_button_2_link <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Call-to-Action Button 2 Link: ", NEW.call_to_action_button_2_link);
    END IF;

    IF NEW.order_sequence <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Order Sequence: ", NEW.order_sequence);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('slider_item', NEW.slider_item_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `slider_item_trigger_update`;
DELIMITER $$
CREATE TRIGGER `slider_item_trigger_update` AFTER UPDATE ON `slider_item` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';
    
    IF NEW.slider_title <> OLD.slider_title THEN
        SET audit_log = CONCAT(audit_log, "Slider Title: ", OLD.slider_title, " -> ", NEW.slider_title, "<br/>");
    END IF;
    
    IF NEW.slider_heading <> OLD.slider_heading THEN
        SET audit_log = CONCAT(audit_log, "Slider Heading: ", OLD.slider_heading, " -> ", NEW.slider_heading, "<br/>");
    END IF;
    
    IF NEW.slider_paragraph <> OLD.slider_paragraph THEN
        SET audit_log = CONCAT(audit_log, "Slider Paragraph: ", OLD.slider_paragraph, " -> ", NEW.slider_paragraph, "<br/>");
    END IF;
    
    IF NEW.call_to_action_button_1_text <> OLD.call_to_action_button_1_text THEN
        SET audit_log = CONCAT(audit_log, "Call-to-Action Button 1 Text: ", OLD.call_to_action_button_1_text, " -> ", NEW.call_to_action_button_1_text, "<br/>");
    END IF;

    IF NEW.call_to_action_button_1_link <> OLD.call_to_action_button_1_link THEN
        SET audit_log = CONCAT(audit_log, "Call-to-Action Button 1 Link: ", OLD.call_to_action_button_1_link, " -> ", NEW.call_to_action_button_1_link, "<br/>");
    END IF;
    
    IF NEW.call_to_action_button_2_text <> OLD.call_to_action_button_2_text THEN
        SET audit_log = CONCAT(audit_log, "Call-to-Action Button 2 Text: ", OLD.call_to_action_button_2_text, " -> ", NEW.call_to_action_button_2_text, "<br/>");
    END IF;

    IF NEW.call_to_action_button_2_link <> OLD.call_to_action_button_2_link THEN
        SET audit_log = CONCAT(audit_log, "Call-to-Action Button 2 Link: ", OLD.call_to_action_button_2_link, " -> ", NEW.call_to_action_button_2_link, "<br/>");
    END IF;
    
    IF NEW.order_sequence <> OLD.order_sequence THEN
        SET audit_log = CONCAT(audit_log, "Order Sequence: ", OLD.order_sequence, " -> ", NEW.order_sequence, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('slider_item', NEW.slider_item_id, audit_log, NEW.last_log_by, NOW());
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
(19, 'Delete Work Hours', 'Access to delete the work hours.', '2024-07-02 10:24:19', 2),
(20, 'Archive Employee', 'Access to archive the employee.', '2024-08-14 09:59:03', 2),
(21, 'Unarchive Employee', 'Access to unarchive the employee.', '2024-08-14 09:59:25', 2),
(22, 'Archive Customer', 'Access to archive the customer.', '2024-08-20 13:39:01', 2),
(23, 'Unarchive Customer', 'Access to unarchive the customer.', '2024-08-20 13:39:35', 2),
(24, 'Send Registration Verification Link', 'Access to send the registration verification link to unverified users.', '2024-08-21 15:07:39', 2),
(25, 'Verify User Registration', 'Access to verify unverified users registration.', '2024-08-21 15:20:18', 2),
(26, 'Link User Account', 'Access to link the user account to an employee or customer.', '2024-08-21 16:49:59', 2),
(27, 'Unlink User Account', 'Access to unlink the user account to an employee or customer.', '2024-08-21 16:51:44', 2),
(28, 'Publish Website Element', 'Access to publish the website element.', '2024-08-27 22:04:11', 2),
(29, 'Unpublish Website Element', 'Access to unpublish the website element.', '2024-08-27 22:04:39', 2),
(30, 'Tag Customer Inquiry As In-Progress', 'Access to tag the customer inquiry as in-progress.', '2024-09-04 11:56:26', 2),
(31, 'Tag Customer Inquiry As Resolved', 'Access to tag the customer inquiry as resolved.', '2024-09-04 12:01:00', 2),
(32, 'Tag Customer Inquiry As Closed', 'Access to tag the customer inquiry as closed.', '2024-09-04 12:01:33', 2),
(33, 'Tag Booking As In-Progress', 'Access to tag the booking as in-progress.', '2024-09-11 14:30:13', 2),
(34, 'Tag Booking As Complete', 'Access to tag the booking as complete.', '2024-09-11 14:30:44', 2),
(35, 'Tag Booking For Cancellation', 'Access to tag the booking for cancellation.', '2024-09-11 14:32:24', 2),
(36, 'Tag Booking As Cancelled', 'Access to tag the booking as cancelled.', '2024-09-11 14:33:23', 2),
(37, 'Tag Booking Payment As Paid', 'Access to tag the booking payment as paid.', '2024-09-11 21:51:17', 2),
(38, 'Tag Booking Payment As Refunded', 'Access to tag the booking payment as refunded', '2024-09-11 21:52:30', 2),
(39, 'Tag Booking For Cancellation As Rejected', 'Access to tag the booking for cancellation as rejected.', '2024-09-12 09:11:47', 2),
(40, 'Tag Booking Payment For Refund', 'Access to tag the booking payment as refunded.', '2024-09-12 09:12:23', 2),
(41, 'Tag Booking Payment For Refund As Rejected', 'Access to tag the booking payment for refund as rejected.', '2024-09-12 09:17:02', 2);

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

--
-- Dumping data for table `system_setting`
--

INSERT INTO `system_setting` (`system_setting_id`, `system_setting_name`, `system_setting_description`, `value`, `created_date`, `last_log_by`) VALUES
(1, 'Allow Registration', '', 'Yes', '2024-08-20 20:21:34', 2);

-- --------------------------------------------------------

--
-- Table structure for table `testimonial`
--

DROP TABLE IF EXISTS `testimonial`;
CREATE TABLE `testimonial` (
  `testimonial_id` int(10) UNSIGNED NOT NULL,
  `testimonial_name` varchar(100) NOT NULL,
  `description` varchar(100) NOT NULL,
  `block_style_id` int(10) UNSIGNED NOT NULL,
  `block_style_name` varchar(100) NOT NULL,
  `publish_status` varchar(5) NOT NULL DEFAULT 'No',
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `testimonial`
--

INSERT INTO `testimonial` (`testimonial_id`, `testimonial_name`, `description`, `block_style_id`, `block_style_name`, `publish_status`, `created_date`, `last_log_by`) VALUES
(1, 'About Us Testimonial', 'Design for the about us testimonials.', 13, 'About Us Testimonial', 'No', '2024-09-07 11:08:14', 2);

--
-- Triggers `testimonial`
--
DROP TRIGGER IF EXISTS `testimonial_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `testimonial_trigger_insert` AFTER INSERT ON `testimonial` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Testimonial created. <br/>';

    IF NEW.testimonial_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Testimonial Name: ", NEW.testimonial_name);
    END IF;

    IF NEW.description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.description);
    END IF;

    IF NEW.block_style_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Style Name: ", NEW.block_style_name);
    END IF;

    IF NEW.publish_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Publish Status: ", NEW.publish_status);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('testimonial', NEW.testimonial_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `testimonial_trigger_update`;
DELIMITER $$
CREATE TRIGGER `testimonial_trigger_update` AFTER UPDATE ON `testimonial` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.testimonial_name <> OLD.testimonial_name THEN
        SET audit_log = CONCAT(audit_log, "Testimonial Name: ", OLD.testimonial_name, " -> ", NEW.testimonial_name, "<br/>");
    END IF;

    IF NEW.description <> OLD.description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.description, " -> ", NEW.description, "<br/>");
    END IF;

    IF NEW.block_style_name <> OLD.block_style_name THEN
        SET audit_log = CONCAT(audit_log, "Block Style Name: ", OLD.block_style_name, " -> ", NEW.block_style_name, "<br/>");
    END IF;

    IF NEW.publish_status <> OLD.publish_status THEN
        SET audit_log = CONCAT(audit_log, "Publish Status: ", OLD.publish_status, " -> ", NEW.publish_status, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('testimonial', NEW.testimonial_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `testimonial_item`
--

DROP TABLE IF EXISTS `testimonial_item`;
CREATE TABLE `testimonial_item` (
  `testimonial_item_id` int(10) UNSIGNED NOT NULL,
  `testimonial_id` int(10) UNSIGNED NOT NULL,
  `testimonial_client` varchar(500) NOT NULL,
  `testimonial_title` varchar(500) NOT NULL,
  `testimonial_paragraph` longtext NOT NULL,
  `rating` float DEFAULT NULL,
  `testimonial_image` varchar(500) NOT NULL,
  `order_sequence` int(11) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `testimonial_item`
--

INSERT INTO `testimonial_item` (`testimonial_item_id`, `testimonial_id`, `testimonial_client`, `testimonial_title`, `testimonial_paragraph`, `rating`, `testimonial_image`, `order_sequence`, `created_date`, `last_log_by`) VALUES
(1, 1, 'Alexander harvard', 'N/A', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in orci elit. Duis lobortis gravida quam gravida fermentum. Integer non pharetra leo. Morbi scelerisque augue quis pretium tempus. Nam et magna dui. Cras malesuada dictum lectus, vel ullamcorper neque feugiat et.', 4.5, './components/testimonial/image/1/lAYZ.png', 1, '2024-09-07 11:20:45', 2),
(2, 1, 'Shoko mugikura', 'N/A', 'Magaling silang maglinis', 5, './components/testimonial/image/1/S2Ut.png', 2, '2024-09-07 11:21:15', 2),
(3, 1, 'Leonel mooney', 'N/A', 'Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur in orci elit. Duis lobortis gravida quam gravida fermentum. Integer non pharetra leo. Morbi scelerisque augue quis pretium tempus. Nam et magna dui. Cras malesuada dictum lectus, vel ullamcorper neque feugiat et.', 4.5, './components/testimonial/image/1/4pmi.png', 3, '2024-09-07 11:21:37', 2);

--
-- Triggers `testimonial_item`
--
DROP TRIGGER IF EXISTS `testimonial_item_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `testimonial_item_trigger_insert` AFTER INSERT ON `testimonial_item` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Testimonial item created. <br/>';

    IF NEW.testimonial_client <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Testimonial Client: ", NEW.testimonial_client);
    END IF;

    IF NEW.testimonial_title <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Testimonial Title: ", NEW.testimonial_title);
    END IF;

    IF NEW.testimonial_paragraph <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Testimonial Paragraph: ", NEW.testimonial_paragraph);
    END IF;

    IF NEW.rating <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Rating: ", NEW.rating);
    END IF;

    IF NEW.order_sequence <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Order Sequence: ", NEW.order_sequence);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('testimonial_item', NEW.testimonial_item_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `testimonial_item_trigger_update`;
DELIMITER $$
CREATE TRIGGER `testimonial_item_trigger_update` AFTER UPDATE ON `testimonial_item` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';
    
    IF NEW.testimonial_client <> OLD.testimonial_client THEN
        SET audit_log = CONCAT(audit_log, "Testimonial Client: ", OLD.testimonial_client, " -> ", NEW.testimonial_client, "<br/>");
    END IF;
    
    IF NEW.testimonial_title <> OLD.testimonial_title THEN
        SET audit_log = CONCAT(audit_log, "Testimonial Title: ", OLD.testimonial_title, " -> ", NEW.testimonial_title, "<br/>");
    END IF;
    
    IF NEW.testimonial_paragraph <> OLD.testimonial_paragraph THEN
        SET audit_log = CONCAT(audit_log, "Testimonial Paragraph: ", OLD.testimonial_paragraph, " -> ", NEW.testimonial_paragraph, "<br/>");
    END IF;
    
    IF NEW.rating <> OLD.rating THEN
        SET audit_log = CONCAT(audit_log, "Rating: ", OLD.rating, " -> ", NEW.rating, "<br/>");
    END IF;
    
    IF NEW.order_sequence <> OLD.order_sequence THEN
        SET audit_log = CONCAT(audit_log, "Order Sequence: ", OLD.order_sequence, " -> ", NEW.order_sequence, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('testimonial_item', NEW.testimonial_item_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

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
(1, 2, 'full', 0, 'dark', 'Blue_Theme', 1, '2024-06-26 20:28:22', 2);

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
(2, 'Internal Notes Attachment', 'Sets the upload setting when uploading internal notes attachement.', 800, '2024-06-26 16:34:32', 1),
(3, 'Employee Image', 'Sets the upload setting when uploading employee image.', 800, '2024-07-09 11:08:34', 2),
(4, 'Employee ID Record', 'Sets the upload setting when uploading employee ID record.', 800, '2024-07-09 11:18:55', 2),
(5, 'Website Elements Images', 'Sets the upload setting when uploading website elements image.', 1000, '2024-08-30 10:44:07', 2);

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
(14, 2, 'Internal Notes Attachment', 90, 'PPTX', 'pptx', '2024-06-26 16:38:37', '2024-06-26 16:38:37', 1),
(15, 3, 'Employee Image', 62, 'JPEG', 'jpeg', '2024-07-09 11:08:48', '2024-07-09 11:08:48', 2),
(16, 3, 'Employee Image', 61, 'JPG', 'jpg', '2024-07-09 11:08:48', '2024-07-09 11:08:48', 2),
(17, 3, 'Employee Image', 63, 'PNG', 'png', '2024-07-09 11:08:48', '2024-07-09 11:08:48', 2),
(19, 4, 'Employee ID Record', 62, 'JPEG', 'jpeg', '2024-08-13 09:08:33', '2024-08-13 09:08:33', 2),
(20, 4, 'Employee ID Record', 61, 'JPG', 'jpg', '2024-08-13 09:08:33', '2024-08-13 09:08:33', 2),
(21, 4, 'Employee ID Record', 63, 'PNG', 'png', '2024-08-13 09:08:33', '2024-08-13 09:08:33', 2),
(22, 5, 'Website Elements Images', 62, 'JPEG', 'jpeg', '2024-08-30 10:44:26', '2024-08-30 10:44:26', 2),
(23, 5, 'Website Elements Images', 61, 'JPG', 'jpg', '2024-08-30 10:44:26', '2024-08-30 10:44:26', 2),
(24, 5, 'Website Elements Images', 63, 'PNG', 'png', '2024-08-30 10:44:26', '2024-08-30 10:44:26', 2),
(25, 5, 'Website Elements Images', 66, 'SVG', 'svg', '2024-08-30 10:44:26', '2024-08-30 10:44:26', 2);

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
  `user_type` varchar(20) DEFAULT 'Guest',
  `user_verified` varchar(20) DEFAULT 'No',
  `linked_id` int(10) UNSIGNED DEFAULT NULL,
  `registration_date` datetime DEFAULT NULL,
  `registration_verification_token` varchar(255) DEFAULT NULL,
  `registration_verification_token_expiry_date` datetime DEFAULT NULL,
  `registration_verification_date` datetime DEFAULT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `user_account`
--

INSERT INTO `user_account` (`user_account_id`, `file_as`, `email`, `username`, `password`, `profile_picture`, `locked`, `active`, `last_failed_login_attempt`, `failed_login_attempts`, `last_connection_date`, `password_expiry_date`, `reset_token`, `reset_token_expiry_date`, `receive_notification`, `two_factor_auth`, `otp`, `otp_expiry_date`, `failed_otp_attempts`, `last_password_change`, `account_lock_duration`, `last_password_reset`, `multiple_session`, `session_token`, `user_type`, `user_verified`, `linked_id`, `registration_date`, `registration_verification_token`, `registration_verification_token_expiry_date`, `registration_verification_date`, `created_date`, `last_log_by`) VALUES
(1, 'CGMI Bot', 'cgmibot.317@gmail.com', 'cgmibot', 'RYHObc8sNwIxdPDNJwCsO8bXKZJXYx7RjTgEWMC17FY%3D', NULL, 'No', 'Yes', NULL, 0, NULL, '2025-12-30', NULL, NULL, 'Yes', 'No', NULL, NULL, 0, NULL, 0, NULL, 'Yes', NULL, 'Administrator', 'Yes', NULL, NULL, NULL, NULL, NULL, '2024-08-21 09:45:47', 1),
(2, 'Administrator', 'lawrenceagulto.317@gmail.com', 'ldagulto', 'RYHObc8sNwIxdPDNJwCsO8bXKZJXYx7RjTgEWMC17FY%3D', './components/user-account/image/profile_image/2/HjQG.jpg', 'No', 'Yes', NULL, 0, '2024-09-12 20:01:37', '2025-12-30', 'bi2hXirf%2BQ6cCo6fIklo5ax5USH5Gl41dP2lOSp5yoA%3D', '2024-09-08 19:42:32', 'Yes', 'No', NULL, NULL, 0, NULL, 0, NULL, 'Yes', 'gv7CgvmLLtdyBQDAA8Gh5HC9qVMCDjW5KBpHuNKhmgw%3D', 'Employee', 'Yes', 1, NULL, NULL, NULL, NULL, '2024-08-21 09:45:47', 2),
(9, 'lawrence agulto', 'agulto.lawrence03@gmail.com', 'leagulto', 'ZvLL2Oyok4HT%2BUDzKdB%2FgxZ15dVtJw7JuCzGgpajvZo%3D', NULL, 'No', 'Yes', NULL, 0, '2024-08-21 14:29:13', '2025-02-17', NULL, NULL, 'Yes', 'Yes', 'tXnO3NAhko8MWIZccZ8h9PfP5B08gpJN6Ok8GWr8BpM%3D', '2024-08-21 14:33:54', 0, '2024-08-21 10:18:07', 0, NULL, 'Yes', 'VA9Cx%2BGNgqIFnfRr1ELLQa0tpucWRD%2FROsSoE2w86ao%3D', 'Customer', 'No', 9, '2024-08-21 10:18:07', 'vnB5ikMYmgudd9ds%2Bk3a2jnx49pv0Fca7e4E9LTPVzY%3D', '2023-08-21 14:25:07', '2024-08-21 14:25:07', '2024-08-21 10:18:07', 1),
(10, 'maricris agulto', 'marishein.fashion@gmail.com', 'magulto', 'f5z8%2FE1Kyk4ybslTTF5cAXGmU2qHu9jdPFROv69rtvI%3D', NULL, 'No', 'Yes', NULL, 0, NULL, '2025-02-17', NULL, NULL, 'Yes', 'Yes', NULL, NULL, 0, '2024-08-21 14:34:24', 0, NULL, 'Yes', NULL, 'Customer', 'Yes', 10, '2024-08-21 14:34:24', 'D6b%2BPZ%2BmA4vcaq1BgIuiNN%2FI%2BBxNV7UC5cWaWdbrGgI%3D', '2023-08-22 11:58:52', '2024-08-22 11:58:52', '2024-08-21 14:34:24', 2),
(11, 'test', 'test@gmail.com', 'test', '1ocWXcUotbhscsy175q3TBr7XmZW2qVZFrLP2a6jnuM%3D', NULL, 'No', 'Yes', NULL, 0, NULL, '2025-02-17', NULL, NULL, 'Yes', 'Yes', NULL, NULL, 0, '2024-08-21 16:48:18', 0, NULL, 'Yes', NULL, 'Guest', 'Yes', NULL, NULL, NULL, '2023-08-21 16:58:36', '2024-08-21 16:58:36', '2024-08-21 16:48:18', 1),
(12, 'Asd Asd', 'asd@gmail.com', 'asd', '8yxzquTHrvtqWG82aM98iU%2BCanoOa%2Fzu4bqCJyZ70qA%3D', NULL, 'No', 'No', NULL, 0, NULL, '2025-02-18', NULL, NULL, 'Yes', 'Yes', NULL, NULL, 0, '2024-08-22 10:49:09', 0, NULL, 'Yes', NULL, 'Customer', 'No', 11, '2024-08-22 10:49:09', 'dqPajbSY%2BYCHWHD3R%2F1hg4QynUBv18%2Fd48bT%2Bw371vE%3D', '2024-08-22 13:49:09', NULL, '2024-08-22 10:49:09', 1);

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

    IF NEW.user_type <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>User Type: ", NEW.user_type);
    END IF;


    IF NEW.user_verified <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>User Verified: ", NEW.user_verified);
    END IF;

    IF NEW.registration_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Registration Date: ", NEW.registration_date);
    END IF;

    IF NEW.registration_verification_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Registration Verification Date: ", NEW.registration_verification_date);
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

    IF NEW.user_type <> OLD.user_type THEN
        SET audit_log = CONCAT(audit_log, "User Type: ", OLD.user_type, " -> ", NEW.user_type, "<br/>");
    END IF;

    IF NEW.user_verified <> OLD.user_verified THEN
        SET audit_log = CONCAT(audit_log, "User Verified: ", OLD.user_verified, " -> ", NEW.user_verified, "<br/>");
    END IF;

    IF NEW.registration_date <> OLD.registration_date THEN
        SET audit_log = CONCAT(audit_log, "Registration Date: ", OLD.registration_date, " -> ", NEW.registration_date, "<br/>");
    END IF;

    IF NEW.registration_verification_date <> OLD.registration_verification_date THEN
        SET audit_log = CONCAT(audit_log, "Registration Verification Date: ", OLD.registration_verification_date, " -> ", NEW.registration_verification_date, "<br/>");
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
-- Table structure for table `voucher`
--

DROP TABLE IF EXISTS `voucher`;
CREATE TABLE `voucher` (
  `voucher_id` int(10) UNSIGNED NOT NULL,
  `voucher_name` varchar(100) NOT NULL,
  `voucher_code` varchar(20) NOT NULL,
  `voucher_usage_start_date` date NOT NULL,
  `voucher_usage_end_date` date NOT NULL,
  `discount_type` varchar(20) NOT NULL,
  `discount_amount` double NOT NULL,
  `minimum_booking_amount` double NOT NULL,
  `voucher_quantity` int(11) NOT NULL,
  `available_voucher` int(11) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `voucher`
--

INSERT INTO `voucher` (`voucher_id`, `voucher_name`, `voucher_code`, `voucher_usage_start_date`, `voucher_usage_end_date`, `discount_type`, `discount_amount`, `minimum_booking_amount`, `voucher_quantity`, `available_voucher`, `created_date`, `last_log_by`) VALUES
(3, 'September Promo', 'ALTHABITAHSEPT2024', '2024-09-01', '2024-09-30', 'Fix Amount', 10, 10, 10, 10, '2024-09-08 19:21:44', 2);

--
-- Triggers `voucher`
--
DROP TRIGGER IF EXISTS `voucher_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `voucher_trigger_insert` AFTER INSERT ON `voucher` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Voucher created. <br/>';

    IF NEW.voucher_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Voucher Name: ", NEW.voucher_name);
    END IF;

    IF NEW.voucher_code <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.voucher_code);
    END IF;

    IF NEW.voucher_usage_start_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Voucher Usage Start Date: ", NEW.voucher_usage_start_date);
    END IF;

    IF NEW.voucher_usage_end_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Voucher Usage End Date: ", NEW.voucher_usage_end_date);
    END IF;

    IF NEW.discount_type <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Discount Type: ", NEW.discount_type);
    END IF;

    IF NEW.discount_amount <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Discount Amount: ", NEW.discount_amount);
    END IF;

    IF NEW.minimum_booking_amount <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Minimum Booking Amount: ", NEW.minimum_booking_amount);
    END IF;

    IF NEW.voucher_quantity <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Voucher Quantity: ", NEW.voucher_quantity);
    END IF;

    IF NEW.available_voucher <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Available Voucher: ", NEW.available_voucher);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('voucher', NEW.voucher_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `voucher_trigger_update`;
DELIMITER $$
CREATE TRIGGER `voucher_trigger_update` AFTER UPDATE ON `voucher` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.voucher_name <> OLD.voucher_name THEN
        SET audit_log = CONCAT(audit_log, "Voucher Name: ", OLD.voucher_name, " -> ", NEW.voucher_name, "<br/>");
    END IF;

    IF NEW.voucher_code <> OLD.voucher_code THEN
        SET audit_log = CONCAT(audit_log, "Voucher Code: ", OLD.voucher_code, " -> ", NEW.voucher_code, "<br/>");
    END IF;

    IF NEW.voucher_usage_start_date <> OLD.voucher_usage_start_date THEN
        SET audit_log = CONCAT(audit_log, "Voucher Usage Start Date: ", OLD.voucher_usage_start_date, " -> ", NEW.voucher_usage_start_date, "<br/>");
    END IF;

    IF NEW.voucher_usage_end_date <> OLD.voucher_usage_end_date THEN
        SET audit_log = CONCAT(audit_log, "Voucher Usage End Date: ", OLD.voucher_usage_end_date, " -> ", NEW.voucher_usage_end_date, "<br/>");
    END IF;

    IF NEW.discount_type <> OLD.discount_type THEN
        SET audit_log = CONCAT(audit_log, "Discount Type: ", OLD.discount_type, " -> ", NEW.discount_type, "<br/>");
    END IF;

    IF NEW.discount_amount <> OLD.discount_amount THEN
        SET audit_log = CONCAT(audit_log, "Discount Amount: ", OLD.discount_amount, " -> ", NEW.discount_amount, "<br/>");
    END IF;

    IF NEW.minimum_booking_amount <> OLD.minimum_booking_amount THEN
        SET audit_log = CONCAT(audit_log, "Minimum Booking Amount: ", OLD.minimum_booking_amount, " -> ", NEW.minimum_booking_amount, "<br/>");
    END IF;

    IF NEW.voucher_quantity <> OLD.voucher_quantity THEN
        SET audit_log = CONCAT(audit_log, "Voucher Quantity: ", OLD.voucher_quantity, " -> ", NEW.voucher_quantity, "<br/>");
    END IF;

    IF NEW.available_voucher <> OLD.available_voucher THEN
        SET audit_log = CONCAT(audit_log, "Available Voucher: ", OLD.available_voucher, " -> ", NEW.available_voucher, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('voucher', NEW.voucher_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END
$$
DELIMITER ;

-- --------------------------------------------------------

--
-- Table structure for table `website`
--

DROP TABLE IF EXISTS `website`;
CREATE TABLE `website` (
  `website_id` int(10) UNSIGNED NOT NULL,
  `website_name` varchar(100) NOT NULL,
  `description` varchar(500) DEFAULT NULL,
  `url` varchar(255) NOT NULL,
  `created_date` datetime NOT NULL DEFAULT current_timestamp(),
  `last_log_by` int(10) UNSIGNED NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

--
-- Dumping data for table `website`
--

INSERT INTO `website` (`website_id`, `website_name`, `description`, `url`, `created_date`, `last_log_by`) VALUES
(1, 'Al Thabitah', 'Testasd', 'https://althabitah.com', '2024-08-23 15:41:46', 2);

--
-- Triggers `website`
--
DROP TRIGGER IF EXISTS `website_trigger_insert`;
DELIMITER $$
CREATE TRIGGER `website_trigger_insert` AFTER INSERT ON `website` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT 'Website created. <br/>';

    IF NEW.website_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Website Name: ", NEW.website_name);
    END IF;

    IF NEW.description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.description);
    END IF;

    IF NEW.url <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>URL: ", NEW.url);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('website', NEW.website_id, audit_log, NEW.last_log_by, NOW());
END
$$
DELIMITER ;
DROP TRIGGER IF EXISTS `website_trigger_update`;
DELIMITER $$
CREATE TRIGGER `website_trigger_update` AFTER UPDATE ON `website` FOR EACH ROW BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.website_name <> OLD.website_name THEN
        SET audit_log = CONCAT(audit_log, "Website Name: ", OLD.website_name, " -> ", NEW.website_name, "<br/>");
    END IF;

    IF NEW.description <> OLD.description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.description, " -> ", NEW.description, "<br/>");
    END IF;

    IF NEW.url <> OLD.url THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.url, " -> ", NEW.url, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('website', NEW.website_id, audit_log, NEW.last_log_by, NOW());
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
-- Dumping data for table `work_location`
--

INSERT INTO `work_location` (`work_location_id`, `work_location_name`, `address`, `city_id`, `city_name`, `state_id`, `state_name`, `country_id`, `country_name`, `phone`, `mobile`, `email`, `created_date`, `last_log_by`) VALUES
(1, 'CGMI', 'Km 112', 257, 'City of Cabanatuan', 13, 'Nueva Ecija', 174, 'Philippines', '', '', '', '2024-07-09 11:21:15', 2);

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
-- Dumping data for table `work_schedule`
--

INSERT INTO `work_schedule` (`work_schedule_id`, `work_schedule_name`, `schedule_type_id`, `schedule_type_name`, `created_date`, `last_log_by`) VALUES
(1, 'Regular', 1, 'Fixed', '2024-07-09 11:21:25', 2);

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
-- Indexes for table `accordion`
--
ALTER TABLE `accordion`
  ADD PRIMARY KEY (`accordion_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `accordion_index_accordion_id` (`accordion_id`);

--
-- Indexes for table `accordion_item`
--
ALTER TABLE `accordion_item`
  ADD PRIMARY KEY (`accordion_item_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `accordion_item_index_accordion_item_id` (`accordion_item_id`),
  ADD KEY `accordion_item_index_accordion_id` (`accordion_id`);

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
-- Indexes for table `block_container`
--
ALTER TABLE `block_container`
  ADD PRIMARY KEY (`block_container_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `block_container_index_block_container_id` (`block_container_id`),
  ADD KEY `block_container_index_block_style_id` (`block_style_id`);

--
-- Indexes for table `block_item`
--
ALTER TABLE `block_item`
  ADD PRIMARY KEY (`block_item_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `block_item_index_block_item_id` (`block_item_id`),
  ADD KEY `block_item_index_block_style_id` (`block_style_id`);

--
-- Indexes for table `block_style`
--
ALTER TABLE `block_style`
  ADD PRIMARY KEY (`block_style_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `block_style_index_block_style_id` (`block_style_id`);

--
-- Indexes for table `block_type`
--
ALTER TABLE `block_type`
  ADD PRIMARY KEY (`block_type_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `block_type_index_block_type_id` (`block_type_id`);

--
-- Indexes for table `blood_type`
--
ALTER TABLE `blood_type`
  ADD PRIMARY KEY (`blood_type_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `blood_type_index_blood_type_id` (`blood_type_id`);

--
-- Indexes for table `booking`
--
ALTER TABLE `booking`
  ADD PRIMARY KEY (`booking_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `booking_index_booking_id` (`booking_id`),
  ADD KEY `booking_index_payment_status` (`payment_status`),
  ADD KEY `booking_index_booking_status` (`booking_status`),
  ADD KEY `booking_index_source_of_booking` (`source_of_booking`),
  ADD KEY `booking_index_service` (`service`),
  ADD KEY `booking_index_mode_of_payment` (`mode_of_payment`),
  ADD KEY `booking_index_payment_reference_number` (`payment_reference_number`),
  ADD KEY `booking_index_booking_reference_number` (`booking_reference_number`),
  ADD KEY `booking_index_discount_type` (`discount_type`);

--
-- Indexes for table `call_to_action`
--
ALTER TABLE `call_to_action`
  ADD PRIMARY KEY (`call_to_action_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `call_to_action_index_call_to_action_id` (`call_to_action_id`);

--
-- Indexes for table `carousel`
--
ALTER TABLE `carousel`
  ADD PRIMARY KEY (`carousel_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `carousel_index_carousel_id` (`carousel_id`);

--
-- Indexes for table `carousel_image`
--
ALTER TABLE `carousel_image`
  ADD PRIMARY KEY (`carousel_image_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `carousel_image_index_carousel_image_id` (`carousel_image_id`),
  ADD KEY `carousel_image_index_carousel_id` (`carousel_id`);

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
-- Indexes for table `client`
--
ALTER TABLE `client`
  ADD PRIMARY KEY (`client_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `client_index_client_id` (`client_id`);

--
-- Indexes for table `client_item`
--
ALTER TABLE `client_item`
  ADD PRIMARY KEY (`client_item_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `client_item_index_client_item_id` (`client_item_id`),
  ADD KEY `client_item_index_client_id` (`client_id`);

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
-- Indexes for table `contact_form`
--
ALTER TABLE `contact_form`
  ADD PRIMARY KEY (`contact_form_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `contact_form_index_contact_form_id` (`contact_form_id`);

--
-- Indexes for table `contact_information_type`
--
ALTER TABLE `contact_information_type`
  ADD PRIMARY KEY (`contact_information_type_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `contact_information_type_index_contact_information_type_id` (`contact_information_type_id`);

--
-- Indexes for table `content_carousel`
--
ALTER TABLE `content_carousel`
  ADD PRIMARY KEY (`content_carousel_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `content_carouselindex_content_carousel_id` (`content_carousel_id`);

--
-- Indexes for table `content_carousel_item`
--
ALTER TABLE `content_carousel_item`
  ADD PRIMARY KEY (`content_carousel_item_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `content_carousel_item_index_content_carousel_item_id` (`content_carousel_item_id`),
  ADD KEY `content_carousel_item_index_content_carousel_id` (`content_carousel_id`);

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
-- Indexes for table `customer`
--
ALTER TABLE `customer`
  ADD PRIMARY KEY (`customer_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `customer_index_customer_id` (`customer_id`),
  ADD KEY `customer_index_civil_status_id` (`civil_status_id`),
  ADD KEY `customer_index_gender_id` (`gender_id`),
  ADD KEY `customer_index_customer_status` (`customer_status`);

--
-- Indexes for table `customer_address`
--
ALTER TABLE `customer_address`
  ADD PRIMARY KEY (`customer_address_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `customer_address_index_customer_address_id` (`customer_address_id`),
  ADD KEY `customer_address_index_customer_id` (`customer_id`),
  ADD KEY `customer_address_index_address_type_id` (`address_type_id`),
  ADD KEY `customer_address_index_city_id` (`city_id`),
  ADD KEY `customer_address_index_state_id` (`state_id`),
  ADD KEY `customer_address_index_country_id` (`country_id`),
  ADD KEY `customer_address_index_default_address` (`default_address`);

--
-- Indexes for table `customer_bank_account`
--
ALTER TABLE `customer_bank_account`
  ADD PRIMARY KEY (`customer_bank_account_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `customer_bank_account_index_customer_bank_account_id` (`customer_bank_account_id`),
  ADD KEY `customer_bank_account_index_customer_id` (`customer_id`),
  ADD KEY `customer_bank_account_index_bank_id` (`bank_id`),
  ADD KEY `customer_bank_account_index_bank_account_type_id` (`bank_account_type_id`);

--
-- Indexes for table `customer_bank_card`
--
ALTER TABLE `customer_bank_card`
  ADD PRIMARY KEY (`customer_bank_card_id`),
  ADD KEY `customer_id` (`customer_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `customer_bank_card_index_customer_bank_card_id` (`customer_bank_card_id`),
  ADD KEY `customer_bank_card_index_default_card` (`default_card`);

--
-- Indexes for table `customer_id_record`
--
ALTER TABLE `customer_id_record`
  ADD PRIMARY KEY (`customer_id_record_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `customer_id_record_index_id_record_id` (`customer_id_record_id`),
  ADD KEY `customer_id_record_index_customer_id` (`customer_id`),
  ADD KEY `customer_id_record_index_id_type_id` (`id_type_id`);

--
-- Indexes for table `customer_inquiry`
--
ALTER TABLE `customer_inquiry`
  ADD PRIMARY KEY (`customer_inquiry_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `customer_inquiry_index_customer_inquiry_id` (`customer_inquiry_id`);

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
  ADD KEY `employee_index_blood_type_id` (`blood_type_id`),
  ADD KEY `employee_index_employment_type_id` (`employment_type_id`),
  ADD KEY `employee_index_department_id` (`department_id`),
  ADD KEY `employee_index_job_position_id` (`job_position_id`),
  ADD KEY `employee_index_manager_id` (`manager_id`),
  ADD KEY `employee_index_work_schedule_id` (`work_schedule_id`),
  ADD KEY `employee_index_work_location_id` (`work_location_id`),
  ADD KEY `employee_index_departure_reason_id` (`departure_reason_id`),
  ADD KEY `employee_index_employment_status` (`employment_status`);

--
-- Indexes for table `employee_address`
--
ALTER TABLE `employee_address`
  ADD PRIMARY KEY (`employee_address_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `employee_address_index_employee_address_id` (`employee_address_id`),
  ADD KEY `employee_address_index_employee_id` (`employee_id`),
  ADD KEY `employee_address_index_address_type_id` (`address_type_id`),
  ADD KEY `employee_address_index_city_id` (`city_id`),
  ADD KEY `employee_address_index_state_id` (`state_id`),
  ADD KEY `employee_address_index_country_id` (`country_id`),
  ADD KEY `employee_address_index_default_address` (`default_address`);

--
-- Indexes for table `employee_bank_account`
--
ALTER TABLE `employee_bank_account`
  ADD PRIMARY KEY (`employee_bank_account_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `employee_bank_account_index_employee_bank_account_id` (`employee_bank_account_id`),
  ADD KEY `employee_bank_account_index_employee_id` (`employee_id`),
  ADD KEY `employee_bank_account_index_bank_id` (`bank_id`),
  ADD KEY `employee_bank_account_index_bank_account_type_id` (`bank_account_type_id`);

--
-- Indexes for table `employee_education`
--
ALTER TABLE `employee_education`
  ADD PRIMARY KEY (`employee_education_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `employee_education_index_employee_education_id` (`employee_education_id`),
  ADD KEY `employee_education_index_employee_employee_id` (`employee_id`);

--
-- Indexes for table `employee_emergency_contact`
--
ALTER TABLE `employee_emergency_contact`
  ADD PRIMARY KEY (`employee_emergency_contact_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `employee_emergency_contact_index_emergency_contact_id` (`employee_emergency_contact_id`),
  ADD KEY `employee_emergency_contact_index_employee_id` (`employee_id`),
  ADD KEY `employee_emergency_contact_index_relation_id` (`relation_id`);

--
-- Indexes for table `employee_experience`
--
ALTER TABLE `employee_experience`
  ADD PRIMARY KEY (`employee_experience_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `employee_experience_index_employee_experience_id` (`employee_experience_id`),
  ADD KEY `employee_experience_index_employee_employee_id` (`employee_id`),
  ADD KEY `employee_experience_index_employee_employment_type_id` (`employment_type_id`),
  ADD KEY `employee_experience_index_employee_lNocation_type_id` (`employment_location_type_id`);

--
-- Indexes for table `employee_id_record`
--
ALTER TABLE `employee_id_record`
  ADD PRIMARY KEY (`employee_id_record_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `employee_id_record_index_id_record_id` (`employee_id_record_id`),
  ADD KEY `employee_id_record_index_employee_id` (`employee_id`),
  ADD KEY `employee_id_record_index_id_type_id` (`id_type_id`);

--
-- Indexes for table `employee_language`
--
ALTER TABLE `employee_language`
  ADD PRIMARY KEY (`employee_language_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `employee_language_index_employee_language_id` (`employee_language_id`),
  ADD KEY `employee_language_index_employee_id` (`employee_id`),
  ADD KEY `employee_language_index_language_id` (`language_id`),
  ADD KEY `employee_language_index_language_proficiency_id` (`language_proficiency_id`);

--
-- Indexes for table `employee_license`
--
ALTER TABLE `employee_license`
  ADD PRIMARY KEY (`employee_license_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `employee_license_index_license_id` (`employee_license_id`),
  ADD KEY `employee_license_index_employee_id` (`employee_id`);

--
-- Indexes for table `employment_location_type`
--
ALTER TABLE `employment_location_type`
  ADD PRIMARY KEY (`employment_location_type_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `employment_location_type_index_employment_location_type_id` (`employment_location_type_id`);

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
-- Indexes for table `footer`
--
ALTER TABLE `footer`
  ADD PRIMARY KEY (`footer_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `footer_index_footer_id` (`footer_id`);

--
-- Indexes for table `gender`
--
ALTER TABLE `gender`
  ADD PRIMARY KEY (`gender_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `gender_index_gender_id` (`gender_id`);

--
-- Indexes for table `header`
--
ALTER TABLE `header`
  ADD PRIMARY KEY (`header_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `header_index_header_id` (`header_id`);

--
-- Indexes for table `id_type`
--
ALTER TABLE `id_type`
  ADD PRIMARY KEY (`id_type_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `id_type_index_id_type_id` (`id_type_id`);

--
-- Indexes for table `image_gallery`
--
ALTER TABLE `image_gallery`
  ADD PRIMARY KEY (`image_gallery_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `image_galleryindex_image_gallery_id` (`image_gallery_id`);

--
-- Indexes for table `image_gallery_item`
--
ALTER TABLE `image_gallery_item`
  ADD PRIMARY KEY (`image_gallery_item_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `image_gallery_item_index_image_gallery_item_id` (`image_gallery_item_id`),
  ADD KEY `image_gallery_item_index_image_gallery_id` (`image_gallery_id`);

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
-- Indexes for table `page_title`
--
ALTER TABLE `page_title`
  ADD PRIMARY KEY (`page_title_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `page_titleindex_page_title_id` (`page_title_id`);

--
-- Indexes for table `password_history`
--
ALTER TABLE `password_history`
  ADD PRIMARY KEY (`password_history_id`),
  ADD KEY `password_history_index_password_history_id` (`password_history_id`),
  ADD KEY `password_history_index_user_account_id` (`user_account_id`);

--
-- Indexes for table `pricing_table`
--
ALTER TABLE `pricing_table`
  ADD PRIMARY KEY (`pricing_table_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `pricing_tableindex_pricing_table_id` (`pricing_table_id`);

--
-- Indexes for table `process_step`
--
ALTER TABLE `process_step`
  ADD PRIMARY KEY (`process_step_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `process_stepindex_process_step_id` (`process_step_id`);

--
-- Indexes for table `process_step_item`
--
ALTER TABLE `process_step_item`
  ADD PRIMARY KEY (`process_step_item_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `process_step_item_index_process_step_item_id` (`process_step_item_id`),
  ADD KEY `process_step_item_index_process_step_id` (`process_step_id`);

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
-- Indexes for table `sections`
--
ALTER TABLE `sections`
  ADD PRIMARY KEY (`sections_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `sections_index_sections_id` (`sections_id`);

--
-- Indexes for table `security_setting`
--
ALTER TABLE `security_setting`
  ADD PRIMARY KEY (`security_setting_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `security_setting_index_security_setting_id` (`security_setting_id`);

--
-- Indexes for table `services_box`
--
ALTER TABLE `services_box`
  ADD PRIMARY KEY (`services_box_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `services_boxindex_services_box_id` (`services_box_id`);

--
-- Indexes for table `services_box_item`
--
ALTER TABLE `services_box_item`
  ADD PRIMARY KEY (`services_box_item_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `services_box_item_index_services_box_item_id` (`services_box_item_id`),
  ADD KEY `services_box_item_index_services_box_id` (`services_box_id`);

--
-- Indexes for table `slider`
--
ALTER TABLE `slider`
  ADD PRIMARY KEY (`slider_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `sliderindex_slider_id` (`slider_id`);

--
-- Indexes for table `slider_item`
--
ALTER TABLE `slider_item`
  ADD PRIMARY KEY (`slider_item_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `slider_item_index_slider_item_id` (`slider_item_id`),
  ADD KEY `slider_item_index_slider_id` (`slider_id`);

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
-- Indexes for table `testimonial`
--
ALTER TABLE `testimonial`
  ADD PRIMARY KEY (`testimonial_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `testimonialindex_testimonial_id` (`testimonial_id`);

--
-- Indexes for table `testimonial_item`
--
ALTER TABLE `testimonial_item`
  ADD PRIMARY KEY (`testimonial_item_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `testimonial_item_index_testimonial_item_id` (`testimonial_item_id`),
  ADD KEY `testimonial_item_index_testimonial_id` (`testimonial_id`);

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
-- Indexes for table `voucher`
--
ALTER TABLE `voucher`
  ADD PRIMARY KEY (`voucher_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `voucher_index_voucher_id` (`voucher_id`);

--
-- Indexes for table `website`
--
ALTER TABLE `website`
  ADD PRIMARY KEY (`website_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `website_index_website_id` (`website_id`);

--
-- Indexes for table `work_hours`
--
ALTER TABLE `work_hours`
  ADD PRIMARY KEY (`work_hours_id`),
  ADD KEY `last_log_by` (`last_log_by`),
  ADD KEY `work_schedule_id` (`work_schedule_id`),
  ADD KEY `work_hours_index_work_hours_id` (`work_hours_id`);

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
-- AUTO_INCREMENT for table `accordion`
--
ALTER TABLE `accordion`
  MODIFY `accordion_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `accordion_item`
--
ALTER TABLE `accordion_item`
  MODIFY `accordion_item_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `address_type`
--
ALTER TABLE `address_type`
  MODIFY `address_type_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `app_module`
--
ALTER TABLE `app_module`
  MODIFY `app_module_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `audit_log`
--
ALTER TABLE `audit_log`
  MODIFY `audit_log_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

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
-- AUTO_INCREMENT for table `block_container`
--
ALTER TABLE `block_container`
  MODIFY `block_container_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `block_item`
--
ALTER TABLE `block_item`
  MODIFY `block_item_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `block_style`
--
ALTER TABLE `block_style`
  MODIFY `block_style_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=30;

--
-- AUTO_INCREMENT for table `block_type`
--
ALTER TABLE `block_type`
  MODIFY `block_type_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `blood_type`
--
ALTER TABLE `blood_type`
  MODIFY `blood_type_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `booking`
--
ALTER TABLE `booking`
  MODIFY `booking_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=11;

--
-- AUTO_INCREMENT for table `call_to_action`
--
ALTER TABLE `call_to_action`
  MODIFY `call_to_action_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `carousel`
--
ALTER TABLE `carousel`
  MODIFY `carousel_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `carousel_image`
--
ALTER TABLE `carousel_image`
  MODIFY `carousel_image_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `city`
--
ALTER TABLE `city`
  MODIFY `city_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `civil_status`
--
ALTER TABLE `civil_status`
  MODIFY `civil_status_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `client`
--
ALTER TABLE `client`
  MODIFY `client_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `client_item`
--
ALTER TABLE `client_item`
  MODIFY `client_item_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `company`
--
ALTER TABLE `company`
  MODIFY `company_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `contact_form`
--
ALTER TABLE `contact_form`
  MODIFY `contact_form_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `contact_information_type`
--
ALTER TABLE `contact_information_type`
  MODIFY `contact_information_type_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `content_carousel`
--
ALTER TABLE `content_carousel`
  MODIFY `content_carousel_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `content_carousel_item`
--
ALTER TABLE `content_carousel_item`
  MODIFY `content_carousel_item_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `country`
--
ALTER TABLE `country`
  MODIFY `country_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=251;

--
-- AUTO_INCREMENT for table `currency`
--
ALTER TABLE `currency`
  MODIFY `currency_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=58;

--
-- AUTO_INCREMENT for table `customer`
--
ALTER TABLE `customer`
  MODIFY `customer_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=12;

--
-- AUTO_INCREMENT for table `customer_address`
--
ALTER TABLE `customer_address`
  MODIFY `customer_address_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `customer_bank_account`
--
ALTER TABLE `customer_bank_account`
  MODIFY `customer_bank_account_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `customer_bank_card`
--
ALTER TABLE `customer_bank_card`
  MODIFY `customer_bank_card_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=8;

--
-- AUTO_INCREMENT for table `customer_id_record`
--
ALTER TABLE `customer_id_record`
  MODIFY `customer_id_record_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `customer_inquiry`
--
ALTER TABLE `customer_inquiry`
  MODIFY `customer_inquiry_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `department`
--
ALTER TABLE `department`
  MODIFY `department_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `departure_reason`
--
ALTER TABLE `departure_reason`
  MODIFY `departure_reason_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

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
  MODIFY `employee_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `employee_address`
--
ALTER TABLE `employee_address`
  MODIFY `employee_address_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `employee_bank_account`
--
ALTER TABLE `employee_bank_account`
  MODIFY `employee_bank_account_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `employee_education`
--
ALTER TABLE `employee_education`
  MODIFY `employee_education_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `employee_emergency_contact`
--
ALTER TABLE `employee_emergency_contact`
  MODIFY `employee_emergency_contact_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `employee_experience`
--
ALTER TABLE `employee_experience`
  MODIFY `employee_experience_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `employee_id_record`
--
ALTER TABLE `employee_id_record`
  MODIFY `employee_id_record_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5;

--
-- AUTO_INCREMENT for table `employee_language`
--
ALTER TABLE `employee_language`
  MODIFY `employee_language_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `employee_license`
--
ALTER TABLE `employee_license`
  MODIFY `employee_license_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `employment_location_type`
--
ALTER TABLE `employment_location_type`
  MODIFY `employment_location_type_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `employment_type`
--
ALTER TABLE `employment_type`
  MODIFY `employment_type_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=15;

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
-- AUTO_INCREMENT for table `footer`
--
ALTER TABLE `footer`
  MODIFY `footer_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `gender`
--
ALTER TABLE `gender`
  MODIFY `gender_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `header`
--
ALTER TABLE `header`
  MODIFY `header_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `id_type`
--
ALTER TABLE `id_type`
  MODIFY `id_type_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=19;

--
-- AUTO_INCREMENT for table `image_gallery`
--
ALTER TABLE `image_gallery`
  MODIFY `image_gallery_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `image_gallery_item`
--
ALTER TABLE `image_gallery_item`
  MODIFY `image_gallery_item_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

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
  MODIFY `job_position_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

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
  MODIFY `menu_group_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=14;

--
-- AUTO_INCREMENT for table `menu_item`
--
ALTER TABLE `menu_item`
  MODIFY `menu_item_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=78;

--
-- AUTO_INCREMENT for table `notification_setting`
--
ALTER TABLE `notification_setting`
  MODIFY `notification_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `notification_setting_email_template`
--
ALTER TABLE `notification_setting_email_template`
  MODIFY `notification_setting_email_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

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
-- AUTO_INCREMENT for table `page_title`
--
ALTER TABLE `page_title`
  MODIFY `page_title_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=16;

--
-- AUTO_INCREMENT for table `password_history`
--
ALTER TABLE `password_history`
  MODIFY `password_history_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `pricing_table`
--
ALTER TABLE `pricing_table`
  MODIFY `pricing_table_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `process_step`
--
ALTER TABLE `process_step`
  MODIFY `process_step_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `process_step_item`
--
ALTER TABLE `process_step_item`
  MODIFY `process_step_item_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

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
  MODIFY `role_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `role_permission`
--
ALTER TABLE `role_permission`
  MODIFY `role_permission_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=83;

--
-- AUTO_INCREMENT for table `role_system_action_permission`
--
ALTER TABLE `role_system_action_permission`
  MODIFY `role_system_action_permission_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `role_user_account`
--
ALTER TABLE `role_user_account`
  MODIFY `role_user_account_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `schedule_type`
--
ALTER TABLE `schedule_type`
  MODIFY `schedule_type_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `sections`
--
ALTER TABLE `sections`
  MODIFY `sections_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=17;

--
-- AUTO_INCREMENT for table `security_setting`
--
ALTER TABLE `security_setting`
  MODIFY `security_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=9;

--
-- AUTO_INCREMENT for table `services_box`
--
ALTER TABLE `services_box`
  MODIFY `services_box_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=3;

--
-- AUTO_INCREMENT for table `services_box_item`
--
ALTER TABLE `services_box_item`
  MODIFY `services_box_item_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=23;

--
-- AUTO_INCREMENT for table `slider`
--
ALTER TABLE `slider`
  MODIFY `slider_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `slider_item`
--
ALTER TABLE `slider_item`
  MODIFY `slider_item_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `state`
--
ALTER TABLE `state`
  MODIFY `state_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=5235;

--
-- AUTO_INCREMENT for table `system_action`
--
ALTER TABLE `system_action`
  MODIFY `system_action_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=42;

--
-- AUTO_INCREMENT for table `system_setting`
--
ALTER TABLE `system_setting`
  MODIFY `system_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `testimonial`
--
ALTER TABLE `testimonial`
  MODIFY `testimonial_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `testimonial_item`
--
ALTER TABLE `testimonial_item`
  MODIFY `testimonial_item_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `ui_customization_setting`
--
ALTER TABLE `ui_customization_setting`
  MODIFY `ui_customization_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `upload_setting`
--
ALTER TABLE `upload_setting`
  MODIFY `upload_setting_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=6;

--
-- AUTO_INCREMENT for table `upload_setting_file_extension`
--
ALTER TABLE `upload_setting_file_extension`
  MODIFY `upload_setting_file_extension_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=26;

--
-- AUTO_INCREMENT for table `user_account`
--
ALTER TABLE `user_account`
  MODIFY `user_account_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=13;

--
-- AUTO_INCREMENT for table `voucher`
--
ALTER TABLE `voucher`
  MODIFY `voucher_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=4;

--
-- AUTO_INCREMENT for table `website`
--
ALTER TABLE `website`
  MODIFY `website_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `work_hours`
--
ALTER TABLE `work_hours`
  MODIFY `work_hours_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT;

--
-- AUTO_INCREMENT for table `work_location`
--
ALTER TABLE `work_location`
  MODIFY `work_location_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- AUTO_INCREMENT for table `work_schedule`
--
ALTER TABLE `work_schedule`
  MODIFY `work_schedule_id` int(10) UNSIGNED NOT NULL AUTO_INCREMENT, AUTO_INCREMENT=2;

--
-- Constraints for dumped tables
--

--
-- Constraints for table `accordion`
--
ALTER TABLE `accordion`
  ADD CONSTRAINT `accordion_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `accordion_item`
--
ALTER TABLE `accordion_item`
  ADD CONSTRAINT `accordion_item_ibfk_1` FOREIGN KEY (`accordion_id`) REFERENCES `accordion` (`accordion_id`),
  ADD CONSTRAINT `accordion_item_ibfk_2` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

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
-- Constraints for table `block_container`
--
ALTER TABLE `block_container`
  ADD CONSTRAINT `block_container_ibfk_1` FOREIGN KEY (`block_style_id`) REFERENCES `block_style` (`block_style_id`),
  ADD CONSTRAINT `block_container_ibfk_2` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `block_item`
--
ALTER TABLE `block_item`
  ADD CONSTRAINT `block_item_ibfk_1` FOREIGN KEY (`block_style_id`) REFERENCES `block_style` (`block_style_id`),
  ADD CONSTRAINT `block_item_ibfk_2` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `block_style`
--
ALTER TABLE `block_style`
  ADD CONSTRAINT `block_style_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `block_type`
--
ALTER TABLE `block_type`
  ADD CONSTRAINT `block_type_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `blood_type`
--
ALTER TABLE `blood_type`
  ADD CONSTRAINT `blood_type_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `booking`
--
ALTER TABLE `booking`
  ADD CONSTRAINT `booking_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `call_to_action`
--
ALTER TABLE `call_to_action`
  ADD CONSTRAINT `call_to_action_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `carousel`
--
ALTER TABLE `carousel`
  ADD CONSTRAINT `carousel_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `carousel_image`
--
ALTER TABLE `carousel_image`
  ADD CONSTRAINT `carousel_image_ibfk_1` FOREIGN KEY (`carousel_id`) REFERENCES `carousel` (`carousel_id`),
  ADD CONSTRAINT `carousel_image_ibfk_2` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `civil_status`
--
ALTER TABLE `civil_status`
  ADD CONSTRAINT `civil_status_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);

--
-- Constraints for table `voucher`
--
ALTER TABLE `voucher`
  ADD CONSTRAINT `voucher_ibfk_1` FOREIGN KEY (`last_log_by`) REFERENCES `user_account` (`user_account_id`);
COMMIT;

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
