DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkFileTypeExist(IN p_file_type_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM file_type
    WHERE file_type_id = p_file_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertFileType(IN p_file_type_name VARCHAR(100), IN p_last_log_by INT, OUT p_file_type_id INT)
BEGIN
    INSERT INTO file_type (file_type_name, last_log_by) 
	VALUES(p_file_type_name, p_last_log_by);
	
    SET p_file_type_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateFileType(IN p_file_type_id INT, IN p_file_type_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    UPDATE file_extension
    SET file_type_name = p_file_type_name,
        last_log_by = p_last_log_by
    WHERE file_type_id = p_file_type_id;

    UPDATE file_type
    SET file_type_name = p_file_type_name,
        last_log_by = p_last_log_by
    WHERE file_type_id = p_file_type_id;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteFileType(IN p_file_type_id INT)
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;
    END;

    START TRANSACTION;

    DELETE FROM upload_setting_file_extension WHERE file_extension_id IN (SELECT file_extension_id FROM file_extension WHERE file_type_id = p_file_type_id);
    DELETE FROM file_extension WHERE file_type_id = p_file_type_id;
    DELETE FROM file_type WHERE file_type_id = p_file_type_id;

    COMMIT;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getFileType(IN p_file_type_id INT)
BEGIN
	SELECT * FROM file_type
	WHERE file_type_id = p_file_type_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateFileTypeTable()
BEGIN
	SELECT file_type_id, file_type_name 
    FROM file_type 
    ORDER BY file_type_id;
END //

CREATE PROCEDURE generateFileTypeOptions()
BEGIN
	SELECT file_type_id, file_type_name 
    FROM file_type 
    ORDER BY file_type_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */