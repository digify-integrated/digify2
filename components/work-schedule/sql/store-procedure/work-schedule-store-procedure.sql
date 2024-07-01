DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkWorkScheduleExist(IN p_work_schedule_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM work_schedule
    WHERE work_schedule_id = p_work_schedule_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertWorkSchedule(IN p_work_schedule_name VARCHAR(100), IN p_schedule_type_id INT, IN p_schedule_type_name VARCHAR(100), IN p_last_log_by INT, OUT p_work_schedule_id INT)
BEGIN
    INSERT INTO work_schedule (work_schedule_name, schedule_type_id, schedule_type_name, last_log_by) 
	VALUES(p_work_schedule_name, p_schedule_type_id, p_schedule_type_name, p_last_log_by);
	
    SET p_work_schedule_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateWorkSchedule(IN p_work_schedule_id INT, IN p_work_schedule_name VARCHAR(100), IN p_schedule_type_id INT, IN p_schedule_type_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE work_schedule
    SET work_schedule_name = p_work_schedule_name,
        schedule_type_id = p_schedule_type_id,
        schedule_type_name = p_schedule_type_name,
        last_log_by = p_last_log_by
    WHERE work_schedule_id = p_work_schedule_id;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteWorkSchedule(IN p_work_schedule_id INT)
BEGIN
    DELETE FROM work_schedule WHERE work_schedule_id = p_work_schedule_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getWorkSchedule(IN p_work_schedule_id INT)
BEGIN
	SELECT * FROM work_schedule
	WHERE work_schedule_id = p_work_schedule_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateWorkScheduleTable(IN p_filter_by_schedule_type INT)
BEGIN
    DECLARE query VARCHAR(5000);

    SET query = CONCAT('
        SELECT work_schedule_id, work_schedule_name, schedule_type_name
        FROM work_schedule 
        WHERE 1');

    IF p_filter_by_schedule_type IS NOT NULL AND p_filter_by_schedule_type != '' THEN
        SET query = CONCAT(query, ' AND schedule_type_id = ', p_filter_by_schedule_type);
    END IF;

    SET query = CONCAT(query, ' ORDER BY work_schedule_name');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

CREATE PROCEDURE generateWorkScheduleOptions()
BEGIN
	SELECT work_schedule_id, work_schedule_name 
    FROM work_schedule 
    ORDER BY work_schedule_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */