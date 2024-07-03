DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkRelationExist(IN p_relation_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM relation
    WHERE relation_id = p_relation_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertRelation(IN p_relation_name VARCHAR(100), IN p_last_log_by INT, OUT p_relation_id INT)
BEGIN
    INSERT INTO relation (relation_name, last_log_by) 
	VALUES(p_relation_name, p_last_log_by);
	
    SET p_relation_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateRelation(IN p_relation_id INT, IN p_relation_name VARCHAR(100), IN p_last_log_by INT)
BEGIN
    UPDATE relation
    SET relation_name = p_relation_name,
        last_log_by = p_last_log_by
    WHERE relation_id = p_relation_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteRelation(IN p_relation_id INT)
BEGIN
    DELETE FROM relation WHERE relation_id = p_relation_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getRelation(IN p_relation_id INT)
BEGIN
	SELECT * FROM relation
	WHERE relation_id = p_relation_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateRelationTable()
BEGIN
	SELECT relation_id, relation_name 
    FROM relation 
    ORDER BY relation_id;
END //

CREATE PROCEDURE generateRelationOptions()
BEGIN
	SELECT relation_id, relation_name 
    FROM relation 
    ORDER BY relation_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */