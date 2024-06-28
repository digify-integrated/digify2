DELIMITER //

CREATE TRIGGER departure_reasons_trigger_update
AFTER UPDATE ON departure_reasons
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.departure_reasons_name <> OLD.departure_reasons_name THEN
        SET audit_log = CONCAT(audit_log, "Departure Reason Name: ", OLD.departure_reasons_name, " -> ", NEW.departure_reasons_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('departure_reasons', NEW.departure_reasons_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER departure_reasons_trigger_insert
AFTER INSERT ON departure_reasons
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Departure reason created. <br/>';

    IF NEW.departure_reasons_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Departure Reason Name: ", NEW.departure_reasons_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('departure_reasons', NEW.departure_reasons_id, audit_log, NEW.last_log_by, NOW());
END //