DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkCallToActionExist(IN p_call_to_action_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM call_to_action
    WHERE call_to_action_id = p_call_to_action_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertCallToAction(IN p_call_to_action_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_call_to_action_header VARCHAR(500), IN p_call_to_action_body LONGTEXT, IN p_last_log_by INT, OUT p_call_to_action_id INT)
BEGIN
    INSERT INTO call_to_action (call_to_action_name, description, block_style_id, block_style_name, call_to_action_header, call_to_action_body, last_log_by) 
	VALUES(p_call_to_action_name, p_description, p_block_style_id, p_block_style_name, p_call_to_action_header, p_call_to_action_body, p_last_log_by);
	
    SET p_call_to_action_id = LAST_INSERT_ID();
END //
/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateCallToAction(IN p_call_to_action_id INT, IN p_call_to_action_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_call_to_action_header VARCHAR(500), IN p_call_to_action_body LONGTEXT, IN p_last_log_by INT)
BEGIN
    UPDATE call_to_action
    SET call_to_action_name = p_call_to_action_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        call_to_action_header = p_call_to_action_header,
        call_to_action_body = p_call_to_action_body,
        last_log_by = p_last_log_by
    WHERE call_to_action_id = p_call_to_action_id;
END //

CREATE PROCEDURE updateCallToActionPublishStatus(IN p_call_to_action_id INT, IN p_publish_status VARCHAR(5), IN p_last_log_by INT)
BEGIN
    UPDATE call_to_action
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE call_to_action_id = p_call_to_action_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteCallToAction(IN p_call_to_action_id INT)
BEGIN
   DELETE FROM call_to_action WHERE call_to_action_id = p_call_to_action_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getCallToAction(IN p_call_to_action_id INT)
BEGIN
	SELECT * FROM call_to_action
	WHERE call_to_action_id = p_call_to_action_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateCallToActionTable()
BEGIN
    SELECT call_to_action_id, call_to_action_name, description, publish_status
    FROM call_to_action;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */