DELIMITER //

CREATE TRIGGER accordion_trigger_update
AFTER UPDATE ON accordion
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.accordion_name <> OLD.accordion_name THEN
        SET audit_log = CONCAT(audit_log, "Accordion Name: ", OLD.accordion_name, " -> ", NEW.accordion_name, "<br/>");
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
        VALUES ('accordion', NEW.accordion_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER accordion_trigger_insert
AFTER INSERT ON accordion
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Accordion created. <br/>';

    IF NEW.accordion_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Accordion Name: ", NEW.accordion_name);
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
    VALUES ('accordion', NEW.accordion_id, audit_log, NEW.last_log_by, NOW());
END //

CREATE TRIGGER accordion_item_trigger_update
AFTER UPDATE ON accordion_item
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.accordion_header <> OLD.accordion_header THEN
        SET audit_log = CONCAT(audit_log, "Accordion Header: ", OLD.accordion_header, " -> ", NEW.accordion_header, "<br/>");
    END IF;

    IF NEW.accordion_body <> OLD.accordion_body THEN
        SET audit_log = CONCAT(audit_log, "Accordion Body: ", OLD.accordion_body, " -> ", NEW.accordion_body, "<br/>");
    END IF;
    
    IF NEW.order_sequence <> OLD.order_sequence THEN
        SET audit_log = CONCAT(audit_log, "Order Sequence: ", OLD.order_sequence, " -> ", NEW.order_sequence, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('accordion_item', NEW.accordion_item_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER accordion_item_trigger_insert
AFTER INSERT ON accordion_item
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Accordion item created. <br/>';

    IF NEW.accordion_header <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Accordion Header: ", NEW.accordion_header);
    END IF;

    IF NEW.accordion_body <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Accordion Body: ", NEW.accordion_body);
    END IF;

    IF NEW.order_sequence <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Order Sequence: ", NEW.order_sequence);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('accordion_item', NEW.accordion_item_id, audit_log, NEW.last_log_by, NOW());
END //