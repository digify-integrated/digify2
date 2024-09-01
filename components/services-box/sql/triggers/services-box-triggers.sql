DELIMITER //

CREATE TRIGGER services_box_trigger_update
AFTER UPDATE ON services_box
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.services_box_name <> OLD.services_box_name THEN
        SET audit_log = CONCAT(audit_log, "Services Box Name: ", OLD.services_box_name, " -> ", NEW.services_box_name, "<br/>");
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
        VALUES ('services_box', NEW.services_box_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER services_box_trigger_insert
AFTER INSERT ON services_box
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Services box created. <br/>';

    IF NEW.services_box_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Services Box Name: ", NEW.services_box_name);
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
    VALUES ('services_box', NEW.services_box_id, audit_log, NEW.last_log_by, NOW());
END //

CREATE TRIGGER services_box_item_trigger_update
AFTER UPDATE ON services_box_item
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';
    
    IF NEW.services_box_title <> OLD.services_box_title THEN
        SET audit_log = CONCAT(audit_log, "Services Box Title: ", OLD.services_box_title, " -> ", NEW.services_box_title, "<br/>");
    END IF;
    
    IF NEW.services_box_heading <> OLD.services_box_heading THEN
        SET audit_log = CONCAT(audit_log, "Services Box Heading: ", OLD.services_box_heading, " -> ", NEW.services_box_heading, "<br/>");
    END IF;
    
    IF NEW.services_box_paragraph <> OLD.services_box_paragraph THEN
        SET audit_log = CONCAT(audit_log, "Services Box Paragraph: ", OLD.services_box_paragraph, " -> ", NEW.services_box_paragraph, "<br/>");
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
        VALUES ('services_box_item', NEW.services_box_item_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER services_box_item_trigger_insert
AFTER INSERT ON services_box_item
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Services box item created. <br/>';

    IF NEW.services_box_title <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Services Box Title: ", NEW.services_box_title);
    END IF;

    IF NEW.services_box_heading <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Services Box Heading: ", NEW.services_box_heading);
    END IF;

    IF NEW.services_box_paragraph <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Services Box Paragraph: ", NEW.services_box_paragraph);
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
    VALUES ('services_box_item', NEW.services_box_item_id, audit_log, NEW.last_log_by, NOW());
END //