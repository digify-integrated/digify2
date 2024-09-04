DELIMITER //

CREATE TRIGGER voucher_trigger_update
AFTER UPDATE ON voucher
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.voucher_name <> OLD.voucher_name THEN
        SET audit_log = CONCAT(audit_log, "Voucher Name: ", OLD.voucher_name, " -> ", NEW.voucher_name, "<br/>");
    END IF;

    IF NEW.voucher_code <> OLD.voucher_code THEN
        SET audit_log = CONCAT(audit_log, "Voucher Code: ", OLD.voucher_code, " -> ", NEW.voucher_code, "<br/>");
    END IF;

    IF NEW.voucher_usage_start_date <> OLD.voucher_usage_start_date THEN
        SET audit_log = CONCAT(audit_log, "Voucher Usage Start Date: ", OLD.voucher_usage_start_date, " -> ", NEW.voucher_usage_start_date, "<br/>");
    END IF;

    IF NEW.voucher_usage_end_date <> OLD.voucher_usage_end_date THEN
        SET audit_log = CONCAT(audit_log, "Voucher Usage End Date: ", OLD.voucher_usage_end_date, " -> ", NEW.voucher_usage_end_date, "<br/>");
    END IF;

    IF NEW.discount_type <> OLD.discount_type THEN
        SET audit_log = CONCAT(audit_log, "Discount Type: ", OLD.discount_type, " -> ", NEW.discount_type, "<br/>");
    END IF;

    IF NEW.discount_amount <> OLD.discount_amount THEN
        SET audit_log = CONCAT(audit_log, "Discount Amount: ", OLD.discount_amount, " -> ", NEW.discount_amount, "<br/>");
    END IF;

    IF NEW.minimum_booking_amount <> OLD.minimum_booking_amount THEN
        SET audit_log = CONCAT(audit_log, "Minimum Booking Amount: ", OLD.minimum_booking_amount, " -> ", NEW.minimum_booking_amount, "<br/>");
    END IF;

    IF NEW.voucher_quantity <> OLD.voucher_quantity THEN
        SET audit_log = CONCAT(audit_log, "Voucher Quantity: ", OLD.voucher_quantity, " -> ", NEW.voucher_quantity, "<br/>");
    END IF;

    IF NEW.available_voucher <> OLD.available_voucher THEN
        SET audit_log = CONCAT(audit_log, "Available Voucher: ", OLD.available_voucher, " -> ", NEW.available_voucher, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('voucher', NEW.voucher_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER voucher_trigger_insert
AFTER INSERT ON voucher
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Voucher created. <br/>';

    IF NEW.voucher_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Voucher Name: ", NEW.voucher_name);
    END IF;

    IF NEW.voucher_code <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.voucher_code);
    END IF;

    IF NEW.voucher_usage_start_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Voucher Usage Start Date: ", NEW.voucher_usage_start_date);
    END IF;

    IF NEW.voucher_usage_end_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Voucher Usage End Date: ", NEW.voucher_usage_end_date);
    END IF;

    IF NEW.discount_type <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Discount Type: ", NEW.discount_type);
    END IF;

    IF NEW.discount_amount <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Discount Amount: ", NEW.discount_amount);
    END IF;

    IF NEW.minimum_booking_amount <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Minimum Booking Amount: ", NEW.minimum_booking_amount);
    END IF;

    IF NEW.voucher_quantity <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Voucher Quantity: ", NEW.voucher_quantity);
    END IF;

    IF NEW.available_voucher <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Available Voucher: ", NEW.available_voucher);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('voucher', NEW.voucher_id, audit_log, NEW.last_log_by, NOW());
END //