DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkDepartureReasonsExist(IN p_departure_reasons_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM departure_reasons
    WHERE departure_reasons_id = p_departure_reasons_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertDepartureReasons(IN p_departure_reasons_name VARCHAR(100), IN p_last_log_by INT, OUT p_departure_reasons_id INT)
BEGIN
    INSERT INTO departure_reasons (departure_reasons_name, last_log_by) 
	VALUES(p_departure_reasons_name, p_last_log_by);
	
    SET p_departure_reasons_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateDepartureReasons(IN p_departure_reasons_id INT, IN p_departure_reasons_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE departure_reasons
    SET departure_reasons_name = p_departure_reasons_name,
        last_log_by = p_last_log_by
    WHERE departure_reasons_id = p_departure_reasons_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteDepartureReasons(IN p_departure_reasons_id INT)
BEGIN
    DELETE FROM departure_reasons WHERE departure_reasons_id = p_departure_reasons_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getDepartureReasons(IN p_departure_reasons_id INT)
BEGIN
	SELECT * FROM departure_reasons
	WHERE departure_reasons_id = p_departure_reasons_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateDepartureReasonsTable()
BEGIN
	SELECT departure_reasons_id, departure_reasons_name 
    FROM departure_reasons 
    ORDER BY departure_reasons_id;
END //

CREATE PROCEDURE generateDepartureReasonsOptions()
BEGIN
	SELECT departure_reasons_id, departure_reasons_name 
    FROM departure_reasons 
    ORDER BY departure_reasons_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */