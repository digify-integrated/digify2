DELIMITER //

CREATE TRIGGER security_setting_trigger_update
AFTER UPDATE ON security_setting
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.security_setting_name <> OLD.security_setting_name THEN
        SET audit_log = CONCAT(audit_log, "Security Setting Name: ", OLD.security_setting_name, " -> ", NEW.security_setting_name, "<br/>");
    END IF;

    IF NEW.security_setting_description <> OLD.security_setting_description THEN
        SET audit_log = CONCAT(audit_log, "Security Setting Description: ", OLD.security_setting_description, " -> ", NEW.security_setting_description, "<br/>");
    END IF;

    IF NEW.value <> OLD.value THEN
        SET audit_log = CONCAT(audit_log, "Value: ", OLD.value, " -> ", NEW.value, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('security_setting', NEW.security_setting_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER security_setting_trigger_insert
AFTER INSERT ON security_setting
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Security Setting created. <br/>';

    IF NEW.security_setting_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Security Setting Name: ", NEW.security_setting_name);
    END IF;

    IF NEW.security_setting_description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Security Setting Description: ", NEW.security_setting_description);
    END IF;

    IF NEW.value <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Value: ", NEW.value);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('security_setting', NEW.security_setting_id, audit_log, NEW.last_log_by, NOW());
END //