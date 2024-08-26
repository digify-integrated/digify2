DELIMITER //

CREATE TRIGGER block_type_trigger_update
AFTER UPDATE ON block_type
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.block_type_name <> OLD.block_type_name THEN
        SET audit_log = CONCAT(audit_log, "Block Type Name: ", OLD.block_type_name, " -> ", NEW.block_type_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('block_type', NEW.block_type_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER block_type_trigger_insert
AFTER INSERT ON block_type
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Block type created. <br/>';

    IF NEW.block_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Type Name: ", NEW.block_type_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('block_type', NEW.block_type_id, audit_log, NEW.last_log_by, NOW());
END //