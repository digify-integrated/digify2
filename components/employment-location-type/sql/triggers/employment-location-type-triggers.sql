DELIMITER //

CREATE TRIGGER employment_location_type_trigger_update
AFTER UPDATE ON employment_location_type
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.employment_location_type_name <> OLD.employment_location_type_name THEN
        SET audit_log = CONCAT(audit_log, "Employment Location Type Name: ", OLD.employment_location_type_name, " -> ", NEW.employment_location_type_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('employment_location_type', NEW.employment_location_type_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER employment_location_type_trigger_insert
AFTER INSERT ON employment_location_type
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Employment location type created. <br/>';

    IF NEW.employment_location_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Employment Location Type Name: ", NEW.employment_location_type_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('employment_location_type', NEW.employment_location_type_id, audit_log, NEW.last_log_by, NOW());
END //