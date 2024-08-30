DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkClientExist(IN p_client_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM client
    WHERE client_id = p_client_id;
END //

CREATE PROCEDURE checkClientItemExist(IN p_client_item_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM client_item
    WHERE client_item_id = p_client_item_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertClient(IN p_client_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT, OUT p_client_id INT)
BEGIN
    INSERT INTO client (client_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_client_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_client_id = LAST_INSERT_ID();
END //

CREATE PROCEDURE insertClientItem(IN p_client_id INT, IN p_client_logo VARCHAR(500), IN p_client_url VARCHAR(500), IN p_order_sequence INT, IN p_last_log_by INT)
BEGIN
    INSERT INTO client_item (client_id, client_logo, client_url, order_sequence, last_log_by) 
	VALUES(p_client_id, p_client_logo, p_client_url, p_order_sequence, p_last_log_by);
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateClient(IN p_client_id INT, IN p_client_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE client
    SET client_name = p_client_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE client_id = p_client_id;
END //

CREATE PROCEDURE updateClientPublishStatus(IN p_client_id INT, IN p_publish_status VARCHAR(5), IN p_last_log_by INT)
BEGIN
    UPDATE client
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE client_id = p_client_id;
END //

CREATE PROCEDURE updateClientItem(IN p_client_item_id INT, IN p_client_id INT, IN p_client_logo VARCHAR(500), IN p_client_url VARCHAR(500), IN p_order_sequence INT, IN p_last_log_by INT)
BEGIN
    IF p_client_logo IS NOT NULL AND p_client_logo != '' THEN
        UPDATE client_item
        SET client_id = p_client_id,
            client_logo = p_client_logo,
            client_url = p_client_url,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE client_item_id = p_client_item_id;
    ELSE
        UPDATE client_item
        SET client_id = p_client_id,
            client_url = p_client_url,
            order_sequence = p_order_sequence,
            last_log_by = p_last_log_by
        WHERE client_item_id = p_client_item_id;
    END IF;   
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteClient(IN p_client_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM client_item WHERE client_id = p_client_id;
    DELETE FROM client WHERE client_id = p_client_id;

    COMMIT;
END //

CREATE PROCEDURE deleteClientItem(IN p_client_item_id INT)
BEGIN
   DELETE FROM client_item WHERE client_item_id = p_client_item_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getClient(IN p_client_id INT)
BEGIN
	SELECT * FROM client
	WHERE client_id = p_client_id;
END //

CREATE PROCEDURE getClientItem(IN p_client_item_id INT)
BEGIN
	SELECT * FROM client_item
	WHERE client_item_id = p_client_item_id;
END //

CREATE PROCEDURE getClientItemByClientID(IN p_client_id INT)
BEGIN
	SELECT * FROM client_item
	WHERE client_id = p_client_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateClientTable()
BEGIN
    SELECT client_id, client_name, description, publish_status
    FROM client;
END //

CREATE PROCEDURE generateClientItemTable(IN p_client_id INT)
BEGIN
    SELECT client_item_id, client_logo, client_url, order_sequence 
    FROM client_item
    WHERE client_id = p_client_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */