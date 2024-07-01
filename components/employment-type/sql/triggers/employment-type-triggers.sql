DELIMITER //

CREATE TRIGGER employment_type_trigger_update
AFTER UPDATE ON employment_type
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.employment_type_name <> OLD.employment_type_name THEN
        SET audit_log = CONCAT(audit_log, "Employment Type Name: ", OLD.employment_type_name, " -> ", NEW.employment_type_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('employment_type', NEW.employment_type_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER employment_type_trigger_insert
AFTER INSERT ON employment_type
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Employment type created. <br/>';

    IF NEW.employment_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Employment Type Name: ", NEW.employment_type_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('employment_type', NEW.employment_type_id, audit_log, NEW.last_log_by, NOW());
END //