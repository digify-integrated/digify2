DELIMITER //

CREATE TRIGGER customer_trigger_update
AFTER UPDATE ON customer
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.full_name <> OLD.full_name THEN
        SET audit_log = CONCAT(audit_log, "Full Name: ", OLD.full_name, " -> ", NEW.full_name, "<br/>");
    END IF;

    IF NEW.first_name <> OLD.first_name THEN
        SET audit_log = CONCAT(audit_log, "First Name: ", OLD.first_name, " -> ", NEW.first_name, "<br/>");
    END IF;

    IF NEW.middle_name <> OLD.middle_name THEN
        SET audit_log = CONCAT(audit_log, "Middle Name: ", OLD.middle_name, " -> ", NEW.middle_name, "<br/>");
    END IF;

    IF NEW.last_name <> OLD.last_name THEN
        SET audit_log = CONCAT(audit_log, "Last Name: ", OLD.last_name, " -> ", NEW.last_name, "<br/>");
    END IF;

    IF NEW.suffix <> OLD.suffix THEN
        SET audit_log = CONCAT(audit_log, "Suffix: ", OLD.suffix, " -> ", NEW.suffix, "<br/>");
    END IF;

    IF NEW.about <> OLD.about THEN
        SET audit_log = CONCAT(audit_log, "About: ", OLD.about, " -> ", NEW.about, "<br/>");
    END IF;

    IF NEW.nickname <> OLD.nickname THEN
        SET audit_log = CONCAT(audit_log, "Nickname: ", OLD.nickname, " -> ", NEW.nickname, "<br/>");
    END IF;

    IF NEW.civil_status_name <> OLD.civil_status_name THEN
        SET audit_log = CONCAT(audit_log, "Civil Status Name: ", OLD.civil_status_name, " -> ", NEW.civil_status_name, "<br/>");
    END IF;

    IF NEW.gender_name <> OLD.gender_name THEN
        SET audit_log = CONCAT(audit_log, "Gender Name: ", OLD.gender_name, " -> ", NEW.gender_name, "<br/>");
    END IF;

    IF NEW.birthday <> OLD.birthday THEN
        SET audit_log = CONCAT(audit_log, "Date of Birth: ", OLD.birthday, " -> ", NEW.birthday, "<br/>");
    END IF;

    IF NEW.birth_place <> OLD.birth_place THEN
        SET audit_log = CONCAT(audit_log, "Birth Place: ", OLD.birth_place, " -> ", NEW.birth_place, "<br/>");
    END IF;

    IF NEW.customer_status <> OLD.customer_status THEN
        SET audit_log = CONCAT(audit_log, "Customer Status: ", OLD.customer_status, " -> ", NEW.customer_status, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('customer', NEW.customer_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER customer_trigger_insert
AFTER INSERT ON customer
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Customer created. <br/>';

    IF NEW.full_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Full Name: ", NEW.full_name);
    END IF;

    IF NEW.first_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>First Name: ", NEW.first_name);
    END IF;

    IF NEW.middle_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Middle Name: ", NEW.middle_name);
    END IF;

    IF NEW.last_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Last Name: ", NEW.last_name);
    END IF;

    IF NEW.suffix <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Suffix: ", NEW.suffix);
    END IF;

    IF NEW.about <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>About: ", NEW.about);
    END IF;

    IF NEW.nickname <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Nickname: ", NEW.nickname);
    END IF;

    IF NEW.civil_status_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Civil Status Name: ", NEW.civil_status_name);
    END IF;

    IF NEW.gender_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Gender Name: ", NEW.gender_name);
    END IF;

    IF NEW.birthday <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Date of Birth: ", NEW.birthday);
    END IF;

    IF NEW.birth_place <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Birth Place: ", NEW.birth_place);
    END IF;

    IF NEW.customer_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Customer Status: ", NEW.customer_status);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('customer', NEW.customer_id, audit_log, NEW.last_log_by, NOW());
END //

CREATE TRIGGER customer_address_trigger_update
AFTER UPDATE ON customer_address
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.address_type_name <> OLD.address_type_name THEN
        SET audit_log = CONCAT(audit_log, "Address Type Name: ", OLD.address_type_name, " -> ", NEW.address_type_name, "<br/>");
    END IF;

    IF NEW.address <> OLD.address THEN
        SET audit_log = CONCAT(audit_log, "Address: ", OLD.address, " -> ", NEW.address, "<br/>");
    END IF;

    IF NEW.city_name <> OLD.city_name THEN
        SET audit_log = CONCAT(audit_log, "City Name: ", OLD.city_name, " -> ", NEW.city_name, "<br/>");
    END IF;

    IF NEW.state_name <> OLD.state_name THEN
        SET audit_log = CONCAT(audit_log, "State Name: ", OLD.state_name, " -> ", NEW.state_name, "<br/>");
    END IF;

    IF NEW.country_name <> OLD.country_name THEN
        SET audit_log = CONCAT(audit_log, "Country Name: ", OLD.country_name, " -> ", NEW.country_name, "<br/>");
    END IF;

    IF NEW.telephone <> OLD.telephone THEN
        SET audit_log = CONCAT(audit_log, "Telephone: ", OLD.telephone, " -> ", NEW.telephone, "<br/>");
    END IF;

    IF NEW.mobile <> OLD.mobile THEN
        SET audit_log = CONCAT(audit_log, "Mobile: ", OLD.mobile, " -> ", NEW.mobile, "<br/>");
    END IF;

    IF NEW.email <> OLD.email THEN
        SET audit_log = CONCAT(audit_log, "Email: ", OLD.email, " -> ", NEW.email, "<br/>");
    END IF;

    IF NEW.default_address <> OLD.default_address THEN
        SET audit_log = CONCAT(audit_log, "Default Address: ", OLD.default_address, " -> ", NEW.default_address, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('customer_address', NEW.customer_address_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER customer_address_trigger_insert
AFTER INSERT ON customer_address
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Customer address created. <br/>';

    IF NEW.address_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Address Type Name: ", NEW.address_type_name);
    END IF;

    IF NEW.address <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Address: ", NEW.address);
    END IF;

    IF NEW.city_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>City Name: ", NEW.city_name);
    END IF;

    IF NEW.state_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>State Name: ", NEW.state_name);
    END IF;

    IF NEW.country_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Country Name: ", NEW.country_name);
    END IF;

    IF NEW.telephone <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Telephone: ", NEW.telephone);
    END IF;

    IF NEW.mobile <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Mobile: ", NEW.mobile);
    END IF;

    IF NEW.email <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Email: ", NEW.email);
    END IF;

    IF NEW.default_address <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Default Address: ", NEW.default_address);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('customer_address', NEW.customer_address_id, audit_log, NEW.last_log_by, NOW());
END //

CREATE TRIGGER customer_bank_card_trigger_update
AFTER UPDATE ON customer_bank_card
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.name_on_card <> OLD.name_on_card THEN
        SET audit_log = CONCAT(audit_log, "Name Of Card: ", OLD.name_on_card, " -> ", NEW.name_on_card, "<br/>");
    END IF;

    IF NEW.card_number <> OLD.card_number THEN
        SET audit_log = CONCAT(audit_log, "Card Number: ", OLD.card_number, " -> ", NEW.card_number, "<br/>");
    END IF;

    IF NEW.expiry_date <> OLD.expiry_date THEN
        SET audit_log = CONCAT(audit_log, "Expiry Date: ", OLD.expiry_date, " -> ", NEW.expiry_date, "<br/>");
    END IF;

    IF NEW.cvv <> OLD.cvv THEN
        SET audit_log = CONCAT(audit_log, "CVV: ", OLD.cvv, " -> ", NEW.cvv, "<br/>");
    END IF;

    IF NEW.default_card <> OLD.default_card THEN
        SET audit_log = CONCAT(audit_log, "Default Card: ", OLD.default_card, " -> ", NEW.default_card, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('customer_bank_card', NEW.customer_bank_card_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER customer_bank_card_trigger_insert
AFTER INSERT ON customer_bank_card
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Customer bank card created. <br/>';

    IF NEW.name_on_card <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Name On Card: ", NEW.name_on_card);
    END IF;

    IF NEW.card_number <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Card Number: ", NEW.card_number);
    END IF;

    IF NEW.expiry_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Expiry Date: ", NEW.expiry_date);
    END IF;

    IF NEW.cvv <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>CVV: ", NEW.cvv);
    END IF;

    IF NEW.default_card <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Default Card: ", NEW.default_card);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('customer_bank_card', NEW.customer_bank_card_id, audit_log, NEW.last_log_by, NOW());
END //

CREATE TRIGGER customer_id_record_trigger_update
AFTER UPDATE ON customer_id_record
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.id_type_name <> OLD.id_type_name THEN
        SET audit_log = CONCAT(audit_log, "ID Type Name: ", OLD.id_type_name, " -> ", NEW.id_type_name, "<br/>");
    END IF;

    IF NEW.id_number <> OLD.id_number THEN
        SET audit_log = CONCAT(audit_log, "ID Number: ", OLD.id_number, " -> ", NEW.id_number, "<br/>");
    END IF;

    IF NEW.issue_date <> OLD.issue_date THEN
        SET audit_log = CONCAT(audit_log, "Issue Date: ", OLD.issue_date, " -> ", NEW.issue_date, "<br/>");
    END IF;

    IF NEW.expiration_date <> OLD.expiration_date THEN
        SET audit_log = CONCAT(audit_log, "Expiration Date: ", OLD.expiration_date, " -> ", NEW.expiration_date, "<br/>");
    END IF;

    IF NEW.issuing_authority <> OLD.issuing_authority THEN
        SET audit_log = CONCAT(audit_log, "Issuing Authority: ", OLD.issuing_authority, " -> ", NEW.issuing_authority, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('customer_id_record', NEW.customer_id_record_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER customer_id_record_trigger_insert
AFTER INSERT ON customer_id_record
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Customer ID record created. <br/>';

    IF NEW.id_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>ID Type Name: ", NEW.id_type_name);
    END IF;

    IF NEW.id_number <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>ID Number: ", NEW.id_number);
    END IF;

    IF NEW.issue_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Issue Date: ", NEW.issue_date);
    END IF;

    IF NEW.expiration_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Expiration Date: ", NEW.expiration_date);
    END IF;

    IF NEW.issuing_authority <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Issuing Authority: ", NEW.issuing_authority);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('customer_id_record', NEW.customer_id_record_id, audit_log, NEW.last_log_by, NOW());
END //