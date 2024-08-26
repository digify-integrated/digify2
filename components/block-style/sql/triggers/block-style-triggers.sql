DELIMITER //

CREATE TRIGGER block_style_trigger_update
AFTER UPDATE ON block_style
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.block_style_name <> OLD.block_style_name THEN
        SET audit_log = CONCAT(audit_log, "Block Style Name: ", OLD.block_style_name, " -> ", NEW.block_style_name, "<br/>");
    END IF;

    IF NEW.description <> OLD.description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.description, " -> ", NEW.description, "<br/>");
    END IF;

    IF NEW.block_type_name <> OLD.block_type_name THEN
        SET audit_log = CONCAT(audit_log, "Block Type Name: ", OLD.block_type_name, " -> ", NEW.block_type_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('block_style', NEW.block_style_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER block_style_trigger_insert
AFTER INSERT ON block_style
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Block style created. <br/>';

    IF NEW.block_style_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Style Name: ", NEW.block_style_name);
    END IF;

    IF NEW.description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.description);
    END IF;

    IF NEW.block_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Type Name: ", NEW.block_type_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('block_style', NEW.block_style_id, audit_log, NEW.last_log_by, NOW());
END //

CREATE TRIGGER block_container_trigger_update
AFTER UPDATE ON block_container
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.block_container <> OLD.block_container THEN
        SET audit_log = CONCAT(audit_log, "Block Container: ", OLD.block_container, " -> ", NEW.block_container, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('block_container', NEW.block_container_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER block_container_trigger_insert
AFTER INSERT ON block_container
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Block container created. <br/>';

    IF NEW.block_container <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Container: ", NEW.block_container);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('block_container', NEW.block_container_id, audit_log, NEW.last_log_by, NOW());
END //

CREATE TRIGGER block_item_trigger_update
AFTER UPDATE ON block_item
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.block_item <> OLD.block_item THEN
        SET audit_log = CONCAT(audit_log, "Block Item: ", OLD.block_item, " -> ", NEW.block_item, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('block_item', NEW.block_item_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER block_item_trigger_insert
AFTER INSERT ON block_item
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Block item created. <br/>';

    IF NEW.block_item <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Item: ", NEW.block_item);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('block_item', NEW.block_item_id, audit_log, NEW.last_log_by, NOW());
END //