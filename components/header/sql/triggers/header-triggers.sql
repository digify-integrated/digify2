DELIMITER //

CREATE TRIGGER header_trigger_update
AFTER UPDATE ON header
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.header_name <> OLD.header_name THEN
        SET audit_log = CONCAT(audit_log, "Header Name: ", OLD.header_name, " -> ", NEW.header_name, "<br/>");
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
        VALUES ('header', NEW.header_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER header_trigger_insert
AFTER INSERT ON header
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Header created. <br/>';

    IF NEW.header_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Header Name: ", NEW.header_name);
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
    VALUES ('header', NEW.header_id, audit_log, NEW.last_log_by, NOW());
END //