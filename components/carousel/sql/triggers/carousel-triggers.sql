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

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('carousel', NEW.carousel_id, audit_log, NEW.last_log_by, NOW());
END //