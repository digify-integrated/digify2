DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkUICustomizationSettingExist(IN p_user_account__id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM ui_customization_setting
	WHERE user_account_id = p_user_account__id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertUICustomizationSetting(IN p_user_account__id INT, IN p_type VARCHAR(30), IN p_customization_value VARCHAR(20), IN p_last_log_by INT)
BEGIN
	IF p_type = 'sidebar type' THEN
        INSERT INTO ui_customization_setting (user_account_id, sidebar_type, last_log_by) 
	    VALUES(p_user_account__id, p_customization_value, p_last_log_by);
    ELSEIF p_type = 'boxed layout' THEN
        INSERT INTO ui_customization_setting (user_account_id, boxed_layout, last_log_by) 
	    VALUES(p_user_account__id, p_customization_value, p_last_log_by);
    ELSEIF p_type = 'theme' THEN
        INSERT INTO ui_customization_setting (user_account_id, theme, last_log_by) 
	    VALUES(p_user_account__id, p_customization_value, p_last_log_by);
    ELSEIF p_type = 'color theme' THEN
        INSERT INTO ui_customization_setting (user_account_id, color_theme, last_log_by) 
	    VALUES(p_user_account__id, p_customization_value, p_last_log_by);
    ELSE
        INSERT INTO ui_customization_setting (user_account_id, card_border, last_log_by) 
	    VALUES(p_user_account__id, p_customization_value, p_last_log_by);
    END IF;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateUICustomizationSetting(IN p_user_account__id INT, IN p_type VARCHAR(30), IN p_customization_value VARCHAR(20), IN p_last_log_by INT)
BEGIN
	IF p_type = 'sidebar type' THEN
        UPDATE ui_customization_setting
        SET sidebar_type = p_customization_value,
        last_log_by = p_last_log_by
       	WHERE user_account_id = p_user_account__id;
    ELSEIF p_type = 'boxed layout' THEN
        UPDATE ui_customization_setting
        SET boxed_layout = p_customization_value,
        last_log_by = p_last_log_by
       	WHERE user_account_id = p_user_account__id;
    ELSEIF p_type = 'theme' THEN
        UPDATE ui_customization_setting
        SET theme = p_customization_value,
        last_log_by = p_last_log_by
       	WHERE user_account_id = p_user_account__id;
    ELSEIF p_type = 'color theme' THEN
        UPDATE ui_customization_setting
        SET color_theme = p_customization_value,
        last_log_by = p_last_log_by
       	WHERE user_account_id = p_user_account__id;
    ELSE
        UPDATE ui_customization_setting
        SET card_border = p_customization_value,
        last_log_by = p_last_log_by
       	WHERE user_account_id = p_user_account__id;
    END IF;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getUICustomizationSetting(IN p_user_account__id INT)
BEGIN
	SELECT * FROM ui_customization_setting
	WHERE user_account_id = p_user_account__id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */