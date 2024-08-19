/* Customer Table */

CREATE TABLE customer (
    customer_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    customer_image VARCHAR(500),
	customer_digital_signature VARCHAR(500),
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
    birthday DATE,
    birth_place VARCHAR(1000),
	customer_status VARCHAR(50) NOT NULL DEFAULT 'Active',
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX customer_index_customer_id ON customer(customer_id);
CREATE INDEX customer_index_civil_status_id ON customer(civil_status_id);
CREATE INDEX customer_index_gender_id ON customer(gender_id);
CREATE INDEX customer_index_customer_status ON customer(customer_status);

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Customer Address Table */

CREATE TABLE customer_address (
    customer_address_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    customer_id INT UNSIGNED NOT NULL,
    address_type_id INT UNSIGNED NOT NULL,
    address_type_name VARCHAR(100) NOT NULL,
    address VARCHAR(1000),
    city_id INT UNSIGNED NOT NULL,
    city_name VARCHAR(100) NOT NULL,
    state_id INT UNSIGNED NOT NULL,
    state_name VARCHAR(100) NOT NULL,
    country_id INT UNSIGNED NOT NULL,
    country_name VARCHAR(100) NOT NULL,
    telephone VARCHAR(50),
    mobile VARCHAR(50),
    email VARCHAR(200),
    default_address VARCHAR(10) NOT NULL DEFAULT 'Primary',
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX customer_address_index_customer_address_id ON customer_address(customer_address_id);
CREATE INDEX customer_address_index_customer_id ON customer_address(customer_id);
CREATE INDEX customer_address_index_address_type_id ON customer_address(address_type_id);
CREATE INDEX customer_address_index_city_id ON customer_address(city_id);
CREATE INDEX customer_address_index_state_id ON customer_address(state_id);
CREATE INDEX customer_address_index_country_id ON customer_address(country_id);
CREATE INDEX customer_address_index_default_address ON customer_address(default_address);

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Customer Bank Card Table */

CREATE TABLE customer_bank_card (
    customer_bank_card_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    customer_id INT UNSIGNED NOT NULL,
    name_on_card VARCHAR(1000) NOT NULL,
    card_number VARCHAR(50) NOT NULL,
    expiry_date VARCHAR(10) NOT NULL,
    cvv VARCHAR(5) NOT NULL,
    default_card VARCHAR(10) NOT NULL DEFAULT 'Primary',
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX customer_bank_card_index_customer_bank_card_id ON customer_bank_card(customer_bank_card_id);
CREATE INDEX customer_bank_card_index_default_card ON customer_bank_card(default_card);

/* ----------------------------------------------------------------------------------------------------------------------------- */

/* Customer ID Record Table */

CREATE TABLE customer_id_record (
    customer_id_record_id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY NOT NULL,
    customer_id INT UNSIGNED NOT NULL,
    id_type_id INT UNSIGNED NOT NULL,
    id_type_name VARCHAR(100) NOT NULL,
    id_number VARCHAR(100) NOT NULL,
    issue_date DATE NOT NULL,
    expiration_date DATE,
    issuing_authority VARCHAR(100),
    id_image VARCHAR(500),
    created_date DATETIME NOT NULL DEFAULT NOW(),
    last_log_by INT UNSIGNED NOT NULL,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id),
    FOREIGN KEY (last_log_by) REFERENCES user_account(user_account_id)
);

CREATE INDEX customer_id_record_index_id_record_id ON customer_id_record(customer_id_record_id);
CREATE INDEX customer_id_record_index_customer_id ON customer_id_record(customer_id);
CREATE INDEX customer_id_record_index_id_type_id ON customer_id_record(id_type_id);

/* ----------------------------------------------------------------------------------------------------------------------------- */