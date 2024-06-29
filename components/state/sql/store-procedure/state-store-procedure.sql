DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkStateExist(IN p_state_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM state
    WHERE state_id = p_state_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertState(IN p_state_name VARCHAR(100), IN p_country_id INT, IN p_country_name VARCHAR(100), IN p_last_log_by INT, OUT p_state_id INT)
BEGIN
    INSERT INTO state (state_name, country_id, country_name, last_log_by) 
	VALUES(p_state_name, p_country_id, p_country_name, p_last_log_by);
	
    SET p_state_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateState(IN p_state_id INT, IN p_state_name VARCHAR(100), IN p_country_id INT, IN p_country_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

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
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteState(IN p_state_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM city WHERE state_id = p_state_id;
    DELETE FROM state WHERE state_id = p_state_id;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getState(IN p_state_id INT)
BEGIN
	SELECT * FROM state
	WHERE state_id = p_state_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateStateTable(IN p_filter_by_country INT)
BEGIN
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
END //

CREATE PROCEDURE generateStateOptions()
BEGIN
	SELECT state_id, state_name, country_name
    FROM state 
    ORDER BY state_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */