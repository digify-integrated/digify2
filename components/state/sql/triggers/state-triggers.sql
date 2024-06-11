DELIMITER //

CREATE TRIGGER state_trigger_update
AFTER UPDATE ON state
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.state_name <> OLD.state_name THEN
        SET audit_log = CONCAT(audit_log, "State Name: ", OLD.state_name, " -> ", NEW.state_name, "<br/>");
    END IF;

    IF NEW.country_name <> OLD.country_name THEN
        SET audit_log = CONCAT(audit_log, "Country: ", OLD.country_name, " -> ", NEW.country_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('state', NEW.state_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER state_trigger_insert
AFTER INSERT ON state
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'State created. <br/>';

    IF NEW.state_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>State Name: ", NEW.state_name);
    END IF;

    IF NEW.country_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Country: ", NEW.country_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('state', NEW.state_id, audit_log, NEW.last_log_by, NOW());
END //