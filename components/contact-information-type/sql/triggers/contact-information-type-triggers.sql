DELIMITER //

CREATE TRIGGER contact_information_type_trigger_update
AFTER UPDATE ON contact_information_type
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.contact_information_type_name <> OLD.contact_information_type_name THEN
        SET audit_log = CONCAT(audit_log, "Contact Information Type Name: ", OLD.contact_information_type_name, " -> ", NEW.contact_information_type_name, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('contact_information_type', NEW.contact_information_type_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER contact_information_type_trigger_insert
AFTER INSERT ON contact_information_type
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Contact information type created. <br/>';

    IF NEW.contact_information_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Contact Information Type Name: ", NEW.contact_information_type_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('contact_information_type', NEW.contact_information_type_id, audit_log, NEW.last_log_by, NOW());
END //