DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkSliderExist(IN p_slider_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM slider
    WHERE slider_id = p_slider_id;
END //

CREATE PROCEDURE checkSliderItemExist(IN p_slider_item_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM slider_item
    WHERE slider_item_id = p_slider_item_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertSlider(IN p_slider_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT, OUT p_slider_id INT)
BEGIN
    INSERT INTO slider (slider_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_slider_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_slider_id = LAST_INSERT_ID();
END //

CREATE PROCEDURE insertSliderItem(IN p_slider_id INT, IN p_slider_title VARCHAR(500), IN p_slider_heading VARCHAR(500), IN p_slider_paragraph LONGTEXT, IN p_call_to_action_button_1_text VARCHAR(100), IN p_call_to_action_button_1_link VARCHAR(500), IN p_call_to_action_button_2_text VARCHAR(100), IN p_call_to_action_button_2_link VARCHAR(500), IN p_slider_image VARCHAR(500), IN p_order_sequence INT, IN p_last_log_by INT)
BEGIN
    INSERT INTO slider_item (slider_id, slider_title, slider_heading, slider_paragraph, call_to_action_button_1_text, call_to_action_button_1_link, call_to_action_button_2_text, call_to_action_button_2_link, slider_image, order_sequence, last_log_by) 
	VALUES(p_slider_id, p_slider_title, p_slider_heading, p_slider_paragraph, p_call_to_action_button_1_text, p_call_to_action_button_1_link, p_call_to_action_button_2_text, p_call_to_action_button_2_link, p_slider_image, p_order_sequence, p_last_log_by);
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateSlider(IN p_slider_id INT, IN p_slider_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE slider
    SET slider_name = p_slider_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE slider_id = p_slider_id;
END //

CREATE PROCEDURE updateSliderPublishStatus(IN p_slider_id INT, IN p_publish_status VARCHAR(5), IN p_last_log_by INT)
BEGIN
    UPDATE slider
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE slider_id = p_slider_id;
END //

CREATE PROCEDURE updateSliderItem(IN p_slider_item_id INT, IN p_slider_id INT, IN p_slider_title VARCHAR(500), IN p_slider_heading VARCHAR(500), IN p_slider_paragraph LONGTEXT, IN p_call_to_action_button_1_text VARCHAR(100), IN p_call_to_action_button_1_link VARCHAR(500), IN p_call_to_action_button_2_text VARCHAR(100), IN p_call_to_action_button_2_link VARCHAR(500), IN p_slider_image VARCHAR(500), IN p_order_sequence INT, IN p_last_log_by INT)
BEGIN
    IF p_slider_image IS NOT NULL AND p_slider_image != '' THEN
        UPDATE slider_item
        SET slider_id = p_slider_id,
            slider_title = p_slider_title,
            slider_heading = p_slider_heading,
            slider_paragraph = p_slider_paragraph,
            call_to_action_button_1_text = p_call_to_action_button_1_text,
            call_to_action_button_1_link = p_call_to_action_button_1_link,
            call_to_action_button_2_text = p_call_to_action_button_2_text,
            call_to_action_button_2_link = p_call_to_action_button_2_link,
            slider_image = p_slider_image,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE slider_item_id = p_slider_item_id;
    ELSE
        UPDATE slider_item
        SET slider_id = p_slider_id,
            slider_title = p_slider_title,
            slider_heading = p_slider_heading,
            slider_paragraph = p_slider_paragraph,
            call_to_action_button_1_text = p_call_to_action_button_1_text,
            call_to_action_button_1_link = p_call_to_action_button_1_link,
            call_to_action_button_2_text = p_call_to_action_button_2_text,
            call_to_action_button_2_link = p_call_to_action_button_2_link,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE slider_item_id = p_slider_item_id;
    END IF;   
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteSlider(IN p_slider_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM slider_item WHERE slider_id = p_slider_id;
    DELETE FROM slider WHERE slider_id = p_slider_id;

    COMMIT;
END //

CREATE PROCEDURE deleteSliderItem(IN p_slider_item_id INT)
BEGIN
   DELETE FROM slider_item WHERE slider_item_id = p_slider_item_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getSlider(IN p_slider_id INT)
BEGIN
	SELECT * FROM slider
	WHERE slider_id = p_slider_id;
END //

CREATE PROCEDURE getSliderItem(IN p_slider_item_id INT)
BEGIN
	SELECT * FROM slider_item
	WHERE slider_item_id = p_slider_item_id;
END //

CREATE PROCEDURE getSliderItemBySliderID(IN p_slider_id INT)
BEGIN
	SELECT * FROM slider_item
	WHERE slider_id = p_slider_id
    ORDER BY order_sequence;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateSliderTable()
BEGIN
    SELECT slider_id, slider_name, description, publish_status
    FROM slider;
END //

CREATE PROCEDURE generateSliderItemTable(IN p_slider_id INT)
BEGIN
    SELECT slider_item_id, slider_title, slider_heading, slider_paragraph, call_to_action_button_1_text, call_to_action_button_1_link, call_to_action_button_2_text, call_to_action_button_2_link, slider_image, order_sequence 
    FROM slider_item
    WHERE slider_id = p_slider_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */