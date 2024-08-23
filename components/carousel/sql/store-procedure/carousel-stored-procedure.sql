DELIMITER //

/* Check Stored Procedure */

CREATE PROCEDURE checkCarouselExist(IN p_carousel_id INT)
BEGIN
	SELECT COUNT(*) AS total
    FROM carousel
    WHERE carousel_id = p_carousel_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Insert Stored Procedure */

CREATE PROCEDURE insertCarousel(IN p_carousel_name VARCHAR(100), IN p_description VARCHAR(500), IN p_last_log_by INT, OUT p_carousel_id INT)
BEGIN
    INSERT INTO carousel (carousel_name, description, last_log_by) 
	VALUES(p_carousel_name, p_description, p_last_log_by);
	
    SET p_carousel_id = LAST_INSERT_ID();
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Update Stored Procedure */

CREATE PROCEDURE updateCarousel(IN p_carousel_id INT, IN p_carousel_name VARCHAR(100), IN p_description VARCHAR(500), IN p_last_log_by INT)
BEGIN
    UPDATE carousel
    SET carousel_name = p_carousel_name,
        description = p_description,
        last_log_by = p_last_log_by
    WHERE carousel_id = p_carousel_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Delete Stored Procedure */

CREATE PROCEDURE deleteCarousel(IN p_carousel_id INT)
BEGIN
    DELETE FROM carousel WHERE carousel_id = p_carousel_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Get Stored Procedure */

CREATE PROCEDURE getCarousel(IN p_carousel_id INT)
BEGIN
	SELECT * FROM carousel
	WHERE carousel_id = p_carousel_id;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Generate Stored Procedure */

CREATE PROCEDURE generateCarouselTable()
BEGIN
	SELECT carousel_id, carousel_name, description
    FROM carousel 
    ORDER BY carousel_id;
END //

CREATE PROCEDURE generateCarouselOptions()
BEGIN
	SELECT carousel_id, carousel_name 
    FROM carousel 
    ORDER BY carousel_name;
END //

/* ----------------------------------------------------------------------------------------------------------------------------- */