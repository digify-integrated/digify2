DELIMITER //

CREATE TRIGGER address_type_trigger_update
AFTER UPDATE ON address_type
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.address_type_name <> OLD.address_type_name THEN
        SET audit_log = CONCAT(audit_log, "Address Type Name: ", OLD.address_type_name, " -> ", NEW.address_type_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('address_type', NEW.address_type_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER address_type_trigger_insert
AFTER INSERT ON address_type
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Address type created. <br/>';

    IF NEW.address_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Address Type Name: ", NEW.address_type_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('address_type', NEW.address_type_id, audit_log, NEW.last_log_by, NOW());
END //