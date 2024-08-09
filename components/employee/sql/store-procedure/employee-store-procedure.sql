DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkEmployeeExist(IN p_employee_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM employee
    WHERE employee_id = p_employee_id;
END //

CREATE PROCEDURE checkEmployeeExperienceExist(IN p_employee_experience_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM employee_experience
    WHERE employee_experience_id = p_employee_experience_id;
END //

CREATE PROCEDURE checkEmployeeEducationExist(IN p_employee_education_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM employee_education
    WHERE employee_education_id = p_employee_education_id;
END //

CREATE PROCEDURE checkEmployeeAddressExist(IN p_employee_address_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM employee_address
    WHERE employee_address_id = p_employee_address_id;
END //

CREATE PROCEDURE checkEmployeeBankAccountExist(IN p_employee_bank_account_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM employee_bank_account
    WHERE employee_bank_account_id = p_employee_bank_account_id;
END //

CREATE PROCEDURE checkEmployeeContactInformationExist(IN p_employee_contact_information_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM employee_contact_information
    WHERE employee_contact_information_id = p_employee_contact_information_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertEmployee(IN p_full_name VARCHAR(1000), IN p_first_name VARCHAR(300), IN p_middle_name VARCHAR(300), IN p_last_name VARCHAR(300), IN p_suffix VARCHAR(10), IN p_nickname VARCHAR(100), IN p_civil_status_id INT, IN p_civil_status_name VARCHAR(100), IN p_gender_id INT, IN p_gender_name VARCHAR(100), IN p_religion_id INT, IN p_religion_name VARCHAR(100), IN p_blood_type_id INT, IN p_blood_type_name VARCHAR(100), IN p_birthday DATE, IN p_birth_place VARCHAR(1000), IN p_height FLOAT, IN p_weight FLOAT, IN p_badge_id VARCHAR(200), IN p_company_id INT, IN p_company_name VARCHAR(100), IN p_employment_type_id INT, IN p_employment_type_name VARCHAR(100), IN p_department_id INT, IN p_department_name VARCHAR(100), IN p_job_position_id INT, IN p_job_position_name VARCHAR(100), IN p_work_location_id INT, IN p_work_location_name VARCHAR(100), IN p_manager_id INT, IN p_manager_name VARCHAR(100), IN p_work_schedule_id INT, IN p_work_schedule_name VARCHAR(100), IN p_pin_code VARCHAR(500), IN p_home_work_distance DOUBLE, IN p_visa_number VARCHAR(50), IN p_work_permit_number VARCHAR(50), IN p_visa_expiration_date DATE, IN p_work_permit_expiration_date DATE, IN p_onboard_date DATE, IN p_time_off_approver_id INT, IN p_time_off_approver_name VARCHAR(100), IN p_last_log_by INT, OUT p_employee_id INT)
BEGIN
    INSERT INTO employee (full_name, first_name, middle_name, last_name, suffix, nickname, civil_status_id, civil_status_name, gender_id, gender_name, religion_id, religion_name, blood_type_id, blood_type_name, birthday, birth_place, height, weight, badge_id, company_id, company_name, employment_type_id, employment_type_name, department_id, department_name, job_position_id, job_position_name, work_location_id, work_location_name, manager_id, manager_name, work_schedule_id, work_schedule_name, pin_code, home_work_distance, visa_number, work_permit_number, visa_expiration_date, work_permit_expiration_date, onboard_date, time_off_approver_id, time_off_approver_name, last_log_by) 
	VALUES(p_full_name, p_first_name, p_middle_name, p_last_name, p_suffix, p_nickname, p_civil_status_id, p_civil_status_name, p_gender_id, p_gender_name, p_religion_id, p_religion_name, p_blood_type_id, p_blood_type_name, p_birthday, p_birth_place, p_height, p_weight, p_badge_id, p_company_id, p_company_name, p_employment_type_id, p_employment_type_name, p_department_id, p_department_name, p_job_position_id, p_job_position_name, p_work_location_id, p_work_location_name, p_manager_id, p_manager_name, p_work_schedule_id, p_work_schedule_name, p_pin_code, p_home_work_distance, p_visa_number, p_work_permit_number, p_visa_expiration_date, p_work_permit_expiration_date, p_onboard_date, p_time_off_approver_id, p_time_off_approver_name, p_last_log_by);
	
    SET p_employee_id = LAST_INSERT_ID();
END //

CREATE PROCEDURE insertEmployeeExperience(IN p_employee_id INT, IN p_job_title VARCHAR(100), IN p_employment_type_id INT, IN p_employment_type_name VARCHAR(100), IN p_company_name VARCHAR(200), IN p_location VARCHAR(200), IN p_employment_location_type_id INT, IN p_employment_location_type_name VARCHAR(100), IN p_start_month VARCHAR(20), IN p_start_year VARCHAR(20), IN p_end_month VARCHAR(20), IN p_end_year VARCHAR(20), IN p_job_description VARCHAR(5000), IN p_last_log_by INT)
BEGIN
    INSERT INTO employee_experience (employee_id, job_title, employment_type_id, employment_type_name, company_name, location, employment_location_type_id, employment_location_type_name, start_month, start_year, end_month, end_year, job_description, last_log_by) 
	VALUES(p_employee_id, p_job_title, p_employment_type_id, p_employment_type_name, p_company_name, p_location, p_employment_location_type_id, p_employment_location_type_name, p_start_month, p_start_year, p_end_month, p_end_year, p_job_description, p_last_log_by);
END //

CREATE PROCEDURE insertEmployeeEducation(IN p_employee_id INT, IN p_school VARCHAR(100), IN p_degree VARCHAR(100), IN p_field_of_study VARCHAR(100), IN p_start_month VARCHAR(20), IN p_start_year VARCHAR(20), IN p_end_month VARCHAR(20), IN p_end_year VARCHAR(20), IN p_activities_societies VARCHAR(5000), IN p_education_description VARCHAR(5000), IN p_last_log_by INT)
BEGIN
    INSERT INTO employee_education (employee_id, school, degree, field_of_study, start_month, start_year, end_month, end_year, activities_societies, education_description, last_log_by) 
	VALUES(p_employee_id, p_school, p_degree, p_field_of_study, p_start_month, p_start_year, p_end_month, p_end_year, p_activities_societies, p_education_description, p_last_log_by);
END //

CREATE PROCEDURE insertEmployeeAddress(IN p_employee_id INT, IN p_address_type_id INT, IN p_address_type_name VARCHAR(100), IN p_address VARCHAR(1000), IN p_city_id INT, IN p_city_name VARCHAR(100), IN p_state_id INT, IN p_state_name VARCHAR(100), IN p_country_id INT, IN p_country_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
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

    INSERT INTO employee_address (employee_id, address_type_id, address_type_name, address, city_id, city_name, state_id, state_name, country_id, country_name, default_address, last_log_by) 
	VALUES(p_employee_id, p_address_type_id, p_address_type_name, p_address, p_city_id, p_city_name, p_state_id, p_state_name, p_country_id, p_country_name, p_default_address, p_last_log_by);
END //

CREATE PROCEDURE insertEmployeeBankAccount(IN p_employee_id INT, IN p_bank_id INT, IN p_bank_name VARCHAR(100), IN p_bank_account_type_id INT, IN p_bank_account_type_name VARCHAR(100), IN p_account_number VARCHAR(100), IN p_last_log_by INT)
BEGIN
    INSERT INTO employee_bank_account (employee_id, bank_id, bank_name, bank_account_type_id,bank_account_type_name, account_number, last_log_by) 
	VALUES(p_employee_id, p_bank_id, p_bank_name, p_bank_account_type_id, p_bank_account_type_name, p_account_number, p_last_log_by);
END //

CREATE PROCEDURE insertEmployeeContactInformation(IN p_employee_id INT, IN p_contact_information_type_id INT, IN p_contact_information_type_name VARCHAR(100), IN p_telephone VARCHAR(50), IN p_mobile VARCHAR(50), IN p_email VARCHAR(200), IN p_last_log_by INT)
BEGIN
    DECLARE existing_contact_information_count INT;
    DECLARE p_default_contact_information VARCHAR(10);

    SELECT COUNT(*) INTO existing_contact_information_count
    FROM employee_contact_information
    WHERE employee_id = p_employee_id AND default_contact_information = 'Primary';

    IF existing_contact_information_count = 0 THEN
        SET p_default_contact_information = 'Primary';
    ELSE
        SET p_default_contact_information = 'Alternate';
    END IF;

    INSERT INTO employee_contact_information (employee_id, contact_information_type_id, contact_information_type_name, telephone, mobile, email, default_contact_information, last_log_by) 
	VALUES(p_employee_id, p_contact_information_type_id, p_contact_information_type_name, p_telephone, p_mobile, p_email, p_default_contact_information, p_last_log_by);
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateEmployeeImage(IN p_employee_id INT, IN p_employee_image VARCHAR(500), IN p_last_log_by INT)
BEGIN
    UPDATE employee
    SET employee_image = p_employee_image,
        last_log_by = p_last_log_by
    WHERE employee_id = p_employee_id;
END //

CREATE PROCEDURE updateEmployeeAbout(IN p_employee_id INT, IN p_about VARCHAR(500), IN p_last_log_by INT)
BEGIN
    UPDATE employee
    SET about = p_about,
        last_log_by = p_last_log_by
    WHERE employee_id = p_employee_id;
END //

CREATE PROCEDURE updateEmployeePrivateInformation(IN p_employee_id INT, IN p_full_name VARCHAR(1000), IN p_first_name VARCHAR(300), IN p_middle_name VARCHAR(300), IN p_last_name VARCHAR(300), IN p_suffix VARCHAR(10), IN p_nickname VARCHAR(100), IN p_civil_status_id INT, IN p_civil_status_name VARCHAR(100), IN p_gender_id INT, IN p_gender_name VARCHAR(100), IN p_religion_id INT, IN p_religion_name VARCHAR(100), IN p_blood_type_id INT, IN p_blood_type_name VARCHAR(100), IN p_birthday DATE, IN p_birth_place VARCHAR(1000), IN p_height FLOAT, IN p_weight FLOAT, IN p_last_log_by INT)
BEGIN
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
END //

CREATE PROCEDURE updateEmployeeWorkInformation(IN p_employee_id INT, IN p_company_id INT, IN p_company_name VARCHAR(100), IN p_department_id INT, IN p_department_name VARCHAR(100), IN p_job_position_id INT, IN p_job_position_name VARCHAR(100), IN p_work_location_id INT, IN p_work_location_name VARCHAR(100), IN p_manager_id INT, IN p_manager_name VARCHAR(100), IN p_work_schedule_id INT, IN p_work_schedule_name VARCHAR(100), IN p_home_work_distance DOUBLE, IN p_time_off_approver_id INT, IN p_time_off_approver_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
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
END //

CREATE PROCEDURE updateEmployeeHRSettings(IN p_employee_id INT, IN p_badge_id VARCHAR(200), IN p_employment_type_id INT, IN p_employment_type_name VARCHAR(100), IN p_pin_code VARCHAR(500), IN p_onboard_date DATE, IN p_last_log_by INT)
BEGIN
    UPDATE employee
    SET badge_id = p_badge_id,
        employment_type_id = p_employment_type_id,
        employment_type_name = p_employment_type_name,
        pin_code = p_pin_code,
        onboard_date = p_onboard_date,
        last_log_by = p_last_log_by
    WHERE employee_id = p_employee_id;
END //

CREATE PROCEDURE updateEmployeeWorkPermit(IN p_employee_id INT, IN p_visa_number VARCHAR(50), IN p_work_permit_number VARCHAR(50), IN p_visa_expiration_date DATE, IN p_work_permit_expiration_date DATE, IN p_last_log_by INT)
BEGIN
    UPDATE employee
    SET visa_number = p_visa_number,
        work_permit_number = p_work_permit_number,
        visa_expiration_date = p_visa_expiration_date,
        work_permit_expiration_date = p_work_permit_expiration_date,
        last_log_by = p_last_log_by
    WHERE employee_id = p_employee_id;
END //

CREATE PROCEDURE updateEmployeeExperience(IN p_employee_experience_id INT, IN p_employee_id INT, IN p_job_title VARCHAR(100), IN p_employment_type_id INT, IN p_employment_type_name VARCHAR(100), IN p_company_name VARCHAR(200), IN p_location VARCHAR(200), IN p_employment_location_type_id INT, IN p_employment_location_type_name VARCHAR(100), IN p_start_month VARCHAR(20), IN p_start_year VARCHAR(20), IN p_end_month VARCHAR(20), IN p_end_year VARCHAR(20), IN p_job_description VARCHAR(5000), IN p_last_log_by INT)
BEGIN
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
END //

CREATE PROCEDURE updateEmployeeEducation(IN p_employee_education_id INT, IN p_employee_id INT, IN p_school VARCHAR(100), IN p_degree VARCHAR(100), IN p_field_of_study VARCHAR(100), IN p_start_month VARCHAR(20), IN p_start_year VARCHAR(20), IN p_end_month VARCHAR(20), IN p_end_year VARCHAR(20), IN p_activities_societies VARCHAR(5000), IN p_education_description VARCHAR(5000), IN p_last_log_by INT)
BEGIN
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
END //

CREATE PROCEDURE updateEmployeeAddress(IN p_employee_address_id INT, IN p_employee_id INT, IN p_address_type_id INT, IN p_address_type_name VARCHAR(100), IN p_address VARCHAR(1000), IN p_city_id INT, IN p_city_name VARCHAR(100), IN p_state_id INT, IN p_state_name VARCHAR(100), IN p_country_id INT, IN p_country_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
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
        last_log_by = p_last_log_by
    WHERE employee_address_id = p_employee_address_id;
END //

CREATE PROCEDURE updateEmployeeBankAccount(IN p_employee_bank_account_id INT, IN p_employee_id INT, IN p_bank_id INT, IN p_bank_name VARCHAR(100), IN p_bank_account_type_id INT, IN p_bank_account_type_name VARCHAR(100), IN p_account_number VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE employee_bank_account
    SET employee_id = p_employee_id,
        bank_id = p_bank_id,
        bank_name = p_bank_name,
        bank_account_type_id = p_bank_account_type_id,
        bank_account_type_name = p_bank_account_type_name,
        account_number = p_account_number
    WHERE employee_bank_account_id = p_employee_bank_account_id;
END //

CREATE PROCEDURE updateEmployeeContactInformation(IN p_employee_contact_information_id INT, IN p_employee_id INT, IN p_contact_information_type_id INT, IN p_contact_information_type_name VARCHAR(100), IN p_telephone VARCHAR(50), IN p_mobile VARCHAR(50), IN p_email VARCHAR(200), IN p_last_log_by INT)
BEGIN
    UPDATE employee_contact_information
    SET employee_id = p_employee_id,
        contact_information_type_id = p_contact_information_type_id,
        contact_information_type_name = p_contact_information_type_name,
        telephone = p_telephone,
        mobile = p_mobile,
        email = p_email
    WHERE employee_contact_information_id = p_employee_contact_information_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteEmployee(IN p_employee_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM employee_experience WHERE employee_id = p_employee_id;
    DELETE FROM employee_education WHERE employee_id = p_employee_id;
    DELETE FROM employee_address WHERE employee_id = p_employee_id;
    DELETE FROM employee_bank_account WHERE employee_id = p_employee_id;
    DELETE FROM employee_contact_information WHERE employee_id = p_employee_id;
    DELETE FROM employee WHERE employee_id = p_employee_id;

    COMMIT;
END //

CREATE PROCEDURE deleteEmployeeExperience(IN p_employee_experience_id INT)
BEGIN
   DELETE FROM employee_experience WHERE employee_experience_id = p_employee_experience_id;
END //

CREATE PROCEDURE deleteEmployeeEducation(IN p_employee_education_id INT)
BEGIN
   DELETE FROM employee_education WHERE employee_education_id = p_employee_education_id;
END //

CREATE PROCEDURE deleteEmployeeAddress(IN p_employee_address_id INT, IN p_employee_id INT)
BEGIN
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
END //

CREATE PROCEDURE deleteEmployeeBankAccount(IN p_employee_bank_account_id INT)
BEGIN
   DELETE FROM employee_bank_account WHERE employee_bank_account_id = p_employee_bank_account_id;
END //

CREATE PROCEDURE deleteEmployeeContactInformation(IN p_employee_contact_information_id INT, IN p_employee_id INT)
BEGIN
    DECLARE existing_contact_information_count INT;
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    DELETE FROM employee_contact_information
    WHERE employee_contact_information_id = p_employee_contact_information_id;

    SELECT COUNT(*) INTO existing_contact_information_count
    FROM employee_contact_information
    WHERE employee_id = p_employee_id AND default_contact_information = 'Primary';

    IF existing_contact_information_count = 0 THEN
        UPDATE employee_contact_information
        SET default_contact_information = 'Primary'
        WHERE employee_id = p_employee_id
        AND default_contact_information = 'Alternate'
        LIMIT 1;
    END IF;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getEmployee(IN p_employee_id INT)
BEGIN
	SELECT * FROM employee
	WHERE employee_id = p_employee_id;
END //

CREATE PROCEDURE getEmployeeExperience(IN p_employee_experience_id INT)
BEGIN
	SELECT * FROM employee_experience
	WHERE employee_experience_id = p_employee_experience_id;
END //

CREATE PROCEDURE getEmployeeEducation(IN p_employee_education_id INT)
BEGIN
	SELECT * FROM employee_education
	WHERE employee_education_id = p_employee_education_id;
END //

CREATE PROCEDURE getEmployeeAddress(IN p_employee_address_id INT)
BEGIN
	SELECT * FROM employee_address
	WHERE employee_address_id = p_employee_address_id;
END //

CREATE PROCEDURE getEmployeeBankAccount(IN p_employee_bank_account_id INT)
BEGIN
	SELECT * FROM employee_bank_account
	WHERE employee_bank_account_id = p_employee_bank_account_id;
END //

CREATE PROCEDURE getEmployeeContactInformation(IN p_employee_contact_information_id INT)
BEGIN
	SELECT * FROM employee_contact_information
	WHERE employee_contact_information_id = p_employee_contact_information_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateEmployeeCard(IN p_search_value TEXT, IN p_filter_by_company INT, IN p_filter_by_department INT, IN p_filter_by_job_position INT, IN p_filter_by_employee_status VARCHAR(50), IN p_filter_by_employment_type INT, IN p_filter_by_gender INT, IN p_filter_by_civil_status INT, IN p_limit INT, IN p_offset INT)
BEGIN
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
END //

CREATE PROCEDURE generateEmployeeExperience(IN p_employee_id INT)
BEGIN
	SELECT * FROM employee_experience
	WHERE employee_id = p_employee_id;
END //

CREATE PROCEDURE generateEmployeeEducation(IN p_employee_id INT)
BEGIN
	SELECT * FROM employee_education
	WHERE employee_id = p_employee_id;
END //

CREATE PROCEDURE generateEmployeeAddress(IN p_employee_id INT)
BEGIN
	SELECT * FROM employee_address
	WHERE employee_id = p_employee_id;
END //

CREATE PROCEDURE generateEmployeeBankAccount(IN p_employee_id INT)
BEGIN
	SELECT * FROM employee_bank_account
	WHERE employee_id = p_employee_id;
END //

CREATE PROCEDURE generateEmployeeContactInformation(IN p_employee_id INT)
BEGIN
	SELECT * FROM employee_contact_information
	WHERE employee_id = p_employee_id;
END //

CREATE PROCEDURE generateEmployeeOptions(IN p_employee_id INT)
BEGIN
    IF p_employee_id IS NOT NULL AND p_employee_id != '' THEN
        SELECT employee_id, employee_name 
        FROM employee 
        WHERE employee_id != p_employee_id
        ORDER BY employee_name;
    ELSE
        SELECT employee_id, employee_name 
        FROM employee 
        ORDER BY employee_name;
    END IF;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */