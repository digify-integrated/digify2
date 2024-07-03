DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkDepartmentExist(IN p_department_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM department
    WHERE department_id = p_department_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertDepartment(IN p_department_name VARCHAR(100), IN p_parent_department_id INT, IN p_parent_department_name VARCHAR(100), IN p_manager_id INT, IN p_manager_name VARCHAR(100), IN p_last_log_by INT, OUT p_department_id INT)
BEGIN
    INSERT INTO department (department_name, parent_department_id, parent_department_name, manager_id, manager_name, last_log_by) 
	VALUES(p_department_name, p_parent_department_id, p_parent_department_name, p_manager_id, p_manager_name, p_last_log_by);
	
    SET p_department_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateDepartment(IN p_department_id INT, IN p_department_name VARCHAR(100), IN p_parent_department_id INT, IN p_parent_department_name VARCHAR(100), IN p_manager_id INT, IN p_manager_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
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
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteDepartment(IN p_department_id INT)
BEGIN
    DELETE FROM department WHERE department_id = p_department_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getDepartment(IN p_department_id INT)
BEGIN
	SELECT * FROM department
	WHERE department_id = p_department_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateDepartmentTable()
BEGIN
    SELECT department_id, department_name, parent_department_name, manager_name 
    FROM department;
END //

CREATE PROCEDURE generateDepartmentOptions(IN p_department_id INT)
BEGIN
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
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */