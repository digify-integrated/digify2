DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkEmploymentTypeExist(IN p_employment_type_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM employment_type
    WHERE employment_type_id = p_employment_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertEmploymentType(IN p_employment_type_name VARCHAR(100), IN p_last_log_by INT, OUT p_employment_type_id INT)
BEGIN
    INSERT INTO employment_type (employment_type_name, last_log_by) 
	VALUES(p_employment_type_name, p_last_log_by);
	
    SET p_employment_type_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateEmploymentType(IN p_employment_type_id INT, IN p_employment_type_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE work_information
    SET employment_type_name = p_employment_type_name,
        last_log_by = p_last_log_by
    WHERE employment_type_id = p_employment_type_id;

    UPDATE employment_type
    SET employment_type_name = p_employment_type_name,
        last_log_by = p_last_log_by
    WHERE employment_type_id = p_employment_type_id;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteEmploymentType(IN p_employment_type_id INT)
BEGIN
    DELETE FROM employment_type WHERE employment_type_id = p_employment_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getEmploymentType(IN p_employment_type_id INT)
BEGIN
	SELECT * FROM employment_type
	WHERE employment_type_id = p_employment_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateEmploymentTypeTable()
BEGIN
	SELECT employment_type_id, employment_type_name 
    FROM employment_type 
    ORDER BY employment_type_id;
END //

CREATE PROCEDURE generateEmploymentTypeOptions()
BEGIN
	SELECT employment_type_id, employment_type_name 
    FROM employment_type 
    ORDER BY employment_type_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */