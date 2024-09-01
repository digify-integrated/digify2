DELIMITER //

CREATE TRIGGER process_step_trigger_update
AFTER UPDATE ON process_step
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.process_step_name <> OLD.process_step_name THEN
        SET audit_log = CONCAT(audit_log, "Process Step Name: ", OLD.process_step_name, " -> ", NEW.process_step_name, "<br/>");
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
        VALUES ('process_step', NEW.process_step_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER process_step_trigger_insert
AFTER INSERT ON process_step
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Process step created. <br/>';

    IF NEW.process_step_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Process Step Name: ", NEW.process_step_name);
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
    VALUES ('process_step', NEW.process_step_id, audit_log, NEW.last_log_by, NOW());
END //

CREATE TRIGGER process_step_item_trigger_update
AFTER UPDATE ON process_step_item
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';
    
    IF NEW.process_step_title <> OLD.process_step_title THEN
        SET audit_log = CONCAT(audit_log, "Process Step Title: ", OLD.process_step_title, " -> ", NEW.process_step_title, "<br/>");
    END IF;
    
    IF NEW.process_step_heading <> OLD.process_step_heading THEN
        SET audit_log = CONCAT(audit_log, "Process Step Heading: ", OLD.process_step_heading, " -> ", NEW.process_step_heading, "<br/>");
    END IF;
    
    IF NEW.process_step_link <> OLD.process_step_link THEN
        SET audit_log = CONCAT(audit_log, "Process Step Link: ", OLD.process_step_link, " -> ", NEW.process_step_link, "<br/>");
    END IF;
    
    IF NEW.order_sequence <> OLD.order_sequence THEN
        SET audit_log = CONCAT(audit_log, "Order Sequence: ", OLD.order_sequence, " -> ", NEW.order_sequence, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('process_step_item', NEW.process_step_item_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER process_step_item_trigger_insert
AFTER INSERT ON process_step_item
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Process step item created. <br/>';

    IF NEW.process_step_title <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Process Step Title: ", NEW.process_step_title);
    END IF;

    IF NEW.process_step_heading <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Process Step Heading: ", NEW.process_step_heading);
    END IF;
    
    IF NEW.process_step_link <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Process Step Link: ", NEW.process_step_link);
    END IF;

    IF NEW.order_sequence <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Order Sequence: ", NEW.order_sequence);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('process_step_item', NEW.process_step_item_id, audit_log, NEW.last_log_by, NOW());
END //