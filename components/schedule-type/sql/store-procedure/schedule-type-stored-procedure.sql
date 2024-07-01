DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkScheduleTypeExist(IN p_schedule_type_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM schedule_type
    WHERE schedule_type_id = p_schedule_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertScheduleType(IN p_schedule_type_name VARCHAR(100), IN p_last_log_by INT, OUT p_schedule_type_id INT)
BEGIN
    INSERT INTO schedule_type (schedule_type_name, last_log_by) 
	VALUES(p_schedule_type_name, p_last_log_by);
	
    SET p_schedule_type_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateScheduleType(IN p_schedule_type_id INT, IN p_schedule_type_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE work_schedule
    SET schedule_type_name = p_schedule_type_name,
        last_log_by = p_last_log_by
    WHERE schedule_type_id = p_schedule_type_id;

    UPDATE schedule_type
    SET schedule_type_name = p_schedule_type_name,
        last_log_by = p_last_log_by
    WHERE schedule_type_id = p_schedule_type_id;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteScheduleType(IN p_schedule_type_id INT)
BEGIN
    DELETE FROM schedule_type WHERE schedule_type_id = p_schedule_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getScheduleType(IN p_schedule_type_id INT)
BEGIN
	SELECT * FROM schedule_type
	WHERE schedule_type_id = p_schedule_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateScheduleTypeTable()
BEGIN
	SELECT schedule_type_id, schedule_type_name 
    FROM schedule_type 
    ORDER BY schedule_type_id;
END //

CREATE PROCEDURE generateScheduleTypeOptions()
BEGIN
	SELECT schedule_type_id, schedule_type_name 
    FROM schedule_type 
    ORDER BY schedule_type_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */