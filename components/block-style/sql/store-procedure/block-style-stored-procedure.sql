DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkBlockStyleExist(IN p_block_style_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM block_style
    WHERE block_style_id = p_block_style_id;
END //

CREATE PROCEDURE checkBlockContainerExist(IN p_block_style_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM block_container
    WHERE block_style_id = p_block_style_id;
END //

CREATE PROCEDURE checkBlockItemExist(IN p_block_style_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM block_item
    WHERE block_style_id = p_block_style_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertBlockStyle(IN p_block_style_name VARCHAR(100), IN p_description VARCHAR(500), IN p_block_type_id INT, IN p_block_type_name VARCHAR(100), IN p_last_log_by INT, OUT p_block_style_id INT)
BEGIN
    INSERT INTO block_style (block_style_name, description, block_type_id, block_type_name, last_log_by) 
	VALUES(p_block_style_name, p_description, p_block_type_id, p_block_type_name, p_last_log_by);
	
    SET p_block_style_id = LAST_INSERT_ID();
END //

CREATE PROCEDURE insertBlockContainer(IN p_block_style_id INT, IN p_block_container LONGTEXT, IN p_last_log_by INT)
BEGIN
    INSERT INTO block_container (block_style_id, block_container, last_log_by) 
	VALUES(p_block_style_id, p_block_container, p_last_log_by);
END //

CREATE PROCEDURE insertBlockItem(IN p_block_style_id INT, IN p_block_item LONGTEXT, IN p_last_log_by INT)
BEGIN
    INSERT INTO block_item (block_style_id, block_item, last_log_by) 
	VALUES(p_block_style_id, p_block_item, p_last_log_by);
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateBlockStyle(IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_description VARCHAR(500), IN p_block_type_id INT, IN p_block_type_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE block_style
    SET block_style_name = p_block_style_name,
        description = p_description,
        block_type_id = p_block_type_id,
        block_type_name = p_block_type_name,
        last_log_by = p_last_log_by
    WHERE block_style_id = p_block_style_id;

    COMMIT;
END //

CREATE PROCEDURE updateBlockContainer(IN p_block_style_id INT, IN p_block_container LONGTEXT, IN p_last_log_by INT)
BEGIN
    UPDATE block_container
    SET block_container = p_block_container,
        last_log_by = p_last_log_by
    WHERE block_style_id = p_block_style_id;
END //

CREATE PROCEDURE updateBlockItem(IN p_block_style_id INT, IN p_block_item LONGTEXT, IN p_last_log_by INT)
BEGIN
    UPDATE block_item
    SET block_item = p_block_item,
        last_log_by = p_last_log_by
    WHERE block_style_id = p_block_style_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteBlockStyle(IN p_block_style_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM block_container WHERE block_style_id = p_block_style_id;
    DELETE FROM block_item WHERE block_style_id = p_block_style_id;
    DELETE FROM block_style WHERE block_style_id = p_block_style_id;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getBlockStyle(IN p_block_style_id INT)
BEGIN
	SELECT * FROM block_style
	WHERE block_style_id = p_block_style_id;
END //

CREATE PROCEDURE getBlockContainer(IN p_block_style_id INT)
BEGIN
	SELECT * FROM block_container
	WHERE block_style_id = p_block_style_id;
END //

CREATE PROCEDURE getBlockItem(IN p_block_style_id INT)
BEGIN
	SELECT * FROM block_item
	WHERE block_style_id = p_block_style_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateBlockStyleTable()
BEGIN
	SELECT block_style_id, block_style_name, description
    FROM block_style 
    ORDER BY block_style_id;
END //

CREATE PROCEDURE generateBlockStyleOptions()
BEGIN
	SELECT block_style_id, block_style_name 
    FROM block_style 
    ORDER BY block_style_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */