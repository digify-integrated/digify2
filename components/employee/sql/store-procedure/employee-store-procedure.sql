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
    SET employee_name = p_employee_name,
        parent_employee_id = p_parent_employee_id,
        parent_employee_name = p_parent_employee_name,
        manager_id = p_manager_id,
        manager_name = p_manager_name,
        last_log_by = p_last_log_by
    WHERE employee_id = p_employee_id;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteEmployee(IN p_employee_id INT)
BEGIN
    DELETE FROM employee WHERE employee_id = p_employee_id;
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