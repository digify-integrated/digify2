DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkEmploymentLocationTypeExist(IN p_employment_location_type_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM employment_location_type
    WHERE employment_location_type_id = p_employment_location_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertEmploymentLocationType(IN p_employment_location_type_name VARCHAR(100), IN p_last_log_by INT, OUT p_employment_location_type_id INT)
BEGIN
    INSERT INTO employment_location_type (employment_location_type_name, last_log_by) 
	VALUES(p_employment_location_type_name, p_last_log_by);
	
    SET p_employment_location_type_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateEmploymentLocationType(IN p_employment_location_type_id INT, IN p_employment_location_type_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE employment_location_type
    SET employment_location_type_name = p_employment_location_type_name,
        last_log_by = p_last_log_by
    WHERE employment_location_type_id = p_employment_location_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteEmploymentLocationType(IN p_employment_location_type_id INT)
BEGIN
    DELETE FROM employment_location_type WHERE employment_location_type_id = p_employment_location_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getEmploymentLocationType(IN p_employment_location_type_id INT)
BEGIN
	SELECT * FROM employment_location_type
	WHERE employment_location_type_id = p_employment_location_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateEmploymentLocationTypeTable()
BEGIN
	SELECT employment_location_type_id, employment_location_type_name 
    FROM employment_location_type 
    ORDER BY employment_location_type_id;
END //

CREATE PROCEDURE generateEmploymentLocationTypeOptions()
BEGIN
	SELECT employment_location_type_id, employment_location_type_name 
    FROM employment_location_type 
    ORDER BY employment_location_type_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */