DELIMITER //

CREATE TRIGGER testimonial_trigger_update
AFTER UPDATE ON testimonial
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.testimonial_name <> OLD.testimonial_name THEN
        SET audit_log = CONCAT(audit_log, "Testimonial Name: ", OLD.testimonial_name, " -> ", NEW.testimonial_name, "<br/>");
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
        VALUES ('testimonial', NEW.testimonial_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER testimonial_trigger_insert
AFTER INSERT ON testimonial
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Testimonial created. <br/>';

    IF NEW.testimonial_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Testimonial Name: ", NEW.testimonial_name);
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
    VALUES ('testimonial', NEW.testimonial_id, audit_log, NEW.last_log_by, NOW());
END //

CREATE TRIGGER testimonial_item_trigger_update
AFTER UPDATE ON testimonial_item
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';
    
    IF NEW.testimonial_client <> OLD.testimonial_client THEN
        SET audit_log = CONCAT(audit_log, "Testimonial Client: ", OLD.testimonial_client, " -> ", NEW.testimonial_client, "<br/>");
    END IF;
    
    IF NEW.testimonial_title <> OLD.testimonial_title THEN
        SET audit_log = CONCAT(audit_log, "Testimonial Title: ", OLD.testimonial_title, " -> ", NEW.testimonial_title, "<br/>");
    END IF;
    
    IF NEW.testimonial_paragraph <> OLD.testimonial_paragraph THEN
        SET audit_log = CONCAT(audit_log, "Testimonial Paragraph: ", OLD.testimonial_paragraph, " -> ", NEW.testimonial_paragraph, "<br/>");
    END IF;
    
    IF NEW.rating <> OLD.rating THEN
        SET audit_log = CONCAT(audit_log, "Rating: ", OLD.rating, " -> ", NEW.rating, "<br/>");
    END IF;
    
    IF NEW.order_sequence <> OLD.order_sequence THEN
        SET audit_log = CONCAT(audit_log, "Order Sequence: ", OLD.order_sequence, " -> ", NEW.order_sequence, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('testimonial_item', NEW.testimonial_item_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER testimonial_item_trigger_insert
AFTER INSERT ON testimonial_item
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Testimonial item created. <br/>';

    IF NEW.testimonial_client <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Testimonial Client: ", NEW.testimonial_client);
    END IF;

    IF NEW.testimonial_title <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Testimonial Title: ", NEW.testimonial_title);
    END IF;

    IF NEW.testimonial_paragraph <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Testimonial Paragraph: ", NEW.testimonial_paragraph);
    END IF;

    IF NEW.rating <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Rating: ", NEW.rating);
    END IF;

    IF NEW.order_sequence <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Order Sequence: ", NEW.order_sequence);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('testimonial_item', NEW.testimonial_item_id, audit_log, NEW.last_log_by, NOW());
END //