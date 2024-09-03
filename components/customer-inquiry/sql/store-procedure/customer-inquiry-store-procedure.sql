DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkServicesBoxExist(IN p_customer_inquiry_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM customer_inquiry
    WHERE customer_inquiry_id = p_customer_inquiry_id;
END //

CREATE PROCEDURE checkServicesBoxItemExist(IN p_customer_inquiry_item_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM customer_inquiry_item
    WHERE customer_inquiry_item_id = p_customer_inquiry_item_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertServicesBox(IN p_customer_inquiry_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT, OUT p_customer_inquiry_id INT)
BEGIN
    INSERT INTO customer_inquiry (customer_inquiry_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_customer_inquiry_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_customer_inquiry_id = LAST_INSERT_ID();
END //

CREATE PROCEDURE insertServicesBoxItem(IN p_customer_inquiry_id INT, IN p_customer_inquiry_title VARCHAR(500), IN p_customer_inquiry_heading VARCHAR(500), IN p_customer_inquiry_paragraph LONGTEXT, IN p_call_to_action_button_text VARCHAR(100), IN p_call_to_action_button_link VARCHAR(500), IN p_customer_inquiry_image VARCHAR(500), IN p_order_sequence INT, IN p_last_log_by INT)
BEGIN
    INSERT INTO customer_inquiry_item (customer_inquiry_id, customer_inquiry_title, customer_inquiry_heading, customer_inquiry_paragraph, call_to_action_button_text, call_to_action_button_link, customer_inquiry_image, order_sequence, last_log_by) 
	VALUES(p_customer_inquiry_id, p_customer_inquiry_title, p_customer_inquiry_heading, p_customer_inquiry_paragraph, p_call_to_action_button_text, p_call_to_action_button_link, p_customer_inquiry_image, p_order_sequence, p_last_log_by);
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateServicesBox(IN p_customer_inquiry_id INT, IN p_customer_inquiry_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE customer_inquiry
    SET customer_inquiry_name = p_customer_inquiry_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE customer_inquiry_id = p_customer_inquiry_id;
END //

CREATE PROCEDURE updateServicesBoxPublishStatus(IN p_customer_inquiry_id INT, IN p_publish_status VARCHAR(5), IN p_last_log_by INT)
BEGIN
    UPDATE customer_inquiry
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE customer_inquiry_id = p_customer_inquiry_id;
END //

CREATE PROCEDURE updateServicesBoxItem(IN p_customer_inquiry_item_id INT, IN p_customer_inquiry_id INT, IN p_customer_inquiry_title VARCHAR(500), IN p_customer_inquiry_heading VARCHAR(500), IN p_customer_inquiry_paragraph LONGTEXT, IN p_call_to_action_button_text VARCHAR(100), IN p_call_to_action_button_link VARCHAR(500), IN p_customer_inquiry_image VARCHAR(500), IN p_order_sequence INT, IN p_last_log_by INT)
BEGIN
    IF p_customer_inquiry_image IS NOT NULL AND p_customer_inquiry_image != '' THEN
        UPDATE customer_inquiry_item
        SET customer_inquiry_id = p_customer_inquiry_id,
            customer_inquiry_title = p_customer_inquiry_title,
            customer_inquiry_heading = p_customer_inquiry_heading,
            customer_inquiry_paragraph = p_customer_inquiry_paragraph,
            call_to_action_button_text = p_call_to_action_button_text,
            call_to_action_button_link = p_call_to_action_button_link,
            customer_inquiry_image = p_customer_inquiry_image,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE customer_inquiry_item_id = p_customer_inquiry_item_id;
    ELSE
        UPDATE customer_inquiry_item
        SET customer_inquiry_id = p_customer_inquiry_id,
            customer_inquiry_title = p_customer_inquiry_title,
            customer_inquiry_heading = p_customer_inquiry_heading,
            customer_inquiry_paragraph = p_customer_inquiry_paragraph,
            call_to_action_button_text = p_call_to_action_button_text,
            call_to_action_button_link = p_call_to_action_button_link,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE customer_inquiry_item_id = p_customer_inquiry_item_id;
    END IF;   
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteServicesBox(IN p_customer_inquiry_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM customer_inquiry_item WHERE customer_inquiry_id = p_customer_inquiry_id;
    DELETE FROM customer_inquiry WHERE customer_inquiry_id = p_customer_inquiry_id;

    COMMIT;
END //

CREATE PROCEDURE deleteServicesBoxItem(IN p_customer_inquiry_item_id INT)
BEGIN
   DELETE FROM customer_inquiry_item WHERE customer_inquiry_item_id = p_customer_inquiry_item_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getServicesBox(IN p_customer_inquiry_id INT)
BEGIN
	SELECT * FROM customer_inquiry
	WHERE customer_inquiry_id = p_customer_inquiry_id;
END //

CREATE PROCEDURE getServicesBoxItem(IN p_customer_inquiry_item_id INT)
BEGIN
	SELECT * FROM customer_inquiry_item
	WHERE customer_inquiry_item_id = p_customer_inquiry_item_id;
END //

CREATE PROCEDURE getServicesBoxItemByServicesBoxID(IN p_customer_inquiry_id INT)
BEGIN
	SELECT * FROM customer_inquiry_item
	WHERE customer_inquiry_id = p_customer_inquiry_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateServicesBoxTable()
BEGIN
    SELECT customer_inquiry_id, customer_inquiry_name, description, publish_status
    FROM customer_inquiry;
END //

CREATE PROCEDURE generateServicesBoxItemTable(IN p_customer_inquiry_id INT)
BEGIN
    SELECT customer_inquiry_item_id, customer_inquiry_title, customer_inquiry_heading, customer_inquiry_paragraph, call_to_action_button_text, call_to_action_button_link, customer_inquiry_image, order_sequence 
    FROM customer_inquiry_item
    WHERE customer_inquiry_id = p_customer_inquiry_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */