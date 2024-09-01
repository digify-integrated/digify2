DELIMITER //

CREATE TRIGGER image_gallery_trigger_update
AFTER UPDATE ON image_gallery
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.image_gallery_name <> OLD.image_gallery_name THEN
        SET audit_log = CONCAT(audit_log, "Image Gallery Name: ", OLD.image_gallery_name, " -> ", NEW.image_gallery_name, "<br/>");
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
        VALUES ('image_gallery', NEW.image_gallery_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER image_gallery_trigger_insert
AFTER INSERT ON image_gallery
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Image gallery created. <br/>';

    IF NEW.image_gallery_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Image Gallery Name: ", NEW.image_gallery_name);
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
    VALUES ('image_gallery', NEW.image_gallery_id, audit_log, NEW.last_log_by, NOW());
END //

CREATE TRIGGER image_gallery_item_trigger_update
AFTER UPDATE ON image_gallery_item
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';
    
    IF NEW.image_gallery_title <> OLD.image_gallery_title THEN
        SET audit_log = CONCAT(audit_log, "Image Gallery Title: ", OLD.image_gallery_title, " -> ", NEW.image_gallery_title, "<br/>");
    END IF;
    
    IF NEW.order_sequence <> OLD.order_sequence THEN
        SET audit_log = CONCAT(audit_log, "Order Sequence: ", OLD.order_sequence, " -> ", NEW.order_sequence, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('image_gallery_item', NEW.image_gallery_item_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER image_gallery_item_trigger_insert
AFTER INSERT ON image_gallery_item
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Image gallery item created. <br/>';

    IF NEW.image_gallery_title <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Image Gallery Title: ", NEW.image_gallery_title);
    END IF;

    IF NEW.order_sequence <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Order Sequence: ", NEW.order_sequence);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('image_gallery_item', NEW.image_gallery_item_id, audit_log, NEW.last_log_by, NOW());
END //