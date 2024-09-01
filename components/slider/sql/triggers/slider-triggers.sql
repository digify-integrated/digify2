DELIMITER //

CREATE TRIGGER slider_trigger_update
AFTER UPDATE ON slider
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.slider_name <> OLD.slider_name THEN
        SET audit_log = CONCAT(audit_log, "Slider Name: ", OLD.slider_name, " -> ", NEW.slider_name, "<br/>");
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
        VALUES ('slider', NEW.slider_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER slider_trigger_insert
AFTER INSERT ON slider
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Slider created. <br/>';

    IF NEW.slider_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Slider Name: ", NEW.slider_name);
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
    VALUES ('slider', NEW.slider_id, audit_log, NEW.last_log_by, NOW());
END //

CREATE TRIGGER slider_item_trigger_update
AFTER UPDATE ON slider_item
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';
    
    IF NEW.slider_title <> OLD.slider_title THEN
        SET audit_log = CONCAT(audit_log, "Slider Title: ", OLD.slider_title, " -> ", NEW.slider_title, "<br/>");
    END IF;
    
    IF NEW.slider_heading <> OLD.slider_heading THEN
        SET audit_log = CONCAT(audit_log, "Slider Heading: ", OLD.slider_heading, " -> ", NEW.slider_heading, "<br/>");
    END IF;
    
    IF NEW.slider_paragraph <> OLD.slider_paragraph THEN
        SET audit_log = CONCAT(audit_log, "Slider Paragraph: ", OLD.slider_paragraph, " -> ", NEW.slider_paragraph, "<br/>");
    END IF;
    
    IF NEW.call_to_action_button_1_text <> OLD.call_to_action_button_1_text THEN
        SET audit_log = CONCAT(audit_log, "Call-to-Action Button 1 Text: ", OLD.call_to_action_button_1_text, " -> ", NEW.call_to_action_button_1_text, "<br/>");
    END IF;

    IF NEW.call_to_action_button_1_link <> OLD.call_to_action_button_1_link THEN
        SET audit_log = CONCAT(audit_log, "Call-to-Action Button 1 Link: ", OLD.call_to_action_button_1_link, " -> ", NEW.call_to_action_button_1_link, "<br/>");
    END IF;
    
    IF NEW.call_to_action_button_2_text <> OLD.call_to_action_button_2_text THEN
        SET audit_log = CONCAT(audit_log, "Call-to-Action Button 2 Text: ", OLD.call_to_action_button_2_text, " -> ", NEW.call_to_action_button_2_text, "<br/>");
    END IF;

    IF NEW.call_to_action_button_2_link <> OLD.call_to_action_button_2_link THEN
        SET audit_log = CONCAT(audit_log, "Call-to-Action Button 2 Link: ", OLD.call_to_action_button_2_link, " -> ", NEW.call_to_action_button_2_link, "<br/>");
    END IF;
    
    IF NEW.order_sequence <> OLD.order_sequence THEN
        SET audit_log = CONCAT(audit_log, "Order Sequence: ", OLD.order_sequence, " -> ", NEW.order_sequence, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('slider_item', NEW.slider_item_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER slider_item_trigger_insert
AFTER INSERT ON slider_item
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Slider item created. <br/>';

    IF NEW.slider_title <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Slider Title: ", NEW.slider_title);
    END IF;

    IF NEW.slider_heading <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Slider Heading: ", NEW.slider_heading);
    END IF;

    IF NEW.slider_paragraph <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Slider Paragraph: ", NEW.slider_paragraph);
    END IF;

    IF NEW.call_to_action_button_1_text <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Call-to-Action Button 1 Text: ", NEW.call_to_action_button_1_text);
    END IF;

    IF NEW.call_to_action_button_1_link <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Call-to-Action Button 1 Link: ", NEW.call_to_action_button_1_link);
    END IF;

    IF NEW.call_to_action_button_2_text <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Call-to-Action Button 2 Text: ", NEW.call_to_action_button_2_text);
    END IF;

    IF NEW.call_to_action_button_2_link <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Call-to-Action Button 2 Link: ", NEW.call_to_action_button_2_link);
    END IF;

    IF NEW.order_sequence <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Order Sequence: ", NEW.order_sequence);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('slider_item', NEW.slider_item_id, audit_log, NEW.last_log_by, NOW());
END //