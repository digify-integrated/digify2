DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkAppModuleExist(IN p_app_module_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM app_module
    WHERE app_module_id = p_app_module_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertAppModule(IN p_app_module_name VARCHAR(100), IN p_app_module_description VARCHAR(500), IN p_order_sequence TINYINT(10), IN p_last_log_by INT, OUT p_app_module_id INT)
BEGIN
    INSERT INTO app_module (app_module_name, app_module_description, order_sequence, last_log_by) 
	VALUES(p_app_module_name, p_app_module_description, p_order_sequence, p_last_log_by);
	
    SET p_app_module_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateAppModule(IN p_app_module_id INT, IN p_app_module_name VARCHAR(100), IN p_app_module_description VARCHAR(500), IN p_order_sequence TINYINT(10), IN p_last_log_by INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE menu_group
    SET app_module_name = p_app_module_name,
        last_log_by = p_last_log_by
    WHERE app_module_id = p_app_module_id;

    UPDATE menu_item
    SET app_module_name = p_app_module_name,
        last_log_by = p_last_log_by
    WHERE app_module_id = p_app_module_id;

    UPDATE app_module
    SET app_module_name = p_app_module_name,
        app_module_description = p_app_module_description,
        order_sequence = p_order_sequence,
        last_log_by = p_last_log_by
    WHERE app_module_id = p_app_module_id;

    COMMIT;
END //

CREATE PROCEDURE updateAppLogo(IN p_app_module_id INT, IN p_app_logo VARCHAR(500), IN p_last_log_by INT)
BEGIN
    UPDATE app_module
    SET app_logo = p_app_logo,
        last_log_by = p_last_log_by
    WHERE app_module_id = p_app_module_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteAppModule(IN p_app_module_id INT)
BEGIN
    DELETE FROM app_module WHERE app_module_id = p_app_module_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getAppModule(IN p_app_module_id INT)
BEGIN
	SELECT * FROM app_module
	WHERE app_module_id = p_app_module_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateAppModuleTable()
BEGIN
	SELECT app_module_id, app_module_name, app_module_description, order_sequence 
    FROM app_module 
    ORDER BY app_module_id;
END //

CREATE PROCEDURE generateAppModuleOptions()
BEGIN
	SELECT app_module_id, app_module_name 
    FROM app_module 
    ORDER BY app_module_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */