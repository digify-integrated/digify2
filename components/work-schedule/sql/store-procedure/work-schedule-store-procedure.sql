DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkWorkScheduleExist(IN p_work_schedule_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM work_schedule
    WHERE work_schedule_id = p_work_schedule_id;
END //

CREATE PROCEDURE checkWorkHoursExist(IN p_work_hours_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM work_hours
    WHERE work_hours_id = p_work_hours_id;
END //

CREATE PROCEDURE checkWorkHoursOverlap(IN p_work_hours_id INT, IN p_work_schedule_id INT, IN p_day_of_week VARCHAR(20), IN p_day_period VARCHAR(20), IN p_start_time TIME, IN p_end_time TIME)
BEGIN
    IF p_work_hours_id IS NOT NULL OR p_work_hours_id <> '' THEN
        SELECT COUNT(*) AS total
        FROM work_hours
        WHERE work_hours_id != p_work_hours_id
        AND work_schedule_id = p_work_schedule_id
        AND day_of_week = p_day_of_week
        AND (start_time BETWEEN p_start_time AND p_end_time OR end_time BETWEEN p_start_time AND p_end_time);
    ELSE
        SELECT COUNT(*) AS total
        FROM work_hours
        WHERE work_hours_id != p_work_hours_id
        AND day_of_week = p_day_of_week
        AND (start_time BETWEEN p_start_time AND p_end_time OR end_time BETWEEN p_start_time AND p_end_time);
    END IF;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertWorkSchedule(IN p_work_schedule_name VARCHAR(100), IN p_schedule_type_id INT, IN p_schedule_type_name VARCHAR(100), IN p_last_log_by INT, OUT p_work_schedule_id INT)
BEGIN
    INSERT INTO work_schedule (work_schedule_name, schedule_type_id, schedule_type_name, last_log_by) 
	VALUES(p_work_schedule_name, p_schedule_type_id, p_schedule_type_name, p_last_log_by);
	
    SET p_work_schedule_id = LAST_INSERT_ID();
END //

CREATE PROCEDURE insertWorkHours(IN p_work_schedule_id INT, IN p_day_of_week VARCHAR(20), IN p_day_period VARCHAR(20), IN p_start_time TIME, IN p_end_time TIME, IN p_notes VARCHAR(500), IN p_last_log_by INT)
BEGIN
    INSERT INTO work_hours (work_schedule_id, day_of_week, day_period, start_time, end_time, notes, last_log_by) 
	VALUES(p_work_schedule_id, p_day_of_week, p_day_period, p_start_time, p_end_time, p_notes, p_last_log_by);
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

    UPDATE work_information
    SET work_schedule_name = p_work_schedule_name,
        last_log_by = p_last_log_by
    WHERE work_schedule_id = p_work_schedule_id;

    UPDATE work_schedule
    SET work_schedule_name = p_work_schedule_name,
        schedule_type_id = p_schedule_type_id,
        schedule_type_name = p_schedule_type_name,
        last_log_by = p_last_log_by
    WHERE work_schedule_id = p_work_schedule_id;

    COMMIT;
END //

CREATE PROCEDURE updateWorkHours(IN p_work_hours_id INT, IN p_work_schedule_id INT, IN p_day_of_week VARCHAR(20), IN p_day_period VARCHAR(20), IN p_start_time TIME, IN p_end_time TIME, IN p_notes VARCHAR(500), IN p_last_log_by INT)
BEGIN
    UPDATE work_hours
    SET work_schedule_id = p_work_schedule_id,
        day_of_week = p_day_of_week,
        day_period = p_day_period,
        start_time = p_start_time,
        end_time = p_end_time,
        notes = p_notes,
        last_log_by = p_last_log_by
    WHERE work_hours_id = p_work_hours_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteWorkSchedule(IN p_work_schedule_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM work_hours WHERE work_schedule_id = p_work_schedule_id;
    DELETE FROM work_schedule WHERE work_schedule_id = p_work_schedule_id;

    COMMIT;
END //

CREATE PROCEDURE deleteWorkHours(IN p_work_hours_id INT)
BEGIN
    DELETE FROM work_hours WHERE work_hours_id = p_work_hours_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getWorkSchedule(IN p_work_schedule_id INT)
BEGIN
	SELECT * FROM work_schedule
	WHERE work_schedule_id = p_work_schedule_id;
END //

CREATE PROCEDURE getWorkHours(IN p_work_hours_id INT)
BEGIN
	SELECT * FROM work_hours
	WHERE work_hours_id = p_work_hours_id;
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

CREATE PROCEDURE generateWorkHoursTable(IN p_work_schedule_id INT)
BEGIN
    SELECT work_hours_id, day_of_week, day_period, start_time, end_time, notes
    FROM work_hours WHERE work_schedule_id = p_work_schedule_id;
END //

CREATE PROCEDURE generateWorkScheduleOptions()
BEGIN
	SELECT work_schedule_id, work_schedule_name 
    FROM work_schedule 
    ORDER BY work_schedule_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */