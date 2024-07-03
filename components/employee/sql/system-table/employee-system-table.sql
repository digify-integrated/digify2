/* Employee Table */

CREATE TABLE employee (
    employee_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    employee_image VARCHAR(500),
	employee_digital_signature VARCHAR(500),
    file_as VARCHAR(1000) NOT NULL,
    first_name VARCHAR(300) NOT NULL,
	middle_name VARCHAR(300),
	last_name VARCHAR(300) NOT NULL,
	suffix VARCHAR(10),
	nickname VARCHAR(100),
	bio VARCHAR(1000),
    civil_status_id INT UNSIGNED NOT NULL,
    civil_status_name VARCHAR(100) NOT NULL,
    gender_id INT UNSIGNED NOT NULL,
    gender_name VARCHAR(100) NOT NULL,
    religion_id INT UNSIGNED,
    religion_name VARCHAR(100),
    blood_type_id INT UNSIGNED,
    blood_type_name VARCHAR(100),
    birthday DATE NOT NULL,
    birth_place VARCHAR(1000) NOT NULL,
    height FLOAT,
    weight FLOAT,
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX employee_index_employee_id ON employee(employee_id);
CREATE INDEX employee_index_civil_status_id ON employee(civil_status_id);
CREATE INDEX employee_index_gender_id ON employee(gender_id);
CREATE INDEX employee_index_religion_id ON employee(religion_id);
CREATE INDEX employee_index_blood_type_id ON employee(blood_type_id);

CREATE TABLE employment_information (
    employment_information_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    employee_id INT UNSIGNED NOT NULL,
    badge_id VARCHAR(500),
    company_id INT UNSIGNED,
    company_name VARCHAR(100),
    employee_type_id INT UNSIGNED,
    employee_type_name VARCHAR(100),
	department_id INT UNSIGNED,
    department_name VARCHAR(100),
	job_position_id INT UNSIGNED,
    job_position_name VARCHAR(100),
	manager_id INT UNSIGNED,
    manager_name VARCHAR(100),
	work_schedule_id INT UNSIGNED,
    work_schedule_name VARCHAR(100),
	employment_status VARCHAR(50) NOT NULL DEFAULT 'Active',
    kiosk_pin_code VARCHAR(500),
    biometrics_id VARCHAR(500),
    onboard_date DATE,
    offboard_date DATE,
    departure_reason_id INT UNSIGNED,
    departure_reason_name VARCHAR(100),
    detailed_departure_reason VARCHAR(5000),
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id),
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id)
);

CREATE INDEX employment_info_index_employee_id ON employment_information(employee_id);
CREATE INDEX employment_info_index_employee_type_id ON employment_information(employee_type_id);
CREATE INDEX employment_info_index_department_id ON employment_information(department_id);
CREATE INDEX employment_info_index_job_position_id ON employment_information(job_position_id);
CREATE INDEX employment_info_index_manager_id ON employment_information(manager_id);
CREATE INDEX employment_info_index_work_schedule_id ON employment_information(work_schedule_id);
CREATE INDEX employment_info_index_departure_reason_id ON employment_information(departure_reason_id);
CREATE INDEX employment_info_index_employment_status ON employment_information(employment_status);

/* ----------------------------------------------------------------------------------------------------------------------------- */