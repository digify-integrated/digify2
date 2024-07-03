DELIMITER //

CREATE TRIGGER educational_stage_trigger_update
AFTER UPDATE ON educational_stage
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.educational_stage_name <> OLD.educational_stage_name THEN
        SET audit_log = CONCAT(audit_log, "Educational Stage Name: ", OLD.educational_stage_name, " -> ", NEW.educational_stage_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('educational_stage', NEW.educational_stage_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER educational_stage_trigger_insert
AFTER INSERT ON educational_stage
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Educational stage created. <br/>';

    IF NEW.educational_stage_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Educational Stage Name: ", NEW.educational_stage_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('educational_stage', NEW.educational_stage_id, audit_log, NEW.last_log_by, NOW());
END //