DELIMITER //

CREATE TRIGGER client_trigger_update
AFTER UPDATE ON client
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.client_name <> OLD.client_name THEN
        SET audit_log = CONCAT(audit_log, "Client Name: ", OLD.client_name, " -> ", NEW.client_name, "<br/>");
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
        VALUES ('client', NEW.client_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER client_trigger_insert
AFTER INSERT ON client
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Client created. <br/>';

    IF NEW.client_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Client Name: ", NEW.client_name);
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
    VALUES ('client', NEW.client_id, audit_log, NEW.last_log_by, NOW());
END //

CREATE TRIGGER client_item_trigger_update
AFTER UPDATE ON client_item
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';
    
    IF NEW.client_url <> OLD.client_url THEN
        SET audit_log = CONCAT(audit_log, "Client URL: ", OLD.client_url, " -> ", NEW.client_url, "<br/>");
    END IF;
    
    IF NEW.order_sequence <> OLD.order_sequence THEN
        SET audit_log = CONCAT(audit_log, "Order Sequence: ", OLD.order_sequence, " -> ", NEW.order_sequence, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('client_item', NEW.client_item_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER client_item_trigger_insert
AFTER INSERT ON client_item
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Client item created. <br/>';

    IF NEW.client_url <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Client URL: ", NEW.client_url);
    END IF;

    IF NEW.order_sequence <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Order Sequence: ", NEW.order_sequence);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('client_item', NEW.client_item_id, audit_log, NEW.last_log_by, NOW());
END //