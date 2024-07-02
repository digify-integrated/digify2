DELIMITER //

/* Generate Stored Procedure */

CREATE PROCEDURE generateLogNotes(IN p_table_name VARCHAR(255), IN p_reference_id INT)
BEGIN
	SELECT log, changed_by, changed_at
    FROM audit_log
    WHERE table_name = p_table_name AND reference_id  = p_reference_id
    ORDER BY changed_at DESC;
END //

CREATE PROCEDURE generateInternalNotes(IN p_table_name VARCHAR(255), IN p_reference_id INT)
BEGIN
	SELECT internal_notes_id, internal_note, internal_note_by, internal_note_date
    FROM internal_notes
    WHERE table_name = p_table_name AND reference_id  = p_reference_id
    ORDER BY internal_note_date DESC;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertInternalNotes(IN p_table_name VARCHAR(255), IN p_reference_id INT, IN p_internal_note VARCHAR(5000), IN p_internal_note_by INT, OUT p_internal_notes_id INT)
BEGIN
    INSERT INTO internal_notes (table_name, reference_id, internal_note, internal_note_by) 
	VALUES(p_table_name, p_reference_id, p_internal_note, p_internal_note_by);

    SET p_internal_notes_id = LAST_INSERT_ID();
END //

CREATE PROCEDURE insertInternalNotesAttachment(IN p_internal_notes_id INT, IN p_attachment_file_name VARCHAR(500), IN p_attachment_file_size DOUBLE, IN p_attachment_path_file VARCHAR(500))
BEGIN
    INSERT INTO internal_notes_attachment (internal_notes_id, attachment_file_name, attachment_file_size, attachment_path_file) 
	VALUES(p_internal_notes_id, p_attachment_file_name, p_attachment_file_size, p_attachment_path_file);
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Build Stored Procedure */

CREATE PROCEDURE buildAppModuleStack(IN p_user_account_id INT)
BEGIN
    SELECT DISTINCT(am.app_module_id) as app_module_id, am.app_module_name, am.menu_item_id, app_logo, app_version, app_module_description
    FROM app_module am
    JOIN menu_item mi ON mi.app_module_id = am.app_module_id
    WHERE EXISTS (
        SELECT 1
        FROM role_permission mar
        WHERE mar.menu_item_id = mi.menu_item_id
        AND mar.read_access = 1
        AND mar.role_id IN (
            SELECT role_id
            FROM role_user_account
            WHERE user_account_id = p_user_account_id
        )
    )
    ORDER BY am.order_sequence, am.app_module_name;
END //

CREATE PROCEDURE buildMenuGroup(IN p_user_account_id INT, IN p_app_module_id INT)
BEGIN
    SELECT DISTINCT(mg.menu_group_id) as menu_group_id, mg.menu_group_name as menu_group_name
    FROM menu_group mg
    JOIN menu_item mi ON mi.menu_group_id = mg.menu_group_id
    WHERE EXISTS (
        SELECT 1
        FROM role_permission mar
        WHERE mar.menu_item_id = mi.menu_item_id
        AND mar.read_access = 1
        AND mar.role_id IN (
            SELECT role_id
            FROM role_user_account
            WHERE user_account_id = p_user_account_id
        )
    )
    AND mg.app_module_id = p_app_module_id
    ORDER BY mg.order_sequence;
END //

CREATE PROCEDURE buildMenuItem(IN p_user_account_id INT, IN p_menu_group_id INT)
BEGIN
    SELECT mi.menu_item_id, mi.menu_item_name, mi.menu_group_id, mi.menu_item_url, mi.parent_id, mi.app_module_id, mi.menu_item_icon
    FROM menu_item AS mi
    INNER JOIN role_permission AS mar ON mi.menu_item_id = mar.menu_item_id
    INNER JOIN role_user_account AS ru ON mar.role_id = ru.role_id
    WHERE mar.read_access = 1 AND ru.user_account_id = p_user_account_id AND mi.menu_group_id = p_menu_group_id
    ORDER BY mi.order_sequence, mi.menu_item_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Check Stored Procedure */

CREATE PROCEDURE checkAccessRights(IN p_user_account_id INT, IN p_menu_item_id INT, IN p_access_type VARCHAR(10))
BEGIN
	IF p_access_type = 'read' THEN
        SELECT COUNT(role_id) AS total
        FROM role_user_account
        WHERE user_account_id = p_user_account_id AND role_id IN (SELECT role_id FROM role_permission where read_access = 1 AND menu_item_id = p_menu_item_id);
    ELSEIF p_access_type = 'write' THEN
        SELECT COUNT(role_id) AS total
        FROM role_user_account
        WHERE user_account_id = p_user_account_id AND role_id IN (SELECT role_id FROM role_permission where write_access = 1 AND menu_item_id = p_menu_item_id);
    ELSEIF p_access_type = 'create' THEN
        SELECT COUNT(role_id) AS total
        FROM role_user_account
        WHERE user_account_id = p_user_account_id AND role_id IN (SELECT role_id FROM role_permission where create_access = 1 AND menu_item_id = p_menu_item_id);       
    ELSE
        SELECT COUNT(role_id) AS total
        FROM role_user_account
        WHERE user_account_id = p_user_account_id AND role_id IN (SELECT role_id FROM role_permission where delete_access = 1 AND menu_item_id = p_menu_item_id);
    END IF;
END //

CREATE PROCEDURE checkSystemActionAccessRights(IN p_user_account_id INT, IN p_system_action_id INT)
BEGIN
    SELECT COUNT(role_id) AS total
    FROM role_system_action_permission 
    WHERE system_action_id = p_system_action_id AND system_action_access = 1 AND role_id IN (SELECT role_id FROM role_user_account WHERE user_account_id = p_user_account_id);
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Check Stored Procedure */

CREATE PROCEDURE getInternalNotesAttachment(IN p_internal_notes_id INT)
BEGIN
	SELECT * FROM internal_notes_attachment
	WHERE internal_notes_id = p_internal_notes_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */