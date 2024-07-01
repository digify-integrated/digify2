DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkJobPositionExist(IN p_job_position_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM job_position
    WHERE job_position_id = p_job_position_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertJobPosition(IN p_job_position_name VARCHAR(100), IN p_last_log_by INT, OUT p_job_position_id INT)
BEGIN
    INSERT INTO job_position (job_position_name, last_log_by) 
	VALUES(p_job_position_name, p_last_log_by);
	
    SET p_job_position_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateJobPosition(IN p_job_position_id INT, IN p_job_position_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE job_position
    SET job_position_name = p_job_position_name,
        last_log_by = p_last_log_by
    WHERE job_position_id = p_job_position_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteJobPosition(IN p_job_position_id INT)
BEGIN
    DELETE FROM job_position WHERE job_position_id = p_job_position_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getJobPosition(IN p_job_position_id INT)
BEGIN
	SELECT * FROM job_position
	WHERE job_position_id = p_job_position_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateJobPositionTable()
BEGIN
	SELECT job_position_id, job_position_name 
    FROM job_position 
    ORDER BY job_position_id;
END //

CREATE PROCEDURE generateJobPositionOptions()
BEGIN
	SELECT job_position_id, job_position_name 
    FROM job_position 
    ORDER BY job_position_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */