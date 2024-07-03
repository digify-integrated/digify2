DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkEducationalStageExist(IN p_educational_stage_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM educational_stage
    WHERE educational_stage_id = p_educational_stage_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertEducationalStage(IN p_educational_stage_name VARCHAR(100), IN p_last_log_by INT, OUT p_educational_stage_id INT)
BEGIN
    INSERT INTO educational_stage (educational_stage_name, last_log_by) 
	VALUES(p_educational_stage_name, p_last_log_by);
	
    SET p_educational_stage_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateEducationalStage(IN p_educational_stage_id INT, IN p_educational_stage_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE educational_stage
    SET educational_stage_name = p_educational_stage_name,
        last_log_by = p_last_log_by
    WHERE educational_stage_id = p_educational_stage_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteEducationalStage(IN p_educational_stage_id INT)
BEGIN
    DELETE FROM educational_stage WHERE educational_stage_id = p_educational_stage_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getEducationalStage(IN p_educational_stage_id INT)
BEGIN
	SELECT * FROM educational_stage
	WHERE educational_stage_id = p_educational_stage_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateEducationalStageTable()
BEGIN
	SELECT educational_stage_id, educational_stage_name 
    FROM educational_stage 
    ORDER BY educational_stage_id;
END //

CREATE PROCEDURE generateEducationalStageOptions()
BEGIN
	SELECT educational_stage_id, educational_stage_name 
    FROM educational_stage 
    ORDER BY educational_stage_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */