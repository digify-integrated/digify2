DELIMITER //

CREATE TRIGGER carousel_trigger_update
AFTER UPDATE ON carousel
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.carousel_name <> OLD.carousel_name THEN
        SET audit_log = CONCAT(audit_log, "Carousel Name: ", OLD.carousel_name, " -> ", NEW.carousel_name, "<br/>");
    END IF;

    IF NEW.description <> OLD.description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.description, " -> ", NEW.description, "<br/>");
    END IF;

    IF NEW.block_style_name <> OLD.block_style_name THEN
        SET audit_log = CONCAT(audit_log, "Block Style Name: ", OLD.block_style_name, " -> ", NEW.block_style_name, "<br/>");
    END IF;

    IF NEW.publish_status <> OLD.publish_status THEN
        SET audit_log = CONCAT(audit_log, "Publish Status: ", OLD.publish_status, " -> ", NEW.publish_status, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('carousel', NEW.carousel_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER carousel_trigger_insert
AFTER INSERT ON carousel
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Carousel created. <br/>';

    IF NEW.carousel_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Carousel Name: ", NEW.carousel_name);
    END IF;

    IF NEW.description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.description);
    END IF;

    IF NEW.block_style_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Style Name: ", NEW.block_style_name);
    END IF;

    IF NEW.publish_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Publish Status: ", NEW.publish_status);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('carousel', NEW.carousel_id, audit_log, NEW.last_log_by, NOW());
END //

CREATE TRIGGER carousel_image_trigger_update
AFTER UPDATE ON carousel_image
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';
    
    IF NEW.order_sequence <> OLD.order_sequence THEN
        SET audit_log = CONCAT(audit_log, "Order Sequence: ", OLD.order_sequence, " -> ", NEW.order_sequence, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('carousel_image', NEW.carousel_image_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER carousel_image_trigger_insert
AFTER INSERT ON carousel_image
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Carousel image created. <br/>';

    IF NEW.order_sequence <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Order Sequence: ", NEW.order_sequence);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('carousel_image', NEW.carousel_image_id, audit_log, NEW.last_log_by, NOW());
END //