DELIMITER //

CREATE TRIGGER work_schedule_trigger_update
AFTER UPDATE ON work_schedule
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.work_schedule_name <> OLD.work_schedule_name THEN
        SET audit_log = CONCAT(audit_log, "Work Schedule Name: ", OLD.work_schedule_name, " -> ", NEW.work_schedule_name, "<br/>");
    END IF;

    IF NEW.schedule_type_name <> OLD.schedule_type_name THEN
        SET audit_log = CONCAT(audit_log, "Schedule Type Name: ", OLD.schedule_type_name, " -> ", NEW.schedule_type_name, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('work_schedule', NEW.work_schedule_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER work_schedule_trigger_insert
AFTER INSERT ON work_schedule
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Work schedule created. <br/>';

    IF NEW.work_schedule_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Work Schedule Name: ", NEW.work_schedule_name);
    END IF;

    IF NEW.schedule_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Schedule Type Name: ", NEW.schedule_type_name);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('work_schedule', NEW.work_schedule_id, audit_log, NEW.last_log_by, NOW());
END //

CREATE TRIGGER work_hours_trigger_update
AFTER UPDATE ON work_hours
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.day_of_week <> OLD.day_of_week THEN
        SET audit_log = CONCAT(audit_log, "Day of Week: ", OLD.day_of_week, " -> ", NEW.day_of_week, "<br/>");
    END IF;

    IF NEW.day_period <> OLD.day_period THEN
        SET audit_log = CONCAT(audit_log, "Day Period: ", OLD.day_period, " -> ", NEW.day_period, "<br/>");
    END IF;

    IF NEW.start_time <> OLD.start_time THEN
        SET audit_log = CONCAT(audit_log, "Start Time: ", OLD.start_time, " -> ", NEW.start_time, "<br/>");
    END IF;

    IF NEW.end_time <> OLD.end_time THEN
        SET audit_log = CONCAT(audit_log, "End Time: ", OLD.end_time, " -> ", NEW.end_time, "<br/>");
    END IF;

    IF NEW.notes <> OLD.notes THEN
        SET audit_log = CONCAT(audit_log, "Notes: ", OLD.notes, " -> ", NEW.notes, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('work_hours', NEW.work_hours_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER work_hours_trigger_insert
AFTER INSERT ON work_hours
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Work hours created. <br/>';

    IF NEW.day_of_week <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Day of Week: ", NEW.day_of_week);
    END IF;

    IF NEW.day_period <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Day Period: ", NEW.day_period);
    END IF;

    IF NEW.start_time <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Start Time: ", NEW.start_time);
    END IF;

    IF NEW.end_time <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>End Time: ", NEW.end_time);
    END IF;

    IF NEW.notes <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Notes: ", NEW.notes);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('work_hours', NEW.work_hours_id, audit_log, NEW.last_log_by, NOW());
END //