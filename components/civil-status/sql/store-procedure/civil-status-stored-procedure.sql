DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkCivilStatusExist(IN p_civil_status_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM civil_status
    WHERE civil_status_id = p_civil_status_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertCivilStatus(IN p_civil_status_name VARCHAR(100), IN p_last_log_by INT, OUT p_civil_status_id INT)
BEGIN
    INSERT INTO civil_status (civil_status_name, last_log_by) 
	VALUES(p_civil_status_name, p_last_log_by);
	
    SET p_civil_status_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateCivilStatus(IN p_civil_status_id INT, IN p_civil_status_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE civil_status
    SET civil_status_name = p_civil_status_name,
        last_log_by = p_last_log_by
    WHERE civil_status_id = p_civil_status_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteCivilStatus(IN p_civil_status_id INT)
BEGIN
    DELETE FROM civil_status WHERE civil_status_id = p_civil_status_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getCivilStatus(IN p_civil_status_id INT)
BEGIN
	SELECT * FROM civil_status
	WHERE civil_status_id = p_civil_status_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateCivilStatusTable()
BEGIN
	SELECT civil_status_id, civil_status_name 
    FROM civil_status 
    ORDER BY civil_status_id;
END //

CREATE PROCEDURE generateCivilStatusOptions()
BEGIN
	SELECT civil_status_id, civil_status_name 
    FROM civil_status 
    ORDER BY civil_status_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */