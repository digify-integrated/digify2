DELIMITER //

CREATE TRIGGER website_trigger_update
AFTER UPDATE ON website
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.website_name <> OLD.website_name THEN
        SET audit_log = CONCAT(audit_log, "Website Name: ", OLD.website_name, " -> ", NEW.website_name, "<br/>");
    END IF;

    IF NEW.description <> OLD.description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.description, " -> ", NEW.description, "<br/>");
    END IF;

    IF NEW.url <> OLD.url THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.url, " -> ", NEW.url, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('website', NEW.website_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER website_trigger_insert
AFTER INSERT ON website
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Website created. <br/>';

    IF NEW.website_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Website Name: ", NEW.website_name);
    END IF;

    IF NEW.description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.description);
    END IF;

    IF NEW.url <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>URL: ", NEW.url);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('website', NEW.website_id, audit_log, NEW.last_log_by, NOW());
END //