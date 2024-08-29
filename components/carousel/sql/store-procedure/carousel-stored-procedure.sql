DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkCarouselExist(IN p_carousel_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM carousel
    WHERE carousel_id = p_carousel_id;
END //

CREATE PROCEDURE checkCarouselImageExist(IN p_carousel_image_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM carousel_image
    WHERE carousel_image_id = p_carousel_image_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertCarousel(IN p_carousel_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT, OUT p_carousel_id INT)
BEGIN
    INSERT INTO carousel (carousel_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_carousel_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_carousel_id = LAST_INSERT_ID();
END //

CREATE PROCEDURE insertCarouselImage(IN p_carousel_id INT, IN p_carousel_image VARCHAR(500), IN p_order_sequence INT, IN p_last_log_by INT)
BEGIN
    INSERT INTO carousel_image (carousel_id, carousel_image, order_sequence, last_log_by) 
	VALUES(p_carousel_id, p_carousel_image, p_order_sequence, p_last_log_by);
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateCarousel(IN p_carousel_id INT, IN p_carousel_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE carousel
    SET carousel_name = p_carousel_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE carousel_id = p_carousel_id;
END //

CREATE PROCEDURE updateCarouselPublishStatus(IN p_carousel_id INT, IN p_publish_status VARCHAR(5), IN p_last_log_by INT)
BEGIN
    UPDATE carousel
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE carousel_id = p_carousel_id;
END //

CREATE PROCEDURE updateCarouselImage(IN p_carousel_image_id INT, IN p_carousel_id INT, IN p_p_carousel_image VARCHAR(500), IN p_order_sequence INT, IN p_last_log_by INT)
BEGIN
    UPDATE carousel_image
    SET carousel_id = p_carousel_id,
        carousel_image = p_carousel_image,
        order_sequence = p_order_sequence,
        last_log_by = p_last_log_by
    WHERE carousel_image_id = p_carousel_image_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteCarousel(IN p_carousel_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM carousel_image WHERE carousel_id = p_carousel_id;
    DELETE FROM carousel WHERE carousel_id = p_carousel_id;

    COMMIT;
END //

CREATE PROCEDURE deleteCarouselImage(IN p_carousel_image_id INT)
BEGIN
   DELETE FROM carousel_image WHERE carousel_image_id = p_carousel_image_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getCarousel(IN p_carousel_id INT)
BEGIN
	SELECT * FROM carousel
	WHERE carousel_id = p_carousel_id;
END //

CREATE PROCEDURE getCarouselImage(IN p_carousel_image_id INT)
BEGIN
	SELECT * FROM carousel_image
	WHERE carousel_image_id = p_carousel_image_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateCarouselTable()
BEGIN
    SELECT carousel_id, carousel_name, description, publish_status
    FROM carousel;
END //

CREATE PROCEDURE generateCarouselImageTable(IN p_carousel_id INT)
BEGIN
    SELECT carousel_image_id, carousel_image, order_sequence 
    FROM carousel_image
    WHERE carousel_id = p_carousel_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */