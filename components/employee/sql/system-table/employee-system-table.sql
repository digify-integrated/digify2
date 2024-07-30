/* Employee Table */

CREATE TABLE employee (
    employee_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    employee_image VARCHAR(500),
	employee_digital_signature VARCHAR(500),
    full_name VARCHAR(1000) NOT NULL,
    first_name VARCHAR(300) NOT NULL,
	middle_name VARCHAR(300),
	last_name VARCHAR(300) NOT NULL,
	suffix VARCHAR(10),
	about VARCHAR(500) DEFAULT 'No about found.',
	nickname VARCHAR(100),
    civil_status_id INT UNSIGNED,
    civil_status_name VARCHAR(100),
    gender_id INT UNSIGNED,
    gender_name VARCHAR(100),
    religion_id INT UNSIGNED,
    religion_name VARCHAR(100),
    blood_type_id INT UNSIGNED,
    blood_type_name VARCHAR(100),
    birthday DATE,
    birth_place VARCHAR(1000),
    height FLOAT,
    weight FLOAT,
    badge_id VARCHAR(200),
    company_id INT UNSIGNED,
    company_name VARCHAR(100),
    employment_type_id INT UNSIGNED,
    employment_type_name VARCHAR(100),
	department_id INT UNSIGNED,
    department_name VARCHAR(100),
	job_position_id INT UNSIGNED,
    job_position_name VARCHAR(100),
	work_location_id INT UNSIGNED,
    work_location_name VARCHAR(100),
	manager_id INT UNSIGNED,
    manager_name VARCHAR(300),
	work_schedule_id INT UNSIGNED,
    work_schedule_name VARCHAR(100),
	employment_status VARCHAR(50) NOT NULL DEFAULT 'Active',
    pin_code VARCHAR(500),
    home_work_distance DOUBLE,
    visa_number VARCHAR(50),
    work_permit_number VARCHAR(50),
    visa_expiration_date DATE,
    work_permit_expiration_date DATE,
    work_permit VARCHAR(500),
    onboard_date DATE,
    offboard_date DATE,
	time_off_approver_id INT UNSIGNED,
    time_off_approver_name VARCHAR(300),
    departure_reason_id INT UNSIGNED,
    departure_reason_name VARCHAR(100),
    detailed_departure_reason VARCHAR(5000),
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX employee_index_employee_id ON employee(employee_id);
CREATE INDEX employee_index_civil_status_id ON employee(civil_status_id);
CREATE INDEX employee_index_gender_id ON employee(gender_id);
CREATE INDEX employee_index_religion_id ON employee(religion_id);
CREATE INDEX employee_index_blood_type_id ON employee(blood_type_id);
CREATE INDEX employee_index_employment_type_id ON employee(employment_type_id);
CREATE INDEX employee_index_department_id ON employee(department_id);
CREATE INDEX employee_index_job_position_id ON employee(job_position_id);
CREATE INDEX employee_index_manager_id ON employee(manager_id);
CREATE INDEX employee_index_work_schedule_id ON employee(work_schedule_id);
CREATE INDEX employee_index_work_location_id ON employee(work_location_id);
CREATE INDEX employee_index_departure_reason_id ON employee(departure_reason_id);
CREATE INDEX employee_index_employment_status ON employee(employment_status);

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Employee Experience Table */

CREATE TABLE employee_experience (
    employee_experience_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    employee_id INT UNSIGNED NOT NULL,
    job_title VARCHAR(100) NOT NULL,
    employment_type_id INT UNSIGNED,
    employment_type_name VARCHAR(100),
    company_name VARCHAR(200) NOT NULL,
    location VARCHAR(200),
    location_type_id INT UNSIGNED,
    location_type_name VARCHAR(100),
    start_month VARCHAR(20),
    start_year VARCHAR(20),
    end_month VARCHAR(20),
    end_year VARCHAR(20),
    job_description VARCHAR(5000),
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (employee_id) REFERENCES employee(employee_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX employee_experience_index_employee_experience_id ON employee_experience(employee_experience_id);
CREATE INDEX employee_experience_index_employee_employee_id ON employee_experience(employee_id);
CREATE INDEX employee_experience_index_employee_employment_type_id ON employee_experience(employment_type_id);
CREATE INDEX employee_experience_index_employee_location_type_id ON employee_experience(location_type_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */