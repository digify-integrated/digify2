DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkImageGalleryExist(IN p_image_gallery_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM image_gallery
    WHERE image_gallery_id = p_image_gallery_id;
END //

CREATE PROCEDURE checkImageGalleryItemExist(IN p_image_gallery_item_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM image_gallery_item
    WHERE image_gallery_item_id = p_image_gallery_item_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertImageGallery(IN p_image_gallery_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT, OUT p_image_gallery_id INT)
BEGIN
    INSERT INTO image_gallery (image_gallery_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_image_gallery_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_image_gallery_id = LAST_INSERT_ID();
END //

CREATE PROCEDURE insertImageGalleryItem(IN p_image_gallery_id INT, IN p_image_gallery_title VARCHAR(500), IN p_image_gallery_image VARCHAR(500), IN p_order_sequence INT, IN p_last_log_by INT)
BEGIN
    INSERT INTO image_gallery_item (image_gallery_id, image_gallery_title, image_gallery_image, order_sequence, last_log_by) 
	VALUES(p_image_gallery_id, p_image_gallery_title, p_image_gallery_image, p_order_sequence, p_last_log_by);
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateImageGallery(IN p_image_gallery_id INT, IN p_image_gallery_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE image_gallery
    SET image_gallery_name = p_image_gallery_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE image_gallery_id = p_image_gallery_id;
END //

CREATE PROCEDURE updateImageGalleryPublishStatus(IN p_image_gallery_id INT, IN p_publish_status VARCHAR(5), IN p_last_log_by INT)
BEGIN
    UPDATE image_gallery
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE image_gallery_id = p_image_gallery_id;
END //

CREATE PROCEDURE updateImageGalleryItem(IN p_image_gallery_item_id INT, IN p_image_gallery_id INT, IN p_image_gallery_title VARCHAR(500), IN p_image_gallery_image VARCHAR(500), IN p_order_sequence INT, IN p_last_log_by INT)
BEGIN
    IF p_image_gallery_image IS NOT NULL AND p_image_gallery_image != '' THEN
        UPDATE image_gallery_item
        SET image_gallery_id = p_image_gallery_id,
            image_gallery_title = p_image_gallery_title,
            image_gallery_image = p_image_gallery_image,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE image_gallery_item_id = p_image_gallery_item_id;
    ELSE
        UPDATE image_gallery_item
        SET image_gallery_id = p_image_gallery_id,
            image_gallery_title = p_image_gallery_title,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE image_gallery_item_id = p_image_gallery_item_id;
    END IF;   
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteImageGallery(IN p_image_gallery_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM image_gallery_item WHERE image_gallery_id = p_image_gallery_id;
    DELETE FROM image_gallery WHERE image_gallery_id = p_image_gallery_id;

    COMMIT;
END //

CREATE PROCEDURE deleteImageGalleryItem(IN p_image_gallery_item_id INT)
BEGIN
   DELETE FROM image_gallery_item WHERE image_gallery_item_id = p_image_gallery_item_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getImageGallery(IN p_image_gallery_id INT)
BEGIN
	SELECT * FROM image_gallery
	WHERE image_gallery_id = p_image_gallery_id;
END //

CREATE PROCEDURE getImageGalleryItem(IN p_image_gallery_item_id INT)
BEGIN
	SELECT * FROM image_gallery_item
	WHERE image_gallery_item_id = p_image_gallery_item_id;
END //

CREATE PROCEDURE getImageGalleryItemByImageGalleryID(IN p_image_gallery_id INT)
BEGIN
	SELECT * FROM image_gallery_item
	WHERE image_gallery_id = p_image_gallery_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateImageGalleryTable()
BEGIN
    SELECT image_gallery_id, image_gallery_name, description, publish_status
    FROM image_gallery;
END //

CREATE PROCEDURE generateImageGalleryItemTable(IN p_image_gallery_id INT)
BEGIN
    SELECT image_gallery_item_id, image_gallery_title, image_gallery_image, order_sequence 
    FROM image_gallery_item
    WHERE image_gallery_id = p_image_gallery_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */