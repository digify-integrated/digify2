DELIMITER //

CREATE TRIGGER call_to_action_trigger_update
AFTER UPDATE ON call_to_action
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.call_to_action_name <> OLD.call_to_action_name THEN
        SET audit_log = CONCAT(audit_log, "Call to Action Name: ", OLD.call_to_action_name, " -> ", NEW.call_to_action_name, "<br/>");
    END IF;

    IF NEW.description <> OLD.description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.description, " -> ", NEW.description, "<br/>");
    END IF;

    IF NEW.block_style_name <> OLD.block_style_name THEN
        SET audit_log = CONCAT(audit_log, "Block Style Name: ", OLD.block_style_name, " -> ", NEW.block_style_name, "<br/>");
    END IF;

    IF NEW.call_to_action_header <> OLD.call_to_action_header THEN
        SET audit_log = CONCAT(audit_log, "Call to Action Header: ", OLD.call_to_action_header, " -> ", NEW.call_to_action_header, "<br/>");
    END IF;

    IF NEW.call_to_action_body <> OLD.call_to_action_body THEN
        SET audit_log = CONCAT(audit_log, "Call to Action Body: ", OLD.call_to_action_body, " -> ", NEW.call_to_action_body, "<br/>");
    END IF;

    IF NEW.publish_status <> OLD.publish_status THEN
        SET audit_log = CONCAT(audit_log, "Publish Status: ", OLD.publish_status, " -> ", NEW.publish_status, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('call_to_action', NEW.call_to_action_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER call_to_action_trigger_insert
AFTER INSERT ON call_to_action
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Call to Action created. <br/>';

    IF NEW.call_to_action_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Call to Action Name: ", NEW.call_to_action_name);
    END IF;

    IF NEW.description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.description);
    END IF;

    IF NEW.block_style_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Style Name: ", NEW.block_style_name);
    END IF;

    IF NEW.call_to_action_header <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Call to Action Header: ", NEW.call_to_action_header);
    END IF;

    IF NEW.call_to_action_body <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Call to Action Body: ", NEW.call_to_action_body);
    END IF;

    IF NEW.publish_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Publish Status: ", NEW.publish_status);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('call_to_action', NEW.call_to_action_id, audit_log, NEW.last_log_by, NOW());
END //