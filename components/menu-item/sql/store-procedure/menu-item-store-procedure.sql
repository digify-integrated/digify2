DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkMenuItemExist(IN p_menu_item_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM menu_item
    WHERE menu_item_id = p_menu_item_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertMenuItem(IN p_menu_item_name VARCHAR(100), IN p_menu_item_url VARCHAR(50), IN p_app_module_id INT, IN p_app_module_name VARCHAR(100), IN p_parent_id INT, IN p_parent_name VARCHAR(100), IN p_order_sequence TINYINT(10), IN p_last_log_by INT, OUT p_menu_item_id INT)
BEGIN
    INSERT INTO menu_item (menu_item_name, menu_item_url, app_module_id, app_module_name, parent_id, parent_name, order_sequence, last_log_by) 
	VALUES(p_menu_item_name, p_menu_item_url, p_app_module_id, p_app_module_name, p_parent_id, p_parent_name, p_order_sequence, p_last_log_by);
	
    SET p_menu_item_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateMenuItem(IN p_menu_item_id INT, IN p_menu_item_name VARCHAR(100), IN p_menu_item_url VARCHAR(50), IN p_app_module_id INT, IN p_app_module_name VARCHAR(100), IN p_parent_id INT, IN p_parent_name VARCHAR(100), IN p_order_sequence TINYINT(10), IN p_last_log_by INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE role_permission
    SET menu_item_name = p_menu_item_name,
        last_log_by = p_last_log_by
    WHERE menu_item_id = p_menu_item_id;

    UPDATE menu_item
    SET menu_item_name = p_menu_item_name,
        menu_item_url = p_menu_item_url,
        app_module_id = p_app_module_id,
        app_module_name = p_app_module_name,
        parent_id = p_parent_id,
        parent_name = p_parent_name,
        order_sequence = p_order_sequence,
        last_log_by = p_last_log_by
    WHERE menu_item_id = p_menu_item_id;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteMenuItem(IN p_menu_item_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM role_permission WHERE menu_item_id = p_menu_item_id;
    DELETE FROM menu_item WHERE menu_item_id = p_menu_item_id;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getMenuItem(IN p_menu_item_id INT)
BEGIN
	SELECT * FROM menu_item
	WHERE menu_item_id = p_menu_item_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateMenuItemTable(IN p_filter_by_app_module INT)
BEGIN
    DECLARE query VARCHAR(5000);

    SET query = CONCAT('
        SELECT menu_item_id, menu_item_name, app_module_name, order_sequence 
        FROM menu_item 
        WHERE 1');

    IF p_filter_by_app_module IS NOT NULL THEN
        SET query = CONCAT(query, ' AND app_module_id = ', p_filter_by_app_module);
    END IF;

    SET query = CONCAT(query, ' ORDER BY menu_item_name');

    PREPARE stmt FROM query;
    EXECUTE stmt;
    DEALLOCATE PREPARE stmt;
END //

CREATE PROCEDURE generateSubmenuItemTable(IN p_parent_id INT)
BEGIN
	SELECT * FROM menu_item
	WHERE parent_id = p_parent_id AND parent_id IS NOT NULL;
END //

CREATE PROCEDURE generateMenuItemOptions()
BEGIN
	SELECT menu_item_id, menu_item_name 
    FROM menu_item 
    ORDER BY menu_item_name;
END //

CREATE PROCEDURE generateRoleMenuItemDualListBoxOptions(IN p_role_id INT)
BEGIN
	SELECT menu_item_id, menu_item_name 
    FROM menu_item 
    WHERE menu_item_id NOT IN (SELECT menu_item_id FROM role_permission WHERE role_id = p_role_id)
    ORDER BY menu_item_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */