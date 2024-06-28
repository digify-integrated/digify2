DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkEmploymentTypesExist(IN p_employment_types_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM employment_types
    WHERE employment_types_id = p_employment_types_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertEmploymentTypes(IN p_employment_types_name VARCHAR(100), IN p_last_log_by INT, OUT p_employment_types_id INT)
BEGIN
    INSERT INTO employment_types (employment_types_name, last_log_by) 
	VALUES(p_employment_types_name, p_last_log_by);
	
    SET p_employment_types_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateEmploymentTypes(IN p_employment_types_id INT, IN p_employment_types_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE employment_types
    SET employment_types_name = p_employment_types_name,
        last_log_by = p_last_log_by
    WHERE employment_types_id = p_employment_types_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteEmploymentTypes(IN p_employment_types_id INT)
BEGIN
    DELETE FROM employment_types WHERE employment_types_id = p_employment_types_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getEmploymentTypes(IN p_employment_types_id INT)
BEGIN
	SELECT * FROM employment_types
	WHERE employment_types_id = p_employment_types_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateEmploymentTypesTable()
BEGIN
	SELECT employment_types_id, employment_types_name 
    FROM employment_types 
    ORDER BY employment_types_id;
END //

CREATE PROCEDURE generateEmploymentTypesOptions()
BEGIN
	SELECT employment_types_id, employment_types_name 
    FROM employment_types 
    ORDER BY employment_types_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */