DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkEmployeeExist(IN p_employee_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM employee
    WHERE employee_id = p_employee_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertEmployee(IN p_full_name VARCHAR(1000), IN p_first_name VARCHAR(300), IN p_middle_name VARCHAR(300), IN p_last_name VARCHAR(300), IN p_suffix VARCHAR(10), IN p_nickname VARCHAR(100), IN p_civil_status_id INT, IN p_civil_status_name VARCHAR(100), IN p_gender_id INT, IN p_gender_name VARCHAR(100), IN p_religion_id INT, IN p_religion_name VARCHAR(100), IN p_blood_type_id INT, IN p_blood_type_name VARCHAR(100), IN p_birthday DATE, IN p_birth_place VARCHAR(1000), IN p_height FLOAT, IN p_weight FLOAT, IN p_last_log_by INT, OUT p_employee_id INT)
BEGIN
    INSERT INTO employee (full_name, first_name, middle_name, last_name, suffix, nickname, civil_status_id, civil_status_name, gender_id, gender_name, religion_id, religion_name, blood_type_id, blood_type_name, birthday, birth_place, height, weight, last_log_by) 
	VALUES(p_full_name, p_first_name, p_middle_name, p_last_name, p_suffix, p_nickname, p_civil_status_id, p_civil_status_name, p_gender_id, p_gender_name, p_religion_id, p_religion_name, p_blood_type_id, p_blood_type_name, p_birthday, p_birth_place, p_height, p_weight, p_last_log_by);
	
    SET p_employee_id = LAST_INSERT_ID();
END //

CREATE PROCEDURE insertWorkInformation(IN p_employee_id INT, IN p_badge_id VARCHAR(200), IN p_company_id INT, IN p_company_name VARCHAR(100), IN p_employment_type_id INT, IN p_employment_type_name VARCHAR(100), IN p_department_id INT, IN p_department_name VARCHAR(100), IN p_job_position_id INT, IN p_job_position_name VARCHAR(100), IN p_work_location_id INT, IN p_work_location_name VARCHAR(100), IN p_manager_id INT, IN p_manager_name VARCHAR(100), IN p_work_schedule_id INT, IN p_work_schedule_name VARCHAR(100), IN p_pin_code VARCHAR(500), IN p_home_work_distance DOUBLE, IN p_visa_number VARCHAR(50), IN p_work_permit_number VARCHAR(50), IN p_visa_expiration_date DATE, IN p_work_permit_expiration_date DATE, IN p_onboard_date DATE, IN p_time_off_approver_id INT, IN p_time_off_approver_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    INSERT INTO work_information (employee_id, badge_id, company_id, company_name, employment_type_id, employment_type_name, department_id, department_name, job_position_id, job_position_name, work_location_id, work_location_name, manager_id, manager_name, work_schedule_id, work_schedule_name, pin_code, home_work_distance, visa_number, work_permit_number, visa_expiration_date, work_permit_expiration_date, onboard_date, time_off_approver_id, time_off_approver_name, last_log_by) 
	VALUES(p_employee_id, p_badge_id, p_company_id, p_company_name, p_employment_type_id, p_employment_type_name, p_department_id, p_department_name, p_job_position_id, p_job_position_name, p_work_location_id, p_work_location_name, p_manager_id, p_manager_name, p_work_schedule_id, p_work_schedule_name, p_pin_code, p_home_work_distance, p_visa_number, p_work_permit_number, p_visa_expiration_date, p_work_permit_expiration_date, p_onboard_date, p_time_off_approver_id, p_time_off_approver_name, p_last_log_by);
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateEmployee(IN p_employee_id INT, IN p_full_name VARCHAR(1000), IN p_first_name VARCHAR(300), IN p_middle_name VARCHAR(300), IN p_last_name VARCHAR(300), IN p_suffix VARCHAR(10), IN p_nickname VARCHAR(100), IN p_civil_status_id INT, IN p_civil_status_name VARCHAR(100), IN p_gender_id INT, IN p_gender_name VARCHAR(100), IN p_religion_id INT, IN p_religion_name VARCHAR(100), IN p_blood_type_id INT, IN p_blood_type_name VARCHAR(100), IN p_birthday DATE, IN p_birth_place VARCHAR(1000), IN p_height FLOAT, IN p_weight FLOAT, IN p_last_log_by INT)
BEGIN
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
END //

CREATE PROCEDURE updateEmployeeImage(IN p_employee_id INT, IN p_employee_image VARCHAR(500), IN p_last_log_by INT)
BEGIN
    UPDATE employee
    SET employee_image = p_employee_image,
        last_log_by = p_last_log_by
    WHERE employee_id = p_employee_id;
END //

CREATE PROCEDURE updateWorkPermit(IN p_employee_id INT, IN p_work_permit VARCHAR(500), IN p_last_log_by INT)
BEGIN
    UPDATE work_information
    SET work_permit = p_work_permit,
        last_log_by = p_last_log_by
    WHERE employee_id = p_employee_id;
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

    DELETE FROM work_information WHERE employee_id = p_employee_id;
    DELETE FROM employee WHERE employee_id = p_employee_id;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getEmployee(IN p_employee_id INT)
BEGIN
	SELECT * FROM employee
	WHERE employee_id = p_employee_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateEmployeeTable()
BEGIN
    SELECT employee_id, employee_name, parent_employee_name, manager_name 
    FROM employee;
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