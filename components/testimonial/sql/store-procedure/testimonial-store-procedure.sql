DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkTestimonialExist(IN p_testimonial_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM testimonial
    WHERE testimonial_id = p_testimonial_id;
END //

CREATE PROCEDURE checkTestimonialItemExist(IN p_testimonial_item_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM testimonial_item
    WHERE testimonial_item_id = p_testimonial_item_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertTestimonial(IN p_testimonial_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT, OUT p_testimonial_id INT)
BEGIN
    INSERT INTO testimonial (testimonial_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_testimonial_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_testimonial_id = LAST_INSERT_ID();
END //

CREATE PROCEDURE insertTestimonialItem(IN p_testimonial_id INT, IN p_testimonial_client VARCHAR(500), IN p_testimonial_title VARCHAR(500), IN p_testimonial_paragraph LONGTEXT, IN p_rating INT, IN p_testimonial_image VARCHAR(500), IN p_order_sequence INT, IN p_last_log_by INT)
BEGIN
    INSERT INTO testimonial_item (testimonial_id, testimonial_client, testimonial_title, testimonial_paragraph, rating, testimonial_image, order_sequence, last_log_by) 
	VALUES(p_testimonial_id, p_testimonial_client, p_testimonial_title, p_testimonial_paragraph, p_rating, p_testimonial_image, p_order_sequence, p_last_log_by);
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateTestimonial(IN p_testimonial_id INT, IN p_testimonial_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE testimonial
    SET testimonial_name = p_testimonial_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE testimonial_id = p_testimonial_id;
END //

CREATE PROCEDURE updateTestimonialPublishStatus(IN p_testimonial_id INT, IN p_publish_status VARCHAR(5), IN p_last_log_by INT)
BEGIN
    UPDATE testimonial
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE testimonial_id = p_testimonial_id;
END //

CREATE PROCEDURE updateTestimonialItem(IN p_testimonial_item_id INT, IN p_testimonial_id INT, IN p_testimonial_client VARCHAR(500), IN p_testimonial_title VARCHAR(500), IN p_testimonial_paragraph LONGTEXT, IN p_rating INT, IN p_testimonial_image VARCHAR(500), IN p_order_sequence INT, IN p_last_log_by INT)
BEGIN
    IF p_testimonial_image IS NOT NULL AND p_testimonial_image != '' THEN
        UPDATE testimonial_item
        SET testimonial_id = p_testimonial_id,
            testimonial_client = p_testimonial_client,
            testimonial_title = p_testimonial_title,
            testimonial_paragraph = p_testimonial_paragraph,
            rating = p_rating,
            testimonial_image = p_testimonial_image,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE testimonial_item_id = p_testimonial_item_id;
    ELSE
        UPDATE testimonial_item
        SET testimonial_id = p_testimonial_id,
            testimonial_client = p_testimonial_client,
            testimonial_title = p_testimonial_title,
            testimonial_paragraph = p_testimonial_paragraph,
            rating = p_rating,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE testimonial_item_id = p_testimonial_item_id;
    END IF;   
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteTestimonial(IN p_testimonial_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM testimonial_item WHERE testimonial_id = p_testimonial_id;
    DELETE FROM testimonial WHERE testimonial_id = p_testimonial_id;

    COMMIT;
END //

CREATE PROCEDURE deleteTestimonialItem(IN p_testimonial_item_id INT)
BEGIN
   DELETE FROM testimonial_item WHERE testimonial_item_id = p_testimonial_item_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getTestimonial(IN p_testimonial_id INT)
BEGIN
	SELECT * FROM testimonial
	WHERE testimonial_id = p_testimonial_id;
END //

CREATE PROCEDURE getTestimonialItem(IN p_testimonial_item_id INT)
BEGIN
	SELECT * FROM testimonial_item
	WHERE testimonial_item_id = p_testimonial_item_id;
END //

CREATE PROCEDURE getTestimonialItemByTestimonialID(IN p_testimonial_id INT)
BEGIN
	SELECT * FROM testimonial_item
	WHERE testimonial_id = p_testimonial_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateTestimonialTable()
BEGIN
    SELECT testimonial_id, testimonial_name, description, publish_status
    FROM testimonial;
END //

CREATE PROCEDURE generateTestimonialItemTable(IN p_testimonial_id INT)
BEGIN
    SELECT testimonial_item_id, testimonial_client, testimonial_title, testimonial_paragraph, rating, testimonial_image, order_sequence 
    FROM testimonial_item
    WHERE testimonial_id = p_testimonial_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */