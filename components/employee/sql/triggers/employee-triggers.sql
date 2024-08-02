DELIMITER //

CREATE TRIGGER employee_trigger_update
AFTER UPDATE ON employee
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

    IF NEW.religion_name <> OLD.religion_name THEN
        SET audit_log = CONCAT(audit_log, "Religion Name: ", OLD.religion_name, " -> ", NEW.religion_name, "<br/>");
    END IF;

    IF NEW.blood_type_name <> OLD.blood_type_name THEN
        SET audit_log = CONCAT(audit_log, "Blood Type Name: ", OLD.blood_type_name, " -> ", NEW.blood_type_name, "<br/>");
    END IF;

    IF NEW.birthday <> OLD.birthday THEN
        SET audit_log = CONCAT(audit_log, "Date of Birth: ", OLD.birthday, " -> ", NEW.birthday, "<br/>");
    END IF;

    IF NEW.birth_place <> OLD.birth_place THEN
        SET audit_log = CONCAT(audit_log, "Birth Place: ", OLD.birth_place, " -> ", NEW.birth_place, "<br/>");
    END IF;

    IF NEW.height <> OLD.height THEN
        SET audit_log = CONCAT(audit_log, "Height: ", OLD.height, " -> ", NEW.height, "<br/>");
    END IF;

    IF NEW.weight <> OLD.weight THEN
        SET audit_log = CONCAT(audit_log, "Weight: ", OLD.weight, " -> ", NEW.weight, "<br/>");
    END IF;

    IF NEW.badge_id <> OLD.badge_id THEN
        SET audit_log = CONCAT(audit_log, "Badge ID: ", OLD.badge_id, " -> ", NEW.badge_id, "<br/>");
    END IF;

    IF NEW.company_name <> OLD.company_name THEN
        SET audit_log = CONCAT(audit_log, "Company Name: ", OLD.company_name, " -> ", NEW.company_name, "<br/>");
    END IF;

    IF NEW.employment_type_name <> OLD.employment_type_name THEN
        SET audit_log = CONCAT(audit_log, "Employment Type Name: ", OLD.employment_type_name, " -> ", NEW.employment_type_name, "<br/>");
    END IF;

    IF NEW.department_name <> OLD.department_name THEN
        SET audit_log = CONCAT(audit_log, "Department Name: ", OLD.department_name, " -> ", NEW.department_name, "<br/>");
    END IF;

    IF NEW.job_position_name <> OLD.job_position_name THEN
        SET audit_log = CONCAT(audit_log, "Job Position Name: ", OLD.job_position_name, " -> ", NEW.job_position_name, "<br/>");
    END IF;

    IF NEW.manager_name <> OLD.manager_name THEN
        SET audit_log = CONCAT(audit_log, "Manager Name: ", OLD.manager_name, " -> ", NEW.manager_name, "<br/>");
    END IF;

    IF NEW.work_schedule_name <> OLD.work_schedule_name THEN
        SET audit_log = CONCAT(audit_log, "Work Schedule Name: ", OLD.work_schedule_name, " -> ", NEW.work_schedule_name, "<br/>");
    END IF;

    IF NEW.employment_status <> OLD.employment_status THEN
        SET audit_log = CONCAT(audit_log, "Employment Status: ", OLD.employment_status, " -> ", NEW.employment_status, "<br/>");
    END IF;

    IF NEW.pin_code <> OLD.pin_code THEN
        SET audit_log = CONCAT(audit_log, "PIN Code: ", OLD.pin_code, " -> ", NEW.pin_code, "<br/>");
    END IF;

    IF NEW.home_work_distance <> OLD.home_work_distance THEN
        SET audit_log = CONCAT(audit_log, "Home Work Distance: ", OLD.home_work_distance, " -> ", NEW.home_work_distance, "<br/>");
    END IF;

    IF NEW.visa_number <> OLD.visa_number THEN
        SET audit_log = CONCAT(audit_log, "Visa Number: ", OLD.visa_number, " -> ", NEW.visa_number, "<br/>");
    END IF;

    IF NEW.work_permit_number <> OLD.work_permit_number THEN
        SET audit_log = CONCAT(audit_log, "Work Permit Number: ", OLD.work_permit_number, " -> ", NEW.work_permit_number, "<br/>");
    END IF;

    IF NEW.visa_expiration_date <> OLD.visa_expiration_date THEN
        SET audit_log = CONCAT(audit_log, "Visa Expiration Date: ", OLD.visa_expiration_date, " -> ", NEW.visa_expiration_date, "<br/>");
    END IF;

    IF NEW.work_permit_expiration_date <> OLD.work_permit_expiration_date THEN
        SET audit_log = CONCAT(audit_log, "Work Permit Expiration Date: ", OLD.work_permit_expiration_date, " -> ", NEW.work_permit_expiration_date, "<br/>");
    END IF;

    IF NEW.onboard_date <> OLD.onboard_date THEN
        SET audit_log = CONCAT(audit_log, "On-Board Date: ", OLD.onboard_date, " -> ", NEW.onboard_date, "<br/>");
    END IF;

    IF NEW.offboard_date <> OLD.offboard_date THEN
        SET audit_log = CONCAT(audit_log, "Off-Board Date: ", OLD.offboard_date, " -> ", NEW.offboard_date, "<br/>");
    END IF;

    IF NEW.time_off_approver_name <> OLD.time_off_approver_name THEN
        SET audit_log = CONCAT(audit_log, "Time Off Approver Name: ", OLD.time_off_approver_name, " -> ", NEW.time_off_approver_name, "<br/>");
    END IF;

    IF NEW.departure_reason_name <> OLD.departure_reason_name THEN
        SET audit_log = CONCAT(audit_log, "Departure Reason Name: ", OLD.departure_reason_name, " -> ", NEW.departure_reason_name, "<br/>");
    END IF;

    IF NEW.detailed_departure_reason <> OLD.detailed_departure_reason THEN
        SET audit_log = CONCAT(audit_log, "Detailed Departure Reason: ", OLD.detailed_departure_reason, " -> ", NEW.detailed_departure_reason, "<br/>");
    END IF;
    
    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('employee', NEW.employee_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER employee_trigger_insert
AFTER INSERT ON employee
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Employee created. <br/>';

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

    IF NEW.religion_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Religion Name: ", NEW.religion_name);
    END IF;

    IF NEW.blood_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Blood Type Name: ", NEW.blood_type_name);
    END IF;

    IF NEW.birthday <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Date of Birth: ", NEW.birthday);
    END IF;

    IF NEW.birth_place <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Birth Place: ", NEW.birth_place);
    END IF;

    IF NEW.height <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Height: ", NEW.height);
    END IF;

    IF NEW.weight <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Weight: ", NEW.weight);
    END IF;

    IF NEW.badge_id <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Badge ID: ", NEW.badge_id);
    END IF;

    IF NEW.company_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Company Name: ", NEW.company_name);
    END IF;

    IF NEW.employment_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Employment Type Name: ", NEW.employment_type_name);
    END IF;

    IF NEW.department_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Department Name: ", NEW.department_name);
    END IF;

    IF NEW.job_position_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Job Position Name: ", NEW.job_position_name);
    END IF;

    IF NEW.manager_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Manager Name: ", NEW.manager_name);
    END IF;

    IF NEW.work_schedule_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Work Schedule Name: ", NEW.work_schedule_name);
    END IF;

    IF NEW.employment_status <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Employment Status: ", NEW.employment_status);
    END IF;

    IF NEW.pin_code <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>PIN Code: ", NEW.pin_code);
    END IF;

    IF NEW.home_work_distance <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Home Work Distance: ", NEW.home_work_distance);
    END IF;

    IF NEW.visa_number <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Visa Number: ", NEW.visa_number);
    END IF;

    IF NEW.work_permit_number <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Work Permit Number: ", NEW.work_permit_number);
    END IF;

    IF NEW.visa_expiration_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Visa Expiration Date: ", NEW.visa_expiration_date);
    END IF;

    IF NEW.work_permit_expiration_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Work Permit Expiration Date: ", NEW.work_permit_expiration_date);
    END IF;

    IF NEW.onboard_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>On-Board Date: ", NEW.onboard_date);
    END IF;

    IF NEW.offboard_date <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Off-Board Date: ", NEW.offboard_date);
    END IF;

    IF NEW.time_off_approver_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Time Off Approver Name: ", NEW.time_off_approver_name);
    END IF;

    IF NEW.departure_reason_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Departure Reason Name: ", NEW.departure_reason_name);
    END IF;

    IF NEW.detailed_departure_reason <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Detailed Departure Reason: ", NEW.detailed_departure_reason);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('employee', NEW.employee_id, audit_log, NEW.last_log_by, NOW());
END //

CREATE TRIGGER employee_experience_trigger_update
AFTER UPDATE ON employee_experience
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.job_title <> OLD.job_title THEN
        SET audit_log = CONCAT(audit_log, "Job Title: ", OLD.job_title, " -> ", NEW.job_title, "<br/>");
    END IF;

    IF NEW.employment_type_name <> OLD.employment_type_name THEN
        SET audit_log = CONCAT(audit_log, "Employment Type Name: ", OLD.employment_type_name, " -> ", NEW.employment_type_name, "<br/>");
    END IF;

    IF NEW.company_name <> OLD.company_name THEN
        SET audit_log = CONCAT(audit_log, "Company Name: ", OLD.company_name, " -> ", NEW.company_name, "<br/>");
    END IF;

    IF NEW.location <> OLD.location THEN
        SET audit_log = CONCAT(audit_log, "Location: ", OLD.location, " -> ", NEW.location, "<br/>");
    END IF;

    IF NEW.employment_location_type_name <> OLD.employment_location_type_name THEN
        SET audit_log = CONCAT(audit_log, "Employment Location Type Name: ", OLD.employment_location_type_name, " -> ", NEW.employment_location_type_name, "<br/>");
    END IF;

    IF NEW.start_month <> OLD.start_month THEN
        SET audit_log = CONCAT(audit_log, "Start Month: ", OLD.start_month, " -> ", NEW.start_month, "<br/>");
    END IF;

    IF NEW.start_year <> OLD.start_year THEN
        SET audit_log = CONCAT(audit_log, "Start Year: ", OLD.start_year, " -> ", NEW.start_year, "<br/>");
    END IF;

    IF NEW.end_month <> OLD.end_month THEN
        SET audit_log = CONCAT(audit_log, "End Month: ", OLD.end_month, " -> ", NEW.end_month, "<br/>");
    END IF;

    IF NEW.end_year <> OLD.end_year THEN
        SET audit_log = CONCAT(audit_log, "End Year: ", OLD.end_year, " -> ", NEW.end_year, "<br/>");
    END IF;

    IF NEW.job_description <> OLD.job_description THEN
        SET audit_log = CONCAT(audit_log, "Job Description: ", OLD.job_description, " -> ", NEW.job_description, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('employee_experience', NEW.employee_experience_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER employee_experience_trigger_insert
AFTER INSERT ON employee_experience
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Employee experience created. <br/>';

    IF NEW.job_title <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Job Title: ", NEW.job_title);
    END IF;

    IF NEW.employment_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Employment Type Name: ", NEW.employment_type_name);
    END IF;

    IF NEW.company_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Company Name: ", NEW.company_name);
    END IF;

    IF NEW.location <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Location: ", NEW.location);
    END IF;

    IF NEW.employment_location_type_name <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Employment Location Type Name: ", NEW.employment_location_type_name);
    END IF;

    IF NEW.start_month <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Start Month: ", NEW.start_month);
    END IF;

    IF NEW.start_year <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Start Year: ", NEW.start_year);
    END IF;

    IF NEW.end_month <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>End Month: ", NEW.end_month);
    END IF;

    IF NEW.end_year <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>End Year: ", NEW.end_year);
    END IF;

    IF NEW.job_description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Job Description: ", NEW.job_description);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('employee_experience', NEW.employee_experience_id, audit_log, NEW.last_log_by, NOW());
END //

CREATE TRIGGER employee_education_trigger_update
AFTER UPDATE ON employee_education
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT '';

    IF NEW.school <> OLD.school THEN
        SET audit_log = CONCAT(audit_log, "School: ", OLD.school, " -> ", NEW.school, "<br/>");
    END IF;

    IF NEW.degree <> OLD.degree THEN
        SET audit_log = CONCAT(audit_log, "Degree: ", OLD.degree, " -> ", NEW.degree, "<br/>");
    END IF;

    IF NEW.field_of_study <> OLD.field_of_study THEN
        SET audit_log = CONCAT(audit_log, "Field of Study: ", OLD.field_of_study, " -> ", NEW.field_of_study, "<br/>");
    END IF;

    IF NEW.start_month <> OLD.start_month THEN
        SET audit_log = CONCAT(audit_log, "Start Month: ", OLD.start_month, " -> ", NEW.start_month, "<br/>");
    END IF;

    IF NEW.start_year <> OLD.start_year THEN
        SET audit_log = CONCAT(audit_log, "Start Year: ", OLD.start_year, " -> ", NEW.start_year, "<br/>");
    END IF;

    IF NEW.end_month <> OLD.end_month THEN
        SET audit_log = CONCAT(audit_log, "End Month: ", OLD.end_month, " -> ", NEW.end_month, "<br/>");
    END IF;

    IF NEW.end_year <> OLD.end_year THEN
        SET audit_log = CONCAT(audit_log, "End Year: ", OLD.end_year, " -> ", NEW.end_year, "<br/>");
    END IF;

    IF NEW.activities_societies <> OLD.activities_societies THEN
        SET audit_log = CONCAT(audit_log, "Activities and Societies: ", OLD.activities_societies, " -> ", NEW.activities_societies, "<br/>");
    END IF;

    IF NEW.education_description <> OLD.education_description THEN
        SET audit_log = CONCAT(audit_log, "Description: ", OLD.education_description, " -> ", NEW.education_description, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('employee_education', NEW.employee_education_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER employee_education_trigger_insert
AFTER INSERT ON employee_education
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Employee education created. <br/>';

    IF NEW.school <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>School: ", NEW.school);
    END IF;

    IF NEW.degree <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Degree: ", NEW.degree);
    END IF;

    IF NEW.field_of_study <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Field of Study: ", NEW.field_of_study);
    END IF;

    IF NEW.start_month <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Start Month: ", NEW.start_month);
    END IF;

    IF NEW.start_year <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Start Year: ", NEW.start_year);
    END IF;

    IF NEW.end_month <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>End Month: ", NEW.end_month);
    END IF;

    IF NEW.end_year <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>End Year: ", NEW.end_year);
    END IF;

    IF NEW.activities_societies <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Activities and Societies: ", NEW.activities_societies);
    END IF;

    IF NEW.education_description <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Description: ", NEW.education_description);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('employee_education', NEW.employee_education_id, audit_log, NEW.last_log_by, NOW());
END //

CREATE TRIGGER employee_address_trigger_update
AFTER UPDATE ON employee_address
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

    IF NEW.default_address <> OLD.default_address THEN
        SET audit_log = CONCAT(audit_log, "Default Address: ", OLD.default_address, " -> ", NEW.default_address, "<br/>");
    END IF;

    IF LENGTH(audit_log) > 0 THEN
        INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
        VALUES ('employee_address', NEW.employee_address_id, audit_log, NEW.last_log_by, NOW());
    END IF;
END //

CREATE TRIGGER employee_address_trigger_insert
AFTER INSERT ON employee_address
FOR EACH ROW
BEGIN
    DECLARE audit_log TEXT DEFAULT 'Employee address created. <br/>';

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

    IF NEW.default_address <> '' THEN
        SET audit_log = CONCAT(audit_log, "<br/>Default Address: ", NEW.default_address);
    END IF;

    INSERT INTO audit_log (table_name, reference_id, log, changed_by, changed_at) 
    VALUES ('employee_address', NEW.employee_address_id, audit_log, NEW.last_log_by, NOW());
END //