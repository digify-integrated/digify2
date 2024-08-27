DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkAccordionExist(IN p_accordion_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM accordion
    WHERE accordion_id = p_accordion_id;
END //

CREATE PROCEDURE checkAccordionItemExist(IN p_accordion_item_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM accordion_item
    WHERE accordion_item_id = p_accordion_item_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertAccordion(IN p_accordion_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT, OUT p_accordion_id INT)
BEGIN
    INSERT INTO accordion (accordion_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_accordion_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_accordion_id = LAST_INSERT_ID();
END //

CREATE PROCEDURE insertAccordionItem(IN p_accordion_id INT, IN p_accordion_header VARCHAR(500), IN p_accordion_body LONGTEXT, IN p_order_sequence INT, IN p_last_log_by INT)
BEGIN
    INSERT INTO accordion_item (accordion_id, accordion_header, accordion_body, order_sequence, last_log_by) 
	VALUES(p_accordion_id, p_accordion_header, p_accordion_body, p_order_sequence, p_last_log_by);
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateAccordion(IN p_accordion_id INT, IN p_accordion_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE accordion
    SET accordion_name = p_accordion_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE accordion_id = p_accordion_id;
END //

CREATE PROCEDURE updateAccordionItem(IN p_accordion_item_id INT, IN p_accordion_id INT, IN p_accordion_header VARCHAR(500), IN p_accordion_body LONGTEXT, IN p_order_sequence INT, IN p_last_log_by INT)
BEGIN
    UPDATE accordion_item
    SET accordion_id = p_accordion_id,
        accordion_header = p_accordion_header,
        accordion_body = p_accordion_body,
        order_sequence = p_order_sequence,
        last_log_by = p_last_log_by
    WHERE accordion_item_id = p_accordion_item_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteAccordion(IN p_accordion_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM accordion_item WHERE accordion_id = p_accordion_id;
    DELETE FROM accordion WHERE accordion_id = p_accordion_id;

    COMMIT;
END //

CREATE PROCEDURE deleteAccordionItem(IN p_accordion_item_id INT)
BEGIN
   DELETE FROM accordion_item WHERE accordion_item_id = p_accordion_item_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getAccordion(IN p_accordion_id INT)
BEGIN
	SELECT * FROM accordion
	WHERE accordion_id = p_accordion_id;
END //

CREATE PROCEDURE getAccordionItem(IN p_accordion_item_id INT)
BEGIN
	SELECT * FROM accordion_item
	WHERE accordion_item_id = p_accordion_item_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateAccordionTable()
BEGIN
    SELECT accordion_id, accordion_name, description, publish_status
    FROM accordion;
END //

CREATE PROCEDURE generateAccordionItemTable(IN p_accordion_id INT)
BEGIN
    SELECT accordion_item_id, accordion_header, accordion_body, order_sequence 
    FROM accordion_item
    WHERE accordion_id = p_accordion_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */