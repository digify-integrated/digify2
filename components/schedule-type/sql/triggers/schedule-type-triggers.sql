DELIMITER //

CREATE TRIGGER schedule_type_trigger_update
AFTER UPDATE ON schedule_type
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.schedule_type_name <> OLD.schedule_type_name THEN
        SET audit_log = CONCAT(audit_log, "Schedule Type Name: ", OLD.schedule_type_name, " -> ", NEW.schedule_type_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('schedule_type', NEW.schedule_type_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER schedule_type_trigger_insert
AFTER INSERT ON schedule_type
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Schedule type created. <br/>';

    IF NEW.schedule_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Schedule Type Name: ", NEW.schedule_type_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('schedule_type', NEW.schedule_type_id, audit_log, NEW.last_log_by, NOW());
END //