DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkProcesStepExist(IN p_process_step_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM process_step
    WHERE process_step_id = p_process_step_id;
END //

CREATE PROCEDURE checkProcesStepItemExist(IN p_process_step_item_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM process_step_item
    WHERE process_step_item_id = p_process_step_item_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertProcesStep(IN p_process_step_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT, OUT p_process_step_id INT)
BEGIN
    INSERT INTO process_step (process_step_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_process_step_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_process_step_id = LAST_INSERT_ID();
END //

CREATE PROCEDURE insertProcesStepItem(IN p_process_step_id INT, IN p_process_step_title VARCHAR(500), IN p_process_step_heading VARCHAR(500), IN p_process_step_link VARCHAR(500), IN p_process_step_image VARCHAR(500), IN p_order_sequence INT, IN p_last_log_by INT)
BEGIN
    INSERT INTO process_step_item (process_step_id, process_step_title, process_step_heading, process_step_link, process_step_image, order_sequence, last_log_by) 
	VALUES(p_process_step_id, p_process_step_title, p_process_step_heading, p_process_step_link, p_process_step_image, p_order_sequence, p_last_log_by);
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateProcesStep(IN p_process_step_id INT, IN p_process_step_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE process_step
    SET process_step_name = p_process_step_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE process_step_id = p_process_step_id;
END //

CREATE PROCEDURE updateProcesStepPublishStatus(IN p_process_step_id INT, IN p_publish_status VARCHAR(5), IN p_last_log_by INT)
BEGIN
    UPDATE process_step
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE process_step_id = p_process_step_id;
END //

CREATE PROCEDURE updateProcesStepItem(IN p_process_step_item_id INT, IN p_process_step_id INT, IN p_process_step_title VARCHAR(500), IN p_process_step_heading VARCHAR(500), IN p_process_step_link VARCHAR(500), IN p_process_step_image VARCHAR(500), IN p_order_sequence INT, IN p_last_log_by INT)
BEGIN
    IF p_process_step_image IS NOT NULL AND p_process_step_image != '' THEN
        UPDATE process_step_item
        SET process_step_id = p_process_step_id,
            process_step_title = p_process_step_title,
            process_step_heading = p_process_step_heading,
            process_step_link = p_process_step_link,
            process_step_image = p_process_step_image,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE process_step_item_id = p_process_step_item_id;
    ELSE
        UPDATE process_step_item
        SET process_step_id = p_process_step_id,
            process_step_title = p_process_step_title,
            process_step_heading = p_process_step_heading,
            process_step_link = p_process_step_link,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE process_step_item_id = p_process_step_item_id;
    END IF;   
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteProcesStep(IN p_process_step_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM process_step_item WHERE process_step_id = p_process_step_id;
    DELETE FROM process_step WHERE process_step_id = p_process_step_id;

    COMMIT;
END //

CREATE PROCEDURE deleteProcesStepItem(IN p_process_step_item_id INT)
BEGIN
   DELETE FROM process_step_item WHERE process_step_item_id = p_process_step_item_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getProcesStep(IN p_process_step_id INT)
BEGIN
	SELECT * FROM process_step
	WHERE process_step_id = p_process_step_id;
END //

CREATE PROCEDURE getProcesStepItem(IN p_process_step_item_id INT)
BEGIN
	SELECT * FROM process_step_item
	WHERE process_step_item_id = p_process_step_item_id;
END //

CREATE PROCEDURE getProcesStepItemByProcesStepID(IN p_process_step_id INT)
BEGIN
	SELECT * FROM process_step_item
	WHERE process_step_id = p_process_step_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateProcesStepTable()
BEGIN
    SELECT process_step_id, process_step_name, description, publish_status
    FROM process_step;
END //

CREATE PROCEDURE generateProcesStepItemTable(IN p_process_step_id INT)
BEGIN
    SELECT process_step_item_id, process_step_title, process_step_heading, process_step_link, process_step_image, order_sequence 
    FROM process_step_item
    WHERE process_step_id = p_process_step_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */