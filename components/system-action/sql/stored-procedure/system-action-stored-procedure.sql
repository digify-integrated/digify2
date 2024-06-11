DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkSystemActionExist (IN p_system_action_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM system_action
    WHERE system_action_id = p_system_action_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertSystemAction(IN p_system_action_name VARCHAR(100), IN p_system_action_description VARCHAR(200), IN p_last_log_by INT, OUT p_system_action_id INT)
BEGIN
    INSERT INTO system_action (system_action_name, system_action_description, last_log_by) 
	VALUES(p_system_action_name, p_system_action_description, p_last_log_by);
	
    SET p_system_action_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateSystemAction(IN p_system_action_id INT, IN p_system_action_name VARCHAR(100), IN p_system_action_description VARCHAR(200), IN p_last_log_by INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE role_system_action_permission
    SET system_action_name = p_system_action_name,
        last_log_by = p_last_log_by
    WHERE system_action_id = p_system_action_id;

	UPDATE system_action
    SET system_action_name = p_system_action_name,
        system_action_description = p_system_action_description,
        last_log_by = p_last_log_by
    WHERE system_action_id = p_system_action_id;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedures */

CREATE PROCEDURE deleteSystemAction(IN p_system_action_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM role_system_action_permission WHERE system_action_id = p_system_action_id;
    DELETE FROM system_action WHERE system_action_id = p_system_action_id;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedures */

CREATE PROCEDURE getSystemAction(IN p_system_action_id INT)
BEGIN
	SELECT * FROM system_action
    WHERE system_action_id = p_system_action_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateSystemActionTable()
BEGIN
	SELECT system_action_id, system_action_name, system_action_description
    FROM system_action 
    ORDER BY system_action_id;
END //

CREATE PROCEDURE generateRoleSystemActionDualListBoxOptions(IN p_role_id INT)
BEGIN
	SELECT system_action_id, system_action_name
    FROM system_action 
    WHERE system_action_id NOT IN (SELECT system_action_id FROM role_system_action_permission WHERE role_id = p_role_id)
    ORDER BY system_action_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */