DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkPricingTableExist(IN p_pricing_table_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM pricing_table
    WHERE pricing_table_id = p_pricing_table_id;
END //
/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertPricingTable(IN p_pricing_table_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT, OUT p_pricing_table_id INT)
BEGIN
    INSERT INTO pricing_table (pricing_table_name, description, block_style_id, block_style_name, last_log_by) 
	VALUES(p_pricing_table_name, p_description, p_block_style_id, p_block_style_name, p_last_log_by);
	
    SET p_pricing_table_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updatePricingTable(IN p_pricing_table_id INT, IN p_pricing_table_name VARCHAR(100), IN p_description VARCHAR(100), IN p_block_style_id INT, IN p_block_style_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE pricing_table
    SET pricing_table_name = p_pricing_table_name,
        description = p_description,
        block_style_id = p_block_style_id,
        block_style_name = p_block_style_name,
        last_log_by = p_last_log_by
    WHERE pricing_table_id = p_pricing_table_id;
END //

CREATE PROCEDURE updatePricingTablePublishStatus(IN p_pricing_table_id INT, IN p_publish_status VARCHAR(5), IN p_last_log_by INT)
BEGIN
    UPDATE pricing_table
    SET publish_status = p_publish_status,
        last_log_by = p_last_log_by
    WHERE pricing_table_id = p_pricing_table_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deletePricingTable(IN p_pricing_table_id INT)
BEGIN
    DELETE FROM pricing_table WHERE pricing_table_id = p_pricing_table_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getPricingTable(IN p_pricing_table_id INT)
BEGIN
	SELECT * FROM pricing_table
	WHERE pricing_table_id = p_pricing_table_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generatePricingTable()
BEGIN
    SELECT pricing_table_id, pricing_table_name, description, publish_status
    FROM pricing_table;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */