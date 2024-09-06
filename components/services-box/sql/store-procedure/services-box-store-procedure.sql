DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkServicesBoxExist(IN p_services_box_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM services_box
    WHERE services_box_id = p_services_box_id;
END //

CREATE PROCEDURE checkServicesBoxItemExist(IN p_services_box_item_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM services_box_item
    WHERE services_box_item_id = p_services_box_item_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertServicesBox(IN p_services_box_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT, OUT p_services_box_id INT)
BEGIN
    INSERT INTO services_box (services_box_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_services_box_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_services_box_id = LAST_INSERT_ID();
END //

CREATE PROCEDURE insertServicesBoxItem(IN p_services_box_id INT, IN p_services_box_title VARCHAR(500), IN p_services_box_heading VARCHAR(500), IN p_services_box_paragraph LONGTEXT, IN p_call_to_action_button_text VARCHAR(100), IN p_call_to_action_button_link VARCHAR(500), IN p_services_box_image VARCHAR(500), IN p_order_sequence INT, IN p_last_log_by INT)
BEGIN
    INSERT INTO services_box_item (services_box_id, services_box_title, services_box_heading, services_box_paragraph, call_to_action_button_text, call_to_action_button_link, services_box_image, order_sequence, last_log_by) 
	VALUES(p_services_box_id, p_services_box_title, p_services_box_heading, p_services_box_paragraph, p_call_to_action_button_text, p_call_to_action_button_link, p_services_box_image, p_order_sequence, p_last_log_by);
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateServicesBox(IN p_services_box_id INT, IN p_services_box_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE services_box
    SET services_box_name = p_services_box_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE services_box_id = p_services_box_id;
END //

CREATE PROCEDURE updateServicesBoxPublishStatus(IN p_services_box_id INT, IN p_publish_status VARCHAR(5), IN p_last_log_by INT)
BEGIN
    UPDATE services_box
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE services_box_id = p_services_box_id;
END //

CREATE PROCEDURE updateServicesBoxItem(IN p_services_box_item_id INT, IN p_services_box_id INT, IN p_services_box_title VARCHAR(500), IN p_services_box_heading VARCHAR(500), IN p_services_box_paragraph LONGTEXT, IN p_call_to_action_button_text VARCHAR(100), IN p_call_to_action_button_link VARCHAR(500), IN p_services_box_image VARCHAR(500), IN p_order_sequence INT, IN p_last_log_by INT)
BEGIN
    IF p_services_box_image IS NOT NULL AND p_services_box_image != '' THEN
        UPDATE services_box_item
        SET services_box_id = p_services_box_id,
            services_box_title = p_services_box_title,
            services_box_heading = p_services_box_heading,
            services_box_paragraph = p_services_box_paragraph,
            call_to_action_button_text = p_call_to_action_button_text,
            call_to_action_button_link = p_call_to_action_button_link,
            services_box_image = p_services_box_image,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE services_box_item_id = p_services_box_item_id;
    ELSE
        UPDATE services_box_item
        SET services_box_id = p_services_box_id,
            services_box_title = p_services_box_title,
            services_box_heading = p_services_box_heading,
            services_box_paragraph = p_services_box_paragraph,
            call_to_action_button_text = p_call_to_action_button_text,
            call_to_action_button_link = p_call_to_action_button_link,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE services_box_item_id = p_services_box_item_id;
    END IF;   
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteServicesBox(IN p_services_box_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM services_box_item WHERE services_box_id = p_services_box_id;
    DELETE FROM services_box WHERE services_box_id = p_services_box_id;

    COMMIT;
END //

CREATE PROCEDURE deleteServicesBoxItem(IN p_services_box_item_id INT)
BEGIN
   DELETE FROM services_box_item WHERE services_box_item_id = p_services_box_item_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getServicesBox(IN p_services_box_id INT)
BEGIN
	SELECT * FROM services_box
	WHERE services_box_id = p_services_box_id;
END //

CREATE PROCEDURE getServicesBoxItem(IN p_services_box_item_id INT)
BEGIN
	SELECT * FROM services_box_item
	WHERE services_box_item_id = p_services_box_item_id;
END //

CREATE PROCEDURE getServicesBoxItemByServicesBoxID(IN p_services_box_id INT)
BEGIN
	SELECT * FROM services_box_item
	WHERE services_box_id = p_services_box_id
    ORDER BY order_sequence;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateServicesBoxTable()
BEGIN
    SELECT services_box_id, services_box_name, description, publish_status
    FROM services_box;
END //

CREATE PROCEDURE generateServicesBoxItemTable(IN p_services_box_id INT)
BEGIN
    SELECT services_box_item_id, services_box_title, services_box_heading, services_box_paragraph, call_to_action_button_text, call_to_action_button_link, services_box_image, order_sequence 
    FROM services_box_item
    WHERE services_box_id = p_services_box_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */