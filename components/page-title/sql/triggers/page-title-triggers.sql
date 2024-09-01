DELIMITER //

CREATE TRIGGER page_title_trigger_update
AFTER UPDATE ON page_title
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.page_title_name <> OLD.page_title_name THEN
        SET audit_log = CONCAT(audit_log, "Page Title Name: ", OLD.page_title_name, " -> ", NEW.page_title_name, "<br/>");
    END IF;

    IF NEW.description <> OLD.description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.description, " -> ", NEW.description, "<br/>");
    END IF;

    IF NEW.block_style_name <> OLD.block_style_name THEN
        SET audit_log = CONCAT(audit_log, "Block Style Name: ", OLD.block_style_name, " -> ", NEW.block_style_name, "<br/>");
    END IF;

    IF NEW.page_title <> OLD.page_title THEN
        SET audit_log = CONCAT(audit_log, "Page Title: ", OLD.page_title, " -> ", NEW.page_title, "<br/>");
    END IF;

    IF NEW.page_heading <> OLD.page_heading THEN
        SET audit_log = CONCAT(audit_log, "Page Heading: ", OLD.page_heading, " -> ", NEW.page_heading, "<br/>");
    END IF;

    IF NEW.publish_status <> OLD.publish_status THEN
        SET audit_log = CONCAT(audit_log, "Publish Status: ", OLD.publish_status, " -> ", NEW.publish_status, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('page_title', NEW.page_title_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER page_title_trigger_insert
AFTER INSERT ON page_title
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Page title created. <br/>';

    IF NEW.page_title_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Page Title Name: ", NEW.page_title_name);
    END IF;

    IF NEW.description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.description);
    END IF;

    IF NEW.block_style_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Style Name: ", NEW.block_style_name);
    END IF;

    IF NEW.page_title <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Page Title: ", NEW.page_title);
    END IF;

    IF NEW.page_heading <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Page Heading: ", NEW.page_heading);
    END IF;

    IF NEW.publish_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Publish Status: ", NEW.publish_status);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('page_title', NEW.page_title_id, audit_log, NEW.last_log_by, NOW());
END //