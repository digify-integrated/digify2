DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkWorkLocationExist(IN p_work_location_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM work_location
    WHERE work_location_id = p_work_location_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertWorkLocation(IN p_work_location_name VARCHAR(100), IN p_address VARCHAR(500), IN p_city_id INT, IN p_city_name VARCHAR(100), IN p_state_id INT, IN p_state_name VARCHAR(100), IN p_country_id INT, IN p_country_name VARCHAR(100), IN p_phone VARCHAR(50), IN p_mobile VARCHAR(50), IN p_email VARCHAR(500), IN p_last_log_by INT, OUT p_work_location_id INT)
BEGIN
    INSERT INTO work_location (work_location_name, address, city_id, city_name, state_id, state_name, country_id, country_name, phone, mobile, email, last_log_by) 
	VALUES(p_work_location_name, p_address, p_city_id, p_city_name, p_state_id, p_state_name, p_country_id, p_country_name, p_phone, p_mobile, p_email, p_last_log_by);
	
    SET p_work_location_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateWorkLocation(IN p_work_location_id INT, IN p_work_location_name VARCHAR(100), IN p_address VARCHAR(500), IN p_city_id INT, IN p_city_name VARCHAR(100), IN p_state_id INT, IN p_state_name VARCHAR(100), IN p_country_id INT, IN p_country_name VARCHAR(100), IN p_phone VARCHAR(50), IN p_mobile VARCHAR(50), IN p_email VARCHAR(500), IN p_last_log_by INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE work_information
    SET work_location_name = p_work_location_name,
        last_log_by = p_last_log_by
    WHERE work_location_id = p_work_location_id;

    UPDATE work_location
    SET work_location_name = p_work_location_name,
        address = p_address,
        city_id = p_city_id,
        city_name = p_city_name,
        state_id = p_state_id,
        state_name = p_state_name,
        country_id = p_country_id,
        country_name = p_country_name,
        phone = p_phone,
        mobile = p_mobile,
        email = p_email,
        last_log_by = p_last_log_by
    WHERE work_location_id = p_work_location_id;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteWorkLocation(IN p_work_location_id INT)
BEGIN
    DELETE FROM work_location WHERE work_location_id = p_work_location_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getWorkLocation(IN p_work_location_id INT)
BEGIN
	SELECT * FROM work_location
	WHERE work_location_id = p_work_location_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateWorkLocationTable(IN p_filter_by_city INT, IN p_filter_by_state INT, IN p_filter_by_country INT)
BEGIN
    DECLARE query VARCHAR(5000);

    SET query = CONCAT('
        SELECT work_location_id, work_location_name, address, city_name, state_name, country_name
        FROM work_location 
        WHERE 1');

    IF p_filter_by_city IS NOT NULL AND p_filter_by_city != '' THEN
        SET query = CONCAT(query, ' AND city_id = ', p_filter_by_city);
    END IF;

    IF p_filter_by_state IS NOT NULL AND p_filter_by_state != '' THEN
        SET query = CONCAT(query, ' AND state_id = ', p_filter_by_state);
    END IF;

    IF p_filter_by_country IS NOT NULL AND p_filter_by_country != '' THEN
        SET query = CONCAT(query, ' AND country_id = ', p_filter_by_country);
    END IF;

    SET query = CONCAT(query, ' ORDER BY work_location_name');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

CREATE PROCEDURE generateWorkLocationOptions()
BEGIN
	SELECT work_location_id, work_location_name 
    FROM work_location 
    ORDER BY work_location_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */