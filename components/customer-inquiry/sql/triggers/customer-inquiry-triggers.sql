DELIMITER //

CREATE TRIGGER customer_inquiry_trigger_update
AFTER UPDATE ON customer_inquiry
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.customer_inquiry_name <> OLD.customer_inquiry_name THEN
        SET audit_log = CONCAT(audit_log, "Customer Inquiry Name: ", OLD.customer_inquiry_name, " -> ", NEW.customer_inquiry_name, "<br/>");
    END IF;

    IF NEW.description <> OLD.description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.description, " -> ", NEW.description, "<br/>");
    END IF;

    IF NEW.block_style_name <> OLD.block_style_name THEN
        SET audit_log = CONCAT(audit_log, "Block Style Name: ", OLD.block_style_name, " -> ", NEW.block_style_name, "<br/>");
    END IF;

    IF NEW.publish_status <> OLD.publish_status THEN
        SET audit_log = CONCAT(audit_log, "Publish Status: ", OLD.publish_status, " -> ", NEW.publish_status, "<br/>");
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
    DECLARE audit_log TEXT DEFAULT 'Services box created. <br/>';

    IF NEW.customer_inquiry_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Customer Inquiry Name: ", NEW.customer_inquiry_name);
    END IF;

    IF NEW.description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.description);
    END IF;

    IF NEW.block_style_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Block Style Name: ", NEW.block_style_name);
    END IF;

    IF NEW.publish_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Publish Status: ", NEW.publish_status);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('customer_inquiry', NEW.customer_inquiry_id, audit_log, NEW.last_log_by, NOW());
END //

CREATE TRIGGER customer_inquiry_item_trigger_update
AFTER UPDATE ON customer_inquiry_item
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';
    
    IF NEW.customer_inquiry_title <> OLD.customer_inquiry_title THEN
        SET audit_log = CONCAT(audit_log, "Customer Inquiry Title: ", OLD.customer_inquiry_title, " -> ", NEW.customer_inquiry_title, "<br/>");
    END IF;
    
    IF NEW.customer_inquiry_heading <> OLD.customer_inquiry_heading THEN
        SET audit_log = CONCAT(audit_log, "Customer Inquiry Heading: ", OLD.customer_inquiry_heading, " -> ", NEW.customer_inquiry_heading, "<br/>");
    END IF;
    
    IF NEW.customer_inquiry_paragraph <> OLD.customer_inquiry_paragraph THEN
        SET audit_log = CONCAT(audit_log, "Customer Inquiry Paragraph: ", OLD.customer_inquiry_paragraph, " -> ", NEW.customer_inquiry_paragraph, "<br/>");
    END IF;
    
    IF NEW.call_to_action_button_text <> OLD.call_to_action_button_text THEN
        SET audit_log = CONCAT(audit_log, "Call-to-Action Button Text: ", OLD.call_to_action_button_text, " -> ", NEW.call_to_action_button_text, "<br/>");
    END IF;

    IF NEW.call_to_action_button_link <> OLD.call_to_action_button_link THEN
        SET audit_log = CONCAT(audit_log, "Call-to-Action Button Link: ", OLD.call_to_action_button_link, " -> ", NEW.call_to_action_button_link, "<br/>");
    END IF;
    
    IF NEW.order_sequence <> OLD.order_sequence THEN
        SET audit_log = CONCAT(audit_log, "Order Sequence: ", OLD.order_sequence, " -> ", NEW.order_sequence, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('customer_inquiry_item', NEW.customer_inquiry_item_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER customer_inquiry_item_trigger_insert
AFTER INSERT ON customer_inquiry_item
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Services box item created. <br/>';

    IF NEW.customer_inquiry_title <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Customer Inquiry Title: ", NEW.customer_inquiry_title);
    END IF;

    IF NEW.customer_inquiry_heading <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Customer Inquiry Heading: ", NEW.customer_inquiry_heading);
    END IF;

    IF NEW.customer_inquiry_paragraph <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Customer Inquiry Paragraph: ", NEW.customer_inquiry_paragraph);
    END IF;

    IF NEW.call_to_action_button_text <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Call-to-Action Button Text: ", NEW.call_to_action_button_text);
    END IF;

    IF NEW.call_to_action_button_link <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Call-to-Action Button Link: ", NEW.call_to_action_button_link);
    END IF;

    IF NEW.order_sequence <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Order Sequence: ", NEW.order_sequence);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('customer_inquiry_item', NEW.customer_inquiry_item_id, audit_log, NEW.last_log_by, NOW());
END //