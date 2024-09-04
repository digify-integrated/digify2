DELIMITER //

CREATE TRIGGER customer_inquiry_trigger_update
AFTER UPDATE ON customer_inquiry
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.customer_name <> OLD.customer_name THEN
        SET audit_log = CONCAT(audit_log, "Customer Name: ", OLD.customer_name, " -> ", NEW.customer_name, "<br/>");
    END IF;

    IF NEW.email <> OLD.email THEN
        SET audit_log = CONCAT(audit_log, "Email: ", OLD.email, " -> ", NEW.email, "<br/>");
    END IF;

    IF NEW.phone <> OLD.phone THEN
        SET audit_log = CONCAT(audit_log, "Phone: ", OLD.phone, " -> ", NEW.phone, "<br/>");
    END IF;

    IF NEW.subject <> OLD.subject THEN
        SET audit_log = CONCAT(audit_log, "Subject: ", OLD.subject, " -> ", NEW.subject, "<br/>");
    END IF;

    IF NEW.message <> OLD.message THEN
        SET audit_log = CONCAT(audit_log, "Message: ", OLD.message, " -> ", NEW.message, "<br/>");
    END IF;

    IF NEW.inquiry_status <> OLD.inquiry_status THEN
        SET audit_log = CONCAT(audit_log, "Inquiry Status: ", OLD.inquiry_status, " -> ", NEW.inquiry_status, "<br/>");
    END IF;

    IF NEW.in_progress_date <> OLD.in_progress_date THEN
        SET audit_log = CONCAT(audit_log, "In-Progress Date: ", OLD.in_progress_date, " -> ", NEW.in_progress_date, "<br/>");
    END IF;

    IF NEW.resolved_date <> OLD.resolved_date THEN
        SET audit_log = CONCAT(audit_log, "Resolved Date: ", OLD.resolved_date, " -> ", NEW.resolved_date, "<br/>");
    END IF;

    IF NEW.closed_date <> OLD.closed_date THEN
        SET audit_log = CONCAT(audit_log, "Closed Date: ", OLD.closed_date, " -> ", NEW.closed_date, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('customer_inquiry', NEW.customer_inquiry_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER customer_inquiry_trigger_insert
AFTER INSERT ON customer_inquiry
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Customer inquiry created. <br/>';

    IF NEW.customer_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Customer Inquiry Name: ", NEW.customer_name);
    END IF;

    IF NEW.email <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Email: ", NEW.email);
    END IF;

    IF NEW.phone <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Phone: ", NEW.phone);
    END IF;

    IF NEW.subject <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Subject: ", NEW.subject);
    END IF;

    IF NEW.message <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Message: ", NEW.message);
    END IF;

    IF NEW.inquiry_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Inquiry Status: ", NEW.inquiry_status);
    END IF;

    IF NEW.in_progress_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>In-Progress Date: ", NEW.in_progress_date);
    END IF;

    IF NEW.resolved_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Resolved Date: ", NEW.resolved_date);
    END IF;

    IF NEW.closed_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Closed Date: ", NEW.closed_date);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('customer_inquiry', NEW.customer_inquiry_id, audit_log, NEW.last_log_by, NOW());
END //