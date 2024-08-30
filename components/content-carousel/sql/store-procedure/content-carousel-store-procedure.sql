DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkContentCarouselExist(IN p_content_carousel_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM content_carousel
    WHERE content_carousel_id = p_content_carousel_id;
END //

CREATE PROCEDURE checkContentCarouselItemExist(IN p_content_carousel_item_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM content_carousel_item
    WHERE content_carousel_item_id = p_content_carousel_item_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertContentCarousel(IN p_content_carousel_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT, OUT p_content_carousel_id INT)
BEGIN
    INSERT INTO content_carousel (content_carousel_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_content_carousel_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_content_carousel_id = LAST_INSERT_ID();
END //

CREATE PROCEDURE insertContentCarouselItem(IN p_content_carousel_id INT, IN p_content_carousel_title VARCHAR(500), IN p_content_carousel_heading VARCHAR(500), IN p_content_carousel_paragraph LONGTEXT, IN p_call_to_action_button_1_text VARCHAR(100), IN p_call_to_action_button_1_link VARCHAR(500), IN p_call_to_action_button_2_text VARCHAR(100), IN p_call_to_action_button_2_link VARCHAR(500), IN p_content_carousel_image VARCHAR(500), IN p_order_sequence INT, IN p_last_log_by INT)
BEGIN
    INSERT INTO content_carousel_item (content_carousel_id, content_carousel_title, content_carousel_heading, content_carousel_paragraph, call_to_action_button_1_text, call_to_action_button_1_link, call_to_action_button_2_text, call_to_action_button_2_link, content_carousel_image, order_sequence, last_log_by) 
	VALUES(p_content_carousel_id, p_content_carousel_title, p_content_carousel_heading, p_content_carousel_paragraph, p_call_to_action_button_1_text, p_call_to_action_button_1_link, p_call_to_action_button_2_text, p_call_to_action_button_2_link, p_content_carousel_image, p_order_sequence, p_last_log_by);
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateContentCarousel(IN p_content_carousel_id INT, IN p_content_carousel_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE content_carousel
    SET content_carousel_name = p_content_carousel_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE content_carousel_id = p_content_carousel_id;
END //

CREATE PROCEDURE updateContentCarouselPublishStatus(IN p_content_carousel_id INT, IN p_publish_status VARCHAR(5), IN p_last_log_by INT)
BEGIN
    UPDATE content_carousel
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE content_carousel_id = p_content_carousel_id;
END //

CREATE PROCEDURE updateContentCarouselItem(IN p_content_carousel_item_id INT, IN p_content_carousel_id INT, IN p_content_carousel_title VARCHAR(500), IN p_content_carousel_heading VARCHAR(500), IN p_content_carousel_paragraph LONGTEXT, IN p_call_to_action_button_1_text VARCHAR(100), IN p_call_to_action_button_1_link VARCHAR(500), IN p_call_to_action_button_2_text VARCHAR(100), IN p_call_to_action_button_2_link VARCHAR(500), IN p_content_carousel_image VARCHAR(500), IN p_order_sequence INT, IN p_last_log_by INT)
BEGIN
    IF p_content_carousel_image IS NOT NULL AND p_content_carousel_image != '' THEN
        UPDATE content_carousel_item
        SET content_carousel_id = p_content_carousel_id,
            content_carousel_title = p_content_carousel_title,
            content_carousel_heading = p_content_carousel_heading,
            content_carousel_paragraph = p_content_carousel_paragraph,
            call_to_action_button_1_text = p_call_to_action_button_1_text,
            call_to_action_button_1_link = p_call_to_action_button_1_link,
            call_to_action_button_2_text = p_call_to_action_button_2_text,
            call_to_action_button_2_link = p_call_to_action_button_2_link,
            content_carousel_image = p_content_carousel_image,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE content_carousel_item_id = p_content_carousel_item_id;
    ELSE
        UPDATE content_carousel_item
        SET content_carousel_id = p_content_carousel_id,
            content_carousel_title = p_content_carousel_title,
            content_carousel_heading = p_content_carousel_heading,
            content_carousel_paragraph = p_content_carousel_paragraph,
            call_to_action_button_1_text = p_call_to_action_button_1_text,
            call_to_action_button_1_link = p_call_to_action_button_1_link,
            call_to_action_button_2_text = p_call_to_action_button_2_text,
            call_to_action_button_2_link = p_call_to_action_button_2_link,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE content_carousel_item_id = p_content_carousel_item_id;
    END IF;   
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteContentCarousel(IN p_content_carousel_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM content_carousel_item WHERE content_carousel_id = p_content_carousel_id;
    DELETE FROM content_carousel WHERE content_carousel_id = p_content_carousel_id;

    COMMIT;
END //

CREATE PROCEDURE deleteContentCarouselItem(IN p_content_carousel_item_id INT)
BEGIN
   DELETE FROM content_carousel_item WHERE content_carousel_item_id = p_content_carousel_item_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getContentCarousel(IN p_content_carousel_id INT)
BEGIN
	SELECT * FROM content_carousel
	WHERE content_carousel_id = p_content_carousel_id;
END //

CREATE PROCEDURE getContentCarouselItem(IN p_content_carousel_item_id INT)
BEGIN
	SELECT * FROM content_carousel_item
	WHERE content_carousel_item_id = p_content_carousel_item_id;
END //

CREATE PROCEDURE getContentCarouselItemByContentCarouselID(IN p_content_carousel_id INT)
BEGIN
	SELECT * FROM content_carousel_item
	WHERE content_carousel_id = p_content_carousel_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateContentCarouselTable()
BEGIN
    SELECT content_carousel_id, content_carousel_name, description, publish_status
    FROM content_carousel;
END //

CREATE PROCEDURE generateContentCarouselItemTable(IN p_content_carousel_id INT)
BEGIN
    SELECT content_carousel_item_id, content_carousel_title, content_carousel_heading, content_carousel_paragraph, call_to_action_button_1_text, call_to_action_button_1_link, call_to_action_button_2_text, call_to_action_button_2_link, content_carousel_image, order_sequence 
    FROM content_carousel_item
    WHERE content_carousel_id = p_content_carousel_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */