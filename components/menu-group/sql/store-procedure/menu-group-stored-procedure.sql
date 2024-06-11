DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkMenuGroupExist(IN p_menu_group_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM menu_group
    WHERE menu_group_id = p_menu_group_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertMenuGroup(IN p_menu_group_name VARCHAR(100), IN p_order_sequence TINYINT(10), IN p_last_log_by INT, OUT p_menu_group_id INT)
BEGIN
    INSERT INTO menu_group (menu_group_name, order_sequence, last_log_by) 
	VALUES(p_menu_group_name, p_order_sequence, p_last_log_by);
	
    SET p_menu_group_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateMenuGroup(IN p_menu_group_id INT, IN p_menu_group_name VARCHAR(100), IN p_order_sequence TINYINT(10), IN p_last_log_by INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE menu_item
    SET menu_group_name = p_menu_group_name,
        last_log_by = p_last_log_by
    WHERE menu_group_id = p_menu_group_id;

    UPDATE menu_group
    SET menu_group_name = p_menu_group_name,
        order_sequence = p_order_sequence,
        last_log_by = p_last_log_by
    WHERE menu_group_id = p_menu_group_id;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteMenuGroup(IN p_menu_group_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM menu_group WHERE menu_group_id = p_menu_group_id;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getMenuGroup(IN p_menu_group_id INT)
BEGIN
	SELECT * FROM menu_group
	WHERE menu_group_id = p_menu_group_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateMenuGroupTable()
BEGIN
	SELECT menu_group_id, menu_group_name, order_sequence 
    FROM menu_group 
    ORDER BY menu_group_id;
END //

CREATE PROCEDURE generateMenuGroupOptions()
BEGIN
	SELECT menu_group_id, menu_group_name 
    FROM menu_group 
    ORDER BY menu_group_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */