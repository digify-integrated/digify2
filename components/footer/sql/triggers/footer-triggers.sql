DELIMITER //

CREATE TRIGGER footer_trigger_update
AFTER UPDATE ON footer
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.footer_name <> OLD.footer_name THEN
        SET audit_log = CONCAT(audit_log, "Footer Name: ", OLD.footer_name, " -> ", NEW.footer_name, "<br/>");
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
        VALUES ('footer', NEW.footer_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER footer_trigger_insert
AFTER INSERT ON footer
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Footer created. <br/>';

    IF NEW.footer_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Footer Name: ", NEW.footer_name);
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
    VALUES ('footer', NEW.footer_id, audit_log, NEW.last_log_by, NOW());
END //