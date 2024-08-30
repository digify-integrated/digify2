DELIMITER //

CREATE TRIGGER content_carousel_trigger_update
AFTER UPDATE ON content_carousel
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.content_carousel_name <> OLD.content_carousel_name THEN
        SET audit_log = CONCAT(audit_log, "Content Carousel Name: ", OLD.content_carousel_name, " -> ", NEW.content_carousel_name, "<br/>");
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
        VALUES ('content_carousel', NEW.content_carousel_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER content_carousel_trigger_insert
AFTER INSERT ON content_carousel
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Content carousel created. <br/>';

    IF NEW.content_carousel_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Content Carousel Name: ", NEW.content_carousel_name);
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
    VALUES ('content_carousel', NEW.content_carousel_id, audit_log, NEW.last_log_by, NOW());
END //

CREATE TRIGGER content_carousel_item_trigger_update
AFTER UPDATE ON content_carousel_item
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';
    
    IF NEW.content_carousel_title <> OLD.content_carousel_title THEN
        SET audit_log = CONCAT(audit_log, "Content Carousel Title: ", OLD.content_carousel_title, " -> ", NEW.content_carousel_title, "<br/>");
    END IF;
    
    IF NEW.content_carousel_heading <> OLD.content_carousel_heading THEN
        SET audit_log = CONCAT(audit_log, "Content Carousel Heading: ", OLD.content_carousel_heading, " -> ", NEW.content_carousel_heading, "<br/>");
    END IF;
    
    IF NEW.content_carousel_paragraph <> OLD.content_carousel_paragraph THEN
        SET audit_log = CONCAT(audit_log, "Content Carousel Paragraph: ", OLD.content_carousel_paragraph, " -> ", NEW.content_carousel_paragraph, "<br/>");
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
        VALUES ('content_carousel_item', NEW.content_carousel_item_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER content_carousel_item_trigger_insert
AFTER INSERT ON content_carousel_item
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Content carousel item created. <br/>';

    IF NEW.content_carousel_title <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Content Carousel Title: ", NEW.content_carousel_title);
    END IF;

    IF NEW.content_carousel_heading <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Content Carousel Heading: ", NEW.content_carousel_heading);
    END IF;

    IF NEW.content_carousel_paragraph <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Content Carousel Paragraph: ", NEW.content_carousel_paragraph);
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
    VALUES ('content_carousel_item', NEW.content_carousel_item_id, audit_log, NEW.last_log_by, NOW());
END //