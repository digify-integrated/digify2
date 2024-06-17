DELIMITER //

CREATE TRIGGER app_module_trigger_update
AFTER UPDATE ON app_module
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.app_module_name <> OLD.app_module_name THEN
        SET audit_log = CONCAT(audit_log, "App Module Name: ", OLD.app_module_name, " -> ", NEW.app_module_name, "<br/>");
    END IF;

    IF NEW.app_module_description <> OLD.app_module_description THEN
        SET audit_log = CONCAT(audit_log, "App Module Description: ", OLD.app_module_description, " -> ", NEW.app_module_description, "<br/>");
    END IF;

    IF NEW.app_version <> OLD.app_version THEN
        SET audit_log = CONCAT(audit_log, "App Version: ", OLD.app_version, " -> ", NEW.app_version, "<br/>");
    END IF;

    IF NEW.menu_item_name <> OLD.menu_item_name THEN
        SET audit_log = CONCAT(audit_log, "Menu Item Name: ", OLD.menu_item_name, " -> ", NEW.menu_item_name, "<br/>");
    END IF;

    IF NEW.order_sequence <> OLD.order_sequence THEN
        SET audit_log = CONCAT(audit_log, "Order Sequence: ", OLD.order_sequence, " -> ", NEW.order_sequence, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('app_module', NEW.app_module_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER app_module_trigger_insert
AFTER INSERT ON app_module
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'App module created. <br/>';

    IF NEW.app_module_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>App Module Name: ", NEW.app_module_name);
    END IF;

    IF NEW.app_module_description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>App Module Description: ", NEW.app_module_description);
    END IF;

    IF NEW.app_version <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>App Version: ", NEW.app_version);
    END IF;

    IF NEW.menu_item_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Menu Item Name: ", NEW.menu_item_name);
    END IF;

    IF NEW.order_sequence <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Order Sequence: ", NEW.order_sequence);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('app_module', NEW.app_module_id, audit_log, NEW.last_log_by, NOW());
END //